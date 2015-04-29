//
//  ThemeBar.h
//  HallyuQ
//
//  Created by Ace on 15/3/26.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ThemeBarDelegate <NSObject>

- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end



@interface ThemeBar : UIView

@property (weak, nonatomic)   id        <ThemeBarDelegate>delegate;

@property (assign, nonatomic) NSInteger currentItemIndex;
@property (strong, nonatomic) NSArray *itemTitles;

@property (strong, nonatomic) NSArray   *themes;


/**
 *  Update Item Data
 */
- (void)updateData;

@end
