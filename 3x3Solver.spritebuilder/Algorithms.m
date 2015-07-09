//
//  Algorithms.m
//  3x3Solver
//
//  Created by Tom on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Algorithms.h"
typedef NS_ENUM(NSInteger, edgePermutation)
{
    UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR
};

typedef NS_ENUM(NSInteger, face)
{
    front, back, up, down, right, left
};

typedef NS_ENUM(NSInteger, cornerPermutation)
{
    URF, ULF, ULB, URB, DRF, DLF, DLB, DRB
};

@implementation Algorithms

#pragma mark Permutations
+ (NSArray *)returnTPerm
{
    return @[@"R", @"U", @"R'", @"U'", @"R'", @"F", @"R2", @"U'", @"R'", @"U'", @"R", @"U", @"R'", @"F'"];
}

+ (NSArray *)returnYPerm
{
    return @[@"R'", @"U'", @"R", @"F2", @"R'", @"U", @"R", @"U", @"F2", @"U'", @"F2", @"U'", @"F2"];
}

#pragma mark For Solving Edges
+ (NSArray *)giveSetupMovesForEdgeWithTargetPermutation:(int)permutation withOrientation:(int)orientation
{
    NSArray *setupMoves = @[];
    if (!orientation)
    {
        switch (permutation)
        {
            case UR:
                break;
            case UF:
                setupMoves = @[@"R2", @"U", @"R2"];
                break;
            case UL:
                break;
            case UB:
                setupMoves = @[@"R2", @"U'", @"R2"];
                break;
            case DR:
                setupMoves = @[@"D2", @"L2"];
                break;
            case DF:
                setupMoves = @[@"D'", @"L2"];
                break;
            case DL:
                setupMoves = @[@"L2"];
                break;
            case DB:
                setupMoves = @[@"D", @"L2"];
                break;
            case FR:
                setupMoves = @[@"U2", @"R", @"U2"];
                break;
            case FL:
                setupMoves = @[@"L'"];
                break;
            case BL:
                setupMoves = @[@"L"];
                break;
            case BR:
                setupMoves = @[@"U2", @"R'", @"U2"];
                break;
        }
    }
    else if (orientation)
    {
        switch (permutation)
        {
            case UR:
                break;
            case UF:
                setupMoves = @[@"R", @"F'", @"R'", @"L'"];
                break;
            case UL:
                setupMoves = @[@"U'", @"F'", @"U", @"L'"];
                break;
            case UB:
                setupMoves = @[@"R'", @"B", @"L", @"R"];
                break;
            case DR:
                setupMoves = @[@"D'", @"U'", @"F", @"U", @"L'"];
                break;
            case DF:
                setupMoves = @[@"F", @"L'", @"F'"];
                break;
            case DL:
                setupMoves = @[@"L'", @"U'", @"F", @"U"];
                break;
            case DB:
                setupMoves = @[@"B'", @"L", @"B"];
                break;
            case FR:
                setupMoves = @[@"U'", @"F'", @"U"];
                break;
            case FL:
                setupMoves = @[@"U'", @"F", @"U"];
                break;
            case BL:
                setupMoves = @[@"U", @"B'", @"U'"];
                break;
            case BR:
                setupMoves = @[@"U", @"B", @"U'"];
                break;
        }
    }
    return setupMoves;
}

+ (NSArray *)giveSolveMovesForEdgeWithTargetPermutation:(int)permutation withOrientation:(int)orientation
{
    NSArray *setupMoves = [self giveSetupMovesForEdgeWithTargetPermutation:permutation withOrientation:orientation];
    NSLog(@"Setup:%@", [self giveStringFromMoveStringArray:setupMoves]);
    
    NSArray *TPerm = [self returnTPerm];
    NSLog(@"TPerm:%@", [self giveStringFromMoveStringArray:TPerm]);
    
    NSMutableArray *inversedSetupMoves = [[[setupMoves reverseObjectEnumerator] allObjects] mutableCopy];
    for (int i = 0; i < [inversedSetupMoves count]; i++)
    {
        NSString *move = inversedSetupMoves[i];
        NSString *inversedMove = [self giveInverseMoveForMove:move];
        inversedSetupMoves[i] = inversedMove;
    }
    NSLog(@"Reverse Setup:%@", [self giveStringFromMoveStringArray:inversedSetupMoves]);
    
    NSArray *moves = [[[NSArray arrayWithArray:setupMoves] arrayByAddingObjectsFromArray:TPerm] arrayByAddingObjectsFromArray:inversedSetupMoves];
    return moves;
}

