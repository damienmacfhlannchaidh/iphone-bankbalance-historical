/*
 *  PinBoxesViewControllerDelegate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "PinBoxesViewController.h"


@implementation PinBoxesViewController

@synthesize delegate;
@synthesize explainText;
@synthesize pin1;
@synthesize pin2;
@synthesize pin3;
@synthesize pin4;
@synthesize pinCollected;
@synthesize message;
@synthesize incorrectPinTries;
@synthesize numberOfDots;
@synthesize mode;
@synthesize messageText;

- (id)initWithMode:(int)theMode {
	self.mode = theMode;
	return self;
}

- (void)viewDidLoad {
	DebugLog(@"Entry");
    [super viewDidLoad];
	if (self = [super init]) {
		self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
		self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];	
		self.navigationItem.rightBarButtonItem = cancelButton;
		[self.navigationItem setHidesBackButton:YES animated:NO];
		
		if (self.mode == PINSetMode) {
			self.title = @"Set PIN";
		} else if (self.mode == PINVerifySetMode) {
			self.title = @"Verify PIN";
		} else {
			self.title = @"Enter PIN";
		}
		
		// Message - UILabel
		explainText = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 320, 22)];
		if (self.mode == PINVerifySetMode) {
			explainText.text = @"Re-enter your passcode";
		} else {
			explainText.text = @"Enter your passcode";
		}
		explainText.textAlignment = UITextAlignmentCenter;
		explainText.opaque = NO;
		explainText.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
		explainText.font = [UIFont fontWithName:BOLD_FONT size:15.0f];
		explainText.shadowColor = [UIColor colorWithRed:57.0 green:57.0 blue:57.0 alpha:1.0];
		[self.view addSubview:explainText];
		
		//PIN1 - UILabel
		pin1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 61, 53)];
		pin1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PINBox.png"]];
		pin1.font = [UIFont fontWithName:BOLD_FONT size:36.0f];
		pin1.textAlignment = UITextAlignmentCenter;
		[self.view addSubview:pin1];
		
		//PIN2 - UILabel
		pin2 = [[UILabel alloc] initWithFrame:CGRectMake(91, 70, 61, 53)];
		pin2.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PINBox.png"]];
		pin2.font = [UIFont fontWithName:BOLD_FONT size:36.0f];
		pin2.textAlignment = UITextAlignmentCenter;
		[self.view addSubview:pin2];
		
		//PIN3 - UILabel
		pin3 = [[UILabel alloc] initWithFrame:CGRectMake(167, 70, 61, 53)];
		pin3.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PINBox.png"]];
		pin3.font = [UIFont fontWithName:BOLD_FONT size:36.0f];
		pin3.textAlignment = UITextAlignmentCenter;
		[self.view addSubview:pin3];
		
		//PIN4 - UILabel
		pin4 = [[UILabel alloc] initWithFrame:CGRectMake(243, 70, 61, 53)];
		pin4.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"PINBox.png"]];
		pin4.font = [UIFont fontWithName:BOLD_FONT size:36.0f];
		pin4.textAlignment = UITextAlignmentCenter;
		[self.view addSubview:pin4];
		
		//HIDDEN PinCollected - UITextField
		pinCollected = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		pinCollected.hidden = YES;
		pinCollected.keyboardType = UIKeyboardTypeNumberPad;
		[self.view addSubview:pinCollected];
		
		//MESSAGE
		message = [[UILabel alloc] initWithFrame:CGRectMake(0, 140, 320, 30)];
		message.backgroundColor = [UIColor redColor];
		if ((self.messageText != nil) && ([self.messageText length]>0)) {
			message.hidden = NO;
			message.text = self.messageText;
		} else {
			message.hidden = YES;
		}
		message.textAlignment = UITextAlignmentCenter;
		message.font = [UIFont fontWithName:BOLD_FONT size:13.0f];
		message.textColor = [UIColor whiteColor];
		[self.view addSubview:message];
		
		if (mode == PINCheckMode) {
			[self readIncorrectPinTries];
			if (self.incorrectPinTries > 0) {
				message.hidden = NO;
				if (self.incorrectPinTries == 1) {
					self.message.text = [NSString stringWithFormat:@"%@ Failed Passcode Attempt", [[NSNumber numberWithInt:self.incorrectPinTries] stringValue]];
				} else {
					self.message.text  = [NSString stringWithFormat:@"%@ Failed Passcode Attempts", [[NSNumber numberWithInt:self.incorrectPinTries] stringValue]];
				}
			}
		}
		
		[self.pinCollected addTarget:self action:@selector(pinDigitEntered:) forControlEvents:UIControlEventEditingChanged];		
		[self.pinCollected becomeFirstResponder];
	}
	DebugLog(@"Exit");
}

#pragma mark-
#pragma mark Events

- (void)cancelButtonPressed:(id) sender {
	DebugLog(@"Entry");
	self.pinCollected = nil;
	[self.delegate pinBoxesViewControllerDidCancel:self];
	DebugLog(@"Exit");
}

- (void)readIncorrectPinTries {
	DebugLog(@"Entry");
	NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *pinTriesFile = [cachesDirectory stringByAppendingPathComponent:PIN_TRIES_FILENAME];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pinTriesFile];
	
	if (!fileExists) {
		DebugLog(@"No pin tries count file exists, count = 0");
		self.incorrectPinTries = 0;
	} else {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pinTriesFile];
		self.incorrectPinTries = [[dict valueForKey:PIN_COUNT] integerValue];
		DebugLog(@"Pin tries count file exists, count = %@", [[NSNumber numberWithInt:self.incorrectPinTries] stringValue]);
		[dict release];
	}
	DebugLog(@"Exit");
}

- (void)pinDigitEntered:(id)sender {
	DebugLog(@"Entry");
	NSInteger currentPos = [self.pinCollected.text length];
	
	if (currentPos<self.numberOfDots) {
		self.pin1.text = BLANK_CHAR;
		self.pin2.text = BLANK_CHAR;
		self.pin3.text = BLANK_CHAR;
		self.pin4.text = BLANK_CHAR; 
	}
	
	if ([self.pinCollected.text length] == 1) {
		self.pin1.text = PIN_CHAR;
		self.numberOfDots=1;
	} else	if ([self.pinCollected.text length] == 2) {
		self.pin1.text = PIN_CHAR;
		self.pin2.text = PIN_CHAR;
		self.numberOfDots=2;
	} else if ([self.pinCollected.text length] == 3) {
		self.pin1.text = PIN_CHAR;
		self.pin2.text = PIN_CHAR;
		self.pin3.text = PIN_CHAR;
		self.numberOfDots=3;
	} else if ([self.pinCollected.text length] == 4) {
		self.pin1.text = PIN_CHAR;
		self.pin2.text = PIN_CHAR;
		self.pin3.text = PIN_CHAR;
		self.pin4.text = PIN_CHAR;
		self.numberOfDots=4;
		[self performSelector:@selector(clearStars) withObject:nil afterDelay:0.2f];
	}
	DebugLog(@"Exit");
}

- (void)clearStars{
	self.pin1.text = BLANK_CHAR;
	self.pin2.text = BLANK_CHAR;
	self.pin3.text = BLANK_CHAR;
	self.pin4.text = BLANK_CHAR; 
	[self.delegate pinBoxesViewControllerDidFinish:self];
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
	[explainText release];
	[pin1 release];
	[pin2 release];
	[pin3 release];
	[pin4 release];
	[message release];
	[pinCollected release];
	[super dealloc];
}


@end
