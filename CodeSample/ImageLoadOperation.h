#import <Foundation/Foundation.h>

@class ImageLoadOperation;

@protocol ImageLoadOperationResultDelegate <NSObject>

@required
-(void) operationFinished:(ImageLoadOperation*)op;

@end


@interface ImageLoadOperation : NSOperation
{
    int cellIndex;
}

-(ImageLoadOperation*) initWithURL:(NSURL*)imageURL andIndex:(int)index;

@property (weak, nonatomic) id<ImageLoadOperationResultDelegate> resultsDelegate;
@property (strong, nonatomic) UIImage* img;

-(int)getCellIndex;

@end
