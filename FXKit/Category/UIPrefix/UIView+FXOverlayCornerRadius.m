//
//  UIView+FXOverlayCornerRadius.m
//  FXKit
//
//  Created by ShawnFoo on 2017/10/17.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "UIView+FXOverlayCornerRadius.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - FXOverlayCacheKeyValue
@protocol FXOverlayCacheKeyValue <NSObject>
- (NSString *)overlayCacheKeyValue;
@end

#pragma mark - FXOverlayBorder
@interface FXOverlayBorder : NSObject <FXOverlayCacheKeyValue>

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;

@end

@implementation FXOverlayBorder

+ (instancetype)borderWithWidth:(CGFloat)width andColor:(UIColor *)color {
    FXOverlayBorder *border = [[FXOverlayBorder alloc] init];
    border.width = width;
    border.color = color;
    return border;
}

- (NSString *)overlayCacheKeyValue {
    return [NSString stringWithFormat:@"b%@_%@", @(self.width), self.color.description];
}

@end


#pragma mark - FXOverlayModel
@interface FXOverlayModel : NSObject <FXOverlayCacheKeyValue>

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) UIRectCorner corners;
@property (nonatomic, strong, nullable) FXOverlayBorder *border;

@end

@implementation FXOverlayModel

+ (instancetype)modelWithRadius:(CGFloat)radius
                           size:(CGSize)size
                     background:(UIColor *)bgColor
                        corners:(UIRectCorner)corners
                         border:(nullable FXOverlayBorder *)border {
    FXOverlayModel *model = [[FXOverlayModel alloc] init];
    model.radius = radius;
    model.size = size;
    model.bgColor = bgColor;
    model.corners = corners;
    model.border = border;
    return model;
}

- (NSString *)overlayCacheKeyValue {
    NSString *suffix = self.border ? [self.border overlayCacheKeyValue] : @"";
    return [[NSString stringWithFormat:@"%@_%@_%@_%@",
             @(self.radius),
             NSStringFromCGSize(self.size),
             self.bgColor.description,
             @(self.corners)] stringByAppendingString:suffix];
}

@end


#pragma mark - UIView + OverlayCornerRadius
@interface UIView ()

@property (nonatomic, strong) UIImageView *fx_overlayImageView;

@end

@implementation UIView (FXOverlayCornerRadius)

/** 圆角镂空图片缓存 */
static NSCache<NSString *, UIImage *> *sOverlaysCache;

#pragma mark Public Instance Methods
- (void)fx_cornerRadius:(CGFloat)radius background:(UIColor *)bgColor {
    [self fx_cornerRadius:radius
               background:bgColor
           roudingCorners:0
              borderWidth:0
              borderColor:nil];
}

- (void)fx_cornerRadius:(CGFloat)radius
             background:(UIColor *)bgColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor {
    [self fx_cornerRadius:radius
               background:bgColor
           roudingCorners:0
              borderWidth:borderWidth
              borderColor:borderColor];
}

- (void)fx_cornerRadius:(CGFloat)radius
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor {
    [self fx_cornerRadius:radius
              overlaySize:self.bounds.size
               background:bgColor
           roudingCorners:corners
              borderWidth:borderWidth
              borderColor:borderColor];
}

- (void)fx_cornerRadius:(CGFloat)radius overlaySize:(CGSize)size background:(UIColor *)bgColor {
    [self fx_cornerRadius:radius
              overlaySize:size
               background:bgColor
           roudingCorners:0
              borderWidth:0
              borderColor:nil];
}

- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners {
    [self fx_cornerRadius:radius
              overlaySize:size
               background:bgColor
           roudingCorners:corners
              borderWidth:0
              borderColor:nil];
}

- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor {
    [self fx_cornerRadius:radius
              overlaySize:size
               background:bgColor
           roudingCorners:0
              borderWidth:borderWidth
              borderColor:borderColor];
}

