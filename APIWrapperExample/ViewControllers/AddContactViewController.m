//
//  AddContactViewController.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *contactNameField;
@property (weak, nonatomic) IBOutlet UITextField *contactEmailField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;
@property (strong, nonatomic) UITextField *activeTextField;
@end

@implementation AddContactViewController
#pragma mark - Main
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Add: %@", self.selectedCampaign.name];
}

#pragma mark - IBActions
- (IBAction)doneBtnTapped:(id)sender {
    if ([self canAddNewContact]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:@"Are you sure you want add this contact?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes!", nil];
        alert.tag = 101;
        [alert show];
    } else {
        [self showError:@"Email and name cannot be empty."];
    }
}

#pragma mark - API Methods
- (void)addContact {
    [[GRApi sharedInstance] addContactWithName:self.contactNameField.text email:self.contactEmailField.text inCampaign:self.selectedCampaign.name completion:^(NSError *error) {
        if (error) {
            [self showError:error.localizedDescription];
        } else {
            [self clearForm];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Contact Queued. It should appear on the contact list soon." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }
    }];
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self addContact];
    }
}

#pragma mark - Helpers
- (BOOL)canAddNewContact {
    if (self.contactEmailField.text.length > 0 && self.contactNameField.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)clearForm {
    [self.activeTextField resignFirstResponder];
    self.contactNameField.text = @"";
    self.contactEmailField.text = @"";
}

- (void)showError:(NSString *)errorString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
