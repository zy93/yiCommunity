//
//  WN_YL_BaseViewController.h
//  YiLianGang
//
//  Created by Way_Lone on 16/7/29.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WN_YL_BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@end
