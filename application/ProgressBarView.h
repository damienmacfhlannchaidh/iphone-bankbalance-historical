/*
 *  ProgressBarView.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface ProgressBarView : UIView {
	UILabel *label;
	UIProgressView *progressBar;
}

@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIProgressView *progressBar;

@end
