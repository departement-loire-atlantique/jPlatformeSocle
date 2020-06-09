package fr.cg44.plugin.socle.infolocale;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.jalios.jcms.Channel;
import com.jalios.util.Util;

import fr.cg44.plugin.socle.SocleUtils;
import fr.cg44.plugin.socle.infolocale.entities.Commune;
import fr.cg44.plugin.socle.infolocale.entities.Contact;
import fr.cg44.plugin.socle.infolocale.entities.DateInfolocale;
import fr.cg44.plugin.socle.infolocale.entities.DossierPresse;
import fr.cg44.plugin.socle.infolocale.entities.Genre;
import fr.cg44.plugin.socle.infolocale.entities.Langue;
import fr.cg44.plugin.socle.infolocale.entities.Lieu;
import fr.cg44.plugin.socle.infolocale.entities.Photo;
import fr.cg44.plugin.socle.infolocale.util.InfolocaleUtil;
import generated.EvenementInfolocale;
import generated.PortletAgendaInfolocale;


/**
 * Ensemble de méthodes utilisées pour la gestion de données Infolocales
 * @author lchoquet
 *
 */
public class InfolocaleEntityUtils {
    
    private InfolocaleEntityUtils() {}
    
    private static final Logger LOGGER = Logger.getLogger(InfolocaleEntityUtils.class);
    
    /**
     * Créé un tableau d'évenements infolocale à partir de JSON
     * @param jsonArray
     * @return
     */
    public static EvenementInfolocale[] createEvenementInfolocaleArrayFromJsonArray(JSONArray jsonArray) {
      return createEvenementInfolocaleArrayFromJsonArray(jsonArray, null, null);
    }
    
    /**
     * Créé un tableau d'évenements infolocale à partir de JSON
     * @param jsonArray
     * @param metadata1
     * @param metadata2
     * @return
     */
    public static EvenementInfolocale[] createEvenementInfolocaleArrayFromJsonArray(JSONArray jsonArray, String metadata1, String metadata2) {
        EvenementInfolocale[] itEvents = new EvenementInfolocale[jsonArray.length()];
        for (int counter = 0; counter < jsonArray.length(); counter++) {
            try {
                itEvents[counter] = createEvenementInfolocaleFromJsonItem(jsonArray.getJSONObject(counter), metadata1, metadata2);
            } catch (JSONException e) {
                LOGGER.error("Erreur in createEvenementInfolocaleArrayFromJsonArray: " + e.getMessage());
            }
        }
        return itEvents;
    }
    
    /**
     * Créé un événement infolocale depuis du JSON
     * @param json
     * @return
     */
    public static EvenementInfolocale createEvenementInfolocaleFromJsonItem(JSONObject json) {
      return createEvenementInfolocaleFromJsonItem(json, null, null);
    }
    
