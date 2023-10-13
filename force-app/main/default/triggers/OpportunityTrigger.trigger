trigger OpportunityTrigger on Opportunity (before insert) {

	if(trigger.isBefore){
		if(trigger.isInsert){
			//FolioAssigmentOpp.FolioAssigment(trigger.new);
		}
	}

}