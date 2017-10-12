//
//  DeviceOKAAddController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/17.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceOKAAddController.h"

#import "DeviceOKATool.h"
#import "DeviceSceneTool.h"
#import "UIImageView+WebCache.h"
#import "DeviceCooperationDetailCell.h"
#import "LoginTool.h"
#import "MBProgressHUD+KR.h"
#import "DeviceAddCooperationController.h"

#define DynamicStartNumber 1

@interface DeviceOKAAddController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addCell;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property(nonatomic,strong) NSMutableArray *cooperationCellMutaArr;
@property(nonatomic,strong) NSMutableArray *sendServiceArr;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation DeviceOKAAddController
-(NSMutableArray *)cooperationCellMutaArr{
    if (!_cooperationCellMutaArr) {
        _cooperationCellMutaArr = [NSMutableArray array];
    }
    return _cooperationCellMutaArr;
}
-(NSMutableArray *)sendServiceArr{
    if(!_sendServiceArr){
        _sendServiceArr = [NSMutableArray array];
    }
    return _sendServiceArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addButton.layer.cornerRadius = 4;
    self.addButton.layer.masksToBounds = YES;
    
    [self setUpNavi];
}
-(void)setUpNavi{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveScene)];
}
static BOOL isRegister = NO;

-(void)saveScene{
    if (self.nameField.text.length==0) {
        [MBProgressHUD showError:@"请填写名称"];
        return;
    }
    if (self.sendServiceArr.count == 0) {
        [MBProgressHUD showError:@"请添加执行"];
        return;
    }
    //按时间类型注册场景
    if (!isRegister) {
        isRegister = YES;
        [[DeviceOKATool sharedDeviceOKATool]sendRequestToRegisterOKAWithName:self.nameField.text services:self.sendServiceArr response:^(NSDictionary *dict) {
            isRegister = NO;
            if ([dict[@"error_code"]intValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccess:@"添加成功"];
                    if (self.delegate) {
                        [self.delegate deviceOKAAddControllerDidAddScene];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else if([dict[@"error_code"]intValue] == 1){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"名称重复"];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:@"网络连接失败"];
                });
            }
            
        }];
    }
}
- (IBAction)clickAddCooperationButton:(UIButton *)sender {
    DeviceAddCooperationController *dacc = [[DeviceAddCooperationController alloc]initWithNumber:self.sendServiceArr.count+1 completeBlock:^{
        DeviceSceneCooperationCellInfo *info = [DeviceSceneTool sharedDeviceSceneTool].lastCellInfo;
        
        if (info && [DeviceSceneTool sharedDeviceSceneTool].lastService) {
            [self.cooperationCellMutaArr addObject:info];
            [self.sendServiceArr addObject:[DeviceSceneTool sharedDeviceSceneTool].lastService];
            
            [self.tableView reloadData];
        }
        
    }];
    
    [self.navigationController pushViewController:dacc animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < DynamicStartNumber+self.cooperationCellMutaArr.count && indexPath.row>DynamicStartNumber-1) {
        return YES;
    }
    return NO;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row < DynamicStartNumber+self.cooperationCellMutaArr.count && indexPath.row>DynamicStartNumber-1) {
            [self.cooperationCellMutaArr removeObjectAtIndex:indexPath.row-DynamicStartNumber];
            [self.sendServiceArr removeObjectAtIndex:indexPath.row-DynamicStartNumber];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return DynamicStartNumber+1+self.sendServiceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.nameCell;
    }else if (indexPath.row == DynamicStartNumber +self.sendServiceArr.count){
        return self.addCell;
    }else if (indexPath.row<DynamicStartNumber+self.sendServiceArr.count && indexPath.row > DynamicStartNumber -1){
        DeviceCooperationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceCooperationDetailCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSInteger index = indexPath.row-DynamicStartNumber;
        DeviceSceneCooperationCellInfo *info = self.cooperationCellMutaArr[index];
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:info.imageUrlStr]];
        cell.cellLabel.text = info.cooperationTitle;
        cell.cellNameLabel.text = info.groupName;
        cell.cellDetailLabel.text = info.detailTitle;
        cell.cellDetailTypeLabel.text = info.typeTitle;
        return cell;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 82;
    }
    else if (indexPath.row == DynamicStartNumber+self.sendServiceArr.count) {
        return 60;
    }else{
        if (self.sendServiceArr.count>0) {
            return 80;
        }
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
