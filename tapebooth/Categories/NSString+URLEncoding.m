//
//  NSString+URLEncoding.m
//  GastroGuide
//
//  Created by Marcus Kida on 14.12.12.
//  Copyright (c) 2012 Marcus Kida [marcuskida.de]. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding 
{
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (__bridge CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
