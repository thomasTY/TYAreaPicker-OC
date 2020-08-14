//
//  TYAddressSelectionModel.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择：model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYAddressSelectionModel : NSObject
/// 省、市、区
@property (nonatomic, copy) NSString * label;
/// 省id、市id、区id
@property (nonatomic, copy) NSString * value;
/// 选中
@property (nonatomic, assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
