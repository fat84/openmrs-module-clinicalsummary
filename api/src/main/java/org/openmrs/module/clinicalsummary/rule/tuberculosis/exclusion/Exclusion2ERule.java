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
package org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion;

import org.openmrs.logic.LogicContext;
import org.openmrs.logic.result.Result;
import org.openmrs.module.clinicalsummary.rule.EvaluableConstants;
import org.openmrs.module.clinicalsummary.rule.EvaluableRule;
import org.openmrs.module.clinicalsummary.rule.observation.ObsWithRestrictionRule;
import org.openmrs.module.clinicalsummary.rule.observation.ObsWithStringRestrictionRule;

import java.util.Arrays;
import java.util.Map;

/**
 * TODO: Write brief description about the class here.
 */
public class Exclusion2ERule extends EvaluableRule {

    public static final String TOKEN = "Tuberculosis:Exclusion 2E";

    /**
     * @param context
     * @param patientId
     * @param parameters
     * @return
     * @see org.openmrs.logic.Rule#eval(org.openmrs.logic.LogicContext, Integer, java.util.Map)
     */
    @Override
    protected Result evaluate(final LogicContext context, final Integer patientId, final Map<String, Object> parameters) {
        Result result = new Result(Boolean.FALSE);
        ObsWithRestrictionRule obsWithRestrictionRule = new ObsWithStringRestrictionRule();

        String TUBERCULOSIS_MEDICATION_PICKUP_LOCATION = "TUBERCULOSIS MEDICATION PICKUP LOCATION"; // 8068
        String AMPATH = "AMPATH"; // 1286
        String OTHER_NON_CODED = "OTHER NON-CODED"; // 5622

        parameters.put(EvaluableConstants.OBS_FETCH_SIZE, 1);
        parameters.put(EvaluableConstants.OBS_CONCEPT, Arrays.asList(TUBERCULOSIS_MEDICATION_PICKUP_LOCATION));
        parameters.put(EvaluableConstants.OBS_VALUE_CODED, Arrays.asList(AMPATH, OTHER_NON_CODED));
        Result obsResults = obsWithRestrictionRule.eval(context, patientId, parameters);
        if (!obsResults.isEmpty()) {
            result = new Result(Boolean.TRUE);
        }
        return result;
    }

    /**
     * Get the token name of the rule that can be used to reference the rule from LogicService
     *
     * @return the token name
     */
    @Override
    protected String getEvaluableToken() {
        return TOKEN;
    }
}
