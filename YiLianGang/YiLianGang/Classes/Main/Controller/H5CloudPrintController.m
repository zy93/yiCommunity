//
//  H5CloudPrintController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/28.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "H5CloudPrintController.h"

@interface H5CloudPrintController ()<UIWebViewDelegate>
@property(nonatomic,strong) NSString *userTel;
@property(nonatomic,strong) NSString *community;
@property(nonatomic,strong) NSString *sign;
@property(nonatomic,assign) BOOL isWebViewLoaded;

@end

@implementation H5CloudPrintController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isWebViewLoaded = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.toolbarHidden = YES;
    
    [self.webView setFrame:self.view.frame];
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
    NSString *urlStr = [HTTP_HOST stringByAppendingString:@"Service_Platform/print/encryPrintParam.do"];
    NSString *userTel = [LoginTool sharedLoginTool].userTel;
    NSString *community = [LoginTool sharedLoginTool].community;
    NSString *str = [NSString stringWithFormat:@"user_tel=%@&community=%@",userTel,community];
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
        NSData *subData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:subData options:NSJSONReadingAllowFragments error:nil];
        weakSelf.sign =dict[@"data"][@"sign"];
        weakSelf.userTel = dict[@"data"][@"user_tel"];
        weakSelf.community = dict[@"data"][@"community"];
        if (weakSelf.sign.length>0 && weakSelf.userTel.length>0 && weakSelf.community.length>0) {
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
    content[@"BackToWLG"] = ^() {
        
        NSLog(@"js调用oc---------begin--------");
        
        NSArray *thisArr = [JSContext currentArguments];
        
        for (JSValue *jsValue in thisArr) {
            
            NSLog(@"=======%@",jsValue);
            
        }
        [weakSelf BackToWLG];
        //JSValue *this = [JSContext currentThis];
        
        //NSLog(@"this: %@",this);
        
        NSLog(@"js调用oc---------The End-------");
        
        //[self.webView stringByEvaluatingJavaScriptFromString:@"show();"];
        
    };
}
//载入webView
-(void)loadWebView{
    
    NSString *headStr = @"http://iotprint.memoin.com/wlg/printHome.html";
    NSString *urlStr = [headStr stringByAppendingString:[NSString stringWithFormat:@"?community=%@&user_tel=%@&sign=%@",self.community,self.userTel,self.sign]];
    urlStr = [urlStr URLEncodedString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    self.webView.delegate = self;
    
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
