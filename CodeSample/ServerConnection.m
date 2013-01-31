#import "ServerConnection.h"

@implementation ServerConnection

@synthesize connection = _connection, request = _request, response = _response, responseData = _responseData, type = _type, delegate = _delegate, retryCount = _retryCount, returnsJSON = _returnsJSON;

- (id) init {
	if(self = [super init]) {
		self.retryCount = 2;
        self.returnsJSON = YES;
	}
	return self;
}

@end
