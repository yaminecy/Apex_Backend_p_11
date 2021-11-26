 @isTest
public with sharing class TestsOrdersAndAccounts {
        @isTest
        static void TestUpdateOrderStatus(){
             
            // Create An Account with an order( with status 'Draft'and without products.)         
            Account acc= new Account (Name ='compte Test');
            insert acc;
            Order ord = new Order (Name='testOrder',EffectiveDate=system.today(),Status='Draft',AccountId=acc.Id);
            insert ord;
            
            //Change Order's Status to 'Activated' 
             Order o =[SELECT Id,Status from order LIMIT 1];
             o.Status = 'Activated';
    
            //Check that the order's status is still 'Draft' and the error message is equals the error in the classe        
            Test.startTest();
            Database.SaveResult result = Database.update(o,false);
            Test.stopTest();
            system.assertequals('Draft',ord.status);
            System.assertEquals('Vous ne pouvez pas changer le statut !',result.getErrors()[0].getMessage());
        }
    
        
        @isTest
        static void TestCheckActivFeild(){
             // Create An Account with an order 
             Account acc= new Account (Name ='compte Test2');
             insert acc;
             Order orde = new Order (Name='testOrdered2',EffectiveDate=system.today(),Status='Draft',AccountId=acc.Id);
             insert orde;
             
              //Delete the order
           Order toDelete =[SELECT Id from order LIMIT 1];
              //check that custom feild Activ__c  is uncheked.
              Test.startTest();
              Database.DeleteResult result = Database.delete(toDelete);
              Test.stopTest();    
              system.assertequals(false, acc.Active__c);
        }
    
        @isTest
        static void TestTaskCreation(){
            // Create An Account without an order 
             Account acc1= new Account (Name ='compte Test3');
             insert acc1;
             List<Task> tsk = new List <Task>();
            //excute batch 
            Test.startTest();
              BatchProcessAcc uca = new BatchProcessAcc();
              Id batchId = Database.executeBatch(uca);
              Test.stopTest();
            //Chech that the remider task is created 
            tsk = [SELECT id FROM Task];
            system.assertequals(1, tsk.size());
        }
        @isTest
        static void TestTaskCreationMultiAccounts(){
            // Create 200 Accounts  without orders 
             List <Account> accl= new List <Account> ();
             for(Integer i=0;i<200;i++){
                 Account acc1= new Account (Name ='compte Test3 '+ i);
                 accl.add(acc1);
             }
             insert accl;         
             List<Task> tsk = new List <Task>();
            //excute batch 
            Test.startTest();
              BatchProcessAcc uca = new BatchProcessAcc();
              Id batchId = Database.executeBatch(uca);
              Test.stopTest();
            ////Chech that the remider tasks are created 
            tsk = [SELECT id FROM Task];
            system.assertequals(200, tsk.size());
        }
 }
    

