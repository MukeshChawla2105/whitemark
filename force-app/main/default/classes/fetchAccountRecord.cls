public class fetchAccountRecord {
    
    @AuraEnabled
    public static String fetchphone(String msid){
        MessagingSession ms = [SELECT Id,MessagingEndUser.Name,Status from MessagingSession WHERE Id =: msid AND Status = 'Active'];
        String messagephone =  ms.MessagingEndUser.Name ;
        String phone = messagephone.right(messagephone.length()-12);
        system.debug('messagephone-->'+phone);
        List<Account> acclist = [SELECT Id,Name,Phone FROM Account WHERE Phone LIKE : phone  LIMIT 1 ]; 
       
        String accid ;
        for(Account acc : acclist){
            accid = acc.Id;   
        }
        System.debug('accid--->'+accid);
        return accid;
    }
    
}