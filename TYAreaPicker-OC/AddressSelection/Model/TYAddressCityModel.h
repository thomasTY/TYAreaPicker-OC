//
//  TYAddressCityModel.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/14.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-城市：model

#import <Foundation/Foundation.h>
#import "TYAddressSelectionModel.h"
#import "TYAddressCountyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAddressCityModel : TYAddressSelectionModel
/// 区县数组
@property (nonatomic , copy) NSArray<TYAddressCountyModel *>              * county;
@end

NS_ASSUME_NONNULL_END
