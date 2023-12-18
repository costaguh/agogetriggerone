@isTest
private class TaskHelperTest {

    @isTest
    static void scenario1() { // 1. Criar uma task aberta para um caso. Depois criar outra task aberta para o mesmo caso.
        Case testCase = new Case();
        insert testCase;

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );
        insert openTask;

        Task openTask2 = new Task(
            Status = 'Not Started', 
            WhatId = testCase.Id
        ); //essa task tem que dar erro porque já tem uma aberta pro caso, então vamos ver certificar que de fato vai dar erro
        
        //uma abordagem legal é usar o SaveResult, porque a gente consegue, através de métodos, checar se a operação deu sucesso e qual erro
        //poderiamos usar um try catch também sem problemas, mas eu acho mais elegante assim...
        //sem alguma tratativa (só o insert por exemplo), daria uma exceção, pois disparamos um addError na trigger, então algum tratamento tem que ter
        //pode pesquisar mais sobre: 
        //https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_database.htm
        //https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_database_saveresult.htm

        Database.SaveResult result = Database.insert(openTask2, false);
        //se olhar no primeiro link que passei, vai notar que o segundo parametro é o allOrNone, você passa sua intenção com a operação
        //caso algum registro que está inserindo (porque pode colocar uma lista de registro, e consequentemente o SaveResult vira uma lista também) dá erro, você quer que todos deem erro? Se sim, coloca true
        //se algum registro que está inserindo dá erro mas pode seguir com o restante que deu sucesso, coloca false
        
