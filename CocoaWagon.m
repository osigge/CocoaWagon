//
//  CocoaWagon.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagon.h"
#import "NSString+Inflection.h"

@implementation CocoaWagon

static NSString *baseURLString;

@synthesize theConnection, receivedData, apiKey, fields;

-(id)init {	
	self = [super init];
	
	if (self != nil) {
		if ([[self class] isEqual:[CocoaWagon class]]) {
			[NSException raise:@"Abstract Class Exception" format:@"Error, attempting to instantiate CocoaWagon directly."];
			[self release]; 
			return nil; 
		}
		
		self.fields = [NSArray arrayWithObject:@"id"];
	}
	
	return self;	
}

-(id)initWithDelegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self init];
	
	if (self != nil) {
		delegate = theDelegate;
	}
	
	return self;	
}


-(id)initWithApiKey:(NSString *)aKey delegate:(NSObject <CocoaWagonDelegate> *)theDelegate {
	
	self = [self initWithDelegate:theDelegate];
	
	if (self != nil) {
		self.apiKey = aKey;
	}
	
	return self;
}

-(void)dealloc {	
	delegate = nil;
	self.apiKey = nil;
	self.fields = nil;
	[super dealloc];	
}

+(void)setBaseURLString:(NSString *)aBaseURLString  {
	
	if (aBaseURLString != baseURLString) {
		[baseURLString release];
		baseURLString = [aBaseURLString retain];
	}

}

+(NSString *)baseURLString {
	return [[baseURLString retain] autorelease];
}


#pragma mark API Methods

-(BOOL)all {
	
	// ToDo: Send API key if it's present
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[self resourcesURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		receivedData = [[NSMutableData data] retain];
		
		if ([delegate respondsToSelector:@selector(didSendRequest:)] ) {
			[delegate didSendRequest:theRequest];
		}
		
	} else {		
		if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
			
			NSError *error = [NSError errorWithDomain:@"Could not establish connection." 
												 code:-1 
											 userInfo:[NSDictionary dictionaryWithObject:theRequest forKey:@"request"]];			
			
			[delegate didFailWithError:error];
			return NO;
		}		
	}
	
	return YES;
}


#pragma mark NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
	
	if ([delegate respondsToSelector:@selector(didReceiveResponse:)] ) {
		[delegate didReceiveResponse:response];
	}
	
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	if ([delegate respondsToSelector:@selector(didReceiveData:)] ) {
		[delegate didReceiveData:data];
	}
	
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    [connection release];
    [receivedData release];
	
	if ([delegate respondsToSelector:@selector(didFailWithError:)] ) {
		[delegate didFailWithError:error];
	}	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	if ([delegate respondsToSelector:@selector(willProcessData:)] ) {
		[delegate willProcessData:receivedData];
	}	
	
	[self processData:receivedData];
	
    [connection release];
    [receivedData release];
}


#pragma mark XML processing

-(void)processData:(NSData *)data {
	
}


#pragma mark ActiveResource Protocol
						
-(NSString *)resourceBaseURL {
	return [CocoaWagon baseURLString];
}

/*
 * Resource name will be derived from class name
 */
-(NSString *)resourceName {
	// ToDo: pluralize
	return [[[self class] description] underscore];
}

/*
 * Communication format.
 */
-(NSString *)format {
	return @"xml";
}

-(NSURL *)resourcesURL {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.%@", [self resourceBaseURL], [self resourceName], [self format]]];
}



@end
