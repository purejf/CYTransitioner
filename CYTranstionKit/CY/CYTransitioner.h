//
//  CYTransitioner.h
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYTransitionConfiguration;

@interface CYTransitioner : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) CYTransitionConfiguration *con;

@end
