<%@ taglib uri="jcms.tld" prefix="jalios" %>
<%@ tag 
    pageEncoding="UTF-8"
    description="Génère le bloc html figure avec les images associées" 
    body-content="scriptless" 
    import="com.jalios.jcms.Channel, com.jalios.util.ServletUtil, com.jalios.util.Util,
        com.jalios.jcms.JcmsUtil, fr.cg44.plugin.socle.SocleUtils"
%>
<%@ attribute name="image"
    required="true"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="L'URL de l'image à afficher"
%>
<%@ attribute name="imageMobile"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="L'URL de l'image mobile"
%>
<%@ attribute name="legend"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Légende de l'image"
%>
<%@ attribute name="copyright"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Le copyright de l'image"
%>
<%@ attribute name="alt"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Le texte alternatif de l'image"
%>
<%@ attribute name="ariaLabel"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Le champ aria-label du bloc Picture"
%>
<%@ attribute name="figureCss"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Classes CSS du bloc Figure"
%>
<%@ attribute name="pictureCss"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Classes CSS du bloc Picture"
%>
<%@ attribute name="imgCss"
    required="false"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Classes CSS du bloc Img"
%>
<%@ attribute name="format"
    required="true"
    fragment="false"
    rtexprvalue="true"
    type="String"
    description="Le format de l'image principale"
%>

<%
boolean hasFigcaption = Util.notEmpty(legend) || Util.notEmpty(copyright);
String userLang = Channel.getChannel().getCurrentUserLang();
String uid = ServletUtil.generateUniqueDOMId(request, "uid");

String formattedImagePath = "";
String formattedMobilePath = "";

if (format.equals("principale") || format.equals("bandeau") ||format.equals("carree") ||format.equals("mobile")) {
  formattedMobilePath = SocleUtils.getUrlOfFormattedImageMobile(imageMobile);

  if (Util.isEmpty(formattedMobilePath)) {
    formattedMobilePath = SocleUtils.getUrlOfFormattedImageMobile(image);
  }
} else if (format.equals("carouselFull") ||format.equals("carouselMobile") ||format.equals("carouselCarree")) {
  formattedMobilePath = SocleUtils.getUrlOfFormattedImageCarouselAccueilMobile(imageMobile);

  if (Util.isEmpty(formattedMobilePath)) {
    formattedMobilePath = SocleUtils.getUrlOfFormattedImageCarouselAccueilMobile(image);
  }
} else {
  // défaut 
  formattedMobilePath = SocleUtils.getUrlOfFormattedImageMobile(imageMobile);

  if (Util.isEmpty(formattedMobilePath)) {
    formattedMobilePath = SocleUtils.getUrlOfFormattedImageMobile(image);
  }
}

switch(format) {

	case "principale" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImagePrincipale(image);
	  break;
	
	case "bandeau" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageBandeau(image);
	  break;
	
	case "carree" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageCarree(image);
	  break;
	
	case "mobile" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageMobile(image);
	  break;
	
	case "carouselFull" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageCarouselAccueilFull(image);
	  break;
	
	case "carouselMobile" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageCarouselAccueilMobile(image);
	  break;
	
	case "carouselCarree" :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImageCarouselAccueilCarree(image);
	  break;
	
	default :
	  formattedImagePath = SocleUtils.getUrlOfFormattedImagePrincipale(image);
}

String label = ariaLabel;
if (Util.isEmpty(label) && Util.notEmpty(legend) || Util.notEmpty(copyright)) {
  label = legend;
  if (Util.notEmpty(copyright)) {
    label += " ";
    label += JcmsUtil.glp(userLang, "jcmsplugin.socle.symbol.copyright") + " " + copyright;
  }
}
else {
  label = alt;
}

%>
<figure role="figure" class="<%= figureCss %>">
    <picture class="<%= pictureCss %>" alt='<%= Util.isEmpty(label) ? JcmsUtil.glp(userLang, "jcmsplugin.socle.illustration") : label %>'>
        <jalios:if predicate="<%= Util.notEmpty(formattedMobilePath) %>">
            <source media="(max-width: 36em)" srcset="<%=formattedMobilePath%>">
        </jalios:if>
        <source media="(min-width: 36em)" srcset="<%=formattedImagePath%>">
        <img src="<%=formattedImagePath%>" alt='<%= Util.isEmpty(alt) ? JcmsUtil.glp(userLang, "jcmsplugin.socle.illustration") : alt %>' class="<%= imgCss %>" id="<%=uid%>"/>
    </picture>
    
    <jalios:if predicate="<%= hasFigcaption%>">
        <figcaption class="ds44-imgCaption">
            <jalios:if predicate="<%= Util.notEmpty(legend)%>">
                <%=legend%>
            </jalios:if>
            <jalios:if predicate="<%= Util.notEmpty(copyright)%>">
                <%= JcmsUtil.glp(userLang, "jcmsplugin.socle.symbol.copyright") %> <%=copyright%>
            </jalios:if>
        </figcaption>
        </figure>
    </jalios:if>
</figure>