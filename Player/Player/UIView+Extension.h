//
//  UIView+Extension.h
//  Player
//
//  Created by maling on 2019/6/21.
//  Copyright © 2019 maling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extension)

- (void)layoutSubviewsCenterY:(UIView *)view, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
