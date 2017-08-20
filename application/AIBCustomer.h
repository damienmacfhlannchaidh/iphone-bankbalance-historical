/*
 *  AIBCustomer.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface AIBCustomer : NSObject {
	NSString *registrationNumber;
	NSString *pac;
	NSString *homePhoneNumber;
	NSString *workPhoneNumber;
	NSString *visaCardNumber;
	NSString *mastercardCardNumber;
}

@property(nonatomic, retain) NSString *registrationNumber;
@property(nonatomic, retain) NSString *pac;
@property(nonatomic, retain) NSString *homePhoneNumber;
@property(nonatomic, retain) NSString *workPhoneNumber;
@property(nonatomic, retain) NSString *visaCardNumber;
@property(nonatomic, retain) NSString *mastercardCardNumber;

- (void)loadFromKeychain;
- (void)saveToKeychain;
- (void)removeFromKeychain;
- (BOOL)isStoredInKeychain;
- (NSString *)getPacDigit:(NSString *)requestedDigit;
- (NSString *)getChallenge:(NSString*)challengeQuestion;
- (void)clear;
@end
