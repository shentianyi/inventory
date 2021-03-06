//
//  RandomListViewController.m
//  leoni
//
//  Created by ryan on 10/14/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomListViewController.h"
#import "InventoryModel.h"
#import "MJRefresh.h"

@interface RandomListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *randomTableView;
@property (nonatomic, strong) NSMutableArray* arrayInventories;
@property (nonatomic, strong) NSMutableArray* arrayUnSyncInventories;

@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation RandomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    

    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,10,self.navigationController.navigationBar.bounds.size.width,self.navigationController.navigationBar.bounds.size.height/2)];
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:@"搜索"];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self initTableView];
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrayInventories count]];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [self initTableView];
}

- (void)initTableView {
    self.randomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.randomTableView.delegate = self;
    self.randomTableView.dataSource = self;
    [self.view addSubview:self.randomTableView];
    CGRect rect = self.navigationController.navigationBar.frame;
    float head_height = rect.size.height + rect.origin.y;
    UIEdgeInsets adjustForTabbarInsets = UIEdgeInsetsMake(head_height, 0, CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    self.randomTableView.contentInset = adjustForTabbarInsets;
    self.randomTableView.scrollIndicatorInsets = adjustForTabbarInsets;
    self.randomTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self.randomTableView.header endRefreshing];
    }];
    [self.randomTableView.header beginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    //Do some search
    NSLog(@"=== testing search %@", searchBar.text);
    
    [self getData:searchBar.text];
    [self.randomTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
//    [searchBar setShowsCancelButton:NO animated:YES];
//    NSLog(@"=== testing cancel ");
    [self loadData];
}



- (void)loadData {
    self.arrayInventories = [[NSMutableArray alloc]init];
    [self getData:@""];
    [self.randomTableView reloadData];
}

-(void)getData:(NSString *)q{
    InventoryModel *inventory = [[InventoryModel alloc] init];
    if(self.searchBar.text.length==0){
      self.arrayInventories = [inventory getLocalRandomCheckDataListWithPosition:@""];
        self.arrayUnSyncInventories=[inventory getLocalRandomCheckUnSyncDataListWithPosition:@""];
    }else{
        self.arrayInventories=[inventory searchLocalRandomCheckDataList:q];
        self.arrayUnSyncInventories=[inventory searchLocalRandomCheckUnSyncDataList:q];
    }
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
        NSLog(@"===  %d",self.arrayInventories.count);
        return self.arrayInventories.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName = [NSString stringWithFormat: @"已抽盘 %i/%i", [self.arrayInventories count],[self.arrayUnSyncInventories count]];
    
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
        NSLog(@"entity %@%@", entity.position, entity.part_nr);
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%d. 库位:%@ 零件:%@", entity.sn, entity.position, entity.part_nr];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"全盘: %@ 抽盘: %@  单位:%@ #%@", entity.check_qty, entity.random_check_qty,entity.part_unit,entity.random_check_user];
        
        
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 15.0 ];
        
//        if(indexPath.row%2==1){
//        cell.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:155.0f/255.0f blue:90.0f/255.0f alpha:0.3f];
//        }
//        
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
