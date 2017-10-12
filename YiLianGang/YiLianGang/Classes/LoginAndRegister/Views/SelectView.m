//
//  SelectView.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/5.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "SelectView.h"
@interface SelectView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UIButton *cancelButton;
@property(nonatomic,strong) NSArray *listArr;
@property(nonatomic,strong) NSString *identify;
 
@end
@implementation SelectView
+(instancetype)selectViewWithTableListArray:(NSArray *)listArr dictIdentify:(NSString*)identify withFrame:(CGRect)frame{
    SelectView *selectView = [[SelectView alloc]initWithFrame:frame];
    selectView.listArr = listArr;
    selectView.identify = identify;
    return selectView;
}

-(void)setNeedsDisplay{
    [super setNeedsDisplay];
    
    [self addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self addSubview:self.cancelButton];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
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
    cell.textLabel.text = [self.listArr[indexPath.row]valueForKey:self.identify];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.selectDelegate selectView:self didSelectRow:indexPath.row string:self.listArr[indexPath.row]];
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
    if(self.superview.tag == 55){
        [self.superview removeFromSuperview];
    }else{
        [self removeFromSuperview];
    }
}
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50) style:UITableViewStylePlain];
	}
	return _tableView;
}

- (UIButton *)cancelButton {
	if(_cancelButton == nil) {
		_cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancelButton.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        view.backgroundColor =[UIColor colorWithRed:0.7928 green:0.7928 blue:0.7928 alpha:1.0];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton addSubview:view];
        [_cancelButton addTarget:self action:@selector(clickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	}
	return _cancelButton;
}


@end
