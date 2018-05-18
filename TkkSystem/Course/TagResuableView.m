//
//  CourseViewController.m
//  TkkSystem
//
//  Created by liny on 2018/3/18.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "TagResuableView.h"
#import "Utils.h"

@implementation TagResuableView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.num = [[UILabel alloc] initWithFrame:self.bounds];
        _num.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_num];
        self.layer.borderWidth = 0;//iphone 7 0.24 plus 0.5
        self.layer.borderColor = [Utils colorWithHexString:@"#6f6c69"].CGColor;
        
    }
    return self;
}
@end