#pragma mark For Solving Corners
+ (NSArray *)giveSetupMovesForCornerWithTargetPermutation:(int)permutation withOrientation:(int)orientation
{
    NSArray *setupMoves = @[];
    if (orientation == 0)
    {
        switch (permutation)
        {
            case ULB:
                break;
            case ULF:
                setupMoves = @[@"U'", @"R'", @"U", @"R"];
                break;
            case URF:
                break;
            case URB:
                setupMoves = @[@"R", @"U'", @"R'", @"U"];
                break;
            case DRF:
                setupMoves = @[@"D'", @"F2"];
                break;
            case DLF:
                setupMoves = @[@"F2"];
                break;
            case DLB:
                setupMoves = @[@"D", @"F2"];
                break;
            case DRB:
                setupMoves = @[@"D2", @"F2"];
                break;
        }
    }
    else if (orientation == 1)
    {
        switch (permutation)
        {
            case ULB:
                break;
            case ULF:
                setupMoves = @[@"F"];
                break;
            case URF:
                setupMoves = @[@"F", @"R"];
                break;
            case URB:
                setupMoves = @[@"R", @"D'", @"R"];
                break;
            case DRF:
                setupMoves = @[@"F'"];
                break;
            case DLF:
                setupMoves = @[@"D", @"F'"];
                break;
            case DLB:
                setupMoves = @[@"D2", @"F'"];
                break;
            case DRB:
                setupMoves = @[@"D'", @"F'"];
                break;
        }
    }
    else if (orientation == 2)
    {
        switch (permutation)
        {
            case ULB:
                break;
            case ULF:
                setupMoves = @[@"F2", @"R"];
                break;
            case URF:
                setupMoves = @[@"R2", @"D'", @"R"];
                break;
            case URB:
                setupMoves = @[@"R'"];
                break;
            case DRF:
                setupMoves = @[@"R"];
                break;
            case DLF:
                setupMoves = @[@"D", @"R"];
                break;
            case DLB:
                setupMoves = @[@"D2", @"R"];
                break;
            case DRB:
                setupMoves = @[@"D'", @"R"];
                break;
        }
    }
    return setupMoves;
}

+ (NSArray *)giveSolveMovesForCornerWithTargetPermutation:(int)permutation withOrientation:(int)orientation
{
    NSArray *setupMoves = [self giveSetupMovesForCornerWithTargetPermutation:permutation withOrientation:orientation];
    NSLog(@"Setup:%@", [self giveStringFromMoveStringArray:setupMoves]);
    
    NSArray *YPerm = [self returnYPerm];
    NSLog(@"YPerm:%@", [self giveStringFromMoveStringArray:YPerm]);
    
    NSMutableArray *inversedSetupMoves = [[[setupMoves reverseObjectEnumerator] allObjects] mutableCopy];
    for (int i = 0; i < [inversedSetupMoves count]; i++)
    {
        NSString *move = inversedSetupMoves[i];
        NSString *inversedMove = [self giveInverseMoveForMove:move];
        inversedSetupMoves[i] = inversedMove;
    }
    NSLog(@"Reverse Setup:%@", [self giveStringFromMoveStringArray:inversedSetupMoves]);
    
    NSArray *moves = [[[NSArray arrayWithArray:setupMoves] arrayByAddingObjectsFromArray:YPerm] arrayByAddingObjectsFromArray:inversedSetupMoves];
    return moves;
}



#pragma mark Manipulating moves in standard notation
+ (NSString *)giveInverseMoveForMove:(NSString *)move
{
    if (move.length == 2)
    {
        char modifier = [move characterAtIndex:1];
        if (modifier == '\'')
        {
            move = [move substringToIndex:1];
        }
    }
    else if (move.length == 1)
    {
        move = [move stringByAppendingString:@"'"];
    }
    return move;
}

+ (NSString *)giveStringFromTurnedFace:(int)face counterClockwise:(BOOL)isCounterClockwise twice:(BOOL)isTwice
{
    NSMutableString *turn = [[NSMutableString alloc] init];
    switch (face) {
        case front:
            [turn appendString:@"F"];
            break;
            
        case back:
            [turn appendString:@"B"];
            break;
            
        case up:
            [turn appendString:@"U"];
            break;
            
        case down:
            [turn appendString:@"D"];
            break;
            
        case right:
            [turn appendString:@"R"];
            break;
            
        case left:
            [turn appendString:@"L"];
            break;
    }
    
    if (isTwice)
    {
        [turn appendString:@"2"];
    }
    
    if (isCounterClockwise)
    {
        [turn appendString:@"'"];
    }
    
    return turn;
}

+ (NSArray *)giveTurnFromString:(NSString *)string
{
    NSArray *turnArr = @[];
    int face = -1;
    BOOL counterClockwise = NO;
    BOOL isTwice = NO;
    char turnLetter = [string characterAtIndex:0];
    switch (turnLetter)
    {
        case 'R':
            face = right;
            break;
        case 'L':
            face = left;
            break;
        case 'U':
            face = up;
            break;
        case 'B':
            face = back;
            break;
        case 'F':
            face = front;
            break;
        case 'D':
            face = down;
            break;
    }
    
    if (string.length == 2)
    {
        char modificator = [string characterAtIndex:1];
        if (modificator == '\'')
        {
            counterClockwise = 1;
        }
        if (modificator == '2')
        {
            isTwice = 1;
        }
    }
    
    turnArr = @[@(face), @(counterClockwise), @(isTwice)];
    return turnArr;
}

#pragma mark Private
+ (NSString *)giveStringFromMoveStringArray:(NSArray *)array
{
    NSMutableString *moves = [[NSMutableString alloc] init];
    for (NSString *move in array)
    {
        [moves appendString:[NSString stringWithFormat:@" %@", move]];
    }
    return moves;
}
@end
