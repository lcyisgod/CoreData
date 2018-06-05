//
//  CoreDataOperation.h
//  CoreData
//
//  Created by liangchengyou on 2018/6/4.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Student+CoreDataClass.h"

@interface CoreDataOperation : NSObject
+(CoreDataOperation *)shareDefault;
//新增一个数据
-(id)addNewDataWithModelName:(NSString *)modelName;
//保存数据库
-(BOOL)saveDataBase;
//删除
-(BOOL)deleteDataWithPredicate:(NSPredicate *)predicate modeName:(NSString *)modelName;
//读取数据
-(NSArray *)readDataWithPredicate:(NSPredicate *)predicate modeName:(NSString *)modelName;
@end
