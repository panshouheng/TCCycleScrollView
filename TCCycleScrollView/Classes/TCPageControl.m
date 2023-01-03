//
//  TCPageControl.m
//  TinecoCookingRoom
//
//  Created by psh on 2022/12/29.
//

#import "TCPageControl.h"
#import <Masonry/Masonry.h>
@implementation TCPageControl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.spacing = 8;
        self.alignment = UIStackViewAlignmentCenter;
    }
    return self;
}
- (instancetype)initWithHighImage:(UIImage *)hightImage normalImage:(UIImage *)normalImage
{
    self = [self init];
    if (self) {
        self.highImage = hightImage;
        self.normalImage = normalImage;
    }
    return self;
}
- (void)setPageNumber:(int)pageNumber {
    _pageNumber = pageNumber;
    [self.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<pageNumber; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.normalImage highlightedImage:self.highImage];
        [self addArrangedSubview:imageView];
    }
}
- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    [self.arrangedSubviews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.highlighted = currentIndex==idx;
        if(currentIndex == idx) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(obj.highlightedImage.size);
            }];
        } else {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(obj.image.size);
            }];
        }
    }];
}
@end
