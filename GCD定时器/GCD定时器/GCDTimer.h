//
//  GCDTimer.h
//  GCD定时器
//
//  Created by 栗豫塬 on 16/10/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

+ (instancetype)timer;

- (void)dispatchTimerWithName:(NSString *)timerName
                 timeInterval:(double)interval
                        queue:(dispatch_queue_t)queue
                       repeat:(BOOL)repeats
                       action:(dispatch_block_t)actionBlock;

- (void)cancelTimerWithName:(NSString *)timerName;

@end
