//
//  PayHistoryTableViewController.m
//  XLCartoon
//
//  Created by Amitabha on 2017/12/19.
//  Copyright © 2017年 XLCR. All rights reserved.
//

#import "PayHistoryTableViewController.h"
#import "PayHistoryCell.h"
@interface PayHistoryTableViewController ()
@property (nonatomic,strong) NSMutableArray <payHistoryModel *>* modelArr;
@end

@implementation PayHistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值记录";
    [self getData];
    self.modelArr =[ NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"PayHistoryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PayHistoryCell"];
}

-(void)getData{
    [super getData];

    [AfnManager postListDataUrl:URL_PAY_HISTORY param:nil result:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        for (NSDictionary * dict in OBJ(responseObject)) {
            [self.modelArr addObject:[payHistoryModel mj_objectWithKeyValues:dict]];
        }
        [self.tableView reloadData];
        self.loading = NO;
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tablerView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"PayHistoryCell" forIndexPath:indexPath];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ((PayHistoryCell *)cell).model = self.modelArr[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PayHistoryCell cellHeight];
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
