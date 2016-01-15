//
//  GRCampaign.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GRCampaign : JSONModel
@property (copy, nonatomic) NSString *campaignId;
@property (copy, nonatomic) NSString <Optional> *href;
@property (copy, nonatomic) NSString <Optional> *name;
@property (copy, nonatomic) NSString <Optional> *desc;
@property (copy, nonatomic) NSString <Optional> *languageCode;
@property (copy, nonatomic) NSDate <Optional> *createdOn;
@property (assign, nonatomic) BOOL isDefault;
@end
