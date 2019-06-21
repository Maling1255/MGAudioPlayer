//
//  NSArray+Extension.m
//  Player
//
//  Created by maling on 2019/6/21.
//  Copyright © 2019 maling. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * mutString = [NSMutableString stringWithString:@"\n[\n"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mutString appendFormat:@"\t%@\n",obj];
    }];
    [mutString stringByAppendingString:@"]\n"];
    return  mutString.copy;
}

@end


@implementation NSDictionary (Extension)


- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString * mutString = [NSMutableString stringWithString:@"\n{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [mutString appendFormat:@"\t%@ = %@\n",key,obj];
    }];
    [mutString stringByAppendingString:@"\n}\n"];
    return  mutString.copy;
}

@end
