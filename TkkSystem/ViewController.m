//
//  ViewController.m
//  TkkSystem
//
//  Created by liny on 2018/3/23.
//  Copyright © 2018年 liny. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "CourseViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *webText;
@property (weak, nonatomic) IBOutlet UIImageView *checkCodeImageView;
@property (strong, nonatomic) IBOutlet UITextField *usernameText;
@property (strong, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) IBOutlet UITextField *checkCodeText;
@property (strong, nonatomic) NSDictionary *cookieDictionary;
@property (assign, nonatomic) NSStringEncoding enc;
@property (strong, nonatomic) NSString *alertString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.checkCodeText.delegate = self;
    self.usernameText.delegate = self;
    self.passwordText.delegate = self;
    self.usernameText.keyboardAppearance= UIKeyboardAppearanceAlert;
    self.usernameText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordText.keyboardAppearance= UIKeyboardAppearanceAlert;
    self.checkCodeText.keyboardAppearance= UIKeyboardAppearanceAlert;
    self.checkCodeText.autocorrectionType = UITextAutocorrectionTypeNo;
    self.enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    //清空Cookie
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage   sharedHTTPCookieStorage];
    NSArray *cookieArray = [NSArray arrayWithArray:[cookieJar cookies]];
    
    for (NSHTTPCookie *cookie in cookieArray) {
        [cookieJar deleteCookie:cookie];
    }
    //不确定是不是写在这里最合适，要去看生命周期表，还有就是开个多线程
    [self getCheckCode];
    
    //注册键盘弹出通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES]; //实现该方法是需要注意view需要是继承UIControl而来的
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登陆
- (IBAction)login:(id)sender {


    NSString *urlString = @"http://jw.xujc.com/index.php?c=Login&a=login";
    NSString *parameters =[NSString stringWithFormat:@"username=%@&password=%@&imgcode=%@&user_lb=%%D1%%A7%%C9%%FA",self.usernameText.text,self.passwordText.text,self.checkCodeText.text];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"POST"
                                                                      URLString:[[NSURL URLWithString:urlString] absoluteString]
                                                                     parameters:nil
                                                                          error:nil];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[parameters dataUsingEncoding:self.enc]];
    //NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:@"jwimgcode.value"];
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"%@=%@",@"jwimgcode",value] forHTTPHeaderField:@"Cookie"];
    [[manager.session dataTaskWithRequest:request
                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSData *htmlData = data;
            NSString *tranStr = [[NSString alloc]initWithData:htmlData encoding:self.enc];
            NSString *uft8HtmlStr = [tranStr stringByReplacingOccurrencesOfString:@"gb2312" withString:@"utf-8"];
            //self.webText.text = tranStr;
            
            //输出保存的所有Cookie
            NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for(NSHTTPCookie *cookie in [cookieJar cookies]) {
                NSLog(@"%@", cookie);
            }
            
            NSData *utf8HtmlData = [uft8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];
            TFHpple *xpathParser = [TFHpple hppleWithHTMLData:utf8HtmlData];
            NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//script"];
            for (TFHppleElement *hppleElement in dataArray)
            {
                if([hppleElement.raw containsString:@"alert"])
                {
                    NSLog(@"scriptxxx%@",hppleElement.raw);
                    NSRange lastAlertRange = [hppleElement.raw rangeOfString:@"alert" options:NSBackwardsSearch];//匹配得到的下标
                    NSString *lastAlertString = [hppleElement.raw substringFromIndex:lastAlertRange.location];//截取范围类的字符串
                    NSRange firstBracketsRange = [lastAlertString rangeOfString:@")"];//匹配得到的下标
                    NSString *alertString = [lastAlertString substringWithRange:NSMakeRange(7, firstBracketsRange.location - 8)];
                    self.alertString = [[NSString alloc]init];
                    self.alertString = alertString;
                    NSLog(@"Alert String：%@",alertString);
                }
            }
            if (self.alertString != nil)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:self.alertString preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                    {
                        NSLog(@"OK Action");
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    self.alertString = nil;
                });
            }
            else
            {
                NSLog(@"tranStr is %@",tranStr);
                NSLog(@"Reply JSON: %@", response);
                [self getHtml];
            }
        } else {
            NSLog(@"Error: %@, %@", error, response);
        }
    }]resume];
    
}

-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //目标视图UITextField
    CGRect frame = self.checkCodeText.frame;
    int y = frame.origin.y + frame.size.height - (self.view.frame.size.height - keyboardSize.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    if(y > 0)
    {
        self.view.frame = CGRectMake(0, -y, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}

//键盘隐藏后将视图恢复到原始状态

-(void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)getHtml
{
    AFHTTPSessionManager *studentManager = [AFHTTPSessionManager manager];
    studentManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    studentManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *studentUrl = @"http://jw.xujc.com/student/index.php";
    
    [studentManager GET:studentUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        

        NSString *studentStr = [[NSString alloc]initWithData:responseObject encoding:self.enc];
        NSLog(@"studentStr is %@",studentStr);
        //self.webText.text = studentStr;
        //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //        NSLog(@"checkCodeCookie = %@",[defaults objectForKey:@"jwimgcode.value"]);
        TFHpple *xpathParser = [[TFHpple alloc]initWithHTMLData:responseObject];
        NSArray *dataArray = [xpathParser searchWithXPathQuery:@"//div"];
        for (TFHppleElement *hppleElement in dataArray)
        {
            if([[hppleElement objectForKey:@"id"]isEqualToString:@"inf"])
            {
                NSLog(@"hppleElement%@",hppleElement.text);
                [self performSegueWithIdentifier:@"mainInterfaceSegue" sender:nil];
                //[self presentViewController:self.tabBarController animated:YES completion:NULL];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.description);
    }];
}

- (IBAction)checkCodeRefresh:(id)sender {
    [self getCheckCode];
}

-(void)getCheckCode{
    AFHTTPSessionManager *codeManager = [AFHTTPSessionManager manager];
    codeManager.responseSerializer = [AFImageResponseSerializer serializer];//设置返回的数据类型为image
    codeManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSString *checkCodeUrl = @"http://jw.xujc.com/imgcode.php";
//    // 设置自动管理Cookies
//    codeManager.requestSerializer.HTTPShouldHandleCookies = YES;
    
    [codeManager GET:checkCodeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //获取验证码Cookie
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        //cookie中可能有多组数据，找到你需要的那一组，并且保存到沙盒中
        for(NSHTTPCookie *cookie in [cookieJar cookies])
        {
            if ([cookie.name isEqualToString:@"jwimgcode"]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:cookie.name forKey:@"jwimgcode"];
                [defaults setObject:cookie.value forKey:@"jwimgcode.value"];
                [defaults synchronize];
            }
        }
        
        //输出保存的所有Cookie
//        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        for(NSHTTPCookie *cookie in [cookieJar cookies]) {
//            NSLog(@"%@", cookie);
//        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSLog(@"checkCodeCookie = %@",[defaults objectForKey:@"jwimgcode.value"]);
        
        //设置ImageView的图片为返回的图片
        self.checkCodeImageView.image = responseObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.description);
    }];
}


@end
