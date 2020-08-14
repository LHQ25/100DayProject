//
//  ViewController.m
//  Day18_OC(RadioButton)
//
//  Created by 亿存 on 2020/8/10.
//  Copyright © 2020 亿存. All rights reserved.
//

#import "ViewController.h"

#import "RadioButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 200, 30)];
    [self.view addSubview:label];
    
    UIButton *radio1 = [UIButton creatRadioWithName:@"苹果" val:@"1" selected:YES];
    radio1.frame = CGRectMake(20, 100, 100, 30);
    UIButton *radio2 = [UIButton creatRadioWithName:@"梨子" val:@"2" selected:NO];
    radio2.frame = CGRectMake(20, 140, 100, 30);
    UIButton *radio3 = [UIButton creatRadioWithName:@"香蕉" val:@"3" selected:NO];
    radio3.frame = CGRectMake(20, 180, 100, 30);
    [RadioGroup onView:self.view select:^(UIButton *radio) {
        label.text = [NSString stringWithFormat:@"name:%@  val:%@",radio.name,radio.val];
    } radios:radio1,radio2,radio3,nil];
    
}


@end
