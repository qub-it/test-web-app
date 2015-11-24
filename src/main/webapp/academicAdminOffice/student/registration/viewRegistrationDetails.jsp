<%--

    Copyright © 2002 Instituto Superior Técnico

    This file is part of FenixEdu Academic.

    FenixEdu Academic is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FenixEdu Academic is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FenixEdu Academic.  If not, see <http://www.gnu.org/licenses/>.

--%>
<%@ page isELIgnored="true"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html" %>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/fenix-renderers" prefix="fr" %>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/taglib/academic" prefix="academic" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="org.fenixedu.academic.domain.ExecutionYear"%>
<%@page import="org.fenixedu.academic.domain.student.RegistrationDataByExecutionYear"%>
<%@page import="org.fenixedu.commons.i18n.I18N" %>
<%@page import="org.fenixedu.ulisboa.specifications.ui.ulisboaservicerequest.ULisboaServiceRequestManagementController"%>
<%@page import="org.fenixedu.ulisboa.specifications.domain.serviceRequests.ULisboaServiceRequest"%>
<%@page import="java.util.stream.Collectors" %>
<%@page import="org.fenixedu.academic.domain.student.Registration" %>





<html:xhtml/>

    <bean:define id="registration" name="registration" scope="request" type="org.fenixedu.academic.domain.student.Registration"/>

    <div style="float: right;">
        <bean:define id="personID" name="registration" property="student.person.username"/>
        <html:img align="middle" src="<%= request.getContextPath() + "/user/photo/" + personID.toString()%>" altKey="personPhoto" bundle="IMAGE_RESOURCES" styleClass="showphoto"/>
    </div>

    <h2><bean:message key="label.visualizeRegistration" bundle="ACADEMIC_OFFICE_RESOURCES"/></h2>
    

    <p>
        <html:link page="/student.do?method=visualizeStudent" paramId="studentID" paramName="registration" paramProperty="student.externalId">
            <bean:message key="link.student.backToStudentDetails" bundle="ACADEMIC_OFFICE_RESOURCES"/>
        </html:link>
    </p>

    

    
    <p class="mvert2">
        <span class="showpersonid">
        <bean:message key="label.student" bundle="ACADEMIC_OFFICE_RESOURCES"/>: 
            <fr:view name="registration" property="student" schema="student.show.personAndStudentInformation.short">
                <fr:layout name="flow">
                    <fr:property name="labelExcluded" value="true"/>
                </fr:layout>
            </fr:view>
        </span>
    </p>
    
    
    
    <logic:messagesPresent message="true">
        <ul class="list7 mtop2 warning0" style="list-style: none;">
            <html:messages id="message" message="true" bundle="ACADEMIC_OFFICE_RESOURCES">
                <li>
                    <span><!-- Error messages go here --><bean:write name="message" /></span>
                </li>
            </html:messages>
        </ul>
    </logic:messagesPresent>






    <logic:present name="registration" property="ingressionType">
        <h3 class="mtop2 mbottom05 separator2"><bean:message key="label.registrationDetails" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
    </logic:present>
    
    <logic:notPresent name="registration" property="ingressionType">
        <h3 class="mtop2 mbottom05 separator2"><bean:message key="label.registrationDetails" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
    </logic:notPresent>
    <bean:define id="registration" name="registration" type="org.fenixedu.academic.domain.student.Registration"/>



