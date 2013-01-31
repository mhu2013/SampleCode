#import "MainViewController.h"
#import "TypeDefs.h"
#import "ArticleDataObject.h"
#import "DetailedArticleViewController.h"
#import "PictureCell.h"
#import "ArticleTitleReusableView.h"
#import "ImageStateObject.h"

@interface MainViewController ()

{
    int currentArticle;
    int totalNumberOfArticles;
}

@property (strong, nonatomic) NSOperationQueue* imagesQueue;

@end

@implementation MainViewController
@synthesize allArticles = _allArticles, collectionView = _collectionView, nextBtn = _nextBtn, prevBtn = _prevBtn, imagesQueue = _imagesQueue;

-(NSMutableArray*) allArticles {
    if (!_allArticles) {
        _allArticles = [[NSMutableArray alloc] init];
    }
    return _allArticles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // observe for NSNotication to refresh data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getLatestData)
                                                 name:kGetFeedData
                                               object:nil];
    
    // navigation bar properties
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    //no previous article
    [self.prevBtn setHidden:YES];
    currentArticle = 0;
    
    // set up operation queue
    self.imagesQueue = [[NSOperationQueue alloc] init];
    
    // set up collection view
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:@"PictureCell"];
    [self.collectionView registerClass:[ArticleTitleReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kGetFeedData object:self];
}
-(void) getLatestData {
    [[ServerManager sharedManager] getDataWithDelegate:self];
}
- (IBAction)previousArticle:(id)sender {
    currentArticle--;
    [self updateNextPreviousButtons];
    [self.collectionView reloadData];
}

- (IBAction)nextArticle:(id)sender {
    currentArticle++;
    [self updateNextPreviousButtons];
    [self.collectionView reloadData];
}

-(void) updateNextPreviousButtons {
    if (currentArticle + 1 == totalNumberOfArticles) {
        [self.nextBtn setHidden:YES];
        [self.prevBtn setHidden:NO];
    }
    else if (currentArticle == 0) {
        [self.prevBtn setHidden:YES];
        [self.nextBtn setHidden:NO];
    }
    else {
        [self.prevBtn setHidden:NO];
        [self.nextBtn setHidden:NO];
    }
}

#pragma mark - delegate method
-(void) receivedFeedData:(NSMutableData*)jsonData {
    currentArticle = 0;
    // parse data
    NSError* error;
    NSDictionary* data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    // create article data objects from json
    NSMutableArray* allArticlesOriginal = [[[data valueForKey:@"responseData"] valueForKey:@"feed"] valueForKey:@"entries"];
    for (NSDictionary* individualArticle in allArticlesOriginal) {
        NSMutableDictionary* dataForArticle = [[NSMutableDictionary alloc] init];
        [dataForArticle setValue:[individualArticle valueForKey:@"title"] forKey:@"articleTitle"];
        [dataForArticle setValue:[individualArticle valueForKey:@"author"] forKey:@"author"];
        [dataForArticle setValue:[individualArticle valueForKey:@"content"] forKey:@"content"];
        
        // now the pictures
        for (NSDictionary* pictureData in [[individualArticle valueForKey:@"mediaGroups"] valueForKey:@"contents"]) {
            [dataForArticle setValue:[pictureData valueForKey:@"url"] forKey:@"pictures"];
        }
        ArticleDataObject* articleObj = [[ArticleDataObject alloc] initWithData:dataForArticle];
        [self.allArticles addObject:articleObj];
    }
    totalNumberOfArticles = [self.allArticles count];
    [self.collectionView reloadData];
}

#pragma mark - Data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.allArticles count] == 0) {
        return 0;
    }
    else {
        return [[[self.allArticles objectAtIndex:currentArticle] getPictureData] count];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    cell.imageView.image = [self requestImageForIndex:indexPath.row];
    return cell;
}

-(UIImage*) requestImageForIndex:(int) index {
    ImageStateObject* imageObj = [self imageObjForIndex:index];
    if ([imageObj getHasImage] == NO && [imageObj getQueuedOp] == NO) {
        ImageLoadOperation* op = [[ImageLoadOperation alloc] initWithURL:imageObj.imageURL andIndex:index];
        op.resultsDelegate = self;
        [self.imagesQueue addOperation:op];
        [imageObj setQueuedOp:YES];
        return nil;
    }
    return nil;
}
-(ImageStateObject*) imageObjForIndex:(int)index {
    ImageStateObject* retVal = [[ImageStateObject alloc] init];
    NSURL* appIconPath = [[[self.allArticles objectAtIndex:currentArticle] getPictureData] objectAtIndex:index];
    retVal.imageURL = appIconPath;
    return retVal;
}
-(void) operationFinished:(ImageLoadOperation*)op {
    if ([NSThread isMainThread]) {
        PictureCell* cell = (PictureCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[op getCellIndex] inSection:0]]; // returns nil if cell is off screen
        if (cell && op.img) {
            cell.imageView.image = op.img;
            [cell sizeToFit];
            [cell setNeedsDisplay];
        }
        ImageStateObject* imageObj = [self imageObjForIndex:[op getCellIndex]];
        [imageObj setScreenshotImage:op.img];
        [imageObj setQueuedOp:NO];
        [imageObj setHasImage:(op.img != nil)];
    }
    else {
        [self performSelectorOnMainThread:@selector(operationFinished:) withObject:op waitUntilDone:NO]; // not recursive
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ArticleTitleReusableView* supplementaryView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"title" forIndexPath:indexPath];
    if ([self.allArticles count] > 0) {
        NSString* articleTitleName = [[self.allArticles objectAtIndex:currentArticle] getArticleTitle];
        [supplementaryView.articleTitle setText:articleTitleName];
    }
    else {
        [supplementaryView.articleTitle setText:@"Loading..."];
    }

    // add gesture recognizer
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTapped:)];
    [supplementaryView addGestureRecognizer:recognizer];
    
    return supplementaryView;
}
- (IBAction)sectionTapped:(UITapGestureRecognizer *)recognizer
{
    [self performSegueWithIdentifier:@"toDetailedPage" sender:nil];
}
#pragma mark - Flow Layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(120, 120);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(320, 120);
    if ([self.allArticles count] > 0) {
        return CGSizeMake(320, 120);
    }
    else {
        return CGSizeMake(0, 0);
    }
}

#pragma mark - segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender {
    if ([segue.identifier isEqualToString:@"toDetailedPage"]) {
        DetailedArticleViewController* vc = [segue destinationViewController];
        vc.articleData = [self.allArticles objectAtIndex:currentArticle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
