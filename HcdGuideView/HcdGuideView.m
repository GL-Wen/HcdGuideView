//
//  HcdGuideViewManager.m
//  HcdGuideViewDemo
//
//  Created by polesapp-hcd on 16/7/12.
//  Copyright © 2016年 Polesapp. All rights reserved.
//

#import "HcdGuideView.h"
#import "HcdGuideViewCell.h"
#import "Masonry.h"

@interface HcdGuideView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *images;

@end

@implementation HcdGuideView
@synthesize button = _button, pageControl = _pageControl, skipButton = _skipButton;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    [self addSubview:self.collectionView];
    [self addSubview:self.button];
    [self addSubview:self.pageControl];
    [self addSubview:self.skipButton];

    float offset = 0;
    if (@available(iOS 11.0, *)) {
        offset = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-(52 + offset));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    offset = 0;
    if (@available(iOS 11.0, *)) {
        offset = UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
    }
    offset = offset > 0 ? offset : 20;
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(self).offset(offset);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)showGuideViewWithImages:(NSArray *)images
{
    self.images = images;
    self.pageControl.numberOfPages = images.count;
    
    if (nil == self.window) {
        self.window = [UIApplication sharedApplication].keyWindow;
    }
    
    [self.collectionView reloadData];
    [self.window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window);
    }];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    HcdGuideViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell forIndexPath:indexPath];
    
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    CGSize size = [self adapterSizeImageSize:img.size compareSize:kHcdGuideViewBounds.size];
    
    //自适应图片位置,图片可以是任意尺寸,会自动缩放.
    cell.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    cell.imageView.image = img;
    cell.imageView.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height / 2);
    
    return cell;
}

/**
 *  计算自适应的图片
 *
 *  @param is 需要适应的尺寸
 *  @param cs 适应到的尺寸
 *
 *  @return 适应后的尺寸
 */
- (CGSize)adapterSizeImageSize:(CGSize)is compareSize:(CGSize)cs
{
    CGFloat w = cs.width;
    CGFloat h = cs.width / is.width * is.height;
    
    if (h < cs.height) {
        w = cs.height / h * w;
        h = cs.height;
    }
    return CGSizeMake(w, h);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentSize.width - scrollView.contentOffset.x - kHcdGuideViewBounds.size.width;
    
    CGFloat alpha = (1 - offset / kHcdGuideViewBounds.size.width);
    self.button.alpha = alpha;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x / kHcdGuideViewBounds.size.width);
    
    self.pageControl.currentPage = index;
    self.skipButton.hidden       = (index == (self.images.count - 1));
}

#pragma mark - Action

/**
 *  点击立即体验按钮响应事件
 *
 *  @param sender sender
 */
- (void)btnAction
{    
    [self removeFromSuperview];
}

#pragma mark - Get

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        _button.alpha = 0;
    }
    return _button;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

/**
 *  初始化pageControl
 *
 *  @return pageControl
 */
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame  = CGRectMake(0, 0, kHcdGuideViewBounds.size.width, 44.0f);
        _pageControl.center = CGPointMake(kHcdGuideViewBounds.size.width / 2, kHcdGuideViewBounds.size.height - 60);
    }
    return _pageControl;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = kHcdGuideViewBounds.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:kHcdGuideViewBounds collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[HcdGuideViewCell class] forCellWithReuseIdentifier:kCellIdentifier_HcdGuideViewCell];
    }
    return _collectionView;
}

@end
