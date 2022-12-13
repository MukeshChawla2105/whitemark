public class LeadTriggerHandler{
    public static void leadValidation(List<Lead> newLeadList,Map<Id,Lead> newLeadMap){
        List<String> phoneList = new List<String>();
        List<Lead> dupLeadList = new List<Lead>();
        for(Lead leadObj : newLeadList){
            phoneList.add(leadObj.Phone_formatted__c);
        }
        System.debug(phoneList);
        if(phoneList.size() > 0){
            dupLeadList = [SELECT Id,Email FROM Lead WHERE Phone_formatted__c IN :phoneList AND Id NOT IN: newLeadMap.keySet() AND Status = 'New'];
        }
        System.debug(dupLeadList.size());
        if(dupLeadList.size() > 0){
            try{
                dupLeadList[0].LastName = newLeadList[0].LastName;
                if(newLeadList[0].Email != null)
                    dupLeadList[0].Email = newLeadList[0].Email;
                if(newLeadList[0].LeadSource != null)
                    dupLeadList[0].LeadSource = newLeadList[0].LeadSource;
                if(newLeadList[0].Enquiry_Type__c != null)
                    dupLeadList[0].Enquiry_Type__c = newLeadList[0].Enquiry_Type__c;
                if(newLeadList[0].District__c != null)
                    dupLeadList[0].District__c = newLeadList[0].District__c;
                if(newLeadList[0].Status != null)
                    dupLeadList[0].Status = newLeadList[0].Status;
                //dupLeadList[0].Address = newLeadList[0].Address;
                //dupLeadList[0].email = newLeadList[0].email;
                MERGE dupLeadList[0] newLeadList[0];  
                //newLeadList[0].addError('Duplicate Lead has been Found! Provided details are merged with the existing lead, close this tab and use below link to acceess the merged lead');
            }
            catch(Exception e){
                System.debug(e.getStackTraceString());
            }
        }
    }
}