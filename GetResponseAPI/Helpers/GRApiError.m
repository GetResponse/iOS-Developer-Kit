//
//  GRApiError.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "GRApiError.h"

@implementation GRApiError
- (NSError *)mappedError {
    NSString *errorDescriptionString = @"";
    
    if (self.context.firstObject != nil) {
        GRApiErrorContext *errorContext = self.context.firstObject;
        if (errorContext.errorDescription) {
            errorDescriptionString = errorContext.errorDescription;
        }
    } else {
        errorDescriptionString = self.codeDescription ? : @"Unknown API Error has occured. Please try again later.";
    }
    
    return [NSError errorWithDomain:@"com.getresponse.ApiError" code:self.code userInfo:@{NSLocalizedDescriptionKey : errorDescriptionString}];
}

+ (NSError *)noResourceError:(NSString *)errorDescription {
    GRApiError *apiError = [[GRApiError alloc] init];
    apiError.code = 404;
    apiError.codeDescription = errorDescription;
    return [apiError mappedError];
}

+ (NSError *)generalApiError {
    GRApiError *apiError = [[GRApiError alloc] init];
    apiError.code = 500;
    return [apiError mappedError];
}

+ (NSError *)noCampaignError:(NSString *)campaignName {
    return [GRApiError noResourceError:[NSString stringWithFormat:@"No campaign with name '%@' were found.", campaignName]];
}

+ (NSError *)noContactError:(NSString *)email {
    return [GRApiError noResourceError:[NSString stringWithFormat:@"No contacts with email '%@' were found.", email]];
}

@end
