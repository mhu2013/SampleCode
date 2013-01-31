//
//  DetailedArticleViewController.m
//  PulseProject
//
//  Created by Rohan Agarwal on 11/25/12.
//  Copyright (c) 2012 Rohan Agarwal. All rights reserved.
//

#import "DetailedArticleViewController.h"

@interface DetailedArticleViewController ()

@property (strong, nonatomic) UILabel* articleTitle;

@end

@implementation DetailedArticleViewController
@synthesize articleTitle = _articleTitle;
@synthesize articleInformation = _articleInformation;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 240, 40)];
    self.articleTitle.text = [self.articleInformation getArticleTitle];
    self.articleTitle.textAlignment = UITextAlignmentCenter;
    self.articleTitle.numberOfLines = 2;
    [self.view addSubview:self.articleTitle];
    
    // show content
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, 320, 480)];
    [webView loadHTMLString:[self.articleInformation getContent] baseURL:nil];
    [self.view addSubview:webView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
