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
package org.openmrs.module.clinicalsummary.rule.tuberculosis.reminders;

import org.openmrs.logic.LogicContext;
import org.openmrs.logic.result.Result;
import org.openmrs.module.clinicalsummary.rule.EvaluableRule;
import org.openmrs.module.clinicalsummary.rule.reminder.ReminderParameters;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.element.Element11ARule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.element.Element11BRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.element.Element11CRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.element.Element11DRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion1CRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2ARule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2BRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2CRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2DRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2ERule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion2FRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion3ARule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion3BRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion3DRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion4ARule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion4BRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion4CRule;
import org.openmrs.module.clinicalsummary.rule.tuberculosis.exclusion.Exclusion4DRule;

import java.util.HashMap;
import java.util.Map;

/**
 * TODO: Write brief description about the class here.
 */
public class Reminder11Rule extends EvaluableRule {

    public static final String TOKEN = "Tuberculosis: Reminder 11";

    /**
     * @param context
     * @param patientId
     * @param parameters
     * @return
     * @see org.openmrs.logic.Rule#eval(org.openmrs.logic.LogicContext, Integer, java.util.Map)
     */
    @Override
    protected Result evaluate(final LogicContext context, final Integer patientId, final Map<String, Object> parameters) {
        Result result = new Result();

//        Exclusion1ARule exclusion1ARule = new Exclusion1ARule();
//        Result exclusion1AResult = exclusion1ARule.eval(context, patientId, new HashMap<String, Object>());
//        if (exclusion1AResult.toBoolean()) {
//            result.add(new Result("Reminder 11 excluded by Ex1A"));
//            return result;
//        }
//
//        Exclusion1BRule exclusion1BRule = new Exclusion1BRule();
//        Result exclusion1BResult = exclusion1BRule.eval(context, patientId, new HashMap<String, Object>());
//        if (exclusion1BResult.toBoolean()) {
//            result.add(new Result("Reminder 11 excluded by Ex1B"));
//            return result;
//        }
//
        Exclusion1CRule exclusion1CRule = new Exclusion1CRule();
        Result exclusion1CResult = exclusion1CRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion1CResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex1C"));
            return result;
        }
//
//        Exclusion1DRule exclusion1DRule = new Exclusion1DRule();
//        Result exclusion1DResult = exclusion1DRule.eval(context, patientId, new HashMap<String, Object>());
//        if (exclusion1DResult.toBoolean()) {
//            result.add(new Result("Reminder 11 excluded by Ex1D"));
//            return result;
//        }

        Exclusion2ARule exclusion2ARule = new Exclusion2ARule();
        Result exclusion2AResult = exclusion2ARule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2AResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2A"));
            return result;
        }

        Exclusion2BRule exclusion2BRule = new Exclusion2BRule();
        Result exclusion2BResult = exclusion2BRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2BResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2B"));
            return result;
        }

        Exclusion2CRule exclusion2CRule = new Exclusion2CRule();
        Result exclusion2CResult = exclusion2CRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2CResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2C"));
            return result;
        }

        Exclusion2DRule exclusion2DRule = new Exclusion2DRule();
        Result exclusion2DResult = exclusion2DRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2DResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2D"));
            return result;
        }

        Exclusion2FRule exclusion2FRule = new Exclusion2FRule();
        Result exclusion2FResult = exclusion2FRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2FResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2F"));
            return result;
        }

        Exclusion2ERule exclusion2ERule = new Exclusion2ERule();
        Result exclusion2EResult = exclusion2ERule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion2EResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex2E"));
            return result;
        }

        Exclusion3ARule exclusion3ARule = new Exclusion3ARule();
        Result exclusion3AResult = exclusion3ARule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion3AResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex3A"));
            return result;
        }

        Exclusion3BRule exclusion3BRule = new Exclusion3BRule();
        Result exclusion3BResult = exclusion3BRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion3BResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex3B"));
            return result;
        }

        Exclusion3DRule exclusion3DRule = new Exclusion3DRule();
        Result exclusion3DResult = exclusion3DRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion3DResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex3D"));
            return result;
        }

        Exclusion4ARule exclusion4ARule = new Exclusion4ARule();
        Result exclusion4AResult = exclusion4ARule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion4AResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex4A"));
            return result;
        }

        Exclusion4BRule exclusion4BRule = new Exclusion4BRule();
        Result exclusion4BResult = exclusion4BRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion4BResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex4B"));
            return result;
        }

        Exclusion4CRule exclusion4CRule = new Exclusion4CRule();
        Result exclusion4CResult = exclusion4CRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion4CResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex4C"));
            return result;
        }

        Exclusion4DRule exclusion4DRule = new Exclusion4DRule();
        Result exclusion4DResult = exclusion4DRule.eval(context, patientId, new HashMap<String, Object>());
        if (exclusion4DResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by Ex4D"));
            return result;
        }

        Element11ARule element11ARule = new Element11ARule();
        Result element11AResult = element11ARule.eval(context, patientId, new HashMap<String, Object>());
        if (element11AResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by E11A"));
            return result;
        }

        Element11BRule element11BRule = new Element11BRule();
        Result element11BResult = element11BRule.eval(context, patientId, new HashMap<String, Object>());
        if (element11BResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by E11B"));
            return result;
        }

        Element11CRule element11CRule = new Element11CRule();
        Result element11CResult = element11CRule.eval(context, patientId, new HashMap<String, Object>());
        if (element11CResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by E11C"));
            return result;
        }

        Element11DRule element11DRule = new Element11DRule();
        Result element11DResult = element11DRule.eval(context, patientId, new HashMap<String, Object>());
        if (element11DResult.toBoolean()) {
            result.add(new Result("Reminder 11 excluded by E11D"));
            return result;
        }

        result.add(new Result(String.valueOf(parameters.get(ReminderParameters.DISPLAYED_REMINDER_TEXT))));
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
