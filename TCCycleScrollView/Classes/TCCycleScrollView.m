//
//  TCCycleScrollView.m
//  TinecoCookingRoom
//
//  Created by psh on 2022/12/29.
//

#import "TCCycleScrollView.h"
#import "TCCycleCell.h"
#import "TCPageControl.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

#define PageControlBottm 12
#define PageControlRight 16

NSString *const cycleCellIdenfiterID = @"cycleCellIdenfiterID";
@interface TCCycleScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    struct DelegateHas{//由于考虑到自动轮播，会经常性使用respondsToSelector，因此使用结构体进行寄存respondsToSelector的结果
        unsigned int didSelectItemAtIndex : 1;
        unsigned int didScrollToIndex : 1;
        unsigned int willDisplayCell : 1;
        unsigned int customizeCell : 1;
    };
}
@property (nonatomic, weak) UICollectionView *collectionView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, strong)UIView<TCPageControlProtocol>*pageControl;
@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图
@property (nonatomic, assign) struct DelegateHas delegateHas;

@property (nonatomic, assign)int oldCurrentIndex;

@property MASConstraint * pageControlLeftConstraint;
@property MASConstraint * pageControlRightConstraint;
@property MASConstraint * pageControlBottomConstraint;
@property MASConstraint * pageControlSizeConstraint;
@property MASConstraint * pageControlCenterXConstraint;

@property (nonatomic ,strong)CAGradientLayer *gradient;
@property (nonatomic, strong)UIColor *maskStartColor;
@property (nonatomic, strong)UIColor *maskEndColor;

@end

