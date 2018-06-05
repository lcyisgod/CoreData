//
//  CoreDataOperation.m
//  CoreData
//
//  Created by liangchengyou on 2018/6/4.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "CoreDataOperation.h"
static CoreDataOperation *operation = nil;

@interface CoreDataOperation()

//数据模型管理器
@property (nonatomic, strong) NSManagedObjectModel *managerModel;
//创建持久化存储器
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//管理上下文
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
@implementation CoreDataOperation

+(CoreDataOperation *)shareDefault {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        operation = [[CoreDataOperation alloc] init];
    });
    return operation;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _context = self.context;
    }
    return self;
}

-(NSManagedObjectModel *)managerModel {
    if (!_managerModel) {
        //指定数据库的位置
        //url 为CoreData.xcdatamodeld，注意扩展名为 momd，而不是 xcdatamodel
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
        _managerModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    }
    return _managerModel;
}

//创建 persistentStoreCoordinator，因为它的创建需要用到 managedObjectModel，managedObjectModel 告诉了persistentStoreCoordinator 数据模型的结构，然后 persistentStoreCoordinator 会根据对应的模型结构创建持久化的本地存储。
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        //创建coredinator需要传入 managedObjectModel
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managerModel];
        //请求自动迁移轻量数据(默认支持)
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES],NSInferMappingModelAutomaticallyOption,nil];
        //指定本地的sqlite数据文件
        NSURL *sqliteUrl = [[self documentDirectoryURL] URLByAppendingPathComponent:@"CoreData.sqlite"];
        NSError *error;
        //为persistentStoreCoordinator指定本地存储的类型，这里指定为Sqlite类型
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteUrl options:options error:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    return _persistentStoreCoordinator;
}

// 用来获取 document 目录
- (nullable NSURL *)documentDirectoryURL {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

//管理上下文
-(NSManagedObjectContext *)context {
    if (!_context) {
        //指定contextd的并发类型:
        //NSMainQueueConcurrencyType   :在主队列中创建并管理context。与UI更新相关时采用
        //NSPrivateQueueConcurrencyType:在私有队列中创建并管理context。涉及大量数据操作可能会阻塞UI时
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _context;
}

-(id)addNewDataWithModelName:(NSString *)modelName {
    id obj = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:_context];
    return obj;
}

-(BOOL)saveDataBase{
    return [_context save:nil];
}
/* 谓词的条件指令
 1.比较运算符 > 、< 、== 、>= 、<= 、!=
 例：@"number >= 99"
 
 2.范围运算符：IN 、BETWEEN
 例：@"number BETWEEN {1,5}"
 @"address IN {'shanghai','nanjing'}"
 
 3.字符串本身:SELF
 例：@"SELF == 'APPLE'"
 
 4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
 例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
 @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
 @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
 
 5.通配符：LIKE
 例：@"name LIKE[cd] '*er*'"   *代表通配符,Like也接受[cd].
 @"name LIKE[cd] '???er*'"
 
 *注*: 星号 "*" : 代表0个或多个字符
 问号 "?" : 代表一个字符
 
 6.正则表达式：MATCHES
 例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
 @"name MATCHES %@",regex
 
 注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
 
 7. 合计操作
 ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
 ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
 NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
 IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
 
 提示:
 1. 谓词中的匹配指令关键字通常使用大写字母
 2. 谓词中可以使用格式字符串
 3. 如果通过对象的key
 path指定匹配条件，需要使用%K
 
 从第几页开始显示
 通过这个属性实现分页
 request.fetchOffset = 0;
 每页显示多少条数据
 request.fetchLimit = 6;

 */

-(BOOL)deleteDataWithPredicate:(NSPredicate *)predicate modeName:(NSString *)modelName{
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
    request.predicate = predicate;
    //发送查询请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    //删除数据
    for (id model in resArray) {
        [_context deleteObject:model];
    }
    //保存
    return [self saveDataBase];
}

-(NSArray *)readDataWithPredicate:(NSPredicate *)predicate modeName:(NSString *)modelName {
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:modelName];
    request.predicate = predicate;
    //发送查询请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    return resArray;
}



@end
