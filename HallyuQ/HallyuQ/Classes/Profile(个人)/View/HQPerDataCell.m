//
//  HQPerDataCell.m
//  HallyuQ
//
//  Created by iPeta on 15/3/27.
//  Copyright (c) 2015年 HallyuQ. All rights reserved.
//

#import "HQPerDataCell.h"
#import "HQUser.h"

@interface HQPerDataCell ()

@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siginLabel;

@end

@implementation HQPerDataCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"userCell";
    HQPerDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HQPerDataCell alloc] init];
        cell = [[NSBundle mainBundle] loadNibNamed:@"HQPerDataCell" owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setUser:(HQUser *)user
{
    _user = user;
    self.ageLabel.text = user.age;
    _homeLabel.text = user.address;
    _siginLabel.text = user.mydescription;
    if (_gender) {
        _gender.text = @"男";
    }else
    {
        _gender.text = @"女";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
