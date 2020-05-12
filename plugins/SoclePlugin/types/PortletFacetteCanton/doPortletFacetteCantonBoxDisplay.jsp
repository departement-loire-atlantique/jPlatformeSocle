<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file='/jcore/doInitPage.jspf' %>
<%@ include file='/jcore/portal/doPortletParams.jspf' %>
<%@ taglib prefix="ds" tagdir="/WEB-INF/tags"%>
<%
	PortletFacetteCanton obj = (PortletFacetteCanton) portlet;

	String rechercheId = (String) request.getAttribute("rechercheId");
%>

<ds:facetteAutoCompletion idFormElement='<%= ServletUtil.generateUniqueDOMId(request, glp("jcmsplugin.socle.facette.form-element")) %>' 
		name='<%= "canton" + glp("jcmsplugin.socle.facette.form-element") + "-" + rechercheId + obj.getId() %>' 
		request="<%= request %>" 
		obj="<%= obj %>" 
		dataMode="select-only" 
		dataUrl="plugins/SoclePlugin/jsp/facettes/acSearchPublication.jsp?query=types%3Dgenerated.Canton&sort=title" 
		label='<%= Util.notEmpty(obj.getLabel()) ? obj.getLabel() : glp("jcmsplugin.socle.facette.canton.default-label") %>'/>