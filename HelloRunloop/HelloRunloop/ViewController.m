//
//  ViewController.m
//  HelloRunloop
//
//  Created by honeyeeb on 2018/11/22.
//  Copyright © 2018 honeyeeb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Action" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(action1) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"Action2" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(action2) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 200, 100, 40);
    [self.view addSubview:button2];
    
}

- (void)test1 {
    NSLog(@"test1:%@", [NSThread currentThread]);
}

- (void)test2 {
    NSLog(@"test2:%@", [NSThread currentThread]);
}

- (void)test3 {
    NSLog(@"test3:%@", [NSThread currentThread]);
}

- (void)action1 {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self test1];
        [self performSelector:@selector(test2) withObject:nil];
        [self performSelector:@selector(test3) withObject:nil afterDelay:0];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)action2 {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"test4");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"test5");
    });
    [self performSelector:@selector(test2) withObject:nil];
    [self performSelector:@selector(test3) withObject:nil afterDelay:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"test6");
    });
    [self test1];
}

@end
