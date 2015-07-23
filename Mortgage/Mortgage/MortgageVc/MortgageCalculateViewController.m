//
//  MortgageCalculateViewController.m
//  Mortgage
//
//  Created by BobAngus on 15/7/14.
//  Copyright (c) 2015年 Bob Angus. All rights reserved.
//

#define LNUMBERS @"0123456789.\n"
#define LNUMBER @"0123456789\n"
#import "MortgageCalculateViewController.h"
#import "ChooseDataViewController.h"
#import "BankRefundService.h"
#import "ComputedResultViewController.h"
#import "SVProgressHUD.h"

@interface MortgageCalculateViewController ()<UIScrollViewDelegate,ChooseDataDelegate>

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UIScrollView *lmainScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *lscrollView;
@property (strong, nonatomic) IBOutlet UIView *lLoanView;

@property (strong, nonatomic) IBOutlet UIView *mortgageView;
@property (strong, nonatomic) IBOutlet UIView *compositionView;
@property (strong, nonatomic) IBOutlet UIView *revenueView;
@property (strong, nonatomic) IBOutlet UIView *cpfView;

@property (strong, nonatomic) IBOutlet UIButton *calculate1Button;
@property (strong, nonatomic) IBOutlet UIButton *calculate2Button;
@property (strong, nonatomic) IBOutlet UIButton *calculate3Button;
@property (strong, nonatomic) IBOutlet UIButton *calculate4Button;

//贷款总额
@property (strong, nonatomic) IBOutlet UITextField *loanTotal1;
@property (strong, nonatomic) IBOutlet UITextField *loanTotal2;
@property (strong, nonatomic) IBOutlet UITextField *loanTotal3;//公积金总额
@property (strong, nonatomic) IBOutlet UITextField *loanTotal4;//商贷总额

//按揭年限
@property (strong, nonatomic) IBOutlet UITextField *mortgageYear1;
@property (strong, nonatomic) IBOutlet UITextField *mortgageYear2;
@property (strong, nonatomic) IBOutlet UITextField *mortgageYear3;

//贷款利率
@property (strong, nonatomic) IBOutlet UITextField *loanRate1;
@property (strong, nonatomic) IBOutlet UITextField *loanRate2;
@property (strong, nonatomic) IBOutlet UITextField *loanRate3;//公积金利率
@property (strong, nonatomic) IBOutlet UITextField *loanRate4;//商贷利率

@property (strong, nonatomic) IBOutlet UITextField *areaText;
@property (strong, nonatomic) IBOutlet UITextField *priceText;

@property (assign, nonatomic) int loanMethod;       //贷款方式
@property (assign, nonatomic) int paymentMethod;    //还款方式

@property (strong, nonatomic) NSDictionary *lhttpLoanRate;

//@property (assign, nonatomic) int loanTotal;        //贷款总额
//@property (assign, nonatomic) float loanRate;       //贷款利率
//@property (assign, nonatomic) int loanTotal2;        //贷款总额
//@property (assign, nonatomic) float loanRate2;       //贷款利率

//商贷利率
@property (assign, nonatomic) float commercialInterestRate;
//公积金利率
@property (assign, nonatomic) float providentFundInterestRate;
@property (strong, nonatomic) NSMutableDictionary *lListLoan;
@end

@implementation MortgageCalculateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _commercialInterestRate = 5.40;
    _providentFundInterestRate = 3.50;
    [NSThread detachNewThreadSelector:@selector(getLoanRate) toTarget:self withObject:nil];
     _loanMethod = 1;
    _paymentMethod = 1;
//    贷款年限
    _mortgageYear1.text = @"20年(240期)";
    _mortgageYear1.placeholder = @"20";
    _mortgageYear2.text = @"20年(240期)";
    _mortgageYear2.placeholder = @"20";
    _mortgageYear3.text = @"20年(240期)";
    _mortgageYear3.placeholder = @"20";
    

    _lListLoan = [[NSMutableDictionary alloc]initWithCapacity:0];
    [_lListLoan setObject:@"" forKey:@""];
    
    _loanRate1.text = [NSString stringWithFormat:@"%.3f",_commercialInterestRate];
    _loanRate2.text = [NSString stringWithFormat:@"%.3f",_providentFundInterestRate];
    _loanRate3.text = [NSString stringWithFormat:@"%.3f",_providentFundInterestRate];;
    _loanRate4.text = [NSString stringWithFormat:@"%.3f",_commercialInterestRate];
    [self initViews];
}

