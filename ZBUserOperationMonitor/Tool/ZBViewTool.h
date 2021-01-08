//
//  ZBViewTool.h
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/8.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBViewTool : NSObject
+ (id)getResponderWithView:(UIView *)view className:(NSString *)className;
+ (NSString *)getResponderTree:(UIView *)view;
+ (NSString *)getViewTree:(UIView *)view;
@end

