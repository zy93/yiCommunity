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
    [self connectedSocket];//连接服务器
    
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
    NSLog(@"接收到服务器返回的数据 tcp [%@:%d] %@", ip, port, s);
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
        NSData *messageData = [NSJSONSerialization dataWithJSONObject:self.dataDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSNumber *dateLenght = @(messageData.length);
        
//        self.sendDictionary = @{@"dateLenght":dateLenght,@"date":self.dataDictionary};
        
        NSDictionary *dataDictionary =@{@"data":self.dataDictionary};
        self.sendDictionary = @{@"nameValuePairs":dataDictionary};
        NSLog(@"测试发送出去的数据：%@",self.sendDictionary);
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.sendDictionary options:NSJSONWritingPrettyPrinted error:nil];
        NSData *buildData = [self buildDate:data];
        
//        NSData *buildData = [self build1Date:data];
        
        //Byte *dataByte = (Byte *)[data bytes];
        unsigned int frameLength = (int)data.length + 2;
        NSData *frameData = [NSData dataWithBytes:&frameLength length:4];
        [mutableData appendData:frameData];
        
        [mutableData appendData:data];
        
        Byte *dataByte = (Byte *)[frameData bytes];
        unsigned int checkByte = dataByte[0]+dataByte[1];
        NSData *checkData = [NSData dataWithBytes:&checkByte length:2];
        [mutableData appendData:checkData];
        
        NSLog(@"测试：%@",buildData);
        
        [self.socket writeData:buildData withTimeout:- 1 tag:0];
    }
}

-(NSData *)buildDate:(NSData *)data
{
    char buf[1024];
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
 

    NSData *result = [NSData dataWithBytes:&chars length:charsLen];
    
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
    sum &= 0x000000ff;
    return  sum;
}

#pragma mark - 将int转byte数组

-(NSData *)build1Date:(NSData *)data
{
    Byte sendByte[1024];
    int byteLength = 0;
    Byte *dataByte = (Byte *)[data bytes];
    //帧长度
    unsigned int dataLen = (int)data.length+2;
    Byte abyte[4];
    abyte[0] = ((dataLen>> 24) &0xff);
    abyte[1] = ((dataLen>> 16) &0xff);
    abyte[2] = ((dataLen>> 8) &0xff);
    abyte[3] = (0xff & dataLen);
    for (int i = 0; i<4; i++) {
        sendByte[i] = abyte[i];
    }
    byteLength +=4;
    
    //有效数据
    for (int i = 4; i<data.length; i++) {
        sendByte[i] = dataByte[i-4];
    }
    byteLength +=data.length;
    
    //校验和
    unsigned short sum = 0;
    for (int i = 0; i < byteLength; i++) {
        sum ^= sendByte[i];
    }
    sum &= 0x000000ff;
    
    Byte sumbyte[2];
    sumbyte[0] = ((dataLen>> 8) &0xff);
    sumbyte[1] = (dataLen &0xff);
    
    for (int i = 0; i<2; i++) {
        sendByte[i+byteLength] = sumbyte[i];
        
    }
    byteLength +=2;
    
    
    NSData *adata = [NSData dataWithBytes:sendByte length:byteLength];
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
