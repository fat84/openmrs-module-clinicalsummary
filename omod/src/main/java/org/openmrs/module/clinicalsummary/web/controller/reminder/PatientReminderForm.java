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

package org.openmrs.module.clinicalsummary.web.controller.reminder;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class PatientReminderForm {

	private static final Log log = LogFactory.getLog(PatientReminderForm.class);

	private Integer id;

	private Integer patientId;

	private String patientName;

	private String providerName;

	private String locationName;

	private Integer reminderId;

	private String token;

	private String datetime;

	/**
	 * @return
	 */
	public Integer getId() {
		return id;
	}

	/**
	 * @param id
	 */
	public void setId(final Integer id) {
		this.id = id;
	}

	/**
	 * @return
	 */
	public Integer getPatientId() {
		return patientId;
	}

	/**
	 * @param patientId
	 */
	public void setPatientId(final Integer patientId) {
		this.patientId = patientId;
	}

	/**
	 * @return
	 */
	public String getPatientName() {
		return patientName;
	}

	/**
	 * @param patientName
	 */
	public void setPatientName(final String patientName) {
		this.patientName = patientName;
	}

	/**
	 * @return
	 */
	public String getProviderName() {
		return providerName;
	}

	/**
	 * @param providerName
	 */
	public void setProviderName(final String providerName) {
		this.providerName = providerName;
	}

	/**
	 * @return
	 */
	public String getLocationName() {
		return locationName;
	}

	/**
	 * @param locationName
	 */
	public void setLocationName(final String locationName) {
		this.locationName = locationName;
	}

	/**
	 * @return
	 */
	public String getToken() {
		return token;
	}

	/**
	 * @param token
	 */
	public void setToken(final String token) {
		this.token = token;
	}

	/**
	 * @return
	 */
	public Integer getReminderId() {
		return reminderId;
	}

	/**
	 * @param reminderId
	 */
	public void setReminderId(final Integer reminderId) {
		this.reminderId = reminderId;
	}

	/**
	 * @return
	 */
	public String getDatetime() {
		return datetime;
	}

	/**
	 * @param datetime
	 */
	public void setDatetime(final String datetime) {
		this.datetime = datetime;
	}
}
