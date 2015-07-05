//
//  Cube.m
//  Rubik's Cube Solver
//
//  Created by Tom on 7/2/15.
//  Copyright (c) 2015 Tom. All rights reserved.
//

#import "Cube.h"

typedef NS_ENUM(NSInteger, face)
{
    front, back, up, down, right, left
};
// front = 0, back = 1, up = 2, down = 3, right = 4, left = 5
// green = 1, blue = 2, white = 3, yellow = 4, red = 5, orange = 6


@implementation Cube

- (void)defineSolvedCube
{
    // the cube is represented as 6 arrays with capacity 9 (6 faces with 9 stickers on each face)
    self.faces = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        // each face is filled with ints 1-6, where each int corresponds to a color (as written above)
        NSNumber *color = [NSNumber numberWithInt:i + 1];
        self.faces[i] = [[NSMutableArray alloc] init];
        for (int j = 0; j < 9; j++)
        {
            [self.faces[i] addObject:color];
        }
    }
    
    
}

/*
    Face - 9 stickers which correspond to one side of the cube
    Layer - 9 stickers on one side + 12 stickers which are adjacent to that face

    Example of turning the right layer:
    1) the cube is rotated so that the right side becomes the front
    2) the front face is turned 90 degrees
    3) all the adjacent stickers to the front face are turned 90 degrees
    4) the cube is rotated back to the initial position
*/
- (void)turnLayer:(int)face counterClockwise:(BOOL)isCounterClockwise
{
    [self rotateCubeWithFrontFace:face];
    [self turnFace:front counterClockwise:isCounterClockwise];
    [self turnAdjacentPiecesToFrontFaceCounterClockwise:isCounterClockwise];
    [self revertCubeRotationsFromFace:face];
    [self.delegate didTurnCube]; // MainScene is notified of a cube turn
    
}

- (void)rotateCubeWithFrontFace:(int)face
{
    switch (face) {
        case front:
            break;
            
        case back:
            [self.faces exchangeObjectAtIndex:front withObjectAtIndex:back];
            [self.faces exchangeObjectAtIndex:up withObjectAtIndex:down];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:left counterClockwise:NO];
            [self turnFace:left counterClockwise:NO];
            
            break;
        
        case up:
            [self.faces exchangeObjectAtIndex:up withObjectAtIndex:front];
            [self.faces exchangeObjectAtIndex:up withObjectAtIndex:back];
            [self.faces exchangeObjectAtIndex:back withObjectAtIndex:down];
            [self turnFace:right counterClockwise:YES];
            [self turnFace:left counterClockwise:NO];
            break;
            
        case down:
            [self.faces exchangeObjectAtIndex:front withObjectAtIndex:down];
            [self.faces exchangeObjectAtIndex:down withObjectAtIndex:back];
            [self.faces exchangeObjectAtIndex:back withObjectAtIndex:up];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:left counterClockwise:YES];
            break;
            
        case right:
            [self.faces exchangeObjectAtIndex:front withObjectAtIndex:right];
            // because right and back faces are flipped relative to each other, we need to turn both faces 180 degrees before swapping them
            [self turnFace:right counterClockwise:NO];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self.faces exchangeObjectAtIndex:right withObjectAtIndex:back];
            // left and back faces are flipped relative to each other
            [self turnFace:left counterClockwise:NO];
            [self turnFace:left counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self.faces exchangeObjectAtIndex:back withObjectAtIndex:left];
            [self turnFace:up counterClockwise:NO];
            [self turnFace:down counterClockwise:YES];
            break;
            
        case left:
            [self.faces exchangeObjectAtIndex:front withObjectAtIndex:left];
            [self turnFace:left counterClockwise:NO];
            [self turnFace:left counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self.faces exchangeObjectAtIndex:left withObjectAtIndex:back];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:right counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self turnFace:back counterClockwise:NO];
            [self.faces exchangeObjectAtIndex:back withObjectAtIndex:right];
            [self turnFace:up counterClockwise:YES];
            [self turnFace:down counterClockwise:NO];
            break;
    }
}

