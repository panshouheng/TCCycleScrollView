//
//  TCCustomCell.m
//  TCCycleScrollView_Example
//
//  Created by psh on 2023/1/5.
//  Copyright © 2023 panshouheng. All rights reserved.
//

#import "TCCustomCell.h"
#import <Masonry/Masonry.h>
@implementation TCCustomCell

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
