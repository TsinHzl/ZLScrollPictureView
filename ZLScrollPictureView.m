//
//  ZLScrollPictureView.m
//  ZLScrollPictureView
//
//  Created by hezhonglin on 16/7/20.
//  Copyright © 2016年 hezhonglin. All rights reserved.

#import "ZLScrollPictureView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

static CGFloat const ZLTimerInterval = 3.0f;

@interface ZLScrollPictureView()<UIScrollViewDelegate>

@property(nonatomic, strong) NSArray<NSString *> *picNames;
@property(nonatomic, strong) NSArray<NSString *> *picNamesLink;
@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, weak) UIPageControl *pageControl;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ZLScrollPictureView

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.bounds;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        _pageControl = pageControl;
        [self addSubview:pageControl];
    }
    return _pageControl;
}


#pragma mark - 工厂方法
//根据url的工厂方法
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect)frame
{
    return [self scrollPicWithPicsName:picNamesLink frame:frame setPicBlock:^(ZLScrollPictureView *scrollPicView, NSArray<UIButton *> *imageViews, NSArray *newArr) {
        scrollPicView.picNamesLink = picNamesLink.copy;
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:newArr[i]] forState:UIControlStateNormal];
        }
    }];
}
//可以设置pagecontrol的color
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect)frame pageControlCurrentColor:(UIColor *)currentColor pageContorlColor:(UIColor *)tintColor
{
    ZLScrollPictureView *scrollPicView = [self scrollPicWithPicNamesLink:picNamesLink frame:frame];
    
    if (currentColor) {
        scrollPicView.pageControl.currentPageIndicatorTintColor = currentColor;
    }
    if (tintColor) {
        scrollPicView.pageControl.pageIndicatorTintColor = tintColor;
    }
    
    return scrollPicView;
}
//根据图片名称的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame
{
    return [self scrollPicWithPicsName:picsName frame:frame setPicBlock:^(ZLScrollPictureView *scrollPicView, NSArray<UIButton *> *imageViews, NSArray *newArr) {
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView setBackgroundImage:newArr[i] forState:UIControlStateNormal];
        }
    }];
}
//可以改变pagecontrol的color
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame pageControlCurrentColor:(UIColor *)currentColor pageContorlColor:(UIColor *)tintColor
{
    ZLScrollPictureView *scrollPicView = [self scrollPicWithPicsName:picsName frame:frame];
    
    if (currentColor) {
        scrollPicView.pageControl.currentPageIndicatorTintColor = currentColor;
    }
    if (tintColor) {
        scrollPicView.pageControl.pageIndicatorTintColor = tintColor;
    }
    return scrollPicView;
}

//根据图片名称的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame setPicBlock:(SPPicBlock)picBlock
{
    ZLScrollPictureView *scrollPicView = [[self alloc] initWithFrame:frame];
    scrollPicView.picNames = picsName.copy;
    [scrollPicView p_configSubviewsWithpicBlock:picBlock];
    
    return scrollPicView;
}

#pragma mark 内部方法

- (void)p_configSubviewsWithpicBlock:(SPPicBlock)picBlock {
    
    NSMutableArray *newArr = [NSMutableArray array];
    [newArr addObject:self.picNames.lastObject];
    [newArr addObjectsFromArray:self.picNames];
    [newArr addObject:self.picNames.firstObject];
    
    CGRect frame = self.frame;
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = frame.size.width;
    CGFloat imageH = frame.size.height;
    NSInteger count = newArr.count;
    //图片最好添加在pagecontrol之后，不然会显示不出pagecontrol的
    for (NSInteger i = 0; i < count; i++) {
        UIButton *imageView = [[UIButton alloc] init];
        imageView.tag = i;
        [imageView addTarget:self action:@selector(imageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageX = frame.size.width * i;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [self.scrollView addSubview:imageView];
        
    }
    
    [self.scrollView setContentOffset:CGPointMake(imageW, 0) animated:NO];
    
    if (picBlock) {
        picBlock(self,self.scrollView.subviews,newArr);
    }
    
    
    self.pageControl.numberOfPages = self.picNames.count;
    self.pageControl.currentPage = 0;
    self.scrollView.contentSize = CGSizeMake(frame.size.width * count, 0);
    
    if (self.picNames.count > 1) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:ZLTimerInterval target:self selector:@selector(picScroll) userInfo:nil repeats:YES];
    }
}