-(void)initViews{
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"房贷计算",@"税费计算",nil];
    _segmentedControl = [[UISegmentedControl alloc]
                                            initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(0.0, 0.0, 260, 30.0);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor redColor];
    [_segmentedControl addTarget:self
                         action:@selector(indexDidChangeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:_segmentedControl];
 
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backImage_n"]
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(clickLeftButton)];
    leftButton.tintColor = [UIColor grayColor];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    _lmainScrollView.showsHorizontalScrollIndicator = NO;
    _lmainScrollView.frame = CGRectMake(0, 66,
                                        CGRectGetWidth(self.view.frame),
                                        CGRectGetHeight(self.view.frame) - 66);
    _lmainScrollView.delegate = self;
    _lmainScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 2, 0);
    _lmainScrollView.pagingEnabled = YES;
//    房贷计算器
    _compositionView.frame = CGRectMake(0,0,
                                        CGRectGetWidth([UIScreen mainScreen].bounds),
                                        CGRectGetHeight(_lmainScrollView.frame));
    _cpfView.frame = CGRectMake(0,0,
                                CGRectGetWidth([UIScreen mainScreen].bounds),
                                CGRectGetHeight(_lmainScrollView.frame));
    _mortgageView.frame = CGRectMake(0,0,
                                     CGRectGetWidth([UIScreen mainScreen].bounds),
                                     CGRectGetHeight(_lmainScrollView.frame));
    [self.lscrollView addSubview:_compositionView];
    [self.lscrollView addSubview:_cpfView];
    [self.lscrollView addSubview:_mortgageView];
    
    
    _calculate1Button.layer.cornerRadius = 5;
    _calculate2Button.layer.cornerRadius = 5;
    _calculate3Button.layer.cornerRadius = 5;
    _calculate4Button.layer.cornerRadius = 5;
    
//  税费计算器
    _revenueView.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds),0,
                                       CGRectGetWidth([UIScreen mainScreen].bounds),
                                       CGRectGetHeight(_lmainScrollView.frame));
    [_lmainScrollView addSubview:_revenueView];
}

-(void)clickLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)indexDidChangeForSegmentedControl:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    [self.view endEditing:YES];
    [_lmainScrollView setContentOffset:CGPointMake((int)segmentedControl.selectedSegmentIndex * CGRectGetWidth([UIScreen mainScreen].bounds), 0) animated:YES];
}


#pragma mark - UICollectionView Protocol
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(scrollView.contentSize.width - self.view.frame.size.width ) >= 1){
        int index = fabs((int)scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
        _segmentedControl.selectedSegmentIndex = index;
        [self.view endEditing:YES];
    }
}

#pragma mark- 贷款方式 1+
- (IBAction)loanAction:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    [self selectNumber:(int)tempButton.tag];
    
}

-(void)selectNumber:(int)tagNum{
    _mortgageView.hidden = YES;
    _cpfView.hidden = YES;
    _compositionView.hidden = YES;
    for (UIButton *tempBut in self.lLoanView.subviews) {
        if ([tempBut isKindOfClass:[UIButton class]]) {
            if (tempBut.tag < 10) {
                if (tempBut.tag != tagNum) {
                    [tempBut setBackgroundImage:[UIImage imageNamed:@"topitem_n"]
                                       forState:UIControlStateNormal];
                    
                }else{
                    [tempBut setBackgroundImage:[UIImage imageNamed:@"topitem_p"]
                                       forState:UIControlStateNormal];
                }
            }
        }
    }
    
    switch (tagNum) {
        case 1:
            _mortgageView.hidden = NO;
            _loanMethod = 1;
            break;
        case 2:
            _cpfView.hidden = NO;
            _loanMethod = 2;
            break;
        case 3:
            _compositionView.hidden = NO;
            _loanMethod = 3;
            break;
        default:
            break;
    }
}

