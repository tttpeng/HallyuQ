//
//  HQSendToolBar.m
//  HallyuQ
//
//  Created by qingyun on 15/3/25.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQSendToolBar.h"

@implementation HQSendToolBar



- (IBAction)buttonClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(toolBar:didClickedButton:)]) {
        [self.delegate toolBar:self didClickedButton:sender];
    }
}


@end
