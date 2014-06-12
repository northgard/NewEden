// OS-specific networking includes
// -------------------------------
#include <winsock2.h>
typedef int socklen_t;


// Socket used for all communications
SOCKET sock;

// Address of the remote server
SOCKADDR_IN addr;

// Buffer used to return dynamic strings to the caller
#define BUFFER_SIZE 1024
char return_buffer[BUFFER_SIZE];

// exposed functions
// ------------------------------

const char* SUCCESS = "1\0"; // string representing success


#define DLL_EXPORT __declspec(dllexport)


// arg1: ip(in the xx.xx.xx.xx format)
// arg2: port(a short)
// return: NULL on failure, SUCCESS otherwise
extern "C" DLL_EXPORT const char* establish_connection(int n, char *v[])
{
    // extract args
    // ------------
    if(n < 2) return 0;
    const char* ip = v[0];
    const char* port_s = v[1];
    unsigned short port = atoi(port_s);

    // set up network stuff
    // --------------------

    WSADATA wsa;
    WSAStartup(MAKEWORD(2,0),&wsa);

    sock = socket(AF_INET,SOCK_DGRAM,0);

    // make the socket non-blocking
    // ----------------------------

    unsigned long iMode=1;
    ioctlsocket(sock,FIONBIO,&iMode);


    // establish a connection to the server
    // ------------------------------------
    memset(&addr,0,sizeof(SOCKADDR_IN));
    addr.sin_family=AF_INET;
    addr.sin_port=htons(port);

    // convert the string representation of the ip to a byte representation
    addr.sin_addr.s_addr=inet_addr(ip);

    return SUCCESS;
}

// arg1: string message to send
// return: NULL on failure, SUCCESS otherwise
extern "C" DLL_EXPORT const char* send_message(int n, char *v[])
{
    // extract the args
    if(n < 1) return 0;
    const char* msg = v[0];

    // send the message
    int rc = sendto(sock,msg,strlen(msg),0,(SOCKADDR*)&addr,sizeof(SOCKADDR));

    // check for errors
    if (rc != -1) {
       return SUCCESS;
    }
    else {
       return 0;
    }
}

// no args
// return: message if any received, NULL otherwise
extern "C" DLL_EXPORT const char* recv_message(int n, char *v[])
{
    SOCKADDR_IN sender; // we will store the sender address here

    socklen_t sender_byte_length = sizeof(sender);

    // Try receiving messages until we receive one that's valid, or there are no more messages
    while(1) {
        int rc = recvfrom(sock, return_buffer, BUFFER_SIZE,0,(SOCKADDR*) &sender,&sender_byte_length);
        if(rc > 0) {
            // we could read something

            if(sender.sin_addr.s_addr != addr.sin_addr.s_addr) {
                continue; // not our connection, ignore and try again
            } else {
                return_buffer[rc] = 0; // 0-terminate the string
                return return_buffer;
            }
        }
        else {
            break; // no more messages, stop trying to receive
        }
    }

    return 0;
}

