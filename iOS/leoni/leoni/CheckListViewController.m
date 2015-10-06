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
@property (nonatomic, strong) NSArray* arrayInventories;
@end

@implementation CheckListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
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
    
//    _dataArray = [[NSMutableArray alloc]init];
//    _currentPage = 1;
//    _socialModel = [[Social alloc] init];
//    
}

- (void)loadData {
    InventoryModel *inventory = [[InventoryModel alloc] init];
    self.arrayInventories = [inventory getList];
    [self.table reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayInventories.count;
//    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.arrayInventories objectAtIndex:indexPath.row]];
    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAge]];
    
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
