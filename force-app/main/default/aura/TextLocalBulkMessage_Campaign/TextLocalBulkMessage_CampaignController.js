({
    doInit : function(component, helper) {
        debugger;
        let recordId = component.get('v.recordId');
        var action = component.get("c.sendBulkSMS");
        action.setParams({ 'recordId' : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState(); // get the response state
            if(state == 'SUCCESS') {
                //alert(response.getReturnValue());
                var messgae = response.getReturnValue();
                if(response.getReturnValue() === 'Message Successfully Sent..'){   
                    alert('came inside')
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Success",
                        "title": "Success",
                        "message": "Message sent successfully."
                    });
                    
                }else if(response.getReturnValue() === 'Please select Schedule at..'){
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Informational",
                        "title": "Informational",
                        "message": "Please select Schedule at..!"
                    });
                    
                }else if(response.getReturnValue() === 'Please select Scheduled date/time'){
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Informational",
                        "title": "Informational",
                        "message": "Please select Scheduled date/time.."
                    });
                    
                }else{
                    $A.get("e.force:closeQuickAction").fire();
                    component.find('notify').showToast({
                        "variant": "Warning",
                        "title": "Warning",
                        "message": messgae,
                        "mode" : "sticky"
                    });
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    }
    
})