        //e aqui a gente verifica se deu sucesso e qual o erro
        System.assertEquals(false, result.isSuccess(), 'Scenario 1');
        System.assertEquals(Label.Task_Error, result.getErrors()[0].getMessage(), 'Scenario 1');
    }

    @isTest
    static void scenario2() { // 2. Criar uma task concluída para um caso. Depois criar outra task aberta para o mesmo caso.
        Case testCase = new Case();
        insert testCase;

        Task completedTask = new Task(
            Status = 'Completed', 
            WhatId = testCase.Id
        );
        insert completedTask;

        Task openTask2 = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );
        insert openTask2;

        //nesse caso não deveria dar erro, então vamos verificar se tem duas tasks no caso mesmo

        List<Task> taskList = [SELECT Id FROM Task WHERE WhatId = :testCase.Id];
        System.assertEquals(2, taskList.size(), 'Scenario 2');
    }

    @isTest
    static void scenario3() { // 3. Criar uma task aberta para um caso, depois atualizar para concluida.
        Case testCase = new Case();
        insert testCase;

        Task task = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );
        insert task;

        task.Status = 'Completed';
        update task;

        //nesse caso não deveria dar erro, então vamos verificar se a task está com o status correto 
        //obs poderia ser outra verificação, mas é importante que dê um assert e garantindo que seu cenário tá correto

        Task taskInserted = [SELECT Id, Status FROM Task WHERE Id = :task.Id];
        System.assertEquals('Completed', taskInserted.Status, 'Scenario 3');
    }

    @isTest
    static void scenario4() { // 4. Criar uma task aberta e uma concluida ao mesmo tempo pro mesmo caso.
        Case testCase = new Case();
        insert testCase;

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );

        Task completedTask = new Task(
            Status = 'Completed', 
            WhatId = testCase.Id
        );

        insert new List<Task>{openTask, completedTask};

        //nesse caso não deveria dar erro, então vamos verificar se tem duas tasks no caso mesmo

        List<Task> taskList = [SELECT Id FROM Task WHERE WhatId = :testCase.Id];
        System.assertEquals(2, taskList.size(), 'Scenario 4');
    }

    @isTest
    static void scenario5() { // 5. Criar duas task abertas ao mesmo tempo pro mesmo caso.
        Case testCase = new Case();
        insert testCase;

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );

        Task openTask2 = new Task(
            Status = 'Not Started', 
            WhatId = testCase.Id
        );

        //nesse caso ambas as tasks deveria dar erro...

        Database.SaveResult[] resultList = Database.insert(new List<Task>{openTask, openTask2}, false);

        for (Database.SaveResult result : resultList) {
            System.assertEquals(false, result.isSuccess(), 'Scenario 5');
            System.assertEquals(Label.Task_Error, result.getErrors()[0].getMessage(), 'Scenario 5');
        }
    }

    @isTest
    static void scenario6() { // 6. Criar uma task aberta e uma concluida ao mesmo tempo pro mesmo caso. Depois atualizar a task concluida para aberta.
        Case testCase = new Case();
        insert testCase;

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );

        Task completedTask = new Task(
            Status = 'Completed', 
            WhatId = testCase.Id
        );

        insert new List<Task>{openTask, completedTask};

        completedTask.Status = 'Waiting on someone else';

        //se fizer isso, teriamos duas tasks abertas pro caso de novo...então deveria dar erro

        Database.SaveResult result = Database.update(completedTask, false);

        System.assertEquals(false, result.isSuccess(), 'Scenario 6');
        System.assertEquals(Label.Task_Error, result.getErrors()[0].getMessage(), 'Scenario 6');
    }

    @isTest
    static void scenario7() { // 7. Criar uma task aberta e uma concluida ao mesmo tempo pro mesmo caso. Depois atualizar a task concluida para aberta.
        Case testCase = new Case();
        insert testCase;

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase.Id
        );

        Task completedTask = new Task(
            Status = 'Completed', 
            WhatId = testCase.Id
        );

        insert new List<Task>{openTask, completedTask};

        completedTask.Status = 'Waiting on someone else';

        //se fizer isso, teriamos duas tasks abertas pro caso de novo...então deveria dar erro

        Database.SaveResult result = Database.update(completedTask, false);
        
        System.assertEquals(false, result.isSuccess(), 'Scenario 7');
        System.assertEquals(Label.Task_Error, result.getErrors()[0].getMessage(), 'Scenario 7');
    }

    @isTest
    static void scenario8() { // 8. Criar dois casos. Depois criar 1 tasks concluidas para ambos. Depois criar uma task aberta para um dos casos.
        Case testCase1 = new Case();
        Case testCase2 = new Case();

        insert new List<Case>{testCase1, testCase2};

        Task completedTask1 = new Task(
            Status = 'Completed', 
            WhatId = testCase1.Id
        );

        Task completedTask2 = new Task(
            Status = 'Completed', 
            WhatId = testCase2.Id
        );

        insert new List<Task>{completedTask1, completedTask2};

        Task openTask = new Task(
            Status = 'In Progress', 
            WhatId = testCase1.Id
        );
        insert openTask;

        //não deveria ter problema...

        List<Task> taskList1 = [SELECT Id FROM Task WHERE WhatId = :testCase1.Id];
        System.assertEquals(2, taskList1.size(), 'Scenario 8');

        List<Task> taskList2 = [SELECT Id FROM Task WHERE WhatId = :testCase2.Id];
        System.assertEquals(1, taskList2.size(), 'Scenario 8');
    }

    @isTest
    static void scenario9() { // 9. Criar dois casos. Depois criar 1 tasks concluidas para ambos. Depois criar uma task aberta para cada um dos casos ao mesmo tempo.
        Case testCase1 = new Case();
        Case testCase2 = new Case();

        insert new List<Case>{testCase1, testCase2};

        Task completedTask1 = new Task(
            Status = 'Completed', 
            WhatId = testCase1.Id
        );

        Task completedTask2 = new Task(
            Status = 'Completed', 
            WhatId = testCase2.Id
        );

        insert new List<Task>{completedTask1, completedTask2};

        Task openTask1 = new Task(
            Status = 'In Progress', 
            WhatId = testCase1.Id
        );
        Task openTask2 = new Task(
            Status = 'In Progress', 
            WhatId = testCase2.Id
        );

        insert new List<Task>{openTask1, openTask2};

        //não deveria ter problema...

        List<Task> taskList1 = [SELECT Id FROM Task WHERE WhatId = :testCase1.Id];
        System.assertEquals(2, taskList1.size(), 'Scenario 9');

        List<Task> taskList2 = [SELECT Id FROM Task WHERE WhatId = :testCase2.Id];
        System.assertEquals(2, taskList2.size(), 'Scenario 9');
    }

    @isTest
    static void scenario10() { // bonus
        Account account = new Account(
            Name = 'Account Test'
        );
        insert account;

        Task openTask1 = new Task(
            Status = 'In Progress', 
            WhatId = account.Id
        );

        Task openTask2 = new Task(
            Status = 'In Progress', 
            WhatId = account.Id
        );

        //se eu inserir, não deveria dar erro, afinal, não estamos falando de Caso aqui...

        Database.SaveResult[] resultList = Database.insert(new List<Task>{openTask1, openTask2}, false);

        for (Database.SaveResult result : resultList) {
            System.assertEquals(true, result.isSuccess(), 'Scenario 10');
        }

    }

}