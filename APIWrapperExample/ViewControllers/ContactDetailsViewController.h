//
//  ContactDetailsViewController.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRApi.h"

@interface ContactDetailsViewController : UIViewController <UIAlertViewDelegate>
@property (strong, nonatomic) GRContact *selectedContact;
@end
