/*
 *  AIBSettingsViewController.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "AIBSettingsViewController.h"


@implementation AIBSettingsViewController

@synthesize aibSettingsTableView;
@synthesize aibCustomer;

- (void)viewDidLoad {
	DebugLog(@"Entry");
    [super viewDidLoad];
	
	self.title = @"AIB Settings";
	
	aibSettingsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, 480) style: UITableViewStyleGrouped];
	aibSettingsTableView.scrollEnabled = NO;
	aibSettingsTableView.delegate = self;
	aibSettingsTableView.dataSource = self;
	
	UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 340, 300, 15)] autorelease];
	label1.textAlignment = UITextAlignmentCenter;
	label1.backgroundColor = [UIColor clearColor];
	label1.textColor = [UIColor darkGrayColor];
	label1.font = [UIFont fontWithName:BOLD_FONT size:12.0];
	label1.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	label1.text = @"Please add all the details that have been";
	
	UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 355, 300, 15)] autorelease];
	label2.textAlignment = UITextAlignmentCenter;
	label2.backgroundColor = [UIColor clearColor];
	label2.textColor = [UIColor darkGrayColor];
	label2.font = [UIFont fontWithName:BOLD_FONT size:12.0];
	label2.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	label2.text = @"stored against your online bank account.";
	
	aibCustomer = [[AIBCustomer alloc] init];
	[aibCustomer loadFromKeychain];
	
	[self.view addSubview:aibSettingsTableView];
	[self.view addSubview:label1];
	[self.view addSubview:label2];
	
	DebugLog(@"Exit");
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PreferenceEntryViewController *preferenceEntryViewController;
	
	switch (indexPath.row) {
		case 0: //REG NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:8];
			preferenceEntryViewController.mode = AIBRegistrationNumber;
			break;
		case 1: //PAC NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:5];
			preferenceEntryViewController.mode = AIBPINNumber;
			break;
		case 2: //HOME NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:4];
			preferenceEntryViewController.mode = AIBHomePhoneNumber;
			break;
		case 3: //WORK NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:4];
			preferenceEntryViewController.mode = AIBWorkPhoneNumber;
			break;
		case 4: //VISA NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:4];
			preferenceEntryViewController.mode = AIBVisaNumber;
			break;
		case 5: //MASTERCARD NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:4];
			preferenceEntryViewController.mode = AIBMastercardNumber;
			break;
		default:
			return;
			break;
	}
	
	preferenceEntryViewController.delegate = self;
	
	[self.navigationController pushViewController:preferenceEntryViewController animated:YES];
	[preferenceEntryViewController release];
	
	[self.aibSettingsTableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AIBCell"];
	
	if (cell == nil) { cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AIBCell"] autorelease]; }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.detailTextLabel.textColor = [UIColor blueColor];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.text = @"";
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Registration Number";
			if ((self.aibCustomer.registrationNumber!=nil) && ([self.aibCustomer.registrationNumber length] == 8)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 1:
			cell.textLabel.text = @"PAC Number";
			if ((self.aibCustomer.pac!=nil) && ([self.aibCustomer.pac length] == 5)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 2:
			cell.textLabel.text = @"Home Phone Number";
			if ((self.aibCustomer.homePhoneNumber!=nil) && ([self.aibCustomer.homePhoneNumber length] == 4)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 3:
			cell.textLabel.text = @"Work Phone Number";
			if ((self.aibCustomer.workPhoneNumber!=nil) && ([self.aibCustomer.workPhoneNumber length] == 4)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 4:
			cell.textLabel.text = @"Visa Number";
			if ((self.aibCustomer.visaCardNumber!=nil) && ([self.aibCustomer.visaCardNumber length] == 4)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 5:
			cell.textLabel.text = @"Mastercard Number";
			if ((self.aibCustomer.mastercardCardNumber!=nil) && ([self.aibCustomer.mastercardCardNumber length] == 4)) { cell.detailTextLabel.text = @"Set"; }
			break;
		default:
			cell.textLabel.text = @"";
			cell.detailTextLabel.text = @"";
			break;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection: (NSInteger) section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection: (NSInteger)section {
	if (footerView == nil) {
		DebugLog(@"Drawing 'Delete Account' button");
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
		footerView.autoresizesSubviews = YES;
		footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		footerView.userInteractionEnabled = YES;
		footerView.hidden = NO;
		footerView.multipleTouchEnabled = NO;
		footerView.opaque = NO;
		footerView.contentMode = UIViewContentModeScaleToFill;
		
		UIImage *image = [UIImage imageNamed:@"RedButton.png"];
		
		//create the button
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(13, 10, 293, 44)];
		[button setBackgroundImage:image forState:UIControlStateNormal];
		
		//set title, font size and font color
		[button setTitle:@"Delete Account" forState:UIControlStateNormal];
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[button addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[footerView addSubview:button];
		[button release];
	}
	return footerView;
}

#pragma mark -
#pragma mark Events

- (void)preferenceEntryViewControllerDidFinish:(PreferenceEntryViewController *)controller {
	DebugLog(@"Entry");
	DebugLog(@"Number entered for %@ is %@", controller.description, controller.numberCollected.text);
	
	if (controller.mode == AIBRegistrationNumber) {
		self.aibCustomer.registrationNumber = controller.numberCollected.text;
	} else if (controller.mode == AIBPINNumber) {
		self.aibCustomer.pac = controller.numberCollected.text;
	} else if (controller.mode == AIBHomePhoneNumber) {
		self.aibCustomer.homePhoneNumber = controller.numberCollected.text;
	} else if (controller.mode == AIBWorkPhoneNumber) {
		self.aibCustomer.workPhoneNumber = controller.numberCollected.text;
	} else if (controller.mode == AIBVisaNumber) {
		self.aibCustomer.visaCardNumber = controller.numberCollected.text;
	} else if (controller.mode == AIBMastercardNumber) {
		self.aibCustomer.mastercardCardNumber = controller.numberCollected.text;
	}
	
	[self.aibCustomer saveToKeychain];
	[self.navigationController popViewControllerAnimated:YES];
	[self.aibSettingsTableView reloadData];
	DebugLog(@"Exit");
}

- (void)deleteButtonPressed:(id)selector {
	DebugLog(@"Entry");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Deleting this account will remove your AIB settings and details completely from the Bank Balance application on your iPhone?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Account" otherButtonTitles:nil];
	
	[actionSheet showInView:self.view];
	[actionSheet release];	
	DebugLog(@"Exit");
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DebugLog(@"Entry");
	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		DebugLog(@"Clearing AIB account from keychain");
		[self.aibCustomer removeFromKeychain];
		[self.aibCustomer clear];
		[self.aibSettingsTableView reloadData];
	}
	InfoLog(@"AIB Account Details Deleted.");
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
}


- (void)dealloc {
	[super dealloc];
	[aibSettingsTableView release];
	[footerView release];
	
}


@end
