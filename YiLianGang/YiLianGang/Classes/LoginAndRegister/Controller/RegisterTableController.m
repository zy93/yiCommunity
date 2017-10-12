//
//  RegisterTableController.m
//  YiLianGang
//
//  Created by Way_Lone on 16/8/3.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "RegisterTableController.h"
#import "RegisterInfoCell.h"
#import "RegisterLastCell.h"
#import "BRPlaceholderTextView.h"
#import "RegisterInfoTool.h"
#import "SelectView.h"
#import "MBProgressHUD+KR.h"
#import "ProtocolViewController.h"
#import "AppDelegate.h"
@interface RegisterTableController ()<UITextViewDelegate,RegisterInfoCellTextFieldDidEdit,RegisterInfoCellTapDelegate,RegisterGetCountryDelegate,RegisterGetProvinceDelegate,RegisterGetCityDelegate,RegisterGetRegionDelegate,SelectViewDelegate,UIGestureRecognizerDelegate,RegisterLastCellDelegate,RegisterDelegate,UITextFieldDelegate>

@property(nonatomic,strong) BRPlaceholderTextView *infoCountry;
@property(nonatomic,strong) BRPlaceholderTextView *infoProvince;
@property(nonatomic,strong) BRPlaceholderTextView *infoCity;
@property(nonatomic,strong) BRPlaceholderTextView *infoRegion;

@property(nonatomic,strong) YLCountry *country;
@property(nonatomic,strong) YLProvince *province;
@property(nonatomic,strong) YLCity *city;
@property(nonatomic,strong) YLRegion *region;

@property(nonatomic,strong) NSArray *countryArr;
@property(nonatomic,strong) NSArray *provinceArr;
@property(nonatomic,strong) NSArray *cityArr;
@property(nonatomic,strong) NSArray *regionArr;

@property(nonatomic,strong) SelectView *countrySelectView;
@property(nonatomic,strong) SelectView *provinceSelectView;
@property(nonatomic,strong) SelectView *citySelectView;
@property(nonatomic,strong) SelectView *regionSelectView;

@property(nonatomic,assign) NSInteger currentSelectViewIndex;//1-4
@property(nonatomic,strong) NSArray *infoArr;

@property(nonatomic,strong) NSDictionary *registerDict;
@property(nonatomic,assign) BOOL isFirstLoad;
@end

@implementation RegisterTableController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//-(void)tapToEndEdit{
//    [self.view endEditing:YES];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequest];
    [self doPretteyView];
    self.isFirstLoad = NO;
    
//    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToEndEdit)]];
//    self.infoArr = @[self.infoPhone,self.infoName,self.infoPwd,self.infoRePwd,self.infoCountry,self.infoProvince,self.infoCity,self.infoRegion,self.infoCommunity,self.infoDetailAddress];

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
/**发送请求获取国家，省份，城市，区域*/
-(void)sendRequest{
    [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllCountry];
    [RegisterInfoTool sharedRegisterInfoTool].countryDelegate = self;
}
-(void)tapSelectView:(UITapGestureRecognizer*)gesture{
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

-(void)showSelectViewWithSelectView:(SelectView*)selectView andArr:(NSArray*)arr{
    NSString *identify;
    if (self.currentSelectViewIndex == 1) {
        identify = @"countryName";
    }else if(self.currentSelectViewIndex == 2){
        identify = @"provinceName";
    }else if(self.currentSelectViewIndex == 3){
        identify = @"cityName";
    }else if(self.currentSelectViewIndex == 4){
        identify = @"countyName";
    }else{
        identify = @"";
    }
    (selectView) = [SelectView selectViewWithTableListArray:arr dictIdentify:identify withFrame:CGRectMake(40, 40, [UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.height-80)];
    (selectView).selectDelegate = self;
    UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.tag = 55;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelectView:)];
    tap.delegate = self;
    [view addGestureRecognizer:tap];
    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [view addSubview:(selectView)];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    if (self.currentSelectViewIndex == 1) {
        self.countrySelectView = selectView;
    }else if(self.currentSelectViewIndex == 2){
        self.provinceSelectView = selectView;
    }else if(self.currentSelectViewIndex == 3){
        self.citySelectView = selectView;
    }else if(self.currentSelectViewIndex == 4){
        self.regionSelectView = selectView;
    }
}

