/*
 *  BankBalanceAppDelegate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */


#import "BankBalance.h"
#import "BankBalanceAppDelegate.h"
#import "MainViewController.h"

@implementation BankBalanceAppDelegate

@synthesize window;
@synthesize navigationController;

static void RootUncaughtExceptionHandler(NSException *exception) {
	InfoLog([exception reason]);
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	NSSetUncaughtExceptionHandler(&RootUncaughtExceptionHandler);
	
	UIWindow *lWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	self.window = lWindow;
	[lWindow release];
	
	MainViewController *lMainViewController = [[MainViewController alloc] init];	
	navigationController = [[UINavigationController alloc] initWithRootViewController:lMainViewController];
	
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	[lMainViewController release];
	
	return YES;
}

#pragma mark-
#pragma mark Cleanup

- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}


@end