@implementation TCCycleScrollView
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(nonnull id<TCCycleScrollViewDelegate>)delegate placeholderImage:(UIImage * _Nullable)placeholderImage {
    return [self cycleScrollViewWithFrame:frame delegate:delegate placeholderImage:placeholderImage pageControlHighImage:nil pageControlNormalImage:nil];
}
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<TCCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage pageControlHighImage:(UIImage *)pageControlHighImage pageControlNormalImage:(UIImage *)pageControlNormalImage {
    TCCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame delegate:delegate];
    cycleScrollView.needPageControl = YES;
    cycleScrollView.autoScrollTimeInterval = 3;
    cycleScrollView.placeholderImage = placeholderImage ? placeholderImage: [self imageFromColor:UIColor.lightGrayColor forSize:frame.size withCornerRadius:0];
    cycleScrollView.pageControlHighImage = pageControlHighImage ? pageControlHighImage:[self imageFromColor:UIColor.redColor forSize:CGSizeMake(4, 4) withCornerRadius:2];
    cycleScrollView.pageControlNormalImage = pageControlNormalImage ? pageControlNormalImage:[self imageFromColor:UIColor.whiteColor forSize:CGSizeMake(4, 4) withCornerRadius:2];
    
    return cycleScrollView;
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(nullable id<TCCycleScrollViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        _delegate = delegate;
        
        self.backgroundColor = UIColor.clearColor;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout = flowLayout;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[TCCycleCell class] forCellWithReuseIdentifier:cycleCellIdenfiterID];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollsToTop = NO;
        collectionView.backgroundColor = UIColor.clearColor;
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        
        
    }
    return self;
}
- (UIColor *)maskStartColor {
    if(!_maskStartColor) {
        _maskStartColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    };
    return _maskStartColor;
}
- (UIColor *)maskEndColor {
    if(!_maskEndColor) {
        _maskEndColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    return _maskEndColor;
}
- (void)setMaskHeight:(CGFloat)maskHeight {
    _maskHeight = maskHeight;
    self.gradient.frame = CGRectMake(0, 0, self.bounds.size.width, self.maskHeight);
}
- (CAGradientLayer *)gradient {
    if(!_gradient) {
        //渐变设置
        _gradient = [CAGradientLayer layer];
        //设置开始和结束位置(通过开始和结束位置来控制渐变的方向)
        _gradient.startPoint = CGPointMake(0, 0);
        _gradient.endPoint = CGPointMake(0, 1);
        _gradient.colors = [NSArray arrayWithObjects:(id)self.maskStartColor.CGColor, (id)self.maskEndColor.CGColor, nil];
        _gradient.locations = @[@(0.0),@(1.0f)];
        _gradient.frame = CGRectMake(0, 0, self.bounds.size.width, self.maskHeight>0 ? self.maskHeight:self.bounds.size.height);
        [self.layer addSublayer:_gradient];
    }
    return _gradient;
}
- (void)setMaskStartColor:(UIColor *)start endColor:(UIColor *)end {
    self.maskStartColor = start;
    self.maskEndColor = end;
    self.gradient.colors =  [NSArray arrayWithObjects:(id)self.maskStartColor.CGColor, (id)self.maskEndColor.CGColor, nil];
}
- (void)setShowBannerMask:(BOOL)showBannerMask {
    _showBannerMask = showBannerMask;
    if(showBannerMask) {
        self.gradient.hidden = NO;
    } else {
        _gradient.hidden = YES;
    }
}
- (void)setNeedPageControl:(BOOL)needPageControl {
    _needPageControl = needPageControl;
    if(needPageControl) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(customPageControlClassForCycleScrollView:)]) {
            _pageControl = [self.delegate customPageControlClassForCycleScrollView:self];
            if(_pageControl == nil) {
                _pageControl = [[TCPageControl alloc] init];
            }
        } else {
            _pageControl = [[TCPageControl alloc] init];
        }
        [self addSubview:_pageControl];
        [self pageControlCenterX];
        [self pageControlBottom:PageControlBottm];
        [self pageControlSize:_pageControl.bounds.size];
    } else {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
}
- (void)initialization {
    _autoScroll = YES;
    _infiniteLoop = YES;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
}
- (void)setPageControlHighImage:(UIImage *)pageControlHighImage {
    _pageControlHighImage = pageControlHighImage;
    if([_pageControl respondsToSelector:@selector(setHighImage:)]) {
        _pageControl.highImage = pageControlHighImage;
    }
    
}
- (void)setPageControlNormalImage:(UIImage *)pageControlNormalImage {
    _pageControlNormalImage = pageControlNormalImage;
    if([_pageControl respondsToSelector:@selector(setNormalImage:)]) {
        _pageControl.normalImage = pageControlNormalImage;
    }
}
- (void)pageControlLeft:(CGFloat)left {
    if(_pageControlCenterXConstraint) {
        [_pageControlCenterXConstraint uninstall];
    }
    if(_pageControlLeftConstraint) {
        [_pageControlLeftConstraint uninstall];
    }
    if(_pageControlRightConstraint) {
        [_pageControlRightConstraint uninstall];
    }
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        _pageControlLeftConstraint = make.left.mas_equalTo(left);
    }];
}
- (void)pageControlRight:(CGFloat)right {
    if(_pageControlCenterXConstraint) {
        [_pageControlCenterXConstraint uninstall];
    }
    if(_pageControlLeftConstraint) {
        [_pageControlLeftConstraint uninstall];
    }
    if(_pageControlRightConstraint) {
        [_pageControlRightConstraint uninstall];
    }
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        _pageControlRightConstraint = make.right.mas_equalTo(-right);
    }];
}
- (void)pageControlBottom:(CGFloat)bottom {
    if(_pageControlBottomConstraint) {
        [_pageControlBottomConstraint uninstall];
    }
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        _pageControlBottomConstraint =  make.bottom.mas_equalTo(-bottom);
    }];
}
- (void)pageControlSize:(CGSize)size {
    if(_pageControlSizeConstraint) {
        [_pageControlSizeConstraint uninstall];
    }
    if(!CGSizeEqualToSize(size, CGSizeZero)) {
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            _pageControlSizeConstraint = make.size.mas_equalTo(size);
        }];
    }
}
- (void)pageControlCenterX {
    if(_pageControlCenterXConstraint) {
        [_pageControlCenterXConstraint uninstall];
    }
    if(_pageControlLeftConstraint) {
        [_pageControlLeftConstraint uninstall];
    }
    if(_pageControlRightConstraint) {
        [_pageControlRightConstraint uninstall];
    }
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        _pageControlCenterXConstraint = make.centerX.mas_equalTo(self);
    }];
}
- (void)setDelegate:(id<TCCycleScrollViewDelegate>)delegate {
    _delegate = delegate;
    _delegateHas.customizeCell = 0;
    if (delegate && [delegate respondsToSelector:@selector(customCollectionViewCellClassForCycleScrollView:)] && [delegate customCollectionViewCellClassForCycleScrollView:self]) {
        _delegateHas.customizeCell = 1;
        [self.collectionView registerClass:[delegate customCollectionViewCellClassForCycleScrollView:self] forCellWithReuseIdentifier:cycleCellIdenfiterID];
    }
    _delegateHas.didSelectItemAtIndex = delegate && [delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)];
    _delegateHas.didScrollToIndex = delegate && [delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)];
    _delegateHas.willDisplayCell = delegate && [delegate respondsToSelector:@selector(setupCustomCell:forIndex:cycleScrollView:)];
    
}
- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}
- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}
- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    [self setAutoScroll:self.autoScroll];
}
- (void)setImagePathsGroup:(NSArray *)imagePathsGroup {
    [self invalidateTimer];
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 100 : self.imagePathsGroup.count;
    
    if (imagePathsGroup.count > 1) { // 由于 !=1 包含count == 0等情况
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
        self.pageControl.hidden = NO;
    } else {
        self.collectionView.scrollEnabled = NO;
        self.pageControl.hidden = YES;
        [self invalidateTimer];
    }
    
    self.pageControl.pageNumber = (int)imagePathsGroup.count;
    [self.collectionView reloadData];
}
- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}
- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        [self insertSubview:bgImageView belowSubview:self.collectionView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)layoutSubviews {
    self.delegate = self.delegate;
    
    [super layoutSubviews];
    _flowLayout.itemSize = self.frame.size;
    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [self scrollToItemAtIndex:targetIndex animated:NO];
    }
    
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
    }
}
//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
    [self invalidateTimer];
}
#pragma mark - public actions

