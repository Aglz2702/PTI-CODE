/**
 *  @Name           POA_TriggerController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Controller class of the PO assigment that has the logic to apply the methods described later
**/
public class POA_TriggerController {

	//Method that performs an approximate calculation of how long a PO assigned to a WO will last
	public static void checkExpireDays(List<PO_assignment__c> newList){
		Set<String> idPOs = new Set<String>();
		Set<String> idWOs = new Set<String>();

		for(PO_assignment__c po : newList){
			idWOs.add(po.Work_order__c);
			idPOs.add(po.Purchase_order__c);
		}

		//Check if the WO to which the POAs are assigned already have a total cost
		Map<Id,Work_order__c> mapsWO = new Map<Id,Work_order__c>([SELECT Id, Total_cost__c, Start_date__c, Type__c FROM Work_order__c WHERE Id IN: idWOs AND Total_cost__c > 0.0]);

		Map<Id,Purchase_order__c> mapPO = new Map<Id,Purchase_order__c>([SELECT Id, Remaining_amount__c FROM Purchase_order__c WHERE id IN: idPOs ]);

		for(PO_assignment__c p : newList){
			Integer days = 0;
			Decimal amount = 0.0;
			//If there is an already worked WO and with POA, it performs the calculations
			if(mapsWO.containsKey(p.Work_order__c)){
				////Calculates the days from the start date of the WO with respect to the current day
				days = mapsWO.get(p.Work_order__c).Start_date__c.daysBetween(Date.today());
				//Calculate the average amount of money spent per day in the WO 
				if(days != null && days != 0){
                    amount = (mapsWO.get(p.Work_order__c).Total_cost__c / days);
                }else{
                    amount = mapsWO.get(p.Work_order__c).Total_cost__c;
                }
				//Calculate the possible number of days that could be left to the PO
				p.Days_to_expire__c = (mapPO.get(p.Purchase_order__c).Remaining_amount__c/amount);

				//Send alert?
				if(mapsWO.get(p.Work_order__c).Type__c == 'L2' && p.Days_to_expire__c < 14 && !(p.Send_alert__c)){
					p.Send_alert__c	 = true;
				}else if(p.Days_to_expire__c < 7 && !(p.Send_alert__c)){
					p.Send_alert__c	 = true;
				}
			}
		}
	}
	
}