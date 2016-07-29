//
//  ViewController.m
//  CoreData
//
//  Created by WS on 16/7/22.
//  Copyright © 2016年 WS. All rights reserved.
//

#import "ViewController.h"
#import "CollegeManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[[CollegeManager shareManager] initlizeData];
    NSString * doc_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"%@", doc_path);
    
    self.navigationItem.title = @"Core Data";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
