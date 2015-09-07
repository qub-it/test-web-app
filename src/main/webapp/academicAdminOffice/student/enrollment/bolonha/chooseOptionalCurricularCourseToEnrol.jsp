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
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<html:xhtml />
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/fenix-renderers" prefix="fr"%>
<%@page import="org.fenixedu.commons.i18n.I18N"%>

<h2>
	<bean:message key="label.student.enrollment.optional.course" bundle="ACADEMIC_OFFICE_RESOURCES" />
	<bean:define id="withRules" name="bolonhaStudentEnrollmentForm" property="withRules" />
	<logic:equal name="withRules" value="true">
		(<bean:message bundle="ACADEMIC_OFFICE_RESOURCES"  key="label.student.enrollment.withRules"/>)
	</logic:equal>
	<logic:equal name="withRules" value="false">
		(<bean:message bundle="ACADEMIC_OFFICE_RESOURCES"  key="label.student.enrollment.withoutRules"/>)
	</logic:equal>
</h2>

<%-- qubExtension --%>
<%@page import="org.fenixedu.bennu.core.i18n.BundleUtil"%>
<%@page import="org.fenixedu.academic.util.Bundle"%>
<%@page import="org.fenixedu.academic.dto.student.enrollment.bolonha.BolonhaStudentOptionalEnrollmentBean"%>
<%@page import="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.DegreeCurricularPlansForDegreeForOptionalEnrollment"%>
<script type="text/javascript">//<![CDATA[
	function disabler(jQuery) {
		var OIDs = <%=DegreeCurricularPlansForDegreeForOptionalEnrollment.getAnyCurricularCourseExceptionsOIDs((BolonhaStudentOptionalEnrollmentBean) request.getAttribute("optionalEnrolmentBean"))%>;
		var indexer = "a[name^=optionalCurricularCourseEnrolLink";
		var label = '<%=BundleUtil.getString("resources/FenixeduUlisboaSpecificationsResources", "curricularRules.ruleExecutors.AnyCurricularCourseExceptions.not.offered.label")%>';
		$.each( OIDs, function( key, value ) {
			$(indexer.concat(value)).text(label).attr('onclick', function(){return false;}).css('text-decoration', 'line-through').css('color', 'grey');
		});
	}
	
	$(document).ready(disabler);
//]]></script>

<html:form action="/bolonhaStudentEnrollment.do">

	<html:hidden property="method" value=""/>
	<html:hidden property="withRules"/>

	<fr:context>
	<fr:edit id="optionalEnrolment" name="optionalEnrolmentBean">

		<%-- qubExtension --%>	
		<fr:schema bundle="STUDENT_RESOURCES"
			type="org.fenixedu.academic.dto.student.enrollment.bolonha.BolonhaStudentOptionalEnrollmentBean">
			<fr:slot name="degreeType" key="label.degreeType"
				layout="menu-select-postback"
				validator="pt.ist.fenixWebFramework.renderers.validators.RequiredValidator">
				<fr:property name="format" value="\${name.content}" />
				<logic:equal name="withRules" value="true">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.BolonhaDegreeTypesProviderForOptionalEnrollment" />
				</logic:equal>
				<logic:equal name="withRules" value="false">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.BolonhaDegreeTypesProvider" />
				</logic:equal>
				<fr:property name="destination" value="updateComboBoxes"/>
			</fr:slot>
			<fr:slot name="degree" key="label.degree"
				layout="menu-select-postback"
				validator="pt.ist.fenixWebFramework.renderers.validators.RequiredValidator">
				<logic:equal name="withRules" value="true">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.DegreesByDegreeTypeForOptionalEnrollment" />
				</logic:equal>
				<logic:equal name="withRules" value="false">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.DegreesByDegreeType" />
				</logic:equal>
				<fr:property name="format" value="\${name}" />
				<fr:property name="destination" value="updateComboBoxes"/>
			</fr:slot>
			<fr:slot name="degreeCurricularPlan" key="label.degreeCurricularPlan"
				layout="menu-select-postback"
				validator="pt.ist.fenixWebFramework.renderers.validators.RequiredValidator">
				<logic:equal name="withRules" value="true">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.DegreeCurricularPlansForDegreeForOptionalEnrollment" />
				</logic:equal>
				<logic:equal name="withRules" value="false">
					<fr:property name="providerClass"
						value="org.fenixedu.academic.ui.renderers.providers.enrollment.bolonha.DegreeCurricularPlansForDegree" />
				</logic:equal>
				<fr:property name="format" value="\${name}" />
				<fr:property name="destination" value="updateComboBoxes"/>
			</fr:slot>
		</fr:schema>
	
		<fr:destination name="updateComboBoxes"
			path="/bolonhaStudentEnrollment.do?method=updateParametersToSearchOptionalCurricularCourses" />
		<fr:layout name="tabular">
			<fr:property name="classes" value="tstyle4 thlight thright" />
			<fr:property name="columnClasses" value=",,tdclear tderror1" />
		</fr:layout>
	</fr:edit>
	
	
		<logic:messagesPresent message="true" property="error">
			<div class="mtop1 mbottom15 error0" style="padding: 0.5em;">
			<p class="mvert0"><strong><bean:message bundle="ACADEMIC_OFFICE_RESOURCES" key="label.student.enrollment.errors.in.enrolment" />:</strong></p>
			<ul class="mvert05">
				<html:messages id="messages" message="true" bundle="APPLICATION_RESOURCES" property="error">
					<% pageContext.setAttribute("messages", ((String) pageContext.getAttribute("messages")).replaceAll("\\?\\?\\?" + I18N.getLocale().toString() + "\\.", "").replaceAll("\\?\\?\\?", ""));%>
					<li><span class="error0"><bean:write name="messages" /></span></li>
				</html:messages>
			</ul>
			</div>
		</logic:messagesPresent>
		
		<logic:present name="curricularRuleLabels">
			<logic:notEmpty name="curricularRuleLabels">
				<div class="smalltxt noborder">
					<ul class="mvert05">
						<logic:iterate id="curricularRuleLabel" name="curricularRuleLabels">
							<li><span style="color: #888"><bean:write name="curricularRuleLabel" /></span></li>
						</logic:iterate>
					</ul>
				</div>
			</logic:notEmpty>
		</logic:present>
	
		<logic:present name="optionalEnrolmentBean" property="degreeCurricularPlan">
			<fr:edit id="degreeCurricularPlan" name="optionalEnrolmentBean">
				<fr:layout name="bolonha-student-optional-enrolments">
					<fr:property name="classes" value="mtop15" />
					<fr:property name="groupRowClasses" value="se_groups" />
				</fr:layout>
			</fr:edit>
		</logic:present>
		
	</fr:context>

</html:form>

<bean:define id="studentCurricularPlanId" name="optionalEnrolmentBean" property="studentCurricularPlan.externalId" />

<html:form action="<%= "/bolonhaStudentEnrollment.do?method=cancelChooseOptionalCurricularCourseToEnrol&amp;withRules=" + withRules.toString() %>">
<fr:context>
	<fr:edit id="optionalEnrolment" name="optionalEnrolmentBean" visible="false"/>
	<p class="mtop15">
		<html:submit bundle="HTMLALT_RESOURCES" altKey="submit.submit">
			<bean:message bundle="APPLICATION_RESOURCES" key="label.cancel"/>
		</html:submit>
	</p>
</fr:context>
</html:form>

<script>
$(function() {
	$('table').removeClass('table');
	$('form div[class="tstyle4 thlight thright"]').addClass('form-horizontal').removeClass('tstyle4 thlight thright');
});
</script>
