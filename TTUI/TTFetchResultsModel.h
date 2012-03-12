//
//  TTFetchResultsModel.h
//  msnsf
//
//  Created by shaohua on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TTModel.h"

@interface TTFetchResultsModel : TTModel <NSFetchedResultsControllerDelegate> {
    BOOL _loaded;
}

@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

- (id)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)name;

@end
