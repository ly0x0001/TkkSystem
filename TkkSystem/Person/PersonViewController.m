//
//  PersonViewController.m
//  
//
//  Created by liny on 2018/5/8.
//

#import "PersonViewController.h"
#import "PersonTableViewCell.h"
#import "ExamTableViewController.h"
@interface PersonViewController ()
@property (strong, nonatomic)NSArray *itemArray;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //self.headImage.image = [UIImage imageNamed:@"headImage.png"];
    self.tableView.alwaysBounceVertical=NO;
    self.itemArray = [[NSArray alloc]initWithObjects:@"考试安排", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    PersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell" forIndexPath:indexPath];
//    [cell updateCellWithImage:nil LableText:[self.itemArray objectAtIndex:indexPath.row]];
//    cell.backgroundColor = [UIColor clearColor];
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 0)
//    {
//        ExamTableViewController *examTVC = [[ExamTableViewController alloc]init];
//        [[self navigationController]pushViewController:examTVC animated:YES];
//    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
