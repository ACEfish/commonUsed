//
//  GCDTimer.m
//  GCD定时器
//
//  Created by 栗豫塬 on 16/10/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer ()

@property (nonatomic, strong) NSMutableDictionary *containDic;

@end


@implementation GCDTimer

+ (instancetype)timer {
    return [[GCDTimer alloc]init];
}


- (void)dispatchTimerWithName:(NSString *)timerName
                 timeInterval:(double)interval
                        queue:(dispatch_queue_t)queue
                       repeat:(BOOL)repeats
                       action:(dispatch_block_t)actionBlock {
    if (nil == timerName) {
        return;
    }
    if (nil == queue) {
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    dispatch_source_t timer = [self.containDic objectForKey:timerName];
    if (!timer) {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        [self.containDic setObject:timer forKey:timerName];
    }
    //设置timer的首次执行时间、执行间隔、精度
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        actionBlock();
        if (!repeats) {
            [weakSelf cancelTimerWithName:timerName];
        }
    });
    
    dispatch_resume(timer);
}

- (void)cancelTimerWithName:(NSString *)timerName {
    dispatch_source_t timer = [self.containDic objectForKey:timerName];
    if (!timer) {
        return;
    }
    dispatch_source_cancel(timer);
    [self.containDic removeObjectForKey:timerName];
    
}




#pragma mark --- setter&getter ---

- (NSMutableDictionary *)containDic {
    if (!_containDic) {
        _containDic = [NSMutableDictionary dictionary];
    }
    return _containDic;
}












@end
