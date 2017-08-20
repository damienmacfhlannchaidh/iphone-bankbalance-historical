/*
 *  PinViewControllerDelegate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <AudioToolbox/AudioToolbox.h>

#import "PinViewController.h"


@implementation PinViewController

@synthesize delegate;
@synthesize mode;
@synthesize pin;
@synthesize pinMemory;
@synthesize message;
@synthesize pinBoxesViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:BACKGROUND_IMAGE]];
	
	if (mode == PINCheckMode) {
		DebugLog(@"PINCheckMode");
		self.title = @"Enter PIN";
		[self.navigationItem setHidesBackButton:YES animated:NO];
	} else {
		DebugLog(@"PINSetMode");
		self.title = @"Set PIN";
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];	
		self.navigationItem.rightBarButtonItem = cancelButton;
	}
	
	self.pinBoxesViewController = [[PinBoxesViewController alloc] initWithMode:mode];
	self.pinBoxesViewController.delegate = self;
	if ((self.message!=nil) && ([self.message length]>0)) {
		self.pinBoxesViewController.messageText = self.message;
	}
	[self.view addSubview:self.pinBoxesViewController.view];
}


#pragma mark -
#pragma mark Events

- (void)pinBoxesViewControllerDidFinish:(PinBoxesViewController *)controller {
	DebugLog(@"Entry");
	
	if (controller.mode == PINVerifySetMode) {
		DebugLog(@"Pin collected=%@, Pin memory=%@", controller.pinCollected.text, self.pinMemory);
		if ([pinMemory isEqualToString:controller.pinCollected.text]) {
			DebugLog(@"PIN is verified");
			self.pin = controller.pinCollected.text;
			[self.delegate pinViewControllerDidFinish:self];
		} else {
			DebugLog(@"PIN is NOT verified");
			PinBoxesViewController *pbViewController = [[PinBoxesViewController alloc] initWithMode:PINVerifySetMode];
			pbViewController.delegate = self;
			pbViewController.mode = PINSetMode;
			pbViewController.messageText = @"Passcodes did not match. Try again.";
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
			[self.navigationController pushViewController:pbViewController animated:YES];
			[pbViewController release];
		}
	} else if (controller.mode == PINSetMode) {
		DebugLog(@"Pin collected=%@", controller.pinCollected.text);
		self.pinMemory=controller.pinCollected.text;
		PinBoxesViewController *pbViewController = [[PinBoxesViewController alloc] initWithMode:PINVerifySetMode];
		pbViewController.delegate = self;
		pbViewController.mode = PINVerifySetMode;
		[self.navigationController pushViewController:pbViewController animated:YES];
		[pbViewController release];
	} else if (controller.mode == PINCheckMode) {
		DebugLog(@"PINCheckMode");
		self.pin = controller.pinCollected.text;
		[self.delegate pinViewControllerDidFinish:self];
	}
	DebugLog(@"Exit");
}

- (void)pinBoxesViewControllerDidCancel:(PinBoxesViewController *)controller {
	DebugLog(@"Entry");
	DebugLog(@"Set PIN was cancelled (at verify PIN stage).");
	self.pin = nil;
	[self.delegate pinViewControllerDidFinish:self];
	DebugLog(@"Exit");
}

- (void)cancelButtonPressed:(id) sender {
	DebugLog(@"Entry");
	self.pin = nil;
	[self.delegate pinViewControllerDidFinish:self];
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
	self.pinBoxesViewController=nil;
}


- (void)dealloc {
	[pinBoxesViewController release];
	[pin release];
	[pinMemory release];
	[message release];
    [super dealloc];
	
}


@end
