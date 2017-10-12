//
//  DeviceGroupCell.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/30.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DeviceGroupCellDelegate<NSObject>
-(void)deviceGroupClickModifyButtonAtRow:(NSUInteger)indexRow;
-(void)deviceGroupClickDeleteButtonAtRow:(NSUInteger)indexRow;

@end
@interface DeviceGroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *editContentView;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyButton;
@property(nonatomic,assign) NSUInteger indexRow;
@property(nonatomic,weak) id<DeviceGroupCellDelegate> delegate;
@end
