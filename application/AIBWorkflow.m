/*
 *  AIBWorkflow.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "AIBWorkflow.h"
#import "AIBParser.h"


@implementation AIBWorkflow

@synthesize baseURL;
@synthesize currentTxToken;
@synthesize pacDigit1Requested;
@synthesize pacDigit2Requested;
@synthesize pacDigit3Requested;
@synthesize challengeRequested;
@synthesize lastTxTokenReturned;
@synthesize errorDetected;


-(id)init {
	self.errorDetected = NO;
	self.baseURL = [NSURL URLWithString:AIB_BASEURL];
	[super init];
	return self;
}

#pragma mark -
#pragma mark Workflow

-(void) performStep1 {
	DebugLog(@"Entry");
	self.errorDetected = NO;
	
	NSData *response = [self executeRequest:baseURL requestBody:nil HTTPMethod:@"GET"];
	
	Document *doc = [[Document alloc] initWithHTMLData:response];
	self.currentTxToken = [AIBParser getTransactionToken:doc];
	[doc release];
	DebugLog(@"Exit");
}



-(void) performStep2: (AIBCustomer *)aibCustomer {
	DebugLog(@"Entry");
	if (self.errorDetected == YES) {
		return;
	}
	
	if ((aibCustomer.registrationNumber == nil) || ([aibCustomer.registrationNumber length] !=8)) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"AIB Registration Number has not been set or is not 8 digits long." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		self.errorDetected = YES;
		[alert release];
		return;
	}
	
	NSString *requestBody = [NSString stringWithFormat:@"jsEnabled=TRUE&transactionToken=%@&regNumber=%@&_target1=true", self.currentTxToken, aibCustomer.registrationNumber];
	DebugLog(requestBody);
	
	NSData *response = [self executeRequest:baseURL requestBody:requestBody HTTPMethod:@"POST"];
	
	Document *doc = [[Document alloc] initWithHTMLData:response];
	self.currentTxToken = [AIBParser getTransactionToken:doc];
	
	self.pacDigit1Requested = [AIBParser getPacDigit1:doc];
	self.pacDigit2Requested = [AIBParser getPacDigit2:doc];
	self.pacDigit3Requested = [AIBParser getPacDigit3:doc];
	self.challengeRequested = [AIBParser getChallenge:doc];
	[doc release];
	
	DebugLog(@"PAC1=%@ and PAC2=%@ and PAC3=%@ and challenge=%@", self.pacDigit1Requested, self.pacDigit2Requested, self.pacDigit3Requested, self.challengeRequested);
	DebugLog(@"Exit");
}

-(NSArray*) performStep3:(AIBCustomer *)aibCustomer {
	DebugLog(@"Entry");
	if (self.errorDetected == YES) {
		return nil;
	}
	
	if (([aibCustomer getPacDigit:self.pacDigit1Requested] == nil) || ([aibCustomer getPacDigit:self.pacDigit2Requested] == nil) || ([aibCustomer getPacDigit:self.pacDigit3Requested] == nil)) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"AIB PAC Number has not been set." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		self.errorDetected = YES;
		[alert release];
		return nil;
	}
	
	if (([aibCustomer getChallenge:self.challengeRequested] == nil) || ([[aibCustomer getChallenge:self.challengeRequested] length] != 4)) {
		NSString *msg = [NSString stringWithFormat:@"AIB %@ has not been set or is not the last 4 digits.", self.challengeRequested];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		self.errorDetected = YES;
		[alert release];
		return nil;
	}
	
	NSString *requestBody = [NSString stringWithFormat:@"transactionToken=%@&pacDetails.pacDigit1=%@&pacDetails.pacDigit2=%@&pacDetails.pacDigit3=%@&challengeDetails.challengeEntered=%@&_finish=true", self.currentTxToken, [aibCustomer getPacDigit:self.pacDigit1Requested],
							 [aibCustomer getPacDigit:self.pacDigit2Requested], [aibCustomer getPacDigit:self.pacDigit3Requested], [aibCustomer getChallenge:self.challengeRequested]];
	
	NSData *response = [self executeRequest:baseURL requestBody:requestBody HTTPMethod:@"POST"];
	Document *doc = [[Document alloc] initWithHTMLData:response];
	
	// check for backend error on AIB Online service
	NSString *errorMsg = [AIBParser checkForBackendError:doc];
	if (errorMsg!=nil) {
		InfoLog(@"AIB Internet Banking Backend error:%@", errorMsg);
		NSString *alertMsg = [NSString stringWithFormat:@"AIB's Online Service has issued the following message:\n%@", errorMsg];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		self.errorDetected=YES;
		[doc release];
		return nil;
	}
	
	NSArray *accounts = [AIBParser getAccountList:doc];
	
	[doc release];
	
	DebugLog(@"Exit");
	return accounts;
}


#pragma mark -
#pragma mark Utility Functions

-(NSString*) printCurrentTxToken {
	if (self.currentTxToken==nil) {
		return @"No Current Tx Token";
	}
	
	return [NSString stringWithFormat:@"Current Tx Token is [%@]", self.currentTxToken];
}

#pragma mark -
#pragma mark Cleanup

-(void) dealloc {
	[baseURL release];
	[currentTxToken release];
	[lastTxTokenReturned release];
	[pacDigit1Requested release];
	[pacDigit2Requested release];
	[pacDigit3Requested release];
	[challengeRequested release];
	[super dealloc];
}

@end
