//
//  UIColor+TYDarkMode.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/14.
//  Copyright © 2020 TYOU. All rights reserved.
// 颜色-暗黑模式-分类：UIColor

#import "UIColor+TYDarkMode.h"

@implementation UIColor (TYDarkMode)
#pragma mark - Life Cycle

#pragma mark - Public Method
+ (UIColor *)ty_colorWithLightHexColor:(long)lightHexColor darkColor:(long)darkHexColor {
    return [self ty_colorWithLightHexColor:lightHexColor darkColor:darkHexColor alpha:1.0];
}

+ (UIColor *)ty_colorWithLightHexColor:(long)lightHexColor darkColor:(long)darkHexColor alpha:(float)opacity{
    UIColor *lightColor = [UIColor ty_colorWithHex:lightHexColor alpha:1.0];
    UIColor *darkColor = [UIColor ty_colorWithHex:darkHexColor alpha:1.0];
    return [self ty_colorWithLightColor:lightColor darkColor:darkColor];
}

+ (UIColor *)ty_colorWithLightColor:(UIColor *)light darkColor:(nullable UIColor *)dark {

    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return light;
            }else {
                return dark;
            }
        }];
        return dyColor;
    }
    return light;
}

+ (UIColor *)ty_colorWithHex:(long)hexColor {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}

+ (UIColor *)ty_colorWithHex:(long)hexColor alpha:(float)opacity {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

#pragma mark - Override

#pragma mark - Private Method

#pragma mark - Request

#pragma mark - Delegate

#pragma mark - Getter And Setter

#pragma mark - Dealloc


@end
