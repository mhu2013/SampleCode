#import "DetailedArticleViewController.h"

@interface DetailedArticleViewController ()

@end

@implementation DetailedArticleViewController
@synthesize articleData = _articleData, webView = _webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.webView loadHTMLString:[self.articleData getContent] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
