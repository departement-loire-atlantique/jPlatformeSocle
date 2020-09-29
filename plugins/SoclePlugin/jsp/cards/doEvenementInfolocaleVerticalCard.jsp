<%@page import="fr.cg44.plugin.socle.infolocale.entities.DateInfolocale"%>
<%@page import="fr.cg44.plugin.socle.infolocale.util.InfolocaleUtil"%>
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

EvenementInfolocale itEvent = (EvenementInfolocale) data;

DateInfolocale currentDisplayedDate = InfolocaleUtil.getClosestDate(itEvent);

String urlPhoto = InfolocaleUtil.getUrlOfLargestPicture(itEvent);

%>

<section class="ds44-card ds44-js-card ds44-card--contact ds44-box ds44-bgGray  ">
    <jalios:if predicate="<%= Util.notEmpty(urlPhoto) %>">
		<picture class="ds44-container-imgRatio">
		   <img src="<%= urlPhoto %>" alt="" class="ds44-imgRatio">
		</picture>
	</jalios:if>
    
    <div class="ds44-card__section">
      <div class="ds44-innerBoxContainer">
          <p role="heading" aria-level="3" class="h4-like ds44-cardTitle"><a href="<%= itEvent.getDisplayUrl(userLocale) %>" class="ds44-card__globalLink"><%= itEvent.getTitre() %></a></p>
          <hr class="mbs" aria-hidden="true">
          <p class="ds44-docListElem ds44-mt-std">
            <i class="icon icon-date ds44-docListIco" aria-hidden="true"></i>
            <jalios:if predicate="<%= Util.notEmpty(currentDisplayedDate) %>">
	            <jalios:select>
	                <jalios:if predicate="<%= InfolocaleUtil.infolocaleDateIsSingleDay(currentDisplayedDate) %>">
	                    <%= InfolocaleUtil.getDayOfMonthLabel(currentDisplayedDate.getDebut()) %> <%= InfolocaleUtil.getMonthLabel(currentDisplayedDate.getDebut(), false) %>
	                </jalios:if>
	                <jalios:default>
	                    <%= InfolocaleUtil.getDayOfMonthLabel(currentDisplayedDate.getDebut()) %> <%= InfolocaleUtil.getMonthLabel(currentDisplayedDate.getDebut(), false) %>
	                    -
	                    <%= InfolocaleUtil.getDayOfMonthLabel(currentDisplayedDate.getFin()) %> <%= InfolocaleUtil.getMonthLabel(currentDisplayedDate.getFin(), false) %>
	                </jalios:default>
	            </jalios:select>
            </jalios:if>
          </p>
             <jalios:if predicate="<%= Util.notEmpty(itEvent.getMetadataDefaultContent()) %>">
	            <p class="ds44-cardLocalisation"><i class="icon <%= itEvent.getMetadataDefaultIcon() %>" aria-hidden="true"></i><span class="visually-hidden"><%= itEvent.getMetadataHiddenLabel() %></span>
	               <span class="ds44-iconInnerText"><%= itEvent.getMetadataDefaultContent() %></span>
	            </p>
	         </jalios:if>
	         <jalios:if predicate="<%= Util.notEmpty(itEvent.getMetadata1()) %>">
	            <p><%= itEvent.getMetadata1() %></p>
	         </jalios:if>
	         <jalios:if predicate="<%= Util.notEmpty(itEvent.getMetadata2()) %>">
	            <p><%= itEvent.getMetadata2() %></p>
	         </jalios:if>
      </div>
      <i class="icon icon-arrow-right ds44-cardArrow" aria-hidden="true"></i>
    </div>
</section>
