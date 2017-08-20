/*
 *  AIBParser.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "Account.h"
#import "AIBParser.h"

@implementation AIBParser

+(NSString *) getTransactionToken:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//input[@name='transactionToken']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0]; // there is only one transactionToken on a page
	NSString *txToken = [e objectForKey:@"value"];
	
	return txToken;
}

+(NSString *) getPacDigit1:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//label[@for='digit1']/strong";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:1]; // its the SECOND mention of pacDigit1 on the page that we are interested in!
	NSString *content = [e content];
	
	if ([content isEqualToString:@"Digit 1"]) {
		return @"1";
	} else if ([content isEqualToString:@"Digit 2"]) {
		return @"2";
	} else if ([content isEqualToString:@"Digit 3"]) {
		return @"3";
	} else if ([content isEqualToString:@"Digit 4"]) {
		return @"4";
	} else {
		return @"5";
	}
}

+(NSString *) getPacDigit2: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//label[@for='digit2']/strong";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0]; 
	NSString *content = [e content];
	
	if ([content isEqualToString:@"Digit 1"]) {
		return @"1";
	} else if ([content isEqualToString:@"Digit 2"]) {
		return @"2";
	} else if ([content isEqualToString:@"Digit 3"]) {
		return @"3";
	} else if ([content isEqualToString:@"Digit 4"]) {
		return @"4";
	} else {
		return @"5";
	}
}

+(NSString *) getPacDigit3: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//label[@for='digit3']/strong";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0];
	NSString *content = [e content];
	
	if ([content isEqualToString:@"Digit 1"]) {
		return @"1";
	} else if ([content isEqualToString:@"Digit 2"]) {
		return @"2";
	} else if ([content isEqualToString:@"Digit 3"]) {
		return @"3";
	} else if ([content isEqualToString:@"Digit 4"]) {
		return @"4";
	} else {
		return @"5";
	}
}

+(NSString *) getChallenge:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//label[@for='challenge']/strong[last()]";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0];
	NSString *content = [e content];
	
	return content;
}

+(NSString *) checkForBackendError: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//div[@class='aibRow errorMessage aibExt63']/p";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ([elements count]==0) {
		DebugLog(@"No AIB Online Service backend error found.");
		return nil;
	}
	DocumentElement *e = [elements objectAtIndex:0];
	NSString *content = [e content];
	return content;	
}

+(NSArray *) getAccountList:(Document *)htmlDocument {
	NSMutableArray *accounts = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *listAccountNames = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *listAccountBalances = [NSMutableArray arrayWithCapacity:0];
	
	NSString *kXPathQuery = @"//span";
	NSString *kXPathQuery2 = @"//h3";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ((elements!=nil) || ([elements count]>0)) {		
		for (int i=0; i<[elements count]; i++) {
			DocumentElement *e = [elements objectAtIndex:i];
			NSString *string = [e content];
			if ([AIBParser stringIsAccount:string]) {
				[listAccountNames addObject:string];
			}
		}
		
		NSArray *elements2 = [htmlDocument search:kXPathQuery2];
		for (int i=0; i<[elements2 count];i++) {
			DocumentElement *e = [elements2 objectAtIndex:i];
			NSString *string = [e content];
			if ([AIBParser stringIsAccountBalance:string]) {
				[listAccountBalances addObject:string];
			}
		}
	}
	
	if (([listAccountNames count]>0) && ([listAccountNames count] == [listAccountBalances count])) {
		for (int i=0; i<[listAccountNames count]; i++) {
			Account *account = [[Account alloc] init];
			account.name = [listAccountNames objectAtIndex:i];
			account.balance = [listAccountBalances objectAtIndex:i];
			[accounts addObject:account];
			[account release];
		}
	} else {
		InfoLog(@"Account list aligment problem");
	}
	
	
	return accounts;
}

+(BOOL) isLoggedIn:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//p[@class='error']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ((elements==nil) || ([elements count]==0)) {
		return YES;
	} else {
		return NO;
	}
}

+(BOOL) stringIsAccount:(NSString *)string {
	if ([string length] < 4) {
		return NO; // its too small to be an a/c
	} else if ([string characterAtIndex:[string length]-4] != '-') {
		return NO;
	} else {
		return YES;
	}
}

+(BOOL) stringIsAccountBalance:(NSString *)string {
	if ([string hasSuffix:@"DR"]) {
		return YES;
	} else if (([string length] > 3) && ([string characterAtIndex:[string length]-3] == '.')) {
		return YES;
	} else {
		return NO;
	}
}

+(BOOL) stringIsCreditBalance:(NSString *)string {
	if ([string hasSuffix:@"DR"]) {
		return NO;
	} else {
		return YES;
	}
}


@end
