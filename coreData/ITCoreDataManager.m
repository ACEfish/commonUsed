//
//  ITCoreDataManager.m
//  conductor
//
//  Created by pengchengwu on 16/9/5.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "ITCoreDataManager.h"

@implementation ITCoreDataManager

+ (instancetype)sharedInstance {
    static dispatch_once_t __singletonToken;
    static ITCoreDataManager *__singleton__;
    dispatch_once( &__singletonToken, ^{
        __singleton__ = [[self alloc] init];
    } );
    return __singleton__;
}

//For iOS 10
//- (void)creatPersistentContainer:(NSString *)modeldName {
//    NSPersistentContainer *persistentContainer = [[NSPersistentContainer alloc] initWithName:modeldName];
//    [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//        if (error != nil) {
//            NSLog(@"LoadPersistentStores error %@, %@", error, error.userInfo);
//        }
//    }];
//    [self.persistentContainersDict setObject:persistentContainer forKey:modeldName];
//    [self.objectContextsDict setObject:persistentContainer.viewContext forKey:modeldName];
//}

- (NSManagedObjectModel *)managedObjectModel:(NSString *)modeldName {
    if ([self.objectModelDict objectForKey:modeldName] != nil) {
        return [self.objectModelDict objectForKey:modeldName];
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modeldName withExtension:@"momd"];
    NSManagedObjectModel *objectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    [self.objectModelDict setObject:objectModel forKey:modeldName];
    return objectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator:(NSString *)modeldName {
    if ([self.persistentStoreCoordinatorDict objectForKey:modeldName] != nil) {
        return [self.persistentStoreCoordinatorDict objectForKey:modeldName];
    }
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel:modeldName]];
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",modeldName]];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [self.persistentStoreCoordinatorDict setObject:coordinator forKey:modeldName];
    return coordinator;
}

- (NSManagedObjectContext *)managedObjectContext:(NSString *)modeldName  {
    if ([self.objectContextsDict objectForKey:modeldName] != nil) {
        return [self.objectContextsDict objectForKey:modeldName];
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator:modeldName];
    if (!coordinator) {
        return nil;
    }
    NSManagedObjectContext *objectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [objectContext setPersistentStoreCoordinator:coordinator];
    [self.objectContextsDict setObject:objectContext forKey:modeldName];
    return objectContext;
}

- (id)creatObject:(NSString *)modeldName entity:(Class)entityClass {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(entityClass) inManagedObjectContext:[self managedObjectContext:modeldName]];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate {
    return [self retrieveObject:modeldName entity:entityClass predicate:predicate offset:0 batchSize:0 limit:0 sortDescriptor:nil];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate sort:(NSString *)sortKey ascending:(BOOL)ascending {
    return [self retrieveObject:modeldName entity:entityClass predicate:predicate offset:0 batchSize:0 limit:0 sort:sortKey ascending:ascending];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate sortDescriptor:(NSDictionary *)sortDict {
    return [self retrieveObject:modeldName entity:entityClass predicate:predicate offset:0 batchSize:0 limit:0 sortDescriptor:sortDict];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit {
    return [self retrieveObject:modeldName entity:entityClass predicate:predicate offset:offset batchSize:batchSize limit:limit sortDescriptor:nil];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sort:(NSString *)sortKey ascending:(BOOL)ascending {
    return [self retrieveObject:modeldName entity:entityClass predicate:predicate offset:offset batchSize:batchSize limit:limit sortDescriptor:@{sortKey:[NSNumber numberWithBool:ascending]}];
}

- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *aEntity = [NSEntityDescription entityForName:NSStringFromClass(entityClass) inManagedObjectContext:[self managedObjectContext:modeldName]];
    [fetchRequest setEntity:aEntity];
    
    fetchRequest.fetchOffset = offset;
    fetchRequest.fetchBatchSize = batchSize;
    fetchRequest.fetchLimit = limit;

    if (predicate != nil) {
        [fetchRequest setPredicate:predicate];
    }
    
    if (sortDict != nil) {
        NSMutableArray *sortArr = [NSMutableArray array];
        for (NSString *aKey in sortDict.allKeys) {
            NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:aKey ascending:[[sortDict objectForKey:aKey] boolValue]];
            [sortArr addObject:aSortDescriptor];
        }
        [fetchRequest setSortDescriptors:sortArr];
    }
    
    NSError *error = nil;
    NSArray *resultArr = [NSArray array];
    resultArr = [[self managedObjectContext:modeldName] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"retrieveObject error %@, %@", error, error.userInfo);
    }
    return resultArr;
}

- (void)deleteObject:(NSString *)modeldName object:(id)object {
    [[self managedObjectContext:modeldName] deleteObject:object];
}

- (void)deleteObject:(NSString *)modeldName objsArr:(NSArray *)objsArr {
    for (id obj in objsArr) {
        [self deleteObject:modeldName object:obj];
    }
}

- (BOOL)saveContext:(NSString *)modeldName {
    NSManagedObjectContext *context = [self managedObjectContext:modeldName];
    if (context != nil) {
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            NSLog(@"saveContext error %@, %@", error, [error userInfo]);
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)saveAllContext {
    for (NSString *modeldName in self.objectContextsDict.allKeys) {
        [self saveContext:modeldName];
    }
}

#pragma mark - get method
- (NSMutableDictionary<NSString *,NSManagedObjectContext *> *)objectContextsDict {
    if (_objectContextsDict == nil) {
        _objectContextsDict = [[NSMutableDictionary alloc]init];
    }
    return _objectContextsDict;
}

- (NSMutableDictionary<NSString *,NSManagedObjectModel *> *)objectModelDict {
    if (_objectModelDict == nil) {
        _objectModelDict = [[NSMutableDictionary alloc]init];
    }
    return _objectModelDict;
}

- (NSMutableDictionary<NSString *,NSPersistentStoreCoordinator *> *)persistentStoreCoordinatorDict {
    if (_persistentStoreCoordinatorDict == nil) {
        _persistentStoreCoordinatorDict = [[NSMutableDictionary alloc]init];
    }
    return _persistentStoreCoordinatorDict;
}

//- (NSMutableDictionary<NSString *,NSPersistentContainer *> *)persistentContainersDict {
//    if (_persistentContainersDict == nil) {
//        _persistentContainersDict = [[NSMutableDictionary alloc]init];
//    }
//    return _persistentContainersDict;
//}

@end
