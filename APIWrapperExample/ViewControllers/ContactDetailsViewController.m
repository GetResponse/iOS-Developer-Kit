//
//  ContactDetailsViewController.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "ContactDetailsViewController.h"

@interface ContactDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *timezoneLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *contactIdLabel;

@end

@implementation ContactDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.selectedContact.name;
    [self prepareContact];
}

- (void)prepareContact {
    self.nameLabel.text = self.selectedContact.name;
    self.emailLabel.text = self.selectedContact.email;
    self.originLabel.text = self.selectedContact.origin;
    self.createdLabel.text = [NSDateFormatter localizedStringFromDate:self.selectedContact.createdOn dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    
    if (self.selectedContact.geolocation && self.selectedContact.geolocation.city && self.selectedContact.geolocation.city.length > 0) {
        self.cityLabel.text = self.selectedContact.geolocation.city;
    } else {
        self.cityLabel.text = @"n/a";
    }
    
    self.timezoneLabel.text = self.selectedContact.timeZone;
    self.contactIdLabel.text = self.selectedContact.contactId;
}

- (IBAction)deleteBtnTapped:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want to delete this contact?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (1 == buttonIndex) {
        [[GRApi sharedInstance] deleteContact:self.selectedContact completion:^(NSError *error) {
            if (!error) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showError:error.localizedDescription];
            }
        }];
    }
}

- (void)showError:(NSString *)errorString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
