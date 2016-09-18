//
//  HKSearchRecordTableViewCell.m
//  阿甘汇客
//
//  Created by 卢安林 on 16/9/9.
//  Copyright © 2016年 YHH. All rights reserved.
//

#import "HKSearchRecordTableViewCell.h"
@implementation HKSearchRecordTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView *timeLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        [timeLogo setImage:[UIImage imageNamed:@"history"]];
        [self.contentView addSubview:timeLogo];
        
        self.labeText = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeLogo.frame)+10, 15,self.frame.size.width-115, 15)];
        self.labeText.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.labeText];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
