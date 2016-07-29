//
//  TableViewController.h
//  CoreData
//
//  Created by WS on 16/7/26.
//  Copyright © 2016年 WS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *avatar_imageView;

@property (weak, nonatomic) IBOutlet UILabel *content_label;

@end

@interface TableViewController : UITableViewController

- (IBAction)addCourseButtonAction:(id)sender;

@end
