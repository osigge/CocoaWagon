//
//  CocoaWagonTest.h
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <UIKit/UIKit.h>
#import "CocoaWagon.h"
#import "TestObject.h"


@interface CocoaWagonTest : SenTestCase <CocoaWagonDelegate> {

}

-(void)testInitialization;
-(void)testCollectionLoading;


@end