#pragma mark - 还款方式 10+
- (IBAction)paymentMethodAction:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    _paymentMethod = (int)tempButton.tag - 10;
    for (UIButton *tempBut in self.lLoanView.subviews) {
        if ([tempBut isKindOfClass:[UIButton class]]) {
            if (tempBut.tag > 10 && tempBut.tag < 20) {
                if (tempBut.tag != tempButton.tag) {
                    [tempBut setImage:[UIImage imageNamed:@"radioImage_n"]
                                       forState:UIControlStateNormal];
                }else{
                    [tempBut setImage:[UIImage imageNamed:@"radioImage_p"]
                                       forState:UIControlStateNormal];
                }
            }
        }
    }
}

#pragma mark - 按揭年限 30+
- (IBAction)mortgageYearAction:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    ChooseDataViewController *chooseDataVc = [[ChooseDataViewController alloc]
                                              initWithNibName:@"ChooseDataViewController" bundle:nil Type:1 Tag:(int)tempButton.tag - 30 Values:nil];
    chooseDataVc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseDataVc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 按揭利率 40+
- (IBAction)loanRateAction:(id)sender {
    @try {
        UIButton *tempButton = (UIButton *)sender;
        if (_lhttpLoanRate) {
            NSArray *tempArray = [[_lhttpLoanRate objectForKey:@"Data"]objectForKey:@"ListLoan"];
            if (tempArray.count > 0) {
                ChooseDataViewController *chooseDataVc = [[ChooseDataViewController alloc]
                                                          initWithNibName:@"ChooseDataViewController" bundle:nil Type:2 Tag:(int)tempButton.tag - 40 Values:tempArray];
                chooseDataVc.delegate = self;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseDataVc];
                [self presentViewController:nav animated:YES completion:nil];
                return;
            }
        }
        ChooseDataViewController *chooseDataVc = [[ChooseDataViewController alloc]
                                                  initWithNibName:@"ChooseDataViewController" bundle:nil Type:2 Tag:(int)tempButton.tag - 40 Values:nil];
        chooseDataVc.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:chooseDataVc];
        [self presentViewController:nav animated:YES completion:nil];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"行号:%d %s Error ＝%@", __LINE__, __func__ ,exception);
    }
    @finally {
        
    }
}

-(void)ChooseDataWithType:(int)type Tag:(int)tag Value:(float)value{
    if (type == 1) {
        if (tag == 1){
            _mortgageYear1.text = [NSString stringWithFormat:@"%d年 (%d期)",(int)value,(int)value*12];
            _mortgageYear1.placeholder = [NSString stringWithFormat:@"%d",(int)value];
        }else if (tag == 2){
            _mortgageYear2.text = [NSString stringWithFormat:@"%d年 (%d期)",(int)value,(int)value*12];
            _mortgageYear2.placeholder = [NSString stringWithFormat:@"%d",(int)value];
        }else if (tag == 3){
            _mortgageYear3.text = [NSString stringWithFormat:@"%d年 (%d期)",(int)value,(int)value*12];
            _mortgageYear3.placeholder = [NSString stringWithFormat:@"%d",(int)value];
        }
    }else{
        if (tag == 1){
            _loanRate1.text = [NSString stringWithFormat:@"%.3f",value];
        }else if (tag == 2){
            _loanRate2.text = [NSString stringWithFormat:@"%.3f",value];
        }else if (tag == 3){
            _loanRate4.text = [NSString stringWithFormat:@"%.3f",value];
        }
    }
}

