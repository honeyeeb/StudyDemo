//
//  HBNotifications.m
//  MultiNotifications
//
//  Created by honeyeeb on 2018/11/22.
//  Copyright © 2018 honeyeeb. All rights reserved.
//

#import "HBNotifications.h"


NSNotificationName const HB_MULTI_NOTIFICATION_NAME = @"HB_MULTI_NOTIFICATION_NAME";

@interface HBNotifications()<NSMachPortDelegate>

@property (nonatomic, strong) NSMutableArray *notificationArray;
@property (nonatomic, strong) NSLock *notificationsLock;
@property (nonatomic, strong) NSMachPort *notificationsPort;
@property (nonatomic, strong) NSThread *notificationsThread;

@end

@implementation HBNotifications

- (instancetype)init {
    if (self = [super init]) {
        [self setUpThreadingSupport];
    }
    return self;
}

- (void)setUpThreadingSupport {
    
    if (self.notificationArray) {
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processNotification:) name:HB_MULTI_NOTIFICATION_NAME object:nil];
    self.notificationArray = [NSMutableArray array];
    self.notificationsLock = [NSLock new];
    self.notificationsPort = [NSMachPort new];
    [self.notificationsPort setDelegate:self];
    self.notificationsThread = [NSThread currentThread];
    NSLog(@"init thred:%@", [NSThread currentThread]);
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    [currentRunloop addPort:self.notificationsPort forMode:NSRunLoopCommonModes];
    [currentRunloop run];
}

- (void)handlePortMessage:(NSPortMessage *)message {
    
    [self.notificationsLock lock];
    
    while (self.notificationArray.count > 0) {
        NSNotification *notification = self.notificationArray[0];
        [self.notificationsLock unlock];
        [self.notificationArray removeObjectAtIndex:0];
        [self processNotification:notification];
        [self.notificationsLock lock];
    }
    
    [self.notificationsLock unlock];
}

- (void)processNotification:(NSNotification *)notification {
    if (!notification) {
        return;
    }
    if (self.notificationsThread != [NSThread currentThread]) {
        [self.notificationsLock lock];
        [self.notificationArray addObject:notification];
        [self.notificationsLock unlock];
        [self.notificationsPort sendBeforeDate:[NSDate date] components:nil from:nil reserved:0];
    } else {
        // 处理任务
        
        NSLog(@"handle notification actions thread:%@", [NSThread currentThread]);
    }
}

@end
