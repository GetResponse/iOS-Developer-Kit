//
//  ContactsTableViewController.h
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRApi.h"

@interface ContactsTableViewController : UITableViewController
@property (nonatomic, strong) GRCampaign *selectedCampaign;
@end
