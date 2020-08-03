//
//  ViewController.m
//  Day16_1 OC(RunTime_API)
//
//  Created by 亿存 on 2020/7/30.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ViewController.h"
#import "ClassViewController.h"
#import "IvarViewController.h"
#import "MethodViewController.h"
#import "PropertyViewController.h"
#import "ProtocolViewController.h"
#import "ObjcController.h"
#import "SELController.h"
#import "MsgSendViewController.h"
@interface ViewController ()<UITableViewDataSource , UITableViewDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , copy) NSArray<NSString *> *titles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"%@",indexPath);
    if (indexPath.row == 0) {
        ClassViewController *classVC = [[ClassViewController alloc] init];
        [self.navigationController pushViewController:classVC animated:true];
    }else if (indexPath.row == 1) {
        IvarViewController *classVC = [[IvarViewController alloc] init];
        [self.navigationController pushViewController:classVC animated:true];
    }else if (indexPath.row == 2) {
        MethodViewController *vc = [[MethodViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 3){
        PropertyViewController *vc = [[PropertyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 4){
        ProtocolViewController *vc = [[ProtocolViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 5){
        ObjcController *vc = [[ObjcController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 6){
        SELController *vc = [[SELController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }else if (indexPath.row == 7){
        MsgSendViewController *vc = [[MsgSendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    }
    
    
}

- (NSArray<NSString *> *)titles{
    if (_titles == nil) {
        _titles = @[@"Class",@"Ivar", @"Method", @"Property", @"Protocol", @"Object", @"SEL", @"msgSend"];
    }
    return _titles;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}


@end
