//
//  AMDServiceConnection.h.h
//  LibMobileDevice
//
//  Created by MartinLau on 31/08/2021.
//

#ifndef AMDServiceConnection_h_h
#define AMDServiceConnection_h_h

/*!
 * @header AMDServiceConnection.h
 *
 * Declares interfaces for AMDServiceConnection, which is an opaque MobileDevice
 * object representing a connection to a service agent running on a device.
 * AMDServiceConnections support SSL and raw socket operations.
 *
 * AMDServiceConnections are CF objects.
 */

#if defined(__cplusplus)
extern "C" {
#endif
    
#if defined(__WIN32__)
#if !defined(BOOL)
#define BOOL WINBOOL
#include <winsock2.h>
#undef BOOL
#else
#include <winsock2.h>
#endif
#endif
    
#if defined(__WIN32__)
#include <CoreFoundation.h>
    
    typedef SOCKET AMDNativeSocket;
#define AMDNativeSocketInvalid INVALID_SOCKET
#else
#include <CoreFoundation/CoreFoundation.h>
    
    typedef int AMDNativeSocket;
#define AMDNativeSocketInvalid (-1)
#endif
    
#if XCFARMEWORK
#include <MobileDeviceKit/MobileDevice.h>
#else
#include "MobileDevice.h"
#endif
    
    /*!
     * @function AMDServiceConnectionGetTypeID
     * @abstract Get the type ID for AMDServiceConnection objects.
     * @result The type ID for AMDServiceConnection objects.
     */
    CFTypeID AMDServiceConnectionGetTypeID(void);
    
    /*!
     * @function AMDServiceConnectionCreate
     * @abstract Create an AMDServiceConnection
     * @param nativeSocket The socket
     * @param sslContext The SSL
     * @param options Specify options. Ses discussion for options. May be NULL.
     * @result NULL, or an AMDServiceConnection.
     *
     * @discussion
     * AMDServiceConnections are CF objects. The SSL context and socket are expected
     * to be related.
     *
     * Options:
     *
     * kAMDOptionCloseOnInvalidate - The returned service connection will take
     *ownership of the underlying file descriptor and SSL context. Manually closing
     *the fd or SSL_free()'ing the ssl context will result in an double free()s and
     *close()s when the service connection object is invalidate or ultimately
     *released. Valid values are boolean true or false. By default, this is on.
     */
    AMDServiceConnectionRef AMDServiceConnectionCreate(AMDNativeSocket nativeSocket,
                                                       SSL *sslContext,
                                                       CFDictionaryRef options);
    
    /*!
     * @function AMDServiceConnectionGetSocket
     * @abstract Get the native socket from a service connection.
     * @result AMDNativeSocketInvalid on failure or a real socket.
     *
     * @discussion
     * This function returns a socket suitable for use with select(2).
     *
     * It may also be used to check the validity/connected-ness of a service
     * connection, by comparing the return value to AMDNativeSocketInvalid.
     */
    AMDNativeSocket AMDServiceConnectionGetSocket(AMDServiceConnectionRef serv_conn);
    
    /*!
     * @function AMDServiceConnectionGetSecureIOContext
     * @abstract Get the SSL context associated with a service connection.
     * @result NULL or a real SSL context.
     */
    SSL *AMDServiceConnectionGetSecureIOContext(AMDServiceConnectionRef serv_conn);
    
    /*!
     * @function AMDServiceConnectionSend
     * @abstract Send data over a service connection.
     * @param serv_conn The connection
     * @param buffer The data to be sent
     * @param length The length of the buffer to be sent.
     * @result -1 on failure, or the number of bytes sent.
     *
     * @discussion
     * Has semantics like send(2).
     */
    int AMDServiceConnectionSend(AMDServiceConnectionRef serv_conn,
                                 const void *buffer, size_t length);
    
    /*!
     * @function AMDServiceConnectionReceive
     * @abstract Receive data over a service connection.
     * @param serv_conn The conection
     * @param buffer The buffer to receive data into.
     * @param buffer_length The amount of data to receive. Buffer must be at least
     * this big.
     * @result -1 on failure, 0 if the connection is closed, or the number of bytes
     * sent.
     *
     * @discussion
     * Has semantics like recv(2).
     */
    int AMDServiceConnectionReceive(AMDServiceConnectionRef serv_conn, void *buffer,
                                    size_t buffer_length);
    
    /*!
     * @function AMDServiceConnectionSendMessage
     * @abstract Sends serialized plists over a service connection.
     * @param serv_conn The service connection
     * @param message The message to send
     * @param format Specifies the serialized format to use. Allowable values are
     * kCFPropertyListOpenStepFormat, kCFPropertyListXMLFormat_v1_0, or
     * kCFPropertyListBinaryFormat_v1_0.
     * @param options Specify extra options. See discussion for options. May be
     * NULL.
     * @result kAMDSucess or an error code.
     *
     * @discussion
     * Sends a plist over 'the wire' in the specified serialization format.
     *
     * Currently no options are supported.
     *
     * Returns kAMDInvalidArgumentError if serv_conn is invalid or message is not
     * serializable to the given format. Returns kAMDTooBigError if the serialized
     * form of the message is too big (UINT32_MAX bytes) for the built-in messaging
     * protocol. Returns kAMDDeviceDisconnectedError if the device disconnects
     * during the send. Returns kAMDEOFError if the underlying socket is closed by
     * the peer. Returns kAMDSendMessageError on generic IO errors.
     */
    AMDError AMDServiceConnectionSendMessage(AMDServiceConnectionRef serv_conn,
                                             CFPropertyListRef message,
                                             CFPropertyListFormat format,
                                             CFDictionaryRef options);
    
    /*!
     * @function AMDServiceConnectionReceiveMessage
     * @abstract Receives serialized plists over a service connection.
     * @param serv_conn The service connection to receive data from.
     * @param message On success, the received plist.
     * @param format On success, the format of the received plist (one of
     * kCFPropertyListOpenStepFormat, kCFPropertyListXMLFormat_v1_0, or
     * kCFPropertyListBinaryFormat_v1_0). May be NULL.
     * @result kAMDSuccess or an error code.
     *
     * @discussion
     * Receives a serialized plist and deserializes it. On success, message belongs
     * to the caller and must be CFRelease()d or it will leak.
     *
     * Currently no options are supported.
     *
     * Returns kAMDInvalidArgumentError if serv_conn is invalid or message argument
     * is NULL. Returns kAMDDeviceDisconnectedError if the device disconnects during
     * the receive. Returns kAMDEOFError if the underlying socket is closed by the
     * peer. Returns kAMDReceiveMessageError on generic IO errors. Returns
     * kAMDInvalidResponseError if the data cannot be unserialized. Returns
     * kAMDNoResourcesError if memory can't be allocated.
     */
    AMDError AMDServiceConnectionReceiveMessage(AMDServiceConnectionRef serv_conn,
                                                CFPropertyListRef *message,
                                                CFPropertyListFormat *format);
    
    /*!
     * @function AMDServiceConnectionInvalidate
     * @abstract Invalidates a service connection.
     * @param serv_conn The service connection to invalidate.
     *
     * @discussion
     * Invalidates a service connection, closing all underlying transport
     * mechanisms. All further attempts to perform IO using the service connection
     * object will fail.
     *
     * All attempts to invalidate beyond the first have no effect.
     *
     * To check the validity of a service connection, check that
     * AMDServiceConnectionGetSocket() does not return AMDNativeSocketInvalid.
     */
    void AMDServiceConnectionInvalidate(AMDServiceConnectionRef serv_conn);
    
    /* This gives us more information for debugging purposes. */
    void AMDServiceConnectionSetDevice(AMDServiceConnectionRef serv_conn,
                                       AMDeviceRef device);
    
    /* This gives us more information for debugging purposes. */
    void AMDServiceConnectionSetServiceName(AMDServiceConnectionRef serv_conn,
                                            CFStringRef serviceName);
    
#ifdef __cplusplus
}
#endif

#endif /* AMDServiceConnection_h_h */

