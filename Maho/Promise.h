//
//  Promise.h
//  Maho
//
//  Created by 堤 健 on 11/04/15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Action;

@interface Promise : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet* actions;

- (void)addActionsObject:(Action *)value;
- (void)removeActionsObject:(Action *)value;
- (void)addActions:(NSSet *)value;
- (void)removeActions:(NSSet *)value;

@end
