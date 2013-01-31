#import "ArticleDataObject.h"

@interface ArticleDataObject ()

@property (strong, nonatomic) NSDictionary* articleData;

@end

@implementation ArticleDataObject
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
    for (NSString* imageUrl in [self.articleData valueForKey:@"pictures"]) {
        NSURL* url = [NSURL URLWithString:imageUrl];
        [allPictures addObject:url];
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
