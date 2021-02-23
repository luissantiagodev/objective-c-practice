//
//  ViewController.m
//  ObjcPractice
//
//  Created by Luis Santiago on 20/02/21.
//

#import "TableViewController.h"
#import "ObjcPractice-Swift.h"
#import "RegisterEditController.h"
#import "ServerRequest.h"

@interface TableViewController ()


@property (strong, nonatomic) NSMutableArray<Receipt *> * receipts;

@end
//
@implementation TableViewController

NSString * cellId = @"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCourses];
    [self setUpNavbar];
    [self fetchData];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier: cellId];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receipts.count;
}

- (void)setUpCourses {
    self.receipts = NSMutableArray.new;
}

- (void) fetchData {
    
    ServerRequest *sharedManager = [ServerRequest sharedServerRequest];
    
    
    [sharedManager fetchReceipts:^(NSMutableArray * _Nonnull list, NSError* error) {
        if(error){
            //Show error
        }else{
            self.receipts = list;
            [self updateList];
        }
    }];

}


-(void)updateList {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)showConfirmDialogue:(void (^)(void))deleteCompletionBlock
{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"¿Estas seguro de eliminar este elemento"
                                 message:@"Esta acción no podrá deshacerse"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Eliminar elemento"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
        deleteCompletionBlock();
    }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Deshacer acción"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
        //Do Nothing for the moment
    }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleDestructive title:@"Eliminar" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)){
        [self showConfirmDialogue:^{
            NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:
                                         [NSIndexPath indexPathForRow:indexPath.item inSection:indexPath.section],
                                         nil];
            
            //Delete Element
            [self.receipts removeObjectAtIndex: indexPath.item];
            [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation: UITableViewRowAnimationBottom];
        }];
    }];
    
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title:@"Editar" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)){
        completionHandler(true);
    }];
    

    UISwipeActionsConfiguration *configurations = [UISwipeActionsConfiguration configurationWithActions: @[deleteAction , editAction]];
    
    return configurations;
    
}

- (void)setUpNavbar {
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.navigationItem.title = @"Receipts";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed: @"icons8-plus-100"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(handleAddButton)];
    
    self.navigationItem.rightBarButtonItem = flipButton;
}


-(void) handleAddButton {
    RegisterEditController * formController = [[RegisterEditController alloc] init];
    formController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController pushViewController:formController animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    Receipt *reciept = self.receipts[indexPath.row];
    cell.backgroundColor = UIColor.whiteColor;
    cell.textLabel.text = reciept.provider;
    cell.detailTextLabel.text = reciept.emission_date;
    
    return cell;
}

@end
