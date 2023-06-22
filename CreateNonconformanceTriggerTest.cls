@IsTest
public class CreateNonconformanceTriggerTest {
    @IsTest
    public static void testCreateNonconformanceTrigger() {
        // Create test data
        Case testCase = new Case(
            Subject = 'Test Case',
            Type = 'Problem'
        );
        insert testCase;
        
        // Set up the Trigger context
        Test.startTest();
        // Perform DML operation to invoke the trigger
        update testCase;
        Test.stopTest();
        
        // Verify the Nonconformance record was created
        Nonconformance__c createdNonconformance = [SELECT Id, Case__c FROM Nonconformance__c WHERE Case__c = :testCase.Id];
        System.assertEquals(testCase.Id, createdNonconformance.Case__c);
        
        // Verify the lookup field was populated on the Case
        Case updatedCase = [SELECT SQX_NC_Reference__c FROM Case WHERE Id = :testCase.Id];
        System.assertEquals(createdNonconformance.Id, updatedCase.SQX_NC_Reference__c);
    }
}