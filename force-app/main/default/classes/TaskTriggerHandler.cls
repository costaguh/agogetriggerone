public with sharing class TaskTriggerHandler {
	List<Task> oldRecords {get; set;}
    List<Task> newRecords {get; set;}
    Map<Id, Task> oldMap {get; set;}
    Map<Id, Task> newMap {get; set;}

    public TaskTriggerHandler(List<Task> oldRecords, List<Task> newRecords, 
    Map<Id, Task> oldMap, Map<Id, Task> newMap) {
        this.oldRecords = oldRecords;
        this.newRecords = newRecords;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeUpdate() {        
        TaskHelper.CheckOpenTasks(this.newRecords, this.oldMap);        
    }

    public void beforeInsert() {       
        TaskHelper.CheckOpenTasks(this.newRecords, new Map<Id, Task>());
    }
}