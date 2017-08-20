/*
 *  BankBalance.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "KeychainUtils.h"
#import "Reachability.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

@implementation BankBalance

+ (BOOL)isAppPinSet {

	NSError *err;
	NSString *pin = [KeychainUtils getSecureValueForKey:KC_APP_PIN andServiceName:KC_APP_PIN error:&err];
	if (pin != nil) {
		return YES;
	} else {
		return NO;
	}
}

+ (BOOL)checkForInternetConnection {
	DebugLog(@"Entry");
	BOOL networkAvailable = YES;
	
	NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
	
	if (netStatus == NotReachable) {
		InfoLog(@"No Internet Connection Detected. Alert Box being displayed to user.");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Internet Connection Detected. \nLatest bank balances will not be available.\nCheck Airplane Mode, connect to WiFi or move into an area with mobile network coverage." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	} 
	DebugLog(@"Entry");
	return networkAvailable;
}

@end
