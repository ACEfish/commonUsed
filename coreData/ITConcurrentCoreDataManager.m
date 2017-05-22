//
//  ITConcurrentCoreDataManager.m
//  conductor
//
//  Created by 栗豫塬 on 17/3/9.
//  Copyright © 2017年 intretech. All rights reserved.
//

static NSString *const CoreData_FileName = @"ConductorModel";

#import "ITConcurrentCoreDataManager.h"
#import <CoreData/CoreData.h>

@interface ITConcurrentCoreDataManager ()

/** 私有队列上下文 */
@property (nonatomic, strong) NSManagedObjectContext *bgContext;

/** 主队列上下文 */
@property (nonatomic, strong) NSManagedObjectContext *mainContext;

/** 持久化协调器 */
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

@end

@implementation ITConcurrentCoreDataManager

+ (instancetype)manager {
    static ITConcurrentCoreDataManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ITConcurrentCoreDataManager alloc] init];
    });

    return manager;
}

- (NSManagedObjectContext *)privateConcurrenContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:self.mainContext];
    
    return context;
}

#pragma mark - 增 -

- (void)creatObjectWithEntity:(Class)entityClass handelBlock:(void(^)(id obj))handelBlock {
    
}


- (void)creatObjectWithEntity:(Class)entityClass predicate:(NSPredicate *)predicate handelBlock:(void(^)(id obj))handelBlock {
    [self retrieveObjectWithEntity:entityClass predicate:predicate offset:0 batchSize:0 limit:0 sortDescriptor:nil handelBlock:^(NSArray *result, NSError *error) {
        if (result && result.count>0) {
            handelBlock(result.firstObject);
        } else {
            [self creatObjectWithEntity:entityClass handelBlock:handelBlock];
        }
    }];
}

#pragma mark - 查 -


- (NSFetchRequest *)fetchRequestWithPredicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(entityClass)];
    //分页的起始索引
    fetchRequest.fetchOffset = offset;
    //查询条目总数
    fetchRequest.fetchBatchSize = batchSize;
    //分页后每页的条数
    fetchRequest.fetchLimit = limit;
    
    if (predicate) {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDict) {
        NSMutableArray *sortArr = [NSMutableArray array];
        for (NSString *aKey in sortDict.allKeys) {
            NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:aKey ascending:[[sortDict objectForKey:aKey] boolValue]];
            [sortArr addObject:aSortDescriptor];
        }
        [fetchRequest setSortDescriptors:sortArr];
    }
    return fetchRequest;
}

- (void)concurrentRetrieveObjectWithEntity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict handelBlock:(void(^)(id result,NSError *error))handelBlock {
    NSManagedObjectContext *context = [self privateConcurrenContext];
    [context performBlock:^{
        NSFetchRequest *fetchRequest = [self fetchRequestWithPredicate:predicate offset:offset batchSize:batchSize limit:limit sortDescriptor:sortDict];
        NSError *error = nil;
        NSArray *resultArr = [self.bgContext executeFetchRequest:fetchRequest error:&error];
        NSMutableArray *objectIdArr = [NSMutableArray array];
        for (NSManagedObject *obj in resultArr) {
            [objectIdArr addObject:obj.objectID];
        }
        [self.mainContext performBlock:^{
            NSMutableArray *objArr = [NSMutableArray array];
            for (NSManagedObjectID *objectID in objectIdArr) {
                [objArr addObject:[self.mainContext objectWithID:objectID]];
            }
            handelBlock(objArr,error);
        }];
    }];
}

- (void)retrieveObjectWithEntity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict handelBlock:(void(^)(NSArray *result,NSError *error))handelBlock {
    [self.bgContext performBlock:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(entityClass)];
        //分页的起始索引
        fetchRequest.fetchOffset = offset;
        //查询条目总数
        fetchRequest.fetchBatchSize = batchSize;
        //分页后每页的条数
        fetchRequest.fetchLimit = limit;
        
        if (predicate) {
            [fetchRequest setPredicate:predicate];
        }
        
        if (sortDict) {
            NSMutableArray *sortArr = [NSMutableArray array];
            for (NSString *aKey in sortDict.allKeys) {
                NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:aKey ascending:[[sortDict objectForKey:aKey] boolValue]];
                [sortArr addObject:aSortDescriptor];
            }
            [fetchRequest setSortDescriptors:sortArr];
        }
        
        NSError *error = nil;
        NSArray *resultArr = [NSArray array];
        resultArr = [self.bgContext executeFetchRequest:fetchRequest error:&error];
        if (error) {
            NSLog(@"retrieveObject error %@, %@", error, error.userInfo);
        }
        handelBlock(resultArr, error);
        
    }];
}

#pragma mark - 保存 -

- (void)saveManagedContext:(void(^)(NSError *error))handelBlock {
    __block NSError *error;
    if ([self.mainContext hasChanges]) {
        [self.mainContext save:&error];
        [self.bgContext performBlock:^{
           [self.bgContext save:&error];
            if (handelBlock) {
                handelBlock(error);
            }
        }];
    }
}

#pragma mark - Setter&&Getter -

- (NSPersistentStoreCoordinator *)coordinator {
    if (!_coordinator) {
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:CoreData_FileName withExtension:@"momd"];
        NSManagedObjectModel *modelObj = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:modelObj];
        NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", CoreData_FileName];
        [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];
        
    }
    return _coordinator;
}

- (NSManagedObjectContext *)bgContext {
    if (!_bgContext) {
        _bgContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _bgContext.persistentStoreCoordinator = self.coordinator;
    }
    return _bgContext;
}

- (NSManagedObjectContext *)mainContext {
    if (!_mainContext) {
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.parentContext = self.bgContext;
        
    }
    return _mainContext;
}


@end
