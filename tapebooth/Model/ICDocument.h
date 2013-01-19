//
//  ICDocument.h
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICDocument : NSObject

@property (nonatomic, retain) NSString *documentId;
@property (nonatomic, retain) NSString *publicUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *extension;
@property (nonatomic, retain) NSString *mediaType;
@property (nonatomic, retain) NSString *origin;
@property (nonatomic, retain) NSString *processingStatus;

@property (nonatomic, retain) NSArray *tags;

@property (nonatomic, retain) NSDictionary *meta;

@property (nonatomic, retain) NSNumber *documentSize;
@property (nonatomic, retain) NSNumber *documentShared;
@property (nonatomic, retain) NSNumber *timeAdded;

- (id) initWithDictionary:(NSDictionary *)dictionary;

@end
