//
//  ViewController.m
//  ToDoList
//
//  Created by Kevin Remigio on 5/13/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import "ViewController.h"
#import "CoreDataStack.h"

@interface ViewController () {
    //holds a list of things to do
    NSMutableArray *arrayOfItems;
    BOOL isUpdating;
    
    //helps toggle selected rows
    NSMutableSet *selectedIndexes;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrayOfItems = [[NSMutableArray alloc]init];
    selectedIndexes = [[NSMutableSet alloc]init];
    
    //get stuff from db
    [self refreshData];
}

- (IBAction)addItem:(id)sender {
    CoreDataStack *cds = [CoreDataStack coreDataStack];
    NSString *note = [[NSString alloc] initWithString:_txtField.text] ;

    if(isUpdating) {
        //get object in the row
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        ToDoList *tdl = [arrayOfItems objectAtIndex:indexPath.row];
        [cds updateItemTo:note forItem:tdl];
        
        //already updated so reset to default "add note"
        isUpdating = NO;
        _myButton.titleLabel.text = @"Add Note";
        
        //refresh selected indexes
        [selectedIndexes removeAllObjects];
    }
    else  {
        //add new item to to do list
        [cds addItem:note];
    }
    [self refreshData];
    
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([selectedIndexes containsObject:indexPath]) {
        //TIME TO DESELECT AND IS NO LONGER UPDATING
        [_myTableView deselectRowAtIndexPath:indexPath animated:YES];
        [selectedIndexes removeObject:indexPath];
        isUpdating = NO;
        _myButton.titleLabel.text = @"Add Note";
    } else {
        //Row is now selected, keep track, and prep to update
        [selectedIndexes addObject:indexPath];
        isUpdating = YES;
        _myButton.titleLabel.text = @"Update";
    }

}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //resets selected rows
    [selectedIndexes removeAllObjects];
}
-(void) refreshData {
    //get fresh copy of db
    [arrayOfItems removeAllObjects];
    
    CoreDataStack *cds = [CoreDataStack coreDataStack];
    [arrayOfItems addObjectsFromArray:cds.getAllItems];
    _txtField.text = @"";
    [_myTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayOfItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //REUSABLE CELLS
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ToDoList *tdl = [arrayOfItems objectAtIndex:indexPath.row];
    
    //get note
    cell.textLabel.text = tdl.note;
    
    //format date
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //get date
    NSString *stringFromDate = [formatter stringFromDate:tdl.date];
    cell.detailTextLabel.text = stringFromDate;
    
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ToDoList *list = [arrayOfItems objectAtIndex:indexPath.row];
        
        [arrayOfItems removeObjectAtIndex:indexPath.row];
        CoreDataStack *cds = [CoreDataStack coreDataStack];
        [cds.managedObjectContext deleteObject:list];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
@end
