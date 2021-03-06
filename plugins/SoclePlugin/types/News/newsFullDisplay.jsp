<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file='/jcore/doInitPage.jsp'%>
<%
News obj = (News) request.getAttribute(PortalManager.PORTAL_PUBLICATION);

// Catégorie Actualités
Category newsCategory = channel.getCategory("$plugin.socle.newsPortalCategoryId");
boolean isNewCategory = false;
  
if(jcmsContext.getCurrentCategory().equals(newsCategory)) isNewCategory = true;

//Stockage des catégories
List<Category> listCatThematiques= new ArrayList<Category>();
listCatThematiques.addAll(obj.getNewsThematics(loggedMember));
listCatThematiques.addAll(obj.getOthersNewsThematics(loggedMember));

%>  

<div class="news-page-actualite-full-display">
    <%--<ds:tag objs="<%=listCatThematiques %>"/>-->
	<%--<ds:title obj="<%=obj%>" title="test" css="testA testB" level="" edit="true"/>-->	
	
	<%--TODO Redirection vers le sommaire ou le dossier--%>
    
    <%-- Date --%>
    <div class="date"><p><jalios:date locale="<%= userLocale %>" format="dd/MM/yy" date="<%=obj.getPdate()%>" /></p></div>

    <div class="clear"></div>
    <%-- Bloc d'introduction --%>
    <div class="introduction visible-desktop printOnly row-fluid">
		<div class="span6 abstract"><jalios:wiki><%=obj.getAbstract()%></jalios:wiki><jalios:edit pub="<%=obj%>" fields="description" /></div>
		<div class="span6 illustration printHide">
		  <%--<ds:figure image="<%=obj.getMainIllustration()%>" legend="<%=obj.getMainIllustrationLegend()%>" copyright="<%= obj.getMainIllustrationCopyright()%>" link=""/>-->
		</div>
	</div>

	<div class="content"><jalios:wysiwyg><%=obj.getDescription1()%></jalios:wysiwyg><jalios:edit pub="<%=obj%>" fields="description1" /></div>
	
	<%--TODO Redirection vers le sommaire ou le dossier--%>

</div>