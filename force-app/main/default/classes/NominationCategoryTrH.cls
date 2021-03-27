public class NominationCategoryTrH extends TriggerHandler {
    public NominationCategoryTrH(){
    }
	
    public override void beforeInsert(){
        //Add only unique name for Nomination Category
        Map<Id, List<String>> existNamesInCampaign = new Map<Id, List<String>>();
        List<NominationCategory__c> newRecords = (List<NominationCategory__c>)Trigger.new;
        Set<Id> campaignIds = new Set<Id>();
        for(NominationCategory__c item : newRecords){
            campaignIds.add(item.CampaignId__c);
        } 
        Map<Id, NominationCategory__c> dublicateNameIds = new Map<Id, NominationCategory__c>();
        
        for(NominationCategory__c item : [SELECT Name, CampaignId__c 
                                                 FROM NominationCategory__c
                                                 WHERE CampaignId__c IN :campaignIds]){
            if(!existNamesInCampaign.containsKey(item.CampaignId__c)){
                existNamesInCampaign.put(item.CampaignId__c, new List<String>());
            }                                        
            existNamesInCampaign.get(item.CampaignId__c)
                                .add(item.Name);
        }
        for(NominationCategory__c item : newRecords){
            if (!existNamesInCampaign.containsKey(item.CampaignId__c)){
                existNamesInCampaign.put(item.CampaignId__c, new List<String>());
                existNamesInCampaign.get(item.CampaignId__c)
                                    .add(item.Name);
            }else if(!existNamesInCampaign.get(item.CampaignId__c).contains(item.Name)){
                existNamesInCampaign.get(item.CampaignId__c)
                                    .add(item.Name);                           
            }else {
                dublicateNameIds.put(item.Id, item);
            }
        }
        if(!dublicateNameIds.isEmpty()){
            //all records must be updated successfully or the entire operation rolls back
            for(NominationCategory__c tmpCategory : newRecords){
            //tmpCategory.addError('Nomination Category with the same name already exists. Please try to use it.');
           	tmpCategory.UniqueName__c = false;
        }
        }
        
    }
}