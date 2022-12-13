public class LeadPhoneUpdateHelper {
    
    public Static void UpdateLeadPhone(List<Lead> LeadList){
        try{
            for(Lead le : LeadList){
                if(le.Phone !=null){
                    String leadPhone = le.Phone.right(10);
                    le.Phone = '0'+leadPhone;
                    le.Updated_Phone__c = true;
                }
            }
        }catch(Exception e){
            System.debug('The Error : '+e.getMessage());
            System.debug('The Line :'+e.getLineNumber());
        }
    }
}