public with sharing class TaskHelper {
    public static void CheckOpenTasks(List<Task> newTasks, Map<Id, Task> oldTaskMap) {
        Set<Id> relatedCaseIds = new Set<Id>();             
        Map<Id, Task> oldTasksById = new Map<Id, Task>();

        List<String> allowedStatus = new List<String>{'Not Started', 'In Progress', 'Waiting on someone else'};
        
        for (Task newTask : newTasks) {
            relatedCaseIds.add(newTask.WhatId);
        }
        for (Task openTask : [
            SELECT Id, WhatId, Status 
            FROM Task 
            WHERE Status IN :allowedStatus 
            AND WhatId IN :relatedCaseIds]) 
            {            
                oldTasksById.put(openTask.WhatId, openTask);
                System.debug(oldTasksById);
            }

        for (Task newTask : newTasks) {            
            if(oldTasksById.containsKey(newTask.WhatId) && allowedStatus.contains(newTask.Status)) {                
                newTask.addError('Já existe uma tarefa em aberto nesse caso. Encerre-a antes de abrir uma nova.');
            }
        }
    }
}