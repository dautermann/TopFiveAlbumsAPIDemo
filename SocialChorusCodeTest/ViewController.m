//
//  ViewController.m
//  SocialChorusCodeTest
//
//  Created by Michael Dautermann on 9/29/14.
//  Copyright (c) 2014 Michael Dautermann. All rights reserved.
//

#import "ViewController.h"
#import "JSONAPI.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // let's go get the json!
    NSURLRequest *jsonDataRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://recordsapi.apiary-mock.com/records/"]];
    NSURLResponse *jsonResponse;
    NSError *error = nil;
    NSData * jsonData = [NSURLConnection sendSynchronousRequest:jsonDataRequest returningResponse:&jsonResponse error:&error];
    
    if([jsonData length] > 0)
    {
        NSString *jsonDataAsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [JSONAPIResourceLinker link:@"artist" toLinkedType:@"artists"];
        
        JSONAPI *jsonAPI = [JSONAPI JSONAPIWithString:jsonDataAsString];
        
        NSLog(@"jsonData  is %@", [jsonAPI description]);
        
        self.albumArray = [jsonAPI resourcesForKey:@"records"];
        for(JSONAPIResource *record in self.albumArray) {
            
            JSONAPIResource *artistName = (JSONAPIResource *)[record linkedResourceForKey:@"artist"];
            
            NSLog(@"album name is %@ and record name is %@", [artistName objectForKey:@"name"], [record objectForKey:@"name"]);
        }
    }
    else
    {
        NSLog(@"error from getting json data - %@", [error localizedDescription]);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return([self.albumArray count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"AwesomeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    JSONAPIResource *albumRecord = [self.albumArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [albumRecord objectForKey:@"name"];
    
    JSONAPIResource *artistName = [albumRecord linkedResourceForKey:@"artist"];

    cell.detailTextLabel.text = [artistName objectForKey:@"name"];
    
    return cell;
}

@end
