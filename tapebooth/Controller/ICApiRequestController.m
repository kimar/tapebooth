//
//  ICApiRequestController.m
//  tapebooth
//
//  Created by Marcus Kida on 19.01.13.
//  Copyright (c) 2013 Marcus Kida [marcuskida.de]. All rights reserved.
//

#define kProgressStripesColor       [UIColor colorWithRed:0.541 green:0.827 blue:0.388 alpha:1.000]
#define kProgressColor              [UIColor greenColor]

#import "ICApiRequestController.h"

@interface ICApiRequestController ()
{
    AJProgressPanel *_panel;
}
@end

@implementation ICApiRequestController

@synthesize view;

+ (id) sharedInstance
{
    static ICApiRequestController *controller = nil;
    if(!controller)
    {
        controller = [[ICApiRequestController alloc] init];
    }
    return controller;
}

- (void) getAccountDataWithCompletion:(void (^)(NSDictionary *account))block
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
        [ICPrefs setAccessToken:NULL];
        block([NSDictionary dictionary]);
        
    }];
    [operation start];
}

- (void) getAllDocumentsWithCompletion:(void (^)(NSArray *documents))block
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
        [ICPrefs setAccessToken:NULL];
        block([NSArray array]);
        
    }];
    [operation start];
}

- (void) postDocumentWithJpegData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long, long long))progress andCompletion:(void (^)(BOOL))block
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
        [_panel setProgress:dProgress animated:YES];
        
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
                
        [_panel hideAnimated:YES];
        block(YES);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_panel hide];
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        [ICPrefs setAccessToken:NULL];
        block(NO);
        
    }];
    
    _panel = [AJProgressPanel showInView:view];
    [_panel setStripesColor:kProgressStripesColor];
    [_panel setProgressColor:kProgressColor];
    [operation start];
}

- (void) postDocumentWithMovData:(NSData *)data andFilename:(NSString *)filename andProgress:(void (^)(long long, long long))progress andCompletion:(void (^)(BOOL))block
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
                                                                fileName:[NSString stringWithFormat:@"%@.mov", filename]
                                                                mimeType:@"video/mov"];
                                    }
                                    ];
    [request setValue:@"tapebooth" forHTTPHeaderField:@"x-dt-origin-desc"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ICPrefs getAccessToken]] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double expected = [[NSNumber numberWithLongLong:totalBytesExpectedToWrite] doubleValue];
        double written = [[NSNumber numberWithLongLong:totalBytesWritten] doubleValue];
        double dProgress = written/expected;
        [_panel setProgress:dProgress animated:YES];
        
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
        
        [_panel hideAnimated:YES];
        block(YES);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_panel hideAnimated:YES];
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        [ICPrefs setAccessToken:NULL];
        block(NO);
        
    }];
    
    _panel = [AJProgressPanel showInView:view];
    [_panel setStripesColor:kProgressStripesColor];
    [_panel setProgressColor:kProgressColor];
    [operation start];
}

- (void) getFileWithDocumentUrl:(NSString *)documentUrl andProgress:(void (^)(long long, long long))progress andCompletion:(void (^)(UIImage *))block
{
    NSString *stUrl = documentUrl;
    NSURL *url = [NSURL URLWithString:stUrl];
    XLog(@"URL: %@", stUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", [ICPrefs getAccessToken]] forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        [_panel hideAnimated:YES];
        block([UIImage imageWithData:responseObject]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        XLog(@"Failure,ERROR: %@", [error localizedDescription]);
        [ICPrefs setAccessToken:NULL];
        [_panel hideAnimated:YES];
        block(NULL);
        
    }];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        double expected = [[NSNumber numberWithLongLong:totalBytesExpectedToRead] doubleValue];
        double written = [[NSNumber numberWithLongLong:totalBytesRead] doubleValue];
        double dProgress = written/expected;
        [_panel setProgress:dProgress animated:YES];
        
        progress(totalBytesRead, totalBytesExpectedToRead);
    }];
    
    _panel = [AJProgressPanel showInView:view];
    [_panel setStripesColor:kProgressStripesColor];
    [_panel setProgressColor:kProgressColor];
    [operation start];
}

@end
