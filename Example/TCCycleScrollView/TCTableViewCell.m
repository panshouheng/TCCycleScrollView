//
//  TCTableViewCell.m
//  TCCycleScrollView_Example
//
//  Created by psh on 2023/1/5.
//  Copyright © 2023 panshouheng. All rights reserved.
//

#import "TCTableViewCell.h"
#import <TCCycleScrollView/TCCycleScrollView.h>
@implementation TCTableViewCell
- (NSArray<NSString *> *)imageURLStringsGroup {
    return @[
        @"https://picsum.photos/414/300?random=61",
        @"https://pics1.baidu.com/feed/43a7d933c895d14371cb5ef48fa106095baf0701.jpeg@f_auto?token=1a59ca969ed17c18b786ddd40e35d5d8",
        @"https://picsum.photos/414/300?random=81",
        @"https://picsum.photos/414/300?random=91",
        @"https://picsum.photos/414/300?random=101",
    ];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        TCCycleScrollView *cycleView = [TCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0 , 0, UIScreen.mainScreen.bounds.size.width, 252) delegate:self placeholderImage:[UIImage imageNamed:@"img_001"] pageControlHighImage:nil pageControlNormalImage:nil];
        cycleView.autoScrollTimeInterval = 10;
        [self.contentView addSubview:cycleView];
        cycleView.imageURLStringsGroup = self.imageURLStringsGroup;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
