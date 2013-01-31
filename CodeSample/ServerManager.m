#import "ServerManager.h"
#import "ServerConnection.h"

@interface ServerManager()

@property (strong, nonatomic) ServerConnection* getFeedConnection;

@end

@implementation ServerManager

#pragma mark - Singleton Enforcement

static ServerManager *sharedManager = nil;

- (id) init {
	if ( sharedManager != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"Cannot initialize a ServerManager directly. Use [ServerManager sharedManager]"];
	}
    else if ( self = [super init] ) {
	}
	return self;
}

+ (ServerManager *)sharedManager {
	@synchronized(self) {
		if(sharedManager == nil) {
			sharedManager = [[self alloc] init]; //sets the sharedManager automatically
		}
	}
	return sharedManager;
}

-(void) getDataWithDelegate:(id<FeedRequestDelegate>) delegate {
    if (self.getFeedConnection) {
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.getFeedConnection = [[ServerConnection alloc] init];
    self.getFeedConnection.type = ServerConnectionTypeGetFeed;
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kFeedURL]];
    [urlRequest setHTTPMethod:@"GET"];
    self.getFeedConnection.request = urlRequest;
    
    self.getFeedConnection.responseData = [[NSMutableData alloc] init];
    self.getFeedConnection.delegate = delegate;
	self.getFeedConnection.connection = [NSURLConnection connectionWithRequest:self.getFeedConnection.request delegate:self];
	if(self.getFeedConnection.connection == nil)
		NSLog(@"Connection error. Couldn't initialize connection with url: %@", kFeedURL);
}

#pragma mark - NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == self.getFeedConnection.connection) {
        [self.getFeedConnection.responseData appendData:data];
    }
    else {
        NSLog(@"invalid connection type in didRecieveData, programmer error");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.getFeedConnection.connection) {
		self.getFeedConnection.response = response;
	}
    else {
        NSLog(@"invalid connection type in didReceiveResponse, programmer error");
    }
}

- (void)connection:(NSURLConnection *)urlConnection didFailWithError:(NSError *)error {
    ServerConnection* connection;
    if (urlConnection == self.getFeedConnection.connection) {
        connection = self.getFeedConnection;
    }
    else {
        NSLog(@"invalid connection type in didFailWithError, programmer error");
    }
    connection.response = nil;
	connection.responseData = nil;
	[self connectionDidFinishLoading:connection.connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlConnection {
    ServerConnection* connection;
    if (urlConnection == self.getFeedConnection.connection) {
        connection = self.getFeedConnection;
    }
    else {
        NSLog(@"invalid connection type in didFinishLoading, programmer error");
    }
    int statusCode = [((NSHTTPURLResponse*) connection.response) statusCode];
    if (!(statusCode >= 200 && statusCode < 300)) {
        NSLog(@"Bad status code: %d", statusCode);
    }
    else { // good response
        if (connection.returnsJSON) {
            if (connection.type == ServerConnectionTypeGetFeed) {
                [connection.delegate receivedFeedData:connection.responseData];
            }
            else {
                NSLog(@"Invalid connection type in returnsJSON");
            }
        }
        else {
            NSLog(@"Invalid case, programmer error.");
        }
        
        // nil the connection
        if(urlConnection == self.getFeedConnection.connection) {
            self.getFeedConnection = nil;
        }
        else {
            NSLog(@"invalid connection type in releasing connections, programmer error");
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
