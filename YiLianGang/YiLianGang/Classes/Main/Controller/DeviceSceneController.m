//
//  DeviceSceneController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/9.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceSceneController.h"
#import "DeviceSceneAddController.h"
#import "DeviceSceneTool.h"
#import "LoginTool.h"
#import "DeviceSceneListCell.h"
#import "MyActivityIndicatorView.h"
#import "MBProgressHUD+KR.h"
@interface DeviceSceneController ()<DeviceSceneAddControllerDelegate>
@property(nonatomic,strong) NSMutableArray *deviceSceneArr;
@property(nonatomic,strong) MyActivityIndicatorView *myIndicatorView;

@end

@implementation DeviceSceneController
-(NSMutableArray *)deviceSceneArr{
    if (!_deviceSceneArr) {
        _deviceSceneArr = [NSMutableArray array];
    }
    return _deviceSceneArr;
}
-(void)deviceSceneAddControllerDidAddScene{
    [self sendRequestGetAllDeviceScene];
}
-(void)sendRequestGetAllDeviceScene{
    
    [[DeviceSceneTool sharedDeviceSceneTool]sendRequestToGetAllDeviceSceneWithUserId:[NSNumber numberWithInteger:[LoginTool sharedLoginTool].userID.integerValue] response:^(NSArray<DeviceSceneInfo *> *infoArr) {
        
        self.deviceSceneArr = [infoArr mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequestGetAllDeviceScene];
    [self setUpNavi];
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)setUpNavi{
    if (self.navigationController) {
        self.navigationItem.title = @"智能场景";
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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addScene)];
    }
}
-(void)clickTopLeftButton:(UIButton*)button{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void)addScene{
    DeviceSceneAddController *dsac = [UIStoryboard storyboardWithName:@"DeviceSceneAddController" bundle:nil].instantiateInitialViewController;

    dsac.delegate = self;
    [self.navigationController pushViewController:dsac animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceSceneArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceSceneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sceneListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceSceneListCell" owner:nil options:nil].lastObject;
        [cell.sceneSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    DeviceSceneInfo *info = self.deviceSceneArr[indexPath.row];
    cell.sceneNameLabel.text = info.cooperationName;
    if ([info.conditionType isEqualToString:@"time"]) {
        
        cell.sceneDetailLabel.text = [NSString stringWithFormat:@"%@ %@",info.exeFrequency,info.time];
    }else{
        
        cell.sceneDetailLabel.text = [NSString stringWithFormat:@"设备"];
    }
    cell.sceneSwitch.tag = 100+indexPath.row;
    [cell.sceneSwitch setOn:([info.state isEqualToString:@"on"]?YES:NO)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
static BOOL isControlling = NO;
-(void)switchChange:(UISwitch*)sender{
    if (!isControlling) {
        isControlling = YES;
        NSInteger index = sender.tag-100;
        DeviceSceneInfo *info = self.deviceSceneArr[index];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myIndicatorView removeFromSuperview];
            self.myIndicatorView = [[MyActivityIndicatorView alloc]initWithStr:@"设置中" imageColor:nil textColor:nil];
            [[UIApplication sharedApplication].keyWindow addSubview:self.myIndicatorView];
            [self.myIndicatorView startAnimating];
            
        });
        [[DeviceSceneTool sharedDeviceSceneTool]sendRequestToControlWithSceneId:info.cooperationId state:sender.on response:^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myIndicatorView stopAnimating];
                
                if (dict && [dict[@"error_code"] intValue] == 0) {
                    [self.myIndicatorView removeFromSuperview];
                    [MBProgressHUD showSuccess:@"设置成功"];
                    
                    
                }else{
                    
                    [sender setOn:sender.isOn?NO:YES];
                    [self sendRequestGetAllDeviceScene];
                    [MBProgressHUD showError:@"网络错误"];
                    
                }
            
                isControlling = NO;
            });
        }];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



static BOOL isDeleting = NO;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (!isDeleting) {
            isDeleting = YES;
            [self.myIndicatorView removeFromSuperview];
            self.myIndicatorView = [[MyActivityIndicatorView alloc]initWithStr:@"正在删除..." imageColor:nil textColor:nil];
            [[UIApplication sharedApplication].keyWindow addSubview:self.myIndicatorView];
            [self.myIndicatorView startAnimating];
            
            
            [self deleteSceneAtIndexPath:indexPath];
        }
    }
    
}

-(void)deleteSceneAtIndexPath:(NSIndexPath*)indexPath{
    DeviceSceneInfo *info = self.deviceSceneArr[indexPath.row];
    
    [[DeviceSceneTool sharedDeviceSceneTool]sendRequestToDeleteWithSceneId:info.cooperationId response:^(NSDictionary *dict) {
        isDeleting = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myIndicatorView stopAnimating];
            [self.myIndicatorView removeFromSuperview];

            if ([dict[@"error_code"] intValue] == 0) {
                [self.deviceSceneArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [MBProgressHUD showSuccess:@"删除成功"];
                
            }else{
                [self sendRequestGetAllDeviceScene];
                [MBProgressHUD showError:@"网络错误"];
            }
            
        });
        
    }];
}
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
