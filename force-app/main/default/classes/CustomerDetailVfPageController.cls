public without sharing class CustomerDetailVfPageController {
    
    public PageReference checkExistingHashKeyMatching(){

        //String LoginPageBaseurl = 'https://whitemart--partial.sandbox.my.salesforce-sites.com/Abasoft_LoginPage';
        //String CustomerDetailPageBaseUrl = 'https://whitemart--partial.sandbox.my.salesforce-sites.com/CusomerDetailAURA_IN_VFPage';

        String LoginPageBaseurl = System.Label.LoginPageBaseurl;
        String CustomerDetailPageBaseUrl = System.Label.CustomerDetailPageBaseUrl;
        // LoginPageBaseurl = LoginPageBaseurl + '?id='+ '&Phone=' + '@AgentId=';
        // PageReference MyNewPage     = new PageReference(LoginPageBaseurl);
        //String PhoneNumber = '';
        String ExistingHashcode = '';
        string FinalPageToRedirect = '';
        Boolean redirecttoLoginPage;
        //List<AbbaSoft_User__c> abasoftUser = new List<AbbaSoft_User__c>();

        String LoginHashcode = Apexpages.currentPage().getparameters().get('id');
        String PhoneNumber = Apexpages.currentPage().getparameters().get('Phone');
        String AgentUniqueCode = Apexpages.currentPage().getparameters().get('AgentId'); //IsReloading
        String Reloading = Apexpages.currentPage().getparameters().get('IsReloading');
        // string headerdata= ApexPages.currentPage().getHeaders().get('Host');
        // string urlvalue=Apexpages.currentPage().getUrl();

        System.debug('hashCode ======> ' + Apexpages.currentPage().getparameters().get('id'));
        System.debug('Phone ======> ' + Apexpages.currentPage().getparameters().get('Phone'));
        System.debug('Reloading ====> ' + Reloading);
        // System.debug('headerdata ====> ' + urlvalue);
        
        Cookie userHashCodeCookie = ApexPages.currentPage().getCookies().get('userHashCodeCookie');
        System.debug('userHashCodeCookie ==> ' + userHashCodeCookie);

        if (userHashCodeCookie != null && LoginHashcode != null) {
            ExistingHashcode = String.valueOf(userHashCodeCookie.getValue());
            if (LoginHashcode == ExistingHashcode) {
                if (Reloading == '') {
                    FinalPageToRedirect = CustomerDetailPageBaseUrl+ '?id='+ExistingHashcode + '&Phone='+PhoneNumber + '&AgentId='+ AgentUniqueCode + '&IsReloading=true';
                    PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
                    CustomerDetailPage.setRedirect(true);
                    return CustomerDetailPage; 
                }
                
            }
        }else {
            FinalPageToRedirect = LoginPageBaseurl + '?id='+ LoginHashcode +'&Phone='+ PhoneNumber + '&AgentId='+ AgentUniqueCode; 
                System.debug('FinalPageToRedirect =====> ' + FinalPageToRedirect);
                PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
                CustomerDetailPage.setRedirect(true);
                return CustomerDetailPage;
        }

        // if (userHashCodeCookie != null  && AgentUniqueCode != null && PhoneNumber !=null  && LoginHashcode == '' ) {
        //     ExistingHashcode = String.valueOf(userHashCodeCookie.getValue());
        //     abasoftUser = [Select Id , Agent_Unique_Id__c, CampaignID__c, HashCode__c From AbbaSoft_User__c 
        //                     Where HashCode__c =: ExistingHashcode  AND Agent_Unique_Id__c =: AgentUniqueCode];
        //     if (abasoftUser.size()>0) {
        //             FinalPageToRedirect = CustomerDetailPageBaseUrl+ '?id='+ExistingHashcode + '&Phone='+PhoneNumber + '&AgentId='+ AgentUniqueCode;
        //             //redirecttoLoginPage = false;
        //     }
        //     System.debug('FinalPageToRedirect  ====> ' + FinalPageToRedirect);
        //     PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
        //      CustomerDetailPage.setRedirect(true);
        //     return CustomerDetailPage;
        // }
        // else if (LoginHashcode == '' && PhoneNumber !=null && AgentUniqueCode != null && userHashCodeCookie == null) {
        //         if (LoginHashcode == '') {
        //             LoginHashcode = Utility.generateRandomString();
        //         }   
        //         FinalPageToRedirect = LoginPageBaseurl + '?id='+ LoginHashcode +'&Phone='+ PhoneNumber + '&AgentId='+ AgentUniqueCode; 
        //         System.debug('FinalPageToRedirect =====> ' + FinalPageToRedirect);
        //         PageReference CustomerDetailPage = new PageReference(FinalPageToRedirect);
        //         CustomerDetailPage.setRedirect(true);
        //         return CustomerDetailPage;
        // }
        //https://whitemart--partial--c.sandbox.vf.force.com/apex/Abasoft_LoginPage?id=&Phone=09562279968&AgentId=3E623D2C-C74E-ED11-80C4-00155D010613 07306429068
        return null;
     }
}