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

typedef NS_ENUM(NSInteger, permutationEdge)
{
    UR, UF, UL, UB, DR, DF, DL, DB, FR, FL, BL, BR
};

typedef NS_ENUM(NSInteger, permutationCorner)
{
    URF, ULF, ULB, URB, DRF, DLF, DLB, DRB
};


@implementation Cube
/*
    A cube state is defined by _edges and _corners array, where each of the indices represent a particular position of an edge cubie or a corner cubie. For example, _edges[0] represents an edge cubie which is located on UR (UP-RIGHT) face. Each move is a manipulation of those arrays, where edges and corners are permuted accrodingly.
 
    _faces array is needed to represent the cube in 6 arrays of capacity 9, where each element represents a sticker, which is later drawn on the screen.
 */

- (void)defineSolvedCube
{
    _edges = [[NSMutableArray alloc] initWithCapacity:12];
    _corners = [[NSMutableArray alloc] initWithCapacity:8];
    _centers = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 12; i++)
    {
        Edge *edge = [[Edge alloc] initWithTargetPermutation:i];
        edge.orientation = 0;
        [_edges addObject:edge];
        
    }
    for (int i = 0; i < 8; i++)
    {
        Corner *corner = [[Corner alloc] initWithTargetPermutation:i];
        corner.orientation = 0;
        [_corners addObject:corner];
    }
    
    for (int i = 0; i < 6; i++)
    {
        Center *center = [[Center alloc] init];
        center.color = i + 1;
        [self.centers addObject:center];
    }
    
    self.faces = [[NSMutableArray alloc] initWithCapacity:6];
    for (int i = 0; i < 6; i++)
    {
        NSMutableArray *face = [[NSMutableArray alloc] initWithCapacity:9];
        for (int j = 0; j < 9; j++)
        {
            [face addObject:@(0)];
        }
        [self.faces addObject:face];
    }
    
    [self updateFaces];
}

