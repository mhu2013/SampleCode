//
//  WebService.m
//  PulseProject
//
//  Created by Rohan Agarwal on 11/25/12.
//  Copyright (c) 2012 Rohan Agarwal. All rights reserved.
//
// Handle Web Requests here

#import "WebService.h"
#import "ArticleDataObject.h"


@interface WebService()

@property (strong, nonatomic) NSString* urlPath;

-(void) receivedRequest:(NSString*) urlPath;
-(void) getHTTPRequest: (NSString*) url;

@end

@implementation WebService
@synthesize urlPath = _urlPath;
@synthesize allArticles = _allArticles;
@synthesize titleOfFeed = _titleOfFeed;

-(NSMutableArray*) allArticles {
    if (!_allArticles) {
        _allArticles = [[NSMutableArray alloc] init];
    }
    return _allArticles;
}

- (id)init {
    self = [super init];
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRequest:) name:@"RequestData" object:self.urlPath];
    }
    return self;
}

-(void) receivedRequest:(NSNotification*) data {
    [self getHTTPRequest:[data object]];
}


-(void) getHTTPRequest: (NSString*) url {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    
    //get response
	NSHTTPURLResponse* urlResponse;
	NSError *error = [[NSError alloc] init];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
	if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300) {
        [self.allArticles removeAllObjects];
        NSDictionary* data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        // maneuver through data (the JSON) , and create article data objects and add them to self.allArticles
        NSMutableArray* allArticlesOriginal = [[[data valueForKey:@"responseData"] valueForKey:@"feed"] valueForKey:@"entries"];
        for (NSDictionary* individualArticle in allArticlesOriginal) {
            NSMutableDictionary* dataForArticle = [[NSMutableDictionary alloc] init];
            [dataForArticle setValue:[individualArticle valueForKey:@"title"] forKey:@"articleTitle"];
            [dataForArticle setValue:[individualArticle valueForKey:@"author"] forKey:@"author"];
            [dataForArticle setValue:[individualArticle valueForKey:@"content"] forKey:@"content"];
            
            // now the pictures
            for (NSDictionary* pictureData in [[individualArticle valueForKey:@"mediaGroups"] valueForKey:@"contents"]) {
                [dataForArticle setValue:[pictureData valueForKey:@"url"] forKey:@"pictures"];
            }
            ArticleDataObject* articleObj = [[ArticleDataObject alloc] initWithData:dataForArticle];
            [self.allArticles addObject:articleObj];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ReceivedData" object:nil];
    }
    else {
    }
}

@end
