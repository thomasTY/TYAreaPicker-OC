//
//  ViewController.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * areaButton;
@property (nonatomic, strong) UIImageView * arrowImageView;
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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.areaButton];
    [self.view addSubview:self.arrowImageView];
    // 所在地
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(10);
        make.height.mas_equalTo(25);
    }];
    // 区域
    [self.areaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    // 箭头
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.view).offset(-10);
    }];
}

- (void)areaButtonClick {
    
}

- (UIColor *)colorWithHex:(long)hexColor {
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

#pragma mark - Request

#pragma mark - Delegate

#pragma mark - Getter And Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [self colorWithHex:0x333333];
        _titleLabel.text = @"所在地";
    }
    return _titleLabel;
}

- (UIButton *)areaButton {
    if (!_areaButton) {
        _areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _areaButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_areaButton setTitleColor:[self colorWithHex:0x333333] forState:UIControlStateNormal];
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
