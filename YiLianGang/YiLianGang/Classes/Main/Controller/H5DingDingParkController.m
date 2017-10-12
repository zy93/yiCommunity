//
//  H5DingDingParkController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/28.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "H5DingDingParkController.h"
#import <DdtcBleSDK/DdtcBleSDK.h>
@interface H5DingDingParkController ()<UIWebViewDelegate,BleOperDelegate>
@property(nonatomic,strong) NSString *appid;
@property(nonatomic,strong) NSString *userid;
@property(nonatomic,strong) NSString *nonce;
@property(nonatomic,strong) NSString *page;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *sign;
@property(nonatomic,assign) BOOL isWebViewLoaded;
@property(nonatomic,strong) BleOper *bleOper;
@property(nonatomic,assign) BOOL isTest;
@property(nonatomic,strong) NSString *lat;
@property(nonatomic,strong) NSString *lng;
@property(nonatomic,strong) NSString *maptype;
@end

@implementation H5DingDingParkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isTest = NO;
    self.bleOper = [[BleOper alloc] initWithDelegate:self];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isWebViewLoaded == NO) {
        [self sendRequestToGetSign];
        self.isWebViewLoaded = YES;
    }
}
//获取加密
-(void)sendRequestToGetSign{
    WS(weakSelf);
    NSString *urlStr = [HTTP_HOST stringByAppendingString:@"Service_Platform/dingding/encryParam.do"];
    NSString *userTel = [LoginTool sharedLoginTool].userTel;
    //    NSString *community = [LoginTool sharedLoginTool].community;
    NSString *str = [NSString stringWithFormat:@"userid=%@&phone=%@&page=rentLock",userTel,userTel];
    if (self.isTest) {
        str =[NSString stringWithFormat:@"userid=%@&phone=%@&page=rentLock&maptype=bd&lat=%@&lng=%@",userTel,userTel,@"39.960715",@"116.278331"];
    }
    //116.278331,39.960715
    //NSString *str = [NSString stringWithFormat:@"community=???&user_tel=15210876095"];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    request.HTTPBody=[str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *str;
        if (error) {
            return ;
        }
        if (data) {
            str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        }
        if (str.length>0) {
            str = [weakSelf stringFromFirstBrackets:str];
        }
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSData *subData = [str dataUsingEncoding:NSUTF8StringEncoding];
        if (!subData) {
            return;
        }
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:subData options:NSJSONReadingAllowFragments error:nil];
        weakSelf.sign =dict[@"data"][@"sign"];
        weakSelf.appid = dict[@"data"][@"appid"];
        weakSelf.userid = dict[@"data"][@"userid"];
        weakSelf.nonce =dict[@"data"][@"nonce"];
        weakSelf.page = dict[@"data"][@"page"];
        weakSelf.phone = dict[@"data"][@"phone"];
        if (weakSelf.isTest) {
            weakSelf.lat = dict[@"data"][@"lat"];
            weakSelf.lng = dict[@"data"][@"lng"];
            weakSelf.maptype = dict[@"data"][@"maptype"];
        }
        if (weakSelf.sign.length>0 && weakSelf.appid.length>0 && weakSelf.userid.length>0&& weakSelf.nonce.length>0 && weakSelf.page.length>0&& weakSelf.phone.length>0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadWebView];
            });
        }
        
    }];
    [dataTask resume];
    
}
//js调用oc
-(void)setJS{
    WS(weakSelf);
    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    content.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    // 以 JSExport 协议关联 native 的方法
    content[@"native"] = self;
    content[@"riseWeb"] = ^(NSString *lockId,NSString *mac,NSString *preFix) {
        [weakSelf riseWebWithLockId:lockId preFix:preFix];
    };
    content[@"dropWeb"] = ^(NSString *lockId,NSString *mac,NSString *preFix) {
        [weakSelf dropWebWithLockId:lockId preFix:preFix];
    };
    [content evaluateScript:[NSString stringWithFormat:@"%@jsp/ownerLock.jsp",@"https://public.dingdingtingche.com"]];
}
//升起
-(void)riseWebWithLockId:(NSString *)lockId preFix:(NSString*)preFix{
    [self.bleOper operBleWithType:rise lockId:lockId andPreFix:preFix andScanTimeOut:10 andConnectTimeOut:10 andOperTimeOut:50];
}
//降落
-(void)dropWebWithLockId:(NSString *)lockId preFix:(NSString*)preFix{
    [self.bleOper operBleWithType:drop lockId:lockId andPreFix:preFix andScanTimeOut:10 andConnectTimeOut:10 andOperTimeOut:50];
}
//载入webView
-(void)loadWebView{
    
    NSString *headStr = @"https://public.dingdingtingche.com/ddtcHtmlSDK/jsp/rentLock.jsp";
    NSString *urlStr = [headStr stringByAppendingString:[NSString stringWithFormat:@"?appid=%@&userid=%@&nonce=%@&page=%@&phone=%@&sign=%@",self.appid,self.userid,self.nonce,self.page,self.phone,self.sign]];
    if (self.isTest) {
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&lat=%@&lng=%@&maptype=%@",self.lat,self.lng,self.maptype]];
    }
    urlStr = [urlStr URLEncodedString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webView.delegate = self;
    
}
#pragma mark 丁丁蓝牙代理
- (void)operResult:(NSString *)reason rssi:(NSString *)rssi battery:(NSString *)battery{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[ToastUtil showToast:reason];
    });
//    [self.bleOper operBleWithType:drop lockId:lockId andPreFix:prefix andScanTimeOut:SCANTIMEOUT andConnectTimeOut:CONNECTTIMEOUT andOperTimeOut:OPERTIMEOUT];
}
-(void)learnResult:(NSString *)learnResult index:(NSString *)index value:(NSString *)value{
    
}
-(NSString *)getDeletekeyIndex{
    return @"";
}
#pragma mark WebviewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *str = request.URL.absoluteString;
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [super webViewDidFinishLoad:webView];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

//    [self.navigationController.navigationBar setHidden:YES];
    [self setJS];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super webView:webView didFailLoadWithError:error];
    
}

-(void)BackToWLG{
    [self clickTopLeftButton:nil];
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
