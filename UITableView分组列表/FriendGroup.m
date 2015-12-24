//
//  FriendGroup.m
//  UITableView分组列表
//
//  Created by 吴书敏 on 15/12/22.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "FriendGroup.h"
#import "Friend.h"

@implementation FriendGroup

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    // kvc赋值
    if ([key isEqualToString:@"friendArray"]) {
        
        // 如果key 为friendArray，array 里面的元素为dic把dic 转化为friend
        self.friendArray = [NSMutableArray array];
        
        NSArray *array = value;
        for (NSDictionary *dic in array) {
            Friend *friend = [[Friend alloc] init];
            [friend setValuesForKeysWithDictionary:dic];
            [_friendArray addObject:friend];
        }
    }
}

@end
