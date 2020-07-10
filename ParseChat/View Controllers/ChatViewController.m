//
//  ChatViewController.m
//  ParseChat
//
//  Created by meganyu on 7/6/20.
//  Copyright © 2020 meganyu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatCell.h"
#import <Parse/Parse.h>

static NSString *const kChatCellIdentifier = @"ChatCell";
static NSString *const kCreatedAtKey = @"createdAt";
static NSString *const kMessageClassName = @"Message_fbu2020";
static NSString *const kTextKey = @"text";
static NSString *const kUserKey = @"user";

#pragma mark - Interface

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messageArray;

@end

#pragma mark - Implementation

@implementation ChatViewController

#pragma mark - Setup

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:true];
}

#pragma mark - Refresh Data

- (void)refresh {
    PFQuery *const query = [PFQuery queryWithClassName:kMessageClassName];
    [query orderByDescending:kCreatedAtKey];
    [query includeKey:kUserKey];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *messages, NSError *error) {
        if (messages != nil) {
            self.messageArray = messages;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - User Interactions

- (IBAction)didTapSend:(id)sender {
    PFObject *const chatMessage = [PFObject objectWithClassName:kMessageClassName];
    
    chatMessage[kTextKey] = self.messageField.text;
    chatMessage[kUserKey] = PFUser.currentUser;
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.messageField.text = nil;
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *const cell = [tableView dequeueReusableCellWithIdentifier:kChatCellIdentifier];
    
    PFObject *const message = self.messageArray[indexPath.row];
    cell.messageLabel.text = message[kTextKey];
    
    PFUser *const user = message[kUserKey];
    if (user != nil) {
        cell.usernameLabel.text = user.username;
    } else {
        cell.usernameLabel.text = @"🤖";
    }
    
    return cell;
}

@end
