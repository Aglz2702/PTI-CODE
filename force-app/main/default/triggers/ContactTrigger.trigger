/**
 *  @Name           ContactTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Trigger that has the logic to verify that contacts change status and call their controller to process that data
**/
trigger ContactTrigger on Contact (before insert, after update) {

	if(trigger.isAfter){
		if(trigger.isUpdate){
			set<Id> inactiveContacts = new set<Id>();
			set<Id> activeContacts = new set<Id>();
			for(String cad : trigger.newMap.keyset()){
				//Verify if the status went from Active or Suspended to Inactive
				if((trigger.oldMap.get(cad).Status__c == 'Active' && trigger.newMap.get(cad).Status__c == 'Inactive')
					|| (trigger.oldMap.get(cad).Status__c == 'Suspended' && trigger.newMap.get(cad).Status__c == 'Inactive')){
					inactiveContacts.add(trigger.newMap.get(cad).Id);
				}
				//Verify if the status changed from Inactive to Active or Suspended
				if((trigger.oldMap.get(cad).Status__c == 'Inactive' && trigger.newMap.get(cad).Status__c == 'Active')
					|| (trigger.oldMap.get(cad).Status__c == 'Inactive' && trigger.newMap.get(cad).Status__c == 'Suspended')){
					activeContacts.add(trigger.newMap.get(cad).Id);
				}
			}

			//If the set is not empty, it calls a method of its controlling class
			if(!inactiveContacts.isEmpty())
				contactTriggerController.deactivateContactFunctions(inactiveContacts);
				
			//If the set is not empty, it calls a method of its controlling class
			if(!activeContacts.isEmpty())
				contactTriggerController.activateContactFunctions(activeContacts);
		}
	}
}