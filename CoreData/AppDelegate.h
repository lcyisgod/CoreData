//
//  AppDelegate.h
//  CoreData
//
//  Created by liangchengyou on 2018/6/4.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

