//
//  PaginationProtocol.h
//  CocoaWagon
//
//  Created by Yves Vogl on 08.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PaginationProtocol

@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) NSInteger totalPages;

-(NSString *)parameterName;
-(BOOL)nextPage;
-(BOOL)previousPage;
-(NSURL *)pageURL:(NSInteger)page;

@end
