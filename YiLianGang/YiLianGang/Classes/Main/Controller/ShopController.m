//
//  ShopController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "ShopController.h"
#import "LZBFocusScrollView.h"
@interface ShopController ()
@property(nonatomic,strong) LZBFocusScrollView *adsView;
@end

@implementation ShopController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商店";
    self.tableView.tableHeaderView =self.adsView;
    [self.tabBarController.tabBar setHidden:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"ShopController dealloc");

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
        imageView.tag = 100;
        [cell addSubview:imageView];
    }
    if (indexPath.row == 0) {
        UIImageView *imageView = [cell viewWithTag:100];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.4194);
        imageView.image = [UIImage imageNamed:@"shop1.jpg"];
    }else{
        UIImageView *imageView = [cell viewWithTag:100];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*1.5313);
        imageView.image = [UIImage imageNamed:@"shop2.jpg"];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return self.view.frame.size.width*0.4194;
    }else{
        return self.view.frame.size.width*1.5313;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (LZBFocusScrollView *)adsView {
	if(_adsView == nil) {
		_adsView = [[LZBFocusScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.4029) WithImageArray:@[[UIImage imageNamed:@"ads01.jpg"],[UIImage imageNamed:@"ads02.jpg"],[UIImage imageNamed:@"ads03.jpg"],[UIImage imageNamed:@"ads04.jpg"],[UIImage imageNamed:@"ads05.jpg"]]];
	}
	return _adsView;
}

@end
