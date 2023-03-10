//
//  TCCycleCell.m
//  TinecoCookingRoom
//
//  Created by psh on 2022/12/29.
//

#import "TCCycleCell.h"
#import <Masonry/Masonry.h>
@implementation TCCycleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}
@end
