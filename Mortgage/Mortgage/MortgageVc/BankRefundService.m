//
//  BankRefundService.m
//  Sotao
//
//  Created by liusc on 15/4/17.
//  Copyright (c) 2015年 sotao. All rights reserved.
//

#import "BankRefundService.h"
#include <math.h>

@implementation BankRefundService

/**
 *  等额本金还款法（利息少，前期还款多）
 *
 *  @param totalMoney 贷款总额
 *  @param rate       贷款利率
 *  @param year       贷款年限
 *
 *  @return 每期还款数集合
 */
+ (NSMutableArray*)principal:(float)totalMoney
                        rate:(float)rate
                        year:(int)year
{
    int totalMonth = year * 12;
    //每月本金
    float monthPri = totalMoney / totalMonth;
    
    float monthRate = [[NSString stringWithFormat:@"%.6f", [self resMonthRate:rate]] floatValue];
    
    NSMutableArray *monthMoneys = [[NSMutableArray alloc] init];
    
    for (int index = 1; index <= totalMonth; index++) {
        double monthRes = monthPri + (totalMoney - monthPri * (index - 1)) * monthRate;
        [monthMoneys addObject:[NSString stringWithFormat:@"%.2f", monthRes]];
    }
    
    return monthMoneys;
}

/**
 *  组合贷款（等额本金还款方式与公积金贷款组合）
 *
 *  @param gtotalMoney 公积金贷款金额（单位：元）
 *  @param stotalMoney 商业贷款金额（单位：元）
 *  @param grate       公积金贷款利率
 *  @param srate       商业贷款利率
 *  @param year        贷款年限
 *
 *  @return 每期还款数集合
 */
+ (NSArray*)loanPortfolioPrincipal:(float)gtotalMoney
                       stotalMoney:(float)stotalMoney
                             grate:(float)grate
                             srate:(float)srate
                              year:(int)year
{
    NSMutableArray *gmoneys = [self principal:gtotalMoney
                                         rate:grate
                                         year:year];
    
    NSMutableArray *smoneys = [self principal:stotalMoney
                                         rate:srate
                                         year:year];
    
    if((gmoneys != nil
        && gmoneys.count > 0)
       && (smoneys != nil
           && smoneys.count > 0)){
           NSMutableArray *moneys = [[NSMutableArray alloc] init];
           for (int i = 0; i < gmoneys.count; i++) {
               [moneys addObject:[NSString stringWithFormat:@"%.2f", ([gmoneys[i] floatValue] + [smoneys[i] floatValue])]];
           }
           return moneys;
       }
    return nil;
}

/**
 *  等额本息还款法（利息多，每月还款金额相同）
 *
 *  @param totalMoney 贷款总额
 *  @param rate       贷款利率
 *  @param year       贷款年限
 *
 *  @return 每期还款数
 */
+ (float)interest:(float)totalMoney
             rate:(float)rate
             year:(int)year
{
    float monthRate = [self resMonthRate:rate];
    float monthInterest = totalMoney * monthRate
				* pow((1 + monthRate), year * 12)
				/ (pow((1 + monthRate), year * 12) - 1);
    return monthInterest;
}

/**
 *  组合贷款（等额本息与商业贷款组合）
 *
 *  @param gtotalMoney 公积金贷款金额（单位：元）
 *  @param stotalMoney 商业贷款金额（单位：元）
 *  @param grate       公积金贷款利率
 *  @param srate       商业贷款利率
 *  @param year        贷款年限
 *
 *  @return 每期应还款项
 */
+ (float)loanPortfolioInterest:(float)gtotalMoney
                   stotalMoney:(float)stotalMoney
                         grate:(float)grate
                         srate:(float)srate
                          year:(int)year
{
    float gmoInterest = [self interest:gtotalMoney
                                  rate:grate
                                  year:year];
    float smoInterest = [self interest:stotalMoney
                                  rate:srate
                                  year:year];
    return [[NSString stringWithFormat:@"%.2f", gmoInterest + smoInterest] floatValue];
}

+ (float)resMonthRate:(float)rate
{
    return rate/12 * 0.01;
}

@end
