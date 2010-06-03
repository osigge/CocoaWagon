//
//  TestNSString+Inflection.m
//  CocoaWagon
//
//  Created by Yves Vogl on 03.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "TestNSString+Inflection.h"


@implementation TestNSString_Inflection


-(void)setUp {
	testString = [[NSString alloc] initWithString:@"testString"];
}


-(void)tearDown {
	[testString release];
}

-(void)testUnderscoring {	
	STAssertTrue([[testString underscore] isEqualToString:@"test_string"], @"Strings don't match");
	STAssertFalse([[testString underscore] isEqualToString:@"testString"], @"Strings don't match");	
}

-(void)testSingularization {
}

-(void)testPluralization {
}

@end
