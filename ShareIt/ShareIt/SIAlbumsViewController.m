//
//  SIAlbumsViewController.m
//  ShareIt
//
//  Created by student on 4/25/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

#import "SIAlbumsViewController.h"
#import "SIPhotosViewController.h"
#import "AFNetworking.h"
#import "SIUploadPhotoViewController.h"



@implementation SIAlbumsViewController

NSMutableArray *tableData;
NSMutableArray *tableID;
NSInteger i;
static NSString * getAlbumsURL;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSLog(@"userID: %@", _userID);
    
    getAlbumsURL = @"http://52.8.15.49:8080/photoshare/api/v1/users/";
    getAlbumsURL = [getAlbumsURL stringByAppendingString:_userID];
    getAlbumsURL = [getAlbumsURL stringByAppendingString:@"/album"];
    NSLog(@"getAlbumsURL: %@", getAlbumsURL);
    
    _myTable.dataSource=self;
    [self fetchAlbums];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIPhotosViewController *photoController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SIPhotosViewController"];
    photoController.userID = self.userID;
    //NSString *aId=[@(indexPath.row)description];
    //photoController.albumID = [tableID objectAtIndex:[aId integerValue]];
    photoController.albumID = tableID [indexPath.row];
    [self.navigationController pushViewController:photoController animated:YES];
    }

- (IBAction)addAlbum:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Album Name"
                                                    message:@"  "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *name = [alertView textFieldAtIndex:0].text;
        NSLog(@"%@",name);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *parameters = @{@"albumName": name};
        [manager POST:getAlbumsURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            [self fetchAlbums];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
        //[self didFinishLoadingwithData:name];
    }
}

//-(void) didFinishLoadingwithData:(NSString*) data {
//    [tableData addObject:data];
//    [self.tableView reloadData];
//}

-(void) fetchAlbums{
    tableData = [[NSMutableArray alloc] init];
    tableID = [[NSMutableArray alloc] init];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:getAlbumsURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@",responseObject);
//                 NSString *zees=[responseObject objectAtIndex:0][@"album"][2][@"albumId"];
//               NSLog(@"%@",zees);
        NSLog(@"response object count: %lu",[[responseObject objectAtIndex:0][@"album"] count]);
        for (i=0; i<[[responseObject objectAtIndex:0][@"album"] count]; i++) {
            [tableID addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumId"]];
            [tableData addObject:[responseObject objectAtIndex:0][@"album"][i][@"albumName"]];
            
        }
        
        NSLog(@"tableData count: %lu",[tableData count]);
        NSLog(@"tableData : %@",tableData);
        NSLog(@"tableId : %@",tableID);
        [self.tableView reloadData];
        
        //            NSArray *tableData2 = [NSArray arrayWithObjects:@"Default", @"Profile Pics", @"Uploads", nil];
        //            NSLog(@"tableData2 : %@",tableData2);
        
        //[tableData addObject:nil];
        
        //            NSString *zees=[responseObject objectForKey:@"feed"][@"author"][0][@"name"][@"$t"];
        //            NSLog(@"%@",zees);
        
        
        // NSLog(@"JSON: %@", responseObject);
        //    self.dataDict = (NSDictionary *) responseObject;
        //            self.dataArary = self.dataDict[@"feed"][@"author"][0][@"name"];
        //            NSString *zee=[self.dataArary valueForKey:@"$t"];
        //            NSLog(@"**************%@******%lu",self.dataArary,(unsigned long)self.dataArary.count);
        
        
        
        //NSError *error;
        
        // NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
        
        //NSLog(@"%@",jsonData);
        //NSLog(@"JSON: %@", responseObject.description);
        //        NSString *idValue  = responseObject[@"_id"];
        //        NSLog(@"%@",idValue);
        //        NSArray *array = responseObject[@"JSON"];
        //        NSArray *array2  = [array valueForKey: @"album"];
        //tableData = [array2 valueForKey: @"albumName"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end

