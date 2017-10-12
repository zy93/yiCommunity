//
//  DayChoiceController.m
//  YiLianGang
//
//  Created by Way_Lone on 2016/10/10.
//  Copyright © 2016年 Way_Lone. All rights reserved.
//

#import "DayChoiceController.h"
#import "DayChoiceCell.h"
@interface DayChoiceController ()
@property(nonatomic,strong) NSArray *dayArr;
@property(nonatomic,strong) NSMutableArray *choice;
@property(nonatomic,copy) DayChoiceBlock block;
@end

@implementation DayChoiceController
-(instancetype)initWithCompleteBlock:(DayChoiceBlock)block{
    if (self == [super init]) {
        self.block = block;
    }
    return self;
}
-(NSArray *)dayArr{
    if (!_dayArr) {
        _dayArr = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    }
    return _dayArr;
}
-(NSMutableArray *)choice{
    if (!_choice) {
        _choice = [@[[NSNumber numberWithBool:1],[NSNumber numberWithBool:1],[NSNumber numberWithBool:1],[NSNumber numberWithBool:1],[NSNumber numberWithBool:1],[NSNumber numberWithBool:1],[NSNumber numberWithBool:1]] mutableCopy];
    }
    return _choice;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(choiceDone)];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)choiceDone{
    [self.navigationController popViewControllerAnimated:YES];
    if(_block) {
        _block(self.choice);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DayChoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dayCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DayChoiceCell" owner:nil options:nil].lastObject   ;
        
    }
    cell.choiceNameLabel.text = self.dayArr[indexPath.row];
    NSNumber *isChoice = self.choice[indexPath.row];
    cell.checkImageView.hidden = !isChoice.boolValue;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *choice = self.choice[indexPath.row];
    [self.choice replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:!choice.boolValue]];
    [self.tableView reloadData];
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
