//
//  HTMLParser.h
//
//

#import <Foundation/Foundation.h>
//You have to include in "Build Phases" under "Link Binary With Libraries" the libxml.dylib
//Add ${SDK}/usr/include/libxml2 to "User Header Search Paths" for BOTH PROJECT AND TARGET
#import <libxml/HTMLparser.h>
#import "HTMLNode.h"

@class HTMLNode;

@interface HTMLParser : NSObject 
{
	@public
	htmlDocPtr _doc;
}

-(id)initWithContentsOfURL:(NSURL*)url error:(NSError**)error;
-(id)initWithData:(NSData*)data error:(NSError**)error;
-(id)initWithString:(NSString*)string error:(NSError**)error;

//Returns the doc tag
-(HTMLNode*)doc;

//Returns the body tag
-(HTMLNode*)body;

//Returns the html tag
-(HTMLNode*)html;

@end
