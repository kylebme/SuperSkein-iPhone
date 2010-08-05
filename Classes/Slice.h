//
//  Slice.h
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import <Foundation/Foundation.h>
#import "Mesh.h"

@interface Slice : NSObject {
	NSMutableArray *Lines;
}

- (id)initWithMesh:(Mesh*)theMesh andZLevel:(float)ZLevel;
- (float)magWithX:(float)tempX andY:(float)tempY;

@property (nonatomic, retain) NSMutableArray *Lines;

@end
