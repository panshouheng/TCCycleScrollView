//
//  TCCycleScrollView.h
//  TinecoCookingRoom
//
//  Created by psh on 2022/12/29.
//

#import <UIKit/UIKit.h>
#import "TCPageControlProtocol.h"
@class TCCycleScrollView;

NS_ASSUME_NONNULL_BEGIN
@protocol TCCycleScrollViewDelegate <NSObject>

@optional
/** 点击图片回调 */
- (void)cycleScrollView:(TCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动回调 */
- (void)cycleScrollView:(TCCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;


/** 如果需要自定义pageControll,实现此协议，返回pageControl实例 */
- (UIView<TCPageControlProtocol> *)customPageControlClassForCycleScrollView:(TCCycleScrollView *)view;
// 不需要自定义轮播cell的请忽略以下两个的代理方法
// ========== 轮播自定义cell ==========
/** 如果你需要自定义cell样式，请在实现此代理方法返回你的自定义cell的class。 */
- (Class)customCollectionViewCellClassForCycleScrollView:(TCCycleScrollView *)view;
/** 如果你自定义了cell样式，请在实现此代理方法为你的cell填充数据以及其它一系列设置 */
- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(TCCycleScrollView *)view;

@end

@interface TCCycleScrollView : UIView

/** 网络图片 url string 数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;
/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;
/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;
/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong, nullable) UIImage *placeholderImage;
/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

@property (nonatomic, weak) id<TCCycleScrollViewDelegate> delegate;


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<TCCycleScrollViewDelegate>)delegate placeholderImage:(UIImage * _Nullable)placeholderImage;

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<TCCycleScrollViewDelegate>)delegate placeholderImage:(UIImage * _Nullable)placeholderImage pageControlHighImage:(UIImage * _Nullable)pageControlHighImage pageControlNormalImage:(UIImage * _Nullable)pageControlNormalImage;
/** 可以调用此方法手动控制滚动到哪一个index */
- (void)makeScrollViewScrollToIndex:(NSInteger)index;
/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

 //  配置pageControl 相关
/// 是否需要显示PageControl 默认显示
@property (nonatomic, assign)BOOL needPageControl;
/** 默认PageControl 配置相应图片，如果自定义pageControl需要也可以进行设置*/
@property (nonatomic, strong)UIImage *pageControlHighImage;
@property (nonatomic, strong)UIImage *pageControlNormalImage;

/** 布局 PageControl*/
- (void)pageControlLeft:(CGFloat)left;
- (void)pageControlRight:(CGFloat)right;
- (void)pageControlBottom:(CGFloat)bottom;
- (void)pageControlCenterX;
- (void)pageControlSize:(CGSize)size;

/// 是否显示遮罩
@property (nonatomic ,assign)BOOL showBannerMask;
/// 遮罩的高度
@property (nonatomic ,assign)CGFloat maskHeight;

- (void)setMaskStartColor:(UIColor *)start endColor:(UIColor *)end;

@end

NS_ASSUME_NONNULL_END
