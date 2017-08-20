/*
 *  PinBoxesViewControllerDelegate.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "BankBalance.h"

@protocol PinBoxesViewControllerDelegate;

@interface PinBoxesViewController : UIViewController {
	id <PinBoxesViewControllerDelegate> delegate;
	UILabel *explainText;
	UILabel *pin1;
	UILabel *pin2;
	UILabel *pin3;
	UILabel *pin4;
	UILabel *message;
	UITextField *pinCollected;
	PINViewControllerModes mode;
	int incorrectPinTries;
	NSInteger numberOfDots;
	NSString *messageText;
	
}

@property(nonatomic, assign) id <PinBoxesViewControllerDelegate> delegate;
@property(nonatomic, retain) UILabel *explainText;
@property(nonatomic, retain) UILabel *pin1;
@property(nonatomic, retain) UILabel *pin2;
@property(nonatomic, retain) UILabel *pin3;
@property(nonatomic, retain) UILabel *pin4;
@property(nonatomic, retain) UILabel *message;
@property(nonatomic, retain) UITextField *pinCollected;
@property PINViewControllerModes mode;
@property int incorrectPinTries;
@property(assign) NSInteger numberOfDots;
@property(nonatomic, retain) NSString *messageText;

- (id)initWithMode:(int)theMode;
- (void)readIncorrectPinTries;
- (void)pinDigitEntered:(id)sender;
- (void)clearStars;
- (void)cancelButtonPressed:(id) sender;

@end

@protocol PinBoxesViewControllerDelegate
- (void)pinBoxesViewControllerDidFinish:(PinBoxesViewController *)controller;
- (void)pinBoxesViewControllerDidCancel:(PinBoxesViewController *)controller;
@end