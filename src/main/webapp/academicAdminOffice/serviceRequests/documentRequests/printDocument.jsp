<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://fenix-ashes.ist.utl.pt/fenix-renderers" prefix="fr"%>
<html:xhtml />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="org.fenixedu.commons.i18n.I18N" %>
<%@ page import="org.fenixedu.qubdocs.ui.documenttemplates.AcademicServiceRequestController" %>
<!-- Choose ONLY ONE:  bennuToolkit OR bennuAngularToolkit -->
${portal.angularToolkit()}
<%-- ${portal.toolkit()} --%>

<link
    href="${pageContext.request.contextPath}/webjars/select2/4.0.0-rc.2/dist/css/select2.min.css"
    rel="stylesheet" />
<script
    src="${pageContext.request.contextPath}/webjars/select2/4.0.0-rc.2/dist/js/select2.min.js"></script>
<script type="text/javascript"
    src="${pageContext.request.contextPath}/webjars/bootbox/4.4.0/bootbox.js"></script>
<script
    src="${pageContext.request.contextPath}/static/qubdocsreports/js/omnis.js"></script>
<script src="${pageContext.request.contextPath}/webjars/angular-sanitize/1.3.11/angular-sanitize.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/webjars/angular-ui-select/0.11.2/select.min.css" />
<script src="${pageContext.request.contextPath}/webjars/angular-ui-select/0.11.2/select.min.js"></script>


<fmt:setLocale value='<%= I18N.getLocale().getLanguage() %>'/>
<fmt:setBundle basename="resources.FenixeduQubdocsReportsResources" var="lang"/>

<h2 class="mbottom1">
    <bean:message bundle="ACADEMIC_OFFICE_RESOURCES"
        key="document.print" />
</h2>

<bean:define id="academicServiceRequest" name="academicServiceRequest"
    scope="request"
    type="org.fenixedu.academic.domain.serviceRequests.RegistrationAcademicServiceRequest" />

<div style="float: right;">
    <bean:define id="personID" name="academicServiceRequest"
        property="registration.student.person.username" />
    <html:img align="middle"
        src="<%=request.getContextPath() + "/user/photo/" + personID.toString()%>"
        altKey="personPhoto" bundle="IMAGE_RESOURCES"
        styleClass="showphoto" />
</div>

<p class="mvert2">
    <span class="showpersonid"> <bean:message key="label.student"
            bundle="ACADEMIC_OFFICE_RESOURCES" />: <fr:view
            name="academicServiceRequest"
            property="registration.student"
            schema="student.show.personAndStudentInformation.short">
            <fr:layout name="flow">
                <fr:property name="labelExcluded" value="true" />
            </fr:layout>
        </fr:view>
    </span>
</p>


<p class="mbottom025">
    <strong><bean:message bundle="ACADEMIC_OFFICE_RESOURCES"
            key="request.information" /></strong>
</p>
<bean:define id="simpleClassName" name="academicServiceRequest"
    property="class.simpleName" />
<fr:view name="academicServiceRequest"
    schema="<%=simpleClassName + ".view"%>">
    <fr:layout name="tabular">
        <fr:property name="classes"
            value="tstyle4 thright thlight mtop025 mbottom05" />
        <fr:property name="rowClasses" value=",,,,," />
    </fr:layout>
</fr:view>

<html:messages id="message" message="true"
    bundle="ACADEMIC_OFFICE_RESOURCES">
    <p class="mtop1">
        <span class="warning0"> <bean:write name="message" />
        </span>
    </p>
</html:messages>

<logic:present name="academicServiceRequest" property="activeSituation">
    <p class="mbottom025">
        <strong><bean:message
                bundle="ACADEMIC_OFFICE_RESOURCES"
                key="request.situation" /></strong>
    </p>
    <fr:view name="academicServiceRequest" property="activeSituation"
        schema="AcademicServiceRequestSituation.view">
        <fr:layout name="tabular">
            <fr:property name="classes"
                value="tstyle4 thright thlight mtop025 mbottom05" />
            <fr:property name="rowClasses" value="tdhl1,,," />
        </fr:layout>
    </fr:view>
</logic:present>

<bean:define id="documentRequest" name="academicServiceRequest"
    type="org.fenixedu.academic.domain.serviceRequests.documentRequests.DocumentRequest" />

