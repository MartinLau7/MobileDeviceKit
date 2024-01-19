//
//  Header.h
//  
//
//  Created by MartinLau on 06/09/2021.
//

#ifndef Header_h
#define Header_h

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

bool sendMessage2Socket(int socket, CFPropertyListRef message, CFStringRef *errorStr);

#ifdef __cplusplus
}
#endif

#endif /* Header_h */
