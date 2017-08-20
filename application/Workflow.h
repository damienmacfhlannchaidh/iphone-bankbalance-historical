/*
 *  Workflow.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface Workflow : NSObject {
	
}

-(NSData*) executeRequest:(NSURL*)url requestBody:(NSString*)requestBody HTTPMethod:(NSString*)method;

@end