-(void)RegisterInfoToolDidGetCountryArr:(NSArray<YLCountry *> *)arr{
    
    self.countryArr = arr;
}
-(void)RegisterInfoToolDidGetProvinceArr:(NSArray<YLProvince *> *)arr{
    
    self.provinceArr = arr;
}
-(void)RegisterInfoToolDidGetCityArr:(NSArray<YLCity *> *)arr{
    
    self.cityArr = arr;
}
-(void)RegisterInfoToolDidGetRegionArr:(NSArray<YLRegion *> *)arr{
    
    self.regionArr = arr;
}
/**美化界面*/
-(void)doPretteyView{
    self.navigationItem.title = @"用户注册";

    //设置左上角返回键
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(8, 11, 40, 21)];
    [button addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_back.png"]];
    imageView.frame = CGRectMake(0, 0, 13, 21);
    [button addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    //设置tableView
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UIImageView *headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    [headerView addSubview:headerImageView];
    headerImageView.center = headerView.center;
    headerImageView.image = [UIImage imageNamed:@"icon_ylg"];
    headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.tableView setTableHeaderView: headerView];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
    [self.tableView setTableFooterView: footerView];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
    
}
-(void)clickBackButton:(UIButton*)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma SelectViewDelegate
-(void)selectView:(SelectView *)selectView didSelectRow:(NSUInteger)row string:(NSString *)str{
    if (selectView == self.countrySelectView) {
        RegisterCellInfo *info = self.infoArr[4];
        self.country = self.countryArr[row];
        info.textViewStr = self.country.countryName;
        [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllProvinceInCountry:self.country];
        [RegisterInfoTool sharedRegisterInfoTool].provinceDelegate = self;
        self.provinceArr = nil;
        self.cityArr = nil;
        self.regionArr = nil;
        self.province = nil;
        self.city = nil;
        self.region = nil;
        info = self.infoArr[5];
        info.textViewStr = @"";
        info = self.infoArr[6];
        info.textViewStr = @"";
        info = self.infoArr[7];
        info.textViewStr = @"";

        [self.tableView reloadData];
        
    }else if(selectView == self.provinceSelectView) {
        RegisterCellInfo *info = self.infoArr[5];
        self.province = self.provinceArr[row];
        info.textViewStr = self.province.provinceName;
        [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllCity:self.province];
        [RegisterInfoTool sharedRegisterInfoTool].cityDelegate = self;
        self.cityArr = nil;
        self.regionArr = nil;
        self.city = nil;
        self.region = nil;
        info = self.infoArr[6];
        info.textViewStr = @"";
        info = self.infoArr[7];
        info.textViewStr = @"";
        [self.tableView reloadData];
        
    }else if(selectView == self.citySelectView) {
        RegisterCellInfo *info = self.infoArr[6];
        self.city = self.cityArr[row];
        info.textViewStr = self.city.cityName;
        [[RegisterInfoTool sharedRegisterInfoTool]sendRequestToGetAllRegion:self.city];
        [RegisterInfoTool sharedRegisterInfoTool].regionDelegate = self;
        self.regionArr = nil;
        self.region = nil;
        info = self.infoArr[7];
        info.textViewStr = @"";
        [self.tableView reloadData];
        
    }else if(selectView == self.regionSelectView) {
        RegisterCellInfo *info = self.infoArr[7];
        self.region = self.regionArr[row];
        info.textViewStr = self.region.countyName;
        [self.tableView reloadData];
        
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
-(void)registerInfoCellDidTap:(UIGestureRecognizer *)gesture{
    [self.view endEditing:YES];
    if (gesture.view.tag == 104) {
        self.currentSelectViewIndex = 1;
        [self showSelectViewWithSelectView:self.countrySelectView andArr:self.countryArr];
    }else if(gesture.view.tag == 105){
        self.currentSelectViewIndex = 2;
        [self showSelectViewWithSelectView:self.provinceSelectView andArr:self.provinceArr];
    }else if(gesture.view.tag == 106){
        self.currentSelectViewIndex = 3;
        [self showSelectViewWithSelectView:self.citySelectView andArr:self.cityArr];
    }else if(gesture.view.tag == 107){
        self.currentSelectViewIndex = 4;
        [self showSelectViewWithSelectView:self.regionSelectView andArr:self.regionArr];
    }
}
#pragma mark 点击协议按钮
-(void)registerLastCellDidClickProtocolButton{
    ProtocolViewController *pvc = [[ProtocolViewController alloc]initWithNibName:@"ProtocolViewController" bundle:nil];
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark 点击注册按钮
/**注册按钮被点击*/
-(void)registerLastCellDidClickRegister:(RegisterLastCell *)cell{
    BOOL isComplete = [self isAllComplete];
    BOOL isAcceptProtocol = cell.isChecked;
    if (!isAcceptProtocol && ![AppDelegate isNeedHidden]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"请同意协议"];
        });
        return;
    }
    if (isComplete) {
        [self sendRequestForRegister];
    }
    [self.tableView reloadData];
}
-(void)sendRequestForRegister{
    
    NSDictionary *dict = @{@"username":((RegisterCellInfo*)_infoArr[1]).textViewStr,
                           @"password":((RegisterCellInfo*)_infoArr[2]).textViewStr,
                           @"tel":((RegisterCellInfo*)_infoArr[0]).textViewStr,
                           @"countryId":self.country.countryId,
                           @"provinceId":self.province.provinceId,
                           @"cityId":self.city.cityId,
                           @"countyId":self.region.countyId,
                           @"communityId":((RegisterCellInfo*)_infoArr[8]).textViewStr,
                           @"otherInfo":((RegisterCellInfo*)_infoArr[9]).textViewStr
                           };
    if ([AppDelegate isNeedHidden]) {
        dict =  @{@"username":((RegisterCellInfo*)_infoArr[1]).textViewStr,
          @"password":((RegisterCellInfo*)_infoArr[2]).textViewStr,
          @"tel":((RegisterCellInfo*)_infoArr[0]).textViewStr,
          @"countryId":@"1",
          @"provinceId":@"110000",
          @"cityId":@"110100",
          @"countyId":@"110108",
          @"communityId":@"test",
          @"otherInfo":@"test"
          };
        
    }
    NSLog(@"%@",dict);
    [[RegisterInfoTool sharedRegisterInfoTool]sendRegisterRequestWithDict:dict];
    [RegisterInfoTool sharedRegisterInfoTool].registerDelegate = self;
    
}
-(void)RegisterDidRegisterSuccess:(BOOL)isSuccess withDict:(NSDictionary*)dict{
    if (isSuccess) {
        if([[dict[@"error_code"]stringValue] isEqualToString:@"0"]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showSuccess:@"注册成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"请检查信息"];
            });
        }

        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showError:@"请检查信息"];
        });
    }
}
-(BOOL)isAllComplete{
    BOOL isComplete;
    //手机
    RegisterCellInfo *info = self.infoArr[0];
    if ([self getToInt:info.textViewStr]!=11 ) {
        isComplete = NO;
    }else{
        isComplete = YES;
    }
    [self setColorWithInfo:info isComplete:isComplete];
    //姓名
    info = self.infoArr[1];
    if ([self getToInt:info.textViewStr]<4||[self getToInt:info.textViewStr]>12 ) {
        isComplete = NO;
    }else{
        isComplete = YES;
    }
    [self setColorWithInfo:info isComplete:isComplete];
    //密码
    info = self.infoArr[2];
    if ([self getToInt:info.textViewStr]<6||[self getToInt:info.textViewStr]>12 ) {
        isComplete = NO;
    }else{
        isComplete = YES;
    }
    [self setColorWithInfo:info isComplete:isComplete];
    //重复密码
    info = self.infoArr[3];
    if ([self getToInt:info.textViewStr]<6||[self getToInt:info.textViewStr]>12 ||![info.textViewStr isEqualToString:((RegisterCellInfo*)self.infoArr[2]).textViewStr]) {
        isComplete = NO;
    }else{
        isComplete = YES;
    }
    [self setColorWithInfo:info isComplete:isComplete];
   
    if (![AppDelegate isNeedHidden]) {
    //国家
        
        info = self.infoArr[4];
        if (!self.country) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];
        
        //省份
        info = self.infoArr[5];
        if (!self.province) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];
        
        //城市
        info = self.infoArr[6];
        if (!self.city) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];
        
        //区域
        info = self.infoArr[7];
        if (!self.region) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];
        
        //小区
        info = self.infoArr[8];
        if (!([self getToInt:info.textViewStr]>0)) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];
        
        //详细地址
        info = self.infoArr[9];
        if (!([self getToInt:info.textViewStr]>0)) {
            isComplete = NO;
        }else{
            isComplete = YES;
        }
        [self setColorWithInfo:info isComplete:isComplete];

    }
    if (isComplete) {
        return YES;
    }else{
        return NO;
    }
    
}
-(void)setColorWithInfo:(RegisterCellInfo*)info isComplete:(BOOL)isComplete{
    if (isComplete) {
        info.textViewColor = [UIColor clearColor];
    }else{
        info.textViewColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.3];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<10) {
        
        RegisterInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerInfoCell"];
        if (!cell) {
            NSArray *arr =[[NSBundle mainBundle]loadNibNamed:@"RegisterInfoCell" owner:nil options:nil];
            for (id obj in arr) {
                if ([obj isKindOfClass:[UITableViewCell class]]) {
                    cell = obj;
                }
            }
            
            cell.backgroundColor = [UIColor clearColor];
            cell.pTextView.spellCheckingType = UITextSpellCheckingTypeNo;
            cell.pTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            cell.pTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        }
        cell.pTextView.tag = 100+indexPath.row;
        cell.pTextView.delegate = self;
        RegisterCellInfo *info = self.infoArr[indexPath.row];
        cell.label.text = info.labelStr;
        
        cell.pTextView.text = [info.textViewStr copy];
        NSLog(@"%lu",(unsigned long)cell.pTextView.text.length);
        cell.pTextView.placeholder = info.textViewPlaceHolder;
        //设置textView的输入内容类型
        if (indexPath.row==0) {
            
            cell.pTextView.keyboardType =UIKeyboardTypeNumberPad;
        }else {
            cell.pTextView.keyboardType =UIKeyboardTypeDefault;

        }
        //是否是密码
        if (info.isPassword == YES) {
            cell.textField.hidden = NO;
            cell.textField.secureTextEntry = YES;
            cell.textFieldDelegate = self;
            
            cell.textField.placeholder = cell.pTextView.placeholder;
            cell.textField.tag = 100+indexPath.row;
            cell.textField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.textField.superview.backgroundColor = info.textViewColor;
            cell.textField.backgroundColor = [UIColor clearColor];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:cell.textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
            cell.pTextView.hidden = YES;
        }else{
            cell.textField.hidden = YES;
            cell.pTextView.hidden = NO;
            cell.textField.superview.backgroundColor = info.textViewColor;
        }
//        if(indexPath.row==2||indexPath.row==3){
//            
//            cell.pTextView.secureTextEntry = YES;
//        }else{
//            
//            cell.pTextView.secureTextEntry = NO;
//            
//        }
        //可输入长度
        if (indexPath.row==2||indexPath.row==3) {
            cell.pTextView.maxTextLength = 12;
        }else if(indexPath.row == 0){
            cell.pTextView.maxTextLength = 11;
        }else if(indexPath.row == 1){
            cell.pTextView.maxTextLength = 12;
        }else if(indexPath.row == 9){
            cell.pTextView.maxTextLength = 60;
        }else{
            cell.pTextView.maxTextLength = 60;
        }
        if (info.type==TYPE_INPUT) {
            cell.dropDownImageView.hidden = YES;
            cell.tapGestureRecognize.enabled = NO;
            

        }else{
            cell.tapGestureRecognize.enabled = YES;
            cell.dropDownImageView.hidden = NO;
            cell.tapDelegate = self;
        }
        //cell中textView颜色
        cell.pTextView.superview.backgroundColor = info.textViewColor;
        cell.pTextView.backgroundColor = [UIColor clearColor];
        if ([AppDelegate isNeedHidden]) {
            cell.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1.0];
        }
        if ([AppDelegate isNeedHidden] && indexPath.row>3) {
            cell.hidden = YES;
        }else{
            cell.hidden = NO;
        }
        return cell;
    }else{
        RegisterLastCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerLastCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"RegisterLastCell" owner:nil options:nil].lastObject;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
            cell.isChecked = YES;
            
        }
        return cell;
    }
    
}

