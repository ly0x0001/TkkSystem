//
//  CourseViewController.m
//  TkkSystem
//
//  Created by liny on 2018/3/18.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "CourseViewController.h"
#import "weekDay.h"
#import "CouresCollectionViewLayout.h"
#import "CourseCell.h"
#import "TagResuableView.h"
#import "CourseModel.h"
#import "SelectWeekView.h"
#import "Utils.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "CDZPicker.h"

@interface CourseViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@property(strong,nonatomic) UICollectionView *collection;
@property(assign,nonatomic) CGFloat addWidth;
@property(strong,nonatomic) NSMutableArray *colors;
@property(strong,nonatomic) SelectWeekView *s;
@property(assign,nonatomic) NSStringEncoding enc;
@property(strong,nonatomic) NSMutableArray *courseMutableArray;
@property(strong,nonatomic) NSArray *courseArray;
@property(strong, nonatomic) IBOutlet UIButton *buttonForTime;
@property(strong, nonatomic) NSString *tmidValue;
@property(strong, nonatomic) NSString *lxValue;
@property(strong, nonatomic) NSString *weekValue;
@property(strong,nonatomic) NSArray *weekArray;


@end

@implementation CourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tmidValue = @"";
    self.lxValue = @"";
    self.weekValue = @"第10周";
    [self.buttonForTime setTitle:self.weekValue forState:UIControlStateNormal];
    [self getCourseData];
    //NSLog(@"course is %ld",self.courseMutableArray.count);
    //NSLog(@"array is %ld",self.courseArray.count);
    [self setTitleView];
    self.weekArray = @[@"双周",@"单周"];
    self.enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
}
- (IBAction)popPickerView:(id)sender {
    [CDZPicker showPickerInView:self.view withStringArrays:@[@[@"17-18 第二学期",@"17-18 第一学期",@"16-17 第二学期",@"16-17 第一学期",@"15-16 第二学期",@"15-16 第一学期"],@[@"第1周",@"第2周",@"第3周",@"第4周",@"第5周",@"第6周",@"第7周",@"第8周",@"第9周",@"第10周",@"第11周",@"第12周",@"第12周",@"第13周",@"第14周",@"第15周",@"第16周",@"第17周",@"第18周",@"第19周"],@[@"教学周",@"实践周"]] confirm:^(NSArray<NSString *> *stringArray) {
        if([[[stringArray objectAtIndex:0] substringWithRange:NSMakeRange(7, 1)]isEqualToString:@"一"])
        {
            self.tmidValue = [[NSString stringWithFormat:@"20"] stringByAppendingFormat:@"%@%@",[[stringArray objectAtIndex:0] substringWithRange:NSMakeRange(0, 2)],@"1"];
            self.array = nil;
            [self getCourseData];
        }
        else
        {
            self.tmidValue = [[NSString stringWithFormat:@"20"] stringByAppendingFormat:@"%@%@",[[stringArray objectAtIndex:0] substringWithRange:NSMakeRange(0, 2)],@"2"];
            self.array = nil;
            [self getCourseData];
        }
        self.weekValue = [stringArray[1] substringWithRange:NSMakeRange(1, 1)];
        if([stringArray[2]isEqualToString:@"教学周"])
        {
            self.lxValue = @"1";
        }
        else
        {
            self.lxValue = @"2";
        }
        [self.buttonForTime setTitle:stringArray[1] forState:UIControlStateNormal];
        NSLog(@"strings:%@",self.tmidValue);
    } cancel:^{
        
    }];
}

//-(void)setTmidValue:(NSString *)tmidValue
//{
//    if(![_tmidValue isEqualToString:tmidValue])
//    {
//        _tmidValue = tmidValue;
//        [self getCourseData];
//    }
//    else if(_tmidValue == nil)
//    {
//        _tmidValue = @"";
//    }
//}

//-(void)setLxValue:(NSString *)lxValue
//{
//    if(![_lxValue isEqualToString:lxValue])
//    {
//        _lxValue = lxValue;
//        [self getCourseData];
//        [self.collection reloadData];
//    }
//}

