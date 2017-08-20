/*
 *  BOIParser.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BOIParser.h"
#import "BankBalance.h"
#import "Account.h"


@implementation BOIParser


+(int)getChallenge:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//label[@for='txt_pword']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0];
	NSString *content = [e content];
	
	if ([content rangeOfString: @"contact" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return BOIChallangeContactNumber;
	} else {
		return BOIChallangeDOB;
	}
}

+(NSString *) getPinDigit1: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//input[normalize-space(@type)='password']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:0];
	NSDictionary *attributes = [e attributes];
	
	NSString *str = [attributes valueForKey:@"title"];
	
	return [BOIParser returnDigitBeingRequested:str];
}

+(NSString *) getPinDigit2: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//input[normalize-space(@type)='password']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:1];
	NSDictionary *attributes = [e attributes];
	
	NSString *str = [attributes valueForKey:@"title"];
	
	return [BOIParser returnDigitBeingRequested:str];
}

+(NSString *) getPinDigit3: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//input[normalize-space(@type)='password']";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	DocumentElement *e = [elements objectAtIndex:2];
	NSDictionary *attributes = [e attributes];
	
	NSString *str = [attributes valueForKey:@"title"];
	
	return [BOIParser returnDigitBeingRequested:str];
}

+(NSString *) returnDigitBeingRequested: (NSString *) str {
	if ([str rangeOfString:@"1" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return @"1";
	} else if ([str rangeOfString:@"2" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return @"2";
	} else if ([str rangeOfString:@"3" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return @"3";
	} else if ([str rangeOfString:@"4" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return @"4";
	} else if ([str rangeOfString:@"5" options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch].location != NSNotFound) {
		return @"5";
	}else {
		return @"6";
	}
}

+(NSString *) checkForBackendError: (Document *)htmlDocument {
	NSString *kXPathQuery = @"//h2";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ([elements count]==0) {
		return nil;
	}
	DocumentElement *e = [elements objectAtIndex:0];
	NSString *content = [e content];
	return content;
}

+(BOOL) checkForSecurityPage:(Document *)htmlDocument {
	NSString *kXPathQuery = @"//title";
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ([elements count]>0) {
		DocumentElement *e = [elements objectAtIndex:0];
		NSString *title = [e content];
		NSRange textRange = [title rangeOfString:@"Alert"];
		if (textRange.location != NSNotFound) {
			return YES;
		} else {
			return NO;
		}
	} else {
		return NO;
	}
}


+(NSArray *) getAccountList: (Document *)htmlDocument {
	
	NSMutableArray *accounts = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *listAccountNames = [NSMutableArray arrayWithCapacity:0];
	NSMutableArray *listAccountBalances = [NSMutableArray arrayWithCapacity:0];
	
	NSString *kXPathQuery = @"//div[@class='account_tables'][1]/table/tr/td/a[text()]";
	NSString *kXPathQuery2 = @"//div[@class='account_tables'][1]/table/tr/td[string-length(text())>1]";
	
	NSArray *elements = [htmlDocument search:kXPathQuery];
	if ((elements!=nil) || ([elements count]>0)) {
		for (int i=0; i < [elements count]; i=i+2) {
			NSString *str1 = [[elements objectAtIndex:i] content];
			NSString *str2 = [[elements objectAtIndex:i+1] content];
			NSString *fullAccountName = [NSString stringWithFormat:@"%@ - %@", str1, str2];
			[listAccountNames addObject:fullAccountName];
		}
		
		NSArray *elements2 = [htmlDocument search:kXPathQuery2];
		for (int i=0; i<[elements2 count];i++) {
			NSString *balance = [[elements2 objectAtIndex:i] content];
			if (![balance isEqualToString:@"EUR"]) {
				[listAccountBalances addObject:balance];
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

+(BOOL) stringIsCreditBalance:(NSString *)string {
	NSRange textRange = [string rangeOfString:@"-"];
	if (textRange.location != NSNotFound) {
		return NO;
	} else {
		return YES;
	}
}

@end

