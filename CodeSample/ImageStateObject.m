#import "ImageStateObject.h"

@implementation ImageStateObject
@synthesize imageURL = _imageURL;

-(void) setHasImage:(BOOL) hasImageVal {
    hasImage = hasImageVal;
}
-(void) setQueuedOp:(BOOL) QueuedOpVal {
    queuedOp = QueuedOpVal;
}
-(BOOL) getHasImage {
    return hasImage;
}
-(BOOL) getQueuedOp {
    return queuedOp;
}

@end
