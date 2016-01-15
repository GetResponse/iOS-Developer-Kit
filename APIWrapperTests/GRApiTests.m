//
//  GRApiTests.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GRApi.h"

@interface GRApiTests : XCTestCase
@property (strong, nonatomic) NSDictionary *configuration;
@property (strong, nonatomic) NSString *testCampaignName;
@property (strong, nonatomic) NSString *testContactEmail;
@property (strong, nonatomic) NSString *testContactId;
@property (strong, nonatomic) NSString *testCampaignId;
@end

@implementation GRApiTests
#pragma mark - Setup
- (void)setUp {
    [super setUp];
    
    //INFO: Due to security reasons, you need to have a file called 'environment.plist' to run unit tests
    NSString *pathToPlist = [[NSBundle mainBundle] pathForResource:
                      @"environment" ofType:@"plist"];
    
    self.configuration = [NSMutableDictionary dictionaryWithContentsOfFile:pathToPlist];
    self.testCampaignName = [self.configuration objectForKey:@"test_campaign_name"];
    self.testContactEmail = [self.configuration objectForKey:@"test_contact_email"];
    self.testContactId = [self.configuration objectForKey:@"test_contact_id"];
    self.testCampaignId = [self.configuration objectForKey:@"test_campaign_id"];
    
    [[GRApi sharedInstance] setupWithApiKey:[self.configuration objectForKey:@"api_key"]];
    [[GRApi sharedInstance] setResultsPerPage:@10];
}

#pragma mark - Campaigns Methods Tests
- (void)testGetCampagins {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getCampaignsWithCompletion:^(NSArray *campaignsList, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got %li campaigns!", campaignsList.count);
            XCTAssertGreaterThan(campaignsList.count, 0, @"Could not get campaign list.");
        } else {
            XCTFail(@"Could not get campaigns.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetSingleCampaign {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getCampaignWithName:self.testCampaignName completion:^(GRCampaign *campaign, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got campaign: %@", campaign.campaignId);
            XCTAssertEqualObjects(self.testCampaignName, campaign.name, @"Campaign names does not match.");
        } else {
            XCTFail(@"Could not get campaign.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Contact List Methods
- (void)testGetContacts {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getContactsWithPageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got %li contacts!", contactsArray.count);
            NSLog(@"Total pages: %i", totalPages.intValue);
            XCTAssertGreaterThan(contactsArray.count, 0, @"Could not get contacts list.");
        } else {
            XCTFail(@"Could not get contact list.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetContactByEmail {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getContactByEmail:self.testContactEmail inCampaign:self.testCampaignName completion:^(GRContact *contact, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got contact with name: %@ for email %@", contact.name, contact.email);
            XCTAssertEqualObjects(self.testContactEmail, contact.email, @"Contact email does not match");
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
            XCTFail(@"Could not get contact");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


- (void)testGetContactsForCampaignName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getContactsForCampaignName:self.testCampaignName pageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got %li contacts for campaign: %@", [contactsArray count], self.testCampaignName);
            XCTAssertGreaterThan(contactsArray.count, 0, @"Could not get contacts list for campaign.");
        } else {
            XCTFail(@"Could not get contact list for campaign.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetContactsForCampaignThatDoesNotExist {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getContactsForCampaignName:[NSString stringWithFormat:@"%@_2",self.testCampaignName] pageNumber:nil completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        [expectation fulfill];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            XCTAssertEqual(error.code, 404, @"Error is different than 404");
        } else {
            XCTFail(@"This method should not return any contacts for random campaign");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testGetSingleContact {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [[GRApi sharedInstance] getContactById:self.testContactId completion:^(GRContact *contact, NSError *error) {
        [expectation fulfill];
        if (!error) {
            NSLog(@"Got Contact: %@", contact.name);
            XCTAssertEqualObjects(contact.contactId, self.testContactId, @"Contacts Ids are different.");
        } else {
            XCTFail(@"Could not get specific contact.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Contact Methods
- (void)testAddContact {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    GRContact *contact = [self randomContact];
    contact.campaignId = self.testCampaignId;
    [[GRApi sharedInstance] addContact:contact completion:^(NSError *error) {
        [expectation fulfill];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            XCTFail(@"Could not queue contact by API.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAddSimpleContact {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    GRContact *contact = [self randomContact];
    [[GRApi sharedInstance] addContactWithName:contact.name email:contact.email inCampaign:self.testCampaignName completion:^(NSError *error) {
        [expectation fulfill];
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            XCTFail(@"Could not queue contact by API.");
        }
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

#pragma mark - Helpers
- (GRContact *)randomContact {
    GRContact *contact = [[GRContact alloc] init];
    contact.name = [NSString stringWithFormat:[self.configuration objectForKey:@"contact_name_format"], [self randomAlphanumericStringWithLength:8]];
    contact.email = [NSString stringWithFormat:[self.configuration objectForKey:@"contact_email_format"], [self randomAlphanumericStringWithLength:8]];
    return contact;
}

- (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}
@end
