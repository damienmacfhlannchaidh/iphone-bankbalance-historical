/*
 *  BOIWorkflow.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BOIWorkflow.h"
#import "BOIParser.h"


@implementation BOIWorkflow
@synthesize errorDetected, challangeRequested, pinDigit1Requested, pinDigit2Requested, pinDigit3Requested;

-(id)init {
	self.errorDetected = NO;
	[super init];
	return self;
}

-(void) performStep1 {
	DebugLog(@"Entry");
	self.errorDetected=NO;
	NSURL *url = [NSURL URLWithString:BOI_URL1];
	
	NSData *response = [self executeRequest:url requestBody:nil HTTPMethod:@"GET"];
	
	Document *doc = [[Document alloc] initWithHTMLData:response];
	self.challangeRequested = [BOIParser getChallenge:doc];
	[doc release];
	DebugLog(@"Exit");
}

-(void) performStep2: (BOICustomer *)boiCustomer {
	DebugLog(@"Entry");
	if (self.errorDetected == YES) {
		return;
	}
	
	NSURL *url = [NSURL URLWithString:BOI_URL2];	
	NSString *challangeAnswer = nil;
	if (self.challangeRequested == BOIChallangeContactNumber) {
		if (boiCustomer.contactNumber == nil || [boiCustomer.contactNumber length] <= 0) {
			InfoLog(@"Bank of Ireland's Online Service is requesting a contact number, but is not set in the app preferences.");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bank of Ireland's Online Service is requesting a contact number, but you have not set one in the app preferences." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			self.errorDetected = YES;
			return;
		} else {
			challangeAnswer = boiCustomer.contactNumber;
		}
	} else {
		if (boiCustomer.dateOfBirth == nil || [boiCustomer.dateOfBirth length] <= 0) {
			InfoLog(@"Bank of Ireland's Online Service is requesting a date of birth, but is not set in the app preferences.");
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bank of Ireland's Online Service is requesting a Date of Birth, but you have not set one in the app preferences." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
			self.errorDetected = YES;
			return;			
		} else {
			NSRange dayRange = {0,2};
			NSRange monthRange = {2,2};
			NSRange yearRange = {4,4};
			NSString *day = [boiCustomer.dateOfBirth substringWithRange:dayRange];
			NSString *month = [boiCustomer.dateOfBirth substringWithRange:monthRange];
			NSString *year = [boiCustomer.dateOfBirth substringWithRange:yearRange];
			NSString *dateOfBirth = [NSString stringWithFormat:@"%@/%@/%@", day, month, year];
			challangeAnswer = [BOIWorkflow urlencode:dateOfBirth];
		}
	}
	NSString *requestBody = [NSString stringWithFormat:@"USER=%@&Pass_Val_1=%@", boiCustomer.loginId, challangeAnswer];
	
	NSData *response = [self executeRequest:url requestBody:requestBody HTTPMethod:@"POST"];
	
	Document *doc = [[Document alloc] initWithHTMLData:response];
	self.pinDigit1Requested = [BOIParser getPinDigit1:doc];
	self.pinDigit2Requested = [BOIParser getPinDigit2:doc];
	self.pinDigit3Requested = [BOIParser getPinDigit3:doc];
	
	[doc release];
	DebugLog(@"Exit");
}

-(NSArray *) performStep3: (BOICustomer *)boiCustomer {
	DebugLog(@"Entry");
	if (self.errorDetected == YES) {
		return nil;
	}
	
	NSURL *url = [NSURL URLWithString:BOI_URL3];	
	NSString *requestBody = [NSString stringWithFormat:@"PIN_Val_1=%@&PIN_Val_2=%@&PIN_Val_3=%@", [boiCustomer getPinDigit:self.pinDigit1Requested], [boiCustomer getPinDigit:self.pinDigit2Requested], [boiCustomer getPinDigit:self.pinDigit3Requested]];
	
	NSData *response = [self executeRequest:url requestBody:requestBody HTTPMethod:@"POST"];
	if (response == nil) {} //dummy function to keep CLANG happy
	
	// check for backend error on 365 Online service
	Document *doc = [[Document alloc] initWithHTMLData:response];
	NSString *errorMsg = [BOIParser checkForBackendError:doc];
	[doc release];
	

	if (errorMsg!=nil) {
		InfoLog(@"365 Online Backend error:%@", errorMsg);
		NSString *alertMsg = [NSString stringWithFormat:@"Bank of Ireland's Online Service has issued the following message:\n%@", errorMsg];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		self.errorDetected=YES;
		return nil;
	}
	
	url = [NSURL URLWithString:BOI_URL4];
	response = [self executeRequest:url requestBody:nil HTTPMethod:@"GET"];
    
	//TODO: deal with BOI's random security page
	Document *doc2 = [[Document alloc] initWithHTMLData:response];
	if ([BOIParser checkForSecurityPage:doc2]) {
		DebugLog(@"BOI security page is present.");
	}
	
	
	NSArray *accounts = [BOIParser getAccountList:doc2];
	[doc2 release];
	
	//logout of service
	url = [NSURL URLWithString:BOI_URL5];
	[self executeRequest:url requestBody:nil HTTPMethod:@"GET"];
	
	DebugLog(@"Exit");
	return accounts;
}

+(BOOL) boiAccountsConfigured {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *value = nil;
	
	//BOI LOGIN ID
	value = [prefs objectForKey:@"pref.roi.loginid"];
	if (value != nil && [value length] > 0) {
		value = nil;
		return YES;
	}
	
	//BOI PIN
	value = [prefs objectForKey:@"pref.boi.pin"];
	if (value != nil && [value length] > 0) {
		value = nil;
		return YES;
	}
	
	//BOI DATE OF BIRTH
	value = [prefs objectForKey:@"pref.boi.dob"];
	if (value != nil && [value length] > 0) {
		value = nil;
		return YES;
	}
	
	//BOI CONTACT NUMBER
	value = [prefs objectForKey:@"pref.boi.contacno"];
	if (value != nil && [value length] > 0) {
		value = nil;
		return YES;
	}
	
	return NO;
}

+(NSString *) urlencode: (NSString *) url {
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [url mutableCopy];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *out = [NSString stringWithString: temp];
	[temp release];
	
    return out;
}

-(void) dealloc {
	[pinDigit1Requested	release];
	[pinDigit2Requested release];
	[pinDigit3Requested	release];
	[super dealloc];
}

@end
