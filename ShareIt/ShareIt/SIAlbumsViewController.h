//
//  SIAlbumsViewController.h
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIAlbumsViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *myTable;
@property(nonatomic) NSString *userID;
//@property (strong, nonatomic) NSDictionary *dataDict;
//@property (strong, nonatomic) NSMutableArray *dataArary;

- (IBAction)addAlbum:(id)sender;

@end
