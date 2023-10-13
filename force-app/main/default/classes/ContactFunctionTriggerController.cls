/**
 *  @Name           ContactFunctionTriggerController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Controller class of the Contact Function trigger that has the logic to apply the methods described later
**/

public class ContactFunctionTriggerController {
	/*
		Method that verifies that the work order does not have a contact function with the same Role 
		that is necessary to send to sign to Docusign
	*/
	public static void checkRoles(Map<Id,Contact_function__c> newMap, Map<Id,Contact_function__c> oldMap){

		Map<String, Map<String, List<Contact_function__c>>> cfMap = new Map<String, Map<String, List<Contact_function__c>>>();

		for(Contact_function__c c : newMap.values()){
			if(!cfMap.containsKey(c.Work_order__c))
				cfMap.put(c.Work_order__c, new Map<String, List<Contact_function__c>>());
		}

		for(Contact_function__c cf : [SELECT id, Work_order__c, Role__c, Contact_type__c FROM Contact_function__c WHERE Work_order__c =: cfMap.keySet()]){
			if(cfMap.containsKey(cf.Work_order__c)){
				if(!cfMap.get(cf.Work_order__c).containsKey(cf.Role__c)){
					cfMap.get(cf.Work_order__c).put(cf.Role__c, new List<Contact_function__c>());
					cfMap.get(cf.Work_order__c).get(cf.Role__c).add(cf);
				}else{
					cfMap.get(cf.Work_order__c).get(cf.Role__c).add(cf);
				}
			}
		}


		for(Contact_function__c cf2 : newMap.values()){

			if(cfMap.containsKey(cf2.Work_order__c)){
				if(cfMap.get(cf2.Work_order__c).containsKey('Coordinator') && 
					(newMap.get(cf2.Id).Role__c != oldMap.get(cf2.Id).Role__c) &&  cf2.Role__c == 'Coordinator'){
					cf2.addError('There can only be one Coordinator Role in one Work order');
				}
				if(cfMap.get(cf2.Work_order__c).containsKey('Process engineer') && 
					(newMap.get(cf2.Id).Role__c != oldMap.get(cf2.Id).Role__c) &&  cf2.Role__c == 'Process engineer'){
					cf2.addError('There can only be one Process engineer Role in one Work order');
				}
				if(cfMap.get(cf2.Work_order__c).containsKey('SQA') && 
					(newMap.get(cf2.Id).Role__c != oldMap.get(cf2.Id).Role__c) &&  cf2.Role__c == 'SQA'){
					cf2.addError('There can only be one SQA Role in one Work order');
				}
				if(cfMap.get(cf2.Work_order__c).containsKey('Quality') && 
					(newMap.get(cf2.Id).Role__c != oldMap.get(cf2.Id).Role__c) &&  cf2.Role__c == 'Quality'){
					cf2.addError('There can only be one Quality Role in one Work order');
				}
				if(cfMap.get(cf2.Work_order__c).containsKey('Finance') && 
					(newMap.get(cf2.Id).Role__c != oldMap.get(cf2.Id).Role__c) &&  cf2.Role__c == 'Finance'){
					for(Contact_function__c cfu : cfMap.get(cf2.Work_order__c).get(cf2.Role__c)){
						if(cfu.Contact_type__c == 'Customer')
							cf2.addError('There can only be one Customer Finance Role in one Work order');
					}
					
				}
			}
				
		}

	}		


}