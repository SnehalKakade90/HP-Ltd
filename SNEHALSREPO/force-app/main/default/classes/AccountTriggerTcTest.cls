@isTest
public class AccountTriggerTcTest {
	
    @isTest
    public static void accountTypePositiveMethod(){
      Account objAcc = new Account(Name='Ram Mall',Rating='Hot');
        Database.insert(objAcc,False);//code coverage
        
        //Buisness Logic Tally
        String actualAccType = [select Id, Type,Rating from Account where Id=:objAcc.Id].Type;//Prospect
        System.assertEquals('Prospect', actualAccType);
    }
    @isTest
    public static void accountTypeNegativeMethod(){
     Account objAcc = new Account(Name='Ram Mall',Rating='Warm');   
        Database.insert(objAcc,False);//code coverage
         //Buisness Logic Tally
        String actualAccType = [select Id, Type,Rating from Account where Id=:objAcc.Id].Type;//null or Null
        System.assertEquals(null, actualAccType);
    } 
    @isTest
    public static void accountTypeEmptyMethod(){
     Account objAcc = new Account(Name='Ram Mall');   
        Database.insert(objAcc,False);//code coverage
         //Buisness Logic Tally
        String actualAccType = [select Id, Type,Rating from Account where Id=:objAcc.Id].Type;//null or Null
        System.assertEquals(null, actualAccType);
    } 
     
}