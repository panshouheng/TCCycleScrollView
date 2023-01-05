//
//  TCViewController.m
//  TCCycleScrollView
//
//  Created by panshouheng on 01/03/2023.
//  Copyright (c) 2023 panshouheng. All rights reserved.
//

#import "TCViewController.h"
#import <TCCycleScrollView/TCCycleScrollView.h>
#import <Masonry/Masonry.h>
#import "TCRecoCyclePageControl.h"
#import "TCCustomCell.h"
#import <SDWebImage/SDWebImage.h>
#import "TCTableViewController.h"
@interface TCViewController ()<TCCycleScrollViewDelegate>

@end

@implementation TCViewController
- (NSArray<NSString *> *)imageURLStringsGroup {
    return @[
        @"https://picsum.photos/414/300?random=61",
        @"https://pics1.baidu.com/feed/43a7d933c895d14371cb5ef48fa106095baf0701.jpeg@f_auto?token=1a59ca969ed17c18b786ddd40e35d5d8",
        @"https://p.upyun.com/demo/webp/animated-gif/0.gif",
        @"https://p.upyun.com/demo/webp/webp/animated-gif-0.webp",
        @"https://picsum.photos/414/300?random=101",
    ];
}
- (NSArray<NSString *> *)imageURLStringsGroup2 {
    return @[
        @"https://picsum.photos/414/300?random=11",
        @"https://picsum.photos/414/300?random=21",
        @"https://picsum.photos/414/300?random=31",
        @"https://picsum.photos/414/300?random=41",
        @"https://picsum.photos/414/300?random=51",
    ];
}
- (NSArray<NSString *> *)imageURLStringsGroup3 {
    return @[
        @"https://picsum.photos/414/300?random=111",
        @"https://picsum.photos/414/300?random=211",
        @"https://picsum.photos/414/300?random=311",
        @"https://picsum.photos/414/300?random=411",
        @"https://picsum.photos/414/300?random=511",
    ];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    TCCycleScrollView *cycleView = [TCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0 , 0, UIScreen.mainScreen.bounds.size.width, 252) delegate:self placeholderImage:[UIImage imageNamed:@"img_001"] pageControlHighImage:nil pageControlNormalImage:nil];
    cycleView.autoScrollTimeInterval = 10;
    [self.view addSubview:cycleView];
    cycleView.imageURLStringsGroup = self.imageURLStringsGroup;
}
///** 点击图片回调 */
- (void)cycleScrollView:(TCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectItemAtIndex%ld",index);
    TCTableViewController *tabVC = [[TCTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tabVC animated:YES];
}
//- (void)cycleScrollView:(TCCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//    NSLog(@"didScrollToIndex_%ld",index);
//}
- (Class)customCollectionViewCellClassForCycleScrollView:(TCCycleScrollView *)view {
    return TCCustomCell.class;
}
- (void)setupCustomCell:(TCCustomCell *)cell forIndex:(NSInteger)index cycleScrollView:(TCCycleScrollView *)view {
    NSLog(@"forIndex_%ld",index);
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLStringsGroup[index]]];
}
//- (UIView<TCPageControlProtocol> *)customPageControlClassForCycleScrollView:(TCCycleScrollView *)view {
//    return [[TCRecoCyclePageControl alloc] initWithFrame:CGRectMake(0, 0, 32, 8)];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
