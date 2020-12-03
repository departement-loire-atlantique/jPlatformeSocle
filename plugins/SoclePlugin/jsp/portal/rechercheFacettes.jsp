<%@ include file='/jcore/doInitPage.jspf' %><%
%><%@ include file='/jcore/portal/doPortletParams.jspf'  %><% 
  PortalJspCollection box = (PortalJspCollection) portlet;
  ServletUtil.backupAttribute(pageContext , "ShowChildPortalElement");
  
%>
<%@ include file='/types/AbstractCollection/doIncludePortletCollection.jspf'%>

<%
  ServletUtil.restoreAttribute(pageContext , "ShowChildPortalElement");
%>

<%= getPortlet(bufferMap,"header") %>

<main role="main" id="content" class="ds44-mainResults">

<jalios:include target="SOCLE_ALERTE"/>

<section class="ds44-container-large">
    <jalios:include id='<%= request.getParameter("boxId" + glp("jcmsplugin.socle.facette.form-element") + "[value]") %>' />
 </section>      
</main>

<footer role="contentinfo">
    <%= getPortlet(bufferMap,"footer") %>
    <%= getPortlet(bufferMap,"footerNavigation") %>
    <p id="backToTop" class="ds44-posRi ds44-hide-mobile ds44-btn-fixed ds44-js-button-sticky" data-is-delayed="true">
        <a class="ds44-icoLink ds44-icoLink--footer" href="#top"><i class="icon icon-arrow-up icon--sizeXL" aria-hidden="true"></i><span class="ds44-icoTxtWrapper"><%= glp("jcmsplugin.socle.hautDepage")%></span></a>
    </p>
</footer>
