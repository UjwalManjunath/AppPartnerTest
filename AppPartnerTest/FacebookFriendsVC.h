//
//  FacebookFriendsVC.h
//  AppPartnerTest
//
//  Created by Ujwal Manjunath on 6/12/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h> 

@interface FacebookFriendsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)ReloadButtonPressed:(UIButton *)sender ;

@end
