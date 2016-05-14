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
    NSMutableArray *arrayOfItems;
    BOOL isUpdating;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrayOfItems = [[NSMutableArray alloc]init];
    [self refreshData];
}

- (IBAction)addItem:(id)sender {
    //[arrayOfItems addObject:_txtField.text];
    CoreDataStack *cds = [CoreDataStack coreDataStack];
 //   ToDoList *tdl = [NSEntityDescription insertNewObjectForEntityForName:@"ToDoList" inManagedObjectContext:cds.managedObjectContext];
    NSString *note = [[NSString alloc] initWithString:_txtField.text] ;

    if(isUpdating) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        ToDoList *tdl = [arrayOfItems objectAtIndex:indexPath.row];
        [cds updateItemTo:note forItem:tdl];
        isUpdating = NO;
    }
    else  {
        //[sender setTitle:@"Add Notes" forState: UIControlStateNormal];
        [cds addItem:note];
    }
    [self refreshData];
    
} 
-(void) refreshData {
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   //     [sender setTitle:@"Update Info" forState:UIControlStateNormal];
    if (!isUpdating) {
        _myButton.titleLabel.text = @"Update";
        isUpdating = YES;
    } else {
        isUpdating = NO;
        _myButton.titleLabel.text = @"Add Note";
        [_myTableView deselectRowAtIndexPath:[_myTableView indexPathForSelectedRow] animated:YES];
    }


}
//- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
//    _myButton.titleLabel.text = @"Add Infos";
//    [_myTableView deselectRowAtIndexPath:[_myTableView indexPathForSelectedRow] animated:YES];
//    
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        ToDoList *list = [arrayOfItems objectAtIndex:indexPath.row];
        
        [arrayOfItems removeObjectAtIndex:indexPath.row];
        CoreDataStack *cds = [CoreDataStack coreDataStack];
        [cds.managedObjectContext deleteObject:list];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
@end
