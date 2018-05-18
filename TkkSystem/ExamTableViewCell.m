//
//  ExamTableViewCell.m
//  TkkSystem
//
//  Created by liny on 2018/5/6.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "ExamTableViewCell.h"

@implementation ExamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCellWithExamYear:(NSString *)examYear ExamDay:(NSString *)examDay examWeek:(NSString *)examWeek examPeriod:(NSString *)examPeriod examTime:(NSString *)examTime examPosition:(NSString *)examPosition examCourse:(NSString *)examCourese examWay:(NSString *)examWay examStatus:(NSString *)examStatus
{
    self.examYearLbl.text = examYear;
    self.examDayLbl.text = examDay;
    self.examWeekLbl.text = examWeek;
    self.examPeriodLbl.text = examPeriod;
    self.examTimeLbl.text = examTime;
    self.examPositionLbl.text = examPosition;
    self.examCourseLbl.text = examCourese;
    self.examWayLbl.text = examWay;
    self.examStatusLbl.text =examStatus;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
