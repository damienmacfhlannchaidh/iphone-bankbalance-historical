/*
 *  ProgressBarView.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */
#import "ProgressBarView.h"
#import "BankBalance.h"


@implementation ProgressBarView
@synthesize label;
@synthesize progressBar;


- (id)initWithFrame:(CGRect)frame {
	[super initWithFrame:frame];
	label = [[UILabel alloc] initWithFrame:CGRectMake(60.0f, 9.0f, 200.0f, 12.0f)];
	progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(60.0f, 25.0f, 200.0f, 13.0f)];
    return self;
}


- (void)drawRect:(CGRect)rect {
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont fontWithName:BOLD_FONT size:10.0f];
	label.textAlignment = UITextAlignmentCenter;
	label.shadowColor = [UIColor grayColor];
	
    [progressBar setProgressViewStyle:UIProgressViewStyleBar];
	progressBar.backgroundColor = [UIColor clearColor];
	
    [self addSubview:label];
	[self addSubview:progressBar];
}

- (void)dealloc {
	[label release];
	[progressBar release];
    [super dealloc];
}


@end
