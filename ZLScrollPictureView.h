//
//  ZLScrollPictureView.h
//  ZLScrollPictureView
//
//  Created by hezhonglin on 16/7/20.
//  Copyright © 2016年 hezhonglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLScrollPictureView;

typedef void(^SPPicBlock)(ZLScrollPictureView *scrollPicView, NSArray<UIButton *> *imageViews,NSArray *newArr);

/// 遵循此代理，实现下面方法，可以监听图片点击
@protocol ZLScrollPictureViewDelegate <NSObject>

@optional

/// 图片点击
/// @param button 当前点击图片的按钮
- (void)scrollPictureViewDidClicked:(UIButton *)button;

@end

@interface ZLScrollPictureView : UIView

@property(nonatomic, weak)id<ZLScrollPictureViewDelegate> delegate;

/// 一般的工厂方法，这种方式是以图片名设置图片
/// @param picsName 图片名
/// @param frame    view的frame
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame;

/// 可以改变pagecontrol的indicatorclolor的工厂方法  同样是以图片名设置图片
/// @param picsName 图片名
/// @param frame frame
/// @param currentColor 当前显示图片pageControl的颜色
/// @param tintColor pageContorl未显示图片时的颜色
+ (instancetype)scrollPicWithPicsName:(NSArray *)picsName frame:(CGRect )frame pageControlCurrentColor:(UIColor *)currentColor pageContorlColor:(UIColor *)tintColor;


/// 根据图片的url进行图片的设置的工厂方法
/// @param picNamesLink 图片url(数组)
/// @param frame frame
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame;

/// 可以改变pagecontrol的indicatorclolor的工厂方法  同样是以url设置图片
/// @param picNamesLink 图片url(数组)
/// @param frame fame
/// @param currentColor 当前显示图片pageControl的颜色
/// @param tintColor pageContorl未显示图片时的颜色
+ (instancetype)scrollPicWithPicNamesLink:(NSArray *)picNamesLink frame:(CGRect )frame pageControlCurrentColor:(UIColor *)currentColor pageContorlColor:(UIColor *)tintColor;

#pragma mark 属性

/* 当前显示图片时pageControl的颜色 */
@property (strong, nonatomic) UIColor *currentPageControlColor;
/* 未显示时pageControl的颜色 */
@property (strong, nonatomic) UIColor *pageControlColor;


/// 设置要显示的图片  以图片名的方式
/// @param picsName 图片名数组
- (void)zl_setPicsName:(NSArray <NSString *>*)picsName;

/// 设置要显示的图片  以url的方式
/// @param picNamesLink 图片url数组
- (void)zl_setPicNamesLink:(NSArray <NSString *>*)picNamesLink;

#pragma mark 这个相当于代理方法，响应图片点击事件
@property (copy, nonatomic) void(^picClickedBlock)(UIButton *btn);

@end
