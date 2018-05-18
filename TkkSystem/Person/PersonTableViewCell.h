//
//  PersonTableViewCell.h
//  TkkSystem
//
//  Created by liny on 2018/5/9.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UILabel *itemLable;

- (void)updateCellWithImage:(UIImage *)image LableText:(NSString *)labeltext;
@end
