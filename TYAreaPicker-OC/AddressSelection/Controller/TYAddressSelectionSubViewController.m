//
//  TYAddressSelectionSubViewController.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择-子视图-基类：ViewCotroller

#import "TYAddressSelectionSubViewController.h"
#import "TYAddressSelectionTableViewCell.h"
#import "TYAddressSelectionModel.h"
#import "TYAddressProvinceModel.h"
#import <Masonry.h>
#import <MJExtension.h>
//#import "UIView+ZMEmptyView.h"

@interface TYAddressSelectionSubViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray <TYAddressSelectionModel *> * models;
@end

@implementation TYAddressSelectionSubViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIConfig];
}

#pragma mark - Public Method
- (void)refreshList {
    [self requestAddressListWithProvinceId:self.provinceId cityId:self.cityId];
}
#pragma mark - Override

#pragma mark - Private Method
// 搭建界面
- (void)UIConfig {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.indicatorView];
    // tableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    // loading
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-100);
    }];
}

- (NSString *)modelAreaIdWithName:(NSString *)name {
    NSString * areaId = @"";
    if (![name isKindOfClass:[NSString class]] || !name.length) {
        return areaId;
    }
    for (NSInteger i = 0; i < self.models.count; i++) {
        if (i < self.models.count) {
            TYAddressSelectionModel * model = [self.models objectAtIndex:i];
            if ([name isEqualToString:model.label]) {
                areaId = [self convertNull:model.value];
            }
        }
    }
    return areaId;
}

- (void)checkDataErrorHaveData:(BOOL)haveData error:(NSError*)error{
//    [self.view configEmptyViewType:ZMEmptyViewTypeAdressSelection hasData:haveData hasError:error !=nil clickBtnBlock:^(id  _Nullable touch) {
//        [self requestAddressListWithProvinceId:self.provinceId cityId:self.cityId];
//    } tapBackBlock:^(id  _Nullable touch) {
//        [self requestAddressListWithProvinceId:self.provinceId cityId:self.cityId];
//    }];
}

- (NSString *)convertNull:(id)object {
    // 转换空串
    if ([object isEqual:[NSNull null]]) {
        return @"";
    } else if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    } else if (object == nil) {
        return @"";
    }
    return object;
}


- (void)showToast:(NSString *)text{
    UIView * superView = [UIApplication sharedApplication].windows.lastObject;
    if (!superView) {
        return;
    }
    CGSize labelSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.f]}];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18.f];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = labelSize.height/4;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor colorWithRed:38/255.f green:187/255.f blue:251/255.f alpha:1.f];
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake((superView.bounds.size.width - labelSize.width)/2, 0, labelSize.width, labelSize.height);
    [superView addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}

#pragma mark - Request
// 传cityId查区列表，传provinceId查市列表，都不传查省列表
- (void)requestAddressListWithProvinceId:(NSString *)provinceId
                                  cityId:(NSString *)cityId {
    // 模拟接口数据
    NSString * url = [[NSBundle mainBundle] pathForResource:@"adress.json" ofType:nil];
    NSData * dataJson = [NSData dataWithContentsOfFile:url];
    NSArray <TYAddressProvinceModel *>* mockModels = [TYAddressProvinceModel mj_objectArrayWithKeyValuesArray:dataJson];
    // 过滤
    if (self.type == ZMAddressSelectionTypeCity) { // 市选择页
        cityId = @"";
    } else if (self.type == ZMAddressSelectionTypeProvince) { // 省选择页
        provinceId = @"";
        cityId = @"";
    }
    [self.indicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.indicatorView stopAnimating];
        if (weakSelf.type == ZMAddressSelectionTypeProvince) { // 省选择页
            weakSelf.models = (NSArray<TYAddressSelectionModel *> *)mockModels;
        } else if (weakSelf.type == ZMAddressSelectionTypeCity) { // 市选择页
            for(TYAddressProvinceModel * p in mockModels) {// 省
                if([provinceId isEqualToString:p.value]){
                    weakSelf.models = (NSArray<TYAddressSelectionModel *> *)[p city];
                    break;
                }
            }
        } else if (weakSelf.type == ZMAddressSelectionTypeCounty) { // 区选择页
            for(TYAddressProvinceModel * p in mockModels) {// 省
                if([provinceId isEqualToString:p.value]){
                    for(TYAddressCityModel * c in p.city) {// 市
                        if([cityId isEqualToString:c.value]){
                            weakSelf.models = (NSArray<TYAddressSelectionModel *> *)[c county];
                        }
                    }
                    break;
                }
            }
        } else {
            [self showToast:@"加载失败"];
//            [weakSelf checkDataErrorHaveData:(weakSelf.models.count > 0) error:error];
        }
    });
}

#pragma mark - Delegate
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TYAddressSelectionTableViewCell rowHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYAddressSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYAddressSelectionTableViewCell"];
    if (indexPath.row < self.models.count) {
        TYAddressSelectionModel *model = [self.models objectAtIndex:indexPath.row];
        if (model) {
            NSString * areaId = @"";
            if (self.type == ZMAddressSelectionTypeCounty &&
                [self.countyId isKindOfClass:[NSString class]] && self.countyId.length) { // 区县选择页
                areaId = self.countyId;
            } else if (self.type == ZMAddressSelectionTypeCity &&
                       [self.cityId isKindOfClass:[NSString class]] && self.cityId.length) { // 市选择页
                areaId = self.cityId;
            } else if (self.type == ZMAddressSelectionTypeProvince &&
                       [self.provinceId isKindOfClass:[NSString class]] && self.provinceId.length) { // 省选择页
                areaId = self.provinceId;
            }
            if ([areaId isKindOfClass:[NSString class]] && areaId.length &&
                [areaId isEqualToString:model.value]) {
                model.isSelected = YES;
            } else {
                model.isSelected = NO;
            }
            [cell setModel:model];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (int i = 0; i < self.models.count; i ++) {
        if (i < self.models.count) {
        TYAddressSelectionModel *model = [self.models objectAtIndex:i];
        model.isSelected = NO;
        }
    }
    if (indexPath.row < self.models.count) {
        TYAddressSelectionModel *model = [self.models objectAtIndex:indexPath.row];
        model.isSelected = YES;
        [tableView reloadData];
        if (self.selectBlock) {
            NSString * area = [self convertNull:model.label];
            NSString * areaId = [self modelAreaIdWithName:area];
            self.selectBlock(area, areaId);
        }
    }
}

#pragma mark - Getter And Setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TYAddressSelectionTableViewCell class] forCellReuseIdentifier:@"TYAddressSelectionTableViewCell"];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

- (NSArray *)models {
    if (!_models) {
        _models = [NSArray array];
    }
    return _models;
}

#pragma mark - Dealloc

@end
