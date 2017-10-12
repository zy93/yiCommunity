//
//  CloudPrinterController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/17.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "CloudPrinterController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface CloudPrinterController ()<CLLocationManagerDelegate,MKMapViewDelegate>
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,strong) MKMapView *mapView;
@property(nonatomic,assign) BOOL isNeedLocateSelf;
@property(nonatomic,assign) BOOL isNeedLocateSelfRepeated;

@end

@implementation CloudPrinterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self selfLocation];
    [self createMap];
    [self addReturnButton];
    self.isNeedLocateSelf = YES;
    self.isNeedLocateSelfRepeated = NO;
    // Do any additional setup after loading the view.
}

-(void)addReturnButton{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"mapLeftButton"] forState:UIControlStateNormal];
//    [button setTitle:@"<" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //定位自己
    UIButton *selfLocation = [[UIButton alloc]initWithFrame:CGRectMake(10,self.view.frame.size.height-50, 40, 40)];
    [selfLocation setBackgroundImage:[UIImage imageNamed:@"selfLocation"] forState:UIControlStateNormal];
    [selfLocation addTarget:self action:@selector(doSelfLocate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selfLocation];
}
-(void)doSelfLocate:(UIButton *)button{
    //定位自己
    MKCoordinateRegion region =MKCoordinateRegionMake(_mapView.userLocation.coordinate, MKCoordinateSpanMake(0.05,0.05));
    
    [_mapView setRegion:region animated:YES];

}
-(void)clickBackButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)selfLocation{
    //创建定位对象
    
    _locationManager =[[CLLocationManager alloc] init];
    
    //设置定位属性
    
    _locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    
    //设置定位更新距离militer
    
    _locationManager.distanceFilter=10.0;
    
    //绑定定位委托
    
    _locationManager.delegate=self;
    
    /**设置用户请求服务*/
    
    //1.去info.plist文件添加定位服务描述,设置的内容可以在显示在定位服务弹出的提示框
    
    //取出当前应用的定位服务状态(枚举值)
    
    CLAuthorizationStatus status =[CLLocationManager authorizationStatus];
    
    //如果未授权则请求
    
    if(status==kCLAuthorizationStatusNotDetermined) {
        
        [_locationManager requestWhenInUseAuthorization];
        
    }
    
    //开始定位
    
    [_locationManager startUpdatingLocation];

}
#pragma mark CLLocationManagerDelegate

//定位后的返回结果

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if(self.isNeedLocateSelf == YES){
        if (self.isNeedLocateSelfRepeated == NO) {
            self.isNeedLocateSelf = NO;
        }
        //locations数组中存储的是CLLocation
        
        //遍历数组取出坐标--》如果不需要也可以不遍历
        
        CLLocation *location =[locations firstObject];
        
        //设置地图显示该经纬度的位置
        
        MKCoordinateRegion region =MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.05,0.05));
        
        [_mapView setRegion:region animated:YES];
    }
//    //创建大头针
//    
//    MKPointAnnotation * pointAnnotation = [[MKPointAnnotation alloc] init];
//    
//    //设置经纬度
//    
//    pointAnnotation.coordinate = location.coordinate;
//    
//    //设置主标题
//    
//    pointAnnotation.title =@"我在这里";
//    
//    //设置副标题
//    
//    pointAnnotation.subtitle =@"hello world";
//    
//    //将大头针添加到地图上
//    
//    [_mapView addAnnotation:pointAnnotation];
    
}
-(void)createMap{
    //实例化
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    //绑定委托
    
    _mapView.delegate=self;
    
    //添加到界面
    
    [self.view addSubview:_mapView];
    
    //添加手势
    
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    //添加到地图上
    
    [_mapView addGestureRecognizer:longPress];
    //添加自身位置
    [_mapView setShowsUserLocation:YES];
    //创建UISegmentedControl
    
    NSArray *mapTypeArray =@[@"标准",@"卫星",@"混合"];
    
    UISegmentedControl *segment =[[UISegmentedControl alloc] initWithItems:mapTypeArray];
    
    segment.frame=CGRectMake(70,20,self.view.frame.size.width-90,30);
    segment.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:0.9];
    segment.layer.cornerRadius = 3;
    segment.layer.masksToBounds = YES;
    [_mapView addSubview:segment];
    
    segment.selectedSegmentIndex=0;
    
    //添加UISegmentedControl的事件响应方法
    
    [segment addTarget:self action:@selector(mapTypeChanged:) forControlEvents:UIControlEventValueChanged];

}
-(void)longPress:(UILongPressGestureRecognizer*)sender{
    //判断是否是长按
    if(sender.state!=UIGestureRecognizerStateBegan) {
        return;
    }
    
    //获取手势在uiview上的位置
    CGPoint longPressPoint = [sender locationInView:_mapView];
    
    //将手势在uiview上的位置转化为经纬度
    CLLocationCoordinate2D coordinate2d =[_mapView convertPoint:longPressPoint toCoordinateFromView:_mapView];
    
    NSLog(@"%f%f",coordinate2d.longitude,coordinate2d.latitude);
    
    MKCircle *circle =[MKCircle circleWithCenterCoordinate:coordinate2d radius:50];
    
    //先添加，在回调方法中创建覆盖物
    [_mapView addOverlay:circle];
}
-(void)addAnnotationWithCoordinate:(CLLocationCoordinate2D)coordinate2d withTitle:(NSString*)title subTitle:(NSString*)subTitle{
    //添加大头针
    MKPointAnnotation *pointAnnotation =[[MKPointAnnotation alloc] init];
    
    //设置经纬度
    pointAnnotation.coordinate = coordinate2d;
    
    //设置主标题和副标题
    pointAnnotation.title = title;
    pointAnnotation.subtitle = subTitle;
    
    //添加到地图上
    [_mapView addAnnotation:pointAnnotation];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //复用
    MKPinAnnotationView *annotationView =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN"];
    
    //判断复用池中是否有可用的
    if(annotationView==nil) {
        annotationView =(MKPinAnnotationView *)[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PIN"];
    }
    //添加左边的视图
    UILabel *leftView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    leftView.text = @"<<";
    
    annotationView.leftCalloutAccessoryView=leftView;
    
    //显示
    annotationView.canShowCallout=YES;
    
    //设置是否显示动画
    annotationView.animatesDrop=YES;
    
    //设置右边视图
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0,0,30,30)];
    
    label.text=@">>";
    annotationView.rightCalloutAccessoryView=label;
    //设置大头针的颜色
    annotationView.pinColor=MKPinAnnotationColorGreen;
    
    return annotationView;
}
//覆盖物的回调方法

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay{
    
    //创建圆形覆盖物
    
    MKCircleRenderer *circleRender =[[MKCircleRenderer alloc] initWithCircle:overlay];
    
    //设置填充色
    
    circleRender.fillColor=[UIColor purpleColor];
    
    //设置边缘颜色
    
    circleRender.strokeColor=[UIColor redColor];
    
    return circleRender;
    
}
//解决手势冲突，可以同时使用多个手势

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}

-(void)mapTypeChanged:(UISegmentedControl*)sender{
    //获得当前segment索引
    NSInteger index =sender.selectedSegmentIndex;
    
    //设置地图的显示方式
    _mapView.mapType =index;
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
