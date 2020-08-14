//
//  TYAddressSelectionTableViewCell.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-tableView：cell

#import "TYAddressSelectionTableViewCell.h"
#import "TYAddressSelectionModel.h"
#import "UIColor+TYDarkMode.h"
#import <Masonry.h>

@interface TYAddressSelectionTableViewCell ()
@property (nonatomic, strong)UIImageView *imageV;
@end

@implementation TYAddressSelectionTableViewCell
#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self UIConfig];
    }
    return self;
}

#pragma mark - Public Method
+ (CGFloat)rowHeight{
    return 46.f;
}

#pragma mark - Override

#pragma mark - Private Method
// 搭建界面
- (void)UIConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 标题
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor ty_colorWithHex:0x333333];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
    }];
    // 选中标记
    _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    _imageV.hidden = YES;
    [self.contentView addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-16);
        make.width.mas_equalTo(12.f);
        make.height.mas_equalTo(12.f);
    }];
}

#pragma mark - Request

#pragma mark - Delegate

#pragma mark - Getter And Setter
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    _imageV.hidden = !_isSelected;
    _titleLabel.textColor = _isSelected ? TYColor(0xF32735, 0xE83B47) : TYColor(0x333333, 0xEEEEEE);
}
 
- (void)setModel:(TYAddressSelectionModel *)model {
    _model = model;
    _imageV.hidden = !model.isSelected;
    _titleLabel.textColor = model.isSelected ? TYColor(0xF32735, 0xE83B47) : TYColor(0x333333, 0xEEEEEE);
    self.titleLabel.text = model.label;
}

#pragma mark - Dealloc
@end
