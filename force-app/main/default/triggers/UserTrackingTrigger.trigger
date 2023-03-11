trigger UserTrackingTrigger on User_Tracking__c (before insert,after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        UserTrackingTriggerHelper.LeadAssignmentMethod(trigger.new);
    } 
    
    if(Trigger.isInsert && Trigger.isbefore){
        
    } 
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
    }
}