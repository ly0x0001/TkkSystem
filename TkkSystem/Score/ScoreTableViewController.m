//
//  ScoreTableViewController.m
//  TkkSystem
//
//  Created by liny on 2018/5/10.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "ScoreTableViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "ScoreModel.h"
#import "ScoreTableViewCell.h"
@interface ScoreTableViewController ()
@property (nonatomic, strong) NSMutableArray *scoreArray;
@property (nonatomic, strong) NSMutableArray *failScoreArray;
@property(assign,nonatomic) NSStringEncoding enc;
@end

@implementation ScoreTableViewController

- (void)setScoreModelArray:(NSMutableArray *)scoreModelArray
{
    _scoreModelArray = scoreModelArray;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.alwaysBounceVertical=NO;
    self.tableView.bounces=NO;
    [self getScoreData];
    self.enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)getScoreData{
    self.scoreArray = [[NSMutableArray alloc]init];
    self.failScoreArray = [[NSMutableArray alloc]init];
    AFHTTPSessionManager *CourseManager = [AFHTTPSessionManager manager];
    CourseManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    CourseManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *studentUrl = @"http://jw.xujc.com/student/index.php";
    NSDictionary *parameters = @{@"c":@"Search",@"a":@"cj",@"tm_id":@"20171"};
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
                           if([[examElement.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]!=0)
                           {
                               //NSLog(@"1111%@",examElement.text);
                               NSString *coursetempString = examElement.text;
                               [self.scoreArray addObject:coursetempString];
                           }
                       }
                   }
                   NSArray *failScoreArray = [xpathParser searchWithXPathQuery:@"//span"];
                   for (TFHppleElement *hppleElement in failScoreArray)
                   {
                       if([[hppleElement objectForKey:@"class"]isEqualToString:@"red"])
                       {
                           //NSLog(@"2222%@",hppleElement.text);
                           [self.failScoreArray addObject:hppleElement.text];
                       }
                   }
                   [self fetchScore];
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"error %@",error.description);
               }];
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

- (void)fetchScore
{
    //Get the Exam information
    ScoreModel *scoreModel;
    self.scoreModelArray = [[NSMutableArray alloc]init];
    NSMutableArray *scoreModelData = [[NSMutableArray alloc]init];
    int indexForFailScore = 2;
    for(int i = 3; i < self.scoreArray.count; i += 5)
    {
        if(![self isNum:[self.scoreArray objectAtIndex:i]])
        {
            [self.scoreArray insertObject:[self.failScoreArray objectAtIndex:indexForFailScore]  atIndex:i];
            indexForFailScore++;
        }
    }
    //NSLog(@"333%ld",self.scoreArray.count);
    for(int i = 0; i < self.scoreArray.count; i += 5)
    {
        scoreModel = [[ScoreModel alloc]init];
        scoreModel.courseName = [self.scoreArray objectAtIndex:(i + 1)];
        scoreModel.studyWay = [NSString stringWithFormat:@"学分：%@" ,[self.scoreArray objectAtIndex:(i + 2)]];
        scoreModel.courseCredit = [self.scoreArray objectAtIndex:(i + 3)];
        scoreModel.courseScore = [NSString stringWithFormat:@"修读方式：%@" ,[self.scoreArray objectAtIndex:(i + 4)]];

        [scoreModelData addObject:scoreModel];
    }
    self.scoreModelArray = scoreModelData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.scoreModelArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"score Cell" forIndexPath:indexPath];
    [cell updateCellWithCourseName:[[self.scoreModelArray objectAtIndex:indexPath.row]courseName]
                          StudyWay:[[self.scoreModelArray objectAtIndex:indexPath.row]studyWay]
                      CourseCredit:[[self.scoreModelArray objectAtIndex:indexPath.row]courseCredit]
                       CourseScore:[[self.scoreModelArray objectAtIndex:indexPath.row]courseScore]];
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
