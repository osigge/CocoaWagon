//
//  TestNSString+Inflection.m
//  CocoaWagon
//
//  Created by Yves Vogl on 03.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "TestNSString+Inflection.h"


@implementation TestNSString_Inflection



-(void)testUnderscoring {	
	STAssertTrue([[@"testString" underscore] isEqualToString:@"test_string"], @"Strings don't match");
	STAssertFalse([[@"testString" underscore] isEqualToString:@"testString"], @"Strings don't match");	
	STAssertTrue([[@"test" underscore] isEqualToString:@"test"], @"Strings don't match");
	STAssertTrue([[@"TestString" underscore] isEqualToString:@"test_string"], @"Strings don't match");
	STAssertFalse([[@"TestString" underscore] isEqualToString:@"testString"], @"Strings don't match");	
	STAssertTrue([[@"Test" underscore] isEqualToString:@"test"], @"Strings don't match");
}

-(void)testSingularization {	
	STAssertTrue([[@"tests" singularize] isEqualToString:@"test"], @"Strings don't match");
	STAssertTrue([[@"test" singularize] isEqualToString:@"test"], @"Strings don't match");	
	STAssertTrue([[@"Tests" singularize] isEqualToString:@"Test"], @"Strings don't match");
	STAssertTrue([[@"Test" singularize] isEqualToString:@"Test"], @"Strings don't match");	
}

-(void)testPluralization {
	STAssertTrue([[@"test" pluralize] isEqualToString:@"tests"], @"Strings don't match");
	STAssertTrue([[@"tests" pluralize] isEqualToString:@"tests"], @"Strings don't match");	
	STAssertTrue([[@"Test" pluralize] isEqualToString:@"Tests"], @"Strings don't match");
	STAssertTrue([[@"Tests" pluralize] isEqualToString:@"Tests"], @"Strings don't match");	
	STAssertTrue([[@"TestS" pluralize] isEqualToString:@"TestS"], @"Strings don't match");	
}

@end
