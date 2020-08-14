//
//  TYAddressSelectionViewController.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-总视图：ViewCotroller

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TYAddressSelectionViewController : UIViewController
/// 选择完成
@property (nonatomic, copy) void(^completion)(NSArray <NSString *> * array);
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) __kindof UIViewController *currentViewController;
@property (nonatomic, strong, readonly) NSArray<__kindof UIViewController *> *viewControllers;
@end

NS_ASSUME_NONNULL_END
