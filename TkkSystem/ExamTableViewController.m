//
//  ExamTableViewController.m
//  TkkSystem
//
//  Created by liny on 2018/4/20.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "ExamTableViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "ExamModel.h"
#import "ExamTableViewCell.h"

@interface ExamTableViewController ()
@property (nonatomic, strong) NSMutableArray *ExamArray;
@property(assign,nonatomic) NSStringEncoding enc;
@end

@implementation ExamTableViewController

- (void)setExamModelArray:(NSMutableArray *)ExamModelArray
{
    _ExamModelArray = ExamModelArray;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getExamData];
    self.tableView.bounces=NO;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchExam
{
    //Get the Exam information
    ExamModel *examModel;
    self.ExamModelArray = [[NSMutableArray alloc]init];
    NSMutableArray *ExamModelData = [[NSMutableArray alloc]init];
    for(int i = 0; i < self.ExamArray.count; i += 10)
    {
        examModel = [[ExamModel alloc]init];
        examModel.examYear = [self.ExamArray objectAtIndex:(i + 1)];
        examModel.examDay = [self.ExamArray objectAtIndex:(i + 2)];
        examModel.examWeek = [self.ExamArray objectAtIndex:(i + 3)];
        examModel.examPeriod = [self.ExamArray objectAtIndex:(i + 4)];
        examModel.examTime = [self.ExamArray objectAtIndex:(i + 5)];
        examModel.examPosition = [self.ExamArray objectAtIndex:(i + 6)];
        examModel.examCourse = [self.ExamArray objectAtIndex:(i + 7)];
        examModel.examWay = [self.ExamArray objectAtIndex:(i + 8)];
        examModel.examStatus = [self.ExamArray objectAtIndex:(i + 9)];
        [ExamModelData addObject:examModel];
    }
    self.ExamModelArray = ExamModelData;
}

-(void)getExamData{
    self.ExamArray = [[NSMutableArray alloc]init];
    AFHTTPSessionManager *CourseManager = [AFHTTPSessionManager manager];
    CourseManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    CourseManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *studentUrl = @"http://jw.xujc.com/student/index.php";
    NSDictionary *parameters = @{@"c":@"Search",@"a":@"ksap"};
    [CourseManager GET:studentUrl parameters:parameters progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   NSString *studentStr = [[NSString alloc]initWithData:responseObject encoding:self.enc];
                   NSString *uft8HtmlStr = [studentStr stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
                   
                   //NSLog(@"studentStr is %@",uft8HtmlStr);
                   NSData *utf8HtmlData = [uft8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
                   TFHpple *xpathParser = [TFHpple hppleWithHTMLData:utf8HtmlData];
                   NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//tr"];
                   for (TFHppleElement *hppleElement in dataArray)
                   {
                       NSArray *examData = [hppleElement searchWithXPathQuery:@"//td"];
                       for (TFHppleElement *examElement in examData)
                       {
                           NSString *coursetempString = examElement.text;
                           [self.ExamArray addObject:coursetempString];
                       }
                   }
                   [self fetchExam];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"error %@",error.description);
               }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld",[self.ExamModelArray count]);
    return [self.ExamModelArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"examCell" forIndexPath:indexPath];
    [cell updateCellWithExamYear:[[self.ExamModelArray objectAtIndex:indexPath.row]examYear]
                         ExamDay:[[self.ExamModelArray objectAtIndex:indexPath.row]examDay]
                        examWeek:[[self.ExamModelArray objectAtIndex:indexPath.row]examWeek]
                      examPeriod:[[self.ExamModelArray objectAtIndex:indexPath.row]examPeriod]
                        examTime:[[self.ExamModelArray objectAtIndex:indexPath.row]examTime]
                    examPosition:[[self.ExamModelArray objectAtIndex:indexPath.row]examPosition]
                      examCourse:[[self.ExamModelArray objectAtIndex:indexPath.row]examCourse]
                         examWay:[[self.ExamModelArray objectAtIndex:indexPath.row]examWay]
                      examStatus:[[self.ExamModelArray objectAtIndex:indexPath.row]examStatus]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
