//
//  ViewController.m
//  CoreData
//
//  Created by liangchengyou on 2018/6/4.
//  Copyright © 2018年 liangchengyou. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataOperation.h"
#import "StudentCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *baseTab;
@property (nonatomic, strong) NSArray *resArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.baseTab];
    CoreDataOperation *operation = [CoreDataOperation shareDefault];
//    for (int i = 0; i < 10; i++) {
//        Student *student = (Student *)[operation addNewDataWithModelName:@"Student"];
//        student.studentName = [NSString stringWithFormat:@"测试%d",i];
//        student.studentId = 1000+arc4random()%500;
//        student.studentAge = 12+arc4random()%5;
//        if ([operation saveDataBase]) {
//            NSLog(@"插入成功");
//        }else {
//            NSLog(@"插入失败");
//        }
//    }
//    Student *student = (Student *)[operation addNewDataWithModelName:@"Student"];
//    student.studentName = [NSString stringWithFormat:@"测试%d",11];
//    student.studentId = 1000+arc4random()%500;
//    student.studentAge = 12+arc4random()%5;
//    student.sex = @"女";
//    if ([operation saveDataBase]) {
//        NSLog(@"插入成功");
//    }else {
//        NSLog(@"插入失败");
//    }
    
    //删除
//    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"studentName =%@",@"测试9"];
//    if ([operation deleteDataWithPredicate:predicate1 modeName:@"Student"]) {
//        NSLog(@"删除成功");
//    }else {
//        NSLog(@"删除失败");
//    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"studentAge > %d",-1];
    NSArray *resArray = [operation readDataWithPredicate:predicate modeName:@"Student"];
//    for (Student *stu in resArray) {
//        NSLog(@"%@",stu.studentName);
//    }
    self.resArray = resArray;
    [self.baseTab reloadData];
}

-(UITableView *)baseTab {
    if (!_baseTab) {
        self.baseTab = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.baseTab.dataSource = self;
        self.baseTab.delegate = self;
    }
    return _baseTab;
}

#pragma mark -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _resArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"studentCell";
    StudentCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"StudentCell" owner:nil options:nil].firstObject;
    }
    if (_resArray.count > 0) {
        Student *model = [_resArray objectAtIndex:indexPath.row];
        cell.namelabel.text = model.studentName;
        cell.agelabel.text = [NSString stringWithFormat:@"%d",model.studentAge];
        cell.sexlabel.text = model.sex;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 127;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
