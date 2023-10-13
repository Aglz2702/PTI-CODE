/**
 *  @Name           DailyReportBatch
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Batch process that allows to know which inspection reports have a date of the previous day for daily reports
**/
global class DailyReportBatch implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
	global String query;
	Set<String> ids = new Set<String>();
	private Boolean dc;
	private Boolean wc;
	List<Contact_function__c> listCF = new List<Contact_function__c>();
	
	//Search the inspection reports and prepare the search for Contact functions to which the report will be sent
	global DailyReportBatch(Boolean dailyCheck, Boolean weeklyCheck) {
		dc = dailyCheck;
		wc = weeklyCheck;
		List<Inspection_report__c> iReports = new List<Inspection_report__c>();
		if(dc){
			iReports = [SELECT Id, Work_order__c FROM Inspection_report__c 
											   WHERE Date__c = YESTERDAY 
											   //WHERE Date__c =: Date.parse('26/11/2018')
											   AND (Work_order__r.Status__c =: 'Active' OR Work_order__r.Status__c =: 'Approved WBS')];
		}else if(wc){
			iReports = [SELECT Id, Work_order__c FROM Inspection_report__c 
											   WHERE Date__c = LAST_WEEK 
											   AND (Work_order__r.Status__c =: 'Active' OR Work_order__r.Status__c =: 'Approved WBS')];
		}
		if(!iReports.isEmpty()){
			for(Inspection_report__c r : iReports){
				ids.add(r.Work_order__c);
			}

			query = 'SELECT Id, Email_send__c FROM Contact_function__c WHERE Work_order__c IN: ids AND Send_daily_email__c = true';

		}else{
			query = '';
		}
	}
	
	//Find the contact functions to which the reports will be sent
	global List<Contact_function__c> start(Database.BatchableContext BC) {
		System.debug('query  ----------------------------'+query);
		if(!String.isEmpty(query)){
			Database.QueryLocator q =  Database.getQueryLocator(query);
			Database.QueryLocatorIterator qli = q.iterator();

			While(qli.hasNext()){
				listCF.add((Contact_function__c)qli.next());
			}
		}
		return listCF;
	}

	//Modify a field in the contact functions that triggers a workflow rule that starts the creation of the PDF
   	global void execute(Database.BatchableContext BC, List<Contact_function__c> scope) {
		
		if(!scope.isEmpty()){
			for(Contact_function__c cf : scope){
				if(dc){
					cf.Email_send__c = 'Daily';
				}else if(wc){
					cf.Email_send__c = 'Weekly';
				}
				
			}

			update scope;
		}
		
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}