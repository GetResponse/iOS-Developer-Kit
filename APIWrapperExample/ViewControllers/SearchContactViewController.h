//
//  SearchContactViewController.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRApi.h"

@interface SearchContactViewController : UIViewController <UITextFieldDelegate>
@property (strong,nonatomic) GRCampaign *selectedCampaign;
@end
