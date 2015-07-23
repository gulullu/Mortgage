//
//  BankRefundService.h
//  Sotao
//
//  Created by liusc on 15/4/17.
//  Copyright (c) 2015年 sotao. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  房贷计算工具类
 */
@interface BankRefundService : NSObject

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
                        year:(int)year;

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
                              year:(int)year;

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
             year:(int)year;

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
                          year:(int)year;

@end
