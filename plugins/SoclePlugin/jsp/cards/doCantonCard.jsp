<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="fr.cg44.plugin.socle.SocleUtils"%>
<%@ taglib prefix="ds" tagdir="/WEB-INF/tags"%>
<%@ include file='/jcore/doInitPage.jspf' %><%
%><%@ page import="com.jalios.jcms.taglib.card.*" %><%
%><%@ include file='/jcore/media/mediaTemplateInit.jspf' %><%
%><%

if (data == null) {
  return;
}

Canton pub = (Canton) data;

Set<Publication> referencedElus = new TreeSet<>(ElectedMember.getComparator("nom", true));
referencedElus.addAll(pub.getLinkIndexedDataSet(ElectedMember.class));

%>

<section class="ds44-card ds44-js-card ds44-card--contact ds44-bgGray">
    <div class="ds44-card__section">
        <div class="ds44-innerBoxContainer">
            <h3 class="h4-like ds44-cardTitle" id="7"><a href="<%= pub.getDisplayUrl(userLocale) %>" class="ds44-card__globalLink"><%= pub.getTitle() %></a></h3>
            <jalios:if predicate="<%= Util.notEmpty(referencedElus) %>">
	            <hr class="mbs" aria-hidden="true">
	            <p class="ds44-docListElem ds44-mt-std"><i class="icon icon-user ds44-docListIco" aria-hidden="true"></i>
	            <jalios:foreach name="itElu" type="ElectedMember" collection="<%= referencedElus %>" counter="itCounter">
	               <%
	               String fullName = "";

	               if (Util.notEmpty(itElu.getFirstName())) fullName = itElu.getFirstName();
	               if (Util.notEmpty(itElu.getNom())) {
	                 if (Util.notEmpty(itElu.getFirstName())) fullName += " ";
	                 fullName += itElu.getNom();
	               }
	               
	               String conseillerLabel = "";
	               if (Util.notEmpty(itElu.getFunctions(loggedMember))) {
	                 if (itElu.getFunctions(loggedMember).contains(channel.getCategory("$jcmsplugin.socle.elu.conseiller"))) {
	                   conseillerLabel = itElu.getGender() ? glp("jcmsplugin.socle.elu.conseiller.masculin") : glp("jcmsplugin.socle.elu.conseiller.feminin");
	                 }
	               }
	               %>
	               <jalios:if predicate="<%= Util.notEmpty(fullName) && Util.notEmpty(conseillerLabel) %>">
	                   <strong><%= conseillerLabel %></strong> : <%= fullName %>
	                   <jalios:if predicate="<%= itCounter < referencedElus.size() %>">
	                       <br/>
	                   </jalios:if>
	               </jalios:if>
	            </jalios:foreach>
	            </p>
	            </jalios:if>
        </div>
        <i class="icon icon-arrow-right ds44-cardArrow" aria-hidden="true"></i>
    </div>
</section>