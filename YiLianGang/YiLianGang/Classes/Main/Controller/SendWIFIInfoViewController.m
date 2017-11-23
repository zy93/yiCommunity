//
//  SendWIFIInfoViewController.m
//  YiLianGang
//
//  Created by 编程 on 2017/10/20.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "SendWIFIInfoViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import "ServiceReturnInformation.h"
#import "MBProgressHUDUtil.h"
#import "MBProgressHUD+Extension.h"
#import "MyViewController.h"

@interface SendWIFIInfoViewController ()<GCDAsyncSocketDelegate,GCDAsyncUdpSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *wifiNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *wifiPassWordTextField;

@property (nonatomic,strong) GCDAsyncSocket *socket;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpsocket;
@property (nonatomic,assign) BOOL connected;
@property (nonatomic,strong) NSDictionary *dataDictionary;
@property (nonatomic,strong) NSDictionary *sendDictionary;


@end

@implementation SendWIFIInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendWifiInfo:(id)sender {
    [self.view endEditing:YES];
    BOOL isWifiName = [self.wifiNameTextField.text isEqualToString:@""];
    BOOL isWifiPassWord = [self.wifiPassWordTextField.text isEqualToString:@""];
    if (isWifiName || isWifiPassWord) {
        [MBProgressHUDUtil showMessage:@"请填写完整信息后，再发送！" toView:self.view];
    }
    else
    {
        [self connectedSocket];//连接服务器
    }
    
}

#pragma mark - 连接socket
-(void)connectedSocket
{
    NSString *host = @"10.10.100.254";
    int port = 8899;
 self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
// self.connected = [self.socket connectToHost:host onPort:port viaInterface:nil withTimeout:-1 error:&error];
    self.connected = [self.socket connectToHost:host onPort:port error:&error];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息发送成功");
    [self.socket readDataWithTimeout:-1 tag:0];//读取服务器的数据
}

#pragma mark - 读取服务器的数据回调方法
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
    NSLog(@"返回数据:%@",dic);
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
    NSString *code = dic[@"error_code"];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (code.integerValue == 0) {
            [MBProgressHUDUtil showLoadingWithMessage:@"发送成功" toView:self.view whileExcusingBlock:^(MBProgressHUD *hud) {
                [hud hide:YES afterDelay:1.f complete:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }];
        }else
        {
            [MBProgressHUDUtil showMessage:@"发送失败" toView:self.view];
        }
    });
    
    
    [self.socket readDataWithTimeout:-1 tag:0];//读取服务器的数据
}

#pragma mark - 连接成功回调方法
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功！");
    [self sendData];
}
#pragma mark - 连接失败回调方法
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
{
    NSLog(@"连接失败!");
    [self connected];
}

//发送数据
-(void)sendData
{
    NSMutableData *mutableData = [NSMutableData data];
    NSString * mainHarborString=[[ServiceReturnInformation sharedReturnInfo].returnInfoDictionary objectForKey:@"mainHarbor"];
    NSString * peidString=[[ServiceReturnInformation sharedReturnInfo].returnInfoDictionary objectForKey:@"peid"];
    NSString * baseKeyString=[[[ServiceReturnInformation sharedReturnInfo].returnInfoDictionary objectForKey:@"mainHarborKey"] objectForKey:@"baseKey"];
    NSString * upKeyString=[[[ServiceReturnInformation sharedReturnInfo].returnInfoDictionary objectForKey:@"mainHarborKey"] objectForKey:@"upKey"];
    NSString * downKeyString=[[[ServiceReturnInformation sharedReturnInfo].returnInfoDictionary objectForKey:@"mainHarborKey"] objectForKey:@"downKey"];
    
    
    if (self.connected) {
        self.dataDictionary = @{@"mainHarbor":mainHarborString,
                                @"peid":peidString,
                                @"baseKey":baseKeyString,
                                @"upKey":upKeyString,
                                @"downKey":downKeyString,
                                @"userNameWifi":self.wifiNameTextField.text,
                                @"passWordWifi":self.wifiPassWordTextField.text
                                };
        NSDictionary *dataDictionary =@{@"data":self.dataDictionary};
        self.sendDictionary = @{@"nameValuePairs":dataDictionary};
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.sendDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //去掉多余的换行和空格
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"发送出去的数据json：%@",jsonStr);
        //编译数据
        NSData *buildData = [self buildDate:data];
        NSLog(@"发送数据：%@",buildData);
        [self.socket writeData:buildData withTimeout:- 1 tag:0];
    }
}

