#import <Foundation/Foundation.h>
#import "TypeDefs.h"

@interface ServerConnection : NSObject


@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) NSMutableData *responseData;
@property ServerConnectionType type;
@property BOOL returnsJSON;
@property (weak, nonatomic) id delegate;
@property NSInteger retryCount; //this is how many times it will requery after the first failure

@end
