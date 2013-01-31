#import <UIKit/UIKit.h>
#import "ServerManager.h"
#import "ImageLoadOperation.h"

@interface MainViewController : UIViewController <FeedRequestDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageLoadOperationResultDelegate>

@property (strong, nonatomic) NSMutableArray* allArticles;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *prevBtn;

@end
