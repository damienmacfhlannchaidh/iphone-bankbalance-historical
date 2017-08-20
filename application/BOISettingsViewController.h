/*
 *  BOISettingsViewController.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "PreferenceEntryViewController.h"
#import "BOICustomer.h"

@interface BOISettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, PreferenceEntryViewControllerDelegate> {
	UITableView *boiSettingsTableView;
	UIView *footerView;
	BOICustomer *boiCustomer;
}

@property(nonatomic, retain) UITableView *boiSettingsTableView;
@property(nonatomic, retain) UIView *footerView;
@property(nonatomic, retain) BOICustomer *boiCustomer;

- (void)preferenceEntryViewControllerDidFinish:(PreferenceEntryViewController *)controller;
- (void)deleteButtonPressed:(id)selector;

@end
