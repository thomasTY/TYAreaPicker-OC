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
@property (nonatomic, strong) UIButton * contactButton;
@property (nonatomic, strong) UIButton * containerButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * areaLabel;
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
    self.view.backgroundColor = TYColor(0xF0F0F0, 0x1A1A1A);
    [self.view addSubview:self.contactButton];
    [self.view addSubview:self.containerButton];
    [self.containerButton addSubview:self.titleLabel];
    [self.containerButton addSubview:self.areaLabel];
    [self.containerButton addSubview:self.arrowImageView];
    // contactButton
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(78.f);
    }];
    // 按钮
    [self.containerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    // 所在地
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerButton);
        make.left.equalTo(self.containerButton).offset(10);
        make.height.mas_equalTo(25);
    }];
    // 区域
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.containerButton).offset(-30);
        make.height.mas_equalTo(25);
    }];
    // 箭头
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.containerButton).offset(-10);
    }];
}

- (void)containerButtonClick {
    self.addressSelectionManager = [TYAddressSelectionManager new];
    __weak typeof(self) weakSelf = self;
    [self.addressSelectionManager showFromVc:self selectedCompletion:^(NSArray<NSString *> * _Nonnull array) {
        NSString * province = [array objectAtIndex:0];
        NSString * city = [array objectAtIndex:1];
        NSString * county = [array objectAtIndex:2];
        NSString * addressStr = [NSString stringWithFormat:@"%@ %@ %@",province, city, county];
        weakSelf.areaLabel.text = addressStr;
    }];
}

- (void)contactButtonClick {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"如果有问题可以加入QQ讨论群:779486831" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"复制到粘贴板" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"779486831";
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isIPhoneX {
    if (@available(iOS 11.0, *)) { // 根据安全区域判断
        CGFloat height = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if (@available(iOS 11.0, *)) {
            height = [[UIApplication sharedApplication].windows lastObject].safeAreaInsets.bottom;
        }
        return (height > 0);
    } else {
        return NO;
    }
}

#pragma mark - Request

#pragma mark - Delegate

#pragma mark - Getter And Setter
- (UIButton *)contactButton {
    if (!_contactButton) {
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactButton.backgroundColor = TYColor(0xFFFFFF, 0x222222);
        [_contactButton addTarget:self action:@selector(contactButtonClick) forControlEvents:UIControlEventTouchUpInside];
        // 标题
        UILabel *label = [UILabel new];
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = TYColor(0x333333, 0xEEEEEE);
        label.text = @"TYAreaPicker-OC";
        [_contactButton addSubview:label];
        CGFloat bottom = 10.f;
        if ([self isIPhoneX] == YES) {
            bottom = 15.f;
        }
        __weak typeof(_contactButton) weakContactButton = _contactButton;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakContactButton);
            make.bottom.equalTo(weakContactButton).offset(-bottom);
        }];
        // 联系我
        UILabel *label1 = [UILabel new];
        label1.font = [UIFont systemFontOfSize:16];
        label1.textColor = TYColor(0x333333, 0xEEEEEE);
        label1.text = @"联系我";
        [_contactButton addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.equalTo(weakContactButton).offset(-15);
        }];
    }
    return _contactButton;
}

- (UIButton *)containerButton {
    if (!_containerButton) {
        _containerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _containerButton.backgroundColor = TYColor(0xFFFFFF, 0x222222);
        [_containerButton addTarget:self action:@selector(containerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _containerButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TYColor(0x333333, 0xEEEEEE);
        _titleLabel.text = @"所在地";
    }
    return _titleLabel;
}

- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [UILabel new];
        _areaLabel.font = [UIFont systemFontOfSize:14];
        _areaLabel.textColor = TYColor(0xAAAAAA, 0x666666);
        _areaLabel.text = @"请选择";
    }
    return _areaLabel;
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