-(NSData *)buildDate:(NSData *)data
{
    char buf[2048];
    memset((char *)buf, 0, sizeof(buf));
    char *chars = buf;
    //char *chars;
    int  charsLen = 0;
    char *dataChar = (char *)[data bytes];
    
    //有效数据的长度
    unsigned int dataLen = (int)data.length+2 ;
    //int转换char*
    char *byte = [self intToByte:4 num:dataLen];
    //补充帧长度
    for (int i = 0; i<4; i++) {
        *(unsigned char *)chars = byte[i];//报错
        chars +=1;
    }
    charsLen +=4;
    
    //补充有效数据
    for (int i = 0; i<data.length; i++) {
        *(unsigned char *)chars = *dataChar++;
        chars +=1;
    }
    charsLen +=data.length;

    //计算校验和
    unsigned short sum = [self checkNum:buf len:charsLen];
    char *byte2 = [self intToByte:2 num:sum];
    
    for (int i = 0; i<2; i++) {
        *(unsigned char *)chars = byte2[i];
        chars +=1;
    }
    charsLen +=2;
 

    NSData *result = [NSData dataWithBytes:&buf length:charsLen];
    
    return result;
}

-(char *)intToByte:(int)len num:(int)num
{
    char byte[len];
    for (int i = 0; i<len; i++) {
        byte[i] = (num >> 8 * ((len-1)-i)) & 0xFF;
        NSLog(@"测试：0x%02x",byte[i]);
    }
    
    return byte;
}


#pragma mark - 校验
-(unsigned short)checkNum:(char *)chars len:(int)length
{
    unsigned short sum = 0;
    
    for (int i = 0; i < length; i++) {
        sum ^= chars[i];
    }
   // sum &= 0x000000ff;
    return  sum;
}

#pragma mark - 将int转byte数组

-(NSData *)build1Date:(NSData *)data
{
    char buf[2048];
    memset((char *)buf, 0, sizeof(buf));
    char *chars = buf;
    int  charsLen = 0;
    char *dataChar = (char *)[data bytes];
    
    //有效数据的长度
    unsigned int dataLen = (int)data.length+2 ;
    //int转换char*
    char *byte = [self intToByte:4 num:dataLen];
    //补充帧长度
    for (int i = 0; i<4; i++) {
        *(unsigned char *)chars = byte[i];//报错
        chars +=1;
    }
    charsLen +=4;
    
    //补充有效数据
    for (int i = 0; i<data.length; i++) {
        *(unsigned char *)chars = *dataChar++;
        chars +=1;
    }
    charsLen +=data.length;
    
    //计算校验和
    unsigned short sum = [self checkNum:buf len:charsLen];
    char *byte2 = [self intToByte:2 num:sum];
    
    for (int i = 0; i<2; i++) {
        *(unsigned char *)chars = byte2[i];
        chars +=1;
    }
    charsLen +=2;
    
    NSData *adata = [NSData dataWithBytes:&buf length:charsLen];
    return adata;
}
//-(Byte )byteFromInt:(int)len num:(int)num
//{
//    Byte byte[len];
//    for (int i = 0; i<len; i++) {
//        byte[i] =(num >> 8 * ((len-1) - i) & 0xFF);
//    }
//    return byte;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
