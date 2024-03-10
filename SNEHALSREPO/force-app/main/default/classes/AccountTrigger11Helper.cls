public  class AccountTrigger11Helper {
    // first scenario
    public Static void updateRecords(List<Account> accList) {
        try{
            List<Opportunity> oppList = new List<Opportunity>(); //Opportunities
            oppList = [Select Id,StageName,CreatedDate,CloseDate FROM Opportunity WHERE AccountId In: Trigger.newMap.keyset()];
            if(!oppList.isEmpty()){
             for(Opportunity existingOpp:oppList){
                if ((existingOpp.StageName != 'Closed Won') && (existingOpp.CreatedDate < System.now() - 30)){ //
                    existingOpp.StageName = 'Closed Lost'; 
                }
             }
            }
            if(!oppList.isEmpty()){
                Database.update(oppList,false);
            }
        }
        catch(Exception e){
          System.debug('Exception caught: '+ e.getMessage()); 
        }
    }
     // second scenario
     public static void sendEmail(List<Account> accounts) {
        try{
            List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
            for(Account eachAccount:accounts){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] {'snehal.bhad@beenait.com'});
                mail.setSenderDisplayName('Snehal Bhad');
                mail.setSubject('Account is Created');
                mail.setPlainTextBody('Account '+ eachAccount.Name +  ' is created. \n Team HP Ltd.');
                mailList.add(mail);
            }
            if(!mailList.isEmpty()){
                Messaging.sendEmail(mailList,false);
                    System.debug('result');
            }
        }
        catch(Exception e){
            System.debug('Exception caught: '+ e.getMessage()); 
        }
    }
   // 3.
   public static void updateContact(Map<Id,Account> newMap, Map<Id,Account> oldMap) {
        try{
            List<Contact> conList = new List<Contact>();
                for(Contact objCon:[Select Id, OtherPhone, HomePhone,AccountId FROM Contact where AccountId In: newMap.keySet()]){
                conList.add(objCon);
                System.debug('result2 '+ objCon);
                }
        if(!conList.isEmpty()){
                for(Contact objCon:conList){
                   objCon.OtherPhone = newMap.get(objCon.AccountId).Phone;
                    objCon.HomePhone =  oldMap.get(objCon.AccountId).Phone;
                    System.debug('result3 '+ objCon.OtherPhone);
                }
        }
            Database.update(conList,false);
        }
        catch(Exception e){
            System.debug('Exception caught: '+ e.getMessage()); 
        }
    }

   // 4.Create a field on Account Named (Client Contact lookup to Contact). Once an Account is inserted 
   //a Contact will create with the name of the Account and that Contact will be the Client Contact on the Account.
   public static void updateClientContact(Map<Id,Account> accountMap) {
        try{
            List<Contact> contacts = new List<Contact>();
            for(Account account:accountMap.values()){
                Contact eachContact = new Contact();
                eachContact.LastName = account.Name;
                eachContact.AccountId = account.Id;
                contacts.add(eachContact);
                System.debug('4th ' + account.Id);
                System.debug('4th ' + eachContact.LastName);
            }
            insert contacts;
            System.debug('result '+ contacts);
            if(!contacts.isEmpty()){
                List<Account> accounts = new List<Account>();
                for(Contact eachContact:contacts){
                    Account acc = new Account();
                    acc.Id = eachContact.AccountId;
                    acc.Client_Contact__c = eachContact.Id;
                    accounts.add(acc);
                }
                update accounts;
            }
        }
        catch(Exception e){
            System.debug('Exception caught: '+ e.getMessage()); 
        }
    }
}