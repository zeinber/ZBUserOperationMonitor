//
//  YYTextViewController.m
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/13.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import "YYTextViewController.h"
#import "YYTextView.h"

@interface YYTextViewController ()

@end

@implementation YYTextViewController

#pragma mark - view Func
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    YYTextView *textView = [[YYTextView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    [self.view addSubview:textView];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.text = @"YYTextView测试的文字";
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
