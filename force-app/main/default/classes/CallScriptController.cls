global without sharing class CallScriptController {


	@RemoteAction
    global static List<Call_Script__c> getScripts(){
        return [Select Id,Name From Call_Script__c];
    }


    @RemoteAction
    global static List<Call_Script__c> searchScriptsFilter(String searchedKey){
        searchedKey = searchedKey.replace(' ', '%');
        string searchedKeyupdated = '%'+searchedKey+'%';
        system.debug('searchedKey :: ' + searchedKey);
        return [Select Id,Name From Call_Script__c Where Name like :searchedKeyupdated OR Name=:searchedKey];
    }

    @RemoteAction
    global static String getDocs(String scriptId){
        Attachment acc = [SELECT Id, ParentId , Body, ContentType , Name FROM Attachment WHERE ParentId = : scriptId];
        return acc.Id;
    }
}