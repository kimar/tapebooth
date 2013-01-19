//
//  ICApiRequestController.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICApiRequestController : NSObject

+ (void) getAccountDataWithCompletion:(void (^)(NSDictionary *account))block;
+ (void) getAllDocumentsWithCompletion:(void (^)(NSArray *documents))block;
+ (void) postDocumentWithJpegData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress andCompletion:(void (^)(BOOL success))block;

@end
