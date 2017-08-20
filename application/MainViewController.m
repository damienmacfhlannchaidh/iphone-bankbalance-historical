/*
 *  MainViewController.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */


#import <AudioToolbox/AudioToolbox.h>

#import "BankBalance.h"
#import "MainViewController.h"
#import "BankBalanceViewController.h"
#import "KeychainUtils.h"

@implementation MainViewController

@synthesize isAppPinSet;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.isAppPinSet = [BankBalance isAppPinSet];

	if (isAppPinSet) {
		[self displayPinView];
	} else {
		[self displayBankBalanceView];
	}
}

- (void) displayPinView {
	PinViewController *pinViewController = [[PinViewController alloc] init];
	pinViewController.delegate=self;
	pinViewController.mode=PINCheckMode;
	
	NSInteger incorrectPinTries = [self getIncorrectPinTries];
	if (incorrectPinTries>0) {
		pinViewController.message = [NSString stringWithFormat:@"%@ Failed Passcode Attempts", [[NSNumber numberWithInt:incorrectPinTries] stringValue]];
	}
	
	[self.navigationController pushViewController:pinViewController animated:NO];
	[pinViewController release];
}

- (void) displayBankBalanceView {
	BankBalanceViewController *bankBalanceViewController = [[BankBalanceViewController alloc] init];
	bankBalanceViewController.title = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
	
	if (self.isAppPinSet) {
		NSInteger incorrectPinTries = [self getIncorrectPinTries];
		if (incorrectPinTries>0) {
			[self resetIncorrectPinTries];
		}
		[self.navigationController pushViewController:bankBalanceViewController animated:YES];
	} else {
		[self.navigationController pushViewController:bankBalanceViewController animated:NO];		
	}
	[bankBalanceViewController release];
}

#pragma mark -
#pragma mark Events

- (void)pinViewControllerDidFinish:(PinViewController *)controller {
	DebugLog(@"Entry");
	BOOL correctPinEntered = [self checkPin:controller.pin];
	if (correctPinEntered) {
		DebugLog(@"Correct Pin entered");
		[self.navigationController popViewControllerAnimated:NO];
		[self displayBankBalanceView];
	} else {
		DebugLog(@"Incorrect Pin entered");
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		[self markIncorrectPinTry];
		[self.navigationController popViewControllerAnimated:NO];
		[self displayPinView];
	}
	DebugLog(@"Exit");
}

- (BOOL)checkPin:(NSString *)pin {
	DebugLog(@"Entry");
	
	NSError *err;
	NSString *keychainPin = [KeychainUtils getSecureValueForKey:KC_APP_PIN andServiceName:KC_APP_PIN error:&err];
	
	if (keychainPin == nil) {
		keychainPin = @"4321"; // DEFAULT PIN
	}
	
	DebugLog(@"Keychain Pin is %@", keychainPin);
	
	if([pin isEqualToString:keychainPin]) {
		DebugLog(@"Exit");
		return YES;
	} else {
		DebugLog(@"Exit");
		return NO;
	}
}

- (NSInteger)getIncorrectPinTries {
	DebugLog(@"Entry");
	NSInteger incorrectPinTries = 0;
	NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *pinTriesFile = [cachesDirectory stringByAppendingPathComponent:PIN_TRIES_FILENAME];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pinTriesFile];
	
	if (fileExists) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pinTriesFile];
		incorrectPinTries = [[dict valueForKey:PIN_COUNT] intValue];
		DebugLog(@"Current PIN Tries count = %@", [[NSNumber numberWithInt:incorrectPinTries] stringValue]);
		[dict release];
	}
	
	DebugLog(@"Exit");
	return incorrectPinTries;
}

- (void)markIncorrectPinTry {
	DebugLog(@"Entry");
	
	NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *pinTriesFile = [cachesDirectory stringByAppendingPathComponent:PIN_TRIES_FILENAME];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pinTriesFile];
	
	if (!fileExists) {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		NSInteger incorrectPinTries = 1; // as no file exists, this must be the first incorrect pin try, hence the hardcoded 1
		[dict setValue:[NSNumber numberWithInt:incorrectPinTries] forKey:PIN_COUNT]; 
		BOOL stored = [dict writeToFile:pinTriesFile atomically:YES];
		if (!stored) {
			InfoLog(@"ERROR: Incorrect Pin Try not stored");
		}
		[dict release];
	} else {
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pinTriesFile];
		NSInteger incorrectPinTries = [[dict valueForKey:PIN_COUNT] intValue];
		DebugLog(@"Current PIN Tries count = %@, new count = %@", [[NSNumber numberWithInt:incorrectPinTries] stringValue], [[NSNumber numberWithInt:incorrectPinTries+1] stringValue]);
		incorrectPinTries++;
		[dict setValue:[NSNumber numberWithInt:incorrectPinTries] forKey:PIN_COUNT];
		BOOL stored = [dict writeToFile:pinTriesFile atomically:YES];
		if (!stored) {
			InfoLog(@"ERROR: Incorrect Pin Try not stored");
		}
		[dict release];
	}
}

- (void)resetIncorrectPinTries {
	DebugLog(@"Entry");
	NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *pinTriesFile = [cachesDirectory stringByAppendingPathComponent:PIN_TRIES_FILENAME];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:pinTriesFile];
	if (fileExists) {
		[[NSFileManager defaultManager] removeItemAtPath:pinTriesFile error:nil];
	}
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
}


@end
