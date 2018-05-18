//
//  CourseViewController.m
//  TkkSystem
//
//  Created by liny on 2018/3/18.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "weekDay.h"
#import "Utils.h"
@interface weekDay(){
    UILabel *day;
    UILabel*week;
}
@end
@implementation weekDay

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
    {
        [self setUp];
        self.backgroundColor = [Utils colorWithHexString:@"#ffffff"];
        
    }
    return self;
}

-(void)setUp{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    day=[[UILabel alloc] initWithFrame:CGRectMake(0, 5, width, height/3)];
    day.textColor = [UIColor blackColor];
    day.textAlignment = NSTextAlignmentCenter;
    week = [[UILabel alloc] initWithFrame:CGRectMake(0, height/3+5, width, height/3*2-5)];
    week.textAlignment = NSTextAlignmentCenter;
    week.textColor = [UIColor blackColor];
    self.layer.borderWidth=1;
    self.layer.borderColor = [Utils colorWithHexString:@"#ffffff"].CGColor;
    self.clipsToBounds = true;
    [self addSubview:day];
    [self addSubview:week];
    
}

-(void)setDay:(NSString*)Day week:(NSString*)Week{
    day.text=Day;
    week.text=Week;
}

@end
