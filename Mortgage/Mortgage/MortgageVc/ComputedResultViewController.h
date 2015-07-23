//
//  ComputedResultViewController.h
//  Mortgage
//
//  Created by BobAngus on 15/7/14.
//  Copyright (c) 2015年 Bob Angus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComputedResultViewController : UIViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type PaymentMethod:(int)paymentMethod ValuesDic:(NSArray *)valuesDic;
@end
