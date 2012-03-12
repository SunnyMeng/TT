//
//  TTFetchResultsModel.m
//  msnsf
//
//  Created by shaohua on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTFetchResultsModel.h"

@implementation TTFetchResultsModel

@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name {
    if (self = [super init]) {
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name];
        _fetchedResultsController.delegate = self;

        // only need to fetch once
        [_fetchedResultsController performFetch:NULL];
    }
    return self;
}

- (void)dealloc {
    [_fetchedResultsController release];
    [super dealloc];
}

- (BOOL)isLoaded {
    return _loaded;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    _loaded = YES;
    [self.delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}

- (NSInteger)numberOfSections {
    return [[_fetchedResultsController sections] count];
}

- (id)objectForSection:(NSInteger)section {
    return [[_fetchedResultsController sections] objectAtIndex:section];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return [[self objectForSection:section] numberOfObjects];
}

- (id)objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_fetchedResultsController objectAtIndexPath:indexPath];
}

- (BOOL)isEmpty {
    return [[_fetchedResultsController fetchedObjects] count] == 0;
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    TTDPRINT();
    [self load:TTURLRequestReloadIgnoringCacheData more:NO];
}

@end
