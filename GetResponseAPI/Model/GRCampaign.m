//
//  GRCampaign.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "GRCampaign.h"

@implementation GRCampaign
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description" : @"desc"}];
}
@end
