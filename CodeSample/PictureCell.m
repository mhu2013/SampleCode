#import "PictureCell.h"

@interface PictureCell()

@property (strong, nonatomic) UIImage* image;

@end

@implementation PictureCell
@synthesize imageView = _imageView, image = _image;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        // self.imageView.CenterX = self.contentView.CenterX
        NSLayoutConstraint* cn = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
        
        // self.imageView.CenterY = self.contentView.CenterY
        cn = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        [self.contentView addConstraint:cn];
    }
    return self;
}


@end
