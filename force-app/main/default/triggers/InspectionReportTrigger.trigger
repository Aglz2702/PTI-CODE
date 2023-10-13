/**
 *  @Name           InspectionReportTrigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Trigger of inspection reports that sends to call other processes
**/
trigger InspectionReportTrigger on Inspection_report__c (before insert, before delete) {

	if(trigger.isBefore){
		if(trigger.isInsert){
			InspectionReportTriggerController.copyWOID(trigger.new);
		}
		if(trigger.isDelete){
			if(FeatureManagement.checkPermission('DeleteInspectionRepportCP')){
					InspectionReportTriggerController.checkPermissionsBeforeDelete(trigger.old);
				}else{
					trigger.old[0].adderror(Label.DeleteInspectionRepport01);
				}
		}
	}
}