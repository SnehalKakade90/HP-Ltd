trigger AccountTrigger11 on Account(after update, after insert,after delete , after undelete) {
   // triggere sceenaro starts
   /* if(trigger.isAfter && trigger.isUpdate){
        AccountTrigger11Helper.updateRecords(Trigger.new);  
    }
   if(trigger.isAfter && trigger.isInsert){
        AccountTrigger11Helper.sendEmail(Trigger.new); 
    }
    if(trigger.isAfter && trigger.isUpdate){
        AccountTrigger11Helper.updateContact(Trigger.newMap, Trigger.oldMap);
    }*/
    if(trigger.isAfter && trigger.isInsert){
        AccountTrigger11Helper.updateClientContact(Trigger.newMap); 
    }
}