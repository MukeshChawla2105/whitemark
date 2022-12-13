trigger TriggerOnAccount on Account (after update, after insert) {
    
    if(trigger.isafter){
        if(trigger.isupdate){
            AccountTriggerHandler.UpdateTaskSubjectOnFieldUpdate(Trigger.OldMap, Trigger.NewMap);
        }
    }
    
}