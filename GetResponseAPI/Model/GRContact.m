//
//  GRContact.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "GRContact.h"
#import "GRCampaignReference.h"

@interface GRContact()
@property (strong, nonatomic) GRCampaignReference *campaign;
@end

@implementation GRContact
- (void)setCampaignId:(NSString *)campaignId {
    self.campaign = [[GRCampaignReference alloc] init];
    self.campaign.campaignId = campaignId;
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
