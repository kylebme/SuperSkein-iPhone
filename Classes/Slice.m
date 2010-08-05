//
//  Slice.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "Slice.h"


@implementation Slice

@synthesize Lines;

- (id)initWithMesh:(Mesh*)theMesh andZLevel:(float)ZLevel {
	if((self=[super init])) {
		NSMutableArray *unsortedLines;
		Line2D *intersection;
		unsortedLines = [[NSMutableArray alloc] initWithCapacity:0];
		int i;
		for(i = [theMesh.Triangles count]-1; i>=0; i--) {
			Triangle * tri = [theMesh.Triangles objectAtIndex:i];
			intersection = [tri getZIntersectWithLevel:ZLevel];
			if(intersection!=nil) [unsortedLines addObject:intersection];
		}
		if(unsortedLines.count < 1) return self;
		Lines = [[NSMutableArray alloc] initWithCapacity:1];
		[Lines addObject:[unsortedLines objectAtIndex:0]];
		//int finalSize = unsortedLines.count;
		[unsortedLines removeObjectAtIndex:0];
		//ratchets for distance
		//dist_flipped exists to catch flipped lines
		float dist, dist_flipped;
		float mindist = 10000;
		
		int iNextLine;
		
		float epsilon = 1e-6;
		
		//while(Lines.size()<FinalSize)
		while(unsortedLines.count>0)
		{
			Line2D * CLine = [Lines objectAtIndex:Lines.count-1];//Get last
			iNextLine = (Lines.count-1);
			mindist = 10000;
			BOOL doflip = NO;
			for(int i = unsortedLines.count-1;i>=0;i--)
			{
				Line2D * LineCandidate = [unsortedLines objectAtIndex:i];
				dist         = [self magWithX:(float)(LineCandidate.theFirstPoint.x-CLine.theSecondPoint.x) andY:(LineCandidate.theFirstPoint.y-CLine.theSecondPoint.y)];
				dist_flipped = [self magWithX:(float)(LineCandidate.theSecondPoint.x-CLine.theSecondPoint.x) andY:(LineCandidate.theSecondPoint.y-CLine.theSecondPoint.y)]; // flipped
				
				if(dist<epsilon)
				{
					// We found exact match.  Break out early.
					doflip = NO;
					iNextLine = i;
					mindist = 0;
					break;
				}
				
				if(dist_flipped<epsilon)
				{
					// We found exact flipped match.  Break out early.
					doflip = YES;
					iNextLine = i;
					mindist = 0;
					break;
				}
				
				if(dist<mindist)
				{
					// remember closest nonexact matches to end
					doflip = NO;
					iNextLine=i;
					mindist = dist;
				}
				
				if(dist_flipped<mindist)
				{
					// remember closest flipped nonexact matches to end
					doflip = YES;
					iNextLine=i;
					mindist = dist_flipped;
				}
			}
			
			Line2D * LineToMove = [unsortedLines objectAtIndex:iNextLine];
			if(doflip) {
				[LineToMove flip];
			}
			[Lines addObject:LineToMove];
			[unsortedLines removeObjectAtIndex:iNextLine];
		}
	}
	return self;
}

- (float)magWithX:(float)tempX andY:(float)tempY {
	return sqrt((pow((0-tempX), 2)+pow((0-tempY), 2)));
}

@end
