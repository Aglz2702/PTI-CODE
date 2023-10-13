global class ResetNotificationsBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	global String query;
	Set<String> ids = new Set<String>();
	
	//Search the inspection reports and prepare the search for Contact functions to which the report will be sent
	global ResetNotificationsBatch() {
		query = 'SELECT Id, Alerta_0__c, Alerta_00__c, Alerta_000__c FROM Work_order__c Where (Status__c = \'Active\' OR Status__c = \'Approved WBS\') AND (Type__c = \'3cpr\' OR Type__c = \'L2\') AND (Alerta_0__c = true OR Alerta_00__c= true OR Alerta_000__c = true)';        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
    	System.debug('query  ----------------------------'+query);
    	//System.debug('----------------------------'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Work_order__c> scope) {
		if(!scope.isEmpty()){
            for(Work_order__c wo : scope){
                wo.Alerta_0__c = false;
                wo.Alerta_00__c = false;
                wo.Alerta_000__c = false;
            }
        }
        Update scope;
    }
    
    global void finish(Database.BatchableContext BC) {
		
	}
}