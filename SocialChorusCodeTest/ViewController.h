//
//  ViewController.h
//  SocialChorusCodeTest
//
//  Created by Michael Dautermann on 9/29/14.
//  Copyright (c) 2014 Michael Dautermann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak) IBOutlet UITableView *tableView;

@property (strong) NSArray *albumArray;

@end

