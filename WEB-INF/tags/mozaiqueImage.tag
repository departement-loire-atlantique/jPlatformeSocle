<%@tag import="com.jalios.jcms.context.JcmsContext"%>
<%@tag import="com.jalios.util.Browser"%>
<%@ taglib uri="jcms.tld" prefix="jalios" %>
<%@ tag 
    pageEncoding="UTF-8"
    description="Image de mozaïque" 
    body-content="scriptless" 
    import="com.jalios.jcms.Channel, com.jalios.util.Util"
%>
<%@ attribute name="image"
    required="true"
    fragment="false"
    rtexprvalue="true"
    type="generated.CarouselElement"
    description="Image affichée"
%>
<%@ attribute name="style"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Style additionnel"
%>
<%
	String userLang = Channel.getChannel().getCurrentJcmsContext().getUserLang();
	JcmsContext jcmsContext = Channel.getChannel().getCurrentJcmsContext();
%>
<figure class="ds44-legendeContainer ds44-container-imgRatio ds44-container-imgZoom <%= style %>" data-target="#overlay-mosaique" data-js="ds44-modal">
	<img src="<%= SocleUtils.getUrlImageElementCarousel(image, userLang, jcmsContext) %>" alt="" class="ds44-imgRatio">
	<figcaption class="ds44-imgCaption">
		<%= JcmsUtil.glp(userLang,"jcmsplugin.socle.diaporama.titre", sdfTuiles.format(image.getPdate()), image.getTitle(userLang, false)) %>
		<br /><%= JcmsUtil.glp(userLang,"jcmsplugin.socle.symbol.copyright") %> <%= image.getImageLegend(userLang, false) %>
	</figcaption>
</figure>