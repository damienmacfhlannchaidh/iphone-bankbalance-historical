/*
 *  BOICustomer.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@interface BOICustomer : NSObject {
	NSString *loginId;
	NSString *pin;
	NSString *dateOfBirth;
	NSString *contactNumber;
}

@property(nonatomic, retain) NSString *loginId;
@property(nonatomic, retain) NSString *pin;
@property(nonatomic, retain) NSString *dateOfBirth;
@property(nonatomic, retain) NSString *contactNumber;


- (void)setDateOfBirth:(NSString *)dob;
- (NSString *)dateOfBirth;

- (void)loadFromKeychain;
- (void)saveToKeychain;
- (void)removeFromKeychain;
- (BOOL)isStoredInKeychain;
- (NSString *)getPinDigit:(NSString *)requestedDigit;
- (void)clear;

@end
