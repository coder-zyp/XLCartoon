//
//  TopTableViewController.m


#import "TopTableViewController.h"
#import "TopCell.h"
#import "CaricatureDetailViewController.h"

@interface TopTableViewController ()
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSMutableArray <cartoon * >* modelArr;
@end

@implementation TopTableViewController

- (instancetype)initWithUrl:(NSString * )url
{
    self = [super init];
    if (self) {
        self.url =  url;
    }
    _modelArr = [NSMutableArray array];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.mj_header = [MJGifHeader headerWithRefreshingBlock:^{
        self.pageIndex = 0;
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (self.pageIndex == self.pageToale) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self getData];
        }
    }];
    
    [self getData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TopCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TopCell"];

}
-(void)getData{
    [super getData];
    NSDictionary * param = @{@"nowPage":[NSString stringWithFormat:@"%d",self.pageIndex+1]};
    [AfnManager postListDataUrl:self.url param:param result:^(NSDictionary *responseObject) {
        if (responseObject) {
            
            if (self.tableView.mj_header.isRefreshing) {
                self.modelArr = [NSMutableArray array];
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary * dict in OBJ(responseObject)) {
                [_modelArr addObject:[cartoon mj_objectWithKeyValues:dict]];
            }
            
            self.pageIndex = PAGE_INDEX(responseObject);
            self.pageToale = PAGE_TOTAL(responseObject);
            
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.loading = NO;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TopCell" forIndexPath:indexPath];
    return  cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_WIDTH/3.7;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TopCell * topCell = (TopCell *)cell;
    CartoonDetailModel * model = [CartoonDetailModel new];
    model.cartoon = self.modelArr[indexPath.row];
    topCell.model = model;
    topCell.TopNumLabel.text = [NSString stringWithFormat:@"%02ld",indexPath.row+1];
    NSArray * colorArr = @[RGB(253, 111, 55),RGB(253, 156, 43),rgba(250, 210, 60, 1)];
    UIColor * color = indexPath.row <3? colorArr[indexPath.row] : RGB(174, 213, 244);
    //    topCell.contentView.backgroundColor = color;
    topCell.backgroundColor = color;
    topCell.lineView.backgroundColor =color;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CaricatureDetailViewController * vc = [[CaricatureDetailViewController alloc]init];
    vc.cartoonId = self.modelArr[indexPath.row].id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
