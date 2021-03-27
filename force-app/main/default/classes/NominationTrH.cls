public class NominationTrH extends TriggerHandler{
    
    public NominationTrH(){
    }
    public override void beforeInsert(){
        List<Nomination__c> newNominations = (List<Nomination__c>)Trigger.new;
        Set<Id> newNomorIds = new Set<Id>();
        
        for(Nomination__c tmpNom : newNominations){
           newNomorIds.add(tmpNom.NominatorId__c);
        }
        List<String> breakFirstRuleKeys = new List<String>();
        String keyFirstRule = '';
        
        Map<String, List<Nomination__c>> breakSecondRuleKeys = new Map<String, List<Nomination__c>>();
        String keySecondRule = '';
        
        for(Nomination__c tmpNom : [SELECT Id, NominatorId__c, NomineeId__c, NominationCategoryId__c
                                    FROM Nomination__c]){
            keyFirstRule = ''+ tmpNom.NomineeId__c + ',' + 
                               tmpNom.NominatorId__c + ',' + 
                               tmpNom.NominationCategoryId__c;
            keySecondRule = '' + tmpNom.NominatorId__c + ',' + 
                                 tmpNom.NominationCategoryId__c;
            breakFirstRuleKeys.add(keyFirstRule);

            if(!breakSecondRuleKeys.containsKey(keySecondRule)){
                breakSecondRuleKeys.put(keySecondRule, new List<Nomination__c>());
            }  
            breakSecondRuleKeys.get(keySecondRule).add(tmpNom);
        }
        
        Boolean isBreakFirstRule = false;
        Boolean isBreakSecondRule = false;
        for(Nomination__c tmpNom : (List<Nomination__c>)Trigger.new){
            keyFirstRule = ''+ tmpNom.NomineeId__c + ',' + 
                               tmpNom.NominatorId__c + ',' + 
                               tmpNom.NominationCategoryId__c;
            keySecondRule = '' + tmpNom.NominatorId__c + ',' +
                                 tmpNom.NominationCategoryId__c;
            if(breakFirstRuleKeys.contains(keyFirstRule)){
                isBreakFirstRule = true;
                break;
            }else{
                breakFirstRuleKeys.add(keyFirstRule);
            }
            if(breakSecondRuleKeys.containsKey(keySecondRule)){
                breakSecondRuleKeys.get(keySecondRule).add(tmpNom);
                
                if(breakSecondRuleKeys.get(keySecondRule).size() > 3){
                	isBreakSecondRule = true;
                	break;
                }
            } else {
                breakSecondRuleKeys.put(keySecondRule, new List<Nomination__c>());
            }
        }
        String brokenRuleMessage = 'Any';
        if(isBreakFirstRule){
            brokenRuleMessage = 'TwiceNomineePerNomination';
        } else if(isBreakSecondRule){
            brokenRuleMessage = 'ThreeNomineesPerNomination';
        }
        for(Nomination__c tmpNomination : newNominations){
           		 tmpNomination.BrokenRuleName__c = brokenRuleMessage;
        	}
        
    }    
   
    public override void afterInsert(){
        // Create and input new NomineeInNominationCategory obj if it is absent. 
        Set<String> existNincNames = new Set<String>();
        for(NomineeInNominationCategory__c tmpNinc : [SELECT Id, NominationCategoryId__c, NomineeId__c 
                                                      FROM NomineeInNominationCategory__c]){
            existNincNames.add(''+ tmpNinc.NominationCategoryId__c + tmpNinc.NomineeId__c);
        }
        List <NomineeInNominationCategory__c> absentNincs = new List <NomineeInNominationCategory__c>();
        String keyNameAbsentNinc = '';
        for(Nomination__c tmpNom : [SELECT Id, NomineeId__c, NominationCategoryId__c
                                    FROM Nomination__c
                                    WHERE Id IN :Trigger.new]){
            keyNameAbsentNinc = ''+ tmpNom.NominationCategoryId__c + tmpNom.NomineeId__c;
            if(!existNincNames.contains(keyNameAbsentNinc)){
                absentNincs.add(new NomineeInNominationCategory__c(
                                            NominationCategoryId__c = tmpNom.NominationCategoryId__c,
                				 			NomineeId__c = tmpNom.NomineeId__c,
                				 			Active__c = false));
                existNincNames.add(keyNameAbsentNinc);  
                
            }
        }
       	if(!absentNincs.isEmpty()){
            	insert absentNincs;
        }
    }

    public override void afterUpdate(){
        //Change Active field (NomineeInNominationCategory obj) to true if nomination has been approved
        Map<Id, Nomination__c> oldInAprovalNoms = (Map<Id, Nomination__c>)Trigger.oldMap;
        Map<String, Nomination__c> nomsWithChange = new Map <String, Nomination__c>();
        String key ='';
        String optionStatus = '';
        for(Nomination__c tmpNom : [SELECT Id, Status__c, NominationCategoryId__c, NomineeId__c 
                                    FROM Nomination__c 
                                    WHERE Id IN :Trigger.New 
                                    AND Status__c = 'Approved']){
            optionStatus = oldInAprovalNoms.get(tmpNom.Id).Status__c;                           
            if (optionStatus == 'In Approval'){
                key = ''+ tmpNom.NominationCategoryId__c +
                          tmpNom.NomineeId__c;
                nomsWithChange.put(key, tmpNom);
            } 
        }
        List<NomineeInNominationCategory__c> nincToUpdate = new List <NomineeInNominationCategory__c>();
        for(NomineeInNominationCategory__c tmpNinc : [SELECT Id, NominationCategoryId__c, NomineeId__c
                                                      FROM NomineeInNominationCategory__c]){
            key = ''+ tmpNinc.NominationCategoryId__c + 
                      tmpNinc.NomineeId__c;   
            if(nomsWithChange.containsKey(key)){
                 tmpNinc.Active__c = true;
                 nincToUpdate.add(tmpNinc);
            }                                              
        }
        if(!nincToUpdate.isEmpty()){
           update nincToUpdate; 
        }
        
 
    }
    
 
}