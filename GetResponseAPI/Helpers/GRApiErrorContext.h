//
//  GRApiErrorContext.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GRApiErrorContext
@end

@interface GRApiErrorContext : JSONModel
@property (copy, nonatomic) NSString<Optional> *errorDescription;
@property (copy, nonatomic) NSString<Optional> *codeDescription;
@property (copy, nonatomic) NSString<Optional> *originalValue;
@property (copy, nonatomic) NSString<Optional> *validationType;
@end
