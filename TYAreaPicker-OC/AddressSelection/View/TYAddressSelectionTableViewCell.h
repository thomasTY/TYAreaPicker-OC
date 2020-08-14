//
//  TYAddressSelectionTableViewCell.h
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-tableView：cell

#import <UIKit/UIKit.h>
@class TYAddressSelectionModel;

NS_ASSUME_NONNULL_BEGIN

@interface TYAddressSelectionTableViewCell : UITableViewCell
@property (nonatomic, strong) TYAddressSelectionModel * model;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, assign)BOOL isSelected;

+ (CGFloat)rowHeight;
@end

NS_ASSUME_NONNULL_END