#pragma mark - 开始计算 90+
- (IBAction)calculateAction:(id)sender {
    @try {
        
        UIButton *tempButton = (UIButton *)sender;
        int tempTag = (int)tempButton.tag - 90;
        if (tempTag == 1) {
            NSString *tempLoanTota = _loanTotal1.text;
            if ((int) tempLoanTota <= 0 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写贷款总额"];
                return;
            }
            NSString *tempMortgageYear = _mortgageYear1.placeholder;
            if ((int)tempMortgageYear < 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择按揭年限"];
                return;
            }
            NSString *tempLoanRate = [NSString stringWithFormat:@"%.3f",[_loanRate1.text floatValue]];
            if ([tempLoanRate floatValue] < 0 && [tempLoanRate floatValue] > 10 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写正确的利率"];
                return;
            }
            tempLoanTota = [tempLoanTota stringByAppendingString:@"0000"];
            
            NSArray *tempArray ; //结果参数Array
            if (_paymentMethod == 1) { //等额本金
                float monthInterest = [BankRefundService interest:[tempLoanTota intValue]
                                                             rate:[tempLoanRate floatValue]
                                                             year:[tempMortgageYear intValue]];
                NSLog(@"monthInterest = %f",monthInterest);
                NSString *tempRental = [NSString stringWithFormat:@"%f",monthInterest * ([tempMortgageYear intValue] * 12)];
                NSString *tempInterest = [NSString stringWithFormat:@"%f",[tempRental floatValue] - [tempLoanTota floatValue]];
                tempArray = [[NSArray alloc]initWithObjects:@"等额本息",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTota]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempRental]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             [NSString stringWithFormat:@"%.2f",monthInterest], nil];
                
                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:1 PaymentMethod:1 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
            }else{
                NSMutableArray *tempArray1 = [BankRefundService principal:[tempLoanTota intValue]
                                                                     rate:[tempLoanRate floatValue]
                                                                     year:[tempMortgageYear intValue]];
                float tempRental = 0;
                for (int i = 0; i < tempArray1.count; i++) {
                    tempRental += [[tempArray1 objectAtIndex:i] floatValue];
                }
                
                NSString *tempInterest = [NSString stringWithFormat:@"%f",tempRental - [tempLoanTota floatValue]];
                
                tempArray = [[NSArray alloc]initWithObjects:@"等额本金",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTota]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:[NSString stringWithFormat:@"%f",tempRental]]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             tempArray1, nil];
                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:1 PaymentMethod:2 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
                
            }
        }else if (tempTag == 2){
            
            NSString *tempLoanTota = _loanTotal2.text;
            if ((int) tempLoanTota <= 0 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写贷款总额"];
                return;
            }
            NSString *tempMortgageYear = _mortgageYear2.placeholder;
            if ((int)tempMortgageYear < 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择按揭年限"];
                return;
            }
            NSString *tempLoanRate = [NSString stringWithFormat:@"%.3f",[_loanRate2.text floatValue]];
            if ([tempLoanRate floatValue] < 0 && [tempLoanRate floatValue] > 10 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写正确的利率"];
                return;
            }
            tempLoanTota = [tempLoanTota stringByAppendingString:@"0000"];
            
            NSArray *tempArray ;
            if (_paymentMethod == 1) { //等额本金
                float monthInterest = [BankRefundService interest:[tempLoanTota intValue]
                                                             rate:[tempLoanRate floatValue]
                                                             year:[tempMortgageYear intValue]];
                NSLog(@"monthInterest = %f",monthInterest);
                NSString *tempRental = [NSString stringWithFormat:@"%f",monthInterest * ([tempMortgageYear intValue] * 12)];
                NSString *tempInterest = [NSString stringWithFormat:@"%f",[tempRental floatValue] - [tempLoanTota floatValue]];
                tempArray = [[NSArray alloc]initWithObjects:@"等额本息",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTota]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempRental]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             [NSString stringWithFormat:@"%.2f",monthInterest], nil];
                
                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:2 PaymentMethod:1 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
            }else{
                NSMutableArray *tempArray1 = [BankRefundService principal:[tempLoanTota intValue]
                                                                     rate:[tempLoanRate floatValue]
                                                                     year:[tempMortgageYear intValue]];
                float tempRental = 0;
                for (int i = 0; i < tempArray1.count; i++) {
                    tempRental += [[tempArray1 objectAtIndex:i] floatValue];
                }
                
                NSString *tempInterest = [NSString stringWithFormat:@"%f",tempRental - [tempLoanTota floatValue]];
                
                tempArray = [[NSArray alloc]initWithObjects:@"等额本金",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTota]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:[NSString stringWithFormat:@"%f",tempRental]]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             tempArray1, nil];
                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:2 PaymentMethod:2 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
                
            }
        }else if (tempTag == 3){
            NSString *tempLoanTota1 = _loanTotal3.text;
            if ((int) tempLoanTota1 <= 0 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写公积金贷款总额"];
                return;
            }
            
            NSString *tempLoanTota2 = _loanTotal4.text;
            if ((int) tempLoanTota2 <= 0 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写商业贷款总额"];
                return;
            }
            
            NSString *tempMortgageYear = _mortgageYear3.placeholder;
            if ((int)tempMortgageYear < 0) {
                [SVProgressHUD showErrorWithStatus:@"请选择按揭年限"];
                return;
            }
            
            NSString *tempLoanRate1 = [NSString stringWithFormat:@"%.3f",[_loanRate3.text floatValue]];
            if ([tempLoanRate1 floatValue] < 0 && [tempLoanRate1 floatValue] > 10 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写正确的公积金利率"];
            }
            NSString *tempLoanRate2 = [NSString stringWithFormat:@"%.3f",[_loanRate4.text floatValue]];
            if ([tempLoanRate2 floatValue] < 0 && [tempLoanRate2 floatValue] > 10 ) {
                [SVProgressHUD showErrorWithStatus:@"请填写正确的商业贷款利率"];
            }
            tempLoanTota1 = [tempLoanTota1 stringByAppendingString:@"0000"];
            tempLoanTota2 = [tempLoanTota2 stringByAppendingString:@"0000"];
            
            
            NSArray *tempArray ;
            if (_paymentMethod == 1) { //等额本金
  
                float monthInterest =  [BankRefundService loanPortfolioInterest:[tempLoanTota1 intValue]
                                                                    stotalMoney:[tempLoanTota2 intValue]
                                                                          grate:[tempLoanRate1 floatValue]
                                                                          srate:[tempLoanRate2 floatValue]
                                                                           year:[tempMortgageYear intValue]];
                
                NSString *tempRental = [NSString stringWithFormat:@"%f",monthInterest * ([tempMortgageYear intValue] * 12)];
//                贷款总额
                NSString *tempLoanTotaSum = [NSString stringWithFormat:@"%d",[tempLoanTota1 intValue] + [tempLoanTota2 intValue]];
//                
                NSString *tempInterest = [NSString stringWithFormat:@"%f",[tempRental floatValue] - [tempLoanTotaSum floatValue]];
                tempArray = [[NSArray alloc]initWithObjects:@"等额本息",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTotaSum]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate1],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate2],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempRental]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             [NSString stringWithFormat:@"%.2f",monthInterest], nil];
                
                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:3 PaymentMethod:3 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
            }else{
                NSArray *tempArray1 =  [BankRefundService loanPortfolioPrincipal:[tempLoanTota1 intValue]
                                                                            stotalMoney:[tempLoanTota2 intValue]
                                                                                  grate:[tempLoanRate1 floatValue]
                                                                                  srate:[tempLoanRate2 floatValue]
                                                                                   year:[tempMortgageYear intValue]];

                float tempRental = 0;
                for (int i = 0; i < tempArray1.count; i++) {
                    tempRental += [[tempArray1 objectAtIndex:i] floatValue];
                }
//                贷款总额
                NSString *tempLoanTotaSum = [NSString stringWithFormat:@"%d",[tempLoanTota1 intValue] + [tempLoanTota2 intValue]];
                
                NSString *tempInterest = [NSString stringWithFormat:@"%f",tempRental - [tempLoanTotaSum floatValue]];
                tempArray = [[NSArray alloc]initWithObjects:@"等额本金",
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempLoanTotaSum]],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate1],
                             [NSString stringWithFormat:@"%@%%",tempLoanRate2],
                             [NSString stringWithFormat:@"%d年 (%d期)",[tempMortgageYear intValue],
                              [tempMortgageYear intValue]*12],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:[NSString stringWithFormat:@"%.2f",tempRental]]],
                             [NSString stringWithFormat:@"%@元",[self strmethodComma:tempInterest]],
                             tempArray1, nil];

                ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                                  initWithNibName:@"ComputedResultViewController" bundle:nil Type:3 PaymentMethod:4 ValuesDic:tempArray];
                [self.navigationController pushViewController:computedResultVc animated:YES];
            }
        }else if (tempTag == 4){
//            公证费：标的额500000元以下部分,收取比例为0.3%,按比例收费不到200元的,按200元收取;   200元
//            契税：
//            1、成交价*1%，90平方米以下的普通住宅，若买方不是唯一住房的按成交价3%征收。
//            2、成交价*1.5%，90平方米以上，144平方米以下普通住宅，若查实买方不是唯一住房的按成交价3%征收。
//            3、成交价*3%，（144平米以上含144平米）
//            印花税：成交价*0.05%
            int tempAreaText = [_areaText.text intValue];
            int tempPriceText = [_priceText.text intValue];
            
            if (tempPriceText <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请填写单价"];
                return;
            }
            
            if (tempAreaText <= 0) {
                [SVProgressHUD showErrorWithStatus:@"请填写面积"];
                return;
            }
            
            float totalPrice = tempPriceText * tempAreaText; //总价
            float deedTax = 0;  //契税
            float stampDuty = totalPrice * 0.005;   //印花税
            
            if (tempAreaText > 0 && tempAreaText <= 90){
                deedTax = totalPrice * 0.01;
            }else if (tempAreaText > 90 && tempAreaText < 144){
                deedTax = totalPrice * 0.15;
            }else if (tempAreaText > 144){
                deedTax = totalPrice * 0.3;
            }
//            @"房屋总价",@"契税",@"印花税",@"公证费",@"税费总额"
            NSArray *tempArray = [[NSArray alloc]initWithObjects:
                                  [NSString stringWithFormat:@"%@元",[self strmethodComma:[NSString stringWithFormat:@"%.2f",totalPrice]]],
                         [NSString stringWithFormat:@"%.2f元",deedTax],
                         [NSString stringWithFormat:@"%.2f元",stampDuty],
                         [NSString stringWithFormat:@"200元"],
                         [NSString stringWithFormat:@"%.2f元",deedTax+stampDuty+200], nil];
            
            ComputedResultViewController *computedResultVc = [[ComputedResultViewController alloc]
                                                              initWithNibName:@"ComputedResultViewController" bundle:nil Type:4 PaymentMethod:5 ValuesDic:tempArray];
            [self.navigationController pushViewController:computedResultVc animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"行号:%d %s Error ＝%@", __LINE__, __func__ ,exception);
    }
    @finally {
        
    }
}



- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}


//金额格式化
-(NSString *)strmethodComma:(NSString *)number{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundDown;
    
    number = [NSString stringWithFormat:@"%.0f",[number doubleValue]];
    if([number doubleValue] == -0){
        return  @"0.00";
    }
    NSNumber *numberF = [NSNumber numberWithDouble:[number doubleValue]];
    NSString *rstring = [formatter stringFromNumber:numberF];
    rstring = [rstring substringWithRange:NSMakeRange(1,rstring.length-1)];
    return rstring;
}

#pragma mark - 过滤非法字符
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _loanRate1 || textField == _loanRate2 || textField == _loanRate3 || textField == _loanRate4) {
        if (![self isValidateNumber:string Type:1]) {
            [SVProgressHUD showErrorWithStatus:@"请输入数字!"];
            return NO;
        }
    }else{
        if (![self isValidateNumber:string Type:2]) {
            [SVProgressHUD showErrorWithStatus:@"请输入数字!"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 验证输入是否为数字
- (BOOL)isValidateNumber:(NSString *)number Type:(int)type{
    NSCharacterSet *cs;
    if (type == 1) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:LNUMBERS] invertedSet];
    }else{
        cs = [[NSCharacterSet characterSetWithCharactersInString:LNUMBER] invertedSet];
    }
    NSString *filtered = [[number componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [number isEqualToString:filtered];
    if(!basicTest)
    {
        return NO;
    }
    return YES;
}

#pragma mark - 键盘管理
- (void)keyboardWillShow:(NSNotification *)noti
{
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    CGRect rect = CGRectMake(0.0f, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}


-(void)getLoanRate
{
    @try {
        [SVProgressHUD showInfoWithStatus:@"正在请求利率数据,请稍后..."];
        NSString *URL = @"http://10.5.0.11/Tools/caculator.json";//appleid
        NSError *error = nil;
        NSString *results = [[NSString alloc]initWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *dic = [self jsonStringToDictionary:results];
        [SVProgressHUD dismiss];
        if (dic) {
            _lhttpLoanRate = dic;
            NSDictionary *tempData = [_lhttpLoanRate objectForKey:@"Data"];
            _commercialInterestRate = [[tempData objectForKey:@"BusinessLoan"] floatValue];
            _providentFundInterestRate = [[tempData objectForKey:@"AccumulationLoan"] floatValue];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"行号:%d %s Error ＝%@", __LINE__, __func__ ,exception);
    }
    @finally {
        
    }
}

- (NSMutableDictionary *)jsonStringToDictionary:(NSString *)parameter
{
    NSData *strData = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:strData options:NSJSONReadingMutableLeaves error:&error];
    return dict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