#pragma mark - 属性设置方法

- (void)setCurrentPageControlColor:(UIColor *)currentPageControlColor {
    if (!currentPageControlColor) {
        NSLog(@"error --- currentPageControlColor为空");
        return;
    }
    
    self.pageControl.currentPageIndicatorTintColor = currentPageControlColor;
    [self.pageControl setNeedsDisplay];
}

- (void)setPageControlColor:(UIColor *)pageControlColor {
    if (!pageControlColor) {
        NSLog(@"error --- pageControlColor为空");
        return;
    }
    
    self.pageControl.pageIndicatorTintColor = pageControlColor;
    [self.pageControl setNeedsDisplay];
}

/// 设置要显示的图片  以图片名的方式
/// @param picsName 图片名数组
- (void)zl_setPicsName:(NSArray <NSString *>*)picsName {
    if (!picsName.count) {
        NSLog(@"error --- picsName为空");
        return;
    }
    
    self.picNames = picsName.copy;
    [self p_configSubviewsWithpicBlock:^(ZLScrollPictureView *scrollPicView, NSArray<UIButton *> *imageViews, NSArray *newArr) {
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView setBackgroundImage:newArr[i] forState:UIControlStateNormal];
        }
    }];
}

/// 设置要显示的图片  以url的方式
/// @param picNamesLink 图片url数组
- (void)zl_setPicNamesLink:(NSArray <NSString *>*)picNamesLink {
    if (!picNamesLink.count) {
        NSLog(@"error --- picNamesLink为空");
        return;
    }
    
    self.picNamesLink = picNamesLink.copy;
    self.picNames = picNamesLink.copy;
    [self p_configSubviewsWithpicBlock:^(ZLScrollPictureView *scrollPicView, NSArray<UIButton *> *imageViews, NSArray *newArr) {
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:newArr[i]] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.frame.size.width;
    
    NSInteger count = (scrollView.contentOffset.x + width * 0.5)/width;
    NSInteger picNum = self.scrollView.subviews.count;
    if (count > 0 && count < picNum - 1) {
        count--;
        self.pageControl.currentPage = count;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self configViewWithScrollView:scrollView];
    
    if (self.pageControl.numberOfPages <= 1) return;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:ZLTimerInterval target:self selector:@selector(picScroll) userInfo:nil repeats:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //    ZLLog(@"----scrollViewDidEndScrollingAnimation-----");
    [self configViewWithScrollView:scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height - 15);
}

- (void)configViewWithScrollView:(UIScrollView *)scrollView {
    CGFloat width = self.frame.size.width;
    
    NSInteger count = (scrollView.contentOffset.x + width * 0.5)/width;
    NSInteger picNum = self.scrollView.subviews.count;
    if (count == 0) {
        [self.scrollView setContentOffset:CGPointMake(width*(picNum - 2), 0) animated:NO];
    }
    
    if (count == picNum - 1) {
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    }
    
    if (count > 0 && count < picNum - 1) {
        count--;
        self.pageControl.currentPage = count;
    }
}

#pragma mark - 定时器方法

- (void)picScroll
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = self.scrollView.contentOffset.x + self.frame.size.width;
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - 按钮/图片 点击方法

- (void)imageViewClicked:(UIButton *)button {
    UIButton *btn = (UIButton *)self.scrollView.subviews[self.pageControl.currentPage + 1];
    if ([self.delegate respondsToSelector:@selector(scrollPictureViewDidClicked:)]) {
        [self.delegate scrollPictureViewDidClicked:btn];
    }
    if (self.picClickedBlock) {
        self.picClickedBlock(btn);
    }
    
}

- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}

@end

