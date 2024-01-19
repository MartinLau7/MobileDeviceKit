//
//  wrapper.c
//  
//
//  Created by MartinLau on 12/01/2024.
//

#include "AMDServiceConnection.h"
#include "MobileDeviceError.h"
#include "AMDeviceDiscovery.h"
#include "AMInstallation.h"
#include "MobileDevice.h"
#include "AFCProtocol.h"
#include "AFCClient.h"
#include "AFCTypes.h"
#include "AMDBase.h"
#include "wrapper.h"

#include <mach/error.h>
#include <sys/socket.h>
#include <CoreFoundation/CoreFoundation.h>


// MARK: - Service

bool sendMessage2Socket(int socket, CFPropertyListRef message, CFStringRef *errorStr) {
    CFIndex xmlLength = CFDataGetLength(message);
    uint32_t sz = htonl(xmlLength);
    if (send(socket, &sz, sizeof(sz), 0) != sizeof(sz)) {
        if (errorStr) {
                // kAMDTooBigError
                // Buffer Too Big
            *errorStr = CFSTR("Can't send message size");
        }
    } else {
        if (send(socket, CFDataGetBytePtr(message), xmlLength, 0) != xmlLength) {
            *errorStr = CFSTR("Can't send message text");
        } else {
            return true;
        }
    }
    return false;
}
