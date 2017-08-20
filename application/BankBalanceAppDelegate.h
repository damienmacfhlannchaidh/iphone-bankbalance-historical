/*
 *  BankBalanceAppDelegate.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface BankBalanceAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
}

@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, retain) UINavigationController *navigationController;

@end