#pragma mark Cube Visualisation
- (void)updateFaces
{
    // update edges
    for (int i = 0; i < [_edges count]; i++)
    {
        Edge *edge = _edges[i];
        NSArray *edgeColors = [NSArray arrayWithArray:edge.colors];
        
        // if the edge is flipped, colors will be stored in a reversed order
        if (edge.orientation)
        {
            edgeColors = [[edge.colors reverseObjectEnumerator] allObjects];
        }
        for (int j = 0; j < [edgeColors count]; j++)
        {
            NSNumber *color = edgeColors[j];
            // upper edges
            
            
            if (i == 0 && j == 0) // UR
            {
                self.faces[up][5] = color;
            }
            if (i == 0 && j == 1)
            {
                self.faces[right][1] = color;
            }
            if (i == 1 && j == 0) // UF
            {
                self.faces[up][7] = color;
            }
            if (i == 1 && j == 1)
            {
                self.faces[front][1] = color;
            }
            if (i == 2 && j == 0) // UL
            {
                self.faces[up][3] = color;
            }
            if (i == 2 && j == 1)
            {
                self.faces[left][1] = color;
            }
            if (i == 3 && j == 0) // UB
            {
                self.faces[up][1] = color;
            }
            if (i == 3 && j == 1)
            {
                self.faces[back][7] = color;
            }
            
            // down edges
            if (i == 4 && j == 0) // DR
            {
                self.faces[down][5] = color;
            }
            if (i == 4 && j == 1)
            {
                self.faces[right][7] = color;
            }
            if (i == 5 && j == 0) // DF
            {
                self.faces[down][1] = color;
            }
            if (i == 5 && j == 1)
            {
                self.faces[front][7] = color;
            }
            if (i == 6 && j == 0) // DL
            {
                self.faces[down][3] = color;
            }
            if (i == 6 && j == 1)
            {
                self.faces[left][7] = color;
            }
            if (i == 7 && j == 0) // DB
            {
                self.faces[down][7] = color;
            }
            if (i == 7 && j == 1)
            {
                self.faces[back][1] = color;
            }
            
            // front E-slice edges
            if (i == 8 && j == 0) // FR
            {
                self.faces[front][5] = color;
            }
            if (i == 8 && j == 1)
            {
                self.faces[right][3] = color;
            }
            if (i == 9 && j == 0) // FL
            {
                self.faces[front][3] = color;
            }
            if (i == 9 && j == 1)
            {
                self.faces[left][5] = color;
            }
            
            // back E-slice edges
            if (i == 10 && j == 0) // BL
            {
                self.faces[back][3] = color;
            }
            if (i == 10 && j == 1)
            {
                self.faces[left][3] = color;
            }
            if (i == 11 && j == 0) // BR
            {
                self.faces[back][5] = color;
            }
            if (i == 11 && j == 1)
            {
                self.faces[right][5] = color;
            }
        }
    }
    
    //update corners
    for (int i = 0; i < [_corners count]; i++)
    {
        Corner *corner = _corners[i];
        NSMutableArray *cornerColors = [[NSMutableArray alloc] initWithArray:corner.colors];
        // depending on corner orientation, stickers will be stored in a different order
        switch (corner.orientation)
        {
            default:
                break;
            
            case 1:
                [cornerColors exchangeObjectAtIndex:0 withObjectAtIndex:2];
                [cornerColors exchangeObjectAtIndex:1 withObjectAtIndex:2];
                break;
                
            case 2:
                [cornerColors exchangeObjectAtIndex:0 withObjectAtIndex:1];
                [cornerColors exchangeObjectAtIndex:1 withObjectAtIndex:2];
                break;
        }
        
        for (int j = 0; j < [cornerColors count]; j++)
        {
            NSNumber *color = cornerColors[j];
            
            // upper corners
            if (i == 0 && j == 0) // URF
            {
                self.faces[up][8] = color;
            }
            if (i == 0 && j == 1)
            {
                self.faces[right][0] = color;
            }
            if (i == 0 && j == 2)
            {
                self.faces[front][2] = color;
            }
            if (i == 1 && j == 0) // ULF
            {
                self.faces[up][6] = color;
            }
            if (i == 1 && j == 1)
            {
                self.faces[front][0] = color;
            }
            if (i == 1 && j == 2)
            {
                self.faces[left][2] = color;
            }
            if (i == 2 && j == 0) // ULB
            {
                self.faces[up][0] = color;
            }
            if (i == 2 && j == 1)
            {
                self.faces[left][0] = color;
            }
            if (i == 2 && j == 2)
            {
                self.faces[back][6] = color;
            }
            if (i == 3 && j == 0) // URB
            {
                self.faces[up][2] = color;
            }
            if (i == 3 && j == 1)
            {
                self.faces[back][8] = color;
            }
            if (i == 3 && j == 2)
            {
                self.faces[right][2] = color;
            }
            
            // lower corners
            if (i == 4 && j == 0) // DRF
            {
                self.faces[down][2] = color;
            }
            if (i == 4 && j == 1)
            {
                self.faces[front][8] = color;
            }
            if (i == 4 && j == 2)
            {
                self.faces[right][6] = color;
            }
            if (i == 5 && j == 0) // DLF
            {
                self.faces[down][0] = color;
            }
            if (i == 5 && j == 1)
            {
                self.faces[left][8] = color;
            }
            if (i == 5 && j == 2)
            {
                self.faces[front][6] = color;
            }
            if (i == 6 && j == 0) // DLB
            {
                self.faces[down][6] = color;
            }
            if (i == 6 && j == 1)
            {
                self.faces[back][0] = color;
            }
            if (i == 6 && j == 2)
            {
                self.faces[left][6] = color;
            }
            if (i == 7 && j == 0) // DRB
            {
                self.faces[down][8] = color;
            }
            if (i == 7 && j == 1)
            {
                self.faces[right][8] = color;
            }
            if (i == 7 && j == 2)
            {
                self.faces[back][2] = color;
            }
        }
    }
    
    // update centers
    for (int i = 0; i < [self.centers count]; i++)
    {
        Center *center = self.centers[i];
        self.faces[i][4] = [NSNumber numberWithInt:center.color];
        
    }
    
}

