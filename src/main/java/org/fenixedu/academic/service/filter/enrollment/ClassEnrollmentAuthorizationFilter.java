package org.fenixedu.academic.service.filter.enrollment;

import java.util.Optional;
import java.util.SortedSet;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.function.Predicate;

import org.fenixedu.academic.domain.DegreeCurricularPlan;
import org.fenixedu.academic.domain.DegreeCurricularPlanEquivalencePlan;
import org.fenixedu.academic.domain.ExecutionSemester;
import org.fenixedu.academic.domain.Person;
import org.fenixedu.academic.domain.StudentCurricularPlan;
import org.fenixedu.academic.domain.accessControl.academicAdministration.AcademicAccessRule;
import org.fenixedu.academic.domain.accessControl.academicAdministration.AcademicOperationType;
import org.fenixedu.academic.domain.exceptions.DomainException;
import org.fenixedu.academic.domain.person.RoleType;
import org.fenixedu.academic.domain.student.Registration;
import org.fenixedu.academic.service.services.exceptions.FenixServiceException;
import org.fenixedu.bennu.core.security.Authenticate;
import org.fenixedu.ulisboa.specifications.domain.enrolmentPeriod.AcademicEnrolmentPeriod;

/**
 * Shadowed class, in order to use AcademicEnrolmentPeriod instead of old EnrolmentPeriod
 */
public class ClassEnrollmentAuthorizationFilter {

    public static final ClassEnrollmentAuthorizationFilter instance = new ClassEnrollmentAuthorizationFilter();

    private static ConcurrentLinkedQueue<ClassEnrollmentCondition> conditions = new ConcurrentLinkedQueue<>();

    @FunctionalInterface
    public static interface ClassEnrollmentCondition {
        public void verify(Registration registration) throws DomainException;
    }

    public static void registerCondition(ClassEnrollmentCondition condition) {
        conditions.add(condition);
    }

    public void execute(Registration registration) throws FenixServiceException {
        Person person = Authenticate.getUser().getPerson();

        if (AcademicAccessRule.isProgramAccessibleToFunction(AcademicOperationType.STUDENT_ENROLMENTS, registration.getDegree(),
                person.getUser())) {
            return;
        }

        if (RoleType.RESOURCE_ALLOCATION_MANAGER.isMember(person.getUser())) {
            person = registration.getPerson();
        }

        for (ClassEnrollmentCondition condition : conditions) {
            condition.verify(registration);
        }

        final SortedSet<StudentCurricularPlan> activeStudentCurricularPlans =
                person.getActiveStudentCurricularPlansSortedByDegreeTypeAndDegreeName();

        if (activeStudentCurricularPlans.isEmpty()) {
            throw new NoActiveStudentCurricularPlanOfCorrectTypeException();
        }

        boolean hasOneOpen = false;
        FenixServiceException toThrow = null;
        for (final StudentCurricularPlan studentCurricularPlan : activeStudentCurricularPlans) {
            final FenixServiceException exception =
                    verify(studentCurricularPlan, ExecutionSemester.readActualExecutionSemester());
            hasOneOpen = hasOneOpen || exception == null;
            toThrow = exception == null ? toThrow : exception;
        }
        if (!hasOneOpen) {
            throw toThrow;
        }
    }

    public void execute(Registration registration, ExecutionSemester executionSemester) throws FenixServiceException {
        Person person = Authenticate.getUser().getPerson();

        if (AcademicAccessRule.isProgramAccessibleToFunction(AcademicOperationType.STUDENT_ENROLMENTS, registration.getDegree(),
                person.getUser())) {
            return;
        }

        if (RoleType.RESOURCE_ALLOCATION_MANAGER.isMember(person.getUser())) {
            person = registration.getPerson();
        }

        for (ClassEnrollmentCondition condition : conditions) {
            condition.verify(registration);
        }

        final SortedSet<StudentCurricularPlan> activeStudentCurricularPlans =
                person.getActiveStudentCurricularPlansSortedByDegreeTypeAndDegreeName();

        if (activeStudentCurricularPlans.isEmpty()) {
            throw new NoActiveStudentCurricularPlanOfCorrectTypeException();
        }

        boolean hasOneOpen = false;
        FenixServiceException toThrow = null;
        for (final StudentCurricularPlan studentCurricularPlan : activeStudentCurricularPlans) {
            final FenixServiceException exception = verify(studentCurricularPlan, executionSemester);
            hasOneOpen = hasOneOpen || exception == null;
            toThrow = exception == null ? toThrow : exception;
        }
        if (!hasOneOpen) {
            throw toThrow;
        }
    }

