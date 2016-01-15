//
//  MethodsTests.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "MethodsTests.h"
#import "GRApi.h"

@interface MethodsTests ()
@property (nonatomic, strong) NSString *campaignId;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *campaignName;
@property (nonatomic, strong) NSString *testContactName;
@property (nonatomic, strong) NSString *testContactEmail;
@property (nonatomic, strong) NSString *existingContactEmail;

@end

@implementation MethodsTests

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *API_KEY = @""; //Developer API Key here
    self.campaignName = @""; //Test Campaign Name here
    self.testContactName = @""; //Test Contact name with %@ here
    self.testContactEmail = @""; //Test Contact email with %@ here
    self.existingContactEmail = @""; //Self-explanatory
    
    [[GRApi sharedInstance] setupWithApiKey:API_KEY];
    
    [self testCampaignsMethods];
    [self testContactsListMethods];
    [self testContactMethods];
    
    // Uncomment this line if you know what you are doing.
    //[self testDestructiveMetods];
}

#pragma mark - Campaigns Methods Tests
- (void)testCampaignsMethods {
    [self testGetCampagins];
    [self testGetSingleCampaign];
}

- (void)testGetCampagins {
    [[GRApi sharedInstance] getCampaignsWithCompletion:^(NSArray *campaignsList, NSError *error) {
        if (!error) {
            NSLog(@"Got %li campaigns!", [campaignsList count]);
        }
    }];
}

- (void)testGetSingleCampaign {
    [[GRApi sharedInstance] getCampaignWithName:self.campaignName completion:^(GRCampaign *campaign, NSError *error) {
        if (!error) {
            self.campaignId = campaign.campaignId;
            NSLog(@"Got campaign: %@", campaign.campaignId);
        }
    }];
}

#pragma mark - Contact List Methods
- (void)testContactsListMethods {
    [self testGetContacts];
    [self testGetContactByEmail];
    [self testGetContactsForCampaignName];
    [self testGetSingleContact];
}

- (void)testGetContacts {
    [[GRApi sharedInstance] getContactsWithPageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        if (!error) {
            NSLog(@"Got %li contacts!", contactsArray.count);
            NSLog(@"Total pages: %i", totalPages.intValue);
        }
    }];
}

- (void)testGetContactByEmail {
    [[GRApi sharedInstance] getContactByEmail:self.existingContactEmail inCampaign:self.campaignName completion:^(GRContact *contact, NSError *error) {
        if (!error) {
            NSLog(@"Got contact with name: %@ for email %@", contact.name, contact.email);
        }
    }];
}

- (void)testGetContactsForCampaignName {
    [[GRApi sharedInstance] getContactsForCampaignName:self.campaignName pageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        if (!error) {
            NSLog(@"Got %li contacts for campaign: %@", [contactsArray count], self.campaignName);
        }
    }];
    
    [[GRApi sharedInstance] getContactsForCampaignName:@"starter__run" pageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)testGetSingleContact {
    [[GRApi sharedInstance] getContactById:@"bDLyN" completion:^(GRContact *contact, NSError *error) {
        if (!error) {
            NSLog(@"Got Contact: %@", contact.name);
        }
    }];
}

#pragma mark - Contact Methods
- (void)testContactMethods {
    [self testAddContact];
    [self testAddSimpleContact];
}



- (void)testAddContact {
    GRContact *contact = [self randomContact];
    contact.campaignId = self.campaignId;
    [[GRApi sharedInstance] addContact:contact completion:^(NSError *error) {
        if (!error) {
            NSLog(@"Contact %@ added.", contact.name);
        }
    }];
}

- (void)testAddSimpleContact {
    GRContact *contact = [self randomContact];
    [[GRApi sharedInstance] addContactWithName:contact.name email:contact.email inCampaign:self.campaignName completion:^(NSError *error) {
        if (!error) {
            NSLog(@"Simple Contact - Added %@", contact.name);
        }
    }];
}

#pragma mark - Destructive Methods
- (void)testDestructiveMetods {
    [[GRApi sharedInstance] getContactsWithPageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        GRContact *contact = [contactsArray lastObject];
        
        [[GRApi sharedInstance] deleteContact:contact completion:^(NSError *error) {
            if (error) {
                NSLog(@"Error occured: %@", [error localizedDescription]);
            }
        }];
    }];
}


#pragma mark - Helpers
- (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}

- (GRContact *)randomContact {
    GRContact *contact = [[GRContact alloc] init];
    contact.name = [NSString stringWithFormat:self.testContactName, [self randomAlphanumericStringWithLength:8]];
    contact.email = [NSString stringWithFormat:self.testContactEmail, [self randomAlphanumericStringWithLength:8]];
    return contact;
}

@end
