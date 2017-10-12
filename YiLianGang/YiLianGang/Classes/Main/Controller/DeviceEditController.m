//
//  DeviceEditController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/31.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DeviceEditController.h"

@interface DeviceEditController ()
@property(nonatomic,strong) void (^block)(NSString *);
@property(nonatomic,strong) NSString *originText;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic,strong) NSString *placeholder;
@end

@implementation DeviceEditController
-(instancetype)initWithText:(NSString*)str withPlaceholder:(NSString*)placeholder withFinishBlock:(void (^)(NSString *text))block{
    if (self = [super init]) {
        self.block = block;
        self.placeholder = placeholder;
        self.originText = str;
    }
    return self;
}
-(void)dealloc{
    NSLog(@"DeviceEditController dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.placeholder = self.placeholder;
    self.textField.layer.cornerRadius = 4;
    self.textField.layer.masksToBounds = YES;
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    if (self.originText.length>0) {
        self.textField.text = self.originText;
    }else{
        self.textField.text = @"";
    }
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
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    rightButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(clickTopRightButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:rightButton];
    rightView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
}
-(void)clickTopLeftButton:(UIButton*)button{
    
    [self back];
}
-(void)clickTopRightButton:(UIButton*)button{
    if (self.textField.text.length== 0) {
        return;
    }
    self.block(self.textField.text);
    [self back];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
