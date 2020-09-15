<%@ include file='/jcore/doInitPage.jspf' %><%
%><%@ include file='/jcore/portal/doPortletParams.jspf' %><%

PortletLogin box = (PortletLogin) portlet;
PortalInterface loginPortal = box.getDisplayPortal() != null ? box.getDisplayPortal() : portal;

Publication obj = (Publication)request.getAttribute(PortalManager.PORTAL_PUBLICATION); 

// A la connexion r�ussie redirection vers cette publication
Publication pubRedirect = channel.getPublication("$jcmsplugin.socle.login.redirect.pub");
if(Util.isEmpty(pubRedirect)) {
	pubRedirect = obj;
}

ControlSettings loginSettings = new TextFieldSettings().placeholder(box.getLoginText(userLang));
ControlSettings passwordSettings = new PasswordSettings().placeholder(box.getPasswordText(userLang));
ControlSettings persistentSettings = new EnumerateSettings().checkbox().multiple().enumValues("true").enumLabels("ui.fo.login.lbl.remember");

%>



<div class="ds44-box ds44-theme mbm">

<div class="ds44-innerBoxContainer">
    <form action='plugins/SoclePlugin/jsp/facettes/displayResultDecodeParams.jsp' method='post' name='login' class='form-horizontal login-form'>
        <fieldset>
            <legend class="ds44-box-heading ds44-mb-std"><%= glp("jcmsplugin.socle.form.login.legend") %></legend>
            
            <%@ include file='/plugins/SoclePlugin/jsp/doMessageBoxCustom.jspf' %>
            
            <p><%= glp("jcmsplugin.socle.facette.champs-obligatoires") %></p>
            
            <jalios:include target="PORTLET_LOGIN_FORM_HEADER" targetContext="div" />
            
            <div class="ds44-mb3">                     
                <div class="ds44-form__container">
	                <div class="ds44-posRel">
					    <label for=login class="ds44-formLabel"><span class="ds44-labelTypePlaceholder"><span><%= glp("jcmsplugin.socle.faq.votre-email") %><sup aria-hidden="true"><%= glp("jcmsplugin.socle.facette.asterisque") %></sup></span></span></label>				    
					    <input type="email" id="login" name='<%= channel.getAuthMgr().getLoginParameter() %>' class="ds44-inpStd" title='<%= glp("jcmsplugin.socle.facette.champ-obligatoire.title", glp("jcmsplugin.socle.faq.votre-email")) %>' required aria-describedby="explanation-form-element-login" /><button class="ds44-reset" type="button"><i class="icon icon-cross icon--sizeL" aria-hidden="true"></i><span class="visually-hidden"><%= glp("jcmsplugin.socle.facette.effacer-contenu-champ", glp("jcmsplugin.socle.faq.votre-email")) %></span></button>								
					</div>

                    <div class="ds44-field-information" aria-live="polite">
				        <ul class="ds44-field-information-list ds44-list">
				            <li id="explanation-form-element-login" class="ds44-field-information-explanation"><%= glp("jcmsplugin.socle.form.exemple.email") %></li>
				        </ul>
				    </div>
                </div>
            </div>
            
            
            <div class="ds44-mb3">
                <div class="ds44-form__container">
                
                    <div class="ds44-posRel">
					    <label for="password" class="ds44-formLabel"><span class="ds44-labelTypePlaceholder"><span><%= glp("ui.fo.login.lbl.passwd") %><sup aria-hidden="true"><%= glp("jcmsplugin.socle.facette.asterisque") %></sup></span></span></label>					    
					    <input type="text" id="password" name="JCMS_password" class="ds44-inpStd" title='<%= glp("jcmsplugin.socle.facette.champ-obligatoire.title", glp("ui.fo.login.lbl.passwd")) %>'  required    /><button class="ds44-reset" type="button"><i class="icon icon-cross icon--sizeL" aria-hidden="true"></i><span class="visually-hidden"><%= glp("jcmsplugin.socle.facette.effacer-contenu-champ", glp("ui.fo.login.lbl.passwd")) %></span></button>										
					</div>
                </div>
            </div>
            
            
            <div>
                <div id="form-element-95779" data-name="form-element-95779" class="ds44-form__checkbox_container ds44-form__container" >
                    <div class="ds44-form__container ds44-checkBox-radio_list ">
					    <input type="checkbox" id="name-check-form-element-95779-connect" name="<%= channel.getAuthMgr().getPersistentParameter() %>" value="true" class="ds44-checkbox"/><label for="name-check-form-element-95779-connect" class="ds44-boxLabel" id="name-check-label-form-element-95779-connect"><%= glp("jcmsplugin.socle.form.login.memoriser") %></label>					    									
					</div>
                </div>
            </div>
            
            
            
            <input type='hidden' name="redirectUrl" value='<%= obj.getDisplayUrl(userLocale) %>' data-technical-field/>
            <input type='hidden' name='redirect' value='<%= pubRedirect.getDisplayUrl(userLocale) %>' data-technical-field/>
            <input type='hidden' name='jsp' value='<%= obj.getDisplayUrl(userLocale) %>' data-technical-field/>
            <input type="hidden" name="csrftoken" value="<%= HttpUtil.getCSRFToken(request) %>" data-technical-field>
            
            
            
            <button type='submit' name='<%= channel.getAuthMgr().getOpLoginParameter() %>' class="ds44-btnStd ds44-btn--invert ds44-bntFullw ds44-bntALeft ds44-mtb1" title='<%= glp("jcmsplugin.socle.form.login.valid-compte") %> '>
                <span class="ds44-btnInnerText"><%= glp("jcmsplugin.socle.valider") %></span><i class="icon icon-long-arrow-right" aria-hidden="true"></i>
            </button>
            
<!--             <p class="ds44-noMrg"><a href="#">Mot de passe oubli� ?</a></p> -->
        </fieldset>
    </form>
    
    <jalios:include target="PORTLET_LOGIN_FORM_FOOTER" targetContext="div" />
    
</div>

</div>


