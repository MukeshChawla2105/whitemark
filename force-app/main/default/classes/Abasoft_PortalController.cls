public class Abasoft_PortalController {
    
    public string tabValues {get;set;}
    
    public Abasoft_PortalController(){
        List<Abasoft_Portal_Tabs__c> cdTabs =[select Id, Name, Controller_Name__c, Display_Order__c from Abasoft_Portal_Tabs__c ORDER BY Display_Order__c];
        tabValues = JSON.serialize(cdTabs);
    }
    
    // Login Class
    @RemoteAction
    public Static String loginContactUser(String userName, String password){
        try{
            List<Contact> conRec = [SELECT Id, Email, Password__c, Login_Hash_Code__c FROM Contact WHERE Email =: userName AND Password__c =: password LIMIT 1];
            if(conRec.size()>0){
                String currentConId;
                currentConId = conRec[0].id;
               
                Contact con = new Contact();
                con.Login_Hash_Code__c = Utility.generateRandomString();
                con.id= currentConId;
                update con;
                return  con.Login_Hash_Code__c;
            }else {
                return null;  
            }
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() +'Erron Line :'+e.getLineNumber());
            return null;
        }
    }
    
    @RemoteAction
    public static List<Contact> getContacts(){
        return [SELECT Id, FirstName, LastName, Name FROM Contact];
    }
    
    public static string getContactName(){
        return [SELECT Id, FirstName, LastName, Name FROM Contact].Name;
    }
    
    @RemoteAction
    public static Contact getContactDetails(String hashCode){
        List<Contact> conList = [SELECT Id, Name, FirstName, LastName, Email, Password__c, Login_Hash_Code__c FROM Contact WHERE Login_Hash_Code__c =:hashCode ];
        if(conList.size()>0){
            return conList[0];
        }
        return null;
    }
    
    @RemoteAction
    public static void updateContact(Contact cont){
        update cont;
    }
    
    @RemoteAction
    public static Contact editProfile(String contId){
        return [SELECT FirstName, LastName, Email, Phone FROM Contact WHERE Login_Hash_Code__c = :contId];
    }
    
    // Logout Clas
    @RemoteAction
    public Static String logoutContactUser(String contactId){
        try{
            List<Contact> conList = [SELECT Id,Login_Hash_Code__c FROM Contact WHERE Id =: contactId];
            for(Contact con : conList){
                if(con.Login_Hash_Code__c !=null){
                    con.Login_Hash_Code__c = null;
                }
            }
            update conList;
            return 'SUCCESS';
            
        }catch(Exception e){
            System.debug('The Error '+e.getMessage() + 'Erron Line '+e.getLineNumber());
            return 'ERROR';
        }
    }

}