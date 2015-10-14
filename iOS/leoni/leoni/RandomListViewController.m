//
//  RandomListViewController.m
//  leoni
//
//  Created by ryan on 10/14/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomListViewController.h"
#import "InventoryModel.h"

@interface RandomListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *randomTableView;
@property (nonatomic, strong) NSMutableArray* arrayInventories;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation RandomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.randomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.randomTableView.delegate = self;
    self.randomTableView.dataSource = self;

    [self.view addSubview:self.randomTableView];
//    CGRect rect = self.navigationController.navigationBar.frame;
//    
//    float y = rect.size.height + rect.origin.y;
//    self.randomTableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
//
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,10,self.navigationController.navigationBar.bounds.size.width,self.navigationController.navigationBar.bounds.size.height/2)];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"搜索库位"];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrayInventories count]];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    //Do some search
    NSLog(@"=== testing search %@", searchBar.text);
    InventoryModel *inventory = [[InventoryModel alloc] init];
    [inventory webGetRandomCheckData:searchBar.text block:^(NSMutableArray *tableArray, NSError *error) {
        if ([tableArray count] > 0) {
            self.arrayInventories = tableArray;
            [self.randomTableView reloadData];
        }
        else {
            [self.arrayInventories removeAllObjects];
            [self.randomTableView reloadData];
        }
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
//    NSLog(@"=== testing cancel ");
    [self loadData];
}

- (void)loadData {
    self.arrayInventories = [[NSMutableArray alloc]init];
    InventoryModel *inventory = [[InventoryModel alloc] init];
    [inventory webGetRandomCheckData:nil block:^(NSMutableArray *tableArray, NSError *error) {
        if ([tableArray count] > 0) {
            self.arrayInventories = tableArray;
            [self.randomTableView reloadData];
        }
    }];
    
    
}

//- (UITableView *)randomTableView {
//    if (!_randomTableView) {
//        _randomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _randomTableView.delegate = self;
//        _randomTableView.dataSource = self;
//    }
//    return _randomTableView;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResult count];
    }
    else
    {
        NSLog(@"===  %d",self.arrayInventories.count);
        return self.arrayInventories.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = [NSString stringWithFormat: @"已盘点%ld", (long)self.arrayInventories.count];
    
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifer = @"RandomCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifer];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
    }
    else
    {
        InventoryEntity *entity = self.arrayInventories[indexPath.row];
        NSLog(@"entity %@%@", entity.position, entity.part);
        cell.textLabel.text = [NSString stringWithFormat:@"%d. 库位:%@ 零件: %@", indexPath.row+1, entity.position, entity.part];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"全盘数量: %@ 抽盘数量: %@", entity.check_qty, entity.random_check_qty];
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
        cell.textLabel.font  = myFont;
        cell.detailTextLabel.font = myFont;
    }
    return cell;
    
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
