trigger TaskTrigger on Task (before insert, before update) {
	TaskTriggerHandler handler = new TaskTriggerHandler(
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