- (void)adjustWhenControllerViewWillAppera {
    long targetIndex = [self currentIndex];
    if (targetIndex < _totalItemsCount) {
        [self scrollToItemAtIndex:targetIndex animated:NO];
    }
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cycleCellIdenfiterID forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
            if (_delegateHas.customizeCell) {//自定义cell
                if (_delegateHas.willDisplayCell) {
                    [_delegate setupCustomCell:cell forIndex:itemIndex cycleScrollView:self];
                }
                return;
            }
            TCCycleCell *systemCell = (TCCycleCell *)cell;
            NSString *imagePath = self.imagePathsGroup[itemIndex];
            if ([imagePath hasPrefix:@"http"]) {
                [systemCell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
            } else {
                UIImage *image = [UIImage imageNamed:imagePath];
                if (!image) {
                    image = [UIImage imageWithContentsOfFile:imagePath];
                }
                systemCell.imageView.image = image;
            }
            if(systemCell.hasConfigured == NO) {
                systemCell.hasConfigured = YES;
                systemCell.imageView.contentMode = self.bannerImageViewContentMode;
                systemCell.clipsToBounds = YES;
            }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegateHas.didSelectItemAtIndex) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    self.pageControl.currentIndex = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if(self.oldCurrentIndex == indexOnPageControl) return; // 解决宽度有小数时，点击banner时调用的问题
    if (_delegateHas.didScrollToIndex) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
    self.oldCurrentIndex = indexOnPageControl;
}

- (void)makeScrollViewScrollToIndex:(NSInteger)index{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
    if (0 == _totalItemsCount) return;
    
    [self scrollToIndex:(int)(_totalItemsCount * 0.5 + index)];
    
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imagePathsGroup.count;
}
- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)automaticScroll {
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}
- (int)currentIndex {
    if (CGSizeEqualToSize(_collectionView.frame.size, CGSizeZero)) {
        return 0;
    }
    int index =  (_collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;;
    return MAX(0, index);
}
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [_collectionView setContentOffset:CGPointMake(index*_flowLayout.itemSize.width, 0) animated:animated];
}
- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [self scrollToItemAtIndex:targetIndex animated:NO];
        }
        return;
    }
    [self scrollToItemAtIndex:targetIndex animated:YES];
}
- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}
@end
