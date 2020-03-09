<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file='/jcore/doInitPage.jspf' %>
<%@ include file='/jcore/portal/doPortletParams.jspf' %>
<% 
	//PAS TERMINE !

	PortletFacetteCategoriesLiees obj = (PortletFacetteCategoriesLiees)portlet; 

	String idFormElement = ServletUtil.generateUniqueDOMId(request, glp("jcmsplugin.socle.facette.form-element"));
%>

<div class="ds44-form__container">
	<form>
		<div class="ds44-flex-container ds44-small-flex-col ds44-fieldContainer ds44-champsLies">
			<div class="ds44-posRel ds44-fg2">
				<label for='<%= idFormElement + "-1" %>' class="ds44-formLabel">
					<span class="ds44-labelTypePlaceholderLarge ds44-moveLabel">
						<%= Util.notEmpty(obj.getLabel()) ? obj.getLabel() : "Catégories principales"%>
						<%= obj.getFacetteObligatoire() ? "<sup aria-hidden=\"true\">*</sup>" : "" %>
					</span> 
					<input type="text" id="field1" class="ds44-inpLarge ds44-inpLarge--first" 
							<%= obj.getFacetteObligatoire() ? "required aria-required=\"true\"" : ""%> />
				</label>
			</div>
			<div class="ds44-posRel ds44-fg1">
				<div id='<%= idFormElement + "-2" %>' class="ds44-inpLarge ds44-inpLarge--last ds44-inputDisabled" role="listbox">
					<p role="heading" aria-level="2" class="ds44-formLabel ds44-moveLabel" id="titreChamp1">
						<span class="ds44-labelLarge"><%= glp("jcmsplugin.socle.facette.category-liees.label") %></span>
					</p>
					<button class="ds44-btnIco ds44-posAbs ds44-posRi ds44-btnOpen" type="button">
						<i class="icon icon-down" aria-hidden="true"></i>
						<span class="visually-hidden"><%= glp("jcmsplugin.socle.facette.category-liees.label") %></span>
					</button>
				</div>
			</div>
		</div>
	</form>
</div>