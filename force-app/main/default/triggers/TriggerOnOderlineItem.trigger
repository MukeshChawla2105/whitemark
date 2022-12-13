trigger TriggerOnOderlineItem on OrderItem (after insert, before insert) {
    
    if (trigger.isAfter && trigger.isInsert) {
        OrdeLineitemTriggerHandler.ClosedWonOpportunityOnBasisOFOrderItem(trigger.newMap, trigger.oldMap);
    }
    

}