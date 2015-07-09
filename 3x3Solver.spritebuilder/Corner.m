//
//  Corner.m
//  3x3Solver
//
//  Created by Tom on 7/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Corner.h"
#import "Center.h"

typedef NS_ENUM(NSInteger, permutation)
{
    URF, ULF, ULB, URB, DRF, DLF, DLB, DRB
};

typedef NS_ENUM(NSInteger, color)
{
    none, green, blue, white, yellow, red, orange
};

@implementation Corner

- (instancetype)initWithTargetPermutation:(int)targetPermutation
{
    self = [super init];
    if (!self) return nil;
    self.targetPermutation = targetPermutation;
    switch (targetPermutation) {
        case URF:
            self.colors = @[@(white), @(red), @(green)];
            break;
            
        case ULF:
            self.colors = @[@(white), @(green), @(orange)];
            break;
            
        case ULB:
            self.colors = @[@(white), @(orange), @(blue)];
            break;
            
        case URB:
            self.colors = @[@(white), @(blue), @(red)];
            break;
            
        case DRF:
            self.colors = @[@(yellow), @(green), @(red)];
            break;
            
        case DLF:
            self.colors = @[@(yellow), @(orange), @(green)];
            break;
            
        case DLB:
            self.colors = @[@(yellow), @(blue), @(orange)];
            break;
            
        case DRB:
            self.colors = @[@(yellow), @(red), @(blue)];
            break;
    }
    
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    Corner *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy)
    {
        copy.orientation = self.orientation;
        copy.targetPermutation = self.targetPermutation;
        copy.colors = [self.colors copy];
    }
    
    return copy;
}
@end
