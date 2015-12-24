//
//  HeaderView.h
//  UITableView分组列表
//
//  Created by 吴书敏 on 15/12/20.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendGroup;

@protocol HeaderViewDelegate <NSObject>

// 点击区头刷新单元格

- (void)headerViewClickedReloadData;

//- (void)headerViewClickedReloadDataOfSection:(NSUInteger)section;


@end


@interface HeaderView : UITableViewHeaderFooterView

// 联系人分组,点击时刷新该分组数据
@property (nonatomic, strong) FriendGroup *friendGroup;

// 是否点击了
@property (nonatomic, assign) BOOL isClicked;

// 分区
@property (nonatomic, assign) NSUInteger section;


// 代理
@property (nonatomic, assign) id<HeaderViewDelegate> delegate;

// 区头也采用重用机制
// 创建方法, 从tableView的重用队列中取
+ (HeaderView *)headerViewForTableView:(UITableView *)tableView;


@end
