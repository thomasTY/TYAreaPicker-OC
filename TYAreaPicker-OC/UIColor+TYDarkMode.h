//
//  UIColor+TYDarkMode.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/14.
//  Copyright © 2020 TYOU. All rights reserved.
// 颜色-暗黑模式-分类：UIColor

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
#define TYColor(lightColorHex, darkColorHex)  [UIColor ty_colorWithLightHexColor:lightColorHex darkColor:darkColorHex]

@interface UIColor (TYDarkMode)
/// 16进制的普通颜色、暗黑颜色
+ (UIColor *)ty_colorWithLightHexColor:(long)lightHexColor darkColor:(long)darkHexColor;
/// 16进制的普通颜色、暗黑颜色， opacity：透明度
+ (UIColor *)ty_colorWithLightHexColor:(long)lightHexColor darkColor:(long)darkHexColor alpha:(float)opacity;
/// UIColor的普通颜色、暗黑颜色
+ (UIColor *)ty_colorWithLightColor:(UIColor *)light darkColor:(nullable UIColor *)dark;
/// 16进制的颜色
+ (UIColor *)ty_colorWithHex:(long)hexColor;
/// 16进制的颜色， opacity：透明度
+ (UIColor *)ty_colorWithHex:(long)hexColor alpha:(float)opacity;
@end

NS_ASSUME_NONNULL_END
