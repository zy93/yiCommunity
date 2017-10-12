//
//  DeviceOKAListController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/14.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceOKAListController.h"
#import "DeviceOKATool.h"
#import "DeviceOKAListCell.h"
#import "MyActivityIndicatorView.h"
#import "MBProgressHUD+KR.h"
#import "DeviceOKAAddController.h"
@interface DeviceOKAListController ()<DeviceOKAAddControllerDelegate>
@property(nonatomic,strong) NSMutableArray *deviceOKAArr;
@property(nonatomic,strong) MyActivityIndicatorView *myIndicatorView;
@end

@implementation DeviceOKAListController

-(NSMutableArray *)deviceOKAArr{
    if (!_deviceOKAArr) {
        _deviceOKAArr = [NSMutableArray array];
    }
    return _deviceOKAArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [self sendRequestToGetAllList];

}
-(void)sendRequestToGetAllList{
    [self.myIndicatorView removeFromSuperview];
    self.myIndicatorView = [[MyActivityIndicatorView alloc]initWithStr:@"加载中" imageColor:nil textColor:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myIndicatorView];
    
    [[DeviceOKATool sharedDeviceOKATool]sendRequestToGetOKAListWithResponse:^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myIndicatorView stopAnimating];
            [self.myIndicatorView removeFromSuperview];
            if (dict && [dict[@"error_code"]integerValue] == 0) {
                NSArray *arr = dict[@"data"];
                if (arr) {
                    NSMutableArray *mutaArr = [NSMutableArray array];
                    for (NSDictionary *dicIn in arr) {
                        DeviceOKAInfo *info = [DeviceOKAInfo new];
                        info.sceneId = dicIn[@"sceneId"];
                        info.sceneName = dicIn[@"sceneName"];
                        [mutaArr addObject:info];
                    }
                    
                    [DeviceOKATool sharedDeviceOKATool].deviceOKAListArr = [mutaArr copy];
                    self.deviceOKAArr = [[DeviceOKATool sharedDeviceOKATool].deviceOKAListArr mutableCopy];
                    
                    [self.tableView reloadData];
                }
            }
        });
    }];

}
-(void)setUpNavi{
    if (self.navigationController) {
        self.navigationItem.title = @"一键执行";
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
/**添加一键执行场景*/
-(void)addScene{
    DeviceOKAAddController *okac = [UIStoryboard storyboardWithName:@"DeviceOKAAddController" bundle:nil].instantiateInitialViewController;
    okac.delegate = self;
    [self.navigationController pushViewController:okac animated:YES];
}
-(void)deviceOKAAddControllerDidAddScene{
    [self sendRequestToGetAllList];
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
    return self.deviceOKAArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceOKAListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OKAListCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DeviceOKAListCell" owner:nil options:nil].lastObject;
        [cell.cellButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    DeviceOKAInfo *info = self.deviceOKAArr[indexPath.row];
    cell.cellLabel.text = info.sceneName;
    cell.cellButton.tag = 100+indexPath.row;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark 点击执行
/**点击执行*/
static BOOL isControlling = NO;
-(void)clickButton:(UIButton *)button{
    if (isControlling == YES) {
        return;
    }
    NSInteger index = button.tag -100;
    [self.myIndicatorView removeFromSuperview];
    self.myIndicatorView = [[MyActivityIndicatorView alloc]initWithStr:@"执行中..." imageColor:nil textColor:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myIndicatorView];
    [self.myIndicatorView startAnimating];
    DeviceOKAInfo *info = self.deviceOKAArr[index];
    [[DeviceOKATool sharedDeviceOKATool]sendRequestToExecuteOKAWithSceneId:info.sceneId response:^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myIndicatorView stopAnimating];
            [self.myIndicatorView removeFromSuperview];
            if (dict && [dict[@"error_code"] integerValue] == 0) {
                
                [MBProgressHUD showSuccess:@"开始执行"];
            }else{
                [MBProgressHUD showError:@"网络错误"];
            }
        });
        isControlling = NO;
    }];
}
#pragma mark 删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.myIndicatorView removeFromSuperview];
    self.myIndicatorView = [[MyActivityIndicatorView alloc]initWithStr:@"删除中..." imageColor:nil textColor:nil];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myIndicatorView];
    [self.myIndicatorView startAnimating];
    DeviceOKAInfo *info = self.deviceOKAArr[indexPath.row];
    [[DeviceOKATool sharedDeviceOKATool]sendRequestToDeleteOKAWithSceneId:info.sceneId response:^(NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myIndicatorView stopAnimating];
            [self.myIndicatorView removeFromSuperview];
            if (dict && [dict[@"error_code"] integerValue] == 0) {
                [self.deviceOKAArr removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [MBProgressHUD showSuccess:@"删除成功"];
            }else{
                [MBProgressHUD showError:@"网络错误"];
            }
        });
    }];
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
