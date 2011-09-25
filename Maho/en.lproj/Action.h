//
//  Action.h
//  Maho
//
//  Created by 堤 健 on 11/04/23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Promise;

@interface Action : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * action;
@property (nonatomic, retain) Promise * promise;

@end
