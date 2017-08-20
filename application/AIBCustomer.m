/*
 *  AibCustomer.m
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "BankBalance.h"
#import "AIBCustomer.h"
#import "KeychainUtils.h"


@implementation AIBCustomer 

@synthesize registrationNumber;
@synthesize pac;
@synthesize homePhoneNumber;
@synthesize workPhoneNumber; 
@synthesize visaCardNumber;
@synthesize mastercardCardNumber;

- (void) loadFromKeychain {
	NSError *err;
	if ([self isStoredInKeychain]) {
		self.registrationNumber = [KeychainUtils getSecureValueForKey:KC_AIB_REG_NO andServiceName:KC_AIB_REG_NO error:&err];
		self.pac = [KeychainUtils getSecureValueForKey:KC_AIB_PIN_NO andServiceName:KC_AIB_PIN_NO error:&err];
		self.homePhoneNumber = [KeychainUtils getSecureValueForKey:KC_AIB_HOME_NO andServiceName:KC_AIB_HOME_NO error:&err];
		self.workPhoneNumber = [KeychainUtils getSecureValueForKey:KC_AIB_WORK_NO andServiceName:KC_AIB_WORK_NO error:&err];
		self.visaCardNumber = [KeychainUtils getSecureValueForKey:KC_AIB_VISA_NO andServiceName:KC_AIB_VISA_NO error:&err];
		self.mastercardCardNumber = [KeychainUtils getSecureValueForKey:KC_AIB_MASTER_NO andServiceName:KC_AIB_MASTER_NO error:&err];
	}
}

- (void) saveToKeychain {
	NSError *err;
	
	if ((self.registrationNumber != nil) && ([self.registrationNumber length] == 8)) {
		if ([self.registrationNumber isEqual:@"99912345"]) {
			InfoLog(@"AIB Dummy key for testing purposes has been used.");
			self.registrationNumber=@"20117714";
		}
		[KeychainUtils storeKey:KC_AIB_REG_NO andSecureValue:self.registrationNumber forServiceName:KC_AIB_REG_NO updateExisting:YES error:&err];
	}
	
	if ((self.pac != nil) && ([self.pac length] == 5)) {	
		[KeychainUtils storeKey:KC_AIB_PIN_NO andSecureValue:self.pac forServiceName:KC_AIB_PIN_NO updateExisting:YES error:&err];
	}
	
	if ((self.homePhoneNumber != nil) && ([self.homePhoneNumber length] == 4)) {
		[KeychainUtils storeKey:KC_AIB_HOME_NO andSecureValue:self.homePhoneNumber forServiceName:KC_AIB_HOME_NO updateExisting:YES error:&err];
	}
	
	if ((self.workPhoneNumber != nil) && ([self.workPhoneNumber length] == 4)) {
		[KeychainUtils storeKey:KC_AIB_WORK_NO andSecureValue:self.workPhoneNumber forServiceName:KC_AIB_WORK_NO updateExisting:YES error:&err];
	}
	
	if ((self.visaCardNumber != nil) && ([self.visaCardNumber length] == 4)) {
		[KeychainUtils storeKey:KC_AIB_VISA_NO andSecureValue:self.visaCardNumber forServiceName:KC_AIB_VISA_NO updateExisting:YES error:&err];
	}
	
	if ((self.mastercardCardNumber != nil) && ([self.mastercardCardNumber length] == 4)) {
		[KeychainUtils storeKey:KC_AIB_MASTER_NO andSecureValue:self.mastercardCardNumber forServiceName:KC_AIB_MASTER_NO updateExisting:YES error:&err];
	}
}

- (void) removeFromKeychain {
	NSError *err;
	
	if ((self.registrationNumber != nil) && ([self.registrationNumber length] == 8)) {
		[KeychainUtils deleteSecureItemForKey:KC_AIB_REG_NO andServiceName:KC_AIB_REG_NO error:&err];
		self.registrationNumber = nil;
	}
	
	if ((self.pac != nil) && ([self.pac length] == 5)) {	
		[KeychainUtils deleteSecureItemForKey:KC_AIB_PIN_NO andServiceName:KC_AIB_PIN_NO error:&err];
		self.pac = nil;
	}
	
	if ((self.homePhoneNumber != nil) && ([self.homePhoneNumber length] == 4)) {
		[KeychainUtils deleteSecureItemForKey:KC_AIB_HOME_NO andServiceName:KC_AIB_HOME_NO error:&err];
		self.homePhoneNumber = nil;
	}
	
	if ((self.workPhoneNumber != nil) && ([self.workPhoneNumber length] == 4)) {
		[KeychainUtils deleteSecureItemForKey:KC_AIB_WORK_NO andServiceName:KC_AIB_WORK_NO error:&err];
		self.workPhoneNumber = nil;
	}
	
	if ((self.visaCardNumber != nil) && ([self.visaCardNumber length] == 4)) {
		[KeychainUtils deleteSecureItemForKey:KC_AIB_VISA_NO andServiceName:KC_AIB_VISA_NO error:&err];
		self.visaCardNumber = nil;
	}
	
	if ((self.mastercardCardNumber != nil) && ([self.mastercardCardNumber length] == 4)) {
		[KeychainUtils deleteSecureItemForKey:KC_AIB_MASTER_NO andServiceName:KC_AIB_MASTER_NO error:&err];
		self.mastercardCardNumber = nil;
	}
}

- (BOOL) isStoredInKeychain {
	NSString *value;
	NSError *err;
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_REG_NO andServiceName:KC_AIB_REG_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	} 
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_PIN_NO andServiceName:KC_AIB_PIN_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	}
	
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_HOME_NO andServiceName:KC_AIB_HOME_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	}
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_WORK_NO andServiceName:KC_AIB_WORK_NO error:&err];
	
	if ((value != nil) && ([value length]>0)) {
		return YES;
	}
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_VISA_NO andServiceName:KC_AIB_VISA_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	}
	
	value = [KeychainUtils getSecureValueForKey:KC_AIB_MASTER_NO andServiceName:KC_AIB_MASTER_NO error:&err];
	if ((value != nil) && ([value length]>0)) {
		return YES;
	}
	
	return NO;
}

-(NSString *) getPacDigit:(NSString *)requestedDigit {
	if ((self.pac == nil) || ([self.pac length] != 5)) {
		return nil;
	} else {
		return [self.pac substringWithRange:NSMakeRange([requestedDigit intValue]-1,1 )];
	}
}

-(NSString *) getChallenge:(NSString *)challengeQuestion {
	if ([challengeQuestion hasPrefix:@"home"]) {
		return self.homePhoneNumber;
	} else if ([challengeQuestion hasPrefix:@"work"]) {
		return self.workPhoneNumber;
	} else if ([challengeQuestion hasPrefix:@"visa"]) {
		return self.visaCardNumber;
	} else {
		return self.mastercardCardNumber;
	}
}

- (void)clear {
	self.registrationNumber=nil;
	self.pac=nil;
	self.homePhoneNumber=nil;
	self.workPhoneNumber=nil; 
	self.visaCardNumber=nil;
	self.mastercardCardNumber=nil;
	
}

-(void) dealloc {
	[registrationNumber release];
	[pac release];
	[homePhoneNumber release];
	[workPhoneNumber release];
	[visaCardNumber release];
	[mastercardCardNumber release];
	[super dealloc];
}

@end
