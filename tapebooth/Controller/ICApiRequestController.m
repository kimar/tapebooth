//
//  ICApiRequestController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICApiRequestController.h"

@implementation ICApiRequestController

+ (void) getAllDocumentsWithCompletion:(void (^)(NSArray *documents))block
{
    NSString *stUrl = [NSString stringWithFormat:@"https://api.doctape.com/v1/doc"];
    NSURL *url = [NSURL URLWithString:stUrl];
    XLog(@"URL: %@", stUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ICPrefs getAccessToken]] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        if(!error)
        {
            XLog(@"Success: %@", JSON);
            
            if([[JSON objectForKey:@"result"] isKindOfClass:[NSDictionary class]])
            {
                NSMutableArray *documents = [[NSMutableArray alloc] init];
                for (NSString *key in [[JSON objectForKey:@"result"] allKeys])
                {
                    NSDictionary *dictionary = [[JSON objectForKey:@"result"] objectForKey:key];
                    ICDocument *document = [[ICDocument alloc] initWithDictionary:dictionary];
                    [documents addObject:document];
                }
                
                block(documents);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        block([NSArray array]);
        
    }];
    [operation start];
}

@end
