/*
 *  Account.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "Account.h"

@implementation Account
@synthesize bank, name, balance;

- (BOOL) isCreditBalance {
	return YES;
}

- (NSString *) formattedBalance {
	return [NSString stringWithFormat:@"€ %@", balance];
}

- (NSDictionary *) toNSDictionary {
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	
	[dict setValue:[NSNumber numberWithInt:bank] forKey:BANK];
	[dict setValue:name forKey:NAME];
	[dict setValue:balance forKey:BAL];
	
	return dict;
}

+ (Account *) fromNSDictionary:(NSDictionary *) dictionary {
	Account *account = [[[Account alloc] init] autorelease];	
	
	account.bank = [[dictionary valueForKey:BANK] integerValue];
	account.name = [dictionary valueForKey:NAME];
	account.balance = [dictionary valueForKey:BAL];
	
	return account;	
}

- (void)dealloc {
	[name dealloc];
	[balance dealloc];
	[super dealloc];
}

@end
