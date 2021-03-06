/**
 * The contents of this file are subject to the OpenMRS Public License
 * Version 1.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://license.openmrs.org
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 * License for the specific language governing rights and limitations
 * under the License.
 *
 * Copyright (C) OpenMRS, LLC.  All Rights Reserved.
 */

package org.openmrs.module.clinicalsummary.task;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.codehaus.jackson.JsonFactory;
import org.codehaus.jackson.JsonParser;
import org.codehaus.jackson.JsonToken;
import org.openmrs.Cohort;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.OpenmrsObject;
import org.openmrs.api.context.Context;
import org.openmrs.module.clinicalsummary.cache.CacheUtils;
import org.openmrs.module.clinicalsummary.enumeration.StatusType;
import org.openmrs.module.clinicalsummary.rule.EvaluableConstants;
import org.openmrs.module.clinicalsummary.service.CoreService;
import org.openmrs.module.clinicalsummary.service.UtilService;
import org.openmrs.module.clinicalsummary.util.FetchRestriction;
import org.openmrs.module.clinicalsummary.util.obs.OrderedObs;
import org.openmrs.util.OpenmrsUtil;

/**
 */
public class OrderedObsProcessor {

	private static final Log log = LogFactory.getLog(OrderedObsProcessor.class);

	private static final String ORDERED_OBSERVATIONS_CONFIGURATION = "clinicalsummary.ordered.observations";

	private ArrayList<Map<String, List<String>>> parameters;

	public OrderedObsProcessor() throws IOException {
		parse(Context.getAdministrationService().getGlobalProperty(ORDERED_OBSERVATIONS_CONFIGURATION));
	}

	public void parse(final String expression) throws IOException {
		parameters = new ArrayList<Map<String, List<String>>>();

		JsonFactory factory = new JsonFactory();
		JsonParser parser = factory.createJsonParser(expression);

		// start object of the json expression
		parser.nextToken();
		while (parser.nextToken() != JsonToken.END_OBJECT) {
			parser.nextToken();

			while (parser.nextToken() != JsonToken.END_ARRAY) {

				Map<String, List<String>> map = new HashMap<String, List<String>>();
				while (parser.nextToken() != JsonToken.END_OBJECT) {
					String key = parser.getCurrentName();
					parser.nextToken();

					List<String> values = new ArrayList<String>();
					while (parser.nextToken() != JsonToken.END_ARRAY)
						values.add(parser.getText());

					map.put(key, values);
				}

				parameters.add(map);
			}
		}
	}

	public void processObservations() {
		// location is clustered, clusters are separated by comma
		String clusterNames = Context.getAdministrationService().getGlobalProperty(TaskParameters.LOCATION_GROUP_LIST);
		if (clusterNames != null) {
			String[] clusterName = StringUtils.split(clusterNames, TaskParameters.CLUSTER_SEPARATOR);
			String processorCounter = Context.getAdministrationService().getGlobalProperty(TaskParameters.PROCESSOR_COUNTER);
			// start with the first cluster (offset = 0) when the counter is not a number
			Integer clusterOffset = NumberUtils.toInt(processorCounter, 0);
			if (clusterOffset >= 0 && clusterOffset < ArrayUtils.getLength(clusterName)) {
				String initProperty = Context.getAdministrationService().getGlobalProperty(TaskParameters.PROCESSOR_INITIALIZED);
				String currentCluster = clusterName[clusterOffset];
				// check whether all cluster have been initialized or not
				Boolean initialized = BooleanUtils.toBoolean(initProperty);

				Cohort cohort;
				String[] locationIds = StringUtils.split(currentCluster);
				for (int i = 0; i < ArrayUtils.getLength(locationIds); i++) {
					log.info("Processing location with id: " + locationIds[i]);
					// default return to -1 because no such location with id -1
					Location location = Context.getLocationService().getLocation(NumberUtils.toInt(locationIds[i], -1));
					if (!initialized) {
						cohort = Context.getService(CoreService.class).getDateCreatedCohort(location, null, null);
					} else {
						// regenerate when there's new obs
						Calendar calendar = Calendar.getInstance();
						calendar.add(Calendar.DATE, -(clusterName.length + 1));
						Date date = calendar.getTime();

						cohort = Context.getService(CoreService.class).getDateCreatedCohort(location, date, new Date());
					}

					// this processing is similar with the flow-sheet processing but we also include the duplicate processing here
					CoreService coreService = Context.getService(CoreService.class);

					for (Map<String, List<String>> parameter : parameters) {
						// process each parameter
						List<String> conceptNames = parameter.get(EvaluableConstants.OBS_CONCEPT);
						List<String> valueCodedNames = parameter.get(EvaluableConstants.OBS_VALUE_CODED);
						if (CollectionUtils.isNotEmpty(conceptNames) && CollectionUtils.isNotEmpty(valueCodedNames)) {

							// prepare the concept restriction
							Collection<OpenmrsObject> concepts = new ArrayList<OpenmrsObject>();
							for (String conceptName : conceptNames) {
								Concept concept = CacheUtils.getConcept(conceptName);
								if (concept != null)
									concepts.add(concept);
							}

							// test ordered concept
							Concept testOrderedConcept = CacheUtils.getConcept(TaskParameters.TESTS_ORDERED);
							Collection<OpenmrsObject> testedConcepts = new ArrayList<OpenmrsObject>();
							testedConcepts.add(testOrderedConcept);

							// prepare the value coded restriction
							Collection<OpenmrsObject> valueCodeds = new ArrayList<OpenmrsObject>();
							for (String valueCodedName : valueCodedNames) {
								Concept concept = CacheUtils.getConcept(valueCodedName);
								if (concept != null)
									valueCodeds.add(concept);
							}

							Map<String, Collection<OpenmrsObject>> restrictions = new HashMap<String, Collection<OpenmrsObject>>();
							for (Integer patientId : cohort.getMemberIds()) {
								// search for the results
								restrictions.put(EvaluableConstants.OBS_CONCEPT, concepts);
								List<Obs> testResultObservations = coreService.getPatientObservations(patientId, restrictions, new FetchRestriction());
								// remove and then save the duplicates
								testResultObservations = stripDuplicate(testResultObservations);

								// search for the tests
								restrictions.put(EvaluableConstants.OBS_CONCEPT, testedConcepts);
								restrictions.put(EvaluableConstants.OBS_VALUE_CODED, valueCodeds);
								List<Obs> testOrderedObservations = coreService.getPatientObservations(patientId, restrictions, new FetchRestriction());
								// remove and then save the duplicates
								testOrderedObservations = stripDuplicate(testOrderedObservations);

								// try to pair the obs and then save the un-pair-able obs
								pair(testOrderedObservations, testResultObservations);
							}
						}
					}
				}
			}
		}
	}

