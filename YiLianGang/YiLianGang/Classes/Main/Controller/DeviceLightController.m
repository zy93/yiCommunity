//
//  DeviceLightController.m
//  YiLianGang
//
//  Created by Way_Lone on 2017/2/23.
//  Copyright © 2017年 Way_Lone. All rights reserved.
//

#import "DeviceLightController.h"
#import "UIImageView+WebCache.h"
@interface DeviceLightController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UISwitch *openSwich;
@property (weak, nonatomic) IBOutlet UISlider *lightSlider;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@end

@implementation DeviceLightController
- (IBAction)switchChanged:(UISwitch *)sender {
    NSString *thingId = self.deviceInfo.thingId;
    [self sendWebSocketStringWithParam:@{
        @"param":@{@"value":(sender.on?@"ON":@"OFF")},
        @"serviceId":@"switch",
        @"thingId":thingId}];
}
- (IBAction)lightSliderTouchUp:(UISlider *)sender {
    if (self.openSwich.on) {
        NSString *thingId = self.deviceInfo.thingId;

        NSInteger lightnessValue = (NSInteger)(sender.value*100);
        NSNumber *lightness = [NSNumber numberWithInteger:lightnessValue];
        [self sendWebSocketStringWithParam:@{
                                             @"param":@{@"value":lightness},
                                             @"serviceId":@"lightness",
                                             @"thingId":thingId}];
    }
}
- (IBAction)colorSliderTouchUp:(UISlider *)sender {
    if (self.openSwich.on) {
        NSString *thingId = self.deviceInfo.thingId;
        NSInteger chromaValue = (NSInteger)(sender.value*100);
        NSNumber *chroma = [NSNumber numberWithInteger:chromaValue];
        [self sendWebSocketStringWithParam:@{
                                             @"param":@{@"value":chroma},
                                             @"serviceId":@"chroma",
                                             @"thingId":thingId}];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *imageUrlStr = [self imageAddExStr:self.deviceInfo.picUrl];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"light"]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
