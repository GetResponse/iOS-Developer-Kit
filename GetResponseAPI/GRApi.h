//
//  GRApi.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRContact.h"
#import "GRCampaign.h"

@interface GRApi : NSObject
@property (strong, nonatomic) NSString *apiKey;
@property (assign, nonatomic) BOOL verbose;
@property (strong, nonatomic) NSNumber *resultsPerPage;
+ (instancetype)sharedInstance;

- (void)setupWithApiKey:(NSString *)apiKey;

// Campaigns
- (void)getCampaignWithName:(NSString *)campaignName completion:(void (^)(GRCampaign *campaign, NSError *error))completionBlock;
- (void)getCampaignsWithCompletion:(void (^)(NSArray *campaignsArray, NSError *error))completionBlock;

// Contacts List
- (void)getContactsWithPageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *contactsArray, NSNumber*totalPages, NSError *error))completionBlock;
- (void)getContactsForCampaignName:(NSString *)campaignName pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *contactsArray, NSNumber *totalPages, NSError *error))completionBlock;
- (void)getContactsForCampaign:(GRCampaign *)campaign pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *contactsArray, NSNumber *totalPages, NSError *error))completionBlock;
- (void)getContactsByCampaignId:(NSString *)campaignId pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *contactsArray, NSNumber *totalPages, NSError *error))completionBlock;

// Contacts Manipulation
- (void)getContactById:(NSString *)contactId completion:(void (^)(GRContact *contact, NSError *error))completionBlock;
- (void)getContactByEmail:(NSString *)email inCampaign:(NSString *)campaignName completion:(void (^)(GRContact *contact, NSError *error))completionBlock;

- (void)addContactWithName:(NSString *)name email:(NSString *)email inCampaign:(NSString *)campaignName completion:(void (^)(NSError *error))completionBlock;
- (void)addContact:(GRContact *)contact completion:(void (^)(NSError *error))completionBlock;

- (void)deleteContact:(GRContact *)contact completion:(void (^)(NSError *error))completionBlock;
- (void)deleteContactById:(NSString *)contactId completion:(void (^)(NSError *error))completionBlock;
@end
