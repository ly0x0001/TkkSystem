//
//  ScoreTableViewCell.h
//  TkkSystem
//
//  Created by liny on 2018/5/10.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *studyWay;
@property (strong, nonatomic) IBOutlet UILabel *courseCredit;
@property (strong, nonatomic) IBOutlet UILabel *courseScore;
- (void)updateCellWithCourseName:(NSString *)courseName
                        StudyWay:(NSString *)studyWay
                    CourseCredit:(NSString *)courseCredit
                     CourseScore:(NSString *)courseScore;
@end
