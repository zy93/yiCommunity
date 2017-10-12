//
//  RegisterLastCell.h
//  YiLianGang
//
//  Created by Way_Lone on 16/8/3.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//
#warning 已弃用
#import <UIKit/UIKit.h>
@class RegisterLastCell;
@protocol RegisterLastCellDelegate<NSObject>
-(void)registerLastCellDidClickRegister:(RegisterLastCell *)cell ;
-(void)registerLastCellDidClickProtocolButton;

@end
@interface RegisterLastCell : UITableViewCell
/**易联港服务协议按钮*/
@property (weak, nonatomic) IBOutlet UIButton *ylProtocolButton;
/**注册按钮 */
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
/**是否打上对勾*/
@property(nonatomic,assign) BOOL isChecked;
@property(nonatomic,weak) id<RegisterLastCellDelegate> delegate;
@end
