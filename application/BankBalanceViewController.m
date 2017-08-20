/*
 *  BankBalanceViewController.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "Reachability.h"
#import "Account.h"
#import "BankBalanceViewController.h"
#import "SettingsViewController.h"
#import "AIBWorkflow.h"
#import "AIBParser.h"
#import "BOIWorkflow.h"
#import "BOIParser.h"

@implementation BankBalanceViewController

@synthesize accountsListTableView;
@synthesize toolBar;
@synthesize progressBarView;
@synthesize aibAccountsList;
@synthesize boiAccountsList;
@synthesize queue;
@synthesize backgroundDataLoadOperation;
@synthesize aibCustomer;
@synthesize boiCustomer;
@synthesize aibWorkflowErrorDetected;
@synthesize boiWorkflowErrorDetected;

#pragma mark-
#pragma mark View Setup

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	DebugLog(@"Entry");
	
	UIView *lView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	[self.navigationItem setHidesBackButton:YES animated:NO];
	
	// ACCOUNT TABLE
	if (accountsListTableView == nil) {
		accountsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, lView.bounds.size.width, lView.bounds.size.height-45)];
		[accountsListTableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
		accountsListTableView.backgroundColor = [UIColor whiteColor];
		accountsListTableView.showsVerticalScrollIndicator = NO;
		accountsListTableView.showsHorizontalScrollIndicator = NO;
		accountsListTableView.scrollEnabled = YES;
	}
	
	// TOOLBAR
	if (toolBar == nil) {
		toolBar = [[UIToolbar alloc] init];
	}
	toolBar.barStyle = UIBarStyleDefault;
	[toolBar sizeToFit];
	
	CGFloat toolbarHeight = [toolBar frame].size.height; //Caclulate the height of the toolbar
	CGRect rootViewBounds = accountsListTableView.bounds; //Get the bounds of the parent view 
	CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds); //Get the height of the parent view. 
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds); //Get the width of the parent view, 
	CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight); //Create a rectangle for the toolbar 
	[toolBar setFrame:rectArea]; //Reposition and resize the receiver
	
	//PROGRESS BAR
	self.progressBarView = [[ProgressBarView alloc] initWithFrame:toolBar.frame];
	progressBarView.opaque = NO;
	progressBarView.progressBar.hidden=YES;
	
	// TOOLBAR BUTTONS
	UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
	
	/*UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	 [refreshButton addTarget:self action:@selector(refreshButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	 UIBarButtonItem *refreshBarButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];*/
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *flexSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIBarButtonItem *progressBarViewButton = [[UIBarButtonItem alloc] initWithCustomView:self.progressBarView];
	
	UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
 	[toolBar setItems:[NSArray arrayWithObjects:/*refreshBarButton,*/ flexSpaceBarButton, progressBarViewButton,flexSpaceBarButton, infoBarButton, nil]];
	
	
	// VIEW
	[lView addSubview:accountsListTableView];
	[lView addSubview:toolBar];
	
	[toolBar release];
	[flexSpaceBarButton release];
	[infoBarButton release];
	[refreshBarButton release];
	[progressBarViewButton release];
	
	self.view = lView;
	[lView release];
	
	DebugLog(@"Exit");
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (self.queue == nil) {
		queue = [[NSOperationQueue alloc] init];
	}
	
	aibCustomer = [[AIBCustomer alloc] init];
	[aibCustomer loadFromKeychain];
	
	boiCustomer = [[BOICustomer alloc] init];
	[boiCustomer loadFromKeychain];
	
	self.accountsListTableView.delegate = self;
	self.accountsListTableView.dataSource = self;
	self.aibAccountsList = [[NSMutableArray alloc] init];
	self.boiAccountsList = [[NSMutableArray alloc] init];
	
	if (DEMO_MODE) {
		InfoLog(@"DEMO MODE");
		[self getDemoBankBalances];
	} else if (![aibCustomer isStoredInKeychain] && ![boiCustomer isStoredInKeychain]) {
		[self performSelector:@selector(infoButtonPressed:) withObject:nil afterDelay:1.0];
	} else {
		[self getBankBalances];
	}
}


