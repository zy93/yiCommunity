//
//  DevicePopoverController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DevicePopoverController.h"

@interface DevicePopoverController ()
@property(nonatomic,strong) NSArray *itemArr;

@end

@implementation DevicePopoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedRefresh = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.preferredContentSize = CGSizeMake(100, 100);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isNeedRefresh) {
        [self.controller refreshView];
//        [self dismissViewControllerAnimated:YES completion:nil];
        self.isNeedRefresh = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"DevicePopoverController dealloc");
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.itemArr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, 80, 23)];//这里设frame无效
    view.backgroundColor = [UIColor clearColor];
    UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(3, 5, 94, 25)];
    [view addSubview:innerView];
    innerView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25];
    innerView.layer.cornerRadius = 3;
    innerView.layer.masksToBounds = YES;
    cell.selectedBackgroundView = view;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 33;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self dismissViewControllerAnimated:NO completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate devicePopoverContollerDidChooseIndex:indexPath.row];
            });
        }];
        
    });
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)itemArr {
	if(_itemArr == nil) {
		_itemArr = @[@"分组设置",@"一键执行",@"智能场景"];
	}
	return _itemArr;
}

@end
