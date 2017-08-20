/*
 *  AIBSettingsViewController.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PreferenceEntryViewController.h"
#import "AIBCustomer.h"

@interface AIBSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, PreferenceEntryViewControllerDelegate> {
	UITableView *aibSettingsTableView;
	UIView *footerView;
	AIBCustomer *aibCustomer;
}

@property(nonatomic, retain) UITableView *aibSettingsTableView;
@property(nonatomic, retain) AIBCustomer *aibCustomer;

- (void)preferenceEntryViewControllerDidFinish:(PreferenceEntryViewController *)controller;
- (void)deleteButtonPressed:(id)selector;

@end
