//
//  ManagementController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/11.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "ManagementController.h"
#import "ManagementCell1.h"
#import "ManagementCell2.h"
@interface ManagementController ()

@end

@implementation ManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理";
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CATransition *transition = [CATransition animation];
    [transition setDuration:0.5];
    [transition setType:@"fade"];
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 3;
        case 2:
            return 1;
        
        default:
            return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
            break;
            
        default:
            break;
    }
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
