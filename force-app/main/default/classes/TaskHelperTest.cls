@isTest
private class TaskHelperTest {

    @isTest
    static void testCheckOpenTasks() {
        
        Case testCase = new Case(Status = 'New');
        insert testCase;

        Task testTask1 = new Task(Subject = 'Test Task 1', Status = 'Not Started', WhatId = testCase.Id);
        Task testTask2 = new Task(Subject = 'Test Task 2', Status = 'In Progress', WhatId = testCase.Id);
        Task testTask3 = new Task(Subject = 'Test Task 3', Status = 'Completed', WhatId = testCase.Id);

        List<Task> testTasks = new List<Task>{testTask1, testTask2, testTask3};
        insert testTasks;
        
        for (Task task : testTasks) {
            if (task.Status == 'Not Started' || task.Status == 'In Progress') {
                System.assert(task.HasErrors(), 'Erro esperado não encontrado.');
            } else {
                System.assertNotEquals(true, task.HasErrors(), 'Erro não esperado encontrado.');
            }
        }
    }
}