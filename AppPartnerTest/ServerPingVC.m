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

#define PARAM @"Password=EGOT"
#define REQUEST_URL @"http://ec2-54-243-205-92.compute-1.amazonaws.com/Tests/ping.php"
#define METHOD @"POST"

-(NSDate *)start
{
    if(!_start) _start = [[NSDate alloc]init];
    return _start;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.responseLabel setText:@""];
    [self.popUp setHidden:YES];
}

- (IBAction)pingServer:(UIButton *)sender
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:REQUEST_URL]];
    [request setHTTPMethod:METHOD];
    NSString *params = [[NSString alloc] initWithFormat:PARAM];
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