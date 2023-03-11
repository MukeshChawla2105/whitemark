trigger MessagingSessionToFetchAccount on MessagingSession (after delete) {

    if(trigger.isAfter && trigger.isInsert){
        System.debug('trigger is called');
        MessagingSessionHandlerClass.afterinsert(trigger.new);
    }
    
}