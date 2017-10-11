// dllmain.cpp : Defines the entry point for the DLL application.
#include <Windows.h>

extern "C" CRITICAL_SECTION phymem_mutex;

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{
	InitializeCriticalSection(&phymem_mutex);;

	switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

