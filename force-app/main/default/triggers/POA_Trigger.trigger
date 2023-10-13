/**
 *  @Name           POA_Trigger
 *  @Copyright      DoIT Cloud Consulting
 *  @Author         Axel Valle <axel.valle@doitcloud.consulting>
 *  @Description    Trigger that has the logic to verify WO's Total cost and PO's Remaining balance
**/
trigger POA_Trigger on PO_assignment__c (before insert) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            POA_TriggerController.checkExpireDays(trigger.new);
        }
    }
}