//
//  NSString+Inflection.m
//  CocoaWagon
//
//  Created by Yves Vogl on 01.06.10.
//  Copyright 2010 DEETUNE. All rights reserved.
//

#import "NSString+Inflection.h"


@implementation NSString(InflectionSupport)

- (NSCharacterSet *)capitals {
	return [NSCharacterSet uppercaseLetterCharacterSet];
}

-(NSString *)underscore {
	
	unichar *buffer = calloc([self length], sizeof(unichar));
	[self getCharacters:buffer];
	
	NSMutableString *underscoredString = [NSMutableString string];
	
	NSString *currentChar;
	
	for (int i = 0; i < [self length]; i++) {
		currentChar = [NSString stringWithCharacters:buffer + i length:1];
		
		if([[self capitals] characterIsMember:buffer[i]]) {
			[underscoredString appendFormat:@"_%@", [currentChar lowercaseString]];
		} else {
			[underscoredString appendString:currentChar];
		}
	}
	
	free(buffer);
	
	return underscoredString;
}

@end
