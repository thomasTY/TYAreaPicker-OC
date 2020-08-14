//
//  ViewController.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "UIColor+TYDarkMode.h"
#import "TYAddressSelectionManager.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * areaButton;
@property (nonatomic, strong) UIImageView * arrowImageView;
@property (nonatomic, strong) TYAddressSelectionManager * addressSelectionManager;
@end

@implementation ViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}
#pragma mark - Public Method

#pragma mark - Override

#pragma mark - Private Method
// 搭建界面
- (void)UIConfig {
    self.view.backgroundColor = TYColor(0xFFFFFF, 0x1A1A1A);
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.areaButton];
    [self.view addSubview:self.arrowImageView];
    // 所在地
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(25);
    }];
    // 区域
    [self.areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-30);
        make.height.mas_equalTo(25);
    }];
    // 箭头
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)areaButtonClick {
    self.addressSelectionManager = [TYAddressSelectionManager new];
    __weak typeof(self) weakSelf = self;
    [self.addressSelectionManager showFromVc:self selectedCompletion:^(NSArray<NSString *> * _Nonnull array) {
        NSString * province = [array objectAtIndex:0];
        NSString * city = [array objectAtIndex:1];
        NSString * county = [array objectAtIndex:2];
        NSString * addressStr = [NSString stringWithFormat:@"%@ %@ %@",province, city, county];
        [weakSelf.areaButton setTitle:addressStr forState:UIControlStateNormal];
    }];
}

#pragma mark - Request

#pragma mark - Delegate

#pragma mark - Getter And Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor ty_colorWithHex:0x333333];
        _titleLabel.text = @"所在地";
    }
    return _titleLabel;
}

- (UIButton *)areaButton {
    if (!_areaButton) {
        _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_areaButton setTitleColor:[UIColor ty_colorWithHex:0x333333] forState:UIControlStateNormal];
        [_areaButton setTitle:@"请选择" forState:UIControlStateNormal];
        [_areaButton addTarget:self action:@selector(areaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaButton;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [UIImageView new];
        _arrowImageView.image = [UIImage imageNamed:@"common_arrow_icon"];
    }
    return _arrowImageView;
}

#pragma mark - Dealloc



@end
