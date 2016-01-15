//
//  GRGeolocation.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GRGeolocation : JSONModel
// All properties are optional
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *ontinentCode;
@property (nonatomic, copy) NSString *countryCode;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *postalCode;
@property (nonatomic, copy) NSString *dmaCode;
@property (nonatomic, copy) NSString *city;
@end
