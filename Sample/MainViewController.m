//
//  MainViewController.m
//  PulseProject
//
//  Created by Rohan Agarwal on 11/25/12.
//  Copyright (c) 2012 Rohan Agarwal. All rights reserved.
//

#import "MainViewController.h"
#import "WebService.h"
#import "DetailedArticleViewController.h"
#import "ArticleDataObject.h"

@interface MainViewController ()
{
    int currentArticle;
    int totalNumberOfArticles;
}
@property (strong, nonatomic) UIActivityIndicatorView* loader;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UILabel* articleTitle;
@property (strong, nonatomic) UILabel* articleNumberDisplay;
@property (strong, nonatomic) WebService* model;
@property (strong, nonatomic) UIButton* rightButton;
@property (strong, nonatomic) UIButton* leftButton;

@end

@implementation MainViewController
@synthesize loader = _loader;
@synthesize scrollView = _scrollView;
@synthesize articleTitle = _articleTitle;
@synthesize articleNumberDisplay = _articleNumberDisplay;
@synthesize rightButton = _rightButton;
@synthesize leftButton = _leftButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];

    // load animating sign
    self.loader = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 190, 40, 40)];
    self.loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.loader startAnimating];
    [self.view addSubview:self.loader];
    
    // add scrollView to hold the pictures
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, 320, 420)];
    [self.scrollView setScrollEnabled:YES];
    [self.view addSubview:self.scrollView];

    self.model = [[WebService alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedData) name:@"ReceivedData" object:nil];
    [self requestData];
}

#pragma mark - Handling Segue

-(void) requestData {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RequestData"
                                                        object:@"https://ajax.googleapis.com/ajax/services/feed/load?q=http://feeds.feedburner.com/ommalik&v=1.0"];
}

-(void) receivedData {
    // data of articles is in self.model.allArticles array
    totalNumberOfArticles = [self.model.allArticles count];
    currentArticle = 1;
    
    self.articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 240, 40)];
    self.articleTitle.text = [[self.model.allArticles objectAtIndex:currentArticle-1] getArticleTitle];
    self.articleTitle.textAlignment = UITextAlignmentCenter;
    self.articleTitle.numberOfLines = 2;
    // make title clickable with a gesture recognizer
    UITapGestureRecognizer* tapTitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTappedOnLink:)];
    [self.articleTitle setUserInteractionEnabled:YES];
    [self.articleTitle addGestureRecognizer:tapTitle];
    [self.view addSubview:self.articleTitle];
    
    // article number fraction
    self.articleNumberDisplay = [[UILabel alloc] initWithFrame:CGRectMake(285, 10, 30, 40)];
    self.articleNumberDisplay.text = [[@"(" stringByAppendingString:[[[NSString stringWithFormat:@"%d", currentArticle] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%d", totalNumberOfArticles]]] stringByAppendingString:@")"];
    self.articleNumberDisplay.textAlignment = UITextAlignmentCenter;
    [self.articleNumberDisplay setFont:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:self.articleNumberDisplay];

    // right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // button colors
    [self.rightButton setFrame:CGRectMake(275, 180, 40, 50)];
    [self.rightButton setAlpha:.6];
    [self.rightButton setTintColor:[UIColor lightGrayColor]];
    // button titlelabel text 
    [self.rightButton setTitle:@">" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.rightButton addTarget:self action:@selector(nextArticle) forControlEvents:UIControlEventTouchUpInside];

    // left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    // button colors
    [self.leftButton setFrame:CGRectMake(5, 180, 40, 50)];
    [self.leftButton setAlpha:.6];
    [self.leftButton setTintColor:[UIColor lightGrayColor]];
    // button titlelabel text
    [self.leftButton setTitle:@"<" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
    [self.leftButton addTarget:self action:@selector(previousArticle) forControlEvents:UIControlEventTouchUpInside];
    
    // check if buttons should be visible
    [self updateNextPreviousButtons];
    [self.view addSubview:self.rightButton];
    [self.view addSubview:self.leftButton];
    
    // start loading pictures
    [self performSelectorInBackground:@selector(loadPictures) withObject:nil];
}

-(void) updateNextPreviousButtons {
    if (currentArticle == totalNumberOfArticles) {
        [self.rightButton setHidden:YES];
    }
    else {
        [self.rightButton setHidden:NO];
    }
    if (currentArticle == 1) {
        [self.leftButton setHidden:YES];
    }
    else {
        [self.leftButton setHidden:NO];
    }

}

-(void) nextArticle {
    currentArticle++;
    [self updateNextPreviousButtons];
    
    // show article
    [self updateArticle];
}
-(void) previousArticle {
    currentArticle--;
    [self updateNextPreviousButtons];
    
    // show article
    [self updateArticle];
    
}

-(void) updateArticle {
    // update title
    self.articleTitle.text = [[self.model.allArticles objectAtIndex:currentArticle-1] valueForKey:@"articleTitle"];
    
    // update article number display
    self.articleNumberDisplay.text = [[@"(" stringByAppendingString:[[[NSString stringWithFormat:@"%d", currentArticle] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%d", totalNumberOfArticles]]] stringByAppendingString:@")"];

    // remove current pictures
    [self removePictures];
    // add new pictures
    [self performSelectorInBackground:@selector(loadPictures) withObject:nil];
}

-(void) loadPictures {
    int xVal = 60; // width is going to be 200
    int yVal = 0; // height will be 200
    for (NSData* imageData in [[self.model.allArticles objectAtIndex:currentArticle-1] getPictureData]) {
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(xVal, yVal, 200, 200);
        [self.scrollView addSubview:imageView];
        yVal += 210;
    }
    [self.scrollView setContentSize:CGSizeMake(200, [[[self.model.allArticles objectAtIndex:currentArticle-1] getPictureData] count]*240)]; // change based on number of pics
    // hide animator
    [self.loader stopAnimating];
}

-(void) removePictures {
    NSArray *viewsToRemove = [self.scrollView subviews];
    for (UIView* viewObj in viewsToRemove) {
        if ([viewObj class] == [UIImageView class]) {
            [viewObj removeFromSuperview];
        }
    }
    [self.loader startAnimating];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender {
    // pass the articleNumber to DetailedViewController to display the correct article!
    DetailedArticleViewController *vc = [segue destinationViewController];
    vc.articleInformation = [self.model.allArticles objectAtIndex:currentArticle-1];
    [segue destinationViewController];
}


-(void)userTappedOnLink:(UIGestureRecognizer*)gestureRecognizer {
    [self performSegueWithIdentifier:@"toDetailedPage" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
