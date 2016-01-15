//
//  GRContact.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GRCampaign.h"
#import "GRGeolocation.h"
#import "GRCustomField.h"

@interface GRContact : JSONModel
@property (copy, nonatomic) NSString *contactId;
@property (copy, nonatomic) NSString *href;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *note;
@property (copy, nonatomic) NSString *origin;
@property (copy, nonatomic) NSString *dayOfCycle;
@property (strong, nonatomic) NSDate *createdOn;
@property (strong, nonatomic) NSDate *changedOn;
@property (copy, nonatomic) NSString *campaignId;
@property (copy, nonatomic) NSString *timeZone;
@property (copy, nonatomic) NSString *ipAddress;
@property (copy, nonatomic) NSString *activities;
@property (strong, nonatomic) GRGeolocation *geolocation;
@property (strong, nonatomic) NSArray <GRCustomField> *customFieldValues;
@end
