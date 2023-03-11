public class TryCatchFororderDetailsSync {
    Public static Void trycatchmethod(){
        try{
            
        }
        catch(Exception e){
            Execption__c ex = new Execption__c();
            ex.Class_Name__c = 'WS_OrderDetailSync';
            ex.Ececption_Message__c = e.getMessage() +'  '+e.getCause()+'  '+e.getLineNumber();
            ex.Stack_Trace__c = e.getStackTraceString();
            ex.Method_Name__c = 'execute';
            Insert ex;
        }
        
    } 
}