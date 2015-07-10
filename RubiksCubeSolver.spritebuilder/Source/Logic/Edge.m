//
//  Edge.m
//  3x3Solver
//
//  Created by Tom on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Edge.h"
typedef NS_ENUM(NSInteger, permutation)
{
    UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR
};

typedef NS_ENUM(NSInteger, color)
{
    none, green, blue, white, yellow, red, orange
};

@implementation Edge
- (instancetype)initWithTargetPermutation:(int)targetPermutation
{
    self = [super init];
    if (!self) return nil;
    self.targetPermutation = targetPermutation;
    switch (targetPermutation) {
        case UR:
            self.colors = @[@(white), @(red)];
            break;
        
        case UF:
            self.colors = @[@(white), @(green)];
            break;
            
        case UL:
            self.colors = @[@(white), @(orange)];
            break;
            
        case UB:
            self.colors = @[@(white), @(blue)];
            break;
            
        case DR:
            self.colors = @[@(yellow), @(red)];
            break;
            
        case DF:
            self.colors = @[@(yellow), @(green)];
            break;
            
        case DL:
            self.colors = @[@(yellow), @(orange)];
            break;
            
        case DB:
            self.colors = @[@(yellow), @(blue)];
            break;
            
        case FR:
            self.colors = @[@(green), @(red)];
            break;
            
        case FL:
            self.colors = @[@(green), @(orange)];
            break;
            
        case BL:
            self.colors = @[@(blue), @(orange)];
            break;
            
        case BR:
            self.colors = @[@(blue), @(red)];
            break;
            
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Edge *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy)
    {
        copy.orientation = self.orientation;
        copy.targetPermutation = self.targetPermutation;
        copy.colors = [self.colors copy];
    }
    
    return copy;
}
@end
