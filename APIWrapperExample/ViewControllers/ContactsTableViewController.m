//
//  ContactsTableViewController.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactDetailsViewController.h"
#import "SearchContactViewController.h"
#import "AddContactViewController.h"

@interface ContactsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *campaignNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadContactsBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addContactBtn;
@property (strong, nonatomic) GRContact *selectedContact;


@property (strong, nonatomic) NSArray *contactsArray;
@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.campaignNameLabel.text = [NSString stringWithFormat:@"%@ (id: %@)",self.selectedCampaign.name, self.selectedCampaign.campaignId];
    self.navigationItem.title = self.selectedCampaign.name;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController == NO)
    {
        [self loadContacts];
    }
}

#pragma mark - Api Methods
- (void)loadContacts {
    [[GRApi sharedInstance] getContactsForCampaignName:self.selectedCampaign.name pageNumber:@1 completion:^(NSArray *contactsArray, NSNumber *totalPages, NSError *error) {
        if (!error) {
            self.contactsArray = contactsArray;
            self.addContactBtn.enabled = self.contactsArray.count > 0;
            [self.tableView reloadData];
        } else {
            [self showError:error.localizedDescription];
        }
    }];
}

#pragma mark - IBActions
- (IBAction)loadContactsBtnTapped:(id)sender {
    [self loadContacts];
}

- (IBAction)searchContactsBtnTapped:(id)sender {
    [self performSegueWithIdentifier:@"searchContactVC" sender:self];
}

- (IBAction)addContactBtnTapped:(id)sender {
    [self performSegueWithIdentifier:@"addContactVC" sender:self];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRContact *contact = [self.contactsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"forIndexPath:indexPath];
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = contact.email;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedContact = [self.contactsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showContactDetails" sender:self];
}

- (void)showError:(NSString *)errorString {
   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addContactVC"]) {
        AddContactViewController *addVC = [segue destinationViewController];
        addVC.selectedCampaign = self.selectedCampaign;
    } else if ([segue.identifier isEqualToString:@"searchContactVC"]) {
        SearchContactViewController *searchVC = [segue destinationViewController];
        searchVC.selectedCampaign = self.selectedCampaign;
    } else {
        ContactDetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.selectedContact = self.selectedContact;
    }
    
}

@end
