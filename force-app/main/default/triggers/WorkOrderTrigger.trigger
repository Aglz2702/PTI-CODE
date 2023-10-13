trigger WorkOrderTrigger on Work_order__c (before insert,before update) {
	if(trigger.isBefore){
		if(trigger.isInsert){
			//workOrderTriggerController.NotRepeat(trigger.new);
		}
		if(trigger.isUpdate){
			//workOrderTriggerController.NotRepeat(trigger.new);
			workOrderTriggerController.FolioAssigmentUpdate(trigger.newMap,trigger.oldMap);
			workOrderTriggerController.updateClientDate(trigger.newMap,trigger.oldMap);
		}
	}

}