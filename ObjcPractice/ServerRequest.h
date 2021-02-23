//
//  ServerRequest.h
//  ObjcPractice
//
//  Created by Luis Santiago on 21/02/21.
//

#import <Foundation/Foundation.h>
#import "ObjcPractice-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerRequest : NSObject
- (void) fetchReceipts :(void (^)(NSMutableArray *list , NSError * _Nullable  error))onDataRetrieved;
- (void) registerReceipt : (Receipt*)receipt :(void (^)(NSError * _Nullable  error))onServerResponse;

+ sharedServerRequest;

@end

NS_ASSUME_NONNULL_END
