({
    doInit : function(component, event, helper) {
        
        var messagesessionid = component.get("v.recordId");
        console.log('messagesessionid-->'+messagesessionid);
        var action = component.get("c.fetchphone");
        action.setParams({
            "msid": messagesessionid
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var id = response.getReturnValue();
                console.log('account id-->'+id); 
                var workspaceAPI = component.find("workspace");
                    workspaceAPI.openSubtab({
                        recordId: id,
                        focus: false
                    })
                .catch(function(error) {
                    console.log(error);
                });
            }
        });
        $A.enqueueAction(action);  
    }
})