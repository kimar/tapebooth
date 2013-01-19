//
//  ICApiRequestController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [indiecoder.net]. All rights reserved.
//

#import "ICApiRequestController.h"

@implementation ICApiRequestController

+ (void) getAccountDataWithCompletion:(void (^)(NSDictionary *account))block
{
    NSString *stUrl = [NSString stringWithFormat:@"https://api.doctape.com/v1/account"];
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
                NSDictionary *dictionary = [JSON objectForKey:@"result"];
                block(dictionary);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        block([NSDictionary dictionary]);
        
    }];
    [operation start];
}

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

+ (void) postDocumentWithJpegData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long, long long))progress andCompletion:(void (^)(BOOL))block
{
    NSString *stUrl = [NSString stringWithFormat:@"https://api.doctape.com/v1/doc/upload"];
    NSURL *url = [NSURL URLWithString:stUrl];
    XLog(@"URL: %@", stUrl);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:NULL
                                                                   parameters:NULL
                                                    constructingBodyWithBlock:^(id <AFMultipartFormData>formData)
                                      {
                                          [formData appendPartWithFileData:data
                                                                      name:@"file"
                                                                  fileName:[NSString stringWithFormat:@"%@.jpg", filename]
                                                                  mimeType:@"image/jpeg"];
                                      }
                                      ];
    [request setValue:@"tapebooth" forHTTPHeaderField:@"x-dt-origin-desc"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ICPrefs getAccessToken]] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double expected = [[NSNumber numberWithLongLong:totalBytesExpectedToWrite] doubleValue];
        double written = [[NSNumber numberWithLongLong:totalBytesWritten] doubleValue];
        double dProgress = written/expected;
        [BWStatusBarOverlay setProgress:dProgress animated:YES];
        
        progress(totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        if(!error)
        {
            XLog(@"Success: %@", JSON);
        }
        
        [BWStatusBarOverlay dismissAnimated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        block(NO);
        
    }];
    
    [BWStatusBarOverlay showLoadingWithMessage:@"Uploading photo..." animated:YES];
    [operation start];
}

@end
