<%@page import="org.fenixedu.bennu.portal.domain.PortalConfiguration"%>
<%@page import="org.fenixedu.academic.predicate.AccessControl"%>
<%
	if(AccessControl.getPerson() == null){
%>
	<meta http-equiv="refresh" content="0; url=${pageContext.request.contextPath}/login" />	
<%
	} else{
	    request.setAttribute("path", PortalConfiguration.getInstance().getMenu().getUserMenuStream().findFirst().get().getPath());
%>
	<meta http-equiv="refresh" content="0; url=${pageContext.request.contextPath}/${path}" />
<%
	}
%>


