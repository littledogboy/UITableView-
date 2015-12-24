//
//  ContactListViewController.m
//  UITableView分组列表
//
//  Created by 吴书敏 on 15/12/20.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "ContactListViewController.h"
#import "HeaderView.h"
#import "FriendGroup.h"
#import "Friend.h"

@interface ContactListViewController () <HeaderViewDelegate>

// 存放好友分组
@property (nonatomic, strong) NSMutableArray *friendGroupArray;


@end

@implementation ContactListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 行高
    self.tableView.rowHeight = 44;
    
    // 区尾
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    // 1. 设置数据
    [self setData];
    
    // 2. 设置自定义分区头
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 加载数据
- (void)setData
{
    self.friendGroupArray = [NSMutableArray array];
    
    // 1. 获取plist文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Friend" ofType:@"plist"];
    
    // 2. 根据根节点获取数据
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    // 3. kvc赋值
    // 层级关系
    // studentGroupArray ——》friendGroup——》friend
    for (NSDictionary *dic in array) {
        
        // 把dic ——转化为》 friendGroup
        FriendGroup *friendGroup = [[FriendGroup alloc] init];
        [friendGroup setValuesForKeysWithDictionary:dic];
        [_friendGroupArray addObject:friendGroup];
    }    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [_friendGroupArray count];
}


#pragma mark- 展开分区核心代码(1)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    // 1. 先获取分区对应的联系人组
    FriendGroup *friendGroup = self.friendGroupArray[section];
    
    // 2. 如果没有展开返回0，否则返回分组数
    NSInteger count = friendGroup.isOpen ? friendGroup.friendArray.count: 0;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    
    // Configure the cell...
    FriendGroup *friendGroup = _friendGroupArray[indexPath.section];
    
    Friend *friend = friendGroup.friendArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:friend.icon];
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = friend.introduce;
    
    return cell;
}


#pragma mark-
#pragma mark 设置自定义分区头

// 必须设置分区头高度，否则不显示。
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

// 加载区头，
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FriendGroup *friendGroup = self.friendGroupArray[section];
    
    HeaderView *headerView = [HeaderView headerViewForTableView:tableView];
    
    // 设置分组数据
    headerView.friendGroup = friendGroup;
    
    headerView.section = section; // 这里可以进一步优化
    
    headerView.delegate = self;
    
    return headerView;
}


// 遵守代理协议
//- (void)headerViewClickedReloadDataOfSection:(NSUInteger)section
//{
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationNone)];
//}

- (void)headerViewClickedReloadData
{
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
