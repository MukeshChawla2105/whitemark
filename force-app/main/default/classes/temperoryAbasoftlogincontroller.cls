public class temperoryAbasoftlogincontroller {
    
    @RemoteAction
    public static void loginUser(string userName, string password){

        //PageReference MyNewPage     = new PageReference();
        // try{
        //     List<AbbaSoft_User__c> AabaSoftUser = [SELECT Name,AabaSoft_UserName__c,Agent_Unique_Id__c,Assignment_Id__c,Campaign__c,CampaignID__c,Contact_Number__c,CreatedOn__c,Email_Id__c, First_Name__c,HashCode__c, IsTaskAssigned__c,Last_Name__c,Password__c,Username__c
        //                                       FROM AbbaSoft_User__c WHERE Username__c =:userName AND Password__c =:password LIMIT  1];
        //     system.debug('AabaSoftUser----'+AabaSoftUser);
        //     if(AabaSoftUser.size() > 0 ){
        //         // String currentAgentId;
        //         // String hasCode;
        //         // currentAgentId = AabaSoftUser[0].id;
        //         // AbbaSoft_User__c AabaSoftAgent = new AbbaSoft_User__c();
        //         // AabaSoftAgent.HashCode__c = Utility.generateRandomString();
        //         // if (AabaSoftAgent.HashCode__c != null) {
                
        //         //     Cookie userHashCodeCookie= new Cookie('userHashCodeCookie',AabaSoftAgent.HashCode__c,null,(18000),false);
        //         //     ApexPages.currentPage().setCookies(new Cookie[]{ userHashCodeCookie });
        //         //     System.debug('userHashCodeCookie ====> ' + userHashCodeCookie);
                    
        //         // }
        //         // //CookieControllerForAabaSoftUser.StoreHashCodeAfterLogin(AabaSoftAgent.HashCode__c);
        //         // AabaSoftAgent.Id = currentAgentId;
        //         // hasCode = String.valueOf(AabaSoftAgent.HashCode__c) ;
        //         // System.debug('The Hash Code Value');
        //         // update AabaSoftAgent;
        //         // return AabaSoftAgent.HashCode__c;
        //     }else{
        //         return null; 
        //     }
        // }catch(exception e){
        //     system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
        //     return null;
        // }   
    }

}