//
//  ICApiRequestController.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICApiRequestController : NSObject

+ (void) getAllDocumentsWithCompletion:(void (^)(NSArray *documents))block;

@end