#pragma mark textField被编辑
-(void)registerInfoCellTextFieldDidEdit:(UITextField *)textField{
    if (textField.tag == 102) {
        RegisterCellInfo *info = self.infoArr[2];
        info.textViewStr = textField.text;
    }else if(textField.tag == 103){
        RegisterCellInfo *info = self.infoArr[3];
        info.textViewStr = textField.text;
    }
    RegisterCellInfo *info = self.infoArr[textField.tag-100];
    
    if (textField.text.length>12) {
        textField.text = [textField.text substringToIndex:12];
        info.textViewStr = textField.text;
    }
}

- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
//得到中英文混合字符串长度 方法2
- (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([AppDelegate isNeedHidden]) {
        if (indexPath.row>3) {
            return 0;
        }
    }
    if (indexPath.row<10) {
        RegisterCellInfo *info = self.infoArr[indexPath.row];
        return info.cellHeight;
    }else{
        return 109;
    }
}
-(void)changeTextView:(BRPlaceholderTextView *)textView{
    for (NSInteger i= textView.text.length-1; i>0; i--) {
        NSString *temp = [textView.text substringToIndex:i];
        NSInteger l1 = [self getToInt:temp];
        NSInteger l2 = textView.maxTextLength;
        NSLog(@"%ld,%ld",(long)l1,(long)l2);
        if (l1<=l2) {
            textView.text = temp;
            break;
        }
    }
}
/**通过代理，更新注册数据*/
-(void)textViewDidChange:(BRPlaceholderTextView *)textView{
    if ([self getToInt:textView.text]>textView.maxTextLength) {
        [self changeTextView:textView];
    }
    NSInteger index = textView.tag-100;
    RegisterCellInfo *info = self.infoArr[index];
    info.textViewStr = textView.text;
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
#pragma mark lazy load
- (NSArray *)infoArr {
	if(_infoArr == nil) {
		_infoArr = [RegisterInfoTool sharedRegisterInfoTool].allRegisterInfoArray;
	}
	return _infoArr;
}



- (NSArray *)countryArr {
	if(_countryArr == nil) {
		_countryArr = [[NSArray alloc] init];
	}
	return _countryArr;
}

- (NSArray *)provinceArr {
	if(_provinceArr == nil) {
		_provinceArr = [[NSArray alloc] init];
	}
	return _provinceArr;
}

- (NSArray *)cityArr {
	if(_cityArr == nil) {
		_cityArr = [[NSArray alloc] init];
	}
	return _cityArr;
}

- (NSArray *)regionArr {
	if(_regionArr == nil) {
		_regionArr = [[NSArray alloc] init];
	}
	return _regionArr;
}

@end
