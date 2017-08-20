/*
 *  BankBalanceViewController.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "ProgressBarView.h"
#import "ProgressBarUpdate.h"
#import "AIBCustomer.h"
#import "BOICustomer.h"

@interface BankBalanceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SettingsViewControllerDelegate> {
	
	// View components
	UITableView *accountsListTableView;
	UIToolbar *toolBar;
	ProgressBarView *progressBarView;
	
	// Arrays that back the table
	NSMutableArray *aibAccountsList;
	NSMutableArray *boiAccountsList;
	
	// Background operations
	NSOperationQueue *queue;
	NSInvocationOperation *backgroundDataLoadOperation;
	
	// Customer objects
	AIBCustomer *aibCustomer;
	BOICustomer *boiCustomer;
	
	// Flow control
	BOOL aibWorkflowErrorDetected;
	BOOL boiWorkflowErrorDetected;
}

@property(nonatomic, retain) UITableView *accountsListTableView;
@property(nonatomic, retain) UIToolbar *toolBar;
@property(nonatomic, retain) ProgressBarView *progressBarView;
@property(nonatomic, retain) NSMutableArray *aibAccountsList;
@property(nonatomic, retain) NSMutableArray *boiAccountsList;
@property(nonatomic, retain) NSOperationQueue *queue;
@property(nonatomic, retain) NSInvocationOperation *backgroundDataLoadOperation;
@property(nonatomic, retain) AIBCustomer *aibCustomer;
@property(nonatomic, retain) BOICustomer *boiCustomer;
@property BOOL aibWorkflowErrorDetected;
@property BOOL boiWorkflowErrorDetected;

- (void)updateProgressBar:(ProgressBarUpdate *)progressBarUpdate;
- (void)showProgressBar;
- (void)hideProgressBar;
- (void)refreshButtonPressed:(id) sender;
- (void)infoButtonPressed:(id) sender;
- (void)performAIBWorkflow;
- (void)performBOIWorkflow;
- (void)getBankBalances;
- (void)getDemoBankBalances;

@end