#pragma mark Turning the Cube
- (void)turnLayer:(int)face counterClockwise:(BOOL)counterClockwise twice:(BOOL)isTwice
{
    if (counterClockwise)
    {
        for (int i = 0; i < 3; i++)
        {
            [self turnLayer:face counterClockwise:NO twice:isTwice];
        }
    }
    else
    {
        for (int i = 0; i < (1 + isTwice); i++)
        {
            switch (face)
            {
                case front:
                {
                    // edges
                    Edge *edgeUF = self.edges[UF];
                    Edge *edgeFR = self.edges[FR];
                    Edge *edgeDF = self.edges[DF];
                    Edge *edgeFL = self.edges[FL];
                    edgeUF.orientation = (edgeUF.orientation + 1) % 2;
                    edgeFR.orientation = (edgeFR.orientation + 1) % 2;
                    edgeDF.orientation = (edgeDF.orientation + 1) % 2;
                    edgeFL.orientation = (edgeFL.orientation + 1) % 2;
                    [self.edges replaceObjectAtIndex:UF withObject:edgeFL];
                    [self.edges replaceObjectAtIndex:FR withObject:edgeUF];
                    [self.edges replaceObjectAtIndex:DF withObject:edgeFR];
                    [self.edges replaceObjectAtIndex:FL withObject:edgeDF];
                    
                    // corners
                    Corner *cornerURF = self.corners[URF];
                    Corner *cornerDRF = self.corners[DRF];
                    Corner *cornerDLF = self.corners[DLF];
                    Corner *cornerULF = self.corners[ULF];
                    cornerURF.orientation = (cornerURF.orientation + 2) % 3;
                    cornerDRF.orientation = (cornerDRF.orientation + 1) % 3;
                    cornerDLF.orientation = (cornerDLF.orientation + 2) % 3;
                    cornerULF.orientation = (cornerULF.orientation + 1) % 3;
                    [self.corners replaceObjectAtIndex:URF withObject:cornerULF];
                    [self.corners replaceObjectAtIndex:DRF withObject:cornerURF];
                    [self.corners replaceObjectAtIndex:DLF withObject:cornerDRF];
                    [self.corners replaceObjectAtIndex:ULF withObject:cornerDLF];
                    break;
                }
                    
                case back:
                {
                    // edges
                    Edge *edgeUB = self.edges[UB];
                    Edge *edgeBL = self.edges[BL];
                    Edge *edgeDB = self.edges[DB];
                    Edge *edgeBR = self.edges[BR];
                    edgeUB.orientation = (edgeUB.orientation + 1) % 2;
                    edgeBL.orientation = (edgeBL.orientation + 1) % 2;
                    edgeDB.orientation = (edgeDB.orientation + 1) % 2;
                    edgeBR.orientation = (edgeBR.orientation + 1) % 2;
                    [self.edges replaceObjectAtIndex:UB withObject:edgeBR];
                    [self.edges replaceObjectAtIndex:BL withObject:edgeUB];
                    [self.edges replaceObjectAtIndex:DB withObject:edgeBL];
                    [self.edges replaceObjectAtIndex:BR withObject:edgeDB];
                    
                    // corners
                    Corner *cornerURB = self.corners[URB];
                    Corner *cornerULB = self.corners[ULB];
                    Corner *cornerDLB = self.corners[DLB];
                    Corner *cornerDRB = self.corners[DRB];
                    cornerURB.orientation = (cornerURB.orientation + 1) % 3;
                    cornerULB.orientation = (cornerULB.orientation + 2) % 3;
                    cornerDLB.orientation = (cornerDLB.orientation + 1) % 3;
                    cornerDRB.orientation = (cornerDRB.orientation + 2) % 3;
                    [self.corners replaceObjectAtIndex:URB withObject:cornerDRB];
                    [self.corners replaceObjectAtIndex:ULB withObject:cornerURB];
                    [self.corners replaceObjectAtIndex:DLB withObject:cornerULB];
                    [self.corners replaceObjectAtIndex:DRB withObject:cornerDLB];
                    break;
                }
                    
                case up:
                {
                    // edges
                    [self.edges exchangeObjectAtIndex:UF withObjectAtIndex:UR];
                    [self.edges exchangeObjectAtIndex:UR withObjectAtIndex:UB];
                    [self.edges exchangeObjectAtIndex:UB withObjectAtIndex:UL];
                    
                    // corners
                    [self.corners exchangeObjectAtIndex:URF withObjectAtIndex:URB];
                    [self.corners exchangeObjectAtIndex:URB withObjectAtIndex:ULB];
                    [self.corners exchangeObjectAtIndex:ULB withObjectAtIndex:ULF];
                    break;
                }
                case down:
                {
                    // edges
                    [self.edges exchangeObjectAtIndex:DF withObjectAtIndex:DL];
                    [self.edges exchangeObjectAtIndex:DL withObjectAtIndex:DB];
                    [self.edges exchangeObjectAtIndex:DB withObjectAtIndex:DR];
                    
                    // corners
                    [self.corners exchangeObjectAtIndex:DRF withObjectAtIndex:DLF];
                    [self.corners exchangeObjectAtIndex:DLF withObjectAtIndex:DLB];
                    [self.corners exchangeObjectAtIndex:DLB withObjectAtIndex:DRB];
                    break;
                }
                case right:
                {
                    // edges
                    [self.edges exchangeObjectAtIndex:UR withObjectAtIndex:FR];
                    [self.edges exchangeObjectAtIndex:FR withObjectAtIndex:DR];
                    [self.edges exchangeObjectAtIndex:DR withObjectAtIndex:BR];
                    
                    // corners
                    Corner *cornerURF = self.corners[URF];
                    Corner *cornerURB = self.corners[URB];
                    Corner *cornerDRB = self.corners[DRB];
                    Corner *cornerDRF = self.corners[DRF];
                    cornerURF.orientation = (cornerURF.orientation + 1) % 3;
                    cornerURB.orientation = (cornerURB.orientation + 2) % 3;
                    cornerDRB.orientation = (cornerDRB.orientation + 1) % 3;
                    cornerDRF.orientation = (cornerDRF.orientation + 2) % 3;
                    [self.corners replaceObjectAtIndex:URF withObject:cornerDRF];
                    [self.corners replaceObjectAtIndex:URB withObject:cornerURF];
                    [self.corners replaceObjectAtIndex:DRB withObject:cornerURB];
                    [self.corners replaceObjectAtIndex:DRF withObject:cornerDRB];
                    break;
                }
                    
                case left:
                {
                    // edges
                    [self.edges exchangeObjectAtIndex:UL withObjectAtIndex:BL];
                    [self.edges exchangeObjectAtIndex:BL withObjectAtIndex:DL];
                    [self.edges exchangeObjectAtIndex:DL withObjectAtIndex:FL];
                    
                    // corners
                    Corner *cornerULF = self.corners[ULF];
                    Corner *cornerULB = self.corners[ULB];
                    Corner *cornerDLB = self.corners[DLB];
                    Corner *cornerDLF = self.corners[DLF];
                    cornerULF.orientation = (cornerULF.orientation + 2) % 3;
                    cornerULB.orientation = (cornerULB.orientation + 1) % 3;
                    cornerDLB.orientation = (cornerDLB.orientation + 2) % 3;
                    cornerDLF.orientation = (cornerDLF.orientation + 1) % 3;
                    [self.corners replaceObjectAtIndex:ULF withObject:cornerULB];
                    [self.corners replaceObjectAtIndex:ULB withObject:cornerDLB];
                    [self.corners replaceObjectAtIndex:DLB withObject:cornerDLF];
                    [self.corners replaceObjectAtIndex:DLF withObject:cornerULF];
                    break;
                    break;
                }
            }
        }
    }
}

