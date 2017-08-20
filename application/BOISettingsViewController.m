/*
 *  BankBalanceViewController.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BOISettingsViewController.h"


@implementation BOISettingsViewController

@synthesize boiSettingsTableView;
@synthesize footerView;
@synthesize boiCustomer;


- (void)viewDidLoad {
	DebugLog(@"Entry");
    [super viewDidLoad];
	
	self.title = @"BOI Settings";
	
	boiSettingsTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, 320, 480) style: UITableViewStyleGrouped];
	boiSettingsTableView.scrollEnabled = NO;
	boiSettingsTableView.delegate = self;
	boiSettingsTableView.dataSource = self;
	
	UILabel *label1 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 15)] autorelease];
	label1.textAlignment = UITextAlignmentCenter;
	label1.backgroundColor = [UIColor clearColor];
	label1.textColor = [UIColor darkGrayColor];
	label1.font = [UIFont fontWithName:BOLD_FONT size:12.0];
	label1.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	label1.text = @"Please add all the details that have been";
	
	UILabel *label2 = [[[UILabel alloc] initWithFrame:CGRectMake(10, 265, 300, 15)] autorelease];
	label2.textAlignment = UITextAlignmentCenter;
	label2.backgroundColor = [UIColor clearColor];
	label2.textColor = [UIColor darkGrayColor];
	label2.font = [UIFont fontWithName:BOLD_FONT size:12.0];
	label2.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	label2.text = @"stored against your online bank account.";
	
	boiCustomer = [[BOICustomer alloc] init];
	[boiCustomer loadFromKeychain];
	
	[self.view addSubview:boiSettingsTableView];
	[self.view addSubview:label1];
	[self.view addSubview:label2];
	
	DebugLog(@"Exit");
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PreferenceEntryViewController *preferenceEntryViewController;
	
	switch (indexPath.row) {
		case 0: //LOGIN ID
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:6];
			preferenceEntryViewController.mode = BOILoginId;
			break;
		case 1: //PIN
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:6];
			preferenceEntryViewController.mode = BOIPin;
			break;
		case 2: //DATE OF BIRTH
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:8];
			preferenceEntryViewController.mode = BOIDateOfBirth;
			break;
		case 3: //CONTACT NUMBER
			preferenceEntryViewController = [[PreferenceEntryViewController alloc] initWithNumberOfEntryBoxes:4];
			preferenceEntryViewController.mode = BOIContactNumber;
			break;
		default:
			return;
			break;
	}
	
	preferenceEntryViewController.delegate = self;
	
	[self.navigationController pushViewController:preferenceEntryViewController animated:YES];
	[preferenceEntryViewController release];
	
	[self.boiSettingsTableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BOICell"];
	
	if (cell == nil) { cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BOICell"] autorelease]; }
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.detailTextLabel.textColor = [UIColor blueColor];
	cell.textLabel.textColor = [UIColor blackColor];
	cell.detailTextLabel.text = @"";
	
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"365 User Id";
			if ((self.boiCustomer.loginId!=nil) && ([self.boiCustomer.loginId length] == 6)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 1:
			cell.textLabel.text = @"PIN Number";
			if ((self.boiCustomer.pin!=nil) && ([self.boiCustomer.pin length] == 6)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 2:
			cell.textLabel.text = @"Date of Birth";
			if ((self.boiCustomer.dateOfBirth!=nil) && ([self.boiCustomer.dateOfBirth length] == 8)) { cell.detailTextLabel.text = @"Set"; }
			break;
		case 3:
			cell.textLabel.text = @"Contact Number";
			if ((self.boiCustomer.contactNumber!=nil) && ([self.boiCustomer.contactNumber length] == 4)) { cell.detailTextLabel.text = @"Set"; }
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
		self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44.0)];
		self.footerView.autoresizesSubviews = YES;
		self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.footerView.userInteractionEnabled = YES;
		self.footerView.hidden = NO;
		self.footerView.multipleTouchEnabled = NO;
		self.footerView.opaque = NO;
		self.footerView.contentMode = UIViewContentModeScaleToFill;
		
		UIImage *image = [UIImage imageNamed:@"RedButton.png"];
		
		//create the button
		UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(13, 10, 293, 44)];
		[button setBackgroundImage:image forState:UIControlStateNormal];
		
		//set title, font size and font color
		[button setTitle:@"Delete Account" forState:UIControlStateNormal];
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[button addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		
		[self.footerView addSubview:button];
		[button release];
	}
	return footerView;
}

#pragma mark -
#pragma mark Events

- (void)preferenceEntryViewControllerDidFinish:(PreferenceEntryViewController *)controller {
	DebugLog(@"Entry");
	DebugLog(@"Number entered for %@ is %@", controller.description, controller.numberCollected.text);
	
	if (controller.mode == BOILoginId) {
		self.boiCustomer.loginId = controller.numberCollected.text;
	} else if (controller.mode == BOIPin) {
		self.boiCustomer.pin = controller.numberCollected.text;
	} else if (controller.mode == BOIDateOfBirth) {
		self.boiCustomer.dateOfBirth = controller.numberCollected.text;
	} else if (controller.mode == BOIContactNumber) {
		self.boiCustomer.contactNumber = controller.numberCollected.text;
	}
	
	[self.boiCustomer saveToKeychain];
	[self.navigationController popViewControllerAnimated:YES];
	[self.boiSettingsTableView reloadData];
	DebugLog(@"Exit");
}

- (void)deleteButtonPressed:(id)selector {
	DebugLog(@"Entry");
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Deleting this account will remove your BOI settings and details completely from the Bank Balance application on your iPhone?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete Account" otherButtonTitles:nil];
	[actionSheet showInView:self.view];
	[actionSheet release];	
	DebugLog(@"Exit");
}

- (void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
	DebugLog(@"Entry");
	if (buttonIndex != [actionSheet cancelButtonIndex]) {
		DebugLog(@"Clearing BOI account from keychain");
		[self.boiCustomer removeFromKeychain];
		[self.boiCustomer clear];
		[self.boiSettingsTableView reloadData];
	}
	InfoLog(@"BOI Account Details Deleted.");
	DebugLog(@"Exit");
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark-
#pragma mark Cleanup

- (void)viewDidUnload {
    [super viewDidUnload];
	self.boiSettingsTableView=nil;
	self.footerView=nil;
}


- (void)dealloc {
	[boiSettingsTableView release];
	[footerView release];
	[boiCustomer release];
    [super dealloc];
}


@end
