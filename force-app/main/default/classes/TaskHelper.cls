public with sharing class TaskHelper {
    public static void CheckOpenTasks(List<Task> newTasks, Map<Id, Task> oldTaskMap) {
        Set<Id> relatedCaseIds = new Set<Id>();             
        Map<Id, Task> oldTasksById = new Map<Id, Task>();
        
        for (Task newTask : newTasks) {
            relatedCaseIds.add(newTask.WhatId);
        }
        for (Task openTask : [SELECT Id, WhatId, Status FROM Task WHERE Status IN ('Not Started', 'In Progress', 'Waiting on someone else') AND WhatId IN :relatedCaseIds]) {            
            oldTasksById.put(openTask.WhatId, openTask);
            System.debug(oldTasksById);
        }
        for (Task newTask : newTasks) {            
            if(oldTasksById.containsKey(newTask.WhatId) && newTask.Status == 'Not Started' || newTask.Status == 'In Progress' || newTask.Status == 'Waiting on someone else') {                
                newTask.addError('Errrouuuu');
            }
        }
    }
}
