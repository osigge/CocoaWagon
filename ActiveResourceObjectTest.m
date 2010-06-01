//
//  ActiveResourceObjectTest.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "ActiveResourceObjectTest.h"


@implementation ActiveResourceObjectTest

- (void)testDynamicMethods {
	
	ActiveResourceObject *object = [ActiveResourceObject withPrimaryKey:42];	
	[object setObject:@"foo" forKey:@"bar"];
	
	STAssertTrue([[object valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");
	STAssertTrue([object.primaryKey intValue] == 42, @"Could not read correct value for primary key by acessing the dynamically generated property.");
	STAssertTrue([[object primaryKey] intValue] == 42, @"Could not read correct value for primary key by acessing the dynamically generated method.");
	STAssertTrue([[object valueForKey:@"foo"] isEqualToString:@"bar"], @"Could not read correct value for generic value from dictionary.");
	STAssertTrue([object.foo isEqualToString:@"bar"], @"Could not read correct value for generic value by acessing the dynamically generated property.");
	STAssertTrue([[object foo] isEqualToString:@"bar"], @"Could not read correct value for generic value by acessing the dynamically generated method.");
}

@end