- (void)turnFace:(int)face counterClockwise:(BOOL)isCounterClockwise
{
    if (!isCounterClockwise)
    {
        
        // turning edges
        [self.faces[face] exchangeObjectAtIndex:1 withObjectAtIndex:5];
        [self.faces[face] exchangeObjectAtIndex:1 withObjectAtIndex:3];
        [self.faces[face] exchangeObjectAtIndex:3 withObjectAtIndex:7];
        
    
        // turning corners
        [self.faces[face] exchangeObjectAtIndex:0 withObjectAtIndex:2];
        [self.faces[face] exchangeObjectAtIndex:0 withObjectAtIndex:6];
        [self.faces[face] exchangeObjectAtIndex:6 withObjectAtIndex:8];
        
    }
    else
    {
        // turning edges
        [self.faces[face] exchangeObjectAtIndex:1 withObjectAtIndex:3];
        [self.faces[face] exchangeObjectAtIndex:1 withObjectAtIndex:5];
        [self.faces[face] exchangeObjectAtIndex:5 withObjectAtIndex:7];
        
        // turning corners
        [self.faces[face] exchangeObjectAtIndex:0 withObjectAtIndex:6];
        [self.faces[face] exchangeObjectAtIndex:0 withObjectAtIndex:2];
        [self.faces[face] exchangeObjectAtIndex:2 withObjectAtIndex:8];
    
    }
    
}

- (void)turnAdjacentPiecesToFrontFaceCounterClockwise:(BOOL)isCounterClockwise
{
    if (!isCounterClockwise)
    {
        // turning edges
        // UD - upper face, sticker on the bottom (down), RL - right face, sticker on the left, etc.
        NSNumber *UD = [self.faces[up] objectAtIndex:7];
        NSNumber *RL = [self.faces[right] objectAtIndex:3];
        NSNumber *DU = [self.faces[down] objectAtIndex:1];
        NSNumber *LR = [self.faces[left] objectAtIndex:5];
        self.faces[up][7] = LR;
        self.faces[right][3] = UD;
        self.faces[down][1] = RL;
        self.faces[left][5] = DU;
        
        // turning corners
        // e.g. ULD - upper-left-bottom (down) sticker
        NSNumber *ULD = [self.faces[up] objectAtIndex:6];
        NSNumber *RLU = [self.faces[right] objectAtIndex:0];
        NSNumber *DRU = [self.faces[down] objectAtIndex:2];
        NSNumber *LRD = [self.faces[left] objectAtIndex:8];
        self.faces[up][6] = LRD;
        self.faces[right][0] = ULD;
        self.faces[down][2] = RLU;
        self.faces[left][8] = DRU;
        
        NSNumber *LRU = [self.faces[left] objectAtIndex:2];
        NSNumber *URD = [self.faces[up] objectAtIndex:8];
        NSNumber *RLD = [self.faces[right] objectAtIndex:6];
        NSNumber *DLU = [self.faces[down] objectAtIndex:0];
        self.faces[up][8] = LRU;
        self.faces[right][6] = URD;
        self.faces[down][0] = RLD;
        self.faces[left][2] = DLU;
        
   }
    else
    {
        for (int i = 0; i < 3; i++)
        {
            [self turnAdjacentPiecesToFrontFaceCounterClockwise:NO];
        }
    }
}

- (void)revertCubeRotationsFromFace:(int)face
{
    switch (face)
    {
        case front:
            break;
            
        case back:
            [self rotateCubeWithFrontFace:back];
            break;
            
        case up:
            [self rotateCubeWithFrontFace:down];
            break;
            
        case down:
            [self rotateCubeWithFrontFace:up];
            break;
            
        case right:
            [self rotateCubeWithFrontFace:left];
            break;
            
        case left:
            [self rotateCubeWithFrontFace:right];
            break;
    }
}

@end
