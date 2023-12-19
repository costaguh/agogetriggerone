public with sharing class TaskHelper {

    public static void checkOpenTasks(List<Task> tasks) {

        List<String> openStatus = new List<String>{
            'Not Started',
            'In Progress',
            'Waiting on someone else'
        };
            
        Map<Id, Integer> caseIdToOpenTaskNumber = new Map<Id, Integer>();
        Set<Id> newTaskIds = new Set<Id>();

        for (Task task : tasks) {
            newTaskIds.add(task.Id);
            if (task.WhatId?.getSObjectType() == Case.SObjectType && openStatus.contains(task.Status)) {
                addTask(caseIdToOpenTaskNumber, task);                
            }
        }

        List<Task> orgOpenTasks = [
            SELECT Id, WhatId, Status
            FROM Task
            WHERE Status IN :openStatus
            AND WhatId IN :caseIdToOpenTaskNumber.keySet()
            AND Id NOT IN :newTaskIds
        ];

        newTaskIds.clear();

        for (Task openTask : orgOpenTasks) {
            addTask(caseIdToOpenTaskNumber, openTask);
        }

        for (Task task : tasks) {
            if (caseIdToOpenTaskNumber.containsKey(task.WhatId) && caseIdToOpenTaskNumber.get(task.WhatId) > 1) {
                task.addError('error');
            }
        }
    }
                                           
	public static void addTask(Map<Id, Integer> caseIdToOpenTaskNumber, Task task) {
        Integer openTaskNumber = caseIdToOpenTaskNumber.get(task.WhatId);
        caseIdToOpenTaskNumber.put(task.WhatId, openTaskNumber == null ? 1 : openTaskNumber + 1);
    }

}