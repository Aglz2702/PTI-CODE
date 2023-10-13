/**
 *  @Name           Contact_function_Trigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Trigger that has the logic to verify that contacts has a certain type of Role and take actions
**/
 
trigger Contact_function_Trigger on Contact_function__c (before insert, before update) {

    if(trigger.isBefore){
        if(trigger.isUpdate){

        	Map<Id, Contact_function__c> nuevos = new Map<Id, Contact_function__c>();
        	Map<Id, Contact_function__c> viejos = new Map<Id, Contact_function__c>();

        	for(Id llave : trigger.newMap.keySet()){
        		if(trigger.newMap.get(llave).Role__c != trigger.oldMap.get(llave).Role__c){
        			nuevos.put(llave, trigger.newMap.get(llave));
        			viejos.put(llave, trigger.oldMap.get(llave));
        		}
        	}
        	if(!nuevos.isEmpty() && !viejos.isEmpty())
            	ContactFunctionTriggerController.checkRoles(nuevos, viejos);
        }
    }

}