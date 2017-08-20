/*
 *  BOIWorkflow.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "Workflow.h"
#import "BOICustomer.h"
#import "BankBalance.h"


@interface BOIWorkflow : Workflow {
	BOIChallangeOptions challangeRequested;
	
	NSString *pinDigit1Requested;
	NSString *pinDigit2Requested;
	NSString *pinDigit3Requested;
	
	BOOL errorDetected;
	
}

@property(nonatomic, retain) NSString *pinDigit1Requested;
@property(nonatomic, retain) NSString *pinDigit2Requested;
@property(nonatomic, retain) NSString *pinDigit3Requested;
@property BOIChallangeOptions challangeRequested;
@property BOOL errorDetected;

-(void) performStep1;
-(void) performStep2: (BOICustomer *)boiCustomer;
-(NSArray *) performStep3: (BOICustomer *)boiCustomer;
+(BOOL) boiAccountsConfigured;
+(NSString *) urlencode: (NSString *) url;

@end
