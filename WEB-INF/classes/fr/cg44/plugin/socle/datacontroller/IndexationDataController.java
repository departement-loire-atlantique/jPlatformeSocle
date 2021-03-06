package fr.cg44.plugin.socle.datacontroller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import com.jalios.jcms.BasicDataController;
import com.jalios.jcms.Data;
import com.jalios.jcms.DataController;
import com.jalios.jcms.JcmsUtil;
import com.jalios.jcms.Member;
import com.jalios.jcms.Publication;
import com.jalios.jcms.handler.QueryHandler;
import com.jalios.util.Util;

import fr.cg44.plugin.socle.policyfilter.PublicationFacetedSearchCityEnginePolicyFilter;
import generated.Canton;
import generated.City;
import generated.Delegation;

/**
 * Si une commune, un canton ou une délégation est modifié alors réindexe les contenus liés
 */
public class IndexationDataController extends BasicDataController {
			
	public void afterWrite(Data data, int op, Member mbr, Map context) {
		if(data instanceof City) {
			City city = (City) data;
			// Si une commune, canton ou une délégation est modifié alors réindexe toutes les publications associées
			if(op == OP_UPDATE ) {	
				// Réindexe les contenus liées à la commune si son code commune ou canton a été modifié
				indexPubCity(city, context);
			} else if(op == OP_CREATE) {
				// Réindexe les contenus liées à toutes les communes lors de la création d'une commune
				indexPubAllCity(city);
			}
		}else if(data instanceof Canton) {
			if(op == OP_UPDATE ) {
				Canton canton = (Canton) data;
				indexPubCanton(canton, context);
			}
		}
	}
	
	
	/**
	 * Réindexe les contenus liées au canton si son code canton a été modifié
	 * @param canton
	 * @param context
	 */
	private void indexPubCanton(Canton canton, Map context) {
		Canton previousCanton = (Canton) context.get(DataController.CTXT_PREVIOUS_DATA);
		// Récupère le code canton avant et après modification
		int previousCantonCode = previousCanton.getCantonCode();
		int cantonCode = canton.getCantonCode();		
		// Si le code canton change alors réindexe les publication en lien avec ce canton
		if(cantonCode != previousCantonCode) {
			// Set des publication à ré-indéxer
			TreeSet<Publication> pubRefSet = new TreeSet<>();
			// Récupère les publications qui référencent directement le canton (champ mono)
			pubRefSet.addAll(canton.getLinkIndexedDataSet(Publication.class, "canton"));
			// Récupère les publications qui référencent directement le canton (champ multiple)
			pubRefSet.addAll(canton.getLinkIndexedDataSet(Publication.class, "cantons"));			
			// Réindexe les publications associées au canton
			indexPublications(pubRefSet);
		}		
	}


	private void indexPubAllCity(City city) {
		// Recherche toutes les publication qui sont cochées à oui sur le champ "toutes les communes"
		String SearchText = PublicationFacetedSearchCityEnginePolicyFilter.INDEX_FIELD_ALL_CITY + ":\"" + "true" + "\"";			
		QueryHandler qh = new QueryHandler();
		qh.setMode("advanced");
		qh.setText(SearchText);
		qh.setLoggedMember(channel.getCurrentLoggedMember());		
		indexPublications(qh.getResultSet());
	}


	/**
	 * Réindexe les contenus liées à la commune si son code commune ou canton a été modifié
	 * @param data
	 * @param context
	 */
	private void indexPubCity(City city, Map context) {	
		City previousCity = (City) context.get(DataController.CTXT_PREVIOUS_DATA);

		// Récupère le code commune avant et après modification
		int previousCityCode = previousCity.getCityCode();
		int cityCode = city.getCityCode();
		Boolean cityChange = cityCode != previousCityCode;

		// Récupère les canton déclarés dans la commune avant et après modification 
		Canton[] previousCityCantons = previousCity.getCanton();
		Canton[] cityCantons = city.getCanton();
		Boolean cantonsChange = !Arrays.equals(previousCityCantons, cityCantons);

		// Récupère la délégation déclarées dans la commune avant et après modification 
		Delegation previousCityDelegation = previousCity.getDelegation();
		Delegation cityDelegation= city.getDelegation();
		Boolean delegationChange = !JcmsUtil.isSameId(previousCityDelegation, cityDelegation);

		// Si le code commune ou le canton de la commune à été changé alors réindexe les contenus liés
		// Set des publication à ré-indéxer
		Set<Publication> pubRefSet = new HashSet<>();

		// Si le code commune change alors réindexe les publication en lien avec cette commune
		if(cityChange) {
			pubRefSet.addAll(indexCityChangeSet(city));				
		}

		// Si un ou plusieurs des cantons de la commune changent (Ajout - suppression - modification) réindexe les publication en lien avec ses cantons
		if(cantonsChange) {
			pubRefSet.addAll(indexCantonChangeSet(previousCityCantons, cityCantons));			
		}

		// Si la délégation de la commune change réindexe les publication en lien avec cette delegation
		if(delegationChange) {
			pubRefSet.addAll(indexDelegationChangeSet(previousCityDelegation, cityDelegation));						
		}			
		
		// Réindexe les publications associées à la commune directement ou indirectement concèrnées par un changement sur la commune			
		indexPublications(pubRefSet);	
	}
	

