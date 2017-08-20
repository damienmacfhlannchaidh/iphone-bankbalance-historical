/*
 *  ProgressBarUpdate.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "ProgressBarUpdate.h"


@implementation ProgressBarUpdate
@synthesize message;
@synthesize	progressPercentage;


- (float)getProgressPercentageAsFloat {
	NSNumber *num = [NSNumber numberWithInteger:progressPercentage];
	float f = [num floatValue]/100;
	return f;
}

#pragma mark-
#pragma mark Cleanup

- (void)dealloc {
	[message release];
    [super dealloc];
}

@end
