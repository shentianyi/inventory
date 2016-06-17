//
//  CheckListViewController.m
//  leoni
//
//  Created by ryan on 10/6/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckListViewController.h"
#import "InventoryModel.h"
#import "UserModel.h"
#import "UserEntity.h"
#import "MJRefresh.h"
#import "AFNetHelper.h"

@interface CheckListViewController ()

@property(nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray* localCheckInventories;
@property (nonatomic,strong) NSMutableArray* localCheckUnSyncInventories;
@property (nonatomic,strong) NSMutableArray* localCreateInventories;
@property (nonatomic,strong) NSMutableArray* localCreateUnSyncInventories;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic,strong) UISearchBar *searchBar;
@property(nonatomic,strong) AFNetHelper *afnetHelper;
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
    [self.searchBar setPlaceholder:@"搜索"];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.localCheckInventories count]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    [self initController];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self initController];
    [self.table reloadData];
    
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

//- (void)viewDidAppear:(BOOL)animated {
//    
//}

- (void)initController
{
    self.afnetHelper=[[AFNetHelper alloc]init];
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
    self.localCheckInventories = [[NSMutableArray alloc]init];
    self.localCreateInventories=[[NSMutableArray alloc]init];
    
    [self getLocalCheckData:@""];
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
        NSLog(@"===  %ld",(unsigned long)self.localCheckInventories.count);
        return self.localCheckInventories.count;
        //list
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger localCheckedUnSyncCount=[self.localCheckUnSyncInventories count];
    NSInteger localCreatedCount=[self.localCreateInventories count];
    NSInteger localCreatedUnSyncCount=[self.localCreateUnSyncInventories count];
    
    NSInteger localCheckedCount=[self.localCheckInventories count]-localCreatedCount;
    
    NSString *sectionName = @"";
    if(self.afnetHelper.listLimitUser){
       int total=0;
       UserEntity *user=[[[UserModel alloc]init] findUserByNr:[UserModel accountNr]];
       if(user!=nil){
           total=user.idSpanCount;
        }
        sectionName=[NSString stringWithFormat:@"已盘点:%i/%i/%i 录入:%i/%i",localCheckedCount,total,localCheckedUnSyncCount,localCreatedCount,localCreatedUnSyncCount];
    }else{
        sectionName=[NSString stringWithFormat:@"已盘点:%i/%i 录入:%i/%i",localCheckedCount,localCheckedUnSyncCount,localCreatedCount,localCreatedUnSyncCount];
    }
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
        InventoryEntity *entity = self.localCheckInventories[indexPath.row];  //list
        NSLog(@"entity %@%@", entity.position, entity.part_nr);
        if (entity.check_qty.length == 0) {
            cell.backgroundColor = [UIColor colorWithRed:224.0f/255.0f green:155.0f/255.0f blue:90.0f/255.0f alpha:0.3f];
        }
       
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. 库位:%@ 零件:%@", (long)entity.sn, entity.position, entity.part_nr];
    
        cell.detailTextLabel.text = [NSString stringWithFormat:@"全盘: %@ 抽盘: %@  单位:%@ #%@", entity.check_qty, entity.random_check_qty,entity.part_unit,entity.check_user];
        
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 15.0 ];
        
        cell.textLabel.font  = myFont;
      
       // cell.textLabel.textColor=[UIColor colorWithRed:0.1f green:0.3f blue:0.8f alpha:1.0f];
        
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
    //搜索信息
    [self getLocalCheckData:self.searchBar.text];
    
    [self.table reloadData];
}

-(void) getLocalCheckData:(NSString *) q{
    InventoryModel *inventory = [[InventoryModel alloc] init];

    if(self.afnetHelper.listLimitUser){
        if(self.searchBar.text.length==0){
          self.localCheckInventories=[inventory getAllLocalCheckDataListWithPosition:q WithUserNr:[UserModel accountNr]];
          self.localCreateInventories=[inventory getLocalCreateCheckDataListWithPoistion:q WithUserNr:[UserModel accountNr]];
           self.localCheckUnSyncInventories=[inventory getLocalCheckUnSyncDataListWithPosition:q WithUserNr:[UserModel accountNr]];
            self.localCreateUnSyncInventories=[inventory getLocalCreateCheckUnSyncDataListWithPoistion:q WithUserNr:[UserModel accountNr]];
        }else{
            self.localCheckInventories=[inventory searchLocalCheckDataList:q WithUserNr:[UserModel accountNr]];
            self.localCreateInventories=[inventory searchLocalCreateCheckDataList:q WithUserNr:[UserModel accountNr]];
            self.localCheckUnSyncInventories=[inventory searchLocalCheckUnSyncDataList:q WithUserNr:[UserModel accountNr]];
            self.localCreateUnSyncInventories=[inventory searchLocalCreateCheckUnSyncDataList:q WithUserNr:[UserModel accountNr]];
        }
    }else{
        if(self.searchBar.text.length==0){
          self.localCheckInventories=[inventory getLocalCheckDataListWithPosition:q];
          self.localCreateInventories=[inventory getLocalCreateCheckDataListWithPoistion:q];
            self.localCheckUnSyncInventories=[inventory getLocalCheckUnSyncDataListWithPosition:q];
            self.localCreateUnSyncInventories=[inventory getLocalCreateCheckUnSyncDataListWithPoistion:q];

        }else{
            self.localCheckInventories=[inventory searchLocalCheckDataList:q];
            self.localCreateInventories=[inventory searchLocalCreateCheckDataList:q];
            self.localCheckUnSyncInventories=[inventory searchLocalCreateCheckUnSyncDataList:q];
            self.localCreateUnSyncInventories=[inventory searchLocalCreateCheckUnSyncDataList:q];

        }
    }
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
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.localCheckInventories filteredArrayUsingPredicate:resultPredicate]];
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
