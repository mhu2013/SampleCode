//
//  ArticleDataObject.h
//  PulseProject
//
//  Created by Rohan Agarwal on 11/25/12.
//  Copyright (c) 2012 Rohan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDataObject : NSObject

-(ArticleDataObject*) initWithData:(NSDictionary*) articleData;
 
-(NSMutableArray*) getPictureData; // holds NSData objects
-(NSString*) getContent;
-(NSString*) getArticleTitle;
-(NSString*) getAuthorName;


@end