- (void)turnLayerWithDrawing:(int)face counterClockwise:(BOOL)isCounterClockwise twice:(BOOL)isTwice
{
    [self turnLayer:face counterClockwise:isCounterClockwise twice:isTwice];
    [self updateFaces];
    [self.delegate didTurnCube];
}

#pragma mark Cube Scrambling
- (NSString *)scrambleCubeAndGiveMoves
{
    NSMutableString *scramble = [[NSMutableString alloc] init];
    int lastFace = -1;
    for (int i = 0; i < 26; i++)
    {
        int face;
        // prevents any consecutive turns of the same layer (e.g. R R) and prevents commutative turns (e.g. R L R')
        while (true)
        {
            face = arc4random_uniform(6);
            if (face != lastFace)
            {
                if ((lastFace == up && face == down) || (lastFace == right && face == left) || (lastFace == front && lastFace == back))
                {
                    continue;
                }
                break;
            }
        }
        BOOL counterClockwise = arc4random_uniform(2);
        BOOL twice = arc4random_uniform(2);
        // prevents counterclockwise double turns (equivalent to clockwise double turns)
        if (twice)
        {
            counterClockwise = 0;
        }
        
        [self turnLayer:face counterClockwise:counterClockwise twice:twice];
        lastFace = face;
        
        if ([scramble isEqualToString:@""])
        {
            [scramble appendString:[Algorithms giveStringFromTurnedFace:face counterClockwise:counterClockwise twice:twice]];
        }
        else
        {
            [scramble appendString:[NSString stringWithFormat:@" %@", [Algorithms giveStringFromTurnedFace:face counterClockwise:counterClockwise twice:twice]]];
        }
        
        if (i == 12)
        {
            [scramble appendString:@"\n"];
        }
    }
    return scramble;
}

#pragma mark Misc
- (int)numberOfEdgesSolved
{
    int numberOfEdgesSolved = 0;
    for (int i = 0; i < [self.edges count]; i++)
    {
        Edge *edge = self.edges[i];
        if (edge.targetPermutation == i && edge.orientation == 0)
        {
            numberOfEdgesSolved++;
        }
    }
    return numberOfEdgesSolved;
}

- (int)numberOfCornersSolved
{
    int numberOfCornersSolved = 0;
    for (int i = 0; i < [self.corners count]; i++)
    {
        Corner *corner = self.corners[i];
        if (corner.targetPermutation == i && corner.orientation == 0)
        {
            numberOfCornersSolved++;
        }
    }
    return numberOfCornersSolved;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    Cube *copy = [[[self class] allocWithZone:zone] init];
    
    if (copy)
    {
        NSMutableArray *dupEdges = [[NSMutableArray alloc] init];
        for (Edge *edge in self.edges)
        {
            [dupEdges addObject:[edge copy]];
        }
        copy.edges = dupEdges;
        
        NSMutableArray *dupCorners = [[NSMutableArray alloc] init];
        for (Corner *corner in self.corners)
        {
            [dupCorners addObject:[corner copy]];
        }
        copy.corners = dupCorners;
    }
    
    return copy;
}

@end
