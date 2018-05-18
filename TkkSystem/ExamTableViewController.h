//
//  ExamTableViewController.h
//  TkkSystem
//
//  Created by liny on 2018/4/20.
//  Copyright © 2018年 liny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *ExamModelArray;
@end
