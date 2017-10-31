//
//  UIView+FXOverlayCornerRadius.h
//  FXKit
//
//  Created by ShawnFoo on 2017/10/17.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 通过生成与背景颜色同色的镂空图片覆盖在View上来实现"圆角", 无离屏渲染
 注: 仅限位于纯色背景且无内容变化的父视图上的子View使用, 比如视频直播上的子View使用这种方法会看出覆盖的圆角层, 跟悬浮view不能使用.
 
 不带size参数的方法, 会默认读取view.bounds.size作为遮罩层的大小
 */
@interface UIView (FXOverlayCornerRadius)

/**
 添加圆角遮罩层
 @param radius 半径
 @param size 所需覆盖的视图size
 @param bgColor 视图的父view背景颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor;

/**
 添加圆角遮罩层, 可指定形圆角位置
 
 @param radius 半径
 @param size 所需覆盖的视图size
 @param bgColor 视图的父view背景颜色
 @param corners UIRectCorner视图的圆角位置
 */
- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners;


/**
 添加圆角遮罩层, 可添加圆角边框(宽度, 颜色)
 
 @param radius 半径
 @param size 所需覆盖的视图size
 @param bgColor 视图的父view背景颜色
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor;


/**
 添加圆角遮罩层, 可添加圆角边框(宽度, 颜色), 跟指定视图的圆角位置
 
 @param radius 半径
 @param size 所需覆盖的视图size
 @param bgColor 视图的父view背景颜色
 @param corners UIRectCorner视图的圆角位置
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor;

/**
 为size已经设置好的UIView添加圆角遮罩层
 
 @param radius 半径
 @param bgColor 视图的父view背景颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius background:(UIColor *)bgColor;

/**
 为size已经设置好的UIView添加圆角遮罩层, 可添加圆角边框(宽度, 颜色)
 
 @param radius 半径
 @param bgColor 视图的父view背景颜色
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius
             background:(UIColor *)bgColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor;

/**
 为size已经设置好的UIView添加圆角遮罩层, 可添加圆角边框(宽度, 颜色), 跟指定视图的圆角位置
 
 @param radius 半径
 @param bgColor 视图的父view背景颜色
 @param corners UIRectCorner视图的圆角位置
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 */
- (void)fx_cornerRadius:(CGFloat)radius
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor;

@end

NS_ASSUME_NONNULL_END
