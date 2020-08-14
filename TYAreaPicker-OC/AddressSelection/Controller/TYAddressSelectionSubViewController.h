//
//  TYAddressSelectionSubViewController.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-子视图-基类：ViewCotroller

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ZMAddressSelectionType) {
    ZMAddressSelectionTypeProvince = 1, // 省
    ZMAddressSelectionTypeCity ,// 市
    ZMAddressSelectionTypeCounty// 区
};

@interface TYAddressSelectionSubViewController : UIViewController
@property (nonatomic, assign) ZMAddressSelectionType type;
// 传cityId查区列表，传provinceId查市列表，不传查省列表
@property (nonatomic, copy) NSString * provinceId;
@property (nonatomic, copy) NSString * cityId;
@property (nonatomic, copy) NSString * countyId;
@property(nonatomic,copy) void(^selectBlock)(NSString * area, NSString * areaId);

- (void)refreshList;
@end

NS_ASSUME_NONNULL_END
