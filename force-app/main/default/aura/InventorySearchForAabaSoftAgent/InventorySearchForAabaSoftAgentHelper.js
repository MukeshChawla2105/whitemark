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
})