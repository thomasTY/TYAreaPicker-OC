//
//  TYAddressProvinceModel.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/14.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-省份：model

#import <Foundation/Foundation.h>
#import "TYAddressSelectionModel.h"
#import "TYAddressCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAddressProvinceModel : TYAddressSelectionModel
// 城市数组
@property (nonatomic , copy) NSArray<TYAddressCityModel *>              * city;
@end

NS_ASSUME_NONNULL_END
