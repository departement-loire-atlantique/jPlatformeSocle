<%@ include file='/jcore/doInitPage.jspf' %>
<%@ include file='/jcore/portal/doPortletParams.jspf' %>
<%@ include file='/types/PortletNavigate/doInitPortletNavigate.jspf' %>

<%-- SGU : inspir� de doPortletNavigateLocation.jsp
    On adapte la liste au design system et on g�re les extradatas de cat�gories (libell�, target)
    Les liens pointent vers les cat�gories. Un portalPolicyFilter s'occupe de rediriger vers le
    bon contenu.
--%>
        
<%
List<Category> ancestors  = currentCategory.getAncestorList();
	
for (Iterator<Category> it = rootCategory.getAncestorList().iterator() ; it.hasNext() ;) {
  ancestors.remove(it.next());
}

if (Util.isEmpty(ancestors) && box.getHideWhenNoResults()) {
  request.setAttribute("ShowPortalElement",Boolean.FALSE);
  return;
}

Collections.reverse(ancestors);

	
String nofollow = box.getNavigatePortlet() ? "" : "rel='nofollow'";
int counter = 0;
String libelleCat = "";
String cible="";
String libelleCible = "";
String textColorStyle = "";

// texte du breadcrumb clair/sombre
if(Util.notEmpty(request.getAttribute("textColor"))){
	textColorStyle = "ds44-text--colorInvert";
}
%>

<nav role="navigation" aria-label='<%=glp("jcmsplugin.socle.breadcrumb.position")%>' class="ds44-hide-smallScreens">
	<ul class="ds44-list <%=textColorStyle%>">
	    <li class="ds44-breadcrumb"><a href="index.jsp"><i class="icon icon-home icon--medium"></i><span class="visually-hidden">Accueil</span></a></li>
	    <jalios:foreach collection="<%= ancestors %>" type="Category" name="itCategory">
	            <jalios:if predicate='<%= itCategory.canBeReadBy(loggedMember , true, true) %>'>
	                <%
	            	if((itCategory.hasAncestor(rootCategory) || itCategory.equals(rootCategory)) && (counter < box.getLevels()-1)) {
	            		libelleCat = Util.notEmpty(itCategory.getExtraData("extra.Category.plugin.tools.synonyme.facet.title")) ? itCategory.getExtraData("extra.Category.plugin.tools.synonyme.facet.title") : itCategory.getName(userLang);
	            		boolean targetBlank = "true".equals(itCategory.getExtraData("extra.Category.plugin.tools.blank")) ? true : false;
	            		if(targetBlank){
	            			cible="target=\"_blank\"";
	            			libelleCible = glp("jcmsplugin.socle.accessibily.newTabLabel");
	            		}
		           %>
	    
				    <li class="ds44-breadcrumb">
				        <a <%= nofollow %> href='<%= PortalManager.getUrlWithUpdateCtxCategories(itCategory , ctxCategories, request , !box.getNavigatePortlet()) %>' <%=cible%> title="<%=libelleCat%><%=libelleCible%>"><%= libelleCat %></a>
				    </li>
				    <% counter++; %>
				  <% } %>
	        </jalios:if>
	    </jalios:foreach>
	    <li class="ds44-breadcrumb" aria-current="location">
            <%= Util.notEmpty(currentCategory.getExtraData("extra.Category.plugin.tools.synonyme.facet.title")) ? currentCategory.getExtraData("extra.Category.plugin.tools.synonyme.facet.title") : currentCategory.getName(userLang) %>
        </li>
	</ul>
</nav>

<% 
if (counter == 0) {
  request.setAttribute("ShowPortalElement",Boolean.FALSE);
}
%>
