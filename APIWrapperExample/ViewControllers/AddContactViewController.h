//
//  AddContactViewController.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRApi.h"

@interface AddContactViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) GRCampaign *selectedCampaign;
@end
