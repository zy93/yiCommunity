//
//  PersonalInfoController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/26.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "PersonalInfoController.h"
#import "TabBarSetTool.h"
#import "LoginTool.h"
#import "DeviceTool.h"
@interface PersonalInfoController ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self doPrettyView];
    self.userLabel.text = [LoginTool sharedLoginTool].userName;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)doPrettyView{
    self.navigationItem.title = @"管理";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        //退出登录
        [[DeviceTool sharedDeviceTool]clearGroupAndDeviceInfo];
        [self goToLoginView];
    }else if (indexPath.section == 1 && indexPath.row == 2){
        [self.tabBarController setSelectedIndex:2];
    }else{
        //[self.navigationController pushViewController:[UIViewController new] animated:YES];
    }
    
}

-(void)dealloc{
    NSLog(@"PersonalInfoController dealloc");
    
}
-(void)goToLoginView{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userPwd"];
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginTableStoryboard" bundle:nil];

    
    UIViewController *vc = [[UINavigationController alloc]initWithRootViewController:[loginStoryboard instantiateInitialViewController]] ;
    
    [UIView transitionFromView:self.tabBarController.view
                        toView:vc.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         [[TabBarSetTool sharedTabBarSetTool]resetTabBar];
         [self dismissViewControllerAnimated:NO completion:nil];
         [UIApplication sharedApplication].keyWindow.rootViewController = vc;
         
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