    private FenixServiceException verify(StudentCurricularPlan studentCurricularPlan, ExecutionSemester executionSemester) {
        final DegreeCurricularPlan degreeCurricularPlan = studentCurricularPlan.getDegreeCurricularPlan();
        Predicate<AcademicEnrolmentPeriod> predicate = null;
        if (!studentCurricularPlan.isInCandidateEnrolmentProcess(executionSemester.getExecutionYear())) {
            predicate = ep -> ep.isForClasses() || ep.isForShift();
        } else {
            predicate = ep -> ep.isForFirstTimeRegistration();
        }
        FenixServiceException result = verify(predicate, degreeCurricularPlan, executionSemester);
        if (result == null) {
            return null;
        }
        for (final DegreeCurricularPlanEquivalencePlan equivalencePlan : degreeCurricularPlan.getTargetEquivalencePlansSet()) {
            final DegreeCurricularPlan otherDegreeCurricularPlan = equivalencePlan.getDegreeCurricularPlan();
            result = verify(predicate, otherDegreeCurricularPlan, executionSemester);
            if (result == null) {
                return null;
            }
        }
        return result;
    }

    private FenixServiceException verify(Predicate<AcademicEnrolmentPeriod> enrolmentTypePredicate,
            DegreeCurricularPlan degreeCurricularPlan, ExecutionSemester executionSemester) {
        final Optional<AcademicEnrolmentPeriod> enrolmentPeriodInClasses =
                getValidEnrolmentPeriod(degreeCurricularPlan, enrolmentTypePredicate, executionSemester);
        if (!enrolmentPeriodInClasses.isPresent() || enrolmentPeriodInClasses.get().getStartDate() == null
                || enrolmentPeriodInClasses.get().getEndDate() == null) {
            return new CurrentClassesEnrolmentPeriodUndefinedForDegreeCurricularPlan();
        }

        if (!enrolmentPeriodInClasses.get().isOpen()) {
            StringBuilder buffer = new StringBuilder();
            buffer.append(enrolmentPeriodInClasses.get().getStartDate().toString("dd/MM/yyyy HH:mm"));
            buffer.append(" - ");
            buffer.append(enrolmentPeriodInClasses.get().getEndDate().toString("dd/MM/yyyy HH:mm"));
            buffer.append(" (").append(enrolmentPeriodInClasses.get().getExecutionSemester().getExecutionYear().getName())
                    .append(")");
            return new OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan(buffer.toString());
        }
        return null;
    }

    public Optional<AcademicEnrolmentPeriod> getValidEnrolmentPeriod(final DegreeCurricularPlan degreeCurricularPlan,
            java.util.function.Predicate<AcademicEnrolmentPeriod> predicate, ExecutionSemester executionSemester) {
        return degreeCurricularPlan.getAcademicEnrolmentPeriodsSet().stream()
                .filter(predicate.and(ep -> ep.getExecutionSemester() == executionSemester && ep.isOpen())).findAny();
    }

    public static class NoActiveStudentCurricularPlanOfCorrectTypeException extends FenixServiceException {
    }

    public static class CurrentClassesEnrolmentPeriodUndefinedForDegreeCurricularPlan extends FenixServiceException {
        public CurrentClassesEnrolmentPeriodUndefinedForDegreeCurricularPlan() {
            super("error.enrolmentPeriodNotDefined");
        }
    }

    public static class OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan extends FenixServiceException {
        public OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan() {
            super();
        }

        public OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan(String message, Throwable cause) {
            super(message, cause);
        }

        public OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan(Throwable cause) {
            super(cause);
        }

        public OutsideOfCurrentClassesEnrolmentPeriodForDegreeCurricularPlan(String message) {
            super("error.enrollment.period.closed", new String[] { message });
        }
    }

}