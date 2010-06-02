//
//  CocoaWagonTest.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "CocoaWagonTest.h"



@implementation CocoaWagonTest

-(void)testInitialization {	
	STAssertThrows([[CocoaWagon alloc] init], @"Should raise exception!");
	STAssertNoThrow([[TestObject alloc] init], @"Should not raise an exception!");	
}

-(void)testCollectionLoading {
	TestObject *testObject = [[TestObject alloc] initWithDelegate:self];
	STAssertNotNil(testObject, @"Could not initialize test object");
	[testObject all];
}

#pragma mark CocoaWagon Delegates

/*
 * See RFC 2616 10 Status Code Definitions for details
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 */
-(void)didFinishWithResults:(NSArray *)results {
		
}

-(void)didFailWithError:(NSError *)error {	
	STAssertNotNil(error, @"Should contain an error");	
}

/*
 * See RFC 2616 10 Status Code Definitions for details
 * http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html
 */
-(void)didRespondWithStatusCode:(NSInteger)statusCode {	
	
	NSRange validStatusCodeRange = NSMakeRange(100, 505);	
	STAssertTrue(NSLocationInRange(statusCode, validStatusCodeRange), @"Every response should have a valid HTTP status code");
	
	/*
	 NSRange validStatusCodeRangeIndicatingSuccess = NSMakeRange(200, 206);	
	 STAssertTrue(NSLocationInRange(statusCode, validStatusCodeRangeIndicatingSuccess), @"Should have a 2xx response code.");
	 */	
}



@end
