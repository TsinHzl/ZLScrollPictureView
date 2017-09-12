//
//  ZLScrollPictureView.m
//  ZLScrollPictureView
//
//  Created by hezhonglin on 16/7/20.
//  Copyright © 2016年 hezhonglin. All rights reserved.
//  iOS/mac开发的一些知名个人博客:
//  http://www.cocoachina.com/bbs/read.php?tid=299721

#import "ZLScrollPictureView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

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
    return [self scrollPicWithPicsName:picNamesLink frame:frame setPicBlock:^(NSArray<UIButton *> *imageViews,NSArray *newArr) {
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:newArr[i]] forState:UIControlStateNormal];
        }
    }];
}
//可以设置pagecontrol的color
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect)frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor
{
    ZLScrollPictureView *scrollPicVeiw = [self scrollPicWithPicNamesLink:picNamesLink frame:frame];
    
    if (currentColor) {
        scrollPicVeiw.pageControl.currentPageIndicatorTintColor = currentColor;
    }
    if (tintColor) {
        scrollPicVeiw.pageControl.pageIndicatorTintColor = tintColor;
    }
    
    return scrollPicVeiw;
}
//根据图片名称的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame
{
    return [self scrollPicWithPicsName:picsName frame:frame setPicBlock:^(NSArray<UIButton *> *imageViews,NSArray *newArr) {
        NSInteger count = newArr.count;
        for (NSInteger i = 0; i < count; i++) {
            UIButton *imageView = imageViews[i];
            [imageView setBackgroundImage:newArr[i] forState:UIControlStateNormal];
        }
    }];
}
//可以改变pagecontrol的color
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame pageControlCurrentTintColor:(UIColor *)currentColor pageContorlTintColor:(UIColor *)tintColor
{
    ZLScrollPictureView *scrollPicVeiw = [self scrollPicWithPicsName:picsName frame:frame];
    
    if (currentColor) {
        scrollPicVeiw.pageControl.currentPageIndicatorTintColor = currentColor;
    }
    if (tintColor) {
        scrollPicVeiw.pageControl.pageIndicatorTintColor = tintColor;
    }
    return scrollPicVeiw;
}

//根据图片名称的工厂方法
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect)frame setPicBlock:(void (^)(NSArray<UIButton *> *imageViews,NSArray *newArr))picBlock
{
    NSMutableArray *newArr = [NSMutableArray array];
    [newArr addObject:picsName.lastObject];
    [newArr addObjectsFromArray:picsName];
    [newArr addObject:picsName.firstObject];
    
    ZLScrollPictureView *scrollPicView = [[self alloc] initWithFrame:frame];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = frame.size.width;
    CGFloat imageH = frame.size.height;
    NSInteger count = newArr.count;
    //图片最好添加在pagecontrol之后，不然会显示不出pagecontrol的
    for (NSInteger i = 0; i < count; i++) {
        UIButton *imageView = [[UIButton alloc] init];
        imageView.tag = i;
        [imageView addTarget:scrollPicView action:@selector(imageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        imageX = frame.size.width * i;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [scrollPicView.scrollView addSubview:imageView];
        
    }
    [scrollPicView.scrollView setContentOffset:CGPointMake(imageW, 0) animated:NO];
    picBlock(scrollPicView.scrollView.subviews,newArr);
    
    scrollPicView.pageControl.numberOfPages = picsName.count;
    scrollPicView.pageControl.currentPage = 0;
    scrollPicView.scrollView.contentSize = CGSizeMake(frame.size.width * count, 0);
    
    scrollPicView.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:scrollPicView selector:@selector(picScroll) userInfo:nil repeats:YES];
    
    
    return scrollPicView;
}
#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger count = (scrollView.contentOffset.x + self.frame.size.width * 0.5)/self.frame.size.width;
    NSInteger picNum = self.scrollView.subviews.count;
    if (count == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*(picNum - 2), 0) animated:NO];
    }
    if (count == 4) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    }
    if (count > 0 && count < 4) {
        count--;
        self.pageControl.currentPage = count;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(picScroll) userInfo:nil repeats:YES];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.pageControl.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height - 15);
}

#pragma mark - 定时器方法

- (void)picScroll
{
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x = self.scrollView.contentOffset.x + self.frame.size.width;
    [self.scrollView setContentOffset:contentOffset animated:YES];
    
    
}

#pragma mark - 按钮点击方法

- (void)imageViewClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(scrollPictureViewDidClicked:)]) {
        [self.delegate scrollPictureViewDidClicked:button];
    }
}

@end
