//
//  Algorithms.h
//  3x3Solver
//
//  Created by Tom on 7/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithms : NSObject

+ (NSArray *)returnTPerm; // gives an algorithm for T-Permutation
+ (NSArray *)returnYPerm; // gives an algorithm for Y-Permutation

+ (NSArray *)giveSetupMovesForEdgeWithTargetPermutation:(int)permutation withOrientation:(int)orientation; // returns setup moves for solving a particular edge
+ (NSArray *)giveSolveMovesForEdgeWithTargetPermutation:(int)permutation withOrientation:(int)orientation; // returns setup moves + T permutation + inverse setup moves for solving a particular edge

+ (NSArray *)giveSetupMovesForCornerWithTargetPermutation:(int)permutation withOrientation:(int)orientation; // returns setup moves for solving a particular corner
+ (NSArray *)giveSolveMovesForCornerWithTargetPermutation:(int)permutation withOrientation:(int)orientation; // returns setup moves + Y permutation + inverse setup moves for solving a particular corner

+ (NSString *)giveStringFromTurnedFace:(int)face counterClockwise:(BOOL)isCounterClockwise twice:(BOOL)isTwice; // converts a turn of a particular layer to a standard notation
+ (NSArray *)giveTurnFromString:(NSString *)string; // gives a move converted from a standard notation
+ (NSString *)giveInverseMoveForMove:(NSString *)move; // gives an inverse of a move
@end
