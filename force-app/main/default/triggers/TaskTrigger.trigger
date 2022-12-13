trigger TaskTrigger on Task (After insert, before insert) {

    if (trigger.isAfter && trigger.isInsert) {
        TaskTriggerHandler.TransferTask(trigger.new, trigger.newMap);
    }

    if (trigger.isBefore && trigger.isInsert) {
        TaskTriggerHandler.AssignAgentBeforeInsert(trigger.new, trigger.newMap);
    }

}