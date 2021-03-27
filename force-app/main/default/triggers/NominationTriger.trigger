trigger NominationTriger on Nomination__c (before insert,
                                           after insert,
                                           after update) {
	(new NominationTrH()).run();
}