//
//  ChooseDataViewController.m
//  Mortgage
//
//  Created by BobAngus on 15/7/15.
//  Copyright (c) 2015年 Bob Angus. All rights reserved.
//

#import "ChooseDataViewController.h"

@interface ChooseDataViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *lmainTable;
@property (assign, nonatomic) int lTag;
@property (assign, nonatomic) int lType;
@property (strong, nonatomic) NSArray *loanRateArray;
@property (strong, nonatomic) NSArray *loanRateValuesArray;
@property (strong, nonatomic) NSArray *lvaluesArray;
@end

@implementation ChooseDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type Tag:(int)tag Values:(NSArray *)values{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lType = type;
        _lTag = tag;
        _lvaluesArray = values;
    }
    return self;
}
-(void)initView{
    if (_lType == 1) {
        self.title = @"按揭年限";
    }else{
        self.title = @"贷款利率";
    }
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backImage_n"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(clickLeftButton)];
    leftButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    if (_lvaluesArray == nil) {
        _loanRateArray = [[NSArray alloc]initWithObjects:@"基准利率下限(7折)",@"基准利率",@"基准利率上限(1.1倍)", nil];
        _loanRateValuesArray = [[NSArray alloc]initWithObjects:@"4.76",@"6.8",@"7.48", nil];
    }else{
        _loanRateArray = _lvaluesArray;
    }
    _lmainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}



#pragma mark - TableView 相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_lType == 1) {
        return 30;
    }
    return _loanRateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (_lType == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d年 (%d期)",(int)indexPath.row+1,(int)(indexPath.row+1)*12];
    }else{
        if (_lvaluesArray == nil) {
            cell.textLabel.text = [_loanRateArray objectAtIndex:indexPath.row];
        }else{
            cell.textLabel.text = [[_loanRateArray objectAtIndex:indexPath.row]objectForKey:@"Name"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (_lType == 1) {
            if ([self.delegate respondsToSelector:@selector(ChooseDataWithType:Tag:Value:)]) {
                [self.delegate ChooseDataWithType:_lType Tag:_lTag Value:indexPath.row + 1];
            }
        }else{
            if (_lvaluesArray == nil) {
                if ([self.delegate respondsToSelector:@selector(ChooseDataWithType:Tag:Value:)]) {
                    [self.delegate ChooseDataWithType:_lType Tag:_lTag Value:[[_loanRateValuesArray objectAtIndex:indexPath.row] floatValue]];
                }
            }else{
                if ([self.delegate respondsToSelector:@selector(ChooseDataWithType:Tag:Value:)]) {
                    [self.delegate ChooseDataWithType:_lType Tag:_lTag Value:[[[_loanRateArray objectAtIndex:indexPath.row]objectForKey:@"value"] floatValue]];
                }
            }
            
            
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"行号:%d %s Error ＝%@", __LINE__, __func__ ,exception);
    }
    @finally {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
