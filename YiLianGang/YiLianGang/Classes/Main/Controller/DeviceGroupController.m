//
//  DeviceGroupController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/30.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceGroupController.h"
#import "DeviceGroupCell.h"
#import "DevicePopoverController.h"
#import "DeviceTool.h"
#import "DeviceEditController.h"
@interface DeviceGroupController ()<UITableViewDataSource,UITableViewDelegate,DeviceGroupCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addGroupButton;
@property(nonatomic,strong) NSArray *groupArr;
@property(nonatomic,assign) BOOL isGroupEditing;
@property(nonatomic,assign) BOOL isClickRightEditButton;

@end

@implementation DeviceGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGroupEditing = NO;
    self.isClickRightEditButton = NO;
    [self doPrettyView];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

-(void)doPrettyView{
    self.addGroupButton.layer.cornerRadius = 4;
    self.addGroupButton.layer.masksToBounds = YES;
    
    //左边
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0, 0, 60, 40);
    [leftButton setTitle:@"        " forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    leftButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    [leftButton addTarget:self action:@selector(clickTopLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftView addSubview:leftButton];
    leftView.backgroundColor = [UIColor clearColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    //右边
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 60, 40);
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    rightButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(clickTopRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:rightButton];
    rightView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}

-(void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
/**点导航栏左键*/
-(void)clickTopLeftButton:(UIButton*)button{
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.lastPresentController refreshView];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
/**点导航栏右键*/
-(void)clickTopRightButton:(UIButton*)button{
    if (self.isClickRightEditButton == YES) {
        return;
    }
    self.isClickRightEditButton = YES;
    if (!self.isGroupEditing) {
        self.isGroupEditing = YES;
    }else{
        self.isGroupEditing = NO;
        
    }
    [self.tableView reloadData];
}
-(void)dealloc{
    NSLog(@"DeviceGroupController dealloc");
}

#pragma mark UITableViewDelegate&UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.groupArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceGroupCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceGroupCell" owner:nil options:nil].lastObject;
    }
    cell.delegate = self;
    if(self.isClickRightEditButton){
        if (self.isGroupEditing) {
            cell.editContentView.alpha = 0;
            
            cell.editContentView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                cell.editContentView.alpha = 1;
            } completion:^(BOOL finished) {
                self.isClickRightEditButton = NO;
            }];
            
        }else{
            cell.editContentView.alpha = 1;
            cell.editContentView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                cell.editContentView.alpha = 0;
            } completion:^(BOOL finished) {
                cell.editContentView.hidden = YES;
                self.isClickRightEditButton = NO;
            }];
            
            
        }
    }else{
        cell.editContentView.hidden = YES;
        self.isGroupEditing = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.groupLabel.text = self.groupArr[indexPath.row];
    cell.indexRow = indexPath.row;
    return cell;
}
-(void)deviceGroupClickDeleteButtonAtRow:(NSUInteger)indexRow{
    [[DeviceTool sharedDeviceTool]deviceSegmentTitlesDeleteWithIndex:indexRow];
    self.groupArr = nil;
    [self.tableView reloadData];
}
-(void)deviceGroupClickModifyButtonAtRow:(NSUInteger)indexRow{
    __weak typeof(self) safe = self;
    DeviceEditController *dec = [[DeviceEditController alloc]initWithText:self.groupArr[indexRow] withPlaceholder:@"修改设备分组名称" withFinishBlock:^(NSString *text) {
        [[DeviceTool sharedDeviceTool]deviceSegmentTitlesModifyWithIndex:indexRow withStr:text];
        safe.groupArr = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [safe.tableView reloadData];
        });
    }];
    dec.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:dec animated:YES];
    
}
- (IBAction)clickAddGroupButton:(id)sender {
    __weak typeof(self) safe = self;
    DeviceEditController *dec = [[DeviceEditController alloc]initWithText:@"" withPlaceholder:@"请输入要添加的设备分组的名称" withFinishBlock:^(NSString *text) {
        NSArray *titleArr = [[DeviceTool sharedDeviceTool]deviceSegmentTitlesAddWithStr:text];
        NSMutableArray *arr = [NSMutableArray array];
        for (DeviceGroupInfo *info in titleArr) {
            [arr addObject:info.groupName];
        }
        safe.groupArr = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [safe.tableView reloadData];
        });
    }];
    
    dec.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:dec animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSArray *)groupArr {
	if(_groupArr == nil) {
        NSMutableArray *titleArr = [NSMutableArray array];
        for (DeviceGroupInfo *info in [[DeviceTool sharedDeviceTool]getDeviceSegmentTitles]) {
            [titleArr addObject:info.groupName];
        }
        _groupArr = titleArr;
	}
	return _groupArr;
}

@end
