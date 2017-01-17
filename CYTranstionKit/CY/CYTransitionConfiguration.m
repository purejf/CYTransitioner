//
//  CYTransitionConfiguration.m
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import "CYTransitionConfiguration.h"

@interface CYTransitionConfiguration ()

// default is NO
@property (nonatomic, assign) BOOL transitionEnabled;

@end

@implementation CYTransitionConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _type = CYTransitionTypeNone;
        _subtype = CYTransitionDirectionNone;
        _duration = 0.5;
//        _mode = CYTransitionModePush;
        _transitionEnabled = NO;
    }
    return self;
}

- (void)setType:(CYTransitionType)type {
    _type = type;
    if (type != CYTransitionTypeNone) {
        _transitionEnabled = YES;
    }
}

- (BOOL)transitionEnabled {
    if (_type == CYTransitionTypeNone) {
        return NO;
    }
    return _transitionEnabled;
}

- (void)setDuration:(NSTimeInterval)duration {
    if (duration > 1 || duration == 0) {
        _duration = 0.5;
    } else {
        _duration = duration;
    }
}

@end