#pragma mark-
#pragma mark Background Account Loading

- (void) performBackgroundDataLoadWorkflow {
	DebugLog(@"Entry");
	
	self.aibWorkflowErrorDetected=NO;
	self.boiWorkflowErrorDetected=NO;
	self.progressBarView.label.text = BLANK_CHAR;
	self.progressBarView.progressBar.hidden=YES;
	
	// if AIB is configured
	if ([aibCustomer isStoredInKeychain]) {
		[self showProgressBar];
		[self performAIBWorkflow];
		[self.accountsListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
	}
	
	// if BOI is configured
	if ([boiCustomer isStoredInKeychain]) {
		[self showProgressBar];
		[self performBOIWorkflow];
		[self.accountsListTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES]; 
	}
	
	if (self.aibWorkflowErrorDetected==NO && self.boiWorkflowErrorDetected==NO) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"dd/MM/yy"];
		
		NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
		[timeFormat setDateFormat:@"HH:mm"];
		
		NSDate *now = [NSDate date];
		self.progressBarView.label.text = [NSString stringWithFormat:@"Balances updated: %@ %@", [dateFormat stringFromDate:now], [timeFormat stringFromDate:now]];
		
		[dateFormat release];
		[timeFormat release];
	}
	
	self.progressBarView.progressBar.hidden=YES;
	DebugLog(@"Exit");
}

