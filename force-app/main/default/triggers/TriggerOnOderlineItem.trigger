trigger TriggerOnOderlineItem on OrderItem (after insert, before insert) {

    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('OrderItem');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c) {
        if (trigger.isAfter && trigger.isInsert) {
            OrdeLineitemTriggerHandler.ClosedWonOpportunityOnBasisOFOrderItem(trigger.newMap, trigger.oldMap);
        }
        
    }
}