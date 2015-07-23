//
//  ComputedResultViewController.m
//  Mortgage
//
//  Created by BobAngus on 15/7/14.
//  Copyright (c) 2015年 Bob Angus. All rights reserved.
//

#import "ComputedResultViewController.h"

@interface ComputedResultViewController ()

@property (nonatomic, strong) NSMutableArray *ltitlesArray;
@property (nonatomic, strong) NSMutableArray *lvaluesArray;

@property (assign, nonatomic) int lType;
@property (assign, nonatomic) int lPaymentMethod;
//是否展开
@property (assign, nonatomic) BOOL lUnfold;
@property (nonatomic, strong) NSArray *lvaluesDic;

@property (strong, nonatomic) IBOutlet UITableView *lmainTable;
@end

@implementation ComputedResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_lType == 1) {
        self.title = @"商业贷款计算结果";
    }else if (_lType == 2){
        self.title = @"公积金贷款计算结果";
    }else if (_lType == 3){
        self.title = @"组合贷款计算结果";
    }else if (_lType == 4){
        self.title = @"税费计算结果";
    }
    _lUnfold = NO;
    [self initViews];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(int)type PaymentMethod:(int)paymentMethod ValuesDic:(NSArray *)valuesDic{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _lType = type;
        _lvaluesDic = valuesDic;
        _lPaymentMethod = paymentMethod;
    }
    return self;
}

