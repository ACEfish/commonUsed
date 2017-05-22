//
//  ITConcurrentCoreDataManager.h
//  conductor
//
//  Created by 栗豫塬 on 17/3/9.
//  Copyright © 2017年 intretech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITConcurrentCoreDataManager : NSObject

/**
 初始化ITConcurrentCoreDataManager
 
 @return @return ITConcurrentCoreDataManager对象
 */
+ (instancetype)manager;


- (void)creatObjectWithEntity:(Class)entityClass predicate:(NSPredicate *)predicate handelBlock:(void(^)(id obj))handelBlock;


/**
 异步处理coreData查询
 */
- (void)concurrentRetrieveObjectWithEntity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict handelBlock:(void(^)(id result, NSError *error))handelBlock;

- (void)saveManagedContext:(void(^)(NSError *error))handelBlock;

@end
