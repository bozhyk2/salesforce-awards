public class NomineeInNominationCategoryTrH extends TriggerHandler{
	
    public override void beforeInsert(){
        List<NomineeInNominationCategory__c> newNincs = (List<NomineeInNominationCategory__c>)Trigger.new;
        String nameNinc = '';
       
        Map<Id, Contact> conts = new Map<Id, Contact>([SELECT Id, FirstName, LastName, Email 
                                                       FROM Contact]);
        Map<Id, NominationCategory__c> nomCats = new Map<Id, NominationCategory__c>([SELECT Id, Name 
                                                                                     FROM NominationCategory__c]);
        for(NomineeInNominationCategory__c tmpNinc: newNincs){
             nameNinc = nomCats.get(tmpNinc.NominationCategoryId__c).Name +
               			  ' - ' + conts.get(tmpNinc.NomineeId__c).FirstName + 
                			' ' + conts.get(tmpNinc.NomineeId__c).LastName +
               			   ' ('  + conts.get(tmpNinc.NomineeId__c).Email + ')';
            tmpNinc.Name = nameNinc;
        }
    }
}