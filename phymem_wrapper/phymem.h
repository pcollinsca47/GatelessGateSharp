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



#ifndef	__PHYMEM_H
#define	__PHYMEM_H


//driver initialize
__declspec(dllexport) BOOL LoadPhyMemDriver();
__declspec(dllexport) VOID UnloadPhyMemDriver();

//map physical memory to user space
PVOID MapPhyMem(DWORD64 phyAddr, DWORD memSize);
VOID  UnmapPhyMem(PVOID pVirAddr, DWORD memSize);

//access port
BYTE  ReadPortByte(WORD portAddr);
WORD  ReadPortWord(WORD portAddr);
DWORD ReadPortLong(WORD portAddr);
VOID  WritePortByte(WORD portAddr, BYTE portValue);
VOID  WritePortWord(WORD portAddr, WORD portValue);
VOID  WritePortLong(WORD portAddr, DWORD portValue);

//access PCI bus
BOOL ReadPCI(DWORD busNum, DWORD devNum, DWORD funcNum,
	DWORD regOff, DWORD bytes, PVOID pValue);
BOOL WritePCI(DWORD busNum, DWORD devNum, DWORD funcNum,
	DWORD regOff, DWORD bytes, PVOID pValue);

#endif	//__PMDLL_H