//
//  ScoreTableViewCell.m
//  TkkSystem
//
//  Created by liny on 2018/5/10.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithCourseName:(NSString *)courseName
                        StudyWay:(NSString *)studyWay
                    CourseCredit:(NSString *)courseCredit
                     CourseScore:(NSString *)courseScore
{
    self.courseName.text = courseName;
    self.studyWay.text = studyWay;
    self.courseCredit.text = courseCredit;
    self.courseScore.text = courseScore;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
