//
//  ViewController.h
//  ToDoList
//
//  Created by Kevin Remigio on 5/13/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoList.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtField;
- (IBAction)addItem:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *myButton;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

