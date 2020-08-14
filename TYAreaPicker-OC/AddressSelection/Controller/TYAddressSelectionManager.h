//
//  TYAddressSelectionManager.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择：manager

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYAddressSelectionManager : NSObject
/// 展示。fromVc：从哪个VC弹出， selectedCompletion选择完成
- (void)showFromVc:(UIViewController *)fromVc selectedCompletion:(void(^)(NSArray <NSString *> * array))selectedCompletion;
/// 隐藏
- (void)hide;
@end

NS_ASSUME_NONNULL_END
