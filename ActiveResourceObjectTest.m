//
//  ActiveResourceObjectTest.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "ActiveResourceObjectTest.h"


@implementation ActiveResourceObjectTest

-(void)setUp {
	//
}

-(void)tearDown {
	//
}




-(void)testFieldAccessors {
	
	/*
	// This needs to be defined manually in CocoaWagon subclass for now. 
	// It later should be detected automatically if not specified manually by getting fields from XML response after API call. See http://github.com/yves-vogl/CocoaWagon/issues#issue/2
	NSMutableArray *fields = [NSMutableArray new];
	[fields addObject:@"id"];
	[fields addObject:@"foo"];
	[fields addObject:@"woo"];
	[fields addObject:@"hoo"];
		
	
	// Simulating a [CocoaWagon all] and XML parsing at this point...
	
	NSMutableArray *rows = [NSMutableArray new];
	NSDictionary *row;
	NSString *values[4];
	
	
	// Got row 1...
	values[0] = @"3";
	values[1] = @"row 1 foo";
	values[2] = @"row 1 woo";
	values[3] = @"row 1 hoo";
	
	row = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	[row release];
	
	// Got row 2...
	values[0] = @"3";
	values[1] = @"row 2 foo";
	values[2] = @"row 2 woo";
	values[3] = @"row 2 hoo";
	
	row = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	[row release];
	
	
	// Got row 3...
	values[0] = @"3";
	values[1] = @"row 3 foo";
	values[2] = @"row 3 woo";
	values[3] = @"row 3 hoo";
	
	row = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:values count:[fields count]] forKeys:fields];	
	[rows addObject:row];
	[row release];
	
	
	// Continue with processing the (simulated) received results
	
	NSEnumerator *enumerator = [rows objectEnumerator];
	id rowObject;
	
	NSMutableArray *objects = [NSMutableArray new];
	ActiveResourceObject *object;
	
	while (rowObject = [enumerator nextObject]) {
		object = [ActiveResourceObject withPrimaryKey:[[rowObject valueForKey:@"id"] intValue] row:rowObject];	
		[objects addObject:object];		
	}
	
	[enumerator release];
	
	
	// Let's test ’em.
		
	enumerator = [objects objectEnumerator];
	ActiveResourceObject *activeResourceObject;
	
	while (activeResourceObject = [enumerator nextObject]) {
		NSLog(@"%@", [activeResourceObject objectForKey:@"foo"]);
		STAssertTrue([[activeResourceObject valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");
	}
	STAssertTrue([[activeResourceObject valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");

	
	
	//STAssertTrue([[object valueForKey:@"primaryKey"] intValue] == 42, @"Could not read correct value for primary key from dictionary.");
	
	
	
	//STAssertTrue([[object valueForKey:@"foo"] isEqualToString:@"bar"], @"Could not read correct value for generic value from dictionary.");
	
	*/
	
}

@end
