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
@interface TCViewController ()<TCCycleScrollViewDelegate>

@end

@implementation TCViewController
- (NSArray<NSString *> *)imageURLStringsGroup {
    return @[
        @"https://picsum.photos/414/300?random=61",
        @"https://picsum.photos/414/300?random=71",
        @"https://picsum.photos/414/300?random=81",
        @"https://picsum.photos/414/300?random=91",
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
    TCCycleScrollView *cycleView = [TCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, 252) delegate:self placeholderImage:[UIImage imageNamed:@"img_001"] pageControlHighImage:nil pageControlNormalImage:nil];
    cycleView.autoScrollTimeInterval = 1.5;
    [self.view addSubview:cycleView];
    cycleView.imageURLStringsGroup = self.imageURLStringsGroup;
    
    
    TCCycleScrollView *cycleView2 = [TCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0 , 262, self.view.frame.size.width, 252) delegate:self placeholderImage:[UIImage imageNamed:@"img_001"] pageControlHighImage:nil pageControlNormalImage:nil];
    cycleView2.autoScrollTimeInterval = 2.5;
    [self.view addSubview:cycleView2];
    cycleView2.imageURLStringsGroup = self.imageURLStringsGroup2;
    
    TCCycleScrollView *cycleView3 = [TCCycleScrollView cycleScrollViewWithFrame:CGRectMake(0 , CGRectGetMaxY(cycleView2.frame)+10, self.view.frame.size.width, 252) delegate:self placeholderImage:[UIImage imageNamed:@"img_001"] pageControlHighImage:nil pageControlNormalImage:nil];
    cycleView3.autoScrollTimeInterval = 3.5;
    [self.view addSubview:cycleView3];
    cycleView3.imageURLStringsGroup = self.imageURLStringsGroup3;
}
/** 点击图片回调 */
- (void)cycleScrollView:(TCCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    TCViewController *vc = [[TCViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
