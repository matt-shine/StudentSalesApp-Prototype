//
//  ItemViewController.m
//  StudentSalesAppII
//
//  Created by Lion User on 7/05/13.
//  Copyright (c) 2013 UQ DECO3800. All rights reserved.
//

#import "ItemViewController.h"
#import "DetailViewController.h"
#import "Constants.h"
#import "ItemViewCell.h"

@interface ItemViewController ()

@end

@implementation ItemViewController


@synthesize itemTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.itemTable addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)retrieveFromParse {
    
    PFQuery *retrieveItems = [PFQuery queryWithClassName:WALL_OBJECT];
    [retrieveItems orderByDescending:KEY_CREATION_DATE];
    
    [retrieveItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            itemArray = [[NSArray alloc] initWithArray:objects];
        }
        [itemTable reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(retrieveFromParse)];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//*********************Setup table of folder names ************************

//get number of sections in tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

//get number of rows by counting number of folders
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemArray.count;
}

//setup cells in tableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
    PFObject *tempObject = [itemArray objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"ItemViewCell";
    
    ItemViewCell *cell = (ItemViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.itemTitle.text = [NSString stringWithFormat:@"%@", [tempObject objectForKey:KEY_TITLE]];
    
    cell.itemPrice.text = [NSString stringWithFormat:@"$%@", [tempObject objectForKey:KEY_PRICE]];
    
    cell.itemDesc.text = [NSString stringWithFormat:@"%@", [tempObject objectForKey:KEY_COMMENT]];
    
    PFFile *theImage = [tempObject objectForKey:KEY_IMAGETHUMB];
    NSData *imageData = [theImage getData];
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageThumb.image = image;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


//user selects folder to add tag to
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *tempObject = [itemArray objectAtIndex:indexPath.row];
    
    NSString *selectedObjectID = [tempObject objectForKey:@"text"];
    
    DetailViewController *dvController = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    dvController.selectedObjectID = selectedObjectID;
    dvController.selectedObject = tempObject;
    [self.navigationController pushViewController:dvController animated:YES];


}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}



@end
