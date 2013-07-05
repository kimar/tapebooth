//
//  ICApiRequestController.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [marcuskida.de]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICApiRequestController : NSObject

@property (strong) UIView *view;

+ (id) sharedInstance;

- (void) getAccountDataWithCompletion:(void (^)(NSDictionary *account))block;
- (void) getAllDocumentsWithCompletion:(void (^)(NSArray *documents))block;

- (void) postDocumentWithJpegData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress andCompletion:(void (^)(BOOL success))block;
- (void) postDocumentWithMovData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress andCompletion:(void (^)(BOOL success))block;

- (void) getFileWithDocumentUrl:(NSString *)documentUrl andProgress:(void (^)(long long totalBytesWritten, long long totalBytesExpectedToWrite))progress andCompletion:(void (^)(UIImage *image))block;

@end
