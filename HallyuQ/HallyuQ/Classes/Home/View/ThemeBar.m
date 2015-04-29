//
//  ThemeBar.m
//  HallyuQ
//
//  Created by Ace on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "ThemeBar.h"


#define kThemeBarItemNumber     5
#define kThemeBarItemWidth      85
#define kThemeBarItemHeight     30


@interface ThemeBar () <ThemeBarDelegate>
{
    UIScrollView    *_navgationBar;         // all items on this scroll view
    
    UIView          *_line;                 // underscore show which item selected
    
    NSMutableArray  *_items;                // ThemeBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    
    UIButton        *_selectedButton;
    
}

@end

@implementation ThemeBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initConfig];
    
    }
    return self;
}


- (void)initConfig
{
    _items = [NSMutableArray array];
    [self viewConfig];
}

- (void)viewConfig
{
    _navgationBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kThemeBarItemHeight + 2.0f)];
    _navgationBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationBar];
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _line = [[UIView alloc] initWithFrame:CGRectMake(0, kThemeBarItemHeight, kThemeBarItemWidth - 4.0f, 2.0f)];
    _line.backgroundColor = kCommonColor;
    [_navgationBar addSubview:_line];
}

- (void)setItemTitles:(NSArray *)itemTitles
{
    for (int i = 0; i < itemTitles.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * kThemeBarItemWidth, 0, kThemeBarItemWidth, kThemeBarItemHeight);
        [button setTitle:itemTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:kCommonColor forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setHighlighted:NO];
        [_navgationBar addSubview:button];
        [_items addObject:button];
        
        if (_items.count == 1) {
            [self itemPressed:button];
        }
    }
    
    
    [self showLineWithButtonWidth:kThemeBarItemWidth];
    
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
}

#pragma mark -
#pragma mark - Public Methods
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    _selectedButton.selected = NO;
    button.selected = YES;
    _selectedButton = button;
    
    if (button.frame.origin.x + button.frame.size.width > kScreenWidth) {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - kScreenWidth;
        [_navgationBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else
    {
        [_navgationBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        _line.frame = CGRectMake(button.frame.origin.x + 2.0f, _line.frame.origin.y, kThemeBarItemWidth - 4.0f, _line.frame.size.height);
    }];
}

- (void)updateData
{
    _navgationBar.contentSize = CGSizeMake(kThemeBarItemWidth * kThemeBarItemNumber, 0);
}

#pragma mark -
#pragma mark -  Delegate Methods
- (void)itemPressedWithIndex:(NSInteger)index
{
    [_delegate itemDidSelectedWithIndex:index];
}

- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    
}
@end
