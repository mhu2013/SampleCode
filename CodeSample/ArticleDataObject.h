#import <Foundation/Foundation.h>

@interface ArticleDataObject : NSObject

-(ArticleDataObject*) initWithData:(NSDictionary*) articleData;
-(NSMutableArray*) getPictureData; // holds NSURL objects
-(NSString*) getContent;
-(NSString*) getArticleTitle;
-(NSString*) getAuthorName;

@end
