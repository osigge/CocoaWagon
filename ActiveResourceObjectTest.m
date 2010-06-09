//
//  ActiveResourceObjectTest.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "ActiveResourceObjectTest.h"


@implementation ActiveResourceObjectTest

-(void)testFieldAccessors {
	
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
	
		
	NSEnumerator *objectEnumerator = [rows objectEnumerator];
	id rowObject;
	
	NSMutableArray *objects = [[NSMutableArray new] autorelease];
	ActiveResourceObject *object;
	
	while (rowObject = [objectEnumerator nextObject]) {
		object = [ActiveResourceObject withPrimaryKey:[[rowObject objectForKey:@"id"] intValue] row:rowObject wagon:nil];	
		[objects addObject:object];		
	}
	
	
	int index;	
	ActiveResourceObject *activeResourceObject;
	id objectValue;
	NSString *assignedValue;
	
	for (index = 0; index < [objects count]; index++) {			
		
		activeResourceObject = [objects objectAtIndex:index];		
		STAssertEquals(activeResourceObject.primaryKey, [[activeResourceObject objectForKey:@"id"] intValue], @"Primary key doesn't match row value");

		objectValue = [activeResourceObject objectForKey:@"foo"];
		assignedValue = [NSString stringWithFormat:@"row %i foo", index + 1];		
		STAssertTrue([objectValue isEqualToString:assignedValue], [NSString stringWithFormat:@"Object value (%@) doesn't match assigned row value (%@)", objectValue, assignedValue]);		
		[objectValue release];
		//[assignedValue release];
		
		objectValue = [activeResourceObject objectForKey:@"woo"];
		assignedValue = [NSString stringWithFormat:@"row %i woo", index + 1];
		STAssertTrue([objectValue isEqualToString:assignedValue], [NSString stringWithFormat:@"Object value (%@) doesn't match assigned row value (%@)", objectValue, assignedValue]);
		[objectValue release];
		//[assignedValue release];
		
		objectValue = [activeResourceObject objectForKey:@"hoo"];
		assignedValue = [NSString stringWithFormat:@"row %i hoo", index + 1];		
		STAssertTrue([objectValue isEqualToString:assignedValue], [NSString stringWithFormat:@"Object value (%@) doesn't match assigned row value (%@)", objectValue, assignedValue]);
		[objectValue release];
		//[assignedValue release];
	}

}

@end
