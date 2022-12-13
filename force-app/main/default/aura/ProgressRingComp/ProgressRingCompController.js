({
    doInit : function(component, event, helper) {
        //helper.doInit(component, event, helper) ;
        debugger;
        var recId = component.get("v.recordId"); 
        var action = component.get('c.computePercentage');
        action.setParams({
            recordId : recId,
        });
        
        action.setCallback(this, function(a) {
            if (a.getState() === 'SUCCESS') {
                var percVal = a.getReturnValue() ; 
                var progressVal = parseInt(  (percVal.recievedpercenetage/100) * 360  ) ; 
                component.set("v.cirDeg" , progressVal );
                component.set("v.perText" , parseInt(percVal.recievedpercenetage)  +'%' ); 
                component.set("v.recievedScore" , percVal.minimumScore );
                component.set("v.maximumScore" , percVal.thresholdScore );
            }  
        });
        $A.enqueueAction(action);  
        
    },
 
    
})