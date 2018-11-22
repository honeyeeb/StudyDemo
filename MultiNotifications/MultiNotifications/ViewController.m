//
//  ViewController.m
//  MultiNotifications
//
//  Created by honeyeeb on 2018/11/22.
//  Copyright © 2018 honeyeeb. All rights reserved.
//
// ref:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/Notifications/Articles/Threading.html

#import "ViewController.h"
#import "HBNotifications.h"

@interface ViewController ()

@property (nonatomic, strong) HBNotifications   *multiNotification;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Action" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 100, 44);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self performSelectorInBackground:@selector(setupNotification) withObject:nil];
}

- (void)setupNotification {
    
    self.multiNotification = [[HBNotifications alloc] init];
}

- (void)buttonAction:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HB_MULTI_NOTIFICATION_NAME object:nil];
}

@end
