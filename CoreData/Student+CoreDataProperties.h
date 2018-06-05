//
//  Student+CoreDataProperties.h
//  CoreData
//
//  Created by liangchengyou on 2018/6/5.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t studentAge;
@property (nonatomic) int64_t studentId;
@property (nullable, nonatomic, copy) NSString *studentName;
@property (nullable, nonatomic, copy) NSString *sex;

@end

NS_ASSUME_NONNULL_END