- (void) performBOIWorkflow {
	DebugLog(@"Entry");
	self.progressBarView.progressBar.hidden=NO;
	ProgressBarUpdate *progressBarUpdate = [[ProgressBarUpdate alloc] init];
	
	if (![BankBalance checkForInternetConnection]) {
		[progressBarUpdate release];
		self.boiWorkflowErrorDetected=YES;
		return;
	}
	
	BOIWorkflow *boiWorkflow = [[BOIWorkflow alloc] init];
	
	//BOI WORKFLOW
	//STEP 1
	progressBarUpdate.message = @"Connecting to BOI";
	progressBarUpdate.progressPercentage = 0;
	[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
	
	[boiWorkflow performStep1];
	
	//BOI WORKFLOW
	//STEP 2
	progressBarUpdate.message = @"Sending credentials to BOI";
	progressBarUpdate.progressPercentage = 33;
	[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
	
	[boiWorkflow performStep2:boiCustomer];
	
	//BOI WORKFLOW
	//STEP 3
	if (!boiWorkflow.errorDetected) {
		progressBarUpdate.message = @"Retrieving account balances from BOI";
		progressBarUpdate.progressPercentage = 66;
		[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
		
		NSArray *accounts = [boiWorkflow performStep3:boiCustomer];
		if ((accounts!=nil) && ([accounts count]>0)) {
			[self.boiAccountsList removeAllObjects];
			[self.boiAccountsList addObjectsFromArray:accounts];
		}
		
		if (!boiWorkflow.errorDetected) {
			
			if ([self.boiAccountsList count]==0) {
				progressBarUpdate.message = @"Latest balances unavailable from BOI";
				self.boiWorkflowErrorDetected=YES;
			} else {
				progressBarUpdate.message = @"Latest balances retrieved from BOI";
			}
			progressBarUpdate.progressPercentage = 100;
			[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
		} else {
			[self hideProgressBar];
			self.boiWorkflowErrorDetected=YES;	
		}
	} else {
		[self hideProgressBar];
		self.boiWorkflowErrorDetected=YES;
	}
	
	[progressBarUpdate release];
	[boiWorkflow release];
	DebugLog(@"Exit");
}

- (void) performAIBWorkflow {
	DebugLog(@"Entry");
	self.progressBarView.progressBar.hidden=NO;
	ProgressBarUpdate *progressBarUpdate = [[ProgressBarUpdate alloc] init];
	
	if (![BankBalance checkForInternetConnection]) {
		[progressBarUpdate release];
		self.aibWorkflowErrorDetected=YES;
		return;
	}
	
	//AIB WORKFLOW	
	//STEP 1
	progressBarUpdate.message = @"Connecting to AIB";
	progressBarUpdate.progressPercentage = 0;
	[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
	
	AIBWorkflow *aibWorkflow = [[AIBWorkflow alloc] init];
	
	[aibWorkflow performStep1];
	
	//AIB WORKFLOW
	//STEP2
	progressBarUpdate.message = @"Sending credentials to AIB";
	progressBarUpdate.progressPercentage = 33;
	[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
	[aibWorkflow performStep2:aibCustomer];
	
	//AIB WORKFLOW
	//STEP3
	if (!aibWorkflow.errorDetected) {
		progressBarUpdate.message = @"Retrieving account balances from AIB";
		progressBarUpdate.progressPercentage = 66;
		[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
		
		NSArray	*accounts = [aibWorkflow performStep3:aibCustomer];
		if (!aibWorkflow.errorDetected) {
			if ((accounts!=nil) && ([accounts count]>0)) {
				[self.aibAccountsList removeAllObjects];
				[self.aibAccountsList addObjectsFromArray:accounts];
			}
			
			if ([self.aibAccountsList count]==0) {
				progressBarUpdate.message = @"Latest balances unavailable from AIB";
				self.aibWorkflowErrorDetected=YES;
			} else {
				progressBarUpdate.message = @"Latest balances retrieved from AIB";
			}
			progressBarUpdate.progressPercentage = 100;
			[self performSelectorOnMainThread:@selector(updateProgressBar:) withObject:progressBarUpdate waitUntilDone:YES];
		} else {
			[self hideProgressBar];
			self.aibWorkflowErrorDetected=YES;
		}
	} else {
		[self hideProgressBar];
		self.aibWorkflowErrorDetected=YES;
	}
	
	[progressBarUpdate release];
	[aibWorkflow release];
	DebugLog(@"Exit");
}

#pragma mark-
#pragma mark Progress Bar Events

- (void)updateProgressBar:(ProgressBarUpdate *)progressBarUpdate {
	DebugLog(@"Entry");
	self.progressBarView.label.text = progressBarUpdate.message;
	self.progressBarView.progressBar.progress = [progressBarUpdate getProgressPercentageAsFloat];
	DebugLog(@"Exit");
}

- (void)showProgressBar {
	DebugLog(@"Entry");
	self.progressBarView.label.hidden=NO;
	self.progressBarView.progressBar.hidden=NO;
	DebugLog(@"Exit");
}

- (void)hideProgressBar {
	DebugLog(@"Entry");
	self.progressBarView.label.text = @"";
	self.progressBarView.label.hidden=YES;
	self.progressBarView.progressBar.progress=0;
	self.progressBarView.progressBar.hidden=YES;
	DebugLog(@"Exit");
}

#pragma mark-
#pragma mark Events

- (void) getBankBalances {
	DebugLog(@"Entry");	
	backgroundDataLoadOperation = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(performBackgroundDataLoadWorkflow) object:nil] autorelease];
	[self.queue addOperation:backgroundDataLoadOperation];	
	DebugLog(@"Exit");
}

- (void)getDemoBankBalances {
	DebugLog(@"Entry");
	Account *account1 = [[Account alloc] init];
	account1.bank = AIB;
	account1.name = @"CURRENT-018";
	account1.balance = @"250.00";
	
	Account *account2 = [[Account alloc] init];
	account2.bank = AIB;
	account2.name = @"MORTGAGE-022";
	account2.balance = @"5,171,863.99 DR";
	
	Account *account3 = [[Account alloc] init];
	account3.bank = AIB;
	account3.name = @"SAVINGS-019";
	account3.balance = @"2593.47";
	
	Account *account4 = [[Account alloc] init];
	account4.bank = BOI;
	account4.name = @"LOAN-1";
	account4.balance = @"-2500.37";
	
	Account *account5 = [[Account alloc] init];
	account5.bank = BOI;
	account5.name = @"JOINT-2";
	account5.balance = @"99.13";
	
	[self.aibAccountsList addObject:account1];
	[self.aibAccountsList addObject:account2];
	[self.aibAccountsList addObject:account3];
	[self.boiAccountsList addObject:account4];
	[self.boiAccountsList addObject:account5];
	
	[account1 release];
	[account2 release];
	[account3 release];
	[account4 release];
	[account5 release];
	DebugLog(@"Exit");
}

- (void) refreshButtonPressed:(id) sender {
	DebugLog(@"Entry");
	[self showProgressBar];
	[self getBankBalances];
	DebugLog(@"Exit");
}

- (void) infoButtonPressed:(id) sender {
	DebugLog(@"Entry");	
	[self hideProgressBar];
	SettingsViewController *settingsViewController =[[SettingsViewController alloc] init];
	settingsViewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	navController.navigationBar.barStyle = UIStatusBarStyleDefault;
	
	navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
	[settingsViewController release];
	DebugLog(@"Exit");
}

- (void) settingsViewControllerDidFinish:(SettingsViewController *) controller {
	DebugLog(@"Entry");
	[self.aibAccountsList removeAllObjects];
	[self.boiAccountsList removeAllObjects];
	[self.accountsListTableView reloadData];
	[self getBankBalances];
	[aibCustomer loadFromKeychain];
	[boiCustomer loadFromKeychain];
	[self dismissModalViewControllerAnimated:YES];
	DebugLog(@"Exit");
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0) {
		return [self.aibAccountsList count];
	} else if (section==1) {
		return [self.boiAccountsList count];
	} else {
		return 0;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section==0) {
		if ([self.aibAccountsList count]>0) {
			return @"AIB Accounts";
		}
	} else if (section==1) {
		if ([self.boiAccountsList count]>0) {
			return @"BOI Accounts";
		}
	} 
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountListCell"];
	if (cell == nil) { cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AccountListCell"] autorelease]; 
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if (indexPath.section == 0) { //AIB
		Account *account = [self.aibAccountsList objectAtIndex:[indexPath row]];
		
		cell.textLabel.font = [UIFont fontWithName:STANDARD_FONT size:15.0f];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = [account.name uppercaseString];
		
		cell.detailTextLabel.font = [UIFont fontWithName:BOLD_FONT size:20.0f];
		if ([AIBParser stringIsCreditBalance:[account formattedBalance]]) {
			cell.detailTextLabel.textColor = [UIColor greenColor];
		} else {
			cell.detailTextLabel.textColor = [UIColor redColor];
		}
		cell.detailTextLabel.text = [account formattedBalance];
	} else if (indexPath.section == 1) { //BOI
		Account *account = [self.boiAccountsList objectAtIndex:[indexPath row]];
		
		cell.textLabel.font = [UIFont fontWithName:STANDARD_FONT size:15.0f];
		cell.textLabel.textColor = [UIColor blackColor];
		cell.textLabel.text = [account.name uppercaseString];
		
		cell.detailTextLabel.font = [UIFont fontWithName:BOLD_FONT size:20.0f];
		if ([BOIParser stringIsCreditBalance:[account formattedBalance]]) {
			cell.detailTextLabel.textColor = [UIColor greenColor];
		} else {
			cell.detailTextLabel.textColor = [UIColor redColor];
		}
		cell.detailTextLabel.text = [account formattedBalance];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
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
	[accountsListTableView release];
	[progressBarView release];
	[aibCustomer release];
	[boiCustomer release];
	[queue release];
	[backgroundDataLoadOperation release];
	[super dealloc];
}


@end
