//
//  RandomListViewController.m
//  leoni
//
//  Created by ryan on 10/14/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomListViewController.h"

@interface RandomListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *randomTableView;

@property (nonatomic, strong) NSMutableArray* arrayInventories;
@end

@implementation RandomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self.view addSubview:self.randomTableView];
    CGRect rect = self.navigationController.navigationBar.frame;
    
    float y = rect.size.height + rect.origin.y;
    self.randomTableView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
}

- (void)loadData {
    self.arrayInventories = [[NSMutableArray alloc]init];
    InventoryModel *inventory = [[InventoryModel alloc] init];
    self.arrayInventories = [inventory getListWithPosition:@""];
    
    [self.table reloadData];
}

- (UITableView *)randomTableView {
    if (!_randomTableView) {
        _randomTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _randomTableView.delegate = self;
    }
    return _randomTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        return [self.searchResult count];
//    }
//    else
//    {
        NSLog(@"===  %d",self.arrayInventories.count);
        return self.arrayInventories.count;
//    }
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
    
//    if (tableView == self.searchDisplayController.searchResultsTableView)
//    {
//        cell.textLabel.text = [self.searchResult objectAtIndex:indexPath.row];
//    }
//    else
//    {
        InventoryEntity *entity = self.arrayInventories[indexPath.row];
        NSLog(@"entity %@%@", entity.position, entity.part);
        cell.textLabel.text = [NSString stringWithFormat:@"%d. 库位:%@ 零件: %@", indexPath.row+1, entity.position, entity.part];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"全盘数量: %@ 抽盘数量: %@", entity.check_qty, @""];
        UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 18.0 ];
        cell.textLabel.font  = myFont;
        cell.detailTextLabel.font = myFont;
//    }
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
