//
//  SuperSkein_iPhoneViewController.m
//  SuperSkein-iPhone
//
//  Created by beak90 on 7/31/10.
//

#import "SuperSkein_iPhoneViewController.h"

#define PreScale 1
#define FileName @"DNAmodel.stl"

@implementation SuperSkein_iPhoneViewController



/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	t=0;
	tfloat=0;
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (IBAction)skeinIt {
	NSMutableString *theFileContents = [[NSMutableString alloc] initWithCapacity:1];
	float layerThickness = [layerheightfield.text floatValue];
	float feedRate = [feedratefield.text floatValue];
	float ZFeedRate = [zfeedratefield.text floatValue];
	NSLog(@"Loading STL file...\n");
	STLFile = [[Mesh alloc] initWithFile:FileName];
	[STLFile scaleWithFactor:1];
	float tempAr[3] = {0,0,-STLFile.bz1};
	float tempAr2[3] = {0,0,-layerThickness};
	float tempAr3[3] = {0,0,-[sinkfield.text floatValue]};
	[STLFile translateWithVector:tempAr];
	[STLFile translateWithVector:tempAr2];
	[STLFile translateWithVector:tempAr3];
	[theFileContents appendString:@"G21\nG90\nM103\nG92 X0 Y0 Z0\n"];
	float Layers = STLFile.bz2/layerThickness;
	float ZLevel;
	for(ZLevel = 0; ZLevel<(STLFile.bz2-layerThickness); ZLevel+=layerThickness) {
		theSlice = [[Slice alloc] initWithMesh:STLFile andZLevel:ZLevel];
		int j;
		Line2D * lin = [theSlice.Lines objectAtIndex:0];
		[theFileContents appendFormat:@"G1 X%f Y%f Z%f F%f\n", lin.theFirstPoint.x, lin.theFirstPoint.y, ZLevel, ZFeedRate];
		for(j = 0; j<theSlice.Lines.count; j++) {
			lin = [theSlice.Lines objectAtIndex:j];
			[theFileContents appendFormat:@"G1 X%f Y%f Z%f F%f\n", lin.theSecondPoint.x, lin.theSecondPoint.y, ZLevel, feedRate];
		}
		[theSlice release];
	}
	[theFileContents writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"output.gcode"] atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	NSLog(@"Finished!!!");
}

- (IBAction)chooseFile {
	NSLog(@"File is %@",FileName);
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	if(STLFile) [STLFile release];
}

@end
