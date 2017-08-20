/*
 *  Workflow.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import "Workflow.h"

@implementation Workflow

-(NSData*) executeRequest:(NSURL*)url requestBody:(NSString*)requestBody HTTPMethod:(NSString*)method {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	[request setHTTPShouldHandleCookies:YES];
	[request setValue:@"Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3" forHTTPHeaderField:@"User-Agent"];
	[request setHTTPMethod:method];
	if (([method isEqualToString:@"POST"]) && (requestBody!=nil)) {
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		[request setValue:[NSString stringWithFormat:@"%d", [requestBody length]] forHTTPHeaderField:@"Content-Length"];
	}
	
	if (requestBody!=nil) {
		[request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSError *error=nil;
	NSHTTPURLResponse *response=nil;
	
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (error!=nil) {
		InfoLog(@"%@/%@", [error localizedDescription], [error localizedFailureReason]);
	}
	[request release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	return responseData;
}

@end
