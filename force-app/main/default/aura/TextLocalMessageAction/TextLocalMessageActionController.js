({
    doInit : function(component, helper) {
        debugger;
        let recordId = component.get('v.recordId');
        var action = component.get("c.sendSMS");
        action.setParams({ 'recordId' : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
             //   alert("state"+state);
             //   alert(response.getReturnValue());
                var res = response.getReturnValue();
                if(response.getReturnValue() === 'Message Sent SuccessFully..!!'){                    
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Success",
                        "title": "Success",
                        "message": "Message sent successfully."
                    });
                    
                }else if(response.getReturnValue() === 'Please Enter Valid Phone Number..!!'){
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Error",
                        "title": "Error",
                        "message": "Please Enter Valid Phone Number..!!"
                    });
                    
                }else{
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Error",
                        "title": "Error",
                        "message": "Exception occurred. Kindly contact system admin."
                    });
                    
                }
            }
        });
        $A.enqueueAction(action);
    }
    
})