/*
 *  PreferenceEntryViewControllerDelegate.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import <UIKit/UIKit.h>

@protocol PreferenceEntryViewControllerDelegate;

@interface PreferenceEntryViewController : UIViewController {
	id<PreferenceEntryViewControllerDelegate> delegate;
	NSInteger numBoxes;
	NSMutableArray *entryBoxes;
	UITextField *numberCollected;
	UILabel *explanationLabel;
	UILabel *descriptionLabel;
	UILabel *descriptionLabel2;
	NSString *description;
	NSString *description2;
	NSInteger numberOfDots;
	PrefEntryViewControllerModes mode;
}

@property(nonatomic, assign) id <PreferenceEntryViewControllerDelegate> delegate;
@property(assign) NSInteger numBoxes;
@property(nonatomic, retain) NSMutableArray *entryBoxes;
@property(nonatomic, retain) UITextField *numberCollected;
@property(nonatomic, retain) UILabel *explanationLabel;
@property(nonatomic, retain) UILabel *descriptionLabel;
@property(nonatomic, retain) UILabel *descriptionLabel2;
@property(nonatomic, retain) NSString *description;
@property(nonatomic, retain) NSString *description2;
@property(assign) NSInteger numberOfDots;
@property(assign) PrefEntryViewControllerModes mode;

- (id) initWithNumberOfEntryBoxes:(NSInteger)numberOfBoxes;
- (void) digitEndered:(id) sender;
- (void) clearEntry:(id) sender;

@end

@protocol PreferenceEntryViewControllerDelegate
- (void)preferenceEntryViewControllerDidFinish:(PreferenceEntryViewController *)controller;
@end