//
//  GRCampaignReference.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GRCampaignReference : JSONModel
@property (copy, nonatomic) NSString *campaignId;
@property (copy, nonatomic) NSString<Optional> *name;
@end
