//
//  UIView+Extension.m
//  Player
//
//  Created by maling on 2019/6/21.
//  Copyright © 2019 maling. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)layoutSubviewsCenterY:(UIView *)view,...
{
    NSMutableArray <UIView *> *array = [NSMutableArray array];
    va_list argList;
     va_start(argList, view);
    id arg;
//    while ((arg = va_arg(argList, UIView *)))
    for (UIView *tempView = view; tempView != nil; tempView = va_arg(argList, UIView *))
    {
        [array addObject:tempView];
    }
    va_end(argList);
    
    NSLog(@"LLL %ld", array.count);
    
    
    for (UIView *subviews in array) {
        NSLog(@"subviews %@", subviews);
    }
    
    UIView *firstView = array.firstObject;
    CGFloat mintop = firstView.frame.origin.y;
    
    UIView *lastView = array.lastObject;
    CGFloat maxBottom = lastView.frame.origin.y + lastView.frame.size.height;
    
   CGFloat y =  (self.frame.size.height - (maxBottom - mintop))*0.5;
    
    CGRect firstFrame = firstView.frame;
    firstFrame.origin.y = y;
    firstView.frame = firstFrame;
    
    
    
}

@end
