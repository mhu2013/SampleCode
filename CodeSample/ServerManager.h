#import <Foundation/Foundation.h>

@protocol FeedRequestDelegate
-(void) receivedFeedData:(NSMutableData*)jsonData;

@end

@interface ServerManager : NSObject

+ (ServerManager *)sharedManager;
-(void) getDataWithDelegate:(id<FeedRequestDelegate>) delegate;

@end
