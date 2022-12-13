global without sharing class ProductDocViewer {
    
	@RemoteAction
    global static List<Product2> getScripts(){
        return [Select Id,Name From Product2 ];
    }


    @RemoteAction
    global static List<Product2> searchScriptsFilter(String searchedKey){
        searchedKey = '%'+searchedKey+'%';
        return [Select Id,Name From Product2 Where Name like :searchedKey];
    }

    @RemoteAction
    global static String getDocs(String scriptId){
        Attachment acc = [SELECT Id, ParentId , Body, ContentType , Name FROM Attachment WHERE ParentId = : scriptId];
        return acc.Id;
    }
}