//
//  AOSUtilities.h
//  AOSKit
//
//  Created by Martin Lau on 09/09/2021.
//

#ifndef AOSUtilities_h
#define AOSUtilities_h

#import <Foundation/Foundation.h>

@interface AOSUtilities : NSObject

+ (id)currentComputerName;
+ (id)machineUDID;
+ (id)machineSerialNumber;
+ (id)retrieveOTPHeadersForDSID:(id)arg1;
    //+ (id)agentSessionInfo;
    //+ (id)currentProcessIdentifier;
    //+ (id)currentProcessName;
    //+ (BOOL)_isValidChineseHostname:(id)arg1;
    //+ (BOOL)currentUserIsAdmin;
    //+ (void)initialize;
@end

#endif /* AOSUtilities_h */
