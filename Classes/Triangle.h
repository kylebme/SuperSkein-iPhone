//
//  Triangle.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <Foundation/Foundation.h>
#import "Line2D.h"


@interface Triangle : NSObject {
	float x1,x2,x3,y1,y2,y3,z1,z2,z3,xn,yn,zn;
}

- (id)initWithArray:(NSMutableArray*)pointArray;
- (void)scaleWithFactor:(float)Factor;
- (void)translateWithVector:(float*)vector;
- (void)rotateZWithRadians:(float)Angle;
- (void)rotateYWithRadians:(float)Angle;
- (void)rotateXWithRadians:(float)Angle;
- (Line2D*)getZIntersectWithLevel:(float)ZLevel;
- (void)Resort;

@property (nonatomic) float x1,x2,x3,y1,y2,y3,z1,z2,z3,xn,yn,zn;


@end
