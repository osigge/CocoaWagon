//
//  TestNSString+Inflection.h
//  CocoaWagon
//
//  Created by Yves Vogl on 03.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CocoaWagon.h"


@interface TestNSString_Inflection : SenTestCase {

	NSString *testString;
	
}

-(void)testUnderscoring;
-(void)testSingularization;
-(void)testPluralization;

@end
