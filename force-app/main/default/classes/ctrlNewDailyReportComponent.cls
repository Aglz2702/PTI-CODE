/**
 *  @Name           ctrlNewDailyReportComponent
 *  @Copyright      PTI QCS
 *  @Author         Emmanuel Gonzalez <egonzalez@ptiqcs.com>
 *  @Description    Visualforce component driver that obtains the necessary information to assemble the PDF 
 					that will be sent daily to the client
**/
public class ctrlNewDailyReportComponent {

	public String idWO {get; set;}
	public Boolean dCheck {get;set;}
	public Boolean wCheck {get;set;}
	public Set<Id> partNumberIds {get;set;}
    public List<Inspection_report__c> bItems {get;set;}
    public List<Inspection_report__c> bItemsWeek {get;set;}
    public List<Inspection_report__c> bItemsGlo {get;set;}

	//Gets the record of the Work Order that is involved in the process
	public Work_order__c getWorkOrder(){
		return [SELECT Id, Name, Job_description__c, Problem__c, Global_defects__c, Global_QTY_Certified__c, Global_standard_hours__c, Global_overtime_hours__c FROM Work_order__c WHERE Id =: idWO];
	}
	
	//Obtain the inspection reports that are involved in the process
	public Map<String, List<Inspection_report__c>> getInspections(){
		partNumberIds = new Set<Id>();
		Map<String, List<Inspection_report__c>> inspectMap = new Map<String, List<Inspection_report__c>>();
		List<Inspection_report__c> ins = new List<Inspection_report__c>();
        
        bItems = [SELECT work_order__r.Name,Date__c, Billable_item__r.Name, Billable_item__r.Unit_cost__c,Quantity__c,Cost__c FROM Inspection_report__c WHERE Work_order__c =: idWO AND Date__c = YESTERDAY AND Cost__c >0 ORDER BY Cost__c ASC];
        bItemsWeek = [SELECT work_order__r.Name,Date__c, Billable_item__r.Name, Billable_item__r.Unit_cost__c,Quantity__c,Cost__c FROM Inspection_report__c WHERE Work_order__c =: idWO AND Date__c = LAST_WEEK AND Cost__c >0 ORDER BY Cost__c ASC];
        bItemsGlo = [SELECT work_order__r.Name,Date__c, Billable_item__r.Name, Billable_item__r.Unit_cost__c,Quantity__c,Cost__c FROM Inspection_report__c WHERE Work_order__c =: idWO AND Cost__c >0 ORDER BY Cost__c ASC];

		if(dCheck){
			ins = [SELECT Date__c,Part_number__c, Part_number__r.Name,
                   								Shift__c,Total_inspected__c, QTY_Certified__c, Total_defects__c,
                   								Rework__c, Description__c, Quantity__c, Billable_item__r.Name,
                   								Billable_item__r.Billable_Item_Type__c, Batch__c FROM Inspection_report__c 
                   							WHERE Work_order__c =: idWO AND Date__c = YESTERDAY AND Total_inspected__c >0 ORDER BY Date__c DESC]; //, Batch__c
		}else if(wCheck){
			ins = [SELECT Date__c,Part_number__c, Part_number__r.Name,
                   								Shift__c,Total_inspected__c, QTY_Certified__c, Total_defects__c,
                   								Rework__c, Description__c, Quantity__c, Billable_item__r.Name,
                   								Billable_item__r.Billable_Item_Type__c, Batch__c FROM Inspection_report__c
										  WHERE Work_order__c =: idWO AND Date__c = LAST_WEEK AND Total_inspected__c >0 ORDER BY Date__c DESC]; //, Batch__c
		}

		for(Inspection_report__c i : ins){
			if(inspectMap.containsKey(i.Part_number__c)){
				inspectMap.get(i.Part_number__c).add(i);
			}else{
				inspectMap.put(i.Part_number__c, new List<Inspection_report__c>());
				inspectMap.get(i.Part_number__c).add(i);
			}

			partNumberIds.add(i.Part_number__c);
		}
		return inspectMap;
	}

	//Get the date of the previous day
	public Date getDateYesterday(){
		return Date.today().addDays(-1);
	}

	public Date getFirstDate(){
		return Date.today().addDays(-7);
	}

	//Get the part numbers involved in the process
	public Map<Id, Part_number__c> getPartNumbers(){
		Map<Id, Part_number__c> mapPartN = new Map<Id, Part_number__c>([SELECT Name, Total_QTY_Certified__c, Total_rework__c, 
										 Total_inspected__c, Total_defects__c, Defect_description__c FROM Part_number__c
										WHERE Id IN: partNumberIds AND Total_inspected__c>0]); 

		return mapPartN;
	}

}