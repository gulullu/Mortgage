//
//  ChooseDataViewController.h
//  Mortgage
//
//  Created by BobAngus on 15/7/15.
//  Copyright (c) 2015年 Bob Angus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseDataDelegate <NSObject>
-(void)ChooseDataWithType:(int)type Tag:(int)tag Value:(float)value;
@end

@interface ChooseDataViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type Tag:(int)tag Values:(NSArray *)values;
@property (strong, nonatomic) id<ChooseDataDelegate> delegate;
@end
