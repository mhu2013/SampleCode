#import "ArticleTitleReusableView.h"

@implementation ArticleTitleReusableView
@synthesize articleTitle = _articleTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.articleTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.articleTitle setUserInteractionEnabled:YES];
        [self.articleTitle setTextColor:[UIColor blackColor]];
        [self.articleTitle setTextAlignment:NSTextAlignmentCenter];
        [self.articleTitle setBackgroundColor:[UIColor clearColor]];
        [self.articleTitle setNumberOfLines:0];
        [self.articleTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [self addSubview:self.articleTitle];
    }
    return self;
}


 

@end
