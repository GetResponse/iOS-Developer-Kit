//
//  SearchContactViewController.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "SearchContactViewController.h"
#import "ContactDetailsViewController.h"

@interface SearchContactViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchContactBtn;
@property (weak, nonatomic) IBOutlet UITextField *contactEmailField;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;

@property (strong,nonatomic) GRContact *searchedContact;

@end

@implementation SearchContactViewController

#pragma mark - Main
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.informationLabel.hidden = YES;
}

#pragma mark - API Methods
- (void)searchContact {
    [[GRApi sharedInstance] getContactByEmail:self.contactEmailField.text inCampaign:self.selectedCampaign.name completion:^(GRContact *contact, NSError *error) {
        if (!error) {
            self.informationLabel.text = [NSString stringWithFormat:@"Contact '%@' Found!", contact.name];
            self.informationLabel.hidden = NO;
            self.searchedContact = contact;
            [self performSegueWithIdentifier:@"showContact" sender:self];
        } else {
            self.informationLabel.text = error.localizedDescription;
            self.informationLabel.hidden = NO;
        }
    }];
}

#pragma mark - IBActions
- (IBAction)searchContactBtnTapped:(id)sender {
    self.informationLabel.hidden = NO;
    self.informationLabel.text = @"Searching for contact...";
    [self searchContact];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.searchContactBtn.enabled = textField.text.length > 0;
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ContactDetailsViewController *detailsVC = [segue destinationViewController];
    detailsVC.selectedContact = self.searchedContact;
}

@end
