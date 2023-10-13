public with sharing class workOrderTriggerController {

	public static void FolioAssigmentUpdate(map<Id,Work_order__c> newMap, map<Id,Work_order__c> oldMap) {
		for(id idWO:newMap.keySet()){
			//if(oldMap.get(idWO).Status__c == 'Draft' && newMap.get(idWO).Status__c != 'Draft'){
				if(newMap.get(idWO).Cost_center__c != null && oldMap.get(idWO).Cost_center__c != newMap.get(idWO).Cost_center__c){
					String tipo = Cost_centers__c.getValues(newMap.get(idWO).Cost_center__c).Folio__c;
					/**Se hizo la búsqueda dentro del for, ya que fué pensado en el procesamiento de un registro a la vez**/
					List<Work_order__c> anterior = new List<Work_order__c>([Select Id,Name From Work_order__c Where (Name Like: tipo+'%' AND Id !=: idWO) ORDER BY Name DESC limit 1]);
					if(anterior.size() != 0){
						String nameWo = anterior[0].Name;
						String folioStr = nameWo.split('-')[3];
						integer folioDec = integer.valueOf(folioStr);
						folioDec++;
						String newFolio = String.valueof(folioDec).leftPad(4).replace(' ', '0');
						newMap.get(idWO).Name = tipo + newFolio;
					}else{
						newMap.get(idWO).Name = tipo + '0001';
					}
				}
				else{
					//newMap.get(idWO).addError(Label.Lack_of_values_for_the_WO_name);
				}
			//}

		}
	}

	public static void updateClientDate(map<Id,Work_order__c> newMap, map<Id,Work_order__c> oldMap){
		for(id idWOrder : newMap.keySet()){
			if(newMap.get(idWOrder).Status__c != oldMap.get(idWOrder).Status__c && 
				 (newMap.get(idWOrder).Status__c == 'Approved WBS' || newMap.get(idWOrder).Status__c == 'Completed') &&
				  newMap.get(idWOrder).Customer_approval_date__c == null){
				newMap.get(idWOrder).Customer_approval_date__c = Datetime.now();			}
		}
	}

	
}