<table>
	<tr>
		<td>
		
			<%-- Registration Details --%>
			<logic:present name="registration" property="ingressionType">
			<fr:view name="registration" schema="student.registrationDetail" >
				<fr:layout name="tabular">
					<fr:property name="classes" value="tstyle4 thright thlight"/>
					<fr:property name="rowClasses" value=",,,,,,,,"/>
				</fr:layout>
			</fr:view>
			</logic:present>
			<logic:notPresent name="registration" property="ingressionType">
			<fr:view name="registration" schema="student.registrationsWithStartData" >
				<fr:layout name="tabular">
					<fr:property name="classes" value="tstyle4 thright thlight mtop0"/>
					<fr:property name="rowClasses" value=",,,,,,,"/>
				</fr:layout>
			</fr:view>
			</logic:notPresent>
		
		</td>
		
		<td style="vertical-align: top; padding-top: 1em;">
			<academic:allowed operation="MANAGE_REGISTRATIONS" program="<%= registration.getDegree() %>">
			<%-- qubExtension --%>
			<academic:allowed operation="STUDENT_ENROLMENTS" program="<%= registration.getDegree() %>">
			<p class="mtop0 pleft1 asd">
				<span class="dblock pbottom03">
					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
					<html:link page="/registration.do?method=prepareViewRegistrationCurriculum" paramId="registrationID" paramName="registration" paramProperty="externalId">
						<bean:message key="link.registration.viewCurriculum" bundle="ACADEMIC_OFFICE_RESOURCES"/>
					</html:link>
				</span>
				<span class="dblock pbottom03">
					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
					<html:link page="/manageRegistrationState.do?method=prepare" paramId="registrationId" paramName="registration" paramProperty="externalId">
						<bean:message key="link.student.manageRegistrationState" bundle="ACADEMIC_OFFICE_RESOURCES"/>
					</html:link>
				</span>
				<span class="dblock pbottom03">
						<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
						<html:link page="/manageIngression.do?method=prepare" paramId="registrationId" paramName="registration" paramProperty="externalId">
							<bean:message key="link.student.manageIngressionAndAgreement" bundle="ACADEMIC_OFFICE_RESOURCES"/>
						</html:link>
				</span>
				<span class="dblock pbottom03">
					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
					<html:link page="/manageRegistrationStartDates.do?method=prepare" paramId="registrationId" paramName="registration" paramProperty="externalId">
						<bean:message key="link.student.manageRegistrationStartDates" bundle="ACADEMIC_OFFICE_RESOURCES"/>
					</html:link>
				</span>		
				<logic:equal name="registration" property="degreeType.name" value="BOLONHA_ADVANCED_FORMATION_DIPLOMA">
					<span class="dblock pbottom03">	
						<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
						<html:link page="/manageEnrolmentModel.do?method=prepare" paramId="registrationID" paramName="registration" paramProperty="externalId">
							<bean:message key="link.student.manageEnrolmentModel" bundle="ACADEMIC_OFFICE_RESOURCES"/>
						</html:link>
					</span>
				</logic:equal>
				<logic:equal name="registration" property="registrationProtocol.enrolmentByStudentAllowed" value="false">
					<span class="dblock pbottom03">	
						<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
						<html:link page="/manageExternalRegistrationData.do?method=prepare" paramId="registrationId" paramName="registration" paramProperty="externalId">
							<bean:message key="link.student.manageExternalRegistrationData" bundle="ACADEMIC_OFFICE_RESOURCES"/>
						</html:link>
					</span>	
				</logic:equal>
				<academic:allowed operation="MANAGE_CONCLUSION" program="<%= registration.getDegree() %>">
					<logic:equal name="registration" property="qualifiedToRegistrationConclusionProcess" value="true">
						<span class="dblock pbottom03">	
							<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
							<html:link page="/registration.do?method=prepareRegistrationConclusionProcess" paramId="registrationId" paramName="registration" paramProperty="externalId">
								<bean:message key="student.registrationConclusionProcess" bundle="ACADEMIC_OFFICE_RESOURCES"/>
							</html:link>
						</span>	
					</logic:equal>
				</academic:allowed>
				<span class="dblock pbottom03">	
					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
					<html:link page="/registration.do?method=showRegimes" paramId="registrationId" paramName="registration" paramProperty="externalId">
						<bean:message key="student.regimes" bundle="ACADEMIC_OFFICE_RESOURCES"/>
					</html:link>
				</span>
<%-- qubExtension --%>
<%-- 				<academic:allowed operation="STUDENT_ENROLMENTS" program="<%= registration.getDegree() %>"> --%>
<!-- 				<span class="dblock pbottom03">	 -->
<%-- 					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" /> --%>
<%-- 					<html:link page="/registration.do?method=viewAttends" paramId="registrationId" paramName="registration" paramProperty="externalId"> --%>
<%-- 						<bean:message key="student.registrationViewAttends" bundle="ACADEMIC_OFFICE_RESOURCES"/> --%>
<%-- 					</html:link> --%>
<!-- 				</span> -->
<%-- 				</academic:allowed>		 --%>
				
				<%-- Extension --%>
				<jsp:include page="viewRegistrationDetailsTreasuryDebtAccountLink_ulisboa_specification.jsp" />	
			</p>
			</academic:allowed>
			</academic:allowed>
		</td>
	</tr>
