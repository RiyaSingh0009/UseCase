trigger CreateNonconformance on Case (before insert, before update) {
    // Check if the current user has the Case Admin permission set
    if(System.FeatureManagement.checkPermission('Case Admin Permissions')) return;
    
    // Collect the Case Ids that need to be processed
    Set<Id> caseIds = new Set<Id>();
    for (Case newCase : Trigger.new) {
        if (newCase.Type == 'Problem' && (Trigger.isInsert || newCase.Type != Trigger.oldMap.get(newCase.Id).Type)) {
            caseIds.add(newCase.Id);
        }
    }
    
    // Query existing Nonconformance records for the selected Cases
    Map<Id, Nonconformance__c> existingNonconformances = new Map<Id, Nonconformance__c>(
        [SELECT Id, Case__c FROM Nonconformance__c WHERE Case__c IN :caseIds]);
    
    // Create new Nonconformance records for the selected Cases
    List<Nonconformance__c> newNonconformances = new List<Nonconformance__c>();
    for (Case newCase : Trigger.new) {
        if (newCase.Type == 'Problem' && !existingNonconformances.containsKey(newCase.Id)) {
            Nonconformance__c nc = new Nonconformance__c(
                Case__c = newCase.Id
            );
            newNonconformances.add(nc);
            newCase.SQX_NC_Reference__c = nc.Id; // Populate the lookup field
        }
    }
    
    // Insert the new Nonconformance records
    insert newNonconformances;
}