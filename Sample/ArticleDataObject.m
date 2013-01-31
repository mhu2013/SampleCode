//
//  ArticleDataObject.m
//  PulseProject
//
//  Created by Rohan Agarwal on 11/25/12.
//  Copyright (c) 2012 Rohan Agarwal. All rights reserved.
//

#import "ArticleDataObject.h"

@interface ArticleDataObject ()

// private variable for abstraction
@property (strong, nonatomic) NSDictionary* articleData;

@end

@implementation ArticleDataObject

// all the useful data about article.
// number of pictures, picture1, picture2, ... , content, title, author
@synthesize articleData = _articleData;

-(ArticleDataObject*) initWithData:(NSDictionary*) articleData {
    self = [super init];
    if (self) {
        [self setArticleData:articleData];
    }
    return self;
}

-(NSMutableArray*) getPictureData {
    NSMutableArray* allPictures = [[NSMutableArray alloc] init];
    NSData* imageData;
    for (NSString* imageUrl in [self.articleData valueForKey:@"pictures"]) {
        imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        if (imageData != nil)
            [allPictures addObject:imageData];
    }
    return allPictures;
}
-(NSString*) getContent {
    return [self.articleData valueForKey:@"content"];
}
-(NSString*) getArticleTitle {
    return [self.articleData valueForKey:@"articleTitle"]; 
}
-(NSString*) getAuthorName {
    return [self.articleData valueForKey:@"author"];
}


@end
