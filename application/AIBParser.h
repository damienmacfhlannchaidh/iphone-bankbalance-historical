/*
 *  AIBParser.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "Document.h"


@interface AIBParser : NSObject {

}

+(NSString *) getTransactionToken: (Document *)htmlDocument;
+(NSString *) getPacDigit1: (Document *)htmlDocument;
+(NSString *) getPacDigit2: (Document *)htmlDocument;
+(NSString *) getPacDigit3: (Document *)htmlDocument;
+(NSString *) getChallenge: (Document *)htmlDocument;
+(NSArray *) getAccountList: (Document *)htmlDocument;
+(BOOL) isLoggedIn: (Document *)htmlDocument;
+(BOOL) stringIsAccount:(NSString *)string;
+(BOOL) stringIsAccountBalance:(NSString *)string;
+(BOOL) stringIsCreditBalance:(NSString *)string;
+(NSString *) checkForBackendError: (Document *)htmlDocument;

@end
