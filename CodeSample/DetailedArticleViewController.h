#import <UIKit/UIKit.h>
#import "ArticleDataObject.h"

@interface DetailedArticleViewController : UIViewController

@property (strong, nonatomic) ArticleDataObject* articleData;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
