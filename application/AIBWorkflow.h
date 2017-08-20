/*
 *  AIBWorkflow.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "AIBCustomer.h"
#import "Workflow.h"


@interface AIBWorkflow : Workflow {	
	NSURL *baseURL;
	NSString *currentTxToken;
	NSString *lastTxTokenReturned;
	NSString *pacDigit1Requested;
	NSString *pacDigit2Requested;
	NSString *pacDigit3Requested;
	NSString *challengeRequested;
	BOOL errorDetected;
}

@property(nonatomic, retain) NSURL *baseURL;
@property(nonatomic, retain) NSString *currentTxToken;
@property(nonatomic, retain) NSString *lastTxTokenReturned;
@property(nonatomic, retain) NSString *pacDigit1Requested;
@property(nonatomic, retain) NSString *pacDigit2Requested;
@property(nonatomic, retain) NSString *pacDigit3Requested;
@property(nonatomic, retain) NSString *challengeRequested;
@property BOOL errorDetected;

-(void) performStep1;
-(void) performStep2: (AIBCustomer*)aibCustomer;
-(NSArray*) performStep3: (AIBCustomer*)aibCustomer;
-(NSString*) printCurrentTxToken;


@end
