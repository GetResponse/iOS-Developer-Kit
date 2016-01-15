//
//  GRApiError.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GRApiErrorContext.h"

@interface GRApiError : JSONModel
@property (assign) NSInteger code;
@property (assign) NSInteger httpStatus;
@property (copy, nonatomic) NSString<Optional> *codeDescription;
@property (copy, nonatomic) NSString<Optional> *message;
@property (copy, nonatomic) NSString<Optional> *moreInfo;
@property (strong, nonatomic) NSArray<Optional, GRApiErrorContext> *context;

+ (NSError *)generalApiError;
+ (NSError *)noCampaignError:(NSString *)campaignName;
+ (NSError *)noContactError:(NSString *)email;
- (NSError *)mappedError;

@end
