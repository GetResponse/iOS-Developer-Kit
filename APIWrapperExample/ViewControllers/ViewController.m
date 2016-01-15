//
//  ViewController.m
//  APIWrapper
//
//  Copyright © 2016 GetResponse. All rights reserved.
//

#import "ViewController.h"
#import "ContactsTableViewController.h"
#import "GRApi.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *blendView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *campaignsArray;
@property (nonatomic, strong) GRCampaign *selectedCampaign;
@end

@implementation ViewController

#pragma mark - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning Paste your Developer API Key here
    NSString *DEVELOPER_API_KEY = @"";

    if (!DEVELOPER_API_KEY || DEVELOPER_API_KEY.length == 0) {
        self.blendView.hidden = NO;
        self.blendView.alpha = 1;
    } else {
        self.blendView.hidden = YES;
        self.blendView.alpha = 0;
        [[GRApi sharedInstance] setupWithApiKey:DEVELOPER_API_KEY];
        [[GRApi sharedInstance] setVerbose:YES];
        [self fetchCampaigns];
    }
}

#pragma mark - API Methods
- (void)fetchCampaigns {
    self.navigationItem.title = @"Loading campaigns...";
    [[GRApi sharedInstance] getCampaignsWithCompletion:^(NSArray *campaignsArray, NSError *error) {
        if (!error) {
            self.campaignsArray = campaignsArray;
            self.navigationItem.title = [NSString stringWithFormat:@"Campaigns (%li)",self.campaignsArray.count];
            [self.tableView reloadData];
        } else {
            [self showError:error.localizedDescription];
        }
    }];
}


#pragma mark - UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GRCampaign *campaign = [self.campaignsArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"campaignCell"forIndexPath:indexPath];
    cell.textLabel.text = campaign.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Campaign ID: %@",campaign.campaignId];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCampaign = [self.campaignsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showContactsVC" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.campaignsArray.count;
}

#pragma mark - Helpers
- (void)showError:(NSString *)errorString {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ContactsTableViewController *contactsVC = [segue destinationViewController];
    contactsVC.selectedCampaign = self.selectedCampaign;
}



@end
