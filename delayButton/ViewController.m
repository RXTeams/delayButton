//
//  ViewController.m
//  delayButton
//
//  Created by 张衡 on 2016/12/5.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (IBAction)buttonClick:(UIButton *)sender {
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    NSString *str = [NSString stringWithFormat:@"%@\n%f", self.label.text, interval];
    self.label.text = str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
