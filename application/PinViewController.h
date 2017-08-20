/*
 *  PinViewControllerDelegate.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "BankBalance.h"
#import "PinBoxesViewController.h"

@protocol PinViewControllerDelegate;

@interface PinViewController : UIViewController <PinBoxesViewControllerDelegate> {
	id <PinViewControllerDelegate> delegate;
	PINViewControllerModes mode;
	NSString *pin;
	NSString *pinMemory;
	NSString *message;
	PinBoxesViewController *pinBoxesViewController; 
}

@property(nonatomic, assign) <PinViewControllerDelegate> delegate;
@property PINViewControllerModes mode;
@property(nonatomic, retain) NSString *pin;
@property(nonatomic, retain) NSString *pinMemory;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) PinBoxesViewController *pinBoxesViewController;

- (void)cancelButtonPressed:(id) sender;
- (void)pinBoxesViewControllerDidFinish:(PinBoxesViewController *)controller;

@end

@protocol PinViewControllerDelegate
- (void)pinViewControllerDidFinish:(PinViewController *)controller;
@end