//
// pch.h
// Header for standard system include files.
//

#pragma once

#include "targetver.h"

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
#endif

#undef WINAPI_FAMILY
#define WINAPI_FAMILY_DESKTOP_APP

#define _CRT_SECURE_NO_WARNINGS

// Windows Header Files:
#include <windows.h>
#include <VersionHelpers.h>
#include <winioctl.h>

#include <inttypes.h>
#include <mutex>

