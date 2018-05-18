//
//  ExamModel.h
//  TkkSystem
//
//  Created by liny on 2018/5/7.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject
@property (strong ,nonatomic) NSString *examYear;
@property (strong ,nonatomic) NSString *examDay;
@property (strong, nonatomic) NSString *examWeek;
@property (strong, nonatomic) NSString *examPeriod;
@property (strong, nonatomic) NSString *examTime;
@property (strong, nonatomic) NSString *examPosition;
@property (strong, nonatomic) NSString *examCourse;
@property (strong, nonatomic) NSString *examWay;
@property (strong, nonatomic) NSString *examStatus;
@end