    /**
     * Créé un événement infolocale depuis du JSON
     * @param json
     * @param metadata1
     * @param metadata2
     * @return
     */
    public static EvenementInfolocale createEvenementInfolocaleFromJsonItem(JSONObject json, String metadata1, String metadata2) {
        if (Util.isEmpty(json)) return null;
        
        EvenementInfolocale itEvent = new EvenementInfolocale();
        
        try {
            itEvent.setId("INFOLOC-"+json.getInt("id"));
            itEvent.setEvenementId(json.getInt("id"));
            if (Util.notEmpty(json.get("organismeId")) && !(json.get("organismeId").toString().equals("null"))) {
              itEvent.setOrganismeId(json.getInt("organismeId"));
            }
            itEvent.setTitre(json.getString("titre"));
            itEvent.setTitreSlug(json.getString("titreSlug"));
            itEvent.setDescription(json.getString("descriptif"));
            itEvent.setDateCreation(json.getString("dateCreation"));
            itEvent.setDateModification(json.getString("dateModification"));
            if (Util.notEmpty(json.get("lieu"))) {
                itEvent.setLieu(createLieuFromJsonItem(json.getJSONObject("lieu")));
                // Ajout de la longitude / latitute en extradata pour s'afficher sur les cartes comme les autres publications JCMS
                itEvent.setExtraData("extra.EvenementInfolocale.plugin.tools.geolocation.longitude", itEvent.getLieu().getLongitude());
                itEvent.setExtraData("extra.EvenementInfolocale.plugin.tools.geolocation.latitude", itEvent.getLieu().getLatitude());
            }
            JSONArray tarifs = json.getJSONArray("tarifs");
            if (tarifs.length() > 0) {
              JSONObject tmpTarif = tarifs.getJSONObject(0);
              itEvent.setGratuit(tmpTarif.getBoolean("gratuit"));
              itEvent.setTarifNormal(tmpTarif.getString("tarif"));
              itEvent.setTarifReduit(tmpTarif.getString("tarifReduit"));
              itEvent.setTarifAutre(tmpTarif.getString("tarifAutre"));
            }
            JSONArray billetteries = json.getJSONArray("billetteries");
            if (billetteries.length() > 0) {
              JSONObject billetterie = billetteries.getJSONObject(0);
              itEvent.setUrlBilletterie(billetterie.getString("url"));
            }
            JSONArray donneesComplementaires = json.getJSONArray("donneesComplementaires");
            if (donneesComplementaires.length() > 0) {
              JSONObject tmpDonnees = donneesComplementaires.getJSONObject(0);
              if (!tmpDonnees.isNull("titreLibre")) itEvent.setTitreLibre(tmpDonnees.getString("titreLibre"));
              if (!tmpDonnees.isNull("texteCourt")) itEvent.setTexteCourt(tmpDonnees.getString("texteCourt"));
              if (!tmpDonnees.isNull("texteLong")) itEvent.setTexteLong(tmpDonnees.getString("texteLong"));
            }
            JSONArray ressources = json.getJSONArray("ressources");
            if (ressources.length() > 0) {
              List<String> urlVideos = new ArrayList<>();
              List<DossierPresse> listDossiers = new ArrayList<>();
              for (int ressourceCounter = 0; ressourceCounter < ressources.length(); ressourceCounter++) {
                JSONObject itRessource = ressources.getJSONObject(ressourceCounter);
                switch (itRessource.getString("type")) {
                  case "video" :
                    urlVideos.add(itRessource.getString("url"));
                    break;
                  case "dossier_presse" :
                    DossierPresse itDossier = new DossierPresse();
                    itDossier.setUrl(itRessource.getString("url"));
                    itDossier.setFilename(SocleUtils.getFilenameFromUrl(itRessource.getString("url")));
                    itDossier.setFormat(SocleUtils.getFileExpensionFromUrl(itRessource.getString("url")));
                    listDossiers.add(itDossier);
                    break;
                }
              }
              itEvent.setUrlVideos(urlVideos);
              itEvent.setDossiersDePresse(listDossiers);
            }
            if (Util.notEmpty(json.get("dates"))) {
                itEvent.setDates(createDateArrayFromJsonArray(json.getJSONArray("dates")));
            }
            itEvent.setDateString(json.getString("dateString"));
            if (Util.notEmpty(json.get("contacts"))) {
                itEvent.setContacts(createContactArrayFromJsonArray(json.getJSONArray("contacts")));
            }
            itEvent.setReservation(json.getString("reservation"));
            itEvent.setProvider(json.getString("provider"));
            if (Util.notEmpty(json.get("genre"))) {
                itEvent.setGenre(createGenreFromJsonItem(json.getJSONObject("genre")));
            }
            if (Util.notEmpty(json.get("photos"))) {
                itEvent.setPhotos(createPhotosArrayFromJsonArray(json.getJSONArray("photos")));
            }
            itEvent.setAgeMinimum(json.getInt("ageMinimum"));
            itEvent.setAgeMaximum(json.getInt("ageMaximum"));
            if (json.getJSONArray("categoriesAge").length() > 0) {
              JSONArray jsonAgeArray = json.getJSONArray("categoriesAge");
              String[] tmpCatAge = new String[jsonAgeArray.length()];
              for (int countArrayAge = 0; countArrayAge < jsonAgeArray.length(); countArrayAge++) {
                tmpCatAge[countArrayAge] = jsonAgeArray.getJSONObject(countArrayAge).getString("libelle");
              }
              itEvent.setCategorieDage(tmpCatAge);
            }
            itEvent.setNombreDeParticipants(json.getInt("nombreParticipants"))  ;
            itEvent.setDuree(json.getInt("duree"));
            itEvent.setMentionEvenementComplet(json.getBoolean("mentionEvenementComplet"));
            itEvent.setMentionAccessibleHandicapAuditif(json.getBoolean("mentionAccessibleHandicapAuditif"));
            itEvent.setMentionAccessibleHandicapVisuel(json.getBoolean("mentionAccessibleHandicapVisuel"));
            itEvent.setMentionAccessibleHandicapMental(json.getBoolean("mentionAccessibleHandicapMental"));
            itEvent.setMentionAccessibleHandicapMoteur(json.getBoolean("mentionAccessibleHandicapMoteur"));
            if (Util.notEmpty(json.get("langues"))) {
                itEvent.setLangues(createLanguesArrayFromJsonArray(json.getJSONArray("langues")));
            }
            itEvent.setUrlAnnonce(json.getString("urlAnnonce"));
            itEvent.setUrlOrganisme(json.getString("urlOrganisme"));
            
            if (Util.notEmpty(metadata1)) {
              itEvent.setMetadata1(InfolocaleMetadataUtils.getMetadataHtml(metadata1, json));
            }
            if (Util.notEmpty(metadata2)) {
              itEvent.setMetadata2(InfolocaleMetadataUtils.getMetadataHtml(metadata2, json));
            }
        } catch (JSONException e) {
            LOGGER.error("Erreur in createEvenementInfolocaleFromJsonItem: " + e.getMessage());
            itEvent = new EvenementInfolocale();
        }
        
        return itEvent;
    }

