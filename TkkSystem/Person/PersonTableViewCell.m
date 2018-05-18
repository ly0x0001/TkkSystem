//
//  PersonTableViewCell.m
//  TkkSystem
//
//  Created by liny on 2018/5/9.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "PersonTableViewCell.h"

@implementation PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithImage:(UIImage *)image LableText:(NSString *)labeltext
{
    self.itemImage.image = image;
    self.itemLable.text = labeltext;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
