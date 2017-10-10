#ifndef	__PHYMEM_H
#define	__PHYMEM_H


#ifdef __cplusplus
extern "C"
{
#endif

	//driver initialize
	BOOL LoadPhyMemDriver();
	VOID UnloadPhyMemDriver();

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

#ifdef __cplusplus
}
#endif

#endif	//__PMDLL_H