</table>
	
	<!-- qubExtension -->
		<jsp:include page="registrationObservations.jsp"></jsp:include>
	<!-- /qubExtension -->
	
	<logic:notEmpty name="registration" property="phdIndividualProgramProcess">
		<academic:allowed operation="MANAGE_PHD_PROCESSES" program="<%= registration.getPhdIndividualProgramProcess().getPhdProgram() %>">
		
		<%-- Phd Individual Program Process --%>
		<bean:define id="phdProcess" name="registration" property="phdIndividualProgramProcess" />
		<h3 class="mbottom05 mtop25 separator2"><bean:message key="PhdIndividualProgramProcess" bundle="PHD_RESOURCES"/></h3>
		<table>
			<tr>
				<td>
					<fr:view schema="AcademicAdminOffice.PhdIndividualProgramProcess.view" name="phdProcess">
						<fr:layout name="tabular">
							<fr:property name="classes" value="tstyle2 thlight mtop15 thleft" />
						</fr:layout>
					</fr:view>
				</td>
			</tr>
		</table>
		
		<p>
			<html:link target="_blank" page="/phdIndividualProgramProcess.do?method=viewProcess"  paramId="processId" paramName="phdProcess" paramProperty="externalId">
				<bean:message key="link.org.fenixedu.academic.domain.phd.PhdIndividualProgramProcess.view" bundle="PHD_RESOURCES" />
			</html:link>
		</p>
		</academic:allowed>
	</logic:notEmpty>
	
	<%-- Registration Data by Execution Year --%>
	<h3 class="mbottom05 mtop25 separator2"><bean:message key="title.registrationDataByExecutionYear" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
	<logic:empty name="registration" property="registrationDataByExecutionYear">
		<bean:message key="label.registrationDataByExecutionYear.noResults" bundle="ACADEMIC_OFFICE_RESOURCES"/>
	</logic:empty>
	<logic:notEmpty name="registration" property="registrationDataByExecutionYear">
		<fr:view name="registration" property="registrationDataByExecutionYear">
			<fr:schema bundle="ACADEMIC_OFFICE_RESOURCES" type="<%= RegistrationDataByExecutionYear.class.getName() %>">
				<fr:slot name="executionYear.qualifiedName" key="label.executionYear" />
				<fr:slot name="enrolmentDate" key="label.enrolmentDate" />
			</fr:schema>
			<fr:layout name="tabular">
				<fr:property name="classes" value="tstyle2 thright thlight thcenter"/>
				<fr:property name="columnClasses" value="acenter,acenter,acenter" />
				<fr:property name="sortBy" value="executionYear=desc" />
				<%-- qubExtension --%>				
				<academic:allowed operation="STUDENT_ENROLMENTS" program="<%= registration.getDegree() %>">
				<fr:link name="edit" label="label.edit,ACADEMIC_OFFICE_RESOURCES" 
							 link="/manageRegistrationDataByExecutionYear.do?method=prepareEdit&registrationDataByExecutionYearId=${externalId}" order="1" />
				<%-- qubExtension --%>
				<fr:link name="shiftEnrolment" label="label.shifts,APPLICATION_RESOURCES" 
							 link="/shiftEnrolment/${registration.externalId}/${executionYear.firstExecutionPeriod.externalId}" order="2" />
				</academic:allowed>							 
			</fr:layout>
		</fr:view>
	</logic:notEmpty>
	
	
	<%-- Curricular Plans --%>
	
	<academic:allowed operation="MANAGE_REGISTRATIONS" program="<%= registration.getDegree() %>">
	<h3 class="mbottom05 mtop25 separator2"><bean:message key="label.studentCurricularPlans" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
	
	<fr:view name="registration" property="sortedStudentCurricularPlans" schema="student.studentCurricularPlans" >
		<fr:layout name="tabular">
			<fr:property name="classes" value="tstyle2 thright thlight thcenter"/>
			<fr:property name="groupLinks" value="false"/>
			
			<fr:property name="linkFormat(enrol)" value="/studentEnrolments.do?method=prepare&amp;scpID=${externalId}" />
			<fr:property name="key(enrol)" value="link.student.enrolInCourses"/>
			<fr:property name="bundle(enrol)" value="ACADEMIC_OFFICE_RESOURCES"/>
			<fr:property name="contextRelative(enrol)" value="true"/>      
			<fr:property name="visibleIf(enrol)" value="allowedToManageEnrolments" />
			<fr:property name="order(enrol)" value="1"/>     					
			
			<%-- qubExtension --%>
			<academic:allowed operation="MANAGE_EQUIVALENCES">
				<fr:property name="linkFormat(dismissal)" value="/studentDismissals.do?method=manage&amp;scpID=${externalId}" />
				<fr:property name="key(dismissal)" value="link.student.dismissal.management"/>
				<fr:property name="bundle(dismissal)" value="ACADEMIC_OFFICE_RESOURCES"/>
				<fr:property name="contextRelative(dismissal)" value="true"/>      	
				<fr:property name="order(dismissal)" value="2"/>
			</academic:allowed>
			
			<fr:property name="linkFormat(createAccountingEvents)" value="/accountingEventsManagement.do?method=prepare&amp;scpID=${externalId}" />
			<fr:property name="key(createAccountingEvents)" value="label.accountingEvents.management.createEvents"/>
			<fr:property name="bundle(createAccountingEvents)" value="ACADEMIC_OFFICE_RESOURCES"/>
			<fr:property name="contextRelative(createAccountingEvents)" value="true"/>      	
			<fr:property name="order(createAccountingEvents)" value="3"/>
			<fr:property name="visibleIf(createAccountingEvents)" value="allowedToManageAccountingEvents"/>
			
			<fr:property name="linkFormat(edit)" value="/manageStudentCurricularPlans.do?method=prepareEdit&amp;studentCurricularPlanId=${externalId}" />
			<fr:property name="key(edit)" value="label.edit"/>
			<fr:property name="bundle(edit)" value="ACADEMIC_OFFICE_RESOURCES"/>
			<fr:property name="contextRelative(edit)" value="true"/>      	
			<fr:property name="visibleIf(edit)" value="allowedToManageEnrolments" />
			<fr:property name="order(edit)" value="4"/>
			
			<fr:property name="linkFormat(delete)" value="/manageStudentCurricularPlans.do?method=delete&amp;studentCurricularPlanId=${externalId}" />
			<fr:property name="key(delete)" value="label.delete"/>
			<fr:property name="bundle(delete)" value="ACADEMIC_OFFICE_RESOURCES"/>
			<fr:property name="confirmationKey(delete)" value="message.manageStudentCurricularPlans.delete.confirmation"/>
			<fr:property name="confirmationBundle(delete)" value="ACADEMIC_OFFICE_RESOURCES"/>
			<fr:property name="contextRelative(delete)" value="true"/>      	
			<fr:property name="visibleIf(delete)" value="allowedToDelete" />
			<fr:property name="order(delete)" value="5"/>
			
		</fr:layout>
	</fr:view>
	
	<p class="mtop0">

		<%-- qubExtension --%>
		<academic:allowed operation="STUDENT_ENROLMENTS" program="<%= registration.getDegree() %>">
		<span>
			<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
			<html:link page="/studentExternalEnrolments.do?method=manageExternalEnrolments" paramId="registrationId" paramName="registration" paramProperty="externalId">
				<bean:message key="label.student.manageExternalEnrolments" bundle="ACADEMIC_OFFICE_RESOURCES"/>
			</html:link>
		</span>
		</academic:allowed>

		<span class="pleft1">
			<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
			<html:link page="/viewStudentCurriculum.do?method=prepare" paramId="registrationOID" paramName="registration" paramProperty="externalId">
				<bean:message key="link.registration.viewStudentCurricularPlans" bundle="ACADEMIC_OFFICE_RESOURCES"/>
			</html:link>
		</span>
		
		<%-- qubExtension --%>
		<academic:allowed operation="STUDENT_ENROLMENTS" program="<%= registration.getDegree() %>">
		<span class="pleft1">
			<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
			<html:link page="/manageStudentCurricularPlans.do?method=prepareCreate" paramId="registrationId" paramName="registration" paramProperty="externalId">
				<bean:message key="link.manageStudentCurricularPlans.create" bundle="ACADEMIC_OFFICE_RESOURCES"/>
			</html:link>
		</span>
		</academic:allowed>
		
	</p>
	
	</academic:allowed>
	
	<academic:notAllowed operation="MANAGE_REGISTRATIONS" program="<%= registration.getDegree() %>">
		<academic:allowed operation="VIEW_FULL_STUDENT_CURRICULUM">
			<h3 class="mbottom05 mtop25 separator2"><bean:message key="label.studentCurricularPlans" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
			
			<fr:view name="registration" property="sortedStudentCurricularPlans" schema="student.studentCurricularPlans" >
				<fr:layout name="tabular">
					<fr:property name="classes" value="tstyle2 thright thlight thcenter"/>
					<fr:property name="groupLinks" value="false"/>
					
					<fr:property name="linkFormat(enrol)" value="/studentEnrolments.do?method=prepare&amp;scpID=${externalId}" />
					<fr:property name="key(enrol)" value="link.student.enrolInCourses"/>
					<fr:property name="bundle(enrol)" value="ACADEMIC_OFFICE_RESOURCES"/>
					<fr:property name="contextRelative(enrol)" value="true"/>      
					<fr:property name="visibleIf(enrol)" value="allowedToManageEnrolments" />
					<fr:property name="order(enrol)" value="1"/>
					
					<%-- extension: Deprecated payment system 
					<fr:property name="linkFormat(createAccountingEvents)" value="/accountingEventsManagement.do?method=prepare&amp;scpID=${externalId}" />
					<fr:property name="key(createAccountingEvents)" value="label.accountingEvents.management.createEvents"/>
					<fr:property name="bundle(createAccountingEvents)" value="ACADEMIC_OFFICE_RESOURCES"/>
					<fr:property name="contextRelative(createAccountingEvents)" value="true"/>      	
					<fr:property name="order(createAccountingEvents)" value="3"/>
					<fr:property name="visibleIf(createAccountingEvents)" value="allowedToManageAccountingEvents"/>
					--%>
				</fr:layout>
			</fr:view>
			<p class="mtop0">
				<span>
					<img src="<%= request.getContextPath() %>/images/dotist_post.gif" alt="<bean:message key="dotist_post" bundle="IMAGE_RESOURCES" />" />
					<html:link page="/viewStudentCurriculum.do?method=prepare" paramId="registrationOID" paramName="registration" paramProperty="externalId">
						<bean:message key="link.registration.viewStudentCurricularPlans" bundle="ACADEMIC_OFFICE_RESOURCES"/>
					</html:link>
				</span>
			</p>
		</academic:allowed>
	</academic:notAllowed>

    <jsp:include page="/WEB-INF/fenixedu-ulisboa-specifications/servicerequests/ulisboarequest/uLisboaServiceRequestSection.jsp" />

    <%-- Precedence Info --%>
    
    <logic:present name="registration" property="studentCandidacy">
        <h3 class="mtop2 mbottom05 separator2"><bean:message key="label.person.title.precedenceDegreeInfo" bundle="ACADEMIC_OFFICE_RESOURCES"/></h3>
        <fr:view name="registration" property="studentCandidacy.precedentDegreeInformation" schema="student.precedentDegreeInformation" >
            <fr:layout name="tabular">
                <fr:property name="classes" value="tstyle4 thright thlight mtop05"/>
            </fr:layout>
        </fr:view>
    </logic:present>
<bean:define id="deliveryWarning">
<bean:message bundle="ACADEMIC_OFFICE_RESOURCES"  key="academic.service.request.delivery.confirmation"/>
</bean:define>
