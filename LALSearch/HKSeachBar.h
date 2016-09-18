//
//  HKSeachBar.h
//  阿甘汇客
//
//  Created by 卢安林 on 16/9/7.
//  Copyright © 2016年 YHH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSeachBar : UISearchBar
@property (strong, nonatomic) UITextField *searchTextField;

-(id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder;
@end
