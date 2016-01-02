//
//  MMSCUtil.m
//  MahjongScoreCalculator
//
//  Created by fredfx on 16/1/2.
//  Copyright © 2016年 fredfx. All rights reserved.
//

#import "MMSCUtil.h"

@implementation MMSCUtil

+ (NSString *)convertToCharacterWithNumber:(NSInteger)number {
    
    static NSArray *unitCharacter;
    static dispatch_once_t unitOnce;
    dispatch_once(&unitOnce, ^{
        unitCharacter = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    });
    
    static NSArray *tenAndHundredCharacter;
    static dispatch_once_t tenAndHundredOnce;
    dispatch_once(&tenAndHundredOnce, ^{
        tenAndHundredCharacter = @[@"十",@"百",@"千",@"万"];
    });
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSInteger tensIndex = 0;
    NSInteger unit = number % 10;
    NSInteger temp = number;
    
    while (temp != 0) {
        temp = temp / 10;
        
        if (unit != 0) {
            
            //0-9
            if (!(tensIndex == 1 && unit == 1 && temp == 0)) {
                [result insertString:unitCharacter[unit - 1] atIndex:0];
            }
            
            unit = temp % 10;
            
            if (temp != 0 && unit != 0) {
                [result insertString:tenAndHundredCharacter[tensIndex] atIndex:0];
            }
            
            tensIndex ++;
        }
    }
    
    return result;
}

@end