- (void)fx_cornerRadius:(CGFloat)radius
            overlaySize:(CGSize)size
             background:(UIColor *)bgColor
         roudingCorners:(UIRectCorner)corners
            borderWidth:(CGFloat)borderWidth
            borderColor:(nullable UIColor *)borderColor {
    if (!self.fx_overlayImageView) {
        [self fx_addOverlayCornerRadiusImageView];
    }
    FXOverlayBorder *border = nil;
    if (borderWidth > 0
        && borderColor
        && borderWidth < radius) {// 内边框半径不得大于圆角半径
        border = [FXOverlayBorder borderWithWidth:borderWidth andColor:borderColor];
    }
    FXOverlayModel *model = [FXOverlayModel modelWithRadius:radius
                                                           size:size
                                                     background:bgColor
                                                        corners:corners
                                                         border:border];
    
    UIImage *overlayImg = [self fx_overlayImageForModel:model];
    self.fx_overlayImageView.image = overlayImg;
}

#pragma mark Overlay ImageView
- (void)fx_addOverlayCornerRadiusImageView {
    UIImageView *overlayIV = [[UIImageView alloc] init];
    overlayIV.userInteractionEnabled = NO;
    [self addSubview:overlayIV];
    overlayIV.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(overlayIV);
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[overlayIV]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[overlayIV]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    self.fx_overlayImageView = overlayIV;
}

#pragma mark Overlay Image
- (UIImage *)fx_overlayImageForModel:(FXOverlayModel *)model {
    NSString *cacheKey = [model overlayCacheKeyValue];
    UIImage *overlayImage = [self fx_overlayImageForKey:cacheKey];
    if (!overlayImage) {
        overlayImage = [self fx_createImageForModel:model];
        [self fx_setOverlayImage:overlayImage forKey:cacheKey];
    }
    return overlayImage;
}

- (UIImage *)fx_createImageForModel:(FXOverlayModel *)model {
    UIGraphicsBeginImageContextWithOptions(model.size, NO, 0.0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, model.size.width, model.size.height);
    // 填外部颜色
    [model.bgColor setFill];
    UIRectFill(rect);
    UIBezierPath *overlayPath = [self fx_overlayPathForModel:model withRect:rect];
    CGContextSetBlendMode(currentContext, kCGBlendModeDestinationOut);
    overlayPath.usesEvenOddFillRule = YES;
    [overlayPath fill];
    // 有边框则画边框
    if (model.border) {
        CGContextSetBlendMode(currentContext, kCGBlendModeNormal);
        CGContextEOFillPath(currentContext);
        UIBezierPath *borderPath = [self fx_borderPathForModel:model];
        [model.border.color setStroke];
        borderPath.usesEvenOddFillRule = YES;
        [borderPath stroke];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIBezierPath *)fx_overlayPathForModel:(FXOverlayModel *)model withRect:(CGRect)rect {
    UIBezierPath *overlayPath = nil;
    if (!model.corners) {
        overlayPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                 cornerRadius:model.radius];
    }
    else {
        overlayPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                            byRoundingCorners:model.corners
                                                  cornerRadii:CGSizeMake(model.radius, model.radius)];
    }
    return overlayPath;
}

- (UIBezierPath *)fx_borderPathForModel:(FXOverlayModel *)model {
    CGFloat borderCorner = model.radius - model.border.width;
    // 边框是从中间往内外两侧进行拓展的
    CGRect borderRect = CGRectMake(model.border.width/2.0,
                                   model.border.width/2.0,
                                   model.size.width - model.border.width,
                                   model.size.height - model.border.width);
    UIBezierPath *borderPath = nil;
    if (!model.corners) {
        borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect
                                                cornerRadius:borderCorner];
    }
    else {
        borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect
                                           byRoundingCorners:model.corners
                                                 cornerRadii:CGSizeMake(borderCorner, borderCorner)];
    }
    borderPath.lineWidth = model.border.width;
    return borderPath;
}

#pragma mark Cache Accessor
- (void)fx_setOverlayImage:(UIImage *)image forKey:(NSString *)key {
	if (!sOverlaysCache) {
		sOverlaysCache = [[NSCache alloc] init];
	}
    [sOverlaysCache setObject:image forKey:key];
}

- (nullable UIImage *)fx_overlayImageForKey:(NSString *)key {
    return [sOverlaysCache objectForKey:key];
}

#pragma mark Accessor
- (UIImageView *)fx_overlayImageView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setFx_overlayImageView:(UIImageView *)fx_overlayImageView {
    objc_setAssociatedObject(self,
                             @selector(fx_overlayImageView),
                             fx_overlayImageView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

NS_ASSUME_NONNULL_END
