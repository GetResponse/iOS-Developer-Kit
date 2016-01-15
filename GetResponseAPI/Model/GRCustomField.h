//
//  GRCustomField.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GRCustomField
@end

@interface GRCustomField : JSONModel

@property(copy, nonatomic) NSString *customFieldId;
@property(copy, nonatomic) NSString *fieldType;
@property(copy, nonatomic) NSString <Optional> *href;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *type;
@property(copy, nonatomic) NSString *valueType;
@property(strong, nonatomic) NSArray *values;

@end