trigger triggerOnLead on Lead (After insert,Before Insert, before update,after update) {
    
    //Added by shubham kumar
    TextLocalMessageonLeadCreation handler = new TextLocalMessageonLeadCreation();
    if(Trigger.isInsert && Trigger.isAfter){
        //Thia is a APiI Hit
        handler.leadInsert(Trigger.new);
        //If owner is there assigning it to owner
        handler.assignLead(Trigger.new);
        //If Lead source is FaceBook Or Missed Call
        //handler.assignLeadsBasedOnSource(Trigger.new);
        //Generating Score For the Lead
        handler.leadScoregeneration(Trigger.new);
        //Only Run If Needed - Actual Lead Assignment
        system.debug('runLeadAssignment'+LeadAssignmentExecutionCriteria.runLeadAssignment);
        if(LeadAssignmentExecutionCriteria.runLeadAssignment == true){
            LeadAssignmentExecutionCriteria.validateEntryCriteria(Trigger.New);
        }
        //handler.validatemanuallyCreatedLead(Trigger.new);
        // Insert task for the Lead
        handler.Createtask(trigger.new, trigger.newMap);
    } 
    
    if(Trigger.isUpdate && Trigger.isAfter){
        handler.updateLeadsToBeScored(Trigger.new);
        handler.CreateFollowuptask(trigger.newMap, trigger.oldMap);
    }    
    
    if(Trigger.isInsert && Trigger.isbefore){
        handler.updateCompanyBeforeInsert(Trigger.new);
        //LeadAssignmentExecutionCriteria.assignDefaultQueue(trigger.new);
    } 
    
    if(trigger.isBefore && trigger.isUpdate){
        LeadPhoneUpdateHelper.UpdateLeadPhone(trigger.new);
    }
}