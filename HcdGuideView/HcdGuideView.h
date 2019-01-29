//
//  HcdGuideViewManager.h
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HcdGuideView : UIView

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, strong, readonly) UIButton *skipButton;

@property (nonatomic, strong, readonly) UIPageControl *pageControl;

- (void)showGuideViewWithImages:(NSArray *)images;

@end
