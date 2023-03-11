public class MessagingSessionHandlerClass {
    
    public static void afterinsert(List<MessagingSession> mslist){
        
        Set<String> msguser = new Set<String>();
        for(MessagingSession ms : mslist){
          msguser.add(ms.MessagingEndUser.Name);  
            System.debug(ms.MessagingEndUser.Name);
        }
        
        List<Account> acclist = [SELECT Id,Name,Phone FROM Account WHERE Phone LIKE :('%' + msguser + '%')];
        if(acclist.size() > 0){
            system.debug('msguser--->'+msguser);
            system.debug('msguser2--->'+acclist);
        }
    }

}