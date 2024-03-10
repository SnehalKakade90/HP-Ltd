@isTest
public class AccountTrigger11HelperTest {
@isTest
    static void testUpdateRecords() {
        // Create test data - Account and related Opportunities
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Opportunity testOpportunity1 = new Opportunity(Name = 'Test Opp 1', StageName = 'Prospecting', CloseDate = Date.today() + 10, AccountId = testAccount.Id);
        Opportunity testOpportunity2 = new Opportunity(Name = 'Test Opp 2', StageName = 'Closed Won', CloseDate = Date.today() - 31, AccountId = testAccount.Id);

        insert new List<Opportunity>{testOpportunity1, testOpportunity2};

        // Update the Account to trigger the helper class logic
        testAccount.Name = 'Updated Test Account';
        update testAccount;

        // Verify that the Opportunities were updated as expected
        List<Opportunity> updatedOpportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :testAccount.Id];
        
        // Check that 'Test Opp 1' stage was updated to 'Closed Lost' because its CreatedDate is more than 30 days ago
        System.assertEquals('Closed Lost', updatedOpportunities[0].StageName);

        // Check that 'Test Opp 2' stage remains 'Closed Won' as it should not be updated
        System.assertEquals('Closed Won', updatedOpportunities[1].StageName);
    }

    @isTest
    static void testUpdateRecordsWithNoOpportunities() {
        // Create test data - Account without Opportunities
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Update the Account to trigger the helper class logic
        testAccount.Name = 'Updated Test Account';
        update testAccount;

        // Verify that no Opportunities were updated
        List<Opportunity> updatedOpportunities = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :testAccount.Id];
        System.assertEquals(0, updatedOpportunities.size(), 'No Opportunities should be updated');
    }
}