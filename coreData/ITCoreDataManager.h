//
//  ITCoreDataManager.h
//  conductor
//
//  Created by pengchengwu on 16/9/5.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface ITCoreDataManager : NSObject

//@property (nonatomic, strong) NSMutableDictionary<NSString *,NSPersistentContainer *> * persistentContainersDict;
//@property (nonatomic, strong) NSMutableDictionary<NSString *,NSManagedObjectContext *> * objectContextsDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *,NSManagedObjectContext *> * objectContextsDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSManagedObjectModel *> * objectModelDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSPersistentStoreCoordinator *> * persistentStoreCoordinatorDict;

/**
 初始化ITCoreDataManager

 @return @return ITCoreDataManager对象
 */
+ (instancetype)sharedInstance;

/**
 创建持久化存储器

 @param modeldName @param modeldName 模型包名
 */
//- (void)creatPersistentContainer:(NSString *)modeldName;

/**
 创建一个实体对象
 
 @param modeldName  模型包名
 @param entityClass 实体名
 
 @return 实体对象
 */
- (id)creatObject:(NSString *)modeldName entity:(Class)entityClass;

/**
 条件查询
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate;

/**
 单关键字排序查询
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 @param sortKey     排序关键字
 @param ascending   是否升序
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate sort:(NSString *)sortKey ascending:(BOOL)ascending;

/**
 多关键字排序查询
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 @param sortDict    排序关键字字典
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate sortDescriptor:(NSDictionary *)sortDict;

/**
 分页查询
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 @param offset      查询起始索引
 @param batchSize   查询条目总数
 @param limit       查询结果数量限制
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit;

/**
 分页查询并单关键字排序
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 @param offset      查询起始索引
 @param batchSize   查询条目总数
 @param limit       查询结果数量限制
 @param sortKey     排序关键字
 @param ascending   是否升序
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sort:(NSString *)sortKey ascending:(BOOL)ascending;

/**
 分页查询并多关键字排序
 
 @param modeldName  模型包名
 @param entityClass 实体类型
 @param predicate   查询语句
 @param offset      查询起始索引
 @param batchSize   查询条目总数
 @param limit       查询结果数量限制
 @param sortDict    排序关键字字典
 
 @return 查询结果数组
 */
- (NSArray *)retrieveObject:(NSString *)modeldName entity:(Class)entityClass predicate:(NSPredicate *)predicate offset:(NSUInteger)offset batchSize:(NSUInteger)batchSize limit:(NSUInteger)limit sortDescriptor:(NSDictionary *)sortDict;

/**
 删除一个条目
 
 @param modeldName 模型包名
 @param object     条目对象
 */
- (void)deleteObject:(NSString *)modeldName object:(id)object;

/**
 删除条目数组
 
 @param modeldName 模型包名
 @param objsArr    条目数组
 */
- (void)deleteObject:(NSString *)modeldName objsArr:(NSArray *)objsArr;

/**
 保存上下文
 
 @param modeldName 模型包名
 
 @return 是否保存成功
 */
- (BOOL)saveContext:(NSString *)modeldName;

/**
 保存所有上下文
 */
- (void)saveAllContext;

//多条件之间使用AND
//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date = %@",[NSDate date]];
//[fetchR setPredicate:predicate]; //关联外键之后查找可使用.语法 abc.name
//Format：
//(1)比较运算符>,<,==,>=,<=,!=
//可用于数值及字符串
//例：@"number > 100"
//
//
//(2)范围运算符：IN、BETWEEN
//例：@"number BETWEEN {1,5}"
//@"address IN {'shanghai','beijing'}"
//
//
//(3)字符串本身:SELF
//例：@“SELF == ‘APPLE’"
//
//
//(4)字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
//例：@"name CONTAINS[cd] 'ang'"   //包含某个字符串
//@"name BEGINSWITH[c] 'sh'"     //以某个字符串开头
//@"name ENDSWITH[d] 'ang'"      //以某个字符串结束
//注:[c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
//
//
//(5)通配符：LIKE
//例：@"name LIKE[cd] '*er*'"    //*代表通配符,Like也接受[cd].
//@"name LIKE[cd] '???er*'"
//
//(6)正则表达式：MATCHES
//例：NSString *regex = @"^A.+e$";   //以A开头，e结尾
//@"name MATCHES %@",regex


@end
