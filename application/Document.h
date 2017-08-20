/*
 *  Document.h
 *  BankBalance
 *
 *  Created by Damien Mac Fhlannchaidh on 05/05/2010.
 *  Copyright 2010 Damien Mac Fhlannchaidh Cubed. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#import "DocumentElement.h"

@interface Document : NSObject {
	NSData * data;
	BOOL isXML;
}

- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithHTMLData:(NSData *)theData;
- (id) initWithXMLData:(NSData *)theData;
- (NSArray *) search:(NSString *)xPathOrCSS;
- (DocumentElement *) at:(NSString *)xPathOrCSS;

@property (retain) NSData * data;

@end