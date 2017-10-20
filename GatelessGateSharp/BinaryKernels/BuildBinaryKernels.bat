@rem In order to build binary kernels, you need:
@rem * CLRadeonExtender ( https://github.com/zawawawa/GCNminC )
@rem * GCNminC ( https://github.com/CLRX/CLRX-mirror )

@rem GCN1: CapeVerde, Pitcairn, Tahiti, Oland, Hainan
@rem GCN2: Bonaire, Hawaii, Mullins
@rem GCN3: Tonga, Fiji, Carrizo
@rem GCN4: Ellesmere, Baffin
@rem ?: Spectre, Spooky, Kalindi, Iceland, Goose, Horse, Stoney

@rem del *.bin

@rem Windows 

clrxasm equihash-gcn1-amdcl-32bit.asm -g CapeVerde -o equihashCapeverdegw256l4.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Pitcairn -o equihashPitcairngw256l4.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Tahiti -o equihashTahitigw256l4.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Oland -o equihashOlandgw256l4.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Hainan -o equihashHainangw256l4.bin

clrxasm ethash-new-gcn1-amdcl-64bit.asm -g CapeVerde -o ethash-newCapeverdegw192l4.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Pitcairn -o ethash-newPitcairngw192l4.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Tahiti -o ethash-newTahitigw192l4.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Oland -o ethash-newOlandgw192l4.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Hainan -o ethash-newHainangw192l4.bin

clrxasm ethash-new-gcn3-amdcl2.asm -g Tonga -o ethash-newTongagw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Fiji -o ethash-newFijigw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Carrizo -o ethash-newCarrizogw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Ellesmere -o ethash-newEllesmeregw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Baffin -o ethash-newBaffingw192l4.bin

clrxasm ethash-new-gcn3-amdcl2.asm -g Iceland -o ethash-newIcelandgw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Goose -o ethash-newGoosegw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Horse -o ethash-newHorsegw192l4.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Stoney -o ethash-newStoneygw192l4.bin

@rem Linux

clrxasm equihash-gcn1-amdcl-32bit.asm -g CapeVerde -o equihashCapeverdegw256l8.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Pitcairn -o equihashPitcairngw256l8.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Tahiti -o equihashTahitigw256l8.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Oland -o equihashOlandgw256l8.bin
clrxasm equihash-gcn1-amdcl-32bit.asm -g Hainan -o equihashHainangw256l8.bin

clrxasm ethash-new-gcn1-amdcl-64bit.asm -g CapeVerde -o ethash-newCapeverdegw192l8.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Pitcairn -o ethash-newPitcairngw192l8.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Tahiti -o ethash-newTahitigw192l8.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Oland -o ethash-newOlandgw192l8.bin
clrxasm ethash-new-gcn1-amdcl-64bit.asm -g Hainan -o ethash-newHainangw192l8.bin

clrxasm ethash-new-gcn3-amdcl2.asm -g Tonga -o ethash-newTongagw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Fiji -o ethash-newFijigw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Carrizo -o ethash-newCarrizogw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Ellesmere -o ethash-newEllesmeregw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Baffin -o ethash-newBaffingw192l8.bin

clrxasm ethash-new-gcn3-amdcl2.asm -g Iceland -o ethash-newIcelandgw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Goose -o ethash-newGoosegw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Horse -o ethash-newHorsegw192l8.bin
clrxasm ethash-new-gcn3-amdcl2.asm -g Stoney -o ethash-newStoneygw192l8.bin

pause
