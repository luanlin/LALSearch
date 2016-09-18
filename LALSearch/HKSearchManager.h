//
//  HKSearchManager.h
//  阿甘汇客
//
//  Created by 卢安林 on 16/9/9.
//  Copyright © 2016年 YHH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKSearchManager : NSObject
//缓存搜索的数组
+(void)SearchText :(NSString *)seaTxt;
//清除缓存数组
+(void)removeAllArray;
@end
