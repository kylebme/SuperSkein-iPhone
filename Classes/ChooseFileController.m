//
//  ChooseFileController.m
//
//  Created by Kyle on 8/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChooseFileController.h"

@implementation ChooseFileController

- (void)viewDidLoad {
	[super viewDidLoad];
	NSFileManager *defaultManager = [NSFileManager defaultManager];
	NSURL *documentsFolderPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
	theFiles = [[NSMutableArray alloc] initWithCapacity:0];
	// Yes this is a long line. But this is why this messy code is in another class.
	[theFiles addObjectsFromArray:[defaultManager contentsOfDirectoryAtURL:documentsFolderPath includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLTypeIdentifierKey, nil] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return theFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Set up the cell...
	NSString *cellValue = [[theFiles objectAtIndex:indexPath.row] lastPathComponent];
	cell.textLabel.text = cellValue;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.parentViewController saveFileSelectionWithFilepath:[[theFiles objectAtIndex:indexPath.row] path]];
}

@end