-(void)initViews{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backImage_n"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(clickLeftButton)];
    leftButton.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    _lmainTable.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    if (_lPaymentMethod == 1) {
        _ltitlesArray = [[NSMutableArray alloc]initWithObjects:@"还款方式",@"贷款总额",@"贷款利率",@"按揭年限",@"还款总额",@"支付利息",@"月均还款", nil];
    }else if (_lPaymentMethod == 2){
        _ltitlesArray = [[NSMutableArray alloc]initWithObjects:@"还款方式",@"贷款总额",@"贷款利率",@"按揭年限",@"还款总额",@"支付利息",@"首月还款",@"末月还款", nil];
    }else if (_lPaymentMethod == 3){
        _ltitlesArray = [[NSMutableArray alloc]initWithObjects:@"还款方式",@"贷款总额",@"公积金贷款利率",@"商业贷款利率",@"按揭年限",@"还款总额",@"支付利息",@"月均还款", nil];
    }else if (_lPaymentMethod == 4){
        _ltitlesArray = [[NSMutableArray alloc]initWithObjects:@"还款方式",@"贷款总额",@"公积金贷款利率",@"商业贷款利率",@"按揭年限",@"还款总额",@"支付利息",@"月均还款",@"末月还款", nil];
    }else if (_lPaymentMethod == 5){
        _ltitlesArray = [[NSMutableArray alloc]initWithObjects:@"房屋总价",@"契税",@"印花税",@"公证费",@"税费总额", nil];
    }
    
    _lmainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)clickLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView 相关

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_lUnfold) {
        if (_lPaymentMethod == 1 || _lPaymentMethod == 2) {
            if ([[_lvaluesDic objectAtIndex:6] isKindOfClass:[NSMutableArray class]]) {
                NSArray *tempArray = [_lvaluesDic objectAtIndex:6];
                return _ltitlesArray.count + tempArray.count - 1;
            }else{
                return 0;
            }
        }else if (_lPaymentMethod == 3 || _lPaymentMethod == 4){
            if ([[_lvaluesDic objectAtIndex:7] isKindOfClass:[NSMutableArray class]]) {
                NSArray *tempArray = [_lvaluesDic objectAtIndex:7];
                return _ltitlesArray.count + tempArray.count - 1;
            }else{
                return 0;
            }
        }else{
            return 0;
        }
    }else{
        return _ltitlesArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
//    title
    if (_lUnfold) {
        if (indexPath.row < _ltitlesArray.count -1) {
            cell.textLabel.text = [_ltitlesArray objectAtIndex:indexPath.row];
        }else{
            if (_lPaymentMethod == 1 || _lPaymentMethod == 2) {
                cell.textLabel.text = [NSString stringWithFormat:@"第%d期",(int)indexPath.row - 6 ];
            }else if (_lPaymentMethod == 3 || _lPaymentMethod == 4){
                cell.textLabel.text = [NSString stringWithFormat:@"第%d期",(int)indexPath.row - 7 ];
            }
        }
    }else{
        cell.textLabel.text = [_ltitlesArray objectAtIndex:indexPath.row];
    }
//    values
    if (_lPaymentMethod == 1 || _lPaymentMethod == 2) {
        if (_lUnfold) {
            if (indexPath.row < 6) {
                cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
            }else if (indexPath.row == 6) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 26, 44)];
                    tempLabel.textAlignment = NSTextAlignmentRight;
                    tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                    tempLabel.font = [UIFont systemFontOfSize:15];
                    tempLabel.text = [[_lvaluesDic objectAtIndex:indexPath.row] objectAtIndex:0];
                    [cell.contentView addSubview:tempLabel];
                    
                    UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_lmainTable.frame) - 20, 20, 12, 7)];
                    tempImage.image = [UIImage imageNamed:@"chooseDown_n"];
                    [cell.contentView addSubview:tempImage];
                }
            }else{
                NSArray *tempArray = [_lvaluesDic objectAtIndex:6];
                cell.detailTextLabel.text = [tempArray objectAtIndex:indexPath.row - 7];
            }
        }else{
            if (indexPath.row == 6) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 26, 44)];
                    tempLabel.textAlignment = NSTextAlignmentRight;
                    tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                    tempLabel.font = [UIFont systemFontOfSize:15];
                    tempLabel.text = [[_lvaluesDic objectAtIndex:indexPath.row] objectAtIndex:0];
                    [cell.contentView addSubview:tempLabel];
                    
                    UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_lmainTable.frame) - 20, 20, 12, 7)];
                    tempImage.image = [UIImage imageNamed:@"chooseDown_n"];
                    [cell.contentView addSubview:tempImage];
                }else{
                    cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
                }
            }else if (indexPath.row == 7){
                if ([[_lvaluesDic objectAtIndex:indexPath.row-1] isKindOfClass:[NSMutableArray class]]) {
                    NSMutableArray *tempArray = [_lvaluesDic objectAtIndex:indexPath.row-1];
                    cell.detailTextLabel.text = [tempArray objectAtIndex:tempArray.count - 1];
                }
            }else{
                cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
            }
        }
        
    }else if (_lPaymentMethod == 3 || _lPaymentMethod == 4){
        if (_lUnfold) {
            if (indexPath.row < 7) {
                cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
            }else if (indexPath.row == 7) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 26, 44)];
                    tempLabel.textAlignment = NSTextAlignmentRight;
                    tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                    tempLabel.font = [UIFont systemFontOfSize:15];
                    tempLabel.text = [[_lvaluesDic objectAtIndex:indexPath.row] objectAtIndex:0];
                    [cell.contentView addSubview:tempLabel];
                    
                    UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_lmainTable.frame) - 20, 20, 12, 7)];
                    tempImage.image = [UIImage imageNamed:@"chooseDown_n"];
                    [cell.contentView addSubview:tempImage];
                }else{
                    cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
                }
            }else{
                NSArray *tempArray = [_lvaluesDic objectAtIndex:7];
                cell.detailTextLabel.text = [tempArray objectAtIndex:indexPath.row - 8];
            }
        }else{
            if (indexPath.row == 7) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - 26, 44)];
                    tempLabel.textAlignment = NSTextAlignmentRight;
                    tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
                    tempLabel.font = [UIFont systemFontOfSize:15];
                    tempLabel.text = [[_lvaluesDic objectAtIndex:indexPath.row] objectAtIndex:0];
                    [cell.contentView addSubview:tempLabel];
                    
                    UIImageView *tempImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_lmainTable.frame) - 20, 20, 12, 7)];
                    tempImage.image = [UIImage imageNamed:@"chooseDown_n"];
                    [cell.contentView addSubview:tempImage];
                }else{
                    cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
                }
            }else if (indexPath.row == 8){
                if ([[_lvaluesDic objectAtIndex:indexPath.row-1] isKindOfClass:[NSMutableArray class]]) {
                    NSMutableArray *tempArray = [_lvaluesDic objectAtIndex:indexPath.row-1];
                    cell.detailTextLabel.text = [tempArray objectAtIndex:tempArray.count - 1];
                }
            }else{
                cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
            }
        }
    }else if (_lPaymentMethod == 5){
        cell.detailTextLabel.text = [_lvaluesDic objectAtIndex:indexPath.row];
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 18;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *bgViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 500)];
    bgViews.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    tempLabel.font = [UIFont systemFontOfSize:15];
    tempLabel.text = @"* 以上计算结果仅供参考";
    [bgViews addSubview:tempLabel];
    return bgViews;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (_lPaymentMethod == 1 || _lPaymentMethod == 2) {
            if (indexPath.row == 6) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    NSLog(@"1111");
                    if (_lUnfold) {
                        _lUnfold = NO;
                    }else{
                        _lUnfold = YES;
                    }
                    [_lmainTable reloadData];
                }
            }
        }else if (_lPaymentMethod == 3 || _lPaymentMethod == 4){
            if (indexPath.row == 7) {
                if ([[_lvaluesDic objectAtIndex:indexPath.row] isKindOfClass:[NSMutableArray class]]) {
                    NSLog(@"2222");
                    if (_lUnfold) {
                        _lUnfold = NO;
                    }else{
                        _lUnfold = YES;
                    }
                    [_lmainTable reloadData];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"行号:%d %s Error ＝%@", __LINE__, __func__ ,exception);
    }
    @finally {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
