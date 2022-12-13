({
	getInventoryList: function(component) {
        debugger;
        var action = component.get('c.getInventory');
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set('v.Inventorylist', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    /*searchKeyChange: function(component, event) {
        debugger;
        var searchKey = component.find("searchKey").get("v.value");
        console.log('searchKey:::::'+searchKey);
        var action = component.get("c.findByName");
        action.setParams({
            "searchKey": searchKey
        });
        action.setCallback(this, function(a) {
            component.set("v.Inventorylist", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    
    getContactList: function(component, pageNumber, pageSize) {
        var action = component.get("c.getContactData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.ContactList", resultData.contactList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
        });
        $A.enqueueAction(action);
    }
    */
})