    /**
     * Créé un tableau d'objets Langue depuis du JSON
     */
    public static Langue[] createLanguesArrayFromJsonArray(JSONArray jsonArray) {
        Langue[] langues = new Langue[jsonArray.length()];
        for (int counter = 0; counter < jsonArray.length(); counter++) {
            try {
                langues[counter] = createLangueFromJsonItem(jsonArray.getJSONObject(counter));
            } catch (JSONException e) {
                LOGGER.error("Erreur in createLanguesArrayFromJsonArray: " + e.getMessage());
            }
        }
        return langues;
    }

    /**
     * Créé un objet Langue depuis du JSON
     */
    public static Langue createLangueFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Langue langue = new Langue();
        try {
            langue.setLangueId(json.getString("langueId"));
            langue.setLangueLibelle(json.getString("langueLibelle"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createLangueFromJsonItem: " + e.getMessage());
            langue = new Langue();
        }
        return langue;
    }

    /**
     * Créé un tableau d'objets Photo depuis du JSON
     */
    public static Photo[] createPhotosArrayFromJsonArray(JSONArray jsonArray) {
        Photo[] photos = new Photo[jsonArray.length()];
        for (int counter = 0; counter < jsonArray.length(); counter++) {
            try {
                photos[counter] = createPhotoFromJsonItem(jsonArray.getJSONObject(counter));
            } catch (JSONException e) {
                LOGGER.error("Erreur in createPhotosArrayFromJsonArray: " + e.getMessage());
            }
        }
        return photos;
    }

    /**
     * Créé un objet Photo depuis du JSON
     */
    public static Photo createPhotoFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Photo photo = new Photo();
        try {
            photo.setPath(json.getString("path"));
            photo.setLegend(json.getString("legend"));
            photo.setCredit(json.getString("credit"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createPhotoFromJsonItem: " + e.getMessage());
            photo = new Photo();
        }
        return photo;
    }

    /**
     * Créé un objet Genre depuis du JSON
     */
    public static Genre createGenreFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Genre genre = new Genre();
        try {
            genre.setGenreId(json.getInt("id"));
            genre.setCategorie(json.getString("categorie"));
            genre.setLibelle(json.getString("libelle"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createGenreFromJsonItem: " + e.getMessage());
            genre = new Genre();
        }
        return genre;
    }

    /**
     * Créé un tableau d'objets Contact depuis du JSON
     */
    public static Contact[] createContactArrayFromJsonArray(JSONArray jsonArray) {
        Contact[] contacts = new Contact[jsonArray.length()];
        for (int counter = 0; counter < jsonArray.length(); counter++) {
            try {
                contacts[counter] = createContactFromJsonItem(jsonArray.getJSONObject(counter));
            } catch (JSONException e) {
                LOGGER.error("Erreur in createContactArrayFromJsonArray: " + e.getMessage());
            }
        }
        return contacts;
    }

    /**
     * Créé un object Contact depuis du JSON
     */
    public static Contact createContactFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Contact contact = new Contact();
        try {
            contact.setTypeId(json.getInt("typeId"));
            contact.setType(json.getString("type"));
            contact.setTelephone1(json.getString("telephone1"));
            contact.setTelephone2(json.getString("telephone2"));
            contact.setUrl(json.getString("url"));
            contact.setEmail(json.getString("email"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createContactFromJsonItem: " + e.getMessage());
            contact = new Contact();
        }
        return contact;
    }

    /**
     * Créé un tableau d'objets Date (infolocale) depuis du JSON
     */
    public static DateInfolocale[] createDateArrayFromJsonArray(JSONArray jsonArray) {
        DateInfolocale[] dates = new DateInfolocale[jsonArray.length()];
        for (int counter = 0; counter < jsonArray.length(); counter++) {
            try {
                dates[counter] = createDateFromJsonItem(jsonArray.getJSONObject(counter));
            } catch (JSONException e) {
                LOGGER.error("Erreur in createDateArrayFromJsonArray: " + e.getMessage());
            }
        }
        return dates;
    }

    /**
     * Créé un objet Date (infolocale) depuis du JSON
     */
    public static DateInfolocale createDateFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        DateInfolocale date = new DateInfolocale();
        try {
            date.setDebut(json.getString("debut"));
            date.setFin(json.getString("fin"));
            String tmpHoraireString = json.getString("horaire");
            StringBuilder horaireBuilder = new StringBuilder();
            boolean isReadingHoraire = false;
            if (Util.notEmpty(tmpHoraireString)) {
              for (Character itChar : tmpHoraireString.toCharArray()) {
                if (itChar.equals('{')) { // début d'un horaire
                  isReadingHoraire = true;
                  continue;
                }
                if (itChar.equals('}')) { // fin d'un horaire
                  isReadingHoraire = false;
                  continue;
                }
                if (itChar.equals(',') && isReadingHoraire) { // virgule au sein d'un horaire formatté autrement
                  horaireBuilder.append(" - ");
                  continue;
                }
                if (itChar.equals(',') && !isReadingHoraire) { // virgule séparant deux horaires formatté autrement
                  horaireBuilder.append(", ");
                  continue;
                }
                // Dans tous les autres cas, on concatène normalement
                horaireBuilder.append(itChar);
              }
            }
            date.setHoraire(horaireBuilder.toString().replace(":", "h"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createDateFromJsonItem: " + e.getMessage());
            date = new DateInfolocale();
        }
        return date;
    }

    /**
     * Créé un objet Lieu depuis du JSON
     */
    public static Lieu createLieuFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Lieu lieu = new Lieu();
        try {
            lieu.setNom(json.getString("nom"));
            lieu.setAdresse(json.getString("adresse"));
            lieu.setLongitude(json.getString("longitude"));
            lieu.setLatitude(json.getString("latitude"));
            if (Util.notEmpty(json.get("commune"))) {
                lieu.setCommune(createCommuneFromJsonItem(json.getJSONObject("commune")));
            }
        } catch (JSONException e) {
            LOGGER.error("Erreur in createLieuFromJsonItem: " + e.getMessage());
            lieu = new Lieu();
        }
        return lieu;
    }

    /**
     * Créé un objet Commune depuis du JSON
     */
    public static Commune createCommuneFromJsonItem(JSONObject json) {
        if (Util.isEmpty(json)) return null;
        Commune commune = new Commune();
        try {
            commune.setInsee(json.getString("insee"));
            commune.setNom(json.getString("nom"));
            commune.setSlug(json.getString("slug"));
            commune.setDepartement(json.getString("departement"));
            commune.setLatitude(json.getString("latitude"));
            commune.setLongitude(json.getString("longitude"));
            commune.setCodePostal(json.getString("codePostal"));
        } catch (JSONException e) {
            LOGGER.error("Erreur in createCommuneFromJsonItem: " + e.getMessage());
            commune = new Commune();
        }
        return commune;
    }
    
    /**
     * Effectue un filtre sur un tableau d'objets EvenementInfolocale à partir de paramètres
     */
    public static EvenementInfolocale[] filterEvenementInfolocaleArray(EvenementInfolocale[] arrayEvents, Map<String, Object> sortParameters) {
        
        if (Util.isEmpty(arrayEvents)) return new EvenementInfolocale[0];
        
        if (Util.isEmpty(sortParameters)) return arrayEvents;
        
        Integer resultatsMax;
        String exclusion;
        boolean accessibiliteMental;
        boolean accessibiliteMoteur;
        boolean accessibiliteVisuel;

        resultatsMax = Util.toInteger(sortParameters.get("resultatsMax"), Channel.getChannel().getIntegerProperty("jcmsplugin.socle.infolocale.limit", 20));
        exclusion = Util.getString(sortParameters.get("exclusion"), null);
        accessibiliteMental = Util.toBoolean(sortParameters.get("accessibiliteMental"), false);
        accessibiliteMoteur = Util.toBoolean(sortParameters.get("accessibiliteMoteur"), false);
        accessibiliteVisuel = Util.toBoolean(sortParameters.get("accessibiliteVisuel"), false);
        
        ArrayList<EvenementInfolocale> listEvents = new ArrayList<>(Arrays.asList(arrayEvents));
        
        for (Iterator<EvenementInfolocale> iter = listEvents.iterator(); iter.hasNext();) {
            EvenementInfolocale itEvent = iter.next();
            
            if (isEventFilteredOnAccessibilityAndId(itEvent, accessibiliteMental, accessibiliteMoteur, accessibiliteVisuel, exclusion)) {
                iter.remove();
            }
        }
        // Tronquer la liste de résultats en fonction du nombre maximum de résultats
        if (resultatsMax < listEvents.size()) {
            listEvents = new ArrayList<>(listEvents.subList(0, resultatsMax));
        }
        
        return listEvents.toArray(new EvenementInfolocale[listEvents.size()]);
    }
    
    private static boolean isEventFilteredOnAccessibilityAndId(EvenementInfolocale event, boolean accessibiliteMental, boolean accessibiliteMoteur, 
            boolean accessibiliteVisuel, String exclusion) {
        
        // filtre sur la mention d'accessibilité : handicap mental
        if (accessibiliteMental && !event.getMentionAccessibleHandicapMental()) {
            return true;
        }
        // filtre sur la mention d'accessibilité : handicap moteur
        if (accessibiliteMoteur && !event.getMentionAccessibleHandicapMoteur()) {
            return true;
        }
        // filtre sur la mention d'accessibilité : handicap visuel
        if (accessibiliteVisuel && !event.getMentionAccessibleHandicapVisuel()) {
            return true;
        }
        // filtre sur l'exclusion de certains IDs d'événements
        if (Util.notEmpty(exclusion) && exclusion.contains(Integer.toString(event.getEvenementId()))) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Retourne l'objet JSON associé à un événement depuis un JSONArray
     * @param event
     * @return
     */
    public static JSONObject getJsonObjectOfEvent(EvenementInfolocale event, JSONArray jsonArray) {
      if (Util.isEmpty(event) || Util.isEmpty(jsonArray) || Util.isEmpty(event.getId())) {
        return null;
      }
      
      Integer jsonEventId = Util.toInteger(event.getId().replace("INFOLOC-", ""), -1);
      
      for (int jsonArrayCounter = 0; jsonArrayCounter <= jsonArray.length(); jsonArrayCounter++) {
        JSONObject itJsonObject;
        try {
          itJsonObject = jsonArray.getJSONObject(jsonArrayCounter);
          if (jsonEventId == itJsonObject.getInt("id")) {
            return itJsonObject;
          }
        } catch (JSONException e) {
          LOGGER.warn("Exception in getJsonObjectOfEvent : " + e.getMessage());
        }
        
      }
      
      return null;
    }
    
    
    /**
     * Retourne le résulat des evenements en fonction de la requete
     * @param request
     * @return
     */
    public static List<EvenementInfolocale> getQueryEvent(HttpServletRequest request) {
      
      Channel channel = Channel.getChannel();  
      PortletAgendaInfolocale box = (PortletAgendaInfolocale) channel.getPublication(request.getParameter("boxId"));
      
      if(Util.isEmpty(request) || Util.isEmpty(box)) {
        return Collections.emptyList();
      }
                
      List<EvenementInfolocale> allEvents = Collections.emptyList();      
      Map<String, Object> parameters = new HashMap<String, Object>();
           
      // Recherche sur une commune
      String commune = request.getParameter("commune");
      if(Util.notEmpty(commune)) {
        parameters.put("codeInsee", commune);
      }
      
      
      // Paramétrage de la portlet Agenda
      if (Util.notEmpty(box.getNombreDeResultats())) {
        parameters.put("limit", box.getNombreDeResultats());
      } else {
        parameters.put("limit", channel.getIntegerProperty("jcmsplugin.socle.infolocale.limit", 20));
      }

      
      // Récupère le flux infolocale et transformation en liste de publication JCMS
      String flux = Util.isEmpty(box.getIdDeFlux()) ? channel.getProperty("jcmsplugin.socle.infolocale.flux.default") : box.getIdDeFlux();
      JSONObject extractedFlux = RequestManager.filterFluxData(flux, parameters);
      try {
        EvenementInfolocale[] evenements = InfolocaleEntityUtils.createEvenementInfolocaleArrayFromJsonArray(extractedFlux.getJSONArray("result"));
        allEvents = InfolocaleUtil.splitEventListFromDateFields(evenements);
      } catch (JSONException e) {
        LOGGER.warn("Erreur lors de la requete sur les évènements infolocale", e);
      }           
      return allEvents;
    }
    
}