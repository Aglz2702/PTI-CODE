/**
 *  @Name           InspectionReportTriggerController
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description:   Class that serves as controller to the Inspection Reports trigger
**/
public with sharing class InspectionReportTriggerController {
	
	//Method that copies the ID of the work order that is referenced in the process to later use it in the daily reports
	public static void copyWOID(List<Inspection_report__c> newList){
		Map<String, String> partNumbersMap = new Map<String, String>();
		Set<String> partnumbers = new Set<String>();
		//List<Id> id_WO = new List<Id>();

		for(Inspection_report__c ir : newList){
			//id_WO.add(ir.Work_order__c);
			partnumbers.add(ir.Part_number__c);
		}

		//Map<Id, Work_order__c> wo_map = new Map<Id, Work_order__c>([SELECT Id, Finished_by_customer__c FROM Work_order__c WHERE Id IN: id_WO]);

		//The work order is searched by one of the parents of the current record
		List<Part_number__c> partsList = [SELECT Id, Work_order__c, Work_order__r.Finished_by_customer__c FROM Part_number__c WHERE id IN: partnumbers ];

		if(!partsList.isEmpty()){
			for(Part_number__c pNumber: partsList){
				if(pNumber.Work_order__r.Finished_by_customer__c){
					partNumbersMap.put(pNumber.Id, null);
				}else{
					partNumbersMap.put(pNumber.Id, pNumber.Work_order__c);
				}
			}
		}

		//The work order id is assigned
		for(Inspection_report__c ir2 : newList){
			if(partNumbersMap.get(ir2.Part_number__c) != null){
				ir2.Work_order__c = partNumbersMap.get(ir2.Part_number__c);
				}else{
					ir2.adderror(Label.InsertInspectionRepport01);
				}
		}
	}

	public static void checkPermissionsBeforeDelete(List<Inspection_report__c> oldList){
		
		for(Inspection_report__c ri : oldList){
			if(ri.Invoiced__c){
				ri.adderror(Label.DeleteInspectionRepport02);
			}
		}
	}
}