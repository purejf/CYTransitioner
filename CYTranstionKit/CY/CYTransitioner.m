//
//  CYTransitioner.m
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import "CYTransitioner.h"
#import "CYTransitionConfiguration.h"

#define force_inline __inline__ __attribute__((always_inline))

static force_inline NSString *CYTransitionTypeStr(CYTransitionType type) {
    switch (type) {
        case CYTransitionTypeNone: return nil; break;
        case CYTransitionTypeFade: return @"fade"; break;
        case CYTransitionTypePush: return @"push"; break;
        case CYTransitionTypeCube: return @"cube"; break;
        case CYTransitionTypeMoveIn: return @"moveIn"; break;
        case CYTransitionTypeReveal: return @"reveal"; break;
        case CYTransitionTypeOglFlip: return @"oglFilp"; break;
        case CYTransitionTypePageCurl: return @"pageCurl"; break;
        case CYTransitionTypePageUnCurl: return @"pageUnCurl"; break;
        case CYTransitionTypeSuckEffect: return @"suckEffect"; break;
        case CYTransitionTypeRippleEffect: return @"rippleEffect"; break;
        case CYTransitionTypeCameraIrisHollowOpen: return @"cameraIrisHollowOpen"; break;
        case CYTransitionTypeCameraIrisHollowClose: return @"cameraIrisHollowClose"; break;
        default: return nil; break;
    }
}

static force_inline NSString *CYTransitionSubtypeStr(CYTransitionDirection direction) {
    switch (direction) {
        case CYTransitionDirectionNone: return nil; break;
        case CYTransitionDirectionFromTop: return @"fromTop"; break;
        case CYTransitionDirectionFromLeft: return @"fromLeft"; break;
        case CYTransitionDirectionFromRight: return @"fromRight"; break;
        case CYTransitionDirectionFromBottom: return @"fromBottom"; break;
        default: return nil; break;
    }
}

static force_inline BOOL CYTranistionSubTypeValid(CYTransitionType type) {
    if (type == CYTransitionTypeSuckEffect ||
        type == CYTransitionTypeRippleEffect ||
        type == CYTransitionTypeCameraIrisHollowOpen ||
        type == CYTransitionTypeCameraIrisHollowClose) {
        return NO;
    }
    return YES;
}

@interface CYTransitioner () <CAAnimationDelegate>
@end

@implementation CYTransitioner {
    id <UIViewControllerContextTransitioning>_transitionContext;
    UIView *_snapShotToView;
    UIView *_snapShotFromView;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)context {
    return self.con.duration;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)context {
    
    UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _snapShotToView = [toVc.view snapshotViewAfterScreenUpdates:YES];
    _snapShotFromView = [fromVc.view snapshotViewAfterScreenUpdates:YES];
    _transitionContext = context;
    
    UIView *containerView = [context containerView];
    [containerView addSubview:fromVc.view];
    [containerView bringSubviewToFront:fromVc.view];
    [containerView addSubview:toVc.view];
    [containerView bringSubviewToFront:toVc.view];
    
    // transition
    CATransition *transition = [CATransition animation];
    NSString *typeStr = CYTransitionTypeStr(_con.type);
    NSString *subtypeStr = CYTransitionSubtypeStr(_con.subtype);
    if (typeStr.length) {
        transition.type = typeStr;
    }
    if (subtypeStr.length && CYTranistionSubTypeValid(_con.type)) {
        transition.subtype = subtypeStr;
    }
    transition.duration = self.con.duration;
    transition.delegate = self;
    [containerView.layer addAnimation:transition forKey:NULL];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
    if (finished) {
        [_snapShotToView removeFromSuperview];
        [_snapShotFromView removeFromSuperview];
        [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
    }
}
@end
