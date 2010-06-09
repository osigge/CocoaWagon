//
//  RequestParameter.m
//  CocoaWagon
//
//  Created by Yves Vogl on 09.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "RequestParameter.h"

@implementation NSString (URLEncodingAdditions)

- (NSString *)URLEncodedString  {
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)self,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    return [result autorelease];	
}

- (NSString*)URLDecodedString {
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
	return [result autorelease];	
}

@end


@implementation RequestParameter


@synthesize name, value, scope;

+ (id)requestParameterWithName:(NSString *)aName value:(NSString *)aValue {
	return [[[RequestParameter alloc] initWithName:aName value:aValue] autorelease];
}

- (id)initWithName:(NSString *)aName value:(NSString *)aValue {
    if (self = [self init]) {
		self.name = aName;
		self.value = aValue;
	}
    return self;
}

- (id)initWithName:(NSString *)aName value:(NSString *)aValue scope:(NSString *)aScope {
    if (self = [self initWithName:aName value:aValue]) {
		self.scope = aScope;
	}
    return self;
}

- (void)dealloc {
	self.name = nil;
	self.value = nil;
	self.scope = nil;
	[super dealloc];
}

- (NSString *)URLEncodedName {
	return [self.name URLEncodedString];
}

- (NSString *)URLEncodedValue {
    return [self.value URLEncodedString];
}

- (NSString *)URLEncodedNameValuePair {
    return [NSString stringWithFormat:@"%@=%@", [self URLEncodedName], [self URLEncodedValue]];
}

- (NSString *)scopedURLEncodedNameValuePair {
	return [NSString stringWithFormat:@"%@[%@]=%@", self.scope, [self URLEncodedName], [self URLEncodedValue]];
}

@end
