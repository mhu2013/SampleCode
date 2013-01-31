#import <Foundation/Foundation.h>

@interface ImageStateObject : NSObject

{
    NSURL* imageURL;
    BOOL hasImage;
    BOOL queuedOp;
}

@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) UIImage* screenshotImage;

-(void) setHasImage:(BOOL) hasImageVal;
-(void) setQueuedOp:(BOOL) QueuedOpVal;
-(BOOL) getHasImage;
-(BOOL) getQueuedOp;

@end
