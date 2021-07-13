<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file='/jcore/doInitPage.jspf' %>
<%@ include file='/jcore/portal/doPortletParams.jspf' %>
<%@ include file='/plugins/SoclePlugin/jsp/facettes/commonParamsFacettes.jspf' %>
<%@ taglib prefix="ds" tagdir="/WEB-INF/tags"%>
<% 
	PortletFacetteCategorie obj = (PortletFacetteCategorie)portlet; 

	String rechercheId = (String) request.getAttribute("rechercheId");
	
	String idFormElement = glp("jcmsplugin.socle.facette.form-element") + "-" + rechercheId + obj.getId();
	

%>

<ds:facetteCategorie obj='<%= obj %>' 
		listeCategory='<%= obj.getCategoriesRacines(loggedMember) %>' 
		idFormElement='<%= idFormElement %>' 
		isDisabled='<%= false %>' 
		request='<%= request %>' 
		selectionMultiple='<%= obj.getTypeDeSelection() %>' 
		profondeur='<%= obj.getProfondeur() %>'
		isSizeStd='<%= isInRechercheFacette %>'/>
		


<jalios:foreach collection='<%= obj.getCategoriesRacines(loggedMember) %>' name="itRootCat" type="Category">
    <input type="hidden" name='<%= "cidBranches" + idFormElement + itCounter %>' value='<%= itRootCat.getId() %>' data-technical-field />
</jalios:foreach>