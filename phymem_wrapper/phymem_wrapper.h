// Copyright 2017 Yurio Miyazawa (a.k.a zawawa)
//
// This file is part of Gateless Gate #.
//
// Gateless Gate # is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Gateless Gate # is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Gateless Gate #.  If not, see <http://www.gnu.org/licenses/>.



#pragma once

#ifndef __PHYMEM_LIB_H
#define __PHYMEM_LIB_H

#define	FILE_DEVICE_PHYMEM	0x8000

#define IOCTL_PHYMEM_MAP	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x800,\
			 METHOD_BUFFERED, FILE_ANY_ACCESS)

#define IOCTL_PHYMEM_UNMAP	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x801,\
			 METHOD_BUFFERED, FILE_ANY_ACCESS)

#define	IOCTL_PHYMEM_GETPORT	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x802,\
			 METHOD_BUFFERED, FILE_ANY_ACCESS)

#define	IOCTL_PHYMEM_SETPORT	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x803,\
			 METHOD_BUFFERED, FILE_ANY_ACCESS)

#define	IOCTL_PHYMEM_GETPCI	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x804,\
			 METHOD_OUT_DIRECT, FILE_ANY_ACCESS)

#define	IOCTL_PHYMEM_SETPCI	\
	CTL_CODE(FILE_DEVICE_PHYMEM, 0x805,\
			 METHOD_OUT_DIRECT, FILE_ANY_ACCESS)

typedef struct tagPHYMEM_MEM
{
	PVOID pvAddr;	//physical addr when mapping, virtual addr when unmapping
	ULONG dwSize;	//memory size to map or unmap
} PHYMEM_MEM, *PPHYMEM_MEM;

typedef struct tagPHYMEM_PORT
{
	ULONG dwPort;	//port number: 0-0xFFFF
	ULONG dwSize;	//must be 1, 2, 4
	ULONG dwValue;	//new value to set
} PHYMEM_PORT, *PPHYMEM_PORT;

typedef struct tagPHYMEM_PCI
{
	ULONG dwBusNum;		//bus number: 0-255
	ULONG dwDevNum;		//device number: 0-31
	ULONG dwFuncNum;	//function number: 0-7
	ULONG dwRegOff;		//register offset: 0-255
	ULONG dwBytes;		//bytes to read or write
} PHYMEM_PCI, *PPHYMEM_PCI;

#endif	//__PHYMEM_H
