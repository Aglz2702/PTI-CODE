/**
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Jaziel Morán <jaziel.moran@doitcloud.consulting>
**/

global class AverageOfDaysRemainingBatch implements Database.Batchable<sObject> {
	
	global String query; 
    List<id> ids=new List<id>();
    global AverageOfDaysRemainingBatch() {
        query = 'SELECT Id, Days_to_expire__c, Send_alert__c, Work_order__r.Id, Work_order__r.Type__c, Work_order__r.Total_cost__c, Work_order__r.Start_date__c, Purchase_order__r.Id, Purchase_order__r.Remaining_amount__c  FROM PO_assignment__c WHERE Work_order__r.Total_cost__c > 0.0 AND Purchase_order__r.Remaining_amount__c > 100 AND Purchase_order__r.Status__c = \'Approved\' AND (Work_order__r.Status__c = \'Active\' OR Work_order__r.Status__c = \'Approved WBS\')';
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	System.debug('query  ----------------------------'+query);
        system.debug('HOLAA!!1');
    	//System.debug('----------------------------'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<PO_assignment__c> scope) {
        for(PO_assignment__c p : scope){
			Integer days = 0;
			Decimal amount = 0.0;
			days = p.Work_order__r.Start_date__c.daysBetween(Date.today());
			amount = p.Work_order__r.Total_cost__c / days;
			p.Days_to_expire__c = p.Purchase_order__r.Remaining_amount__c / amount;
			if(p.Work_order__r.Type__c == 'L2'){
				if(p.Days_to_expire__c < 14 && p.Send_alert__c==False){
					p.Send_alert__c = True;
				}
			}else{
				if(p.Days_to_expire__c < 7 && p.Send_alert__c == False){
					p.Send_alert__c = True;
				}
			}
		}
		update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
	
}