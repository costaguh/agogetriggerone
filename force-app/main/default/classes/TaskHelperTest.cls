@isTest
private class TaskHelperTest {

    @isTest
    static void testNewTasks() {
        Case testCase = new Case(Status = 'New');
        insert testCase;

        Task testTask1 = new Task(Subject = 'Call', Status = 'Not Started', WhatId = testCase.Id);
        Task testTask2 = new Task(Subject = 'Call', Status = 'In Progress', WhatId = testCase.Id);
        Task testTask3 = new Task(Subject = 'Call', Status = 'Waiting on someone else', WhatId = testCase.Id);

        System.debug(testTask1);
        System.debug(testTask2);
        System.debug(testTask3); 

        insert testTask1;

        System.assertEquals(testTask1.Status, 'Not Started');
        System.assertEquals(testTask2.Status, 'In Progress');
        System.assertEquals(testTask3.Status, 'Waiting on someone else');

        testTask1.Status = 'Deferred';
        
        update testTask1;

        Task testTask4 = new Task(Subject = 'Call', Status = 'Not Started', WhatId = testCase.Id);

        insert testTask4;
        
        System.debug('testTask1 ' + testTask1);        
    }

    @isTest
    static void testUpdateTasks() {        
    }
}