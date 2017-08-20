/*
 *  SettingsViewControllerDelegate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "BankBalanceAppDelegate.h"
#import "SettingsViewController.h"
#import "AIBSettingsViewController.h"
#import "BOISettingsViewController.h"
#import "KeychainUtils.h"
#import "AIBCustomer.h"
#import	"BOICustomer.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize settingsTableView;
@synthesize pinSwitch;

#pragma mark-
#pragma mark View Setup


- (void)viewDidLoad {
	DebugLog(@"Entry");
    [super viewDidLoad];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishedWithSettingsView:)];	
	
	self.title = @"Settings";
	self.navigationItem.leftBarButtonItem = doneButton;
	
	//TABLE
	settingsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, 480) style: UITableViewStyleGrouped];
	settingsTableView.scrollEnabled = NO;
	settingsTableView.delegate = self;
	settingsTableView.dataSource = self;
	
	[self.view addSubview:settingsTableView];
	
	DebugLog(@"Exit");
}

- (void)viewWillAppear:(BOOL)animated {
	DebugLog(@"Entry");
	[self.settingsTableView reloadData];
	DebugLog(@"Exit");
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	if (indexPath.row == 0) {
		DebugLog(@"Pushing AIBSettingsViewController onto nav stack");
		AIBSettingsViewController *aibSettingsViewController = [[AIBSettingsViewController alloc] init];
		[self.navigationController pushViewController:aibSettingsViewController animated:YES];
		[aibSettingsViewController release];
	} else if (indexPath.row == 1) {
		DebugLog(@"Pushing BOISettingsViewController onto nav stack");
		BOISettingsViewController *boiSettingsViewController = [[BOISettingsViewController alloc] init];
		[self.navigationController pushViewController:boiSettingsViewController animated:YES];
		[boiSettingsViewController release];
	}
	[self.settingsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Bank Logon Details";
			break;
		case 1:
			return @"Preferences";
			break;
		default:
			return @"";
			break;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
			break;
		case 1:
			return 1;
			break;
		default:
			return 0;
			break;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;
	
	if (indexPath.section == 0) { //BANKS
		cell = [tableView dequeueReusableCellWithIdentifier:@"BankSelectionCell"];
		if (cell == nil) { cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BankSelectionCell"] autorelease]; }
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.detailTextLabel.textColor = [UIColor blueColor];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.detailTextLabel.text = @"";
		
		AIBCustomer *aibCustomer = [[AIBCustomer alloc] init];
		BOOL isAibConfigured = [aibCustomer isStoredInKeychain];
		[aibCustomer release];
		BOICustomer *boiCustomer = [[BOICustomer alloc] init];
		BOOL isBoiConfigured = [boiCustomer isStoredInKeychain];
		[boiCustomer release];
		
		switch (indexPath.row) {
			case 0: //AIB
				cell.textLabel.text = @"AIB";
				if (isAibConfigured) { cell.detailTextLabel.text = @"Set"; }
				break;
			case 1: //BOI
				cell.textLabel.text = @"BOI";
				if (isBoiConfigured) { cell.detailTextLabel.text = @"Set"; }
				break;
			default:
				break;
		}
	}
	else { //PREFERENCES
		cell = [tableView dequeueReusableCellWithIdentifier:@"PrefCell"];
		if (cell == nil) { cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrefCell"] autorelease]; }
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10.0, 15.0, 150.0, 15.0)] autorelease];
		label.text = @"PIN Protection";
		label.font = [UIFont fontWithName:BOLD_FONT size:17.0f];
		pinSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(190.0, 8.0, 300.0, 15.0)] autorelease];
		BOOL pinProtection = [BankBalance isAppPinSet];
		self.pinSwitch.on = pinProtection;
		[self.pinSwitch addTarget:self action:@selector(setPinProtection) forControlEvents:UIControlEventValueChanged];
		
		[cell.contentView addSubview:label];
		[cell.contentView addSubview:pinSwitch];
		
	}
	
	return cell;
}


#pragma mark -
#pragma mark Events

- (void) finishedWithSettingsView:(id) sender {
	DebugLog(@"Entry");
	[self.delegate settingsViewControllerDidFinish:self];
	DebugLog(@"Exit");
}

- (void) setPinProtection {
	DebugLog(@"Entry");
	BOOL pinProtection = self.pinSwitch.on;
	if (pinProtection) {
		//show setPIN & verifyPIN screens
		PinViewController *pinViewController = [[PinViewController alloc] init];
		pinViewController.delegate = self;
		pinViewController.mode = PINSetMode;
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinViewController];
		navController.navigationBar.barStyle = UIStatusBarStyleDefault;
		[self presentModalViewController:navController animated:YES];
		[pinViewController release];
		[navController release];
	} else {
		NSError *err;
		[KeychainUtils deleteSecureItemForKey:KC_APP_PIN andServiceName:KC_APP_PIN error:&err];
	}
	DebugLog(@"Exit");
}

- (void)pinViewControllerDidFinish:(PinViewController *)controller {
	DebugLog(@"Entry");
	if ((controller.pin != nil) && ([controller.pin length]==4)) {
		//set PIN into keychain
		NSError *err;
		[KeychainUtils storeKey:KC_APP_PIN andSecureValue:controller.pin forServiceName:KC_APP_PIN updateExisting:YES error:&err];
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:YES forKey:PREFS_PIN_PROTECTION];
	}
	
	[self dismissModalViewControllerAnimated:YES];
	[self.settingsTableView reloadData];
	DebugLog(@"Exit");
}


#pragma mark-
#pragma mark Cleanup

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.settingsTableView = nil;
	self.pinSwitch = nil;
}


- (void)dealloc {
	[super dealloc];
	//	[settingsTableView release];
	[pinSwitch release];
}


@end
