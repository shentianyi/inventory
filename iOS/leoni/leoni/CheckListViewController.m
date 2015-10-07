//
//  CheckListViewController.m
//  leoni
//
//  Created by ryan on 10/6/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckListViewController.h"
#import "InventoryModel.h"

@interface CheckListViewController ()

@property(nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray* arrayInventories;
@property (nonatomic, strong) NSMutableArray *searchResult;
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
    
    UISearchBar  *sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,10,self.navigationController.navigationBar.bounds.size.width,self.navigationController.navigationBar.bounds.size.height/2)];
    sBar.delegate = self;
    [self.navigationController.navigationBar addSubview:sBar];
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.arrayInventories count]];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self initController];
}

- (void)initController
{
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.delegate=self;
    self.table.dataSource=self;
    [self.view addSubview:self.table];
    CGRect rect = self.navigationController.navigationBar.frame;
    
    float y = rect.size.height + rect.origin.y;
    self.table.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }

- (void)loadData {
    self.arrayInventories = [[NSMutableArray alloc]init];
    InventoryModel *inventory = [[InventoryModel alloc] init];
    self.arrayInventories = [inventory getList];
    
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
        NSLog(@"===  %d",self.arrayInventories.count);
        return self.arrayInventories.count;
    }
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
    }
    return cell;
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResult removeAllObjects];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.arrayInventories filteredArrayUsingPredicate:resultPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
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
