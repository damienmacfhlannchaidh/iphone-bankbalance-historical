/*
 *  Account.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#define BANK @"Bank"
#define NAME @"Name"
#define BAL  @"Balance"

#import <Foundation/Foundation.h>
#import "BankBalance.h"

@interface Account : NSObject {
	Bank     bank;
	NSString *name;
	NSString *balance;
}

@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *balance;
@property Bank bank;

+ (Account *) fromNSDictionary:(NSDictionary *) dictionary;

- (BOOL)isCreditBalance;
- (NSString *) formattedBalance;
- (NSDictionary *) toNSDictionary;


@end
