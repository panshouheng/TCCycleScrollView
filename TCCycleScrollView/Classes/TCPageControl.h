//
//  TCPageControl.h
//  TinecoCookingRoom
//
//  Created by psh on 2022/12/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCPageControl : UIStackView

@property (nonatomic, strong) UIImage *highImage;
@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int currentIndex;

- (instancetype)initWithHighImage:(UIImage *)hightImage normalImage:(UIImage *)normalImage;
@end

NS_ASSUME_NONNULL_END
