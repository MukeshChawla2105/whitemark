/*
* Note: Run this batch with batch size of 1.
*/
global Class WishlistCartItemSMSBatch implements Database.Batchable<sobject>,Database.AllowsCallouts{
    global Database.Querylocator start(Database.BatchableContext Bc){
        String query = '';
        query = 'SELECT Id,Name,Phone,(SELECT Id,Name,Product__r.Name,Product__r.Brand__c,Product__r.Family,SMS_Notification_Count__c FROM Wishlist_Cart_Items__r WHERE SMS_Notification_Count__c <= 3) FROM Account WHERE Id IN (SELECT Customer__c FROM Wishlist_Cart_Items__c WHERE SMS_Notification_Count__c <= 3)';
        RETURN Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList){
        List<String> numberList = new List<String>();
        List<Wishlist_Cart_Items__c> wishCartUpdateList = new List<Wishlist_Cart_Items__c>();
        List<SMS_Template__mdt> templateList = new List<SMS_Template__mdt>();
        String itemNameString = '';
        String customerName = '';
        Text_Local_API_Details__c apiDetails = new Text_Local_API_Details__c();
        apiDetails =[SELECT id, Api_Key__c, Message__c, Sender__c,Admin_Email__c from Text_Local_API_Details__c];
        templateList = [SELECT Id,DeveloperName,Template_Body__c FROM SMS_Template__mdt WHERE Active__c = true];
        String apikey = apiDetails.Api_Key__c;
        String sender = apiDetails.Sender__c;
        String adminEmail = apiDetails.Admin_Email__c;
        String apiBooleanValue = String.valueof(false);
        
        for(Account accObj: accList){
            customerName = accObj.Name;
            if(accObj.Phone != null)
                numberList.add(accObj.Phone);
        }
        if(numberList.size() > 0 && accList[0].Wishlist_Cart_Items__r.size() > 0){
            for(Wishlist_Cart_Items__c cartObj : accList[0].Wishlist_Cart_Items__r){
                //System.debug(cartObj.SMS_Notification_Count__c);
                cartObj.SMS_Notification_Count__c ++;
                //System.debug(cartObj.SMS_Notification_Count__c);
                wishCartUpdateList.add(cartObj);
                try{
                    if(cartObj.Product__r.Brand__c != null)
                        itemNameString = cartObj.Product__r.Brand__c;
                    if(cartObj.Product__r.Family != null)
                        itemNameString += ' '+cartObj.Product__r.Family;
                    if(itemNameString == null || itemNameString == '')
                        itemNameString = cartObj.Product__r.Name;
                    
                    if(itemNameString.length() >= 30)
                        itemNameString = itemNameString.subString(0,30);
                    else
                        itemNameString = itemNameString.subString(0,itemNameString.length());
                    
                    //System.debug(itemNameString);
                    Map<String,String> smsBodyMap = new Map<String,String>();
                    for(SMS_Template__mdt tempObj : templateList){
                        String smsBody = tempObj.Template_Body__c;
                        smsBody = smsBody.replace('Cust_Name',customerName);
                        smsBody = smsBody.replace('Wishlist_Item',itemNameString);
                        smsBody = smsBody.replace('<<','');
                        smsBody = smsBody.replace('>>','');
                        smsBodyMap.put(tempObj.DeveloperName,smsBody);
                        //System.debug(smsBodyMap.values());
                    }
                    String apiErrorMessage = '';
                    String numberString = String.valueOf(numberList);
                    numberString = numberString.remove('(');
                    numberString = numberString.remove(')');
                    for(String tempDevName : smsBodyMap.keySet()){
                        //System.debug(smsBodyMap.get(tempDevName));
                        HttpRequest req = new HttpRequest();
                        String apiEndPoint = 'https://api.textlocal.in/send/?apikey='+EncodingUtil.urlEncode(apikey,'UTF-8')+'&message='+EncodingUtil.urlEncode(smsBodyMap.get(tempDevName),'UTF-8')+'&sender='+EncodingUtil.urlEncode(sender,'UTF-8')+'&numbers='+EncodingUtil.urlEncode(numberString,'UTF-8');
                        if(tempDevName == 'UnfinishedBusinessinCart')
                            apiEndPoint += '&unicode=1';
                        //To be added for API testing
                        //apiEndPoint += '&test=1';
                        System.debug('Api End Pint:::'+apiEndPoint);
                        req.setEndpoint(apiEndPoint);
                        req.setMethod('POST');
                        req.setHeader('Content-Type','application/json');
                        Http http = new Http();
                        
                        HTTPResponse res = http.send(req);
                        System.debug('Res:::'+res.getBody());
                        if(res.getBody().containsIgnoreCase('warnings') || res.getBody().containsIgnoreCase('errors')){
                            if(res.getBody().containsIgnoreCase('Invalid number')){
                                apiErrorMessage = apiErrorMessage+' Invalid number \n';
                            }
                            if(res.getBody().containsIgnoreCase('No recipients specified')){
                                apiErrorMessage = apiErrorMessage+' No recipients specified \n';
                            }
                            if(res.getBody().containsIgnoreCase('Insufficient credits')){
                                apiErrorMessage = apiErrorMessage+' Insufficient credits kinldy check with textLocal team \n';
                            }
                            if(res.getBody().containsIgnoreCase('Message too long')){
                                apiErrorMessage = apiErrorMessage+' Message too long. \n';
                            }
                            if(res.getBody().containsIgnoreCase('Invalid number format')){
                                apiErrorMessage = apiErrorMessage+' Invalid number format. \n';
                            }
                            if(res.getBody().containsIgnoreCase('Invalid sender name')){
                                apiErrorMessage = apiErrorMessage+' Invalid sender name. \n';
                            }
                            if(res.getBody().containsIgnoreCase('No sender name specified')){
                                apiErrorMessage = apiErrorMessage+' No sender name specified \n';
                            }
                            if(res.getBody().containsIgnoreCase('Invalid Template')){
                                apiErrorMessage = apiErrorMessage+' Invalid Template. The message given didnt match any approved templates on your account. \n';
                            }
                            if(res.getBody().containsIgnoreCase('Schedule time is outside that allowed')){
                                apiErrorMessage = apiErrorMessage+' Schedule time is outside that allowed. \n';
                            }
                            if(res.getBody().containsIgnoreCase('You cannot send message at this time')){
                                apiErrorMessage = apiErrorMessage+' You cannot send message at this time. \n';
                            }
                        }
                    }
                    if(apiErrorMessage != ''){
                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List<String> sendTo = new List<String>();
                        sendTo.add(adminEmail);
                        mail.setToAddresses(sendTo);
                        mail.setSenderDisplayName('WishList/Cart Item SMS Error');
                        mail.setSubject('WishList/Cart Item SMS Error');
                        String body = 'Dear Admin,</br></br>Some Error occured while sending WishList/Cart bulk SMS. Please find the details below.</br>'+apiErrorMessage+'</br></br>Regards,</br>WhiteMart Support';
                        mail.setHtmlBody(body);
                        mails.add(mail);
                        Messaging.sendEmail(mails);
                    }
                }
                catch(Exception e){}
            }            
        }
        if(wishCartUpdateList.size() > 0){
            UPDATE wishCartUpdateList;
        }
    }
    // Finish Method
    global void finish(Database.BatchableContext BC) {}
}