<script>
angular.module('angularAppAcademicServiceRequestTemplate', ['ngSanitize', 'ui.select', 'bennuToolkit']).controller('AcademicServiceRequestTemplateController', ['$scope', function($scope) {
    $scope.booleanvalues= [
                            {name: '<spring:message code="label.no"/>',    value: false},
                            {name: '<spring:message code="label.yes"/>',        value: true}
                          ];
    $scope.object;
    $scope.postBack = createAngularPostbackFunction($scope);
}]);
</script>
<logic:equal name="documentRequest" property="toPrint" value="true">
    <form name='form' method="POST" class="form-horizontal"
          ng-app="angularAppAcademicServiceRequestTemplate" ng-controller="AcademicServiceRequestTemplateController"
          action='${pageContext.request.contextPath}<%= AcademicServiceRequestController.PRINT_DOCUMENT_REQUEST_URL %>'>
        <input type="hidden" name="postback"
            value='${pageContext.request.contextPath}<%= AcademicServiceRequestController.GET_CUSTOM_TEMPLATES_URL %>' />
            
        <input name="bean" type="hidden" value="{{ object }}" />
        <input name="documentRequest" type="hidden" value="${academicServiceRequest.externalId}" />

        <div class="panel-header">
            <strong><fmt:message key="label.title.printingSettings" bundle="${lang}" /></strong>
        </div>
        <div class="panel panel-default" data-ng-init="postBack($model)">
            <div class="panel-body">
                <div class="form-group row">
                    <div class="col-sm-2 control-label">
                        <fmt:message key="label.title.manageDocumentSignature" bundle="${lang}"/>
                    </div>
                    <div class="col-sm-6">
                        <ui-select id="academicServiceRequestTemplate_signature" class="" name="signature" ng-model="$parent.object.documentSigner" theme="bootstrap" ng-disabled="disabled" required style="width:100%">
                            <ui-select-match >{{$select.selected.text}}</ui-select-match>
                            <ui-select-choices repeat="signature.id as signature in object.documentSignerDataSource | filter: $select.search">
                                <span ng-bind-html="signature.text | highlight: $select.search"></span>
                            </ui-select-choices>
                        </ui-select>
                    </div>
                </div>
                <div class="form-group row" ng-show="object.academicServiceRequestTemplateDataSource.length > 1">
                    <div class="col-sm-2 control-label">
                        <fmt:message key="label.documentTemplates.template" bundle="${lang}"/>
                    </div>
                    <div class="col-sm-6">
                        <ui-select id="academicServiceRequestTemplate_template" class="" name="template" ng-model="$parent.object.academicServiceRequestTemplate" theme="bootstrap" ng-disabled="disabled" required style="width:100%">
                            <ui-select-match >{{$select.selected.text}}</ui-select-match>
                            <ui-select-choices repeat="template.id as template in object.academicServiceRequestTemplateDataSource | filter: $select.search">
                                <span ng-bind-html="template.text | highlight: $select.search"></span>
                            </ui-select-choices>
                        </ui-select>
                    </div>
                </div>
                <input type="submit" class="btn btn-default" role="button" value='<fmt:message key="label.print" bundle="${lang}" />' />
            </div>
        </div>
    </form>
</logic:equal>

<bean:define id="registrationID" name="academicServiceRequest"
    property="registration.externalId" />

<fr:form
    action="<%="/academicServiceRequestsManagement.do?academicServiceRequestId="
                        + academicServiceRequest.getExternalId().toString() + "&amp;registrationID=" + registrationID.toString()%>">
    <html:hidden name="academicServiceRequestsManagementForm"
        property="method" value="concludeAcademicServiceRequest" />

    <p class="mtop15 mbottom025">
        <strong><bean:message
                bundle="ACADEMIC_OFFICE_RESOURCES"
                key="documentRequest.confirmDocumentSuccessfulPrinting" /></strong>
    </p>
    <logic:equal name="documentRequest" property="pagedDocument"
        value="true">
        <fr:edit id="documentRequestConclude" name="documentRequest"
            schema="DocumentRequest.conclude-info">
            <fr:layout name="tabular">
                <fr:property name="classes"
                    value="tstyle5 thmiddle thright thlight mtop025 mbottom1" />
                <fr:property name="columnClasses"
                    value=",,tdclear tderror1" />
            </fr:layout>
            <fr:destination name="invalid"
                path="<%="/documentRequestsManagement.do?method=prepareConcludeDocumentRequest&amp;academicServiceRequestId="
                                + academicServiceRequest.getExternalId().toString()%>" />
        </fr:edit>
    </logic:equal>

    <logic:equal name="documentRequest" property="diploma" value="true">
        <fr:edit id="serviceRequestBean" name="serviceRequestBean"
            schema="AcademicServiceRequestBean.external.entity.edit">
            <fr:layout>
                <fr:property name="classes"
                    value="tstyle4 thright thlight mtop025 mbottom05" />
                <fr:property name="columnClasses"
                    value=",,tdclear tderror1" />
            </fr:layout>
        </fr:edit>
    </logic:equal>

    <%-- 
	<strong><bean:message key="label.serviceRequests.sendEmailToStudent" bundle="ACADEMIC_OFFICE_RESOURCES"/></strong><html:radio name="academicServiceRequestsManagementForm" property="sendEmailToStudent" value="true"><bean:message key="label.yes" bundle="ACADEMIC_OFFICE_RESOURCES"/></html:radio><html:radio name="academicServiceRequestsManagementForm" property="sendEmailToStudent" value="false"><bean:message key="label.no" bundle="ACADEMIC_OFFICE_RESOURCES"/></html:radio>
	<br/>
	<br/>
	--%>
    <html:submit>
        <bean:message key="label.documentRequestsManagement.conclude"
            bundle="ACADEMIC_OFFICE_RESOURCES" />
    </html:submit>
    <html:cancel
        onclick="this.form.method.value='backToViewRegistration'">
        <bean:message key="back" bundle="ACADEMIC_OFFICE_RESOURCES" />
    </html:cancel>
</fr:form>

