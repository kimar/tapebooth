//
//  ICDocument.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICDocument.h"

/*
 "5620cfdc-27fb-42b1-b662-7b7947ab1a4e": {
 
 "id": "5620cfdc-27fb-42b1-b662-7b7947ab1a4e",
 "public_url": null,
 "name": "T3N - Facebook vs Google (Demo Document)",
 "extension": "pdf",
 "size": 1055783,
 "time_added": 1357816554,
 "media_type": "doc",
 "tags": [ ],
 "origin": "doctape",
 "shared": 0,
 "processing_status": "ok",
 "meta": { }
 
 },
 */

@implementation ICDocument

@synthesize documentId;
@synthesize publicUrl;
@synthesize name;
@synthesize extension;
@synthesize mediaType;
@synthesize origin;
@synthesize processingStatus;

@synthesize tags;

@synthesize meta;

@synthesize documentSize;
@synthesize documentShared;
@synthesize timeAdded;

- (id) initWithDictionary:(NSDictionary *)dictionary
{
    if((self = [super init]))
    {
        // Assign the NSString
        self.documentId = (![[dictionary objectForKey:@"id"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"id"]:@"";
        self.publicUrl = (![[dictionary objectForKey:@"public_url"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"public_url"]:@"";
        self.name = (![[dictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"name"]:@"";
        self.extension = (![[dictionary objectForKey:@"extension"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"extension"]:@"";
        self.mediaType = (![[dictionary objectForKey:@"media_type"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"media_type"]:@"";
        self.origin = (![[dictionary objectForKey:@"origin"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"origin"]:@"";
        self.processingStatus = (![[dictionary objectForKey:@"processing_status"] isKindOfClass:[NSNull class]])?[dictionary objectForKey:@"processing_status"]:@"";

        // Assign the NSArray
        self.tags = ([[dictionary objectForKey:@"tags"] isKindOfClass:[NSArray class]])?[dictionary objectForKey:@"tags"]:[NSArray array];
        
        // Assign the NSDictionary
        self.meta = ([[dictionary objectForKey:@"meta"] isKindOfClass:[NSDictionary class]])?[dictionary objectForKey:@"meta"]:[NSDictionary dictionary];
        
        // Now let's Assign the NSNumbers
        self.documentSize = (![[dictionary objectForKey:@"size"] isKindOfClass:[NSNull class]])?[NSNumber numberWithInt:[[dictionary objectForKey:@"size"] intValue]]:[NSNumber numberWithInt:0];
        self.documentShared = (![[dictionary objectForKey:@"shared"] isKindOfClass:[NSNull class]])?[NSNumber numberWithInt:[[dictionary objectForKey:@"shared"] intValue]]:[NSNumber numberWithInt:0];
        self.timeAdded = (![[dictionary objectForKey:@"time_added"] isKindOfClass:[NSNull class]])?[NSNumber numberWithInt:[[dictionary objectForKey:@"time_added"] intValue]]:[NSNumber numberWithInt:0];
    }
    return self;
}

@end
