//
//  AMFuncModel.m
//  Prepare
//
//  Created by GL on 2021/4/4.
//

#import "AMFuncCostModel.h"

@implementation AMFuncCostModel

- (NSString *)desc {
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%2d| ",(int)self.callDepth];
    [str appendFormat:@"%6.2f|",self.timeCost * 1000.0];
    for (NSUInteger i = 0; i < self.callDepth; i++) {
        [str appendString:@"  "];
    }
    [str appendFormat:@"%s[%@ %@]", (self.isClassMethod ? "+" : "-"), self.className, self.methodName];
    return str;
}

@end
