//
//  Mesh.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <Foundation/Foundation.h>
#import "Triangle.h"
#import "Everything.h"

@interface Mesh : NSObject {
	NSMutableArray * Triangles;
	float bx1,by1,bz1,bx2,by2,bz2; //bounding box
	char *b;
	float Sink;
}

- (id)initWithFile:(NSString*)filename;
- (void)scaleWithFactor:(float)factor;
- (void)translateWithVector:(float*)vector;
- (void)CalculateBoundingBox;

@property (nonatomic, retain) NSMutableArray * Triangles;
@property (nonatomic) float bx1,by1,bz1,bx2,by2,bz2;

@end
