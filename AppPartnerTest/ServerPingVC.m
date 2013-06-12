//
//  ServerPingVC.m
//  AppPartnerTest
//
//  Created by Ujwal Manjunath on 6/12/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "ServerPingVC.h"

@interface ServerPingVC ()

@property(nonatomic,strong)NSDate *start;
@property (weak, nonatomic) IBOutlet UIImageView *popUp;
@property (weak, nonatomic) IBOutlet UILabel *responseLabel;


@end

@implementation ServerPingVC

-(NSDate *)start
{
    if(!_start) _start = [[NSDate alloc]init];
    return _start;
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
	// Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.responseLabel setText:@""];
    [self.popUp setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pingServer:(UIButton *)sender {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ec2-54-243-205-92.compute-1.amazonaws.com/Tests/ping.php"]];
    
    [request setHTTPMethod:@"POST"];
    NSString *params = [[NSString alloc] initWithFormat:@"Password=EGOT"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    self.start = [NSDate date];
   
    [connection start];
  
   
         
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection Error: %@", [error description]);
    
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:[error description]
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Connection did Receive Response");
    
   
    
      
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
     NSLog(@"Connection did Receive Data");
    
    NSString *response =  [[NSString  alloc]initWithData:data encoding:NSUTF8StringEncoding] ;
    
    double ellapsedSeconds = [[NSDate date] timeIntervalSinceDate:self.start];
    NSLog(@"ellapsed time:%f",ellapsedSeconds);
    
    NSString *responseString = [NSString stringWithFormat:@"Response: %@ PingTime:%f sec",response,ellapsedSeconds];
    [self.popUp setHidden:NO];
    [self.responseLabel setText:responseString];

   
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection did Finish Loading");
}

    







@end
