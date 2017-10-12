//
//  RegisterLastCell.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/3.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "RegisterLastCell.h"
#import "StyleTool.h"
#import "UIImage+ImageColorChange.h"
#import "AppDelegate.h"
@interface RegisterLastCell()
@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UIImageView *CheckImageView;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *regBkgBox;

@end
@implementation RegisterLastCell
- (IBAction)clickCheckButton:(UIButton*)sender {
    self.isChecked = self.isChecked?0:1;
    [self refreshCheckImage];
}
- (IBAction)protocolButton:(id)sender {
    [self.delegate registerLastCellDidClickProtocolButton];
}
- (IBAction)clickRegisterButton:(id)sender {
    [self.delegate registerLastCellDidClickRegister:self];
}
-(void)refreshCheckImage{
    StyleInfo *styleInfo = [[StyleTool sharedStyleTool]sessionSyle];
    if (self.isChecked) {
        self.CheckImageView.hidden = NO;
    }else{
        self.CheckImageView.hidden = YES;
    }
    self.CheckImageView.image = [self.CheckImageView.image imageChangeColor:styleInfo.welcomeColor];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self doPrettyView];
    [self refreshCheckImage];
    [self addObserver:self forKeyPath:@"isChecked" options:NSKeyValueObservingOptionOld context:nil];
    self.registerButton.layer.cornerRadius =5;
    self.registerButton.layer.masksToBounds = YES;
    
    // Initialization code
}
-(void)doPrettyView{
    StyleInfo *styleInfo = [[StyleTool sharedStyleTool]sessionSyle];
    self.CheckImageView.image = [self.CheckImageView.image imageChangeColor:styleInfo.welcomeColor];
    self.registerButton.backgroundColor = styleInfo.welcomeColor;
    
    [self.ylProtocolButton setTitleColor:styleInfo.welcomeColor forState:UIControlStateNormal];
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"isChecked"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object ==self && [keyPath isEqualToString:@"isChecked"]) {
        [self refreshCheckImage];
    }
    if ([AppDelegate isNeedHidden]) {
        self.agreeLabel.hidden = YES;
        self.checkButton.hidden = YES;
        self.CheckImageView.hidden = YES;
        self.ylProtocolButton.hidden = YES;
        self.regBkgBox.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
