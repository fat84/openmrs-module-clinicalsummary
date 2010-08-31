-- MySQL dump 10.11
--
-- Host: localhost    Database: openmrs
-- ------------------------------------------------------
-- Server version	5.0.67-0ubuntu6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `clinical_summary`
--
-- WHERE:  clinical_summary.clinical_summary_id=6

LOCK TABLES `clinical_summary` WRITE;
/*!40000 ALTER TABLE `clinical_summary` DISABLE KEYS */;
INSERT INTO `clinical_summary` VALUES (null,'AMPATH Clinical Summary v.3a','Defines a clinical summary very similar to the basic summary except with the addition of the AMPATH medication list.','<?xml version=\"1.0\"?>\n<clinicalSummaryList>\n\n#foreach($patientId in $patientSet.patientIds)\n$!{fn.setPatientId($patientId)}\n<clinicalSummary>\n    #foreach($id in $!{fn.getPatientAttr(\'PatientIdentifier\', \'identifier\', true)})\n        #if ($velocityCount == 1)\n           <id>$id</id>\n        #else\n            <alternateId>$id</alternateId>\n        #end\n    #end\n    <name>\n        $!{fn.getPatientAttr(\'PersonName\', \'givenName\')}\n        $!{fn.getPatientAttr(\'PersonName\', \'middleName\')}\n        $!{fn.getPatientAttr(\'PersonName\', \'familyName\')}\n    </name>\n    <gender>$!{fn.getPatientAttr(\'Person\', \'gender\')}</gender>\n    #set($birthdate = $!{fn.getPatientAttr(\'Person\', \'birthdate\')})\n    #set($birthdate_estimated = $!{fn.getPatientAttr(\'Person\', \'birthdateEstimated\')})\n    #if ($birthdate)\n        #set($age = $!{fn.getAge(${birthdate})})\n        #if ($!{age.get(1)} == \"days\")\n            #set($age_text = \"$!{age.get(0)} day-old\")\n        #elseif ($!{age.get(1)} == \"weeks\")\n            #set($age_text = \"$!{age.get(0)} week-old\")\n        #elseif ($!{age.get(1)} == \"months\")\n            #set($age_text = \"$!{age.get(0)} month-old\")\n        #else\n            #set($age_text = \"$!{age.get(0)} year-old\")\n        #end\n    #else\n        #set($age_text = \"??? year-old\")\n    #end\n    <birthdate estimate=\"${birthdate_estimated}\" age=\"$!{age_text}\">\n        $!{fn.formatDate(\'dd-MMM-yyyy\',${birthdate})}\n    </birthdate>\n    <firstEncounterDate>\n        $!{fn.formatDate(\'dd-MMM-yyyy\', $!{fn.getFirstEncounterAttr([\'ADULTINITIAL\',\'ADULTRETURN\',\'PEDSINITIAL\',\'PEDSRETURN\'], \'encounterDatetime\')})}\n    </firstEncounterDate>\n    <lastEncounter>\n        <dateTime>\n            $!{fn.formatDate(\'dd-MMM-yyyy\', $!{fn.getLastEncounterAttr([\'ADULTINITIAL\',\'ADULTRETURN\',\'PEDSINITIAL\',\'PEDSRETURN\'], \'encounterDatetime\')})}\n        </dateTime>\n        <location>\n            $!{fn.getLastEncounterAttr([\'ADULTINITIAL\',\'ADULTRETURN\',\'PEDSINITIAL\',\'PEDSRETURN\'], \'location\')}\n        </location>\n    </lastEncounter>\n    <healthCenter>${fn.getValueAsString($!{fn.getPersonAttribute(\'Health Center\', \'Location\', \'locationId\', \'name\', false)})}</healthCenter>\n    <whoStage>\n        #set($whoStage = ${fn.getLastObs(\'5356\')})\n        #if (${whoStage.getConceptId()} == \'1204\')\n            WHO STAGE I\n        #elseif (${whoStage.getConceptId()} == \'1205\')\n            WHO STAGE II\n        #elseif (${whoStage.getConceptId()} == \'1206\')\n            WHO STAGE III\n        #elseif (${whoStage.getConceptId()} == \'1207\')\n            WHO STAGE IV\n        #elseif (${whoStage.getConceptId()} == \'1220\')\n            WHO STAGE I\n        #elseif (${whoStage.getConceptId()} == \'1221\')\n            WHO STAGE II\n        #elseif (${whoStage.getConceptId()} == \'1222\')\n            WHO STAGE III\n        #elseif (${whoStage.getConceptId()} == \'1223\')\n            WHO STAGE IV\n        #else \n            ${fn.getValueAsString($whoStage)}\n        #end\n    </whoStage>\n    <perfectAdherence>\n        #set($obsValues = $fn.getObsTimeframe(\'1164\', 12))\n        #if (${obsValues.size()} < 1)\n            unknown\n        #else\n            #set($all = true)\n            #foreach($val in $obsValues)\n                #if (!(${val.getConceptId()} == 1163))#set($all = false)#end\n            #end\n            #if ($all == true)\n                yes\n            #else\n                no\n            #end\n        #end\n    </perfectAdherence>\n    <problemList>\n        <!-- Make a list of all PROBLEM ADDED without a subsequent matching PROBLEM RESOLVED -->\n        #set($arr = [\'obsDatetime\'])\n        #set($obsValues = $fn.getIntersectedObs(\'6042\', \'6097\', $arr))\n        #foreach($vals in $obsValues)\n            <problem date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0).getName()})}\n            </problem>\n        #end\n    </problemList>\n    <flowsheet>\n      <!--\n          List all known values for\n              WEIGHT (KG),\n              HGB (concept HEMOGLOBIN),\n              VIRAL LOAD,\n              CD4 (CD4, BY FACS),\n              SGPT\n          All dates should be in MM-DD-YYYY format\n          For CD4: if CD4% exists on same day, repeat as CD4 (%), e.g. <value date=\"...\">252 (16%)</value>\n      -->\n    <results name=\"WEIGHT (KG)\">\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'5089\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'5089\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n        #set($pendingTest = $fn.getPendingTestOrdered(\'5089\'))\n            <pending date=\"$!fn.formatDate(\'dd-MMM-yyyy\', $!{pendingTest.getObsDatetime()}\">\n                $!{fn.getValueAsString($pendingTest)}\n            </pending>\n    </results>\n    <results name=\"HGB\">\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'21\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'21\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n        #set($pendingTest = $fn.getPendingTestOrdered(\'21\'))\n            <pending date=\"$!fn.formatDate(\'dd-MMM-yyyy\', $!{pendingTest.getObsDatetime()}\">\n                $!{fn.getValueAsString($pendingTest)}\n            </pending>\n    </results>\n    <results name=\"CD4\">\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'5497\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'5497\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n        #set($pendingTest = $fn.getPendingTestOrdered(\'5497\'))\n            <pending date=\"$!fn.formatDate(\'dd-MMM-yyyy\', $!{pendingTest.getObsDatetime()}\">\n                $!{fn.getValueAsString($pendingTest)}\n            </pending>\n    </results>\n\n    <results name=\"VIRAL LOAD\">\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'856\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'856\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n        #set($pendingTest = $fn.getPendingTestOrdered(\'856\'))\n            <pending date=\"$!fn.formatDate(\'dd-MMM-yyyy\', $!{pendingTest.getObsDatetime()}\">\n                $!{fn.getValueAsString($pendingTest)}\n            </pending>\n    </results>\n    <results name=\"SGPT\">\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'654\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'654\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n        #set($pendingTest = $fn.getPendingTestOrdered(\'654\'))\n            <pending date=\"$!fn.formatDate(\'dd-MMM-yyyy\', $!{pendingTest.getObsDatetime()}\">\n                $!{fn.getValueAsString($pendingTest)}\n            </pending>\n    </results>\n    </flowsheet>\n    \n    <cd4_percent>\n        #set($arr = [\'obsDatetime\'])\n        #set($firstObsVal = $fn.getFirstNObsWithValues(1, \'730\', $arr))\n            <first date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${firstObsVal.get(0).get(1)})}\">\n                ${fn.getValueAsString(${firstObsVal.get(0).get(0)})}\n            </first>\n        #set($obsValues = $fn.getLastNObsWithValues(-1, \'730\', $arr))\n        #foreach($vals in $obsValues)\n            <value date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n                ${fn.getValueAsString(${vals.get(0)})}\n            </value>\n        #end\n    </cd4_percent>\n\n    #set($arr = [\'obsDatetime\'])\n    #set($obsValues = $fn.getLastNObsWithValues(1, \'12\', $arr))\n    #foreach($vals in $obsValues)\n        #if(${vals.get(0)})\n            #if($velocityCount == 1)<cxr date=\"$!{fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">#end\n                ${fn.getValueAsString(${vals.get(0)})}\n                #if($velocityCount > 1) , #end\n            #if($velocityCount == ${obsValues.size()})</cxr>#end\n        #end\n    #end\n\n    #set($medValues = ${fn.getAmpathActiveMedications()})\n    #foreach($vals in $medValues)\n        #if($velocityCount == 1)<medications>#end\n        <medication date=\"${fn.formatDate(\'dd-MMM-yyyy\', ${vals.get(1)})}\">\n            ${fn.getValueAsString(${vals.get(0)})}\n        </medication>\n        #if($velocityCount == ${medValues.size()})</medications>#end\n    #end\n\n    <reminders>\n    #set($cd4Reminder = $fn.getCD4CountReminder()) \n        <reminder>${cd4Reminder}</reminder> \n    </reminders>        \n\n</clinicalSummary>\n#end <!-- ending patient loop -->\n\n</clinicalSummaryList>','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<xsl:stylesheet version=\"2.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"\n    xmlns:fo=\"http://www.w3.org/1999/XSL/Format\" xmlns:fn=\"http://www.w3.org/2005/02/xpath-functions\"\n    exclude-result-prefixes=\"fo\">\n<xsl:output method=\"xml\" version=\"1.0\" omit-xml-declaration=\"no\" indent=\"yes\"/>\n\n<xsl:template match=\"clinicalSummaryList\">\n<fo:root xmlns:fo=\"http://www.w3.org/1999/XSL/Format\">\n    <fo:layout-master-set>\n        <fo:simple-page-master master-name=\"simple\" page-height=\"297mm\" page-width=\"210mm\"\n            margin-top=\"1cm\" margin-left=\"1cm\" margin-right=\"1cm\" margin-bottom=\"1cm\">\n            <fo:region-body margin-top=\"1.2cm\" margin-bottom=\"1.2cm\" />\n            <fo:region-before extent=\"3cm\"  />\n            <fo:region-after extent=\"1cm\" />\n        </fo:simple-page-master>\n    </fo:layout-master-set>\n   \n    <!-- Begin Summary -->\n    <xsl:for-each select=\"clinicalSummary\">\n    <fo:page-sequence master-reference=\"simple\">\n        <!-- Header -->\n        <fo:static-content flow-name=\"xsl-region-before\" font-family=\"Helvetica\">\n            <fo:block text-align=\"center\"\n                border-top=\"thin solid grey\"\n                border-left=\"thin solid grey\"\n                border-right=\"thin solid black\"\n                border-bottom=\"thin solid black\"\n                background-color=\"#e0e0e0\"\n                padding=\"0.2cm\"\n                space-after=\"12pt\"\n                font-weight=\"bold\">AMPATH Medical Record System Clinical Summary</fo:block>\n        </fo:static-content>\n        <!-- Footer -->\n        <fo:static-content flow-name=\"xsl-region-after\" font-family=\"Helvetica\">\n            <fo:table table-layout=\"fixed\" width=\"100%\">\n                <fo:table-column column-width=\"60%\" />\n                <fo:table-column column-width=\"40%\" />\n                <fo:table-body>\n                    <fo:table-row height=\"1cm\">\n                        <fo:table-cell display-align=\"center\">\n                            <fo:block text-align=\"left\" font-size=\"8pt\">\n                                <xsl:if test=\"lastEncounter/location\">\n                                    <fo:block>\n                                        Last seen <xsl:value-of select=\"lastEncounter/dateTime\" />\n                                        at <xsl:value-of select=\"lastEncounter/location\" />\n                                     </fo:block>\n                                </xsl:if>\n                                Printed on <xsl:value-of select=\"format-dateTime(current-dateTime(),\'[Y0001]-[M01]-[D01] at [H01]:[m01]:[s01]\')\" />\n                            </fo:block>\n                        </fo:table-cell>\n                        <fo:table-cell display-align=\"center\">\n                            <fo:block text-align=\"right\" font-size=\"20pt\" font-weight=\"bold\">\n                                <xsl:value-of select=\"id\" />\n                            </fo:block>\n                        </fo:table-cell>\n                    </fo:table-row>\n                </fo:table-body>\n            </fo:table>       \n            <fo:block>\n            </fo:block>\n        </fo:static-content>\n       \n        <!-- Begin Page Content -->\n        <fo:flow flow-name=\"xsl-region-body\" font-family=\"Helvetica\" font-size=\"14pt\">\n            <fo:table table-layout=\"fixed\" width=\"100%\">\n                <fo:table-column column-width=\"60%\" />\n                <fo:table-column column-width=\"40%\" />\n                <fo:table-body>\n                    <fo:table-row>\n                        <fo:table-cell>\n                            <fo:block font-weight=\"bold\" font-style=\"italic\" font-size=\"20pt\">\n                                <xsl:value-of select=\"name\" />\n                            </fo:block>\n                            <fo:block font-size=\"14pt\" space-after=\"6pt\">\n                                <fo:inline><xsl:value-of select=\"birthdate/@age\" /></fo:inline>\n                                <xsl:choose>\n                                    <xsl:when test=\"gender = \'M\'\">\n                                        <fo:inline> male</fo:inline>\n                                    </xsl:when>\n                                    <xsl:when test=\"gender = \'F\'\">\n                                        <fo:inline> female</fo:inline>\n                                    </xsl:when>\n                                </xsl:choose>\n                            </fo:block>\n                            <xsl:if test=\"firstEncounterDate and string-length(normalize-space(firstEncounterDate)) > 0\">\n                                <fo:block>\n                                    <fo:inline>First Encounter on <xsl:value-of select=\"firstEncounterDate\" /></fo:inline>\n                                </fo:block>\n                            </xsl:if>\n                            <xsl:if test=\"whoStage\">\n                                <fo:block>\n                                    <fo:inline><xsl:value-of select=\"whoStage\" /></fo:inline>\n                                </fo:block>\n                            </xsl:if>\n                            <xsl:if test=\"whoStage\">\n                                <fo:block>Perfect HIV Rx Adherence (past year): <xsl:value-of select=\"perfectAdherence\" /></fo:block>\n                            </xsl:if>\n                            <!-- <fo:block text-align=\"center\" space-before=\"12pt\" space-after=\"12pt\">\n                                <fo:leader leader-pattern=\"rule\" leader-length=\"80%\" color=\"#808080\" />\n                            </fo:block> -->\n                        </fo:table-cell>\n                        <fo:table-cell text-align=\"right\">\n                            <fo:block font-weight=\"bold\" font-size=\"20pt\"><xsl:value-of select=\"id\" /></fo:block>\n                            <xsl:if test=\"alternateId\">\n                                <xsl:variable name=\"maxIds\" select=\"4\" />\n                                <xsl:for-each select=\"alternateId\">\n                                    <xsl:choose>\n                                        <xsl:when test=\"position() &lt; $maxIds\">\n                                            <fo:block color=\"#888888\">\n                                                <fo:inline><xsl:value-of select=\".\" /></fo:inline>\n                                            </fo:block>\n                                        </xsl:when>\n                                        <xsl:when test=\"position() = ($maxIds + 1)\">\n                                            <fo:block color=\"#888888\">\n                                                <fo:inline font-style=\"italic\">(not all ids shown)</fo:inline>\n                                            </fo:block>\n                                        </xsl:when>\n                                    </xsl:choose>\n                                </xsl:for-each>\n                            </xsl:if>\n                        </fo:table-cell>\n                    </fo:table-row>\n                </fo:table-body>\n            </fo:table>\n            \n            <!-- Problem/Med List table -->\n            <xsl:variable name=\"maxRows\" select=\"20\" />\n            <xsl:variable name=\"wrapEstimate\" select=\"25\" />\n            <fo:table table-layout=\"fixed\"\n                width=\"100%\"\n                border-spacing=\"0.25in\" space-before=\"6pt\"\n                space-after=\"6pt\">\n                <fo:table-column column-width=\"50%\" />\n                <fo:table-column column-width=\"50%\" />\n                <fo:table-body font-size=\"20pt\">\n                    <fo:table-row height=\"7cm\">\n                        <fo:table-cell>\n\n            <!-- Problem list -->\n            <fo:block font-size=\"18pt\"\n                space-before=\"8pt\"\n                space-after=\"8pt\"><fo:inline text-decoration=\"underline\">Problem List</fo:inline>:</fo:block>\n             <xsl:choose>\n                <xsl:when test=\"problemList/problem\">\n                    <xsl:variable name=\"problemList\" select=\"subsequence(problemList/problem,1,$maxRows)\" />\n                    <xsl:variable name=\"numWide\" select=\"sum(for $s in $problemList return if (string-length(normalize-space($s)) > $wrapEstimate) then 1 else 0)\" />\n                    <xsl:variable name=\"fontSize\" select=\"min((round(500 div max((count($problemList)+$numWide,1))) div 100,0.5))\" />\n                    <xsl:element name=\"fo:list-block\">\n                        <xsl:attribute name=\"font-size\" select=\"concat($fontSize,\'cm\')\" />\n                        <xsl:attribute name=\"space-after\">12pt</xsl:attribute>\n                        <xsl:attribute name=\"provisional-label-separation\">1mm</xsl:attribute>\n                        <xsl:attribute name=\"provisional-distance-between-starts\">1mm</xsl:attribute>\n                        <xsl:for-each select=\"$problemList\">\n                        <fo:list-item>\n                            <fo:list-item-label end-indent=\"label-end()\" text-align=\"right\">\n                                <fo:block><xsl:value-of select=\"position()\" />.</fo:block>\n                            </fo:list-item-label>\n                            <fo:list-item-body start-indent=\"body-start()\">\n                                <fo:block>\n                                    <xsl:value-of select=\".\" />\n                                    <xsl:if test=\"@date\">\n                                        <xsl:element name=\"fo:inline\">\n                                            <xsl:attribute name=\"font-size\" select=\"concat($fontSize div 2,\'cm\')\" />\n                                            <xsl:attribute name=\"font-style\">italic</xsl:attribute>\n                                            <xsl:attribute name=\"color\">#555</xsl:attribute>\n                                            <xsl:text> (</xsl:text>\n                                            <xsl:value-of select=\"@date\" />\n                                            <xsl:text>)</xsl:text>\n                                        </xsl:element>\n                                    </xsl:if>\n                                </fo:block>\n                            </fo:list-item-body>\n                        </fo:list-item>\n                        </xsl:for-each>\n                        <xsl:if test=\"count(problemList/problem) > $maxRows\">\n                            <fo:list-item>\n                                <fo:list-item-label end-indent=\"label-end()\">\n                                    <fo:block></fo:block>\n                                </fo:list-item-label>\n                                <fo:list-item-body start-indent=\"body-start()\">\n                                    <fo:block font-style=\"italic\">\n                                        <xsl:text>(</xsl:text>\n                                        <xsl:value-of select=\"count(problemList/problem) - $maxRows\" />\n                                        <xsl:text> more problems)</xsl:text>\n                                    </fo:block>\n                                </fo:list-item-body>\n                            </fo:list-item>\n                        </xsl:if>\n                    </xsl:element>\n                </xsl:when>\n                <xsl:otherwise>\n                    <fo:block font-size=\"0.5cm\">NONE</fo:block>\n                </xsl:otherwise>\n             </xsl:choose>\n\n                        </fo:table-cell>\n                        <fo:table-cell>\n                       \n            <!-- Medications -->\n            <fo:block font-size=\"18pt\"\n                space-before=\"8pt\"\n                space-after=\"8pt\"><fo:inline text-decoration=\"underline\">Recent ARVs and OI Meds</fo:inline>:</fo:block>\n\n            <xsl:choose>\n                <xsl:when test=\"medications/medication\">\n                    <xsl:variable name=\"medList\" select=\"subsequence(medications/medication,1,$maxRows)\" />\n                    <xsl:variable name=\"numWide\" select=\"sum(for $s in $medList return if (string-length(normalize-space($s)) > $wrapEstimate) then 1 else 0)\" />\n                    <xsl:variable name=\"fontSize\" select=\"min((round(500 div max((count($medList)+$numWide,1))) div 100,0.5))\" />\n                    <xsl:element name=\"fo:list-block\">\n                        <xsl:attribute name=\"font-size\" select=\"concat($fontSize,\'cm\')\" />\n                        <xsl:attribute name=\"space-after\">12pt</xsl:attribute>\n                        <xsl:attribute name=\"provisional-label-separation\">1mm</xsl:attribute>\n                        <xsl:attribute name=\"provisional-distance-between-starts\">1mm</xsl:attribute>\n                        <xsl:for-each select=\"$medList\">\n                        <fo:list-item>\n                            <fo:list-item-label end-indent=\"label-end()\" text-align=\"right\">\n                                <fo:block><xsl:value-of select=\"position()\" />.</fo:block>\n                            </fo:list-item-label>\n                            <fo:list-item-body start-indent=\"body-start()\">\n                                <fo:block>\n                                    <xsl:value-of select=\".\" />\n                                    <!--\n                                    <xsl:if test=\"@date\">\n                                        <xsl:text> (</xsl:text>\n                                        <xsl:value-of select=\"@date\" />\n                                        <xsl:text>)</xsl:text>\n                                    </xsl:if>\n                                    -->\n                                </fo:block>\n                            </fo:list-item-body>\n                        </fo:list-item>\n                        </xsl:for-each>\n                        <xsl:if test=\"count(medications/medication) > $maxRows\">\n                            <fo:list-item>\n                              <fo:list-item-label end-indent=\"label-end()\">\n                                 <fo:block></fo:block>\n                               </fo:list-item-label>\n                               <fo:list-item-body start-indent=\"body-start()\">\n                                   <fo:block font-style=\"italic\">\n                                        <xsl:text>(</xsl:text>\n                                      <xsl:value-of select=\"count(medications/medication) - $maxRows\" />\n                                        <xsl:text> more meds)</xsl:text>\n                                    </fo:block>\n                             </fo:list-item-body>\n                            </fo:list-item>\n                        </xsl:if>\n                    </xsl:element>\n                </xsl:when>\n                <xsl:otherwise>\n                    <fo:block font-size=\"0.5cm\">NONE</fo:block>\n                </xsl:otherwise>\n             </xsl:choose>\n\n                        </fo:table-cell>\n                    </fo:table-row>\n                </fo:table-body>\n            </fo:table>\n\n            <!-- Flowsheet -->\n            <fo:block font-size=\"18pt\"><fo:inline text-decoration=\"underline\">Flowsheet</fo:inline>:</fo:block>\n            <fo:table space-after=\"12pt\" width=\"100%\" border-collapse=\"collapse\">\n                <xsl:for-each select=\"flowsheet/results\">\n                    <fo:table-column />\n                </xsl:for-each>\n                <fo:table-body>\n                    <fo:table-row>\n                        <xsl:for-each select=\"flowsheet/results\">\n                            <xsl:element name=\"fo:table-cell\">\n                                <xsl:attribute name=\"text-align\">center</xsl:attribute>\n                                <xsl:attribute name=\"padding\">2pt</xsl:attribute>\n                                <xsl:attribute name=\"border-bottom\">thin solid black</xsl:attribute>\n                                <xsl:if test=\"not(position()=last())\">\n                                    <xsl:attribute name=\"border-right\">thin solid black</xsl:attribute>\n                                </xsl:if>\n                                <fo:block><xsl:value-of select=\"@name\" /></fo:block>\n                            </xsl:element>\n                        </xsl:for-each>\n                    </fo:table-row>\n                    <xsl:variable name=\"results\" select=\"flowsheet/results\" />\n                    <xsl:variable name=\"cd4_percent\" select=\"cd4_percent\" />\n                    <xsl:for-each select=\"(1,2,3,4,5)\">\n                        <xsl:variable name=\"i\" select=\"position()\" />\n                        <xsl:element name=\"fo:table-row\">\n                            <xsl:attribute name=\"background-color\">\n                                <xsl:if test=\"$i mod 2\">#F8F8F8</xsl:if>\n                                <xsl:if test=\"not($i mod 2)\">#FFFFFF</xsl:if>\n                            </xsl:attribute>\n                            <xsl:attribute name=\"height\">1cm</xsl:attribute>\n                            <xsl:for-each select=\"$results\">\n                                <xsl:variable name=\"result_name\" select=\"@name\" />\n                                <xsl:element name=\"fo:table-cell\">\n                                    <xsl:attribute name=\"text-align\">center</xsl:attribute>\n                                    <xsl:attribute name=\"display-align\">center</xsl:attribute>\n                                    <xsl:attribute name=\"padding\">2pt</xsl:attribute>\n                                    <xsl:if test=\"not(position()=last())\">\n                                        <xsl:attribute name=\"border-right\">thin solid black</xsl:attribute>\n                                    </xsl:if>\n                                    <xsl:choose>\n                                        <xsl:when test=\"($i=1) and (count(value) > 5)\">\n                                            <xsl:variable name=\"result_date\" select=\"value[position()=last()]/@date\" />\n                                            <fo:block space-after=\"0pt\">\n                                                <xsl:value-of select=\"value[position()=last()]\" />\n                                                <xsl:if test=\"$result_name=\'CD4\'\">\n                                                    <xsl:variable name=\"p\" select=\"$cd4_percent/value[@date=$result_date]\" />\n                                                    <xsl:if test=\"$p\">\n                                                        <xsl:text> (</xsl:text>\n                                                        <xsl:value-of select=\"normalize-space($p[position()=1])\" />\n                                                        <xsl:text>%)</xsl:text>\n                                                    </xsl:if>\n                                                </xsl:if>\n                                            </fo:block>\n                                            <xsl:if test=\"$result_date\">\n                                                <fo:block font-size=\"6pt\" font-style=\"italic\" color=\"#808080\" space-before=\"0pt\">\n                                                    <xsl:value-of select=\"substring($result_date,0,12)\" />\n                                                </fo:block>\n                                            </xsl:if>\n                                        </xsl:when>\n                                        <xsl:when test=\"$i &lt;= count(value)\">\n                                            <xsl:variable name=\"j\" select=\"min((count(value),5))-$i+1\" />\n                                            <xsl:choose>\n                                            <xsl:when test=\"($j=1) and value[$j]=first and value[$j]/@date=first/@date\">\n                                            <xsl:variable name=\"result_date\" select=\"first/@date\" />\n                                            <fo:block space-after=\"0pt\">\n                                                <xsl:value-of select=\"first\" />\n                                                <xsl:if test=\"$result_name=\'CD4\'\">\n                                                    <xsl:variable name=\"p\" select=\"$cd4_percent/first\" />\n                                                    <xsl:if test=\"$p\">\n                                                        <xsl:text> (</xsl:text>\n                                                        <xsl:value-of select=\"normalize-space($p[position()=1])\" />\n                                                        <xsl:text>%)</xsl:text>\n                                                    </xsl:if>\n                                                </xsl:if>\n                                            </fo:block>\n                                            <xsl:if test=\"$result_date\">\n                                                <fo:block font-size=\"6pt\" font-style=\"italic\" color=\"#808080\" space-before=\"0pt\">\n                                                    <xsl:value-of select=\"substring($result_date,0,12)\" />\n                                                </fo:block>\n                                            </xsl:if>\n                                            </xsl:when>\n                                            <xsl:otherwise>\n                                            <xsl:variable name=\"result_date\" select=\"value[$j]/@date\" />\n                                            <fo:block space-after=\"0pt\">\n                                                <xsl:value-of select=\"value[$j]\" />\n                                                <xsl:if test=\"$result_name=\'CD4\'\">\n                                                    <xsl:variable name=\"p\" select=\"$cd4_percent/value[@date=$result_date]\" />\n                                                    <xsl:if test=\"$p\">\n                                                        <xsl:text> (</xsl:text>\n                                                        <xsl:value-of select=\"normalize-space($p[position()=1])\" />\n                                                        <xsl:text>%)</xsl:text>\n                                                    </xsl:if>\n                                                </xsl:if>\n                                            </fo:block>\n                                            <xsl:if test=\"$result_date\">\n                                                <fo:block font-size=\"6pt\" font-style=\"italic\" color=\"#808080\" space-before=\"0pt\">\n                                                    <xsl:value-of select=\"substring($result_date,0,12)\" />\n                                                </fo:block>\n                                            </xsl:if>\n                                            </xsl:otherwise>\n                                            </xsl:choose>\n                                        </xsl:when>\n                                        <xsl:otherwise>\n                                            <fo:block></fo:block>\n                                        </xsl:otherwise>\n                                    </xsl:choose>\n                                </xsl:element>\n                            </xsl:for-each>\n                        </xsl:element>\n                    </xsl:for-each>\n                    <fo:table-row>\n                            <xsl:attribute name=\"background-color\">\n                                #FFFFFF\n                            </xsl:attribute>\n                            <xsl:attribute name=\"height\">1cm</xsl:attribute>\n                            <xsl:for-each select=\"flowsheet/results\">\n                                <xsl:variable name=\"result_name\" select=\"@name\" />\n                                <xsl:element name=\"fo:table-cell\">\n                                    <xsl:attribute name=\"text-align\">center</xsl:attribute>\n                                    <xsl:attribute name=\"display-align\">center</xsl:attribute>\n                                    <xsl:attribute name=\"padding\">2pt</xsl:attribute>\n                                    <xsl:if test=\"($result_name != \'SGPT\')\">\n                                        <xsl:attribute name=\"border-right\">thin solid black</xsl:attribute>\n                                    </xsl:if>\n                                            <xsl:variable name=\"result_date\" select=\"pending/@date\" />\n                                            <fo:block space-after=\"0pt\">\n                                                <xsl:value-of select=\"pending\" />\n                                            </fo:block>\n                                            <xsl:if test=\"$result_date\">\n                                                <fo:block font-size=\"6pt\" font-style=\"italic\" color=\"#808080\" space-before=\"0pt\">\n                                                    <xsl:value-of select=\"substring($result_date,0,12)\" />\n                                                </fo:block>\n                                    </xsl:if>\n                                </xsl:element>\n                    </fo:table-row>\n                </fo:table-body>\n            </fo:table>\n           \n            <!-- Chest X-ray -->\n            <fo:block font-size=\"18pt\">\n                <fo:inline text-decoration=\"underline\">Chest X-ray</fo:inline>:\n                <fo:inline font-size=\"12pt\" text-decoration=\"none\">\n                    (check chart as needed for results prior to 14-Feb-2006)\n                </fo:inline>\n            </fo:block>\n            <xsl:choose>\n                <xsl:when test=\"cxr\">\n                    <fo:block><xsl:value-of select=\"cxr[position()=1]/@date\" />: <xsl:value-of select=\"cxr[position()=1]\" /></fo:block>\n                </xsl:when>\n                <xsl:otherwise>\n                    <fo:block>No chest x-ray results available.</fo:block>\n                </xsl:otherwise>\n            </xsl:choose>\n           \n            <!-- Reminders -->\n            <fo:block space-before=\"12pt\" width=\"100%\">\n                <xsl:attribute name=\"border-bottom\">thin solid black</xsl:attribute>\n            </fo:block>\n            <fo:block font-size=\"18pt\" space-before=\"6pt\">\n                <fo:inline text-decoration=\"underline\">Reminders</fo:inline>:\n            </fo:block>\n            <xsl:if test=\"reminders\">\n                <xsl:for-each select=\"reminders/reminder\">\n                    <fo:block space-before=\"6pt\"><xsl:value-of select=\".\" /></fo:block>\n                </xsl:for-each>\n            </xsl:if>\n        </fo:flow>\n    </fo:page-sequence>\n    </xsl:for-each>\n</fo:root>\n</xsl:template>\n\n</xsl:stylesheet>',1,1,'2009-01-21 00:00:00',1,'2009-01-21 00:00:00');
/*!40000 ALTER TABLE `clinical_summary` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-01-22  1:18:10