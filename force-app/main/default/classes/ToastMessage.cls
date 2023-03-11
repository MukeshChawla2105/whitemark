public class ToastMessage {
    @auraEnabled
    public static string toastMessage(String message, List<string> InvalidNumbers){
        system.debug('message'+message);
        if(message != null || message != ''){
            Return 'Invalid Numbers Found. Messages cannot be sent to this Numbers'+message+'';
        }
        Return 'Message sent Successfully..';
    }

}