	/**
	 * @param observations
	 * @return
	 */
	private List<Obs> stripDuplicate(final List<Obs> observations) {

		if (CollectionUtils.isEmpty(observations))
			return observations;

		List<Obs> strippedObservations = new ArrayList<Obs>();
		while (observations.size() > 0) {
			Obs referredObs = observations.remove(0);

			// search for duplicates and remove them
			int counter = 0;
			while (observations.size() > counter) {
				Obs currentObs = observations.get(counter);

				if (DateUtils.isSameDay(referredObs.getObsDatetime(), currentObs.getObsDatetime())
						&& OpenmrsUtil.nullSafeEquals(referredObs.getConcept(), currentObs.getConcept())) {

					if (OpenmrsUtil.nullSafeEquals(referredObs.getValueNumeric(), currentObs.getValueNumeric())
							|| OpenmrsUtil.nullSafeEquals(referredObs.getValueCoded(), currentObs.getValueCoded())) {
						Obs removedObs = observations.remove(counter);
						saveOrderedObs(removedObs, StatusType.STATUS_DUPLICATE_RESULTS);
						continue;
					}
				}
				counter++;
			}

			strippedObservations.add(referredObs);
		}

		Context.flushSession();
		Context.clearSession();

		return strippedObservations;
	}

	/**
	 * @param testObservations
	 * @param resultObservations
	 */
	private void pair(final List<Obs> testObservations, final List<Obs> resultObservations) {

		Integer testCounter = 0;
		Integer resultCounter = 0;
		while (resultCounter < testObservations.size() && testCounter < resultObservations.size()) {
			Date testDate = testObservations.get(testCounter).getObsDatetime();
			Date resultDate = resultObservations.get(resultCounter).getObsDatetime();

			OrderedObs orderedObs = new OrderedObs();

			Obs removedObs = null;
			if (testDate.after(resultDate)) {
				removedObs = testObservations.get(testCounter++);
				orderedObs.setStatusType(StatusType.STATUS_NO_RESULT);
			} else {
				removedObs = resultObservations.get(resultCounter++);
				if (resultDate.after(DateUtils.addDays(testDate, 1)))
					orderedObs.setStatusType(StatusType.STATUS_NO_ORDER);
				else
					testCounter++;
			}

			if (removedObs != null) {
				orderedObs.setObs(removedObs);
				// if the obs have encounter, then pull some info from the encounter
				Encounter encounter = removedObs.getEncounter();
				if (encounter != null) {
					encounter = Context.getEncounterService().getEncounter(encounter.getEncounterId());
					orderedObs.setLocation(encounter.getLocation());
					orderedObs.setProvider(encounter.getProvider());
				}
				Context.getService(UtilService.class).saveOrderedObs(orderedObs);
			}
		}

		while (CollectionUtils.isNotEmpty(resultObservations)) {
			Obs removedObs = resultObservations.get(resultCounter++);
			saveOrderedObs(removedObs, StatusType.STATUS_NO_ORDER);
		}

		while (CollectionUtils.isNotEmpty(testObservations)) {
			Obs removedObs = testObservations.remove(0);
			saveOrderedObs(removedObs, StatusType.STATUS_NO_RESULT);
		}

		Context.flushSession();
		Context.clearSession();
	}

	/**
	 * Save ordered obs with the specified status
	 *
	 * @param obs
	 * @param statusType
	 */
	private void saveOrderedObs(Obs obs, StatusType statusType) {
		OrderedObs orderedObs = new OrderedObs();
		orderedObs.setObs(obs);
		// set status if the status is in the parameter
		if (statusType != null)
			orderedObs.setStatusType(statusType);
		// if the obs have encounter, then pull some info from the encounter
		Encounter encounter = obs.getEncounter();
		if (encounter != null) {
			encounter = Context.getEncounterService().getEncounter(encounter.getEncounterId());
			orderedObs.setLocation(encounter.getLocation());
			orderedObs.setProvider(encounter.getProvider());
		}
		Context.getService(UtilService.class).saveOrderedObs(orderedObs);
	}
}
