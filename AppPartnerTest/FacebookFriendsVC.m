//
//  FacebookFriendsVC.m
//  AppPartnerTest
//
//  Created by Ujwal Manjunath on 6/12/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "FacebookFriendsVC.h"
#import "facebookFriendCell.h"


@interface FacebookFriendsVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *fbCell;

@property (weak, nonatomic) IBOutlet UITableView *friendsListView;
@property(strong,nonatomic) NSMutableDictionary *fbFriendsList;
@property(strong,nonatomic) NSMutableArray *photos;
@property(strong,nonatomic) NSMutableDictionary *facebookUidToImageDownloadOperations;
@property (strong,nonatomic) NSOperationQueue *imageLoadingOperationQueue ;

@end

@implementation FacebookFriendsVC
@synthesize photos=_photos;
-(NSOperationQueue *)imageLoadingOperationQueue
{
    if(!_imageLoadingOperationQueue)
        _imageLoadingOperationQueue =  [[NSOperationQueue alloc] init];
    return _imageLoadingOperationQueue;
}

-(NSMutableDictionary *)fbFriendsList
{
    if(!_fbFriendsList){
       _fbFriendsList = [[NSMutableDictionary alloc]init]; 
    }
    return _fbFriendsList;
}

-(NSMutableDictionary *)facebookUidToImageDownloadOperations
{
    if(!_facebookUidToImageDownloadOperations){
        _facebookUidToImageDownloadOperations = [[NSMutableDictionary alloc]init];
    }
    return _facebookUidToImageDownloadOperations;
}

-(NSMutableArray *)photos
{
    if(!_photos){
        _photos = [[NSMutableArray alloc]init];
        
    }
    return _photos;
}

-(void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    [self.friendsListView reloadData];
}

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

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fbFriendsList count];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendViewCell"];
    NSArray *allKeys = [self.fbFriendsList allKeys];
    dispatch_queue_t loaderQ = dispatch_queue_create("imageloader", NULL);
    
    
    dispatch_async(loaderQ, ^{
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:allKeys[indexPath.row]]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.textLabel.text = [self.fbFriendsList valueForKey:[allKeys objectAtIndex:indexPath.row]];
            //   NSString *urlString =
            cell.imageView.image = image;
            //[self.photos objectAtIndex:indexPath.row];

          
        });
    });

    
    
    
      
    
   
    
    return cell;
}*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSArray *facebookFriends = [self.fbFriendsList allKeys];
//FacebookFriend *friend =
//FacebookFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:FB_CELL_IDENTIFIER forIndexPath:indexPath];
    facebookFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendViewCell" forIndexPath:indexPath];
    cell.nameLabel.text = [self.fbFriendsList valueForKey:[facebookFriends objectAtIndex:indexPath.row]];
    
//Create a block operation for loading the image into the profile image view
        NSBlockOperation *loadImageIntoCellOp = [[NSBlockOperation alloc] init];
//Define weak operation so that operation can be referenced from within the block without creating a retain cycle
    __weak NSBlockOperation *weakOp = loadImageIntoCellOp;

    [loadImageIntoCellOp addExecutionBlock:^(void){
        //Some asynchronous work. Once the image is ready, it will load into view on the main queue
        UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:facebookFriends[indexPath.row]]]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^(void) {
            //Check for cancelation before proceeding. We use cellForRowAtIndexPath to make sure we get nil for a non-visible cell
            if (!weakOp.isCancelled) {
               facebookFriendCell *theCell = (facebookFriendCell *)[tableView cellForRowAtIndexPath:indexPath];
                theCell.profileImage.image = profileImage;
                
                [self.facebookUidToImageDownloadOperations removeObjectForKey:[self.fbFriendsList valueForKey:[facebookFriends objectAtIndex:indexPath.row]]];
            }
        }];
    }];
    
//Save a reference to the operation in an NSMutableDictionary so that it can be cancelled later on
    if (facebookFriends[indexPath.row]) {
        [self.facebookUidToImageDownloadOperations setObject:loadImageIntoCellOp forKey:[self.fbFriendsList valueForKey:[facebookFriends objectAtIndex:indexPath.row]]];
    }
    
//Add the operation to the designated background queue
    if (loadImageIntoCellOp) {
        [self.imageLoadingOperationQueue addOperation:loadImageIntoCellOp];
    }
    
//Make sure cell doesn't contain any traces of data from reuse -
//This would be a good place to assign a placeholder image
   cell.imageView.image = nil;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
   // FacebookFriend *friend = [self.facebookFriends objectAtIndex:indexPath.row];
    NSArray *facebookFriends = [self.fbFriendsList allKeys];
    //Fetch operation that doesn't need executing anymore
    NSBlockOperation *ongoingDownloadOperation = [self.facebookUidToImageDownloadOperations objectForKey:[self.fbFriendsList valueForKey:[facebookFriends objectAtIndex:indexPath.row]]];
    if (ongoingDownloadOperation) {
        //Cancel operation and remove from dictionary
        [ongoingDownloadOperation cancel];
        [self.facebookUidToImageDownloadOperations removeObjectForKey:[self.fbFriendsList valueForKey:[facebookFriends objectAtIndex:indexPath.row]]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.imageLoadingOperationQueue cancelAllOperations];
}



- (IBAction)ReloadButtonPressed:(UIButton *)sender {
      
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession openActiveSessionWithReadPermissions:nil
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          }
                                          else if(session.isOpen){
                                             [self ReloadButtonPressed:sender];
                                          }
                                          
                                      }];
        return;
    }
   
 
[self LoadFriendsList];

   }



-(void)LoadFriendsList
{
    
    FBRequest *friendRequest = [FBRequest requestForGraphPath:@"me/friends"];
    [ friendRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       NSArray *data = [result objectForKey:@"data"];
        for (FBGraphObject<FBGraphUser> *friend in data) {
            [self.fbFriendsList setObject:[friend name] forKey:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture",[friend id]]];
      //      NSLog(@"%@",friend);
        }
        [self.friendsListView reloadData];
        }];
   
}

+(NSArray *)getUserImages:(NSArray *)urlList
{
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for(NSString *urlString in urlList){
        [photos addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]]];
    }
    return [photos copy];
    
}

@end
