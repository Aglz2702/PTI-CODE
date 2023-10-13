/**
 *  @Name           contactTriggerController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Controller class of the Contact trigger that has the logic to apply the methods described later
**/
public with sharing class contactTriggerController {
	
	//Method that disables the sending of daily emails for contact functions in active and approved Work orders if 
	//the contact passes from active status or suspended to inactive
	public static void deactivateContactFunctions(set<Id> inactiveContacts){

		List<Contact_function__c> cf = new List<Contact_function__c>();
		cf = [SELECT Send_daily_email__c, Id FROM Contact_function__c 
		      WHERE Contact__c IN: inactiveContacts AND (Work_order__r.Status__c =: 'Active' OR Work_order__r.Status__c =: 'Approved')];

		if(!cf.isEmpty()){
			for(Contact_function__c c : cf){
				c.Send_daily_email__c = false;
			}
			update cf;
		}
	}

	//Method that activates the sending of daily emails for contact functions in active and approved Work orders if 
	//the contact passes from inactive to active or suspended status
	public static void activateContactFunctions(set<Id> activeContacts){

		List<Contact_function__c> contactF = new List<Contact_function__c>();
		contactF = [SELECT Send_daily_email__c, Id FROM Contact_function__c 
		      WHERE Contact__c IN: activeContacts AND (Work_order__r.Status__c =: 'Active' OR Work_order__r.Status__c =: 'Approved')];

		if(!contactF.isEmpty()){
			for(Contact_function__c c : contactF){
				c.Send_daily_email__c = true;
			}
			update contactF;
		}
	}
}