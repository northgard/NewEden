#define DLL_EXPORT __declspec(dllexport)
#include <iostream>
#include <cstring>
#include <string>
#include <windows.h>


// arg1: Path to python script
extern "C" DLL_EXPORT void run_python(int n, char *v[])
{
    // extract args
    // ------------
    std::string script = v[0];
    std::string arguments = "";
    if(n > 1) arguments = v[1];

    system(("pythonw "+script +" "+ arguments).std::string::c_str());


    return;
}
