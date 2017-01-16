//
//  UIViewController+CY.m
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import "UIViewController+CY.h"
#import <objc/runtime.h>
#import "CYTransitioner.h"
#import "CYTransitionConfiguration.h"

@implementation UIViewController (CY)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self _exchangePresent];
        [self _exchangeDismiss];
    });
}

- (void)setCon:(CYTransitionConfiguration *)con {
    objc_setAssociatedObject(self, @selector(con), con, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CYTransitionConfiguration *)con {
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)_exchangePresent {
    [self _exchangeSeletor1:@selector(presentViewController:animated:completion:) selector2:@selector(cy_presentViewController:animated:completion:)];
}

+ (void)_exchangeDismiss {
    [self _exchangeSeletor1:@selector(dismissViewControllerAnimated:completion:) selector2:@selector(cy_dismissViewControllerAnimated:completion:)];
}

+ (void)_exchangeSeletor1:(SEL)selector1 selector2:(SEL)selector2 {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, selector1);
    Method swizzledMethod = class_getInstanceMethod(class, selector2);
    
    // Change implementation
    BOOL success = class_addMethod(class, selector1, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, selector2, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)cy_presentViewController:(UIViewController *)vcToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    if (vcToPresent) {
        CYTransitionConfiguration *con = vcToPresent.con;
        if (con.transitionEnabled &&
            con.type != CYTransitionTypeNone) {
            con.mode = CYTransitionModePresent;
            vcToPresent.transitioningDelegate = self;
        }
    }
    // Forward to primary implementation
    [self cy_presentViewController:vcToPresent animated:animated completion:completion];
}

- (void)cy_dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    // Forward to primary implementation
    self.transitioningDelegate = self;
    self.con.mode = CYTransitionModeDismiss;
    [self cy_dismissViewControllerAnimated:flag completion:completion];
}

#pragma mark - UIViewControllerTransitioningDelegate

// 谁负责弹出
- (CYTransitioner *)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    CYTransitioner *transitioner = [CYTransitioner new];
    transitioner.con = presented.con;
    return transitioner;
}

// 谁负责消失
- (CYTransitioner *)animationControllerForDismissedController:(UIViewController *)dismissed {
    CYTransitioner *transitioner = [CYTransitioner new];
    CYTransitionConfiguration *con = dismissed.con;
    switch (con.subtype) {
        case CYTransitionDirectionFromLeft: con.subtype = CYTransitionDirectionFromRight; break;
        case CYTransitionDirectionFromRight: con.subtype = CYTransitionDirectionFromLeft; break;
        case CYTransitionDirectionFromTop: con.subtype = CYTransitionDirectionFromBottom; break;
        case CYTransitionDirectionFromBottom: con.subtype = CYTransitionDirectionFromTop; break;
        default: break;
    }
    transitioner.con = dismissed.con;
    return transitioner;
}

@end
