//
//  TYAddressSelectionManager.m
//  TYAreaPicker-OC
//
//  Created by chentianyou on 2020/8/5.
//  Copyright © 2020 TYOU. All rights reserved.
// 省市区选择：manager

#import "TYAddressSelectionManager.h"
#import "TYAddressSelectionViewController.h"
#import "UIColor+TYDarkMode.h"
#import <Masonry.h>

@interface TYAddressSelectionManager ()<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, strong) UIButton * dismissButton;
@property (nonatomic, assign, getter=isPresentation) BOOL presentation;// 标记是present还是dismiss
@property (nonatomic, strong) UIViewController * toVc;
@end

@implementation TYAddressSelectionManager
#pragma mark - Life Cycle

#pragma mark - Public Method
- (void)showFromVc:(UIViewController *)fromVc selectedCompletion:(void(^)(NSArray <NSString *> * array))selectedCompletion {
    TYAddressSelectionViewController * vc = [TYAddressSelectionViewController new];
    vc.completion = selectedCompletion;
    self.toVc = vc;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [fromVc presentViewController:vc animated:YES completion:nil];
}

- (void)hide {
    [self dismissViewController];
}

#pragma mark - Override

#pragma mark - Private Method
- (void)dismissViewController {
    [self.toVc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request

#pragma mark - Delegate
#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    UIView * animationView = self.presentation ? toVC.view : fromVC.view;
    
    // 根据安全区域判断
    BOOL isIPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        CGFloat height = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        isIPhoneX = (height > 0);
    }
    CGFloat topMargin = isIPhoneX ? 100 : 130;
    if (self.presentation && toVC.view) { // 推出
        [containerView addSubview:self.coverView];
        [containerView addSubview:self.dismissButton];
        // 遮罩视图
        [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(containerView);
        }];
        self.coverView.alpha = 0;
        // 收回按钮
        [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView);
            make.left.equalTo(containerView);
            make.right.equalTo(containerView);
            make.height.mas_equalTo(topMargin);
        }];
        // 内容
        [containerView addSubview:toVC.view];
        [toVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(containerView).offset([UIScreen mainScreen].bounds.size.height);
            make.left.equalTo(containerView);
            make.right.equalTo(containerView);
            make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-topMargin);
        }];
    }
    [containerView layoutIfNeeded];
    // 动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [animationView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (self.presentation == YES) {
                make.top.equalTo(containerView).offset(topMargin);
            } else {
                make.top.equalTo(containerView).offset([UIScreen mainScreen].bounds.size.height);
            }
        }];
        self.coverView.alpha = self.presentation ? 0.5 : 0;
        [containerView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presentation = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presentation = NO;
    return self;
}

#pragma mark - Getter And Setter
- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [UIView new];
        _coverView.backgroundColor = [UIColor ty_colorWithHex:0x000000];
    }
    return _coverView;
}

- (UIButton *)dismissButton {
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

#pragma mark - Dealloc

@end
