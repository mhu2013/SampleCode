//
//  ServerConnection.h
//  PulseProject
//
//  Created by Rohan Agarwal on 1/30/13.
//  Copyright (c) 2013 Rohan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnection : NSObject

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSString *unauthorizedURL;
@property BSLServerConnectionType type;
@property BOOL returnsXML;
@property (weak, nonatomic) id delegate;
@property NSInteger retryCount; //this is how many times it will requery after the first failure


@end
