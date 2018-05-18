//
//  ExamTableViewCell.h
//  TkkSystem
//
//  Created by liny on 2018/5/6.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *examYearLbl;
@property (strong, nonatomic) IBOutlet UILabel *examDayLbl;
@property (strong, nonatomic) IBOutlet UILabel *examWeekLbl;
@property (strong, nonatomic) IBOutlet UILabel *examPeriodLbl;
@property (strong, nonatomic) IBOutlet UILabel *examTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *examPositionLbl;
@property (strong, nonatomic) IBOutlet UILabel *examCourseLbl;
@property (strong, nonatomic) IBOutlet UILabel *examWayLbl;
@property (strong, nonatomic) IBOutlet UILabel *examStatusLbl;

- (void)updateCellWithExamYear:(NSString *)examYear
                       ExamDay:(NSString *)examDay
                      examWeek:(NSString *)examWeek
                    examPeriod:(NSString *)examPeriod
                      examTime:(NSString *)examTime
                  examPosition:(NSString *)examPosition
                    examCourse:(NSString *)examCourese
                       examWay:(NSString *)examWay
                    examStatus:(NSString *)examStatus;
@end
