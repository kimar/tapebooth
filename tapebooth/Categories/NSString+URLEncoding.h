//
//  NSString+URLEncoding.h
//  GastroGuide
//
//  Created by Marcus Kida on 14.12.12.
//  Copyright (c) 2012 Marcus Kida [marcuskida.de]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

@end

