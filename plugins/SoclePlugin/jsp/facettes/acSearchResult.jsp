<%@page import="fr.cg44.plugin.socle.comparator.TypesComparator"%>
<%@page import="fr.cg44.plugin.socle.SocleUtils"%>
<%@page import="com.jalios.jcms.handler.QueryHandler"%><%
%><%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%><%
%><%@page import="com.google.gson.JsonObject"%><%
%><%@page import="com.google.gson.JsonArray"%><%

request.setAttribute("inFO", Boolean.TRUE);

%><%@ include file='/jcore/doInitPage.jspf' %><%
response.setContentType("application/json");

PortletSearch portletSearch = (PortletSearch) channel.getPublication(channel.getProperty("jcmsplugin.socle.recherche.portletsearch.id"));
String defaultfoQuerySort = Util.getString(channel.getProperty("query.sort.fo"), "relevance");
String foQuerySortParam = getAlphaNumParameter("sort", defaultfoQuerySort);


String textSearch = getStringParameter("q", "", ".*");


QueryHandler qh = new QueryHandler(portletSearch.getQuery());
qh.setCheckPstatus(true);
qh.setText(textSearch);
qh.setSort(foQuerySortParam);
qh.setSearchInFiles(Util.arrayContains(portletSearch.getSearchIn(), "searchInFiles"));
QueryResultSet collection = qh.getResultSet();

Comparator scoreTypeComparator = QueryResultSet.getScoreComparator(collection, new TypesComparator());
SortedSet<Publication> resultSet = new TreeSet<Publication>(scoreTypeComparator);
resultSet.addAll(collection);


%><% 
%><%= SocleUtils.publicationToJsonArray(resultSet) %>