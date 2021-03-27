@isTest
public class TestDataFactory {
    public static List<NominationCategory__c> createNominationCategory(Integer numSameNames,
                                                                       String nameExample,
                                                                       Integer numDiffNames){
        Campaign tmpCampaign = generateUniqueCampaignId('Test Campaign');
        List<NominationCategory__c> listNc = new List<NominationCategory__c>();
        for(Integer i = 0; i < numSameNames; i++){
          listNc.add(new NominationCategory__c(Name=nameExample, UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        }
        for(Integer i = 0; i < numDiffNames; i++){
          	listNc.add(new NominationCategory__c(Name=nameExample + i, UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        }                                                                 
        return listNc;
    }
           
    public static List<Contact> createTenDiffContact(){
        List<Contact> conts = new List<Contact>();
        conts.add(new Contact(Email='johndou@ibozh.com', FirstName='John', LastName='Dou'));
        conts.add(new Contact(Email='noahdavis@ibozh.com', FirstName='Noah', LastName='Davis'));
        conts.add(new Contact(Email='liammiller@ibozh.com', FirstName='Liam', LastName='Miller'));
        conts.add(new Contact(Email='lucasgarcia@ibozh.com', FirstName='Lucas', LastName='Garcia'));
        conts.add(new Contact(Email='oliverjones@ibozh.com', FirstName='Oliver', LastName='Jones'));
        conts.add(new Contact(Email='emilygonzalez@ibozh.com', FirstName='Emily', LastName='Gonzalez'));
        conts.add(new Contact(Email='maryprivate@ibozh.com', FirstName='Mary', LastName='Private'));
        conts.add(new Contact(Email='oliviasmith@ibozh.com', FirstName='Olivia', LastName='Smith'));
        conts.add(new Contact(Email='emmajohnson@ibozh.com', FirstName='Emma', LastName='Johnson'));
        conts.add(new Contact(Email='sophiabrown@ibozh.com', FirstName='Sophia', LastName='Brown'));
        return conts;
    }
     public static List<NominationCategory__c> createTenDiffNominationCategory(){
        Campaign tmpCampaign = generateUniqueCampaignId('Test Campaign');
        List<NominationCategory__c> listNc = new List<NominationCategory__c>();
        listNc.add(new NominationCategory__c(Name='The Best Expert', UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best DevOps', UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Mentor', UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Quality Assurance Tester', UniqueName__c=true, CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Web Developer', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Systems Analyst', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Network Engineer', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Best Support Specialist', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Technical Leader', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        listNc.add(new NominationCategory__c(Name='The Most Creative Person', UniqueName__c=true,  CampaignId__c=tmpCampaign.Id));
        return listNc;
    }
    public static List<String> createTenWellReview(){
        List<String> listRews = new List<String>();
        listRews.add('Achieves optimal levels of performance and accomplishment with...');
        listRews.add('Provides strong evidence of [specific accomplishment]...');
        listRews.add('Excels at developing programs / strategies that have delivered X results');
        listRews.add('Improved production by X% through [specific task]');
        listRews.add('Exceeded the original goal of X by X% through [specific task]');
        listRews.add('Continuously examines administrative effectiveness and seeks better procedures such as [tasks]');
        listRews.add('Develops successful administrative strategies such as [task] that led to [results]');
        listRews.add('Establishes effective systems for information retrieval through [task]');
        listRews.add('Improves administrative support systems through [task]');
        listRews.add('Keeps documents organized via [task] to avoid duplicate information');
    	return listRews;
    }
    
    
    private static Campaign generateUniqueCampaignId(String campaignName){
     
        List<Campaign> existCampaign = [SELECT Id, Name
                                    FROM Campaign
                                    WHERE Name =:campaignName];
        if(!existCampaign.isEmpty()){
            return existCampaign[0];
        }
        Campaign tmpCampaign = new Campaign(Name='Test Campaign');
        insert tmpCampaign;
        return tmpCampaign;
    }
 
}