	/**
	 * Récuprère la liste des publications associés à des délégations (seulement des délégations qui ont changé)
	 * @param previousCityDelegation
	 * @param cityDelegation
	 * @return
	 */
	private Collection<? extends Publication> indexDelegationChangeSet(Delegation previousCityDelegation, Delegation cityDelegation) {
		Set<Publication> pubRefSet = new HashSet<>();
		Set<Delegation> delegationSet = new HashSet<Delegation>();
		if(Util.notEmpty(cityDelegation)) {
			delegationSet.add(cityDelegation);
		}
		if(Util.notEmpty(previousCityDelegation)) {
			delegationSet.add(previousCityDelegation);
		}
		for(Delegation itDelegation : delegationSet) {
			// Récupère les publications qui référencent directement la délégation (champ mono)
			pubRefSet.addAll(itDelegation.getLinkIndexedDataSet(Publication.class, "delegation"));
			// Récupère les publications qui référencent directement le canton (champ multiple)
			pubRefSet.addAll(itDelegation.getLinkIndexedDataSet(Publication.class, "delegations"));
		}	
		return pubRefSet;
	}


	/**
	 * Récuprère la liste des publications associés à des cantons (seulement des cantons qui ont changé)
	 * @param previousCityCantons
	 * @param cityCantons
	 * @return
	 */
	private Collection<? extends Publication> indexCantonChangeSet(Canton[] previousCityCantons, Canton[] cityCantons) {
		Set<Publication> pubRefSet = new HashSet<>();
		
		List<Canton> previousCityCantonsList = previousCityCantons!= null ? Arrays.asList(previousCityCantons) : new ArrayList<Canton>();
		List<Canton> cityCantonsList = cityCantons!= null ? Arrays.asList(cityCantons) : new ArrayList<Canton>();				
		
		// La liste des canton qui n'ont pas changé dans la commune
		List<Canton> cantonCommunSet = new ArrayList<Canton>(cityCantonsList);
		cantonCommunSet.retainAll(previousCityCantonsList);
		
		// La liste des cantons qui sont modifiés (ajouter ou enlever de la commune)
		List<Canton> cantonSet = new ArrayList<Canton>(cityCantonsList);
		cantonSet.addAll(previousCityCantonsList);
		// Retire la liste des canton qui n'ont pas changé dans la commune
		cantonSet.removeAll(cantonCommunSet);
		
		// réindexe les publication en lien avec un canton qui à changé de commune
		for(Canton itCanton : cantonSet) {
			// Récupère les publications qui référencent directement le canton (champ mono)
			pubRefSet.addAll(itCanton.getLinkIndexedDataSet(Publication.class, "canton"));
			// Récupère les publications qui référencent directement le canton (champ multiple)
			pubRefSet.addAll(itCanton.getLinkIndexedDataSet(Publication.class, "cantons"));
		}	
		return pubRefSet;
	}


	/**
	 * Récuprère la liste des publications associés à une commune
	 * @param city
	 * @return
	 */
	private Collection<? extends Publication> indexCityChangeSet(City city) {
		Set<Publication> pubRefSet = new HashSet<>();
		// Récupère les publications qui référencent directement la commune (champ mono)
		pubRefSet.addAll(city.getLinkIndexedDataSet(Publication.class, "commune"));
		// Récupère les publications qui référencent directement la commune (champ multiple)
		pubRefSet.addAll(city.getLinkIndexedDataSet(Publication.class, "communes"));
		return pubRefSet;
	}


	/**
	 * Réindexe les publications passées en paramètre
	 * @param publicationsSet
	 */
	public void indexPublications(Set<Publication> publicationsSet) {
		if(Util.notEmpty(publicationsSet)) {
			for(Publication itPub : publicationsSet) {
				// Ne pas réindexer les autres communes du cantons
				if(!(itPub instanceof City)) {
					channel.getQueryManager().getPublicationSearchEngine().update(itPub);
				}
			}
		}
	}
	
}