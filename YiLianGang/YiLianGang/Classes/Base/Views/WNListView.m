//
//  WNListView.m
//  MenuTest
//
//  Created by Way_Lone on 16/9/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "WNListView.h"
#define ListHeightForCell 35

typedef enum{
    UpDirType,
    DownDirType,
}DirectType;
@interface WNListView ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong) UITableView *listView;
@property(nonatomic,assign) DirectType dirType;
@property(nonatomic,strong) UIView *supView;
@end

@implementation WNListView
+(instancetype)listViewWithArrayStr:(NSArray *)strArr acordingFrameInScreen:(CGRect)frame superView:(UIView*)superView clickResponse:(ListBlock)listBlock{
    WNListView *lv = [[WNListView alloc]initWithArr:strArr frame:frame superView:superView response:listBlock];
    
    
    return lv;
    
}
//-(void)drawRect:(CGRect)rect{
//    
//}
-(instancetype)initWithArr:(NSArray*)strArr frame:(CGRect)frame superView:(UIView*)superView response:(ListBlock)listBlock{
    if (self = [super init]) {
        self.listArr = strArr;
        self.listBlock = listBlock;
        self.frameAcording = frame;
        self.supView = superView;
        [self awakeFromNib];
    }
    return self;
}
-(void)dealloc{
    NSLog(@"WNListView dealloc");
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self endEditing:YES];
    self.backgroundColor = [UIColor clearColor];
    if (!self.listBackgroundColor) {
        self.listBackgroundColor = [UIColor colorWithRed:0.9361 green:0.9361 blue:0.9361 alpha:1.0];
    }
    if(self.supView){
        self.frame = self.supView.bounds;
        [self.supView addSubview:self];
    }else{
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    }
    CGFloat x = self.frameAcording.origin.x;
    CGFloat y = self.frameAcording.origin.y;
    CGFloat width = self.frameAcording.size.width;
    CGFloat height = self.frameAcording.size.height;
    CGFloat maxHeight = (self.frame.size.height+self.frame.origin.y-height)/2;
    CGFloat rHeight;
    if (self.listArr.count*ListHeightForCell>maxHeight) {
        rHeight = ((int)maxHeight/ListHeightForCell)*ListHeightForCell;
    }else{
        rHeight = self.listArr.count*ListHeightForCell;
    }
    CGPoint center = CGPointMake(_frameAcording.origin.x+_frameAcording.size.width/2, _frameAcording.origin.y+_frameAcording.size.height/2);
    if (center.y>self.frame.origin.y + self.frame.size.height/2) {
        self.dirType = UpDirType;
    }else{
        self.dirType = DownDirType;
    }
    
    if(self.dirType == UpDirType){
        self.listView = [[UITableView alloc]initWithFrame:CGRectMake(x, y-2-rHeight, width, rHeight) style:UITableViewStylePlain];
    }else{
        self.listView = [[UITableView alloc]initWithFrame:CGRectMake(x, y+height+2, width, rHeight) style:UITableViewStylePlain];
    }
    self.listView.dataSource = self;
    self.listView.delegate = self;
    self.listView.layer.cornerRadius = 3;
    self.listView.layer.masksToBounds = YES;
    self.listView.backgroundColor = self.listBackgroundColor;
    
    [self addSubview:self.listView];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}
-(void)tapGesture:(UITapGestureRecognizer*)gesture{
    
    [self removeFromSuperview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark UITableViewDelegate && datesource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.listArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ListHeightForCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listBlock(indexPath.row);
    });
    [self listQuit];
}
-(void)listQuit{
    [self removeFromSuperview];
}
@end
