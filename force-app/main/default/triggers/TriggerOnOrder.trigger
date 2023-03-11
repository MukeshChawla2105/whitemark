trigger TriggerOnOrder on Order (after insert,after update) {
    
    if(trigger.isAfter){
        if(trigger.isinsert){
            //OrderTriggerHandler.CreateTaskOnOrderCreation(trigger.new);
            OrderTriggerHandler.OrdermanualShareRead(trigger.new);
            OrderTriggerHandler.createFEMIandhappycallTask(trigger.newMap, trigger.oldMap);
        }
    }
    
    if(Trigger.isUpdate && Trigger.isAfter){
        OrderTriggerHandler.completeHappyCall(Trigger.new,Trigger.oldMap);
        OrderTriggerHandler.CreateFEMIcall(trigger.oldMap, trigger.newmap);
    }

}