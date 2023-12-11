public with sharing class TaskHelper {

    public static void checkOpenTasks(List<Task> tasks) {
        Set<Id> relatedCaseIds = new Set<Id>();
        Map<Id, Task> existingTasksById = new Map<Id, Task>();
        Map<Id, Task> oldTasksById = new Map<Id, Task>();

        List<String> allowedStatus = new List<String>{
            'Not Started',
            'In Progress',
            'Waiting on someone else'
        };

        for (Task task : tasks) {
            relatedCaseIds.add(task.WhatId);
            existingTasksById.put(task.Id, task);
        }

        List<Task> openTasks = [
            SELECT Id, WhatId, Status
            FROM Task
            WHERE Status IN :allowedStatus
            AND WhatId IN :relatedCaseIds
        ];

        for (Task openTask : openTasks) {
            Task existingTask = existingTasksById.get(openTask.Id);
            if (existingTask != null) {
                continue;
            }
            oldTasksById.put(openTask.WhatId, openTask);
        }

        for (Task task : tasks) {
            if (oldTasksById.containsKey(task.WhatId) && allowedStatus.contains(task.Status)) {
                task.addError(Label.Task_Error);
            }
        }
    }
}