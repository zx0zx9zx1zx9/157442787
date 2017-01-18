//
//  ViewController.h
//  Oc1
//
//  Created by zhangxin on 2016/10/31.
//  Copyright © 2016年 Apple inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)click:(id)sender;

@end

