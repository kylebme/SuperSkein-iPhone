//
//  Mesh.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "Mesh.h"

@implementation Mesh

@synthesize Triangles,bx1,by1,bz1,bx2,by2,bz2;


- (id)initWithFile:(NSString*)filename {
	if((self=[super init])) {
		NSData *fileData = [[NSData alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename]];
		b = malloc(fileData.length);
		[fileData getBytes:b length:fileData.length];
		Triangles = [[NSMutableArray alloc] initWithCapacity:9];
		Sink = 0;
		NSMutableArray *Tri = [[NSMutableArray alloc] initWithCapacity:9];
		int offs = 84;
		NSUInteger theLength = fileData.length;
		[fileData release];
		while(offs<theLength) {
			offs += 12;
			int i;
			for(i = 0; i<9; i++) {
				if(offs>=96&&offs<=132) [Tri addObject:[NSNumber numberWithFloat:[Everything bin_to_float:b+offs and:b+offs+1 also:b+offs+2 finally:b+offs+3]]];
				else [Tri replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:[Everything bin_to_float:b+offs and:b+offs+1 also:b+offs+2 finally:b+offs+3]]];
				offs+=4;
			}
			offs+=2;
			[Triangles addObject:[[Triangle alloc] initWithArray:Tri]];
		}
		[self CalculateBoundingBox];
		[Tri release];
	}
	return self;
}

- (void)scaleWithFactor:(float)factor {
	int i;
	for(i = [Triangles count]-1; i>=0; i--) {
		Triangle * tri = [Triangles objectAtIndex:i];
		[tri scaleWithFactor:factor];
	}
	[self CalculateBoundingBox];
}

- (void)translateWithVector:(float*)vector {
	int i;
	for(i = [Triangles count]-1; i>=0; i--) {
		Triangle * tri = [Triangles objectAtIndex:i];
		[tri translateWithVector:vector];
		
	}
	[self CalculateBoundingBox];
}

- (void)CalculateBoundingBox
{
	bx1 = 10000;
	bx2 = -10000;
	by1 = 10000;
	by2 = -10000;
	bz1 = 10000;
	bz2 = -10000;
	int i;
	for(i = [Triangles count]-1;i>=0;i--)
    {
		
		Triangle * tri = [Triangles objectAtIndex:i];
		if(tri.x1<bx1)bx1=tri.x1;
		if(tri.x2<bx1)bx1=tri.x2;
		if(tri.x3<bx1)bx1=tri.x3;
		if(tri.x1>bx2)bx2=tri.x1;
		if(tri.x2>bx2)bx2=tri.x2;
		if(tri.x3>bx2)bx2=tri.x3;
		if(tri.y1<by1)by1=tri.y1;
		if(tri.y2<by1)by1=tri.y2;
		if(tri.y3<by1)by1=tri.y3;
		if(tri.y1>by2)by2=tri.y1;
		if(tri.y2>by2)by2=tri.y2;
		if(tri.y3>by2)by2=tri.y3;
		if(tri.z1<bz1)bz1=tri.z1;
		if(tri.z2<bz1)bz1=tri.z2;
		if(tri.z3<bz1)bz1=tri.z3;
		if(tri.z1>bz2)bz2=tri.z1;
		if(tri.z2>bz2)bz2=tri.z2;
		if(tri.z3>bz2)bz2=tri.z3;
    }    
}

- (void)dealloc {
	[super dealloc];
	free(b);
	[Triangles release];
}

@end
