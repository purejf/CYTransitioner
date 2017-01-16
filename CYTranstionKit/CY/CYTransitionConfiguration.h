//
//  CYTransitionConfiguration.h
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CYTransitionMode) {
    CYTransitionModePush,
    CYTransitionModePop,
    CYTransitionModePresent,
    CYTransitionModeDismiss,
};

typedef NS_ENUM(NSUInteger, CYTransitionType) {
    CYTransitionTypeNone,
    CYTransitionTypeFade, // fade
    CYTransitionTypePush, // push
    CYTransitionTypeCube, // cube
    CYTransitionTypeMoveIn, // moveIn
    CYTransitionTypeReveal, // reveal
    CYTransitionTypeOglFlip, //
    CYTransitionTypePageCurl, // pageCurl
    CYTransitionTypePageUnCurl,
    // if you select type with behind, the transition direction will not work
    
    CYTransitionTypeSuckEffect, // suckEffect
    CYTransitionTypeRippleEffect, // rippleEffect
    CYTransitionTypeCameraIrisHollowOpen,
    CYTransitionTypeCameraIrisHollowClose
};

typedef NS_ENUM(NSUInteger, CYTransitionDirection) {
    CYTransitionDirectionNone,
    CYTransitionDirectionFromTop,
    CYTransitionDirectionFromLeft,
    CYTransitionDirectionFromRight,
    CYTransitionDirectionFromBottom
};

@interface CYTransitionConfiguration : NSObject

@property (nonatomic, assign) CYTransitionType type;

@property (nonatomic, assign) CYTransitionDirection subtype;

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, assign) CYTransitionMode mode;

// set YES when the type != CYTransitionTypeNone
// default is NO
@property (nonatomic, readonly, assign) BOOL transitionEnabled;

@end
