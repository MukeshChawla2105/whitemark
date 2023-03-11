public without sharing class AabaSoftLogInFormController {
    public String userName { get; set; }
    public String password { get; set; }
    public String PhoneNumber { get; set; }
    public String AgentuniqueID { get; set; }

    public PageReference loginUser(){
        AgentuniqueID = Apexpages.currentPage().getparameters().get('AgentId');
        PhoneNumber = Apexpages.currentPage().getparameters().get('Phone');
        
        System.debug('userName =====>' + userName);
        System.debug('password =====>' + password);
        System.debug('PhoneNumber =====>' + PhoneNumber);
        System.debug('AgentuniqueID =====>' + AgentuniqueID);
        
        //String LoginPageBaseurl = 'https://whitemart--partial.sandbox.my.salesforce-sites.com/Abasoft_LoginPage';
        String LoginPageBaseurl = System.Label.LoginPageBaseurl;
        //String CustomerDetailPageBaseUrl = 'https://whitemart--partial--c.sandbox.vf.force.com/apex/CusomerDetailAURA_IN_VFPage';
        String CustomerDetailPageBaseUrl = System.Label.CustomerDetailPageBaseUrl;

        // LoginPageBaseurl = LoginPageBaseurl + '?id='+ '&Phone=' + '&AgentId=';
        PageReference MyNewPage;
        
        try{
            List<AbbaSoft_User__c> AabaSoftUser = [SELECT Name,AabaSoft_UserName__c,Agent_Unique_Id__c,Assignment_Id__c,Campaign__c,CampaignID__c,Email_Id__c,Contact_Number__c,CreatedOn__c, First_Name__c,HashCode__c, IsTaskAssigned__c,Last_Name__c,Password__c, Username__c
                                              FROM AbbaSoft_User__c WHERE  Username__c =:userName AND Password__c =:password LIMIT  1]; //
            system.debug('AabaSoftUser----'+AabaSoftUser);
            AbbaSoft_User__c AabaSoftAgent = new AbbaSoft_User__c();
            AabaSoftAgent.HashCode__c = Utility.generateRandomString();
            if(AabaSoftUser.size() > 0 ){
                String currentAgentId;
                String hasCode;
                currentAgentId = AabaSoftUser[0].id;
                if (AabaSoftAgent.HashCode__c != null) {
                
                    Cookie userHashCodeCookie= new Cookie('userHashCodeCookie',AabaSoftAgent.HashCode__c,null,(18000),true);
                    ApexPages.currentPage().setCookies(new Cookie[]{ userHashCodeCookie });
                    System.debug('userHashCodeCookie ====> ' + userHashCodeCookie);
                    
                }
                //CookieControllerForAabaSoftUser.StoreHashCodeAfterLogin(AabaSoftAgent.HashCode__c);
                AabaSoftAgent.Id = currentAgentId;
                hasCode = String.valueOf(AabaSoftAgent.HashCode__c);
                System.debug('The Hash Code Value');
                update AabaSoftAgent;
                //return AabaSoftAgent.HashCode__c;
                if (AabaSoftAgent.id != null) {
                    CustomerDetailPageBaseUrl = CustomerDetailPageBaseUrl + '?id='+ AabaSoftAgent.HashCode__c+ '&Phone='+ PhoneNumber + '&AgentId='+ AgentuniqueID;
                    MyNewPage     = new PageReference(CustomerDetailPageBaseUrl);
                    MyNewPage.setRedirect(true);
                } 
                // else{
                //     LoginPageBaseurl = LoginPageBaseurl + '?id='+ AabaSoftAgent.HashCode__c+ '&Phone='+ PhoneNumber + '&AgentId='+ AgentuniqueID;
                //     MyNewPage     = new PageReference(CustomerDetailPageBaseUrl);
                //     MyNewPage.setRedirect(true);
                // }
            }
            else {
                LoginPageBaseurl = LoginPageBaseurl + '?id='+ AabaSoftAgent.HashCode__c+ '&Phone='+ PhoneNumber + '&AgentId='+ AgentuniqueID + '&State=Invalid';
                MyNewPage     = new PageReference(LoginPageBaseurl);
                //MyNewPage.getParameters().put('State','Invalid');
                MyNewPage.setRedirect(true);
            }
            System.debug('--- pg val'+MyNewPage);
            return MyNewPage;
        }catch(exception e){
            system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
            return null;
        }   
    }
    
     // Forget Reset Email 
    @RemoteAction 
    Public Static String ForgetPassReviewer(String emailId){
        try{
            List<AbbaSoft_User__c> AabaSoftUser = [SELECT Name,AabaSoft_UserName__c,Agent_Unique_Id__c,Assignment_Id__c,Campaign__c,CampaignID__c,Email_Id__c,Contact_Number__c,CreatedOn__c, First_Name__c,HashCode__c, IsTaskAssigned__c,Last_Name__c,Password__c,Username__c
                                                    FROM AbbaSoft_User__c WHERE Username__c =:emailId LIMIT  1]; //
        System.debug('AabaSoftUser----------->'+AabaSoftUser);
        if(AabaSoftUser.size()>0){
            String currentAgentId;
            String hashCode;
            currentAgentId = AabaSoftUser[0].id;
            AbbaSoft_User__c AabaSoftUserTobeUpdated = new AbbaSoft_User__c();
            AabaSoftUserTobeUpdated.HashCode__c = Utility.generateRandomString();
            AabaSoftUserTobeUpdated.Id = currentAgentId;
                hashCode = String.valueOf(AabaSoftUserTobeUpdated.HashCode__c) ;
                System.debug('The Hash Code Value========'+hashCode);

                /*List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                 EmailTemplate temp = [SELECT Id,HTMLValue,Subject,Body FROM EmailTemplate WHERE Name = 'Reviewer Password Reset' ];
                 String htmlBody = temp.HTMLValue;
                 String subject = temp.Subject;
                 String plainTextBody = temp.body;

                 htmlBody = htmlBody.replace('{!Reviewer__c.Name}', RevList[0].Name);
                 htmlBody = htmlBody.replace('{!Reviewer__c.Login_Hash_Code__c}', Rev.Login_Hash_Code__c);
                 htmlBody = htmlBody.replace('{!$Label.Reviewer_Password_Reset}', Label.Reviewer_Password_Reset);

                 plainTextBody = plainTextBody.replace('{!Reviewer__c.Name}', RevList[0].Name);
                 plainTextBody = plainTextBody.replace('{!Reviewer__c.Login_Hash_Code__c}', Rev.Login_Hash_Code__c);
                 plainTextBody = plainTextBody.replace('{!$Label.Reviewer_Password_Reset}', Label.Reviewer_Password_Reset);
                 System.debug('The  str plainTextBody Value========'+plainTextBody);

          

               Messaging.SingleEmailMessage mailTemp = new Messaging.SingleEmailMessage();
               //mailTemp.setTemplateId(temp.id);
               mailTemp.setHtmlBody(htmlBody);
               mailTemp.setSubject(temp.subject);
               mailTemp.setPlainTextBody(plainTextBody);
               System.debug('The  str Value========'+RevList[0].Email__c);
               //mailTemp.setTargetObjectId(Rev.id);
               mailTemp.toAddresses = new String[] {  RevList[0].Email__c};

               //mailTemp.setToAddresses(Rev.Email__c);
               mailList.add(mailTemp);
               if(!mailList.isEmpty()){
                 Messaging.sendEmail(mailList);
               }*/
                update AabaSoftUserTobeUpdated;
                return AabaSoftUserTobeUpdated.HashCode__c;
        }

        }catch(exception e){
            system.debug(e.getLineNumber()+'---error Message---'+e.getMessage());
            return null;
        }   
        return null;
    }

     //  Reset Password Email 
     @RemoteAction 
     public Static String ResetPassword(String password, String loginhashcode){
        try{
            AbbaSoft_User__c AabaSoftUser = [SELECT Name,AabaSoft_UserName__c,Agent_Unique_Id__c,Assignment_Id__c,Campaign__c,CampaignID__c,Email_Id__c,Contact_Number__c,CreatedOn__c, First_Name__c,HashCode__c, IsTaskAssigned__c,Last_Name__c,Password__c,  Username__c
                                                    FROM AbbaSoft_User__c WHERE HashCode__c =:loginhashcode LIMIT  1];
            //AbbaSoft_User__c ReviUpdate = [SELECT Id,Name,Email__c, Password__c, Login_Hash_Code__c FROM Reviewer__c WHERE Login_Hash_Code__c =: loginhashcode  LIMIT 1]; //
            AabaSoftUser.Password__c = password;
            AabaSoftUser.HashCode__c = Utility.generateRandomString();
            update AabaSoftUser;
            return AabaSoftUser.HashCode__c;

        }catch(Exception e){
                System.debug('The Error '+e.getMessage());
                System.debug('Erron Line '+e.getLineNumber());
            }
            return null;
     }

     public PageReference checkExistingHashKey(){

        //String LoginPageBaseurl = 'https://whitemart--partial.sandbox.my.salesforce-sites.com/Abasoft_LoginPage';
        String LoginPageBaseurl = System.Label.LoginPageBaseurl;
        //String CustomerDetailPageBaseUrl = 'https://whitemart--partial.sandbox.my.salesforce-sites.com/CusomerDetailAURA_IN_VFPage';
        String CustomerDetailPageBaseUrl = System.Label.CustomerDetailPageBaseUrl;
        // LoginPageBaseurl = LoginPageBaseurl + '?id='+ '&Phone=' + '@AgentId=';
        // PageReference MyNewPage     = new PageReference(LoginPageBaseurl);
        //String PhoneNumber = '';
        String ExistingHashcode = '';
        string FinalPageToRedirect = '';
        Boolean redirecttoLoginPage;
        List<AbbaSoft_User__c> abasoftUser = new List<AbbaSoft_User__c>();

        String LoginHashcode = Apexpages.currentPage().getparameters().get('id');
        String PhoneNumber = Apexpages.currentPage().getparameters().get('Phone');
        String AgentUniqueCode = Apexpages.currentPage().getparameters().get('AgentId');
        string headerdata= ApexPages.currentPage().getHeaders().get('Host');
        string urlvalue=Apexpages.currentPage().getUrl();

        System.debug('hashCode ======> ' + Apexpages.currentPage().getparameters().get('id'));
        System.debug('Phone ======> ' + Apexpages.currentPage().getparameters().get('Phone'));
        System.debug('headerdata ====> ' + headerdata);
        System.debug('headerdata ====> ' + urlvalue);
        
        Cookie userHashCodeCookie = ApexPages.currentPage().getCookies().get('userHashCodeCookie');
        System.debug('userHashCodeCookie ==> ' + userHashCodeCookie);

        // if (userHashCodeCookie != null && PhoneNumber !=null && AgentUniqueCode != null && LoginHashcode == '') {
        //     FinalPageToRedirect = LoginPageBaseurl+ '?id='+LoginHashcode + '&Phone='+PhoneNumber + '&AgentId='+ AgentUniqueCode;
        //     System.debug('FinalPageToRedirect  ====> ' + FinalPageToRedirect);
        //     redirecttoLoginPage = false;
        // }
        // else 

        
        if (userHashCodeCookie != null  && AgentUniqueCode != null && PhoneNumber !=null  && LoginHashcode == '' ) {
            ExistingHashcode = String.valueOf(userHashCodeCookie.getValue());
            system.debug('userHashCodeCookie'+userHashCodeCookie);
            system.debug('AgentUniqueCode'+AgentUniqueCode);
            system.debug('PhoneNumber'+PhoneNumber);
            system.debug('ExistingHashcode'+ExistingHashcode);
            system.debug('LoginHashcode'+LoginHashcode);
            abasoftUser = [Select Id , Agent_Unique_Id__c, CampaignID__c, HashCode__c From AbbaSoft_User__c 
                            Where HashCode__c =: ExistingHashcode  AND Agent_Unique_Id__c =: AgentUniqueCode];
            system.debug('Size is '+abasoftUser);
            if (abasoftUser.size()>0) {
                    FinalPageToRedirect = CustomerDetailPageBaseUrl+ '?id='+ExistingHashcode + '&Phone='+PhoneNumber + '&AgentId='+ AgentUniqueCode;
                    //redirecttoLoginPage = false;
            }else{
               FinalPageToRedirect = CustomerDetailPageBaseUrl+ '?id='+ExistingHashcode + '&Phone='+PhoneNumber + '&AgentId='+ AgentUniqueCode; 
            }
            System.debug('FinalPageToRedirect  ====> ' + FinalPageToRedirect);
            PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
            CustomerDetailPage.setRedirect(true);
            return CustomerDetailPage;
        }
        else if (LoginHashcode == '' && PhoneNumber !=null && AgentUniqueCode != null && userHashCodeCookie == null) {
                if (LoginHashcode == '' || LoginHashcode == null) {
                    LoginHashcode = Utility.generateRandomString();
                }   
                FinalPageToRedirect = LoginPageBaseurl + '?id='+ LoginHashcode +'&Phone='+ PhoneNumber + '&AgentId='+ AgentUniqueCode; 
                System.debug('FinalPageToRedirect =====> ' + FinalPageToRedirect);
                PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
                CustomerDetailPage.setRedirect(true);
                return CustomerDetailPage;
                //FinalPageToRedirect = LoginPageBaseurl + '/'; // + '?id=' +'&Phone='+ '&AgentId='; 
        }
        //https://whitemart--partial.sandbox.my.salesforce-sites.com/Abasoft_LoginPage?id=&Phone=09562279968&AgentId=3E623D2C-C74E-ED11-80C4-00155D010613
        //https://whitemart.secure.force.com/Abasoft_LoginPage?id=&Phone=09562279968&AgentId=3E623D2C-C74E-ED11-80C4-00155D010613
        // PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
        // CustomerDetailPage.setRedirect(true);
        // return CustomerDetailPage;
        //demoagent@ofabi.com
        //9633916970
        return null;
     }

}