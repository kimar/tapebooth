//
//  ICOAuthController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICOAuthController.h"

@implementation ICOAuthController
/*
+ (void) requestAccessCodeWithCompletion:(void (^)(BOOL))block
{
    NSString *stUrl = kOAuthApiAuthUrl;
    NSURL *url = [NSURL URLWithString:stUrl];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary *parameters = [[]
    NSMutableURLRequest *afRequest = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                           path:NULL
                                                                     parameters:NULL
                                                      constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {

                                      }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        block(YES);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error.description);
        block(NO);
    }];
    [operation start];
}
*/
@end
