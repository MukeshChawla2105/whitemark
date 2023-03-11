trigger TaskTrigger on Task (After insert, before insert) {

    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Task');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c) {
        if (trigger.isAfter && trigger.isInsert) {
            TaskTriggerHandler.TransferTask(trigger.new, trigger.newMap);
        }
    
        if (trigger.isBefore && trigger.isInsert) {
            TaskTriggerHandler.AssignAgentBeforeInsert(trigger.new, trigger.newMap);
        }

    }
}