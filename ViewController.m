//
//  ViewController.m
//  Oc1
//
//  Created by zhangxin on 2016/10/31.
//  Copyright © 2016年 Apple inc. All rights reserved.
//

#import "ViewController.h"
#import "SimpleTableCell.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TestModel.h"
#import "SqliteTool.h"
@interface ViewController ()

@end

@implementation ViewController

{
    NSArray *tableData;
    NSArray *thumbnails;
    NSArray *preTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableData = [NSArray arrayWithObjects: @"111", @"222", @"333", @"444", nil];
    //thumbnails =[NSArray arrayWithObjects: @"Image1", @"Image2", @"Image3", @"Image4",nil];
    //preTime = [NSArray arrayWithObjects:@"10:10",@"10:20",@"10:30",@"10:40", nil];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"receipes" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile: path];
    tableData = [dict objectForKey:@"RecipeName"];
    thumbnails = [dict objectForKey:@"Thumbnail"];
    preTime = [dict objectForKey:@"PrepTime"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sim = @"sim";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sim];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sim];
    }
    
    
    UIImage *uiimage = [UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    CGSize imageSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    //获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片 ,三个参数含义是设置大小、透明度 （NO为不透明）、缩放（0代表不缩放）
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [uiimage drawInRect:imageRect];
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIGraphicsEndImageContext();
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"will");
    if (indexPath == 0) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *mess = [[UIAlertView alloc] initWithTitle:@"row selected" message:@"you selected a row" delegate:nil cancelButtonTitle:@"ok"otherButtonTitles:nil, nil];
    
    
   
    //[mess show];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (IBAction)click:(id)sender {
    TestModel *model = [[TestModel alloc]init];
    model.name = @"小明";
    model.age = 35;
    model.sex = @"man";
    
    TestModel *model1 = [[TestModel alloc]init];
    model1.name = @"小花";
    model1.age = 23;
    model1.sex = @"woman";
    
    if([[SqliteTool shareinstance] creatSqliteDB]){
        if([[SqliteTool shareinstance] createTable]){
            
            //增
//            if([[SqliteTool shareinstance] insertModel:model] && [[SqliteTool shareinstance] insertModel:model1]){
//                NSLog(@"增加model、model1");
//                NSLog(@"%@",[[SqliteTool shareinstance] selectAllModel]);
//            }
            
            //删
            if([[SqliteTool shareinstance] deletedateModel:model1]){
                NSLog(@"删除model1");
                NSLog(@"%@",[[SqliteTool shareinstance] selectAllModel]);
            }
//
//            //改
//            
//            model.age = 28;
//            //注意 这里因为是以名字作为索引对象，因此名字是不能修改的， 如果要修改名字，应该另外增加一个不变属性作为索引
//            if([[SqliteTool shareinstance] updateModel:model]){
//                NSLog(@"修改model");
//                NSLog(@"%@",[[SqliteTool shareinstance] selectAllModel]);
//            }
//
//            //查
//            NSLog(@"%@",[[SqliteTool shareinstance] selectAllModel]);
            
        }
    }
    
}
//- (IBAction)click:(id)sender {
//    NSLog(@"testkkkkkkkk");
//   // NSString *fullPath = @"";
//    AVPlayerItem *item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://dl.mojing.baofeng.com/xianchang/151008/1444301665_SD.mp4"]];
//    AVPlayer *player=[AVPlayer playerWithPlayerItem:item];
//    //NSURL *videoURL = [NSURL fileURLWithPath:fullPath];
//    //AVPlayer *player = [AVPlayer playerWithUR L:videoURL];
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
//    playerLayer.frame=CGRectMake(0, 0, 100, 100);
//    //playerLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:playerLayer];
//    [player play];
//}
@end
