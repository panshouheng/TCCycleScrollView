//
//  TCPageControlProtocol.h
//  TCCycleScrollView
//
//  Created by psh on 2023/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCPageControlProtocol <NSObject>
@required
@property(nonatomic, assign)int pageNumber;
@property(nonatomic, assign)int currentIndex;

@optional
@property (nonatomic, strong ,nullable) UIImage *highImage;
@property (nonatomic, strong ,nullable) UIImage *normalImage;
@end

NS_ASSUME_NONNULL_END
