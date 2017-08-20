/*
 *  BOICustomer.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "BOICustomer.h"
#import "KeychainUtils.h"


@implementation BOICustomer

@synthesize loginId;
@synthesize pin;
@synthesize dateOfBirth;
@synthesize contactNumber;


#pragma mark -
#pragma mark Business Logic

- (void)loadFromKeychain {
	NSError *err;
	if ([self isStoredInKeychain]) {
		self.loginId = [KeychainUtils getSecureValueForKey:KC_BOI_LOGIN_ID andServiceName:KC_BOI_LOGIN_ID error:&err];
		self.pin = [KeychainUtils getSecureValueForKey:KC_BOI_PIN_NO andServiceName:KC_BOI_PIN_NO error:&err];
		self.dateOfBirth = [KeychainUtils getSecureValueForKey:KC_BOI_DOB_NO andServiceName:KC_BOI_DOB_NO error:&err];
		self.contactNumber = [KeychainUtils	getSecureValueForKey:KC_BOI_CONTACT_NO andServiceName:KC_BOI_CONTACT_NO error:&err];
	}
}

- (void) saveToKeychain {
	NSError *err;
	
	if ((self.loginId != nil) && ([self.loginId length] == 6)) {
		if ([self.loginId isEqual:@"999123"]) {
			InfoLog(@"BOI Dummy key for testing purposes has been used.");
			self.loginId=@"603496";
		}
		[KeychainUtils storeKey:KC_BOI_LOGIN_ID andSecureValue:self.loginId forServiceName:KC_BOI_LOGIN_ID updateExisting:YES error:&err];
	}
	
	if ((self.pin != nil) && ([self.pin length] == 6)) {
		[KeychainUtils storeKey:KC_BOI_PIN_NO andSecureValue:self.pin forServiceName:KC_BOI_PIN_NO updateExisting:YES error:&err];
	}
	
	if ((self.dateOfBirth != nil) && ([self.dateOfBirth length] == 8)) {
		[KeychainUtils storeKey:KC_BOI_DOB_NO andSecureValue:self.dateOfBirth forServiceName:KC_BOI_DOB_NO updateExisting:YES error:&err];
	}
	
	if ((self.contactNumber != nil) && ([self.contactNumber length] == 4)) {
		[KeychainUtils storeKey:KC_BOI_CONTACT_NO andSecureValue:self.contactNumber forServiceName:KC_BOI_CONTACT_NO updateExisting:YES error:&err];
	}
}

- (void) removeFromKeychain {
	NSError *err;
	
	if ((self.loginId != nil) && ([self.loginId length] == 6)) {
		[KeychainUtils deleteSecureItemForKey:KC_BOI_LOGIN_ID andServiceName:KC_BOI_LOGIN_ID error:&err];
	}
	
	if ((self.pin != nil) && ([self.pin length] == 6)) {
		[KeychainUtils deleteSecureItemForKey:KC_BOI_PIN_NO andServiceName:KC_BOI_PIN_NO error:&err];
	}
	
	if ((self.dateOfBirth != nil) && ([self.dateOfBirth length] == 8)) {
		[KeychainUtils deleteSecureItemForKey:KC_BOI_DOB_NO andServiceName:KC_BOI_DOB_NO error:&err];
	}
	
	if ((self.contactNumber != nil) && ([self.contactNumber length] == 4)) {
		[KeychainUtils deleteSecureItemForKey:KC_BOI_CONTACT_NO andServiceName:KC_BOI_CONTACT_NO error:&err];
	}
}

- (BOOL) isStoredInKeychain {
	NSString *value;
	NSError *err;
	
	value = [KeychainUtils getSecureValueForKey:KC_BOI_LOGIN_ID andServiceName:KC_BOI_LOGIN_ID error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	} 
	
	value = [KeychainUtils getSecureValueForKey:KC_BOI_PIN_NO andServiceName:KC_BOI_PIN_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	} 
	
	value = [KeychainUtils getSecureValueForKey:KC_BOI_DOB_NO andServiceName:KC_BOI_DOB_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	} 
	
	value = [KeychainUtils	getSecureValueForKey:KC_BOI_CONTACT_NO andServiceName:KC_BOI_CONTACT_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	} 
	
	return NO;
}

-(NSString *) getPinDigit:(NSString *)requestedDigit {
	if ((self.pin == nil) || ([self.pin length] != 6)) {
		return nil;
	} else {
		return [self.pin substringWithRange:NSMakeRange([requestedDigit intValue]-1,1 )];
	}
}

- (void)clear {
	self.loginId=nil;
	self.pin=nil;
	self.dateOfBirth=nil;
	self.contactNumber=nil;
}

#pragma mark -
#pragma mark Cleanup

-(void) dealloc {
	[loginId release];
	[pin release];
	[dateOfBirth release];
	[contactNumber release];
	[super dealloc];
}

@end
