//
//  TYAddressSelectionViewController.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-总视图：ViewCotroller

#import "TYAddressSelectionViewController.h"
#import "TYAddressSelectionSubViewController.h"
#import "UIColor+TYDarkMode.h"
#import <VTMagic/VTMagic.h>
#import <Masonry.h>

@interface TYAddressSelectionViewController () <VTMagicViewDelegate, VTMagicViewDataSource, VTMagicProtocol>
@property (nonatomic, strong)VTMagicView *magicView;
@property (nonatomic, strong) UIView * backgroundColorView;
@property (nonatomic, strong) UIView * topContainerView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * closeImageView;
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, strong) NSMutableArray *menuList;
@property (nonatomic, strong) NSMutableArray *areaIdList;
@end

@implementation TYAddressSelectionViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfig];
    [self UIConfig];
    [self.magicView reloadData];
}

#pragma mark - Public Method

#pragma mark - Override
- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationCustom;
}

#pragma mark - Private Method
// 初始化配置
- (void)initConfig {
    self.topMargin = 100.f;
    // 根据安全区域判断
    BOOL isIPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        CGFloat height = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        isIPhoneX = (height > 0);
    }
    if (isIPhoneX) {
        self.topMargin += 30;
    }
}

// 搭建界面
- (void)UIConfig {
    self.view.backgroundColor = [UIColor clearColor];
    // 添加
    [self.view addSubview:self.backgroundColorView];
    [self.view addSubview:self.topContainerView];
    [self.topContainerView addSubview:self.titleLabel];
    [self.topContainerView addSubview:self.closeImageView];
    [self.view addSubview:self.magicView];
    // 背景色
    [self.backgroundColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(12);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    // 内容区域
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(41.f);
    }];
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView).offset(16);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(25.f);
    }];
    // 关闭
    [self.closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.topContainerView).mas_equalTo(-16);
        make.height.mas_equalTo(15.5f);
        make.width.mas_equalTo(15.5f);
    }];
    // magicView
    [self.magicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    // 顶部圆角
    [self.view layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.topContainerView.bounds
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.topContainerView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.topContainerView.layer.mask = maskLayer;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealSelectWithArea:(NSString *)area areaId:(NSString *)areaId index:(NSUInteger)pageIndex {
    NSInteger index = pageIndex;
    NSInteger count = self.menuList.count;
    if (pageIndex+1 > count) {// 防止越界
        index = count - 1;
    }
    // areaId
    {
        NSArray * array = @[areaId];
        NSInteger step = self.areaIdList.count - pageIndex;
        if (step >= 0) {
            [self.areaIdList replaceObjectsInRange:NSMakeRange(pageIndex, step) withObjectsFromArray:array];
        }
    }
    // 分栏
    if (count) {
        NSArray * array = [NSArray arrayWithObjects:area, @"请选择", nil];
        if (pageIndex == 2) {
            array = @[area];
        }
        NSInteger step = count - pageIndex;
        if (step >= 0) { // 防止越界
            [self.menuList replaceObjectsInRange:NSMakeRange(pageIndex, step) withObjectsFromArray:array];
        }
        [self.magicView reloadData];
        // 切换分栏
        count = self.menuList.count;
        NSInteger page = count-1;
        if (page < 0) { // 防止越界
            page = 0;
        }
        [self.magicView switchToPage:page animated:YES];
    }
    
    // 选中最后一项后回调
    if (pageIndex == 2) {
        if (self.completion) {
            self.completion(self.menuList.copy);
        }
    }
}
- (NSString *)stringWithIndex:(NSInteger)index array:(NSArray*)array {
    NSString * string = @"";
    if (index < array.count) {
        string = [array objectAtIndex:index];
    }
    return string;
}

#pragma mark - Request

#pragma mark - Delegate
#pragma mark -- VTMagicViewDelegate && VTMagicViewDelegate
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView{
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:TYColor(0x333333, 0xEEEEEE) forState:UIControlStateNormal];
        [menuItem setTitleColor:TYColor(0xF32735, 0xE83B47) forState:UIControlStateSelected];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        if (!font) {
            font = [UIFont systemFontOfSize:16.f];
        }
        menuItem.titleLabel.font = font;
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId1 = @"TYAddressSelectionProvinceViewControllerID";
    static NSString *gridId2 = @"TYAddressSelectionCityViewControllerID";
    static NSString *gridId3 = @"TYAddressSelectionCountyViewControllerID";
    TYAddressSelectionSubViewController *vc = nil;
    if (pageIndex == 0) {// 省
        vc = [magicView dequeueReusablePageWithIdentifier:gridId1];
    } else if (pageIndex == 1) {// 市
        vc = [magicView dequeueReusablePageWithIdentifier:gridId2];
    } else {// 区
        vc = [magicView dequeueReusablePageWithIdentifier:gridId3];
    }
    
    if (!vc) {
        vc = [TYAddressSelectionSubViewController new];
        vc.provinceId = [self stringWithIndex:0 array:self.areaIdList];
        vc.cityId = [self stringWithIndex:1 array:self.areaIdList];
        vc.countyId = [self stringWithIndex:2 array:self.areaIdList];
        if (pageIndex == 0) {// 省
            vc.type = TYAddressSelectionTypeProvince;
        } else if (pageIndex == 1) {// 市
            vc.type = TYAddressSelectionTypeCity;
        } else {// 区
            vc.type = TYAddressSelectionTypeCounty;
        }
    }
    return vc;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    TYAddressSelectionSubViewController* vc = (TYAddressSelectionSubViewController*)viewController;
    NSInteger count = self.areaIdList.count;
    if (count) {
        vc.provinceId = [self stringWithIndex:0 array:self.areaIdList];
        vc.cityId = [self stringWithIndex:1 array:self.areaIdList];
        vc.countyId = [self stringWithIndex:2 array:self.areaIdList];
    }
    __weak typeof(self) weakSelf = self;
    vc.selectBlock = ^(NSString * area, NSString * areaId) {
        [weakSelf dealSelectWithArea:area areaId:areaId index:pageIndex];
    };
    [vc refreshList];
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{

}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{

}

#pragma mark - VTMagicProtocol
- (UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex {
    return [self.magicView viewControllerAtPage:pageIndex];
}

- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated {
    [self.magicView switchToPage:pageIndex animated:animated];
}

#pragma mark - accessor methods
- (NSArray<UIViewController *> *)viewControllers {
    return self.magicView.viewControllers;
}

#pragma mark - Getter And Setter
- (UIView *)backgroundColorView {
    if (!_backgroundColorView) {
        _backgroundColorView = [UIView new];
        _backgroundColorView.backgroundColor = TYColor(0xFFFFFF, 0x1A1A1A);
    }
    return _backgroundColorView;
}

- (UIView *)topContainerView {
    if (!_topContainerView) {
        _topContainerView = [UIView new];
        _topContainerView.backgroundColor = TYColor(0xFFFFFF, 0x1A1A1A);
    }
    return _topContainerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18.f];
        if (!font) {
            font = [UIFont systemFontOfSize:18.f];
        }
        _titleLabel.font = font;
        _titleLabel.textColor = TYColor(0x333333, 0x666666);
        _titleLabel.text = @"请选择所在地区";
    }
    return _titleLabel;
}

- (UIImageView *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [UIImageView new];
        _closeImageView.image = [UIImage imageNamed:@"address_close"];
        _closeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_closeImageView addGestureRecognizer:tap];
    }
    return _closeImageView;
}

- (VTMagicView *)magicView {
    if (!_magicView) {
        _magicView = [VTMagicView new];
        _magicView.delegate = self;
        _magicView.dataSource = self;
        _magicView.magicController = self;
        _magicView.bounces = NO;
        _magicView.headerHeight = 0;
        _magicView.againstStatusBar = NO;
        _magicView.navigationView.backgroundColor = TYColor(0xFFFFFF, 0x1A1A1A);
        _magicView.sliderColor = TYColor(0xFFFFFF, 0x1A1A1A);
        _magicView.sliderExtension = 0;
        _magicView.layoutStyle = VTLayoutStyleDefault;
        _magicView.itemSpacing = 20;
        _magicView.separatorHidden = YES;
    }
    return _magicView;
}

- (NSMutableArray *)menuList {
    if (!_menuList) {
        _menuList = [NSMutableArray array];
        [_menuList addObject:@"请选择"];
    }
    return _menuList;
}

- (NSMutableArray *)areaIdList {
    if (!_areaIdList) {
        _areaIdList = [NSMutableArray array];
    }
    return _areaIdList;
}

#pragma mark - Dealloc

@end
