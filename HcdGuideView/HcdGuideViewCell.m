//
//  HcdGuideViewCell.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideViewCell.h"
#import "HcdGuideView.h"

@interface HcdGuideViewCell()

@end

@implementation HcdGuideViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.layer.masksToBounds = YES;
    self.imageView = [[UIImageView alloc]initWithFrame:kHcdGuideViewBounds];
    self.imageView.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height / 2);
    
    [self.contentView addSubview:self.imageView];    
}

@end