-(void)getCourseData{
    self.courseMutableArray = [[NSMutableArray alloc]init];
    
    AFHTTPSessionManager *CourseManager = [AFHTTPSessionManager manager];
    CourseManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    CourseManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *studentUrl = @"http://jw.xujc.com/student/index.php";
    //参数的选择处理？？？思路：取出 现在的所有学期（可以单独写函数） 显示最新的课程表 然后做个可以选择学期和xx周的滚轮供用户选择
    //NSDictionary *parameters = @{@"c":@"Default",@"a":@"Kb",@"tm_id":@"20162",@"lx":@"1"};
    NSDictionary *parameters = @{@"c":@"Default",@"a":@"Kb",@"tm_id":(self.tmidValue != nil)?self.tmidValue:@"",@"lx":(self.lxValue != nil)?self.lxValue:@""};
    [CourseManager GET:studentUrl parameters:parameters progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *studentStr = [[NSString alloc]initWithData:responseObject encoding:self.enc];
        NSString *uft8HtmlStr = [studentStr stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
        
        NSLog(@"studentStr is %@",uft8HtmlStr);
        //self.courseWebData.text = uft8HtmlStr;
        NSData *utf8HtmlData = [uft8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
        TFHpple *xpathParser = [TFHpple hppleWithHTMLData:utf8HtmlData];
        NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//tr"];
        int row = 1;
        int column = 1;
        for (TFHppleElement *hppleElement in dataArray)
        {
            if([[hppleElement objectForKey:@"class"]isEqualToString:@"even"])
            {
                NSArray *courseData = [hppleElement searchWithXPathQuery:@"//td"];
                for (TFHppleElement *courseElement in courseData)
                {
                    if([[courseElement.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
                    {
                        column++;
                    }
                    else if([courseElement objectForKey:@"rowspan"])
                    {
                        NSString *coursetempString = courseElement.raw;
                        NSString *coursePeriod = [coursetempString substringWithRange:NSMakeRange(13, 1)];
                        NSString *courseString = [coursetempString substringWithRange:NSMakeRange(16, coursetempString.length - 21)];
                        NSString *dealCourseString = [courseString stringByReplacingOccurrencesOfString:@"<br/>" withString:@" "];
                        NSString *finalCourseString = [NSString stringWithFormat:@"%i %i %@ %@",row,column,coursePeriod,dealCourseString];
                        self.courseArray = [[NSArray alloc]init];
                        self.courseArray = [finalCourseString componentsSeparatedByString:@" "];
                        [self.courseMutableArray addObjectsFromArray:self.courseArray];
                        //NSLog(@"course is %ld",self.courseMutableArray.count);
                        //NSLog(@"array is %ld",self.courseArray.count);
                        for (NSString * str in self.courseArray)
                        {
                            NSLog(@"str = %@",str);
                        }
                        column++;
                    }
                }
                row += 2;
                column = 1;
            }
        }
        [self prepareForView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.description);
    }];
}
-(void)prepareForView
{
    //颜色还需要调节好？？？？？？
    NSArray *colorArray = @[@"#1b83b4",@"#6d9525",@"#ADD8E6",@"#4161b7",@"#af4271",@"#7053ab",@"#60a779",@"#cb5253",@"#C71585",@"#9932CC",@"#008000",@"#DAA520",@"#D2B48C",@"#8B0000",@"    #808080",@"#F08080"];
    self.colors =[[NSMutableArray alloc]init];
    [self.colors addObjectsFromArray:colorArray];
    [self setModel];
    self.addWidth= ([UIScreen mainScreen].bounds.size.width-30)/5.0 - 2.0;
    [self setWeekAndDays];
    CouresCollectionViewLayout*course = [[CouresCollectionViewLayout alloc] init];
    //    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"icon0.jpg"]];
    course.width = self.addWidth;
    course.height = (CGRectGetHeight([UIScreen mainScreen].bounds)-64-45)/9.7;
    course.array = _array;
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+45, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:course];
    self.collection.dataSource=self;
    self.collection.delegate=self;
    self.collection.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    [self.collection registerClass:[CourseCell class] forCellWithReuseIdentifier:@"course"];
    [self.collection registerClass:[TagResuableView class] forSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num"];
    self.collection.bounces = NO;
    [self.view addSubview:self.collection];
    self.s= [[SelectWeekView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100,64, 200, 250)];
    self.s.backgroundColor =[UIColor colorWithWhite:1 alpha:0];
}

-(void)setTitleView{


    //UITextField *button = [[UITextField alloc]init];
    //[button setText:@"课程表"];
    //button.delegate = self;
    //UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button setTitle:@"课程表" forState:UIControlStateNormal];
    //[button setTitleColor:[Utils colorWithHexString:@"#44acf3"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(popSelectView) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.titleView = button;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return NO;
    
}

-(void)popSelectView{
    static BOOL flag = false ;
    if(!flag){
        [self.view addSubview:self.s];
        flag = true;
    }
    else
    {
        [self.s removeFromSuperview];
        flag = false;
    }
}

-(void)setModel{
    self.array = [[NSMutableArray alloc]init];
    CourseModel *model;
    for(int i = 0; i < self.courseMutableArray.count; i+=7)
    {
        if([[self.courseMutableArray objectAtIndex:(i + 6)] containsString:[self.weekArray objectAtIndex:([self.weekValue intValue]%2)]]||[[self.courseMutableArray objectAtIndex:(i + 6)] containsString:@"每周"])
        {
            model = [[CourseModel alloc] init];
            NSInteger l = arc4random_uniform((int)self.colors.count);
            model.colors = self.colors[l];
            [self.colors removeObjectAtIndex:l];
            model.start = [[self.courseMutableArray objectAtIndex:i]intValue];
            model.weekDay =[[self.courseMutableArray objectAtIndex:(i + 1)]intValue];
            model.end = [[self.courseMutableArray objectAtIndex:i]intValue] + [[self.courseMutableArray objectAtIndex:(i + 2)]intValue] - 1;
            //model.courseName =[[self.courseMutableArray objectAtIndex:(i + 3)] stringByAppendingFormat:@"\n%@\n%@\n%@" ,[self.courseMutableArray objectAtIndex:(i + 4)],[self.courseMutableArray objectAtIndex:(i + 5)],[self.courseMutableArray objectAtIndex:(i + 6)]];
            model.courseName = [[self.courseMutableArray objectAtIndex:(i + 3)] stringByAppendingFormat:@"\n%@\n%@" ,[self.courseMutableArray objectAtIndex:(i + 5)],[self.courseMutableArray objectAtIndex:(i + 6)]];
            model.course = [self.courseMutableArray objectAtIndex:(i + 3)];
            for(CourseModel *tempModel in self.array)
            {
                if([tempModel.course isEqualToString:[self.courseMutableArray objectAtIndex:(i + 3)]])
                {
                    model.colors = tempModel.colors;
                }
            }
            [self.array addObject:model];
        }
        
    }
    [self.collection reloadData];
}

-(void)setWeekAndDays{
    NSArray *weekStr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;     comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday]-1;
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    weekDay *flag;
    CGFloat height = 45;
    CGFloat x=37;
    NSInteger startDay = day - week+1;
    NSInteger startWeek = 0;
    flag = [[weekDay alloc] initWithFrame:CGRectMake(0, 64, 37, height)];
    flag.alpha=0.8;
    [flag setDay:[NSString stringWithFormat:@"%ld月",(long)month] week:@" "];
    [self.view addSubview:flag];
    for(int i=1;i<=6;i++)
    {
        x--;
        flag = [[weekDay alloc] initWithFrame:CGRectMake(x, 64, self.addWidth, height)];
        x+=self.addWidth;
        flag.alpha=0.9;
        
        [flag setDay:[NSString stringWithFormat:@"%ld",(long)startDay] week:weekStr[startWeek]];
        startDay++;
        startWeek++;
        
        [self.view addSubview:flag];
    }
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 31;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CourseCell *cell = [self.collection dequeueReusableCellWithReuseIdentifier:@"course" forIndexPath:indexPath];
    cell.model = _array[indexPath.row-12];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    TagResuableView*Tag = [collectionView dequeueReusableSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num" forIndexPath:indexPath];
    if(indexPath.row + 1 <= 4){
        Tag.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    }
    else if(indexPath.row + 1 <= 6){
        Tag.num.text = [NSString stringWithFormat:@"午%ld",indexPath.row+1-4];
    }
    else{
        Tag.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1-2];
    }
    Tag.num.textColor = [UIColor blackColor];
    return Tag;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

