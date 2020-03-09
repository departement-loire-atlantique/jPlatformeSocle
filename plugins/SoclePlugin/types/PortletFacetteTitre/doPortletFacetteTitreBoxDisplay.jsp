<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file='/jcore/doInitPage.jspf' %>
<%@ include file='/jcore/portal/doPortletParams.jspf' %>
<% 
	PortletFacetteTitre obj = (PortletFacetteTitre)portlet; 
	
	String idFormElement = ServletUtil.generateUniqueDOMId(request, glp("jcmsplugin.socle.facette.form-element"));
	String dataMode = "free-text";
	String query = "";
	if(Util.notEmpty(request.getAttribute("query"))) {
		query = (String)(request.getAttribute("query"));
	}
	String dataUrl = "plugins/SoclePlugin/jsp/facettes/acSearchPublication.jsp?query="+query;
	String name= "titre";
	String label = Util.notEmpty(obj.getLabel()) ? obj.getLabel() : glp("jcmsplugin.socle.facette.titre.default-label");
	String option = "";
	TreeSet<Category> setRayons = new TreeSet<Category>();
%>

<%@ include file='/plugins/SoclePlugin/jsp/portlet/portletFacetteAutoCompletion.jspf' %>