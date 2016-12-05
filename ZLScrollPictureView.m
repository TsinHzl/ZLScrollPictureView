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
    ZLScrollPictureView *scrollPicVeiw = [[self alloc] initWithFrame:frame];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = frame.size.width;
    CGFloat imageH = frame.size.height;
    //图片最好添加在pagecontrol之后，不然会显示不出pagecontrol的
    for (NSInteger i = 0; i < picNamesLink.count; i++) {
        UIButton *imageView = [[UIButton alloc] init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:picNamesLink[i]]];
        [imageView sd_setBackgroundImageWithURL:[NSURL URLWithString:picNamesLink[i]] forState:UIControlStateNormal];
        imageView.tag = i;
        [imageView addTarget:scrollPicVeiw action:@selector(imageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        imageX = frame.size.width * i;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [scrollPicVeiw.scrollView addSubview:imageView];
        
    }
    
    scrollPicVeiw.pageControl.numberOfPages = picNamesLink.count;
    scrollPicVeiw.pageControl.currentPage = 0;
    scrollPicVeiw.scrollView.contentSize = CGSizeMake(frame.size.width * picNamesLink.count, 0);
    
    scrollPicVeiw.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:scrollPicVeiw selector:@selector(picScroll) userInfo:nil repeats:YES];
    
    return scrollPicVeiw;
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
    ZLScrollPictureView *scrollPicVeiw = [[self alloc] initWithFrame:frame];
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = frame.size.width;
    CGFloat imageH = frame.size.height;
    //图片最好添加在pagecontrol之后，不然会显示不出pagecontrol的
    for (NSInteger i = 0; i < picsName.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:picsName[i]];
        imageX = frame.size.width * i;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        [scrollPicVeiw.scrollView addSubview:imageView];
        
    }
    
    scrollPicVeiw.pageControl.numberOfPages = picsName.count;
    scrollPicVeiw.pageControl.currentPage = 0;
    scrollPicVeiw.scrollView.contentSize = CGSizeMake(frame.size.width * picsName.count, 0);
    
    scrollPicVeiw.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:scrollPicVeiw selector:@selector(picScroll) userInfo:nil repeats:YES];
    
    return scrollPicVeiw;
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
#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger count = (scrollView.contentOffset.x + self.frame.size.width * 0.5)/self.frame.size.width;
    self.pageControl.currentPage = count;
    
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
    if (self.scrollView.contentOffset.x == self.scrollView.contentSize.width - self.frame.size.width) {
        contentOffset.x = 0;
    }else {
        contentOffset.x = self.scrollView.contentOffset.x + self.frame.size.width;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = contentOffset;
    } completion:^(BOOL finished) {
        
    }];
    
    
}

#pragma mark - 按钮点击方法

- (void)imageViewClicked:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(scrollPictureViewDidClicked:)]) {
        [self.delegate scrollPictureViewDidClicked:button];
    }
}

@end
