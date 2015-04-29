//
//  HQNothingCell.m
//  HallyuQ
//
//  Created by iPeta on 15/4/1.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQNothingCell.h"
#import <FLAnimatedImage.h>

@interface HQNothingCell()

@property (weak, nonatomic) IBOutlet UIImageView *myimageView;



@end

@implementation HQNothingCell

- (void)awakeFromNib {
    // Initialization code
}



+ (instancetype)nothingCellWithTableView:(UITableView*)tableview
{
    static NSString *identifier = @"notCell";
    HQNothingCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQNothingCell alloc] init];
        cell = [[NSBundle mainBundle] loadNibNamed:@"HQNothingCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        

//        NSString *path = [[NSBundle mainBundle] pathForResource:@"233" ofType:@"gif"];
//        NSURL *url = [NSURL URLWithString:path];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
//        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
//        imageView.animatedImage = image;
//        imageView.frame = CGRectMake(-14, 43, 400.0, 216.0);
//        [cell.contentView addSubview:imageView];
    
        
    }
    return cell;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
