//
//  HeaderView.m
//  UITableView分组列表
//
//  Created by 吴书敏 on 15/12/20.
//  Copyright © 2015年 littledogboy. All rights reserved.
//

#import "HeaderView.h"
#import "FriendGroup.h"

#define kLeft 20


@interface HeaderView ()

// 箭头图片视图
@property (nonatomic, strong) UIImageView *arrowView; // 解决方法1. 设置为单例 2. 放到另外一个方法里面。

// 分组名label
@property (nonatomic, strong) UILabel *groupNameLabel;

// 人数label
@property (nonatomic, strong) UILabel *numberLabel;


@property (nonatomic, assign) BOOL isSelected;

@end

@implementation HeaderView


// BUG2 没有使用区头加载的重用机制
// demo 中创建区头竟然使用的cell重用方法，这是个明显的错误，导致每次都要创建新的区头
static int  number = 0;
+ (HeaderView *)headerViewForTableView:(UITableView *)tableView
{
    
    static NSString *identifier = @"headerView1";
    
    // 1. 先从重用队列中取
    HeaderView *headerView = (HeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    
    // 2. 如果为空创建
    if (headerView == nil) {
        NSLog(@"重新创建区头%d", ++number);
        headerView = [[HeaderView alloc] initWithReuseIdentifier:identifier];
    }
    
    // 3. 返回
    return headerView;
}


// 重写初始化方法，自定义布局
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        CGFloat totalWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 44;
        
        
        // backgroundView
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, totalWidth, height))];
        backgroundView.userInteractionEnabled = YES;
        
        backgroundView.image = [UIImage imageNamed:@"buddy_header_bg"];
        [self.contentView addSubview:backgroundView];
        
        
        // imageView
        _arrowView = [[UIImageView alloc] initWithFrame:(CGRectMake(20, 16.5, 7, 11))];
        
        _arrowView.image = [UIImage imageNamed:@"buddy_header_arrow"];
        
        [self.contentView addSubview:_arrowView];
        
        
        // groupLabel
        CGFloat groupX = _arrowView.frame.origin.x + _arrowView.frame.size.width + 10;
        CGFloat groupY = 7;
        CGFloat groupWidth = 200;
        CGFloat groupHeight = 30;
        _groupNameLabel = [[UILabel alloc] initWithFrame:(CGRectMake(groupX, groupY, groupWidth, groupHeight))];
        [self.contentView addSubview:_groupNameLabel];
        
        
        // numberLabel
        CGFloat numberWidth = 80;
        CGFloat numberHeight = 30;
        CGFloat numberX = totalWidth - kLeft - numberWidth;
        CGFloat numberY = 7;
        _numberLabel = [[UILabel alloc] initWithFrame:(CGRectMake(numberX, numberY, numberWidth, numberHeight))];
        _numberLabel.textAlignment = NSTextAlignmentRight; // 右对齐
        [self addSubview:_numberLabel];
        
    }
    
    return self;
}


#pragma mark-
#pragma mark  model set 方法
// 重写set方法，在给friendGroup赋值的同时，给内部控件赋值
- (void)setFriendGroup:(FriendGroup *)friendGroup
{
    _friendGroup = friendGroup;
    
    // 给分组名赋值
    self.groupNameLabel.text = friendGroup.groupName;
    
    // 给number赋值
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", friendGroup.friendArray.count, friendGroup.numberOnLine];
    
    // 正确方法：应该在，返回区头之前，让箭头视图旋转。赋值在返回之前，可以实现。
    // 旋转arrowView
    if (_friendGroup.isOpen == YES) {
        
        _arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    } else {
        
        _arrowView.transform = CGAffineTransformMakeRotation(0); // 旋转90度
    }

    
}

// BUG1 区头不能滑动问题
// demo中用的是一个button作为自定义区头的背景控件(把button设置为整个屏幕大小，button背景为一张图片)
// 产生问题： button点击事件与tableView的滑动事件冲突，导致不能滑动。
// 正确方法，应该是1.添加自定义控件 imageView 作为背景。2. 重写自定义区头的 touchEnded方法，
// 实现touchend方法
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    _friendGroup.isOpen = !_friendGroup.isOpen;
    
//
    if (_delegate != nil && [_delegate respondsToSelector:@selector(headerViewClickedReloadData)]) {
        [_delegate headerViewClickedReloadData];
    }
    
}


#pragma mark- layoutSubView


// 重写didMoveToSuperView，当父视图发生改变时执行该方法
// 比如： 俯视图reloadData ，添加移除视图等操作
// bug 只有加载新的视图才会触发
/*
- (void)didMoveToSuperview
{
    // 旋转arrowView
    if (_friendGroup.isOpen == YES) {
        
        _arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    } else {
        
        _arrowView.transform = CGAffineTransformMakeRotation(0); // 旋转90度
    }

}
 */




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
