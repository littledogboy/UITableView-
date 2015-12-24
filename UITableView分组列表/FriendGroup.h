//
//  FriendGroup.h
//  UITableView分组列表
//
//  Created by 吴书敏 on 15/12/22.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendGroup : NSObject

// 联系人数组
@property (nonatomic, strong) NSMutableArray *friendArray;

// 分组名
@property (nonatomic, strong) NSString *groupName;

// 在线人数
@property (nonatomic, assign) NSInteger numberOnLine;

// 是否展开
@property (nonatomic, assign) BOOL isOpen;

// 重写kvc赋值

@end
