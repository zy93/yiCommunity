//
//  SelectUtil.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/21.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "SelectUtil.h"
static SelectUtil *instance;
@interface SelectUtil()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *listArr;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) SelctBlock block;
@property(nonatomic,strong) UIView *containerView;
@property(nonatomic,strong) UIButton *cancelButton;
@end
@implementation SelectUtil
+(instancetype)sharedSelectUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SelectUtil new];
    });
    return instance;
}
-(void)showSelectArray:(NSArray *)arr selectBlock:(SelctBlock)block{
    if (arr) {
        if (self.containerView) {
            [self.containerView removeFromSuperview];
        }
        self.listArr = arr;
        self.block = block;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        self.containerView = view;
        UIView *innerContainerView = [[UIView alloc]initWithFrame:CGRectMake(width*0.2, height*0.2, width*0.6, height*0.6)];
        innerContainerView.backgroundColor = [UIColor whiteColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width*0.6, height*0.6-35) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [innerContainerView addSubview:self.tableView];
        innerContainerView.layer.cornerRadius = 7;
        innerContainerView.layer.masksToBounds = YES;
        //取消按钮
        self.cancelButton =[UIButton buttonWithType:UIButtonTypeSystem];
        self.cancelButton.frame = CGRectMake(0, height*0.6-35, width*0.6, 35);
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [innerContainerView addSubview:self.cancelButton];
        [self.containerView addSubview:innerContainerView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.containerView];
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"selectCell"];
    }
    cell.textLabel.text = self.listArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.block(indexPath.row,self.listArr[indexPath.row]);
    [self clickCancelButton:nil];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)clickCancelButton:(UIButton*)button{
    [self.containerView removeFromSuperview];
}




@end
