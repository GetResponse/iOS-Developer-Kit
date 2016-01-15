//
//  GRApi.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "GRApi.h"
#import "GRApiDefines.h"
#import "AFNetworkActivityLogger.h"
#import "GRApiError.h"
#import "AFNetworking.h"

@interface GRApi ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;
@property (strong, nonatomic) AFHTTPRequestSerializer *httpSerializer;
@property (strong, nonatomic) AFJSONRequestSerializer *jsonSerializer;
@property (strong, nonatomic) NSString *apiURL;
@property (strong, nonatomic) NSMutableArray *cachedCampaigns;
@end

@implementation GRApi
@synthesize apiKey = _apiKey;
#pragma mark - Main
+ (instancetype)sharedInstance {
    static GRApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setupWithApiKey:(NSString *)apiKey {
    [self clearCache];
    self.apiKey = apiKey;
    self.resultsPerPage = @100;
}

#pragma mark - Campaigns List

- (void)getCampaignsWithCompletion:(void (^)(NSArray *, NSError *))completionBlock {
    [self getCampaignsWithParameters:nil completion:^(NSArray *campaignsList, NSError *error) {
        if (!error) {
            self.cachedCampaigns = [campaignsList mutableCopy];
            if (completionBlock) {
                completionBlock(self.cachedCampaigns, nil);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)getCampaignWithName:(NSString *)campaignName completion:(void (^)(GRCampaign *, NSError *))completionBlock {
    
    GRCampaign *cachedCampaign = [self campaignInCache:campaignName];
    if (cachedCampaign) {
        if (completionBlock) {
            completionBlock(cachedCampaign, nil);
        }
        return;
    }

    NSDictionary *parameters = @{@"query":@{@"name":campaignName}};
    [self getCampaignsWithParameters:parameters completion:^(NSArray *campaignsList, NSError *error) {
        if (!error) {
            NSError *apiError;
            GRCampaign *campaign;
            if (campaignsList.count == 1) {
                campaign = [campaignsList firstObject];
                [self addCampaignToCache:campaign];
            } else {
                apiError = [GRApiError noCampaignError:campaignName];
            }
            
            if (completionBlock) {
                completionBlock(campaign, apiError);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)getCampaignsWithParameters:(NSDictionary *)parameters completion:(void (^)(NSArray *, NSError *))completionBlock {
    [self performGET:CampaignsEndpoint parameters:parameters completion:^(id responseObject, NSDictionary *headers, NSError *error) {
        NSError *err;
        if (!error) {
            if ([responseObject isKindOfClass:[NSArray class]]) {
                NSArray *campaignsList = [GRCampaign arrayOfModelsFromDictionaries:responseObject error:&err];
                if (completionBlock) {
                    completionBlock(campaignsList, err);
                }
            } else {
                if (completionBlock) {
                    completionBlock(nil, [GRApiError generalApiError]);
                }
            }
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

#pragma mark - Contacts List

- (void)getContactsWithPageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *, NSNumber*, NSError *))completionBlock {
    [self getContactsWithParameters:nil pageNumber:pageNum completion:completionBlock];
}

- (void)getContactsForCampaignName:(NSString *)campaignName pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *, NSNumber*, NSError *))completionBlock {
    [self getCampaignWithName:campaignName completion:^(GRCampaign *campaign, NSError *error) {
        if (!error) {
            NSDictionary *parameters = @{@"query":@{@"campaignId":campaign.campaignId}};
            [self getContactsWithParameters:parameters pageNumber:pageNum completion:completionBlock];
        } else {
            completionBlock(nil, nil, error);
        }
    }];
}

- (void)getContactsForCampaign:(GRCampaign *)campaign pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *, NSNumber*, NSError *))completionBlock {
    [self getContactsByCampaignId:campaign.campaignId pageNumber:pageNum completion:completionBlock];
}

- (void)getContactsByCampaignId:(NSString *)campaignId pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *, NSNumber *, NSError *))completionBlock {
    NSDictionary *parameters = @{@"query":@{@"campaignId":campaignId}};
    [self getContactsWithParameters:parameters pageNumber:pageNum completion:completionBlock];
}

- (void)getContactsWithParameters:(NSDictionary *)parameters pageNumber:(NSNumber *)pageNum completion:(void (^)(NSArray *, NSNumber *,  NSError *))completionBlock {
    
    if (!pageNum) {
        pageNum = @1;
    }
    
    if (parameters) {
        NSMutableDictionary *tempParams = [parameters mutableCopy];
        tempParams[@"page"] = pageNum;
        tempParams[@"perPage"] = self.resultsPerPage;
        parameters = tempParams;
    } else {
        parameters = @{@"page":pageNum, @"perPage": self.resultsPerPage};
    }
    [self performGET:ContactsEndpoint parameters:parameters completion:^(id responseObject, NSDictionary *headers, NSError *error) {
        NSError *err;
        NSNumber *totalPages = [headers objectForKey:@"TotalPages"];
        if (!error) {
            NSArray *contactsArray = [GRContact arrayOfModelsFromDictionaries:responseObject error:&err];
            if (completionBlock) {
                completionBlock(contactsArray, totalPages, err);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil, totalPages, error);
            }
        }
    }];
}

#pragma mark - Contacts Manipulation

- (void)getContactById:(NSString *)contactId completion:(void (^)(GRContact *, NSError *))completionBlock {
    [self performGET:[NSString stringWithFormat:@"%@/%@",ContactsEndpoint, contactId] parameters:nil completion:^(id responseObject, NSDictionary *headers, NSError *error) {
        NSError *err;
        if (!error) {
            GRContact *contact = [[GRContact alloc] initWithDictionary:responseObject error:&err];
            if (completionBlock) {
                completionBlock(contact, err);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)getContactByEmail:(NSString *)email inCampaign:(NSString *)campaignName completion:(void (^)(GRContact *, NSError *))completionBlock {
    [self getCampaignWithName:campaignName completion:^(GRCampaign *campaign, NSError *error) {
        if (!error) {
            NSDictionary *parameters = @{@"query":@{@"email":email, @"campaignId": campaign.campaignId}};
            [self getContactsWithParameters:parameters pageNumber:@1 completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
                if (!error) {
                    NSError *apiError;
                    GRContact *contact;
                    if (contactsArray.count == 1) {
                         contact = [contactsArray firstObject];
                    } else {
                        apiError = [GRApiError noContactError:email];
                    }
                    
                    if (completionBlock) {
                        completionBlock(contact, apiError);
                    }
                } else {
                    if (completionBlock) {
                        completionBlock(nil, error);
                    }
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    }];
}

- (void)addContactWithName:(NSString *)name email:(NSString *)email inCampaign:(NSString *)campaignName completion:(void (^)(NSError *error))completionBlock {
    [self getCampaignWithName:campaignName completion:^(GRCampaign *campaign, NSError *error) {
        if (!error) {
            GRContact *tempContact = [[GRContact alloc] init];
            tempContact.name = name;
            tempContact.email = email;
            tempContact.campaignId = campaign.campaignId;
            
            [self addContact:tempContact completion:^(NSError *error) {
                if (completionBlock) {
                    completionBlock(error);
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock(error);
            }
        }
        
    }];
}

- (void)addContact:(GRContact *)contact completion:(void (^)(NSError *))completionBlock {
    NSDictionary *parameters = [contact toDictionary];
    [self performPOST:ContactsEndpoint parameters:parameters completion:^(id responseObject, NSError *error) {
        if (completionBlock) {
            return completionBlock(error);
        }
    }];
}

- (void)deleteContactById:(NSString *)contactId completion:(void (^)(NSError *error))completionBlock {
    [self performDELETE:[NSString stringWithFormat:@"%@/%@",ContactsEndpoint, contactId] completion:completionBlock];
}

- (void)deleteContact:(GRContact *)contact completion:(void (^)(NSError *))completionBlock {
    [self deleteContactById:contact.contactId completion:completionBlock];
}

#pragma mark - Communication

- (void)performGET:(NSString *)endpoint parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSDictionary *headers, NSError *error))completionBlock {
    [self useRequestSerializer:self.httpSerializer];
    [self.operationManager GET:endpoint parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, operation.response.allHeaderFields, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (operation.responseObject) {
            NSError *err = nil;
            GRApiError *apiError = [[GRApiError alloc] initWithDictionary:operation.responseObject error:&err];
            error = [apiError mappedError];
        }
        
        if (completionBlock) {
            completionBlock(nil, operation.response.allHeaderFields, error);
        }
    }];
}

- (void)performPOST:(NSString *)endpoint parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, NSError *error))completionBlock {
    [self useRequestSerializer:self.jsonSerializer];
    [self.operationManager POST:endpoint parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (operation.responseObject) {
            NSError *err = nil;
            GRApiError *apiError = [[GRApiError alloc] initWithDictionary:operation.responseObject error:&err];
            error = [apiError mappedError];
        }
        
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

- (void)performDELETE:(NSString *)endpoint completion:(void (^)(NSError *error))completionBlock {
    [self useRequestSerializer:self.httpSerializer];
    [self.operationManager DELETE:endpoint parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (completionBlock) {
            completionBlock(nil);
        };
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }];
}

#pragma mark - Cache
- (GRCampaign *)campaignInCache:(NSString *)campaignName {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name==%@",campaignName];
    NSArray *results = [self.cachedCampaigns filteredArrayUsingPredicate:predicate];
    return [results firstObject];
}

- (void)addCampaignToCache:(GRCampaign *)campaign {
    GRCampaign *cachedCampaign = [self campaignInCache:campaign.name];
    if (!cachedCampaign) {
        [self.cachedCampaigns addObject:campaign];
    }
}

- (void)clearCache {
    self.cachedCampaigns = [NSMutableArray new];
}

#pragma mark - Utility
- (void)setVerbose:(BOOL)verbose {
    if (verbose) {
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    } else {
        [[AFNetworkActivityLogger sharedLogger] stopLogging];
    }
}

- (NSString *)apiKey {
    return [NSString stringWithFormat:@"api-key %@",_apiKey];
}

- (NSString *)apiURL {
    return API_URL;
}

- (void)setApiKey:(NSString *)apiKey {
    _apiKey = apiKey;
    [self clearCache];
}

- (AFHTTPRequestOperationManager *)operationManager {
    if (!_operationManager) {
        _operationManager = [AFHTTPRequestOperationManager manager];
    }
    return _operationManager;
}

- (AFHTTPRequestSerializer *)httpSerializer {
    if (!_httpSerializer) {
        _httpSerializer = [AFHTTPRequestSerializer new];
    }
    return _httpSerializer;
}

- (AFJSONRequestSerializer *)jsonSerializer {
    if (!_jsonSerializer) {
        _jsonSerializer = [AFJSONRequestSerializer new];
    }
    return _jsonSerializer;
}

- (void)useRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    self.operationManager.requestSerializer = requestSerializer;
    [self.operationManager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.operationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self.operationManager.requestSerializer setValue:@"utf-8" forHTTPHeaderField:@"Accept-Charset"];
    [self.operationManager.requestSerializer setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [self.operationManager.requestSerializer setValue:self.apiKey forHTTPHeaderField:@"X-Auth-Token"];
}
@end
