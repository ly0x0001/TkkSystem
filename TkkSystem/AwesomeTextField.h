//
//  CourseViewController.m
//  TkkSystem
//
//  Created by liny on 2018/3/18.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface AwesomeTextField : UITextField

@property (strong, nonatomic) IBInspectable UIColor *underlineColor;
@property (assign, nonatomic) IBInspectable CGFloat underlineWidth;
@property (assign, nonatomic) IBInspectable CGFloat underlineAlpha;
@property (strong, nonatomic) IBInspectable UIColor *placeholderColor;
@property (assign, nonatomic) IBInspectable CGFloat animationDuration;

@end
