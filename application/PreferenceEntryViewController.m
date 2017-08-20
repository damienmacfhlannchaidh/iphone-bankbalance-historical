/*
 *  PreferenceEntryViewControllerDelegate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */


#import "PreferenceEntryViewController.h"

@implementation PreferenceEntryViewController

@synthesize delegate;
@synthesize numBoxes;
@synthesize entryBoxes;
@synthesize numberCollected;
@synthesize explanationLabel;
@synthesize descriptionLabel;
@synthesize descriptionLabel2;
@synthesize description;
@synthesize description2;
@synthesize numberOfDots;
@synthesize mode;

- (id) initWithNumberOfEntryBoxes:(NSInteger)numberOfBoxes {
	if (self = [super init]) {
		self.numBoxes = numberOfBoxes;
		self.entryBoxes = [[NSMutableArray alloc] initWithCapacity:numberOfBoxes];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
	
	UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonSystemItemStop  target:self action:@selector(clearEntry:)];	
	self.navigationItem.rightBarButtonItem = clearButton;
	
	if (mode == AIBRegistrationNumber) {
		self.description = @"Registration Number";
		self.description2 = @"(Full 8 digits)";
	} else if (mode == AIBPINNumber) {
		self.description = @"PAC Number";
		self.description2 = @"(Full 5 digits)";
	} else if (mode == AIBHomePhoneNumber) {
		self.description = @"Home Number";
		self.description2 = @"(Last 4 digits)";
	} else if (mode == AIBWorkPhoneNumber) {
		self.description = @"Work Number";
		self.description2 = @"(Last 4 digits)";
	} else if (mode == AIBVisaNumber) {
		self.description = @"Visa Card Number";
		self.description2 = @"(Last 4 digits)";
	} else if (mode == AIBMastercardNumber) {
		self.description = @"Mastercard Number";
		self.description2 = @"(Last 4 digits)";
	} else if (mode == BOILoginId) {
		self.description = @"365 User ID";
		self.description2 = @"(Full 6 digits)";
	} else if (mode == BOIPin) {
		self.description = @"PIN Number";
		self.description2 = @"(Full 6 digits)";
	} else if (mode == BOIDateOfBirth) {
		self.description = @"Date of Birth"; 
		self.description2 = @"(In DDMMYYYY format)";
	} else if (mode == BOIContactNumber) {
		self.description = @"Contact Number";
		self.description2 = @"(Last 4 digits)";
	}
	
	self.descriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 35, 320, 30)];
	self.descriptionLabel.text = self.description;
	self.descriptionLabel.textAlignment = UITextAlignmentCenter;
	self.descriptionLabel.backgroundColor = [UIColor clearColor];
	self.descriptionLabel.textColor = [UIColor blackColor]; 
	self.descriptionLabel.font = [UIFont fontWithName:BOLD_FONT size:18.0];
	self.descriptionLabel.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	
	self.descriptionLabel2 = [[UILabel alloc] initWithFrame: CGRectMake(0, 55, 320, 30)];
	self.descriptionLabel2.text = self.description2;
	self.descriptionLabel2.textAlignment = UITextAlignmentCenter;
	self.descriptionLabel2.backgroundColor = [UIColor clearColor];
	self.descriptionLabel2.textColor = [UIColor blackColor]; 
	self.descriptionLabel2.font = [UIFont fontWithName:BOLD_FONT size:12.0];
	self.descriptionLabel2.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
	
	
	//FORMULA: ((320-(40*numBoxes))/2)
	NSInteger freeSpaceCalculatedInPixels = ((320-(37*numBoxes))/2);
	for (NSInteger loop=0; loop<numBoxes; loop++) {
		UILabel *box;
		box = [[UILabel alloc] initWithFrame:CGRectMake(freeSpaceCalculatedInPixels, 90, 35, 35)];
		box.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"EntryBox.png"]];
		box.textAlignment = UITextAlignmentCenter;
		box.font = [UIFont fontWithName:BOLD_FONT size:36.0f];
		[entryBoxes addObject:box];
		[self.view addSubview:box];
		freeSpaceCalculatedInPixels+=37;
		[box release];
	}
	
	//HIDDEN numberCollected - UITextField
	self.numberCollected = [[UITextField alloc] init];
	self.numberCollected.hidden = YES;
	self.numberCollected.keyboardType = UIKeyboardTypeNumberPad;
	[self.numberCollected addTarget:self action:@selector(digitEndered:) forControlEvents:UIControlEventEditingChanged];
	[self.numberCollected becomeFirstResponder];
	[self.view addSubview:self.numberCollected];
	
	self.explanationLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, 140, 320, 30)];
	self.explanationLabel.text = @"";
	self.explanationLabel.textAlignment = UITextAlignmentCenter;
	self.explanationLabel.backgroundColor = [UIColor clearColor];
	self.explanationLabel.textColor = [UIColor blackColor]; 
	self.explanationLabel.font = [UIFont fontWithName:BOLD_FONT size:14.0];
	self.explanationLabel.text = [NSString stringWithFormat:@"Enter %@ digit %@ of %@", self.description, @"1" , [NSString stringWithFormat:@"%d", [self.entryBoxes count]]];
	
	[self.view addSubview:self.descriptionLabel];
	[self.view addSubview:self.descriptionLabel2];
	[self.view addSubview:self.explanationLabel];
	
	[descriptionLabel release];
	[explanationLabel release];
}


#pragma mark-
#pragma mark Events

- (void) digitEndered:(id) sender {
	DebugLog(@"Entry");
	NSInteger currentPos = [self.numberCollected.text length];

	if (currentPos<self.numberOfDots) {
		for (NSInteger loop=0; loop<[self.entryBoxes count]; loop++) {
			UILabel *box = [self.entryBoxes objectAtIndex:loop];
			box.text = BLANK_CHAR;
			self.explanationLabel.text = [NSString stringWithFormat:@"Enter %@ digit %@ of %@", self.description, @"1" , [NSString stringWithFormat:@"%d", [self.entryBoxes count]]];
		}
	}
	
	for (NSInteger loop=0; loop<currentPos; loop++) {
		UILabel *box = [self.entryBoxes objectAtIndex:loop];
		box.text = PIN_CHAR;
		numberOfDots++;
		if (!(loop+1 == [self.entryBoxes count])) {
			self.explanationLabel.text = [NSString stringWithFormat:@"Enter %@ digit %@ of %@", self.description, [NSString stringWithFormat:@"%d", loop+2] , [NSString stringWithFormat:@"%d", [self.entryBoxes count]]];
		} else {
			[self.delegate preferenceEntryViewControllerDidFinish:self];
		}
	}
	
	DebugLog(@"Exit");
}
- (void) clearEntry:(id) sender {
	DebugLog(@"Entry");
	numberCollected.text = @"";
	for (NSInteger loop=0; loop<[self.entryBoxes count]; loop++) {
		UILabel *box = [self.entryBoxes objectAtIndex:loop];
		box.text = BLANK_CHAR;
	}
	self.explanationLabel.text = [NSString stringWithFormat:@"Enter %@ digit %@ of %@", self.description, @"1" , [NSString stringWithFormat:@"%d", [self.entryBoxes count]]];
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
	[numberCollected release];
	[entryBoxes release];
}


@end
