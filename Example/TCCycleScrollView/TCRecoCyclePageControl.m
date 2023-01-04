//
//  TCRecoCyclePageControl.m
//  TinecoCookingRoom
//
//  Created by psh on 2023/1/4.
//

#import "TCRecoCyclePageControl.h"

@interface TCRecoCyclePageControl ()
{
    int _pageNumber;
    int _currentIndex;
}
@property (nonatomic, strong)NSMutableArray *strokeStarts;
@property (nonatomic, strong)CAShapeLayer *progressLayer;

@end

@implementation TCRecoCyclePageControl
- (void)setPageNumber:(int)pageNumber {
    _pageNumber = pageNumber;
    CGFloat per = 0.5/(pageNumber-1);
    for (int i = 0; i<pageNumber; i++) {
        [self.strokeStarts addObject:@(per*i)];
    }
    self.currentIndex = 0;
}
- (int)pageNumber {
    return _pageNumber;
}
- (void)setCurrentIndex:(int)currentIndex {
    _currentIndex = currentIndex;
    
    self.progressLayer.strokeStart = [self.strokeStarts[currentIndex] floatValue];
    self.progressLayer.strokeEnd = [self.strokeStarts[currentIndex] floatValue]+0.5;
}
- (int)currentIndex {
    return _currentIndex;
}
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        _strokeStarts = [[NSMutableArray alloc] init];
        
        CGPoint center = CGPointMake(self.frame.size.width/2.0, -sqrtf((pow(self.frame.size.width/2, 2)+pow(self.frame.size.height*2, 2)))/2-5.5);
        UIBezierPath *bz = [UIBezierPath bezierPathWithArcCenter:center radius:sqrtf((pow(self.frame.size.width/2, 2)+pow(self.frame.size.height*2, 2))) startAngle:-1.35 * M_PI endAngle:-1.65 *M_PI clockwise:NO];
        
        CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
        backgroundLayer.frame = self.bounds;
        backgroundLayer.lineWidth = 4;
        backgroundLayer.fillColor = UIColor.clearColor.CGColor;
        backgroundLayer.strokeColor = UIColor.lightGrayColor.CGColor;
        backgroundLayer.lineCap = kCALineCapRound;
        backgroundLayer.path = bz.CGPath;
        
        [self.layer addSublayer:backgroundLayer];
        
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.lineWidth = 4;
        progressLayer.fillColor = UIColor.clearColor.CGColor;
        progressLayer.strokeColor = UIColor.orangeColor.CGColor;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.path = bz.CGPath;
        [self.layer addSublayer:progressLayer];
        _progressLayer = progressLayer;
        
    }
    return self;
}

@end
