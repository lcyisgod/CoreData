//
//  Student+CoreDataProperties.m
//  CoreData
//
//  Created by liangchengyou on 2018/6/5.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic studentAge;
@dynamic studentId;
@dynamic studentName;
@dynamic sex;

@end
