global with sharing class CookieControllerForAabaSoftUser{

    private static final String LoginPageBaseurl = 'https://whitemart--partial--c.sandbox.vf.force.com/apex/Abasoft_LoginPage';
    private static final String CustomerDetailPageBaseUrl = 'https://whitemart--partial--c.sandbox.vf.force.com/apex/CusomerDetailAURA_IN_VFPage';
    
    global CookieControllerForAabaSoftUser(){
        
        Cookie counter = ApexPages.currentPage().getCookies().get('counter');
    
        // If this is the first time the user is accessing the page, 
        // create a new cookie with name 'counter', an initial value of '1', 
        // path 'null', maxAge '-1', and isSecure 'true'. 
        if (counter == null) {
            counter = new Cookie('counter','1',null,-1,true);
        } else {
        // If this isn't the first time the user is accessing the page
        // create a new cookie, incrementing the value of the original count by 1
            Integer count = Integer.valueOf(counter.getValue());
            counter = new Cookie('counter', String.valueOf(count+1),null,-1,true);
        }
    
        // Set the new cookie for the page
        ApexPages.currentPage().setCookies(new Cookie[]{counter});
    }

    global static void StoreHashCodeAfterLogin(string hashCode) {
        /*Cookie counter = ApexPages.currentPage().getCookies().get('counter');
        if(counter == null) {
            return '0';
        }
        return counter.getValue();*/
        String ExistingHashcode = '';
        System.debug('hashCode ======> ' + hashCode);
        try {
            if (hashCode != null) {
                
                Cookie userHashCodeCookie= new Cookie('userHashCodeCookie',hashCode,null,(18000),false);
                ApexPages.currentPage().setCookies(new Cookie[]{ userHashCodeCookie });
                System.debug('userHashCodeCookie ====> ' + userHashCodeCookie);
                
            }else {
                //ExistingHashcode = String.valueOf(userHashCodeCookie.getValue());
            }
            
        } catch (Exception e ) {
            System.debug('Thee error has occured due to =====> ' + e.getMessage() + 'At line number  '+ e.getLineNumber());
            System.debug('the error ====> ' + e.getStackTraceString());
        }
        //Cookie userHashCodeCookie = ApexPages.currentPage().getCookies().get('userHashCodeCookie');
    }

}