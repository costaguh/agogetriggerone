trigger Product2Trigger on Product2 (before insert, before update) {	
	Product2TriggerHandler handler = new Product2TriggerHandler(
    	Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap
    );
    
    switch on Trigger.operationType {
        when BEFORE_UPDATE {
            handler.beforeUpdate();
        }
        when BEFORE_INSERT {
            handler.beforeInsert();
        }              
    }
}