#import "ImageLoadOperation.h"

@interface ImageLoadOperation()

@property (strong, nonatomic) NSURL* pathToImage;

@end

@implementation ImageLoadOperation

-(ImageLoadOperation*) initWithURL:(NSURL*)imageURL andIndex:(int)index {
    self = [super init];
    if (self) {
        self.pathToImage = imageURL;
        cellIndex = index;
    }
    return self;
}

-(void) main {
    NSData* imageData = [[NSData alloc]initWithContentsOfURL:self.pathToImage];
    self.img = [UIImage imageWithData:imageData];
    [self.resultsDelegate operationFinished:self];
}

-(int)getCellIndex {
    return cellIndex;
}

@end
