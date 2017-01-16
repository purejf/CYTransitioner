//
//  ViewController.m
//  CYTranstionKit
//
//  Created by Charles on 17/1/16.
//  Copyright © 2017年 Charles. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "UIViewController+CY.h"
#import "CYTransitionConfiguration.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SecondViewController *v = (SecondViewController *)segue.destinationViewController;
    CYTransitionConfiguration *con = [CYTransitionConfiguration new];
    con.type = CYTransitionTypeReveal;
    con.subtype = CYTransitionDirectionFromRight;
    v.con = con;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
