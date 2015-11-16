//
//  CheckListViewController.m
//  leoni
//
//  Created by ryan on 10/6/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckListViewController.h"
#import "InventoryModel.h"
#import "MJRefresh.h"

@interface CheckListViewController ()

@property(nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray* arrayInventories;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
//    
//    UISearchBar *searchBar = [UISearchBar new];
////    searchBar.showsCancelButton = YES;
//    searchBar.translucent = NO;
//    [searchBar sizeToFit];
//    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
//    [barWrapper addSubview:searchBar];
//    self.navigationItem.titleView = barWrapper;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,10,self.navigationController.navigationBar.bounds.size.width,self.navigationController.navigationBar.bounds.size.height/2)];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"搜索库位"];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrayInventories count]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    [self initController];
}

//-(void)dismissKeyboard {
//    NSArray *subviews = [self.view subviews];
//    for (id objInput in subviews) {
//        if ([objInput isKindOfClass:[UITextField class]]) {
//            UITextField *theTextField = objInput;
//            if ([objInput isFirstResponder]) {
//                [theTextField resignFirstResponder];
//            }
//        }
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self initController];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}


-(void)decoderDataReceived:(NSString *)data
{
    self.searchBar.text=[data copy];
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)initController
{
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    
    CGRect rect = self.navigationController.navigationBar.frame;
    float head_height = rect.size.height + rect.origin.y;
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(head_height, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.table.contentInset = adjustForTabbarInsets;
    self.table.scrollIndicatorInsets = adjustForTabbarInsets;
    self.table.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self.table.header endRefreshing];
    }];
    [self.table.header beginRefreshing];
    [self.view addSubview:self.table];
    

    }

- (void)loadData {
    self.arrayInventories = [[NSMutableArray alloc]init];
    InventoryModel *inventory = [[InventoryModel alloc] init];
    self.arrayInventories = [inventory getLocalCheckDataListWithPosition:@""];
    
    [self.table reloadData];
}

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
        NSLog(@"===  %ld",self.arrayInventories.count);
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
   
    static NSString *CellIdentifer = @"CellIdentifier";
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
    
        cell.detailTextLabel.text = [NSString stringWithFormat:@"全盘数量: %@ 抽盘数量: %@", entity.check_qty, @""];
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
        cell.textLabel.font  = myFont;
        cell.detailTextLabel.font = myFont;
//        if(indexPath.row%2==1){
//            cell.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:155.0f/255.0f blue:90.0f/255.0f alpha:0.3f];
//        }
    }
    return cell;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    //Do some search
    NSLog(@"=== testing search %@", searchBar.text);
    InventoryModel *inventory = [[InventoryModel alloc] init];
    self.arrayInventories = [inventory getLocalCheckDataListWithPosition:self.searchBar.text];
    
    [self.table reloadData];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
//    [searchBar setShowsCancelButton:NO animated:YES];
//    NSLog(@"=== testing cancel ");
    [self loadData];
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    NSLog(@"=== testing search");
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.arrayInventories filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"=== testing search");
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
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
