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
	/*
	ActiveResourceObject *object = [ActiveResourceObject withPrimaryKey:42];	
	[object setObject:@"foo" forKey:@"bar"];
	
	STAssertTrue([[object valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");
	STAssertTrue([object.primaryKey intValue] == 42, @"Could not read correct value for primary key by acessing the dynamically generated property.");
	STAssertTrue([[object primaryKey] intValue] == 42, @"Could not read correct value for primary key by acessing the dynamically generated method.");
	STAssertTrue([[object valueForKey:@"foo"] isEqualToString:@"bar"], @"Could not read correct value for generic value from dictionary.");
	STAssertTrue([object.foo isEqualToString:@"bar"], @"Could not read correct value for generic value by acessing the dynamically generated property.");
	STAssertTrue([[object foo] isEqualToString:@"bar"], @"Could not read correct value for generic value by acessing the dynamically generated method.");
	*/
}


- (void)testFieldAccessors {
	
	// This needs to be defined manually in CocoaWagon subclass for now. 
	// It later should be detected automatically if not specified manually by getting fields from XML response after API call. See http://github.com/yves-vogl/CocoaWagon/issues#issue/2
	NSMutableArray *fields = [NSMutableArray new];
	[fields addObject:@"id"];
	[fields addObject:@"foo"];
	[fields addObject:@"woo"];
	[fields addObject:@"hoo"];
		
	
	// Simulating a [CocoaWagon all] and XML parsing at this point...
	
	NSMutableArray *rows = [NSMutableArray new];
	NSString *values[4];
	
	
	// Got row 1...
	values[0] = @"3";
	values[1] = @"row 1 foo";
	values[2] = @"row 1 woo";
	values[3] = @"row 1 hoo";
	
	NSDictionaray *row = [NSDictionaray dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	
	
	// Got row 2...
	values[0] = @"3";
	values[1] = @"row 2 foo";
	values[2] = @"row 2 woo";
	values[3] = @"row 2 hoo";
	
	NSDictionaray *row = [NSDictionaray dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	
	
	// Got row 3...
	values[0] = @"3";
	values[1] = @"row 3 foo";
	values[2] = @"row 3 woo";
	values[3] = @"row 3 hoo";
	
	NSDictionaray *row = [NSDictionaray dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	
	
	// Continue with processing the received results
	
	NSEnumerator *enumerator = [rows objectEnumerator];
	id rowObject;
	
	NSMutableArray *objects = [NSMutableArray new];
	ActiveResourceObject *object;
	
	while (rowObject = [enumerator nextObject]) {
		object = [ActiveResourceObject withPrimaryKey:[[rowObject valueForKey:@"id"] intValue] row:rowObject];	
		[objects addObject:object];		
	}
	
	
	// Let's test ’em.
	
	
	
	
	
	STAssertTrue([[object valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");
	
	
	
	//STAssertTrue([[object valueForKey:@"foo"] isEqualToString:@"bar"], @"Could not read correct value for generic value from dictionary.");
	
	
	
}

@end
