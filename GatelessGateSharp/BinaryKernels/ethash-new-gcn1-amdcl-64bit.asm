/*
** Gateless Gate, a Zcash miner
** Copyright 2016-2017 zawawa @ bitcointalk.org
**
** The initial version of this software was based on:
** SILENTARMY v5
** The MIT License (MIT) Copyright (c) 2016 Marc Bevand, Genoil, eXtremal
**
** This program is free software : you can redistribute it and / or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
** 
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
** GNU General Public License for more details.
** 
** You should have received a copy of the GNU General Public License
** along with this program. If not, see <http://www.gnu.org/licenses/>.
**/



.amd
.64bit
.driver_info "@(#) OpenCL 1.2 AMD-APP (2117.14).  Driver version: 2117.14 (VM)"
.globaldata
    .byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x82, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x8a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .byte 0x8b, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .byte 0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .byte 0x09, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x8a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x88, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x09, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .byte 0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .byte 0x8b, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .byte 0x8b, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x89, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x03, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x02, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x0a, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .byte 0x0a, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .byte 0x81, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
    .byte 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80
    .byte 0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00
    .byte 0x08, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00, 0x80
.kernel search
    .config
        .dims x
        .cws 192, 1, 1
        .sgprsnum 34
        .vgprsnum 91
        .hwlocal 3840
        .floatmode 0xc0
        .uavid 11
        .uavprivate 224
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00078098
        .useconstdata
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg g_output, "uint*", uint*, global, restrict volatile, 12
        .arg g_header, "uint2*", uint2*, constant, const, 0, 13
        .arg _g_dag, "ulong8*", ulong8*, global, const, 14
        .arg DAG_SIZE, "uint", uint
        .arg start_nonce, "ulong", ulong
        .arg target, "ulong", ulong
        .arg isolate, "uint", uint
    .text
/*befc03ff 00008000*/ s_mov_b32       m0, 0x8000
/*c2000518         */ s_buffer_load_dword s0, s[4:7], 0x18
/*c0880368         */ s_load_dwordx4  s[16:19], s[2:3], 0x68
/*c2470904         */ s_buffer_load_dwordx2 s[14:15], s[8:11], 0x4
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*c2490910         */ s_buffer_load_dwordx2 s[18:19], s[8:11], 0x10
/*b80c00c0         */ s_mulk_i32      s12, 0xc0
/*8000000c         */ s_add_u32       s0, s12, s0
/*9381ff11 00100000*/ s_bfe_u32       s1, s17, 0x100000
/*4a020000         */ v_add_i32       v1, vcc, s0, v0
/*be800310         */ s_mov_b32       s0, s16
/*80000e00         */ s_add_u32       s0, s0, s14
/*82010f01         */ s_addc_u32      s1, s1, s15
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d24a6a09 00002501*/ v_add_i32       v9, vcc, v1, s18
/*7e060213         */ v_mov_b32       v3, s19
/*50140680         */ v_addc_u32      v10, vcc, 0, v3, vcc
/*7e080300         */ v_mov_b32       v4, v0
/*7e0a0280         */ v_mov_b32       v5, 0
/*d2c40004 00010504*/ v_lshr_b64      v[4:5], v[4:5], 2
/*c2420520         */ s_buffer_load_dwordx2 s[4:5], s[4:7], 0x20
/*c2430900         */ s_buffer_load_dwordx2 s[6:7], s[8:11], 0x0
/*c2460908         */ s_buffer_load_dwordx2 s[12:13], s[8:11], 0x8
/*c207090c         */ s_buffer_load_dword s14, s[8:11], 0xc
/*c2480914         */ s_buffer_load_dwordx2 s[16:17], s[8:11], 0x14
/*c2040918         */ s_buffer_load_dword s8, s[8:11], 0x18
/*c08a0100         */ s_load_dwordx4  s[20:23], s[0:1], 0x0
/*c08c0104         */ s_load_dwordx4  s[24:27], s[0:1], 0x4
/*c08e0350         */ s_load_dwordx4  s[28:31], s[2:3], 0x50
/*340a0886         */ v_lshlrev_b32   v5, 6, v4
/*360c0083         */ v_and_b32       v6, 3, v0
/*7e040280         */ v_mov_b32       v2, 0
/*7e0602ff 80000000*/ v_mov_b32       v3, 0x80000000
/*7e920280         */ v_mov_b32       v73, 0
/*7e100280         */ v_mov_b32       v8, 0
/*b0000000         */ s_movk_i32      s0, 0x0
/*7e940280         */ v_mov_b32       v74, 0
/*7e960280         */ v_mov_b32       v75, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7e980214         */ v_mov_b32       v76, s20
/*7e9a0215         */ v_mov_b32       v77, s21
/*7e1e0216         */ v_mov_b32       v15, s22
/*7e200217         */ v_mov_b32       v16, s23
/*7e22021a         */ v_mov_b32       v17, s26
/*7e24021b         */ v_mov_b32       v18, s27
/*7e260218         */ v_mov_b32       v19, s24
/*7e280219         */ v_mov_b32       v20, s25
/*7e2a0281         */ v_mov_b32       v21, 1
/*7e2c0280         */ v_mov_b32       v22, 0
/*7e9c0280         */ v_mov_b32       v78, 0
/*7e9e0280         */ v_mov_b32       v79, 0
/*7e320280         */ v_mov_b32       v25, 0
/*7e340280         */ v_mov_b32       v26, 0
/*7ea00280         */ v_mov_b32       v80, 0
/*7e380280         */ v_mov_b32       v28, 0
/*7e3a0280         */ v_mov_b32       v29, 0
/*7e3c0280         */ v_mov_b32       v30, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*7e900280         */ v_mov_b32       v72, 0
/*7ea40280         */ v_mov_b32       v82, 0
/*7ea60280         */ v_mov_b32       v83, 0
/*7ea80280         */ v_mov_b32       v84, 0
/*7e2e0280         */ v_mov_b32       v23, 0
/*7e4a0280         */ v_mov_b32       v37, 0
/*7e4c0280         */ v_mov_b32       v38, 0
/*7eaa0280         */ v_mov_b32       v85, 0
/*7eac0280         */ v_mov_b32       v86, 0
/*7e520280         */ v_mov_b32       v41, 0
/*7e540280         */ v_mov_b32       v42, 0
/*7e420280         */ v_mov_b32       v33, 0
/*7e8e0280         */ v_mov_b32       v71, 0
/*7e0e0280         */ v_mov_b32       v7, 0
/*7e5a0280         */ v_mov_b32       v45, 0
/*7eae0280         */ v_mov_b32       v87, 0
/*7eb00280         */ v_mov_b32       v88, 0
/*7e620280         */ v_mov_b32       v49, 0
/*7e640280         */ v_mov_b32       v50, 0
/*7e660280         */ v_mov_b32       v51, 0
/*7e160280         */ v_mov_b32       v11, 0
/*7e6a0280         */ v_mov_b32       v53, 0
/*7e5c0280         */ v_mov_b32       v46, 0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
.L352_0:
/*bf029600         */ s_cmp_gt_i32    s0, 22
/*bf850195         */ s_cbranch_scc1  .L1980_0
/*bf008008         */ s_cmp_eq_i32    s8, 0
/*bf85fffc         */ s_cbranch_scc1  .L352_0
/*3a6eaf09         */ v_xor_b32       v55, v9, v87
/*3a70b10a         */ v_xor_b32       v56, v10, v88
/*3a6e6f31         */ v_xor_b32       v55, v49, v55
/*3a707132         */ v_xor_b32       v56, v50, v56
/*3a6e6f33         */ v_xor_b32       v55, v51, v55
/*3a70710b         */ v_xor_b32       v56, v11, v56
/*3a6e6f35         */ v_xor_b32       v55, v53, v55
/*3a70712e         */ v_xor_b32       v56, v46, v56
/*d29c0039 027e7137*/ v_alignbit_b32  v57, v55, v56, 31
/*d29c003a 027e6f38*/ v_alignbit_b32  v58, v56, v55, 31
/*3a763b13         */ v_xor_b32       v59, v19, v29
/*3a783d14         */ v_xor_b32       v60, v20, v30
/*3a767751         */ v_xor_b32       v59, v81, v59
/*3a787948         */ v_xor_b32       v60, v72, v60
/*3a767749         */ v_xor_b32       v59, v73, v59
/*3a787908         */ v_xor_b32       v60, v8, v60
/*3a767752         */ v_xor_b32       v59, v82, v59
/*3a787953         */ v_xor_b32       v60, v83, v60
/*3a727739         */ v_xor_b32       v57, v57, v59
/*3a74793a         */ v_xor_b32       v58, v58, v60
/*3a7a7321         */ v_xor_b32       v61, v33, v57
/*3a7c7547         */ v_xor_b32       v62, v71, v58
/*d29c003f 022e7d3d*/ v_alignbit_b32  v63, v61, v62, 11
/*d29c003d 022e7b3e*/ v_alignbit_b32  v61, v62, v61, 11
/*d29c003e 027e793b*/ v_alignbit_b32  v62, v59, v60, 31
/*d29c003b 027e773c*/ v_alignbit_b32  v59, v60, v59, 31
/*3a782b4c         */ v_xor_b32       v60, v76, v21
/*3a802d4d         */ v_xor_b32       v64, v77, v22
/*3a78794e         */ v_xor_b32       v60, v78, v60
/*3a80814f         */ v_xor_b32       v64, v79, v64
/*3a787919         */ v_xor_b32       v60, v25, v60
/*3a80811a         */ v_xor_b32       v64, v26, v64
/*3a787950         */ v_xor_b32       v60, v80, v60
/*3a80811c         */ v_xor_b32       v64, v28, v64
/*3a7c793e         */ v_xor_b32       v62, v62, v60
/*3a76813b         */ v_xor_b32       v59, v59, v64
/*3a827d54         */ v_xor_b32       v65, v84, v62
/*3a847717         */ v_xor_b32       v66, v23, v59
/*d29c0043 02528342*/ v_alignbit_b32  v67, v66, v65, 20
/*d29c0041 02528541*/ v_alignbit_b32  v65, v65, v66, 20
/*3a84873f         */ v_xor_b32       v66, v63, v67
/*3a88833d         */ v_xor_b32       v68, v61, v65
/*3a8a2302         */ v_xor_b32       v69, v2, v17
/*3a8c2503         */ v_xor_b32       v70, v3, v18
/*3a8a8b4a         */ v_xor_b32       v69, v74, v69
/*3a8c8d4b         */ v_xor_b32       v70, v75, v70
/*3a568b21         */ v_xor_b32       v43, v33, v69
/*3a588d47         */ v_xor_b32       v44, v71, v70
/*3a565707         */ v_xor_b32       v43, v7, v43
/*3a58592d         */ v_xor_b32       v44, v45, v44
/*d29c0045 027e592b*/ v_alignbit_b32  v69, v43, v44, 31
/*d29c0046 027e572c*/ v_alignbit_b32  v70, v44, v43, 31
/*3a46a90f         */ v_xor_b32       v35, v15, v84
/*3a482f10         */ v_xor_b32       v36, v16, v23
/*3a464725         */ v_xor_b32       v35, v37, v35
/*3a484926         */ v_xor_b32       v36, v38, v36
/*3a464755         */ v_xor_b32       v35, v85, v35
/*3a484956         */ v_xor_b32       v36, v86, v36
/*3a464729         */ v_xor_b32       v35, v41, v35
/*3a48492a         */ v_xor_b32       v36, v42, v36
/*3a8a4745         */ v_xor_b32       v69, v69, v35
/*3a8c4946         */ v_xor_b32       v70, v70, v36
/*3a3e8b51         */ v_xor_b32       v31, v81, v69
/*3a408d48         */ v_xor_b32       v32, v72, v70
/*d29c0047 02563f20*/ v_alignbit_b32  v71, v32, v31, 21
/*d29c001f 0256411f*/ v_alignbit_b32  v31, v31, v32, 21
/*d2940020 050a8747*/ v_bfi_b32       v32, v71, v67, v66
/*d2940042 0512831f*/ v_bfi_b32       v66, v31, v65, v68
/*d29c0044 027e4923*/ v_alignbit_b32  v68, v35, v36, 31
/*d29c0023 027e4724*/ v_alignbit_b32  v35, v36, v35, 31
/*3a488937         */ v_xor_b32       v36, v55, v68
/*3a464738         */ v_xor_b32       v35, v56, v35
/*3a1a494c         */ v_xor_b32       v13, v76, v36
/*3a1c474d         */ v_xor_b32       v14, v77, v35
/*3a6e1b47         */ v_xor_b32       v55, v71, v13
/*3a701d1f         */ v_xor_b32       v56, v31, v14
/*d2940037 04de1b43*/ v_bfi_b32       v55, v67, v13, v55
/*d2940038 04e21d41*/ v_bfi_b32       v56, v65, v14, v56
/*91019f00         */ s_ashr_i32      s1, s0, 31
/*8f8a8300         */ s_lshl_b64      s[10:11], s[0:1], 3
/*800a0a04         */ s_add_u32       s10, s4, s10
/*820b0b05         */ s_addc_u32      s11, s5, s11
/*9393ff1d 00100000*/ s_bfe_u32       s19, s29, 0x100000
/*be92031c         */ s_mov_b32       s18, s28
/*800a0a12         */ s_add_u32       s10, s18, s10
/*820b0b13         */ s_addc_u32      s11, s19, s11
/*c0450b00         */ s_load_dwordx2  s[10:11], s[10:11], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*3a986e0a         */ v_xor_b32       v76, s10, v55
/*3a9a700b         */ v_xor_b32       v77, s11, v56
/*d29c0044 027e813c*/ v_alignbit_b32  v68, v60, v64, 31
/*d29c003c 027e7940*/ v_alignbit_b32  v60, v64, v60, 31
/*3a56892b         */ v_xor_b32       v43, v43, v68
/*3a58792c         */ v_xor_b32       v44, v44, v60
/*3a6a5735         */ v_xor_b32       v53, v53, v43
/*3a6c592e         */ v_xor_b32       v54, v46, v44
/*d29c003c 024a6d35*/ v_alignbit_b32  v60, v53, v54, 18
/*d29c0035 024a6b36*/ v_alignbit_b32  v53, v54, v53, 18
/*3a6c1b3f         */ v_xor_b32       v54, v63, v13
/*3a801d3d         */ v_xor_b32       v64, v61, v14
/*d2940036 04da7f3c*/ v_bfi_b32       v54, v60, v63, v54
/*d2940040 05027b35*/ v_bfi_b32       v64, v53, v61, v64
/*3a887947         */ v_xor_b32       v68, v71, v60
/*3a906b1f         */ v_xor_b32       v72, v31, v53
/*d294003f 05128f3f*/ v_bfi_b32       v63, v63, v71, v68
/*d294001f 05223f3d*/ v_bfi_b32       v31, v61, v31, v72
/*3a2e494e         */ v_xor_b32       v23, v78, v36
/*3a30474f         */ v_xor_b32       v24, v79, v35
/*d29c003d 02763117*/ v_alignbit_b32  v61, v23, v24, 29
/*d29c0017 02762f18*/ v_alignbit_b32  v23, v24, v23, 29
/*3a227311         */ v_xor_b32       v17, v17, v57
/*3a247512         */ v_xor_b32       v18, v18, v58
/*d29c0018 02122511*/ v_alignbit_b32  v24, v17, v18, 4
/*d29c0011 02122312*/ v_alignbit_b32  v17, v18, v17, 4
/*3a24313d         */ v_xor_b32       v18, v61, v24
/*3a882317         */ v_xor_b32       v68, v23, v17
/*3a5e5757         */ v_xor_b32       v47, v87, v43
/*3a605958         */ v_xor_b32       v48, v88, v44
/*d29c0047 0232612f*/ v_alignbit_b32  v71, v47, v48, 12
/*d29c002f 02325f30*/ v_alignbit_b32  v47, v48, v47, 12
/*d2940012 044a3147*/ v_bfi_b32       v18, v71, v24, v18
/*d2940030 0512232f*/ v_bfi_b32       v48, v47, v17, v68
/*3a867943         */ v_xor_b32       v67, v67, v60
/*3a826b41         */ v_xor_b32       v65, v65, v53
/*d294000d 050e790d*/ v_bfi_b32       v13, v13, v60, v67
/*d294000e 05066b0e*/ v_bfi_b32       v14, v14, v53, v65
/*3a428b52         */ v_xor_b32       v33, v82, v69
/*3a448d53         */ v_xor_b32       v34, v83, v70
/*d29c0035 020e4322*/ v_alignbit_b32  v53, v34, v33, 3
/*d29c0021 020e4521*/ v_alignbit_b32  v33, v33, v34, 3
/*3a446b3d         */ v_xor_b32       v34, v61, v53
/*3a784317         */ v_xor_b32       v60, v23, v33
/*3a4e7d55         */ v_xor_b32       v39, v85, v62
/*3a507756         */ v_xor_b32       v40, v86, v59
/*d29c0041 024e4f28*/ v_alignbit_b32  v65, v40, v39, 19
/*d29c0027 024e5127*/ v_alignbit_b32  v39, v39, v40, 19
/*d2940022 048a7b41*/ v_bfi_b32       v34, v65, v61, v34
/*d2940028 04f22f27*/ v_bfi_b32       v40, v39, v23, v60
/*3a788347         */ v_xor_b32       v60, v71, v65
/*3a864f2f         */ v_xor_b32       v67, v47, v39
/*d2940054 04f28f3d*/ v_bfi_b32       v84, v61, v71, v60
/*d2940017 050e5f17*/ v_bfi_b32       v23, v23, v47, v67
/*3a7a6b47         */ v_xor_b32       v61, v71, v53
/*3a5e432f         */ v_xor_b32       v47, v47, v33
/*d2940057 04f66b18*/ v_bfi_b32       v87, v24, v53, v61
/*d2940058 04be4311*/ v_bfi_b32       v88, v17, v33, v47
/*3a308318         */ v_xor_b32       v24, v24, v65
/*3a224f11         */ v_xor_b32       v17, v17, v39
/*d2940018 04628335*/ v_bfi_b32       v24, v53, v65, v24
/*d2940011 04464f21*/ v_bfi_b32       v17, v33, v39, v17
/*3a425733         */ v_xor_b32       v33, v51, v43
/*3a4e590b         */ v_xor_b32       v39, v11, v44
/*d29c0033 02624f21*/ v_alignbit_b32  v51, v33, v39, 24
/*d29c0021 02624327*/ v_alignbit_b32  v33, v39, v33, 24
/*3a3a8b1d         */ v_xor_b32       v29, v29, v69
/*3a3c8d1e         */ v_xor_b32       v30, v30, v70
/*d29c0027 026a3d1d*/ v_alignbit_b32  v39, v29, v30, 26
/*d29c001d 026a3b1e*/ v_alignbit_b32  v29, v30, v29, 26
/*3a3c4f33         */ v_xor_b32       v30, v51, v39
/*3a683b21         */ v_xor_b32       v52, v33, v29
/*3a16734a         */ v_xor_b32       v11, v74, v57
/*3a18754b         */ v_xor_b32       v12, v75, v58
/*d29c0035 021e190b*/ v_alignbit_b32  v53, v11, v12, 7
/*d29c000b 021e170c*/ v_alignbit_b32  v11, v12, v11, 7
/*d294000c 047a4f35*/ v_bfi_b32       v12, v53, v39, v30
/*d294001e 04d23b0b*/ v_bfi_b32       v30, v11, v29, v52
/*3a1e7d0f         */ v_xor_b32       v15, v15, v62
/*3a207710         */ v_xor_b32       v16, v16, v59
/*d29c0034 027e210f*/ v_alignbit_b32  v52, v15, v16, 31
/*d29c000f 027e1f10*/ v_alignbit_b32  v15, v16, v15, 31
/*3a206935         */ v_xor_b32       v16, v53, v52
/*3a821f0b         */ v_xor_b32       v65, v11, v15
/*d294004e 04426927*/ v_bfi_b32       v78, v39, v52, v16
/*d294004f 05061f1d*/ v_bfi_b32       v79, v29, v15, v65
/*3a866933         */ v_xor_b32       v67, v51, v52
/*3a881f21         */ v_xor_b32       v68, v33, v15
/*3a364950         */ v_xor_b32       v27, v80, v36
/*3a38471c         */ v_xor_b32       v28, v28, v35
/*d29c0047 023a391b*/ v_alignbit_b32  v71, v27, v28, 14
/*d29c001b 023a371c*/ v_alignbit_b32  v27, v28, v27, 14
/*d294004a 050e6747*/ v_bfi_b32       v74, v71, v51, v67
/*d294004b 0512431b*/ v_bfi_b32       v75, v27, v33, v68
/*3a888f35         */ v_xor_b32       v68, v53, v71
/*3a90370b         */ v_xor_b32       v72, v11, v27
/*d2940051 05126b33*/ v_bfi_b32       v81, v51, v53, v68
/*d2940048 05221721*/ v_bfi_b32       v72, v33, v11, v72
/*3a427d25         */ v_xor_b32       v33, v37, v62
/*3a4a7726         */ v_xor_b32       v37, v38, v59
/*d29c0026 025a4b21*/ v_alignbit_b32  v38, v33, v37, 22
/*d29c0021 025a4325*/ v_alignbit_b32  v33, v37, v33, 22
/*3a125709         */ v_xor_b32       v9, v9, v43
/*3a14590a         */ v_xor_b32       v10, v10, v44
/*d29c0025 02161509*/ v_alignbit_b32  v37, v9, v10, 5
/*d29c0009 0216130a*/ v_alignbit_b32  v9, v10, v9, 5
/*3a144b26         */ v_xor_b32       v10, v38, v37
/*3a6a1321         */ v_xor_b32       v53, v33, v9
/*3a2a4915         */ v_xor_b32       v21, v21, v36
/*3a2c4716         */ v_xor_b32       v22, v22, v35
/*d29c0044 02722b16*/ v_alignbit_b32  v68, v22, v21, 28
/*d29c0015 02722d15*/ v_alignbit_b32  v21, v21, v22, 28
/*d294000a 042a4b44*/ v_bfi_b32       v10, v68, v37, v10
/*d2940016 04d61315*/ v_bfi_b32       v22, v21, v9, v53
/*3a4e8f27         */ v_xor_b32       v39, v39, v71
/*3a3a371d         */ v_xor_b32       v29, v29, v27
/*d2940027 049e8f34*/ v_bfi_b32       v39, v52, v71, v39
/*d294000f 0476370f*/ v_bfi_b32       v15, v15, v27, v29
/*3a367307         */ v_xor_b32       v27, v7, v57
/*3a3a752d         */ v_xor_b32       v29, v45, v58
/*d29c002d 0222371d*/ v_alignbit_b32  v45, v29, v27, 8
/*d29c001b 02223b1b*/ v_alignbit_b32  v27, v27, v29, 8
/*3a3a5b26         */ v_xor_b32       v29, v38, v45
/*3a5c3721         */ v_xor_b32       v46, v33, v27
/*3a0e8b49         */ v_xor_b32       v7, v73, v69
/*3a108d08         */ v_xor_b32       v8, v8, v70
/*d29c0034 02461107*/ v_alignbit_b32  v52, v7, v8, 17
/*d29c0007 02460f08*/ v_alignbit_b32  v7, v8, v7, 17
/*d2940049 04764d34*/ v_bfi_b32       v73, v52, v38, v29
/*d2940008 04ba4307*/ v_bfi_b32       v8, v7, v33, v46
/*3a5c6944         */ v_xor_b32       v46, v68, v52
/*3a6a0f15         */ v_xor_b32       v53, v21, v7
/*d2940055 04ba8926*/ v_bfi_b32       v85, v38, v68, v46
/*d2940056 04d62b21*/ v_bfi_b32       v86, v33, v21, v53
/*3a5c5b44         */ v_xor_b32       v46, v68, v45
/*3a2a3715         */ v_xor_b32       v21, v21, v27
/*d2940033 04ba5b25*/ v_bfi_b32       v51, v37, v45, v46
/*d294000b 04563709*/ v_bfi_b32       v11, v9, v27, v21
/*3a4a6925         */ v_xor_b32       v37, v37, v52
/*3a120f09         */ v_xor_b32       v9, v9, v7
/*d2940021 0496692d*/ v_bfi_b32       v33, v45, v52, v37
/*d2940047 04260f1b*/ v_bfi_b32       v71, v27, v7, v9
/*3a124919         */ v_xor_b32       v9, v25, v36
/*3a32471a         */ v_xor_b32       v25, v26, v35
/*d29c001a 025e1319*/ v_alignbit_b32  v26, v25, v9, 23
/*d29c0009 025e3309*/ v_alignbit_b32  v9, v9, v25, 23
/*3a047302         */ v_xor_b32       v2, v2, v57
/*3a067503         */ v_xor_b32       v3, v3, v58
/*d29c0019 02260503*/ v_alignbit_b32  v25, v3, v2, 9
/*d29c0002 02260702*/ v_alignbit_b32  v2, v2, v3, 9
/*3a06331a         */ v_xor_b32       v3, v26, v25
/*3a360509         */ v_xor_b32       v27, v9, v2
/*3a465731         */ v_xor_b32       v35, v49, v43
/*3a485932         */ v_xor_b32       v36, v50, v44
/*d29c002b 02664724*/ v_alignbit_b32  v43, v36, v35, 25
/*d29c0023 02664923*/ v_alignbit_b32  v35, v35, v36, 25
/*d2940003 040e332b*/ v_bfi_b32       v3, v43, v25, v3
/*d294001b 046e0523*/ v_bfi_b32       v27, v35, v2, v27
/*3a268b13         */ v_xor_b32       v19, v19, v69
/*3a288d14         */ v_xor_b32       v20, v20, v70
/*d29c0024 020a2714*/ v_alignbit_b32  v36, v20, v19, 2
/*d29c0013 020a2913*/ v_alignbit_b32  v19, v19, v20, 2
/*3a28492b         */ v_xor_b32       v20, v43, v36
/*3a582723         */ v_xor_b32       v44, v35, v19
/*d2940050 04524919*/ v_bfi_b32       v80, v25, v36, v20
/*d294001c 04b22702*/ v_bfi_b32       v28, v2, v19, v44
/*3a5a491a         */ v_xor_b32       v45, v26, v36
/*3a622709         */ v_xor_b32       v49, v9, v19
/*3a527d29         */ v_xor_b32       v41, v41, v62
/*3a54772a         */ v_xor_b32       v42, v42, v59
/*d29c0032 027a5529*/ v_alignbit_b32  v50, v41, v42, 30
/*d29c0029 027a532a*/ v_alignbit_b32  v41, v42, v41, 30
/*d2940007 04b63532*/ v_bfi_b32       v7, v50, v26, v45
/*d294002d 04c61329*/ v_bfi_b32       v45, v41, v9, v49
/*3a62652b         */ v_xor_b32       v49, v43, v50
/*3a685323         */ v_xor_b32       v52, v35, v41
/*d2940052 04c6571a*/ v_bfi_b32       v82, v26, v43, v49
/*d2940053 04d24709*/ v_bfi_b32       v83, v9, v35, v52
/*3a326519         */ v_xor_b32       v25, v25, v50
/*3a045302         */ v_xor_b32       v2, v2, v41
/*d2940035 04666524*/ v_bfi_b32       v53, v36, v50, v25
/*d294002e 040a5313*/ v_bfi_b32       v46, v19, v41, v2
/*80008100         */ s_add_u32       s0, s0, 1
/*7e040318         */ v_mov_b32       v2, v24
/*7e12030d         */ v_mov_b32       v9, v13
/*7e200342         */ v_mov_b32       v16, v66
/*7e26033f         */ v_mov_b32       v19, v63
/*7e28031f         */ v_mov_b32       v20, v31
/*7e2a0312         */ v_mov_b32       v21, v18
/*7e32030a         */ v_mov_b32       v25, v10
/*7e340316         */ v_mov_b32       v26, v22
/*7e3a0322         */ v_mov_b32       v29, v34
/*7e4a030c         */ v_mov_b32       v37, v12
/*7e4c031e         */ v_mov_b32       v38, v30
/*7e520303         */ v_mov_b32       v41, v3
/*7e54031b         */ v_mov_b32       v42, v27
/*7e620327         */ v_mov_b32       v49, v39
/*7e64030f         */ v_mov_b32       v50, v15
/*7e060311         */ v_mov_b32       v3, v17
/*7e14030e         */ v_mov_b32       v10, v14
/*7e1e0320         */ v_mov_b32       v15, v32
/*7e220336         */ v_mov_b32       v17, v54
/*7e240340         */ v_mov_b32       v18, v64
/*7e2c0330         */ v_mov_b32       v22, v48
/*7e3c0328         */ v_mov_b32       v30, v40
/*bf82fe69         */ s_branch        .L352_0
.L1980_0:
/*3a6ea90f         */ v_xor_b32       v55, v15, v84
/*3a702f10         */ v_xor_b32       v56, v16, v23
/*3a4a6f25         */ v_xor_b32       v37, v37, v55
/*3a4c7126         */ v_xor_b32       v38, v38, v56
/*3a4a4b55         */ v_xor_b32       v37, v85, v37
/*3a4c4d56         */ v_xor_b32       v38, v86, v38
/*3a4a4b29         */ v_xor_b32       v37, v41, v37
/*3a4c4d2a         */ v_xor_b32       v38, v42, v38
/*d29c0029 027e4d25*/ v_alignbit_b32  v41, v37, v38, 31
/*d29c002a 027e4b26*/ v_alignbit_b32  v42, v38, v37, 31
/*3a12af09         */ v_xor_b32       v9, v9, v87
/*3a14b10a         */ v_xor_b32       v10, v10, v88
/*3a121331         */ v_xor_b32       v9, v49, v9
/*3a141532         */ v_xor_b32       v10, v50, v10
/*3a121333         */ v_xor_b32       v9, v51, v9
/*3a14150b         */ v_xor_b32       v10, v11, v10
/*3a121335         */ v_xor_b32       v9, v53, v9
/*3a14152e         */ v_xor_b32       v10, v46, v10
/*3a525309         */ v_xor_b32       v41, v9, v41
/*3a54550a         */ v_xor_b32       v42, v10, v42
/*3a2a2b4c         */ v_xor_b32       v21, v76, v21
/*3a2c2d4d         */ v_xor_b32       v22, v77, v22
/*3a2a2b4e         */ v_xor_b32       v21, v78, v21
/*3a2c2d4f         */ v_xor_b32       v22, v79, v22
/*3a2a2b19         */ v_xor_b32       v21, v25, v21
/*3a2c2d1a         */ v_xor_b32       v22, v26, v22
/*3a2a2b50         */ v_xor_b32       v21, v80, v21
/*3a2c2d1c         */ v_xor_b32       v22, v28, v22
/*d29c0019 027e2d15*/ v_alignbit_b32  v25, v21, v22, 31
/*d29c001a 027e2b16*/ v_alignbit_b32  v26, v22, v21, 31
/*3a042302         */ v_xor_b32       v2, v2, v17
/*3a062503         */ v_xor_b32       v3, v3, v18
/*3a04054a         */ v_xor_b32       v2, v74, v2
/*3a06074b         */ v_xor_b32       v3, v75, v3
/*3a040521         */ v_xor_b32       v2, v33, v2
/*3a060747         */ v_xor_b32       v3, v71, v3
/*3a040507         */ v_xor_b32       v2, v7, v2
/*3a06072d         */ v_xor_b32       v3, v45, v3
/*3a163302         */ v_xor_b32       v11, v2, v25
/*3a183503         */ v_xor_b32       v12, v3, v26
/*d29c0019 027e0702*/ v_alignbit_b32  v25, v2, v3, 31
/*d29c0002 027e0503*/ v_alignbit_b32  v2, v3, v2, 31
/*3a064b19         */ v_xor_b32       v3, v25, v37
/*3a044d02         */ v_xor_b32       v2, v2, v38
/*d29c0019 027e1509*/ v_alignbit_b32  v25, v9, v10, 31
/*d29c0009 027e130a*/ v_alignbit_b32  v9, v10, v9, 31
/*3a143b13         */ v_xor_b32       v10, v19, v29
/*3a263d14         */ v_xor_b32       v19, v20, v30
/*3a141551         */ v_xor_b32       v10, v81, v10
/*3a262748         */ v_xor_b32       v19, v72, v19
/*3a0e1549         */ v_xor_b32       v7, v73, v10
/*3a102708         */ v_xor_b32       v8, v8, v19
/*3a0e0f52         */ v_xor_b32       v7, v82, v7
/*3a101153         */ v_xor_b32       v8, v83, v8
/*3a140f19         */ v_xor_b32       v10, v25, v7
/*3a121109         */ v_xor_b32       v9, v9, v8
/*d29c0013 027e1107*/ v_alignbit_b32  v19, v7, v8, 31
/*d29c0007 027e0f08*/ v_alignbit_b32  v7, v8, v7, 31
/*3a102b13         */ v_xor_b32       v8, v19, v21
/*3a0e2d07         */ v_xor_b32       v7, v7, v22
/*3a26071d         */ v_xor_b32       v19, v29, v3
/*3a28051e         */ v_xor_b32       v20, v30, v2
/*d29c0050 026a2913*/ v_alignbit_b32  v80, v19, v20, 26
/*d29c0059 026a2714*/ v_alignbit_b32  v89, v20, v19, 26
/*3a281521         */ v_xor_b32       v20, v33, v10
/*3a2c1347         */ v_xor_b32       v22, v71, v9
/*d29c0019 022e2d14*/ v_alignbit_b32  v25, v20, v22, 11
/*d29c0014 022e2916*/ v_alignbit_b32  v20, v22, v20, 11
/*3a2c1154         */ v_xor_b32       v22, v84, v8
/*3a340f17         */ v_xor_b32       v26, v23, v7
/*d29c001b 02522d1a*/ v_alignbit_b32  v27, v26, v22, 20
/*d29c0016 02523516*/ v_alignbit_b32  v22, v22, v26, 20
/*3a343719         */ v_xor_b32       v26, v25, v27
/*3a382d14         */ v_xor_b32       v28, v20, v22
/*3a3a0751         */ v_xor_b32       v29, v81, v3
/*3a3c0548         */ v_xor_b32       v30, v72, v2
/*d29c001f 02563b1e*/ v_alignbit_b32  v31, v30, v29, 21
/*d29c001d 02563d1d*/ v_alignbit_b32  v29, v29, v30, 21
/*d294001a 046a371f*/ v_bfi_b32       v26, v31, v27, v26
/*d294001c 04722d1d*/ v_bfi_b32       v28, v29, v22, v28
/*3a1a534c         */ v_xor_b32       v13, v76, v41
/*3a1c554d         */ v_xor_b32       v14, v77, v42
/*3a3c1b1f         */ v_xor_b32       v30, v31, v13
/*3a401d1d         */ v_xor_b32       v32, v29, v14
/*d294001e 047a1b1b*/ v_bfi_b32       v30, v27, v13, v30
/*d2940020 04821d16*/ v_bfi_b32       v32, v22, v14, v32
/*3a3c3cff 80008008*/ v_xor_b32       v30, 0x80008008, v30
/*3a4040ff 80000000*/ v_xor_b32       v32, 0x80000000, v32
/*3a461735         */ v_xor_b32       v35, v53, v11
/*3a48192e         */ v_xor_b32       v36, v46, v12
/*d29c0025 024a4923*/ v_alignbit_b32  v37, v35, v36, 18
/*d29c0023 024a4724*/ v_alignbit_b32  v35, v36, v35, 18
/*3a481b19         */ v_xor_b32       v36, v25, v13
/*3a4c1d14         */ v_xor_b32       v38, v20, v14
/*d2940024 04923325*/ v_bfi_b32       v36, v37, v25, v36
/*d2940013 049a2923*/ v_bfi_b32       v19, v35, v20, v38
/*3a564b1f         */ v_xor_b32       v43, v31, v37
/*3a58471d         */ v_xor_b32       v44, v29, v35
/*d2940019 04ae3f19*/ v_bfi_b32       v25, v25, v31, v43
/*d2940014 04b23b14*/ v_bfi_b32       v20, v20, v29, v44
/*3a2e534e         */ v_xor_b32       v23, v78, v41
/*3a30554f         */ v_xor_b32       v24, v79, v42
/*d29c001d 02763117*/ v_alignbit_b32  v29, v23, v24, 29
/*d29c0017 02762f18*/ v_alignbit_b32  v23, v24, v23, 29
/*3a141511         */ v_xor_b32       v10, v17, v10
/*3a121312         */ v_xor_b32       v9, v18, v9
/*d29c0011 0212130a*/ v_alignbit_b32  v17, v10, v9, 4
/*d29c0009 02121509*/ v_alignbit_b32  v9, v9, v10, 4
/*3a14231d         */ v_xor_b32       v10, v29, v17
/*3a241317         */ v_xor_b32       v18, v23, v9
/*3a161757         */ v_xor_b32       v11, v87, v11
/*3a181958         */ v_xor_b32       v12, v88, v12
/*d29c0018 0232190b*/ v_alignbit_b32  v24, v11, v12, 12
/*d29c000b 0232170c*/ v_alignbit_b32  v11, v12, v11, 12
/*d294000a 042a2318*/ v_bfi_b32       v10, v24, v17, v10
/*d294000c 044a130b*/ v_bfi_b32       v12, v11, v9, v18
/*3a244b1b         */ v_xor_b32       v18, v27, v37
/*3a2c4716         */ v_xor_b32       v22, v22, v35
/*d294000d 044a4b0d*/ v_bfi_b32       v13, v13, v37, v18
/*d294000e 045a470e*/ v_bfi_b32       v14, v14, v35, v22
/*3a060752         */ v_xor_b32       v3, v82, v3
/*3a040553         */ v_xor_b32       v2, v83, v2
/*d29c0012 020e0702*/ v_alignbit_b32  v18, v2, v3, 3
/*d29c0002 020e0503*/ v_alignbit_b32  v2, v3, v2, 3
/*3a06251d         */ v_xor_b32       v3, v29, v18
/*3a2c0517         */ v_xor_b32       v22, v23, v2
/*3a361155         */ v_xor_b32       v27, v85, v8
/*3a3e0f56         */ v_xor_b32       v31, v86, v7
/*d29c0021 024e371f*/ v_alignbit_b32  v33, v31, v27, 19
/*d29c001b 024e3f1b*/ v_alignbit_b32  v27, v27, v31, 19
/*d2940056 040e3b21*/ v_bfi_b32       v86, v33, v29, v3
/*d2940055 045a2f1b*/ v_bfi_b32       v85, v27, v23, v22
/*3a3e4318         */ v_xor_b32       v31, v24, v33
/*3a44370b         */ v_xor_b32       v34, v11, v27
/*d2940058 047e311d*/ v_bfi_b32       v88, v29, v24, v31
/*d2940057 048a1717*/ v_bfi_b32       v87, v23, v11, v34
/*3a3e4311         */ v_xor_b32       v31, v17, v33
/*3a443709         */ v_xor_b32       v34, v9, v27
/*d2940016 047e4312*/ v_bfi_b32       v22, v18, v33, v31
/*d2940054 048a3702*/ v_bfi_b32       v84, v2, v27, v34
/*3a302518         */ v_xor_b32       v24, v24, v18
/*3a16050b         */ v_xor_b32       v11, v11, v2
/*d294004f 04622511*/ v_bfi_b32       v79, v17, v18, v24
/*d2940053 042e0509*/ v_bfi_b32       v83, v9, v2, v11
/*3a10110f         */ v_xor_b32       v8, v15, v8
/*3a0e0f10         */ v_xor_b32       v7, v16, v7
/*d29c004e 027e0f08*/ v_alignbit_b32  v78, v8, v7, 31
/*d29c0052 027e1107*/ v_alignbit_b32  v82, v7, v8, 31
/*36100081         */ v_and_b32       v8, 1, v0
/*34101085         */ v_lshlrev_b32   v8, 5, v8
/*4a101105         */ v_add_i32       v8, vcc, v5, v8
/*34160c83         */ v_lshlrev_b32   v11, 3, v6
/*4a161705         */ v_add_i32       v11, vcc, v5, v11
/*34000082         */ v_lshlrev_b32   v0, 2, v0
/*c08a0370         */ s_load_dwordx4  s[20:23], s[2:3], 0x70
/*b0000000         */ s_movk_i32      s0, 0x0
/*b0010004         */ s_movk_i32      s1, 0x4
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
.L2848_0:
/*bf088001         */ s_cmp_gt_u32    s1, 0
/*bf8414e7         */ s_cbranch_scc0  .L24260_0
/*d10a000a 00000106*/ v_cmp_lg_i32    s[10:11], v6, s0
/*be92047e         */ s_mov_b64       s[18:19], exec
/*8afe0a12         */ s_andn2_b64     exec, s[18:19], s[10:11]
/*bf88002f         */ s_cbranch_execz .L3064_0
/*d8340000 00001e05*/ ds_write_b32    v5, v30
/*4a2a0a84         */ v_add_i32       v21, vcc, 4, v5
/*d8340000 00002015*/ ds_write_b32    v21, v32
/*4a2a0a88         */ v_add_i32       v21, vcc, 8, v5
/*d8340000 00001a15*/ ds_write_b32    v21, v26
/*4a2a0a8c         */ v_add_i32       v21, vcc, 12, v5
/*d8340000 00001c15*/ ds_write_b32    v21, v28
/*4a2a0a90         */ v_add_i32       v21, vcc, 16, v5
/*d8340000 00001915*/ ds_write_b32    v21, v25
/*4a2a0a94         */ v_add_i32       v21, vcc, 20, v5
/*d8340000 00001415*/ ds_write_b32    v21, v20
/*4a2a0a98         */ v_add_i32       v21, vcc, 24, v5
/*d8340000 00002415*/ ds_write_b32    v21, v36
/*4a2a0a9c         */ v_add_i32       v21, vcc, 28, v5
/*d8340000 00001315*/ ds_write_b32    v21, v19
/*4a2a0aa0         */ v_add_i32       v21, vcc, 32, v5
/*d8340000 00000d15*/ ds_write_b32    v21, v13
/*4a2a0aa4         */ v_add_i32       v21, vcc, 36, v5
/*d8340000 00000e15*/ ds_write_b32    v21, v14
/*4a2a0aa8         */ v_add_i32       v21, vcc, 40, v5
/*d8340000 00000a15*/ ds_write_b32    v21, v10
/*4a2a0aac         */ v_add_i32       v21, vcc, 44, v5
/*d8340000 00000c15*/ ds_write_b32    v21, v12
/*4a2a0ab0         */ v_add_i32       v21, vcc, 48, v5
/*d8340000 00005815*/ ds_write_b32    v21, v88
/*4a2a0ab4         */ v_add_i32       v21, vcc, 52, v5
/*d8340000 00005715*/ ds_write_b32    v21, v87
/*4a2a0ab8         */ v_add_i32       v21, vcc, 56, v5
/*d8340000 00005615*/ ds_write_b32    v21, v86
/*4a2a0abc         */ v_add_i32       v21, vcc, 60, v5
/*d8340000 00005515*/ ds_write_b32    v21, v85
.L3064_0:
/*befe0412         */ s_mov_b64       exec, s[18:19]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*4a2a1098         */ v_add_i32       v21, vcc, 24, v8
/*4a301090         */ v_add_i32       v24, vcc, 16, v8
/*4a361088         */ v_add_i32       v27, vcc, 8, v8
/*d9d80000 21000015*/ ds_read_b64     v[33:34], v21
/*d9d80000 27000018*/ ds_read_b64     v[39:40], v24
/*d9d80000 29000008*/ ds_read_b64     v[41:42], v8
/*d9d80000 2b00001b*/ ds_read_b64     v[43:44], v27
/*d8d80000 15000005*/ ds_read_b32     v21, v5
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be8903ff 01000193*/ s_mov_b32       s9, 0x1000193
/*d2d60018 00001315*/ v_mul_lo_i32    v24, v21, s9
/*3a303129         */ v_xor_b32       v24, v41, v24
/*7e360c0e         */ v_cvt_f32_u32   v27, s14
/*7e36551b         */ v_rcp_f32       v27, v27
/*103636ff 4f800000*/ v_mul_f32       v27, 0x4f800000 /* 4.2949673e+9f */, v27
/*7e360f1b         */ v_cvt_u32_f32   v27, v27
/*d2d2001f 0002360e*/ v_mul_lo_u32    v31, s14, v27
/*d2d40023 0002360e*/ v_mul_hi_u32    v35, s14, v27
/*4c4a3e80         */ v_sub_i32       v37, vcc, 0, v31
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d200002d 004a3f25*/ v_cndmask_b32   v45, v37, v31, s[18:19]
/*d2d4002d 0002372d*/ v_mul_hi_u32    v45, v45, v27
/*4c5c5b1b         */ v_sub_i32       v46, vcc, v27, v45
/*4a5a5b1b         */ v_add_i32       v45, vcc, v27, v45
/*d200002d 004a5d2d*/ v_cndmask_b32   v45, v45, v46, s[18:19]
/*d2d4002d 0002312d*/ v_mul_hi_u32    v45, v45, v24
/*d2d2002e 00001d2d*/ v_mul_lo_u32    v46, v45, s14
/*4c5e5d18         */ v_sub_i32       v47, vcc, v24, v46
/*d18c0012 00025d18*/ v_cmp_ge_u32    s[18:19], v24, v46
/*4a5c5a81         */ v_add_i32       v46, vcc, 1, v45
/*4a605ac1         */ v_add_i32       v48, vcc, -1, v45
/*7d865e0e         */ v_cmp_le_u32    vcc, s14, v47
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*005a5d2d         */ v_cndmask_b32   v45, v45, v46, vcc
/*d200002d 004a5b30*/ v_cndmask_b32   v45, v48, v45, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*005a5ac1         */ v_cndmask_b32   v45, -1, v45, vcc
/*d2d6002d 00001d2d*/ v_mul_lo_i32    v45, v45, s14
/*4c305b18         */ v_sub_i32       v24, vcc, v24, v45
/*bf8a0000         */ s_barrier
/*d8340c00 00001800*/ ds_write_b32    v0, v24 offset:3072
/*34300884         */ v_lshlrev_b32   v24, 4, v4
/*4a5a30ff 00000c00*/ v_add_i32       v45, vcc, 0xc00, v24
/*7e5c020d         */ v_mov_b32       v46, s13
/*345e0c85         */ v_lshlrev_b32   v47, 5, v6
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*3a622a81         */ v_xor_b32       v49, 1, v21
/*d2d60030 00026131*/ v_mul_lo_i32    v48, v49, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053832*/ tbuffer_load_format_xyzw v[56:59], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525334         */ v_xor_b32       v41, v52, v41
/*3a545535         */ v_xor_b32       v42, v53, v42
/*3a565736         */ v_xor_b32       v43, v54, v43
/*3a585937         */ v_xor_b32       v44, v55, v44
/*3a5c612a         */ v_xor_b32       v46, v42, v48
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a82         */ v_xor_b32       v49, 2, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053c32*/ tbuffer_load_format_xyzw v[60:63], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526929         */ v_xor_b32       v41, v41, v52
/*3a546b2a         */ v_xor_b32       v42, v42, v53
/*3a566d2b         */ v_xor_b32       v43, v43, v54
/*3a586f2c         */ v_xor_b32       v44, v44, v55
/*3a5c5d2b         */ v_xor_b32       v46, v43, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a83         */ v_xor_b32       v49, 3, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054032*/ tbuffer_load_format_xyzw v[64:67], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526929         */ v_xor_b32       v41, v41, v52
/*3a546b2a         */ v_xor_b32       v42, v42, v53
/*3a566d2b         */ v_xor_b32       v43, v43, v54
/*3a586f2c         */ v_xor_b32       v44, v44, v55
/*3a5c5d2c         */ v_xor_b32       v46, v44, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*3a4e4f38         */ v_xor_b32       v39, v56, v39
/*3a505139         */ v_xor_b32       v40, v57, v40
/*3a42433a         */ v_xor_b32       v33, v58, v33
/*3a44453b         */ v_xor_b32       v34, v59, v34
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*3a4e4f3c         */ v_xor_b32       v39, v60, v39
/*3a50513d         */ v_xor_b32       v40, v61, v40
/*3a42433e         */ v_xor_b32       v33, v62, v33
/*3a44453f         */ v_xor_b32       v34, v63, v34
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f40         */ v_xor_b32       v39, v64, v39
/*3a505141         */ v_xor_b32       v40, v65, v40
/*3a424342         */ v_xor_b32       v33, v66, v33
/*3a444543         */ v_xor_b32       v34, v67, v34
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a84         */ v_xor_b32       v49, 4, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053832*/ tbuffer_load_format_xyzw v[56:59], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5c5d27         */ v_xor_b32       v46, v39, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a85         */ v_xor_b32       v49, 5, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053c32*/ tbuffer_load_format_xyzw v[60:63], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5c5d28         */ v_xor_b32       v46, v40, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a86         */ v_xor_b32       v49, 6, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054032*/ tbuffer_load_format_xyzw v[64:67], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5c5d21         */ v_xor_b32       v46, v33, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*3a622a87         */ v_xor_b32       v49, 7, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3200002d*/ ds_read_b32     v50, v45
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*50606730         */ v_addc_u32      v48, vcc, v48, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a90130*/ v_addc_u32      v51, vcc, v48, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054432*/ tbuffer_load_format_xyzw v[68:71], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5c5d22         */ v_xor_b32       v46, v34, v46
/*d2d40030 00025d31*/ v_mul_hi_u32    v48, v49, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0018 0002632e*/ v_cmp_ge_u32    s[24:25], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 00626133*/ v_cndmask_b32   v48, v51, v48, s[24:25]
/*d2000030 004a60c1*/ v_cndmask_b32   v48, -1, v48, s[18:19]
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*d8d80000 3000002d*/ ds_read_b32     v48, v45
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20030 00010f30*/ v_lshl_b64      v[48:49], v[48:49], 7
/*4a5c600c         */ v_add_i32       v46, vcc, s12, v48
/*7e60020d         */ v_mov_b32       v48, s13
/*50606330         */ v_addc_u32      v48, vcc, v48, v49, vcc
/*4a045f2e         */ v_add_i32       v2, vcc, v46, v47
/*d2506a03 01a90130*/ v_addc_u32      v3, vcc, v48, 0, vcc
/*ebf38000 80053202*/ tbuffer_load_format_xyzw v[50:53], v[2:3], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054802*/ tbuffer_load_format_xyzw v[72:75], v[2:3], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*3a525338         */ v_xor_b32       v41, v56, v41
/*3a545539         */ v_xor_b32       v42, v57, v42
/*3a56573a         */ v_xor_b32       v43, v58, v43
/*3a58593b         */ v_xor_b32       v44, v59, v44
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*3a52533c         */ v_xor_b32       v41, v60, v41
/*3a54553d         */ v_xor_b32       v42, v61, v42
/*3a56573e         */ v_xor_b32       v43, v62, v43
/*3a58593f         */ v_xor_b32       v44, v63, v44
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*3a525340         */ v_xor_b32       v41, v64, v41
/*3a545541         */ v_xor_b32       v42, v65, v42
/*3a565742         */ v_xor_b32       v43, v66, v43
/*3a585943         */ v_xor_b32       v44, v67, v44
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525344         */ v_xor_b32       v41, v68, v41
/*3a545545         */ v_xor_b32       v42, v69, v42
/*3a565746         */ v_xor_b32       v43, v70, v43
/*3a585947         */ v_xor_b32       v44, v71, v44
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*d2d60027 00025d27*/ v_mul_lo_i32    v39, v39, v46
/*d2d60028 00025d28*/ v_mul_lo_i32    v40, v40, v46
/*d2d60021 00025d21*/ v_mul_lo_i32    v33, v33, v46
/*d2d60022 00025d22*/ v_mul_lo_i32    v34, v34, v46
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526529         */ v_xor_b32       v41, v41, v50
/*3a54672a         */ v_xor_b32       v42, v42, v51
/*3a56692b         */ v_xor_b32       v43, v43, v52
/*3a586b2c         */ v_xor_b32       v44, v44, v53
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e9127         */ v_xor_b32       v39, v39, v72
/*3a509328         */ v_xor_b32       v40, v40, v73
/*3a429521         */ v_xor_b32       v33, v33, v74
/*3a449722         */ v_xor_b32       v34, v34, v75
/*bf8a0000         */ s_barrier
/*3a5c2a88         */ v_xor_b32       v46, 8, v21
/*d2d6002e 0000132e*/ v_mul_lo_i32    v46, v46, s9
/*3a5c5d29         */ v_xor_b32       v46, v41, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d2d40030 00025d30*/ v_mul_hi_u32    v48, v48, v46
/*d2d20031 00001d30*/ v_mul_lo_u32    v49, v48, s14
/*4c64632e         */ v_sub_i32       v50, vcc, v46, v49
/*d18c0012 0002632e*/ v_cmp_ge_u32    s[18:19], v46, v49
/*4a626081         */ v_add_i32       v49, vcc, 1, v48
/*4a6660c1         */ v_add_i32       v51, vcc, -1, v48
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*00606330         */ v_cndmask_b32   v48, v48, v49, vcc
/*d2000030 004a6133*/ v_cndmask_b32   v48, v51, v48, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*006060c1         */ v_cndmask_b32   v48, -1, v48, vcc
/*d2d60030 00001d30*/ v_mul_lo_i32    v48, v48, s14
/*4c5c612e         */ v_sub_i32       v46, vcc, v46, v48
/*bf8a0000         */ s_barrier
/*d8340c00 00002e00*/ ds_write_b32    v0, v46 offset:3072
/*4a5c3084         */ v_add_i32       v46, vcc, 4, v24
/*4a5c5cff 00000c00*/ v_add_i32       v46, vcc, 0xc00, v46
/*7e60020d         */ v_mov_b32       v48, s13
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a642a89         */ v_xor_b32       v50, 9, v21
/*d2d60031 00026332*/ v_mul_lo_i32    v49, v50, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50606930         */ v_addc_u32      v48, vcc, v48, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90130*/ v_addc_u32      v52, vcc, v48, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053933*/ tbuffer_load_format_xyzw v[57:60], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525335         */ v_xor_b32       v41, v53, v41
/*3a545536         */ v_xor_b32       v42, v54, v42
/*3a565737         */ v_xor_b32       v43, v55, v43
/*3a585938         */ v_xor_b32       v44, v56, v44
/*3a60632a         */ v_xor_b32       v48, v42, v49
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8a         */ v_xor_b32       v50, 10, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053d33*/ tbuffer_load_format_xyzw v[61:64], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526b29         */ v_xor_b32       v41, v41, v53
/*3a546d2a         */ v_xor_b32       v42, v42, v54
/*3a566f2b         */ v_xor_b32       v43, v43, v55
/*3a58712c         */ v_xor_b32       v44, v44, v56
/*3a60612b         */ v_xor_b32       v48, v43, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8b         */ v_xor_b32       v50, 11, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054133*/ tbuffer_load_format_xyzw v[65:68], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526b29         */ v_xor_b32       v41, v41, v53
/*3a546d2a         */ v_xor_b32       v42, v42, v54
/*3a566f2b         */ v_xor_b32       v43, v43, v55
/*3a58712c         */ v_xor_b32       v44, v44, v56
/*3a60612c         */ v_xor_b32       v48, v44, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*3a4e4f39         */ v_xor_b32       v39, v57, v39
/*3a50513a         */ v_xor_b32       v40, v58, v40
/*3a42433b         */ v_xor_b32       v33, v59, v33
/*3a44453c         */ v_xor_b32       v34, v60, v34
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*3a4e4f3d         */ v_xor_b32       v39, v61, v39
/*3a50513e         */ v_xor_b32       v40, v62, v40
/*3a42433f         */ v_xor_b32       v33, v63, v33
/*3a444540         */ v_xor_b32       v34, v64, v34
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f41         */ v_xor_b32       v39, v65, v39
/*3a505142         */ v_xor_b32       v40, v66, v40
/*3a424343         */ v_xor_b32       v33, v67, v33
/*3a444544         */ v_xor_b32       v34, v68, v34
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8c         */ v_xor_b32       v50, 12, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053933*/ tbuffer_load_format_xyzw v[57:60], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a606127         */ v_xor_b32       v48, v39, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8d         */ v_xor_b32       v50, 13, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053d33*/ tbuffer_load_format_xyzw v[61:64], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a606128         */ v_xor_b32       v48, v40, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8e         */ v_xor_b32       v50, 14, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054133*/ tbuffer_load_format_xyzw v[65:68], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a606121         */ v_xor_b32       v48, v33, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642a8f         */ v_xor_b32       v50, 15, v21
/*d2d60030 00026132*/ v_mul_lo_i32    v48, v50, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054533*/ tbuffer_load_format_xyzw v[69:72], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a606122         */ v_xor_b32       v48, v34, v48
/*d2d40031 00026132*/ v_mul_hi_u32    v49, v50, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0018 00026530*/ v_cmp_ge_u32    s[24:25], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*d8d80000 3000002e*/ ds_read_b32     v48, v46
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20030 00010f30*/ v_lshl_b64      v[48:49], v[48:49], 7
/*4a60600c         */ v_add_i32       v48, vcc, s12, v48
/*7e64020d         */ v_mov_b32       v50, s13
/*50626332         */ v_addc_u32      v49, vcc, v50, v49, vcc
/*4a605f30         */ v_add_i32       v48, vcc, v48, v47
/*d2506a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*ebf38000 80053230*/ tbuffer_load_format_xyzw v[50:53], v[48:49], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054930*/ tbuffer_load_format_xyzw v[73:76], v[48:49], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e6002ff 01000193*/ v_mov_b32       v48, 0x1000193
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*3a525339         */ v_xor_b32       v41, v57, v41
/*3a54553a         */ v_xor_b32       v42, v58, v42
/*3a56573b         */ v_xor_b32       v43, v59, v43
/*3a58593c         */ v_xor_b32       v44, v60, v44
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*3a52533d         */ v_xor_b32       v41, v61, v41
/*3a54553e         */ v_xor_b32       v42, v62, v42
/*3a56573f         */ v_xor_b32       v43, v63, v43
/*3a585940         */ v_xor_b32       v44, v64, v44
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*3a525341         */ v_xor_b32       v41, v65, v41
/*3a545542         */ v_xor_b32       v42, v66, v42
/*3a565743         */ v_xor_b32       v43, v67, v43
/*3a585944         */ v_xor_b32       v44, v68, v44
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525345         */ v_xor_b32       v41, v69, v41
/*3a545546         */ v_xor_b32       v42, v70, v42
/*3a565747         */ v_xor_b32       v43, v71, v43
/*3a585948         */ v_xor_b32       v44, v72, v44
/*d2d60029 00026129*/ v_mul_lo_i32    v41, v41, v48
/*d2d6002a 0002612a*/ v_mul_lo_i32    v42, v42, v48
/*d2d6002b 0002612b*/ v_mul_lo_i32    v43, v43, v48
/*d2d6002c 0002612c*/ v_mul_lo_i32    v44, v44, v48
/*d2d60027 00026127*/ v_mul_lo_i32    v39, v39, v48
/*d2d60028 00026128*/ v_mul_lo_i32    v40, v40, v48
/*d2d60021 00026121*/ v_mul_lo_i32    v33, v33, v48
/*d2d60022 00026122*/ v_mul_lo_i32    v34, v34, v48
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526529         */ v_xor_b32       v41, v41, v50
/*3a54672a         */ v_xor_b32       v42, v42, v51
/*3a56692b         */ v_xor_b32       v43, v43, v52
/*3a586b2c         */ v_xor_b32       v44, v44, v53
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e9327         */ v_xor_b32       v39, v39, v73
/*3a509528         */ v_xor_b32       v40, v40, v74
/*3a429721         */ v_xor_b32       v33, v33, v75
/*3a449922         */ v_xor_b32       v34, v34, v76
/*bf8a0000         */ s_barrier
/*3a602a90         */ v_xor_b32       v48, 16, v21
/*d2d60030 00001330*/ v_mul_lo_i32    v48, v48, s9
/*3a606129         */ v_xor_b32       v48, v41, v48
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d2d40031 00026131*/ v_mul_hi_u32    v49, v49, v48
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c666530         */ v_sub_i32       v51, vcc, v48, v50
/*d18c0012 00026530*/ v_cmp_ge_u32    s[18:19], v48, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 004a6334*/ v_cndmask_b32   v49, v52, v49, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*006262c1         */ v_cndmask_b32   v49, -1, v49, vcc
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c606330         */ v_sub_i32       v48, vcc, v48, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00003000*/ ds_write_b32    v0, v48 offset:3072
/*4a603088         */ v_add_i32       v48, vcc, 8, v24
/*4a6060ff 00000c00*/ v_add_i32       v48, vcc, 0xc00, v48
/*7e62020d         */ v_mov_b32       v49, s13
/*7e6402ff 01000193*/ v_mov_b32       v50, 0x1000193
/*d2d60029 00026529*/ v_mul_lo_i32    v41, v41, v50
/*d2d6002a 0002652a*/ v_mul_lo_i32    v42, v42, v50
/*d2d6002b 0002652b*/ v_mul_lo_i32    v43, v43, v50
/*d2d6002c 0002652c*/ v_mul_lo_i32    v44, v44, v50
/*3a662a91         */ v_xor_b32       v51, 17, v21
/*d2d60032 00026533*/ v_mul_lo_i32    v50, v51, v50
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50626b31         */ v_addc_u32      v49, vcc, v49, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525336         */ v_xor_b32       v41, v54, v41
/*3a545537         */ v_xor_b32       v42, v55, v42
/*3a565738         */ v_xor_b32       v43, v56, v43
/*3a585939         */ v_xor_b32       v44, v57, v44
/*3a62652a         */ v_xor_b32       v49, v42, v50
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a92         */ v_xor_b32       v51, 18, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632b         */ v_xor_b32       v49, v43, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a93         */ v_xor_b32       v51, 19, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632c         */ v_xor_b32       v49, v44, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3a         */ v_xor_b32       v39, v58, v39
/*3a50513b         */ v_xor_b32       v40, v59, v40
/*3a42433c         */ v_xor_b32       v33, v60, v33
/*3a44453d         */ v_xor_b32       v34, v61, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3e         */ v_xor_b32       v39, v62, v39
/*3a50513f         */ v_xor_b32       v40, v63, v40
/*3a424340         */ v_xor_b32       v33, v64, v33
/*3a444541         */ v_xor_b32       v34, v65, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f42         */ v_xor_b32       v39, v66, v39
/*3a505143         */ v_xor_b32       v40, v67, v40
/*3a424344         */ v_xor_b32       v33, v68, v33
/*3a444545         */ v_xor_b32       v34, v69, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a94         */ v_xor_b32       v51, 20, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626327         */ v_xor_b32       v49, v39, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a95         */ v_xor_b32       v51, 21, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626328         */ v_xor_b32       v49, v40, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a96         */ v_xor_b32       v51, 22, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626321         */ v_xor_b32       v49, v33, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a97         */ v_xor_b32       v51, 23, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000030*/ ds_read_b32     v52, v48
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054634*/ tbuffer_load_format_xyzw v[70:73], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626322         */ v_xor_b32       v49, v34, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*d8d80000 31000030*/ ds_read_b32     v49, v48
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*7e66020d         */ v_mov_b32       v51, s13
/*50646533         */ v_addc_u32      v50, vcc, v51, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a90132*/ v_addc_u32      v50, vcc, v50, 0, vcc
/*ebf38000 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054a31*/ tbuffer_load_format_xyzw v[74:77], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a52533a         */ v_xor_b32       v41, v58, v41
/*3a54553b         */ v_xor_b32       v42, v59, v42
/*3a56573c         */ v_xor_b32       v43, v60, v43
/*3a58593d         */ v_xor_b32       v44, v61, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a52533e         */ v_xor_b32       v41, v62, v41
/*3a54553f         */ v_xor_b32       v42, v63, v42
/*3a565740         */ v_xor_b32       v43, v64, v43
/*3a585941         */ v_xor_b32       v44, v65, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a525342         */ v_xor_b32       v41, v66, v41
/*3a545543         */ v_xor_b32       v42, v67, v42
/*3a565744         */ v_xor_b32       v43, v68, v43
/*3a585945         */ v_xor_b32       v44, v69, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525346         */ v_xor_b32       v41, v70, v41
/*3a545547         */ v_xor_b32       v42, v71, v42
/*3a565748         */ v_xor_b32       v43, v72, v43
/*3a585949         */ v_xor_b32       v44, v73, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526729         */ v_xor_b32       v41, v41, v51
/*3a54692a         */ v_xor_b32       v42, v42, v52
/*3a566b2b         */ v_xor_b32       v43, v43, v53
/*3a586d2c         */ v_xor_b32       v44, v44, v54
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e9527         */ v_xor_b32       v39, v39, v74
/*3a509728         */ v_xor_b32       v40, v40, v75
/*3a429921         */ v_xor_b32       v33, v33, v76
/*3a449b22         */ v_xor_b32       v34, v34, v77
/*bf8a0000         */ s_barrier
/*3a622a98         */ v_xor_b32       v49, 24, v21
/*d2d60031 00001331*/ v_mul_lo_i32    v49, v49, s9
/*3a626329         */ v_xor_b32       v49, v41, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d2d40032 00026332*/ v_mul_hi_u32    v50, v50, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0012 00026731*/ v_cmp_ge_u32    s[18:19], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 004a6535*/ v_cndmask_b32   v50, v53, v50, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*006464c1         */ v_cndmask_b32   v50, -1, v50, vcc
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*4a30308c         */ v_add_i32       v24, vcc, 12, v24
/*4a3030ff 00000c00*/ v_add_i32       v24, vcc, 0xc00, v24
/*7e62020d         */ v_mov_b32       v49, s13
/*7e6402ff 01000193*/ v_mov_b32       v50, 0x1000193
/*d2d60029 00026529*/ v_mul_lo_i32    v41, v41, v50
/*d2d6002a 0002652a*/ v_mul_lo_i32    v42, v42, v50
/*d2d6002b 0002652b*/ v_mul_lo_i32    v43, v43, v50
/*d2d6002c 0002652c*/ v_mul_lo_i32    v44, v44, v50
/*3a662a99         */ v_xor_b32       v51, 25, v21
/*d2d60032 00026533*/ v_mul_lo_i32    v50, v51, v50
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50626b31         */ v_addc_u32      v49, vcc, v49, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525336         */ v_xor_b32       v41, v54, v41
/*3a545537         */ v_xor_b32       v42, v55, v42
/*3a565738         */ v_xor_b32       v43, v56, v43
/*3a585939         */ v_xor_b32       v44, v57, v44
/*3a62652a         */ v_xor_b32       v49, v42, v50
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9a         */ v_xor_b32       v51, 26, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632b         */ v_xor_b32       v49, v43, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9b         */ v_xor_b32       v51, 27, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632c         */ v_xor_b32       v49, v44, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3a         */ v_xor_b32       v39, v58, v39
/*3a50513b         */ v_xor_b32       v40, v59, v40
/*3a42433c         */ v_xor_b32       v33, v60, v33
/*3a44453d         */ v_xor_b32       v34, v61, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3e         */ v_xor_b32       v39, v62, v39
/*3a50513f         */ v_xor_b32       v40, v63, v40
/*3a424340         */ v_xor_b32       v33, v64, v33
/*3a444541         */ v_xor_b32       v34, v65, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f42         */ v_xor_b32       v39, v66, v39
/*3a505143         */ v_xor_b32       v40, v67, v40
/*3a424344         */ v_xor_b32       v33, v68, v33
/*3a444545         */ v_xor_b32       v34, v69, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9c         */ v_xor_b32       v51, 28, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626327         */ v_xor_b32       v49, v39, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9d         */ v_xor_b32       v51, 29, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626328         */ v_xor_b32       v49, v40, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9e         */ v_xor_b32       v51, 30, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626321         */ v_xor_b32       v49, v33, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662a9f         */ v_xor_b32       v51, 31, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 34000018*/ ds_read_b32     v52, v24
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054634*/ tbuffer_load_format_xyzw v[70:73], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626322         */ v_xor_b32       v49, v34, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*7e66020d         */ v_mov_b32       v51, s13
/*50646533         */ v_addc_u32      v50, vcc, v51, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a90132*/ v_addc_u32      v50, vcc, v50, 0, vcc
/*ebf38000 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054a31*/ tbuffer_load_format_xyzw v[74:77], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a52533a         */ v_xor_b32       v41, v58, v41
/*3a54553b         */ v_xor_b32       v42, v59, v42
/*3a56573c         */ v_xor_b32       v43, v60, v43
/*3a58593d         */ v_xor_b32       v44, v61, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a52533e         */ v_xor_b32       v41, v62, v41
/*3a54553f         */ v_xor_b32       v42, v63, v42
/*3a565740         */ v_xor_b32       v43, v64, v43
/*3a585941         */ v_xor_b32       v44, v65, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a525342         */ v_xor_b32       v41, v66, v41
/*3a545543         */ v_xor_b32       v42, v67, v42
/*3a565744         */ v_xor_b32       v43, v68, v43
/*3a585945         */ v_xor_b32       v44, v69, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525346         */ v_xor_b32       v41, v70, v41
/*3a545547         */ v_xor_b32       v42, v71, v42
/*3a565748         */ v_xor_b32       v43, v72, v43
/*3a585949         */ v_xor_b32       v44, v73, v44
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526729         */ v_xor_b32       v41, v41, v51
/*3a54692a         */ v_xor_b32       v42, v42, v52
/*3a566b2b         */ v_xor_b32       v43, v43, v53
/*3a586d2c         */ v_xor_b32       v44, v44, v54
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e9527         */ v_xor_b32       v39, v39, v74
/*3a509728         */ v_xor_b32       v40, v40, v75
/*3a429921         */ v_xor_b32       v33, v33, v76
/*3a449b22         */ v_xor_b32       v34, v34, v77
/*bf8a0000         */ s_barrier
/*3a622aa0         */ v_xor_b32       v49, 32, v21
/*d2d60031 00001331*/ v_mul_lo_i32    v49, v49, s9
/*3a626329         */ v_xor_b32       v49, v41, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d2d40032 00026332*/ v_mul_hi_u32    v50, v50, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0012 00026731*/ v_cmp_ge_u32    s[18:19], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 004a6535*/ v_cndmask_b32   v50, v53, v50, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*006464c1         */ v_cndmask_b32   v50, -1, v50, vcc
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e62020d         */ v_mov_b32       v49, s13
/*7e6402ff 01000193*/ v_mov_b32       v50, 0x1000193
/*d2d60029 00026529*/ v_mul_lo_i32    v41, v41, v50
/*d2d6002a 0002652a*/ v_mul_lo_i32    v42, v42, v50
/*d2d6002b 0002652b*/ v_mul_lo_i32    v43, v43, v50
/*d2d6002c 0002652c*/ v_mul_lo_i32    v44, v44, v50
/*3a662aa1         */ v_xor_b32       v51, 33, v21
/*d2d60032 00026533*/ v_mul_lo_i32    v50, v51, v50
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50626b31         */ v_addc_u32      v49, vcc, v49, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525336         */ v_xor_b32       v41, v54, v41
/*3a545537         */ v_xor_b32       v42, v55, v42
/*3a565738         */ v_xor_b32       v43, v56, v43
/*3a585939         */ v_xor_b32       v44, v57, v44
/*3a62652a         */ v_xor_b32       v49, v42, v50
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa2         */ v_xor_b32       v51, 34, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632b         */ v_xor_b32       v49, v43, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa3         */ v_xor_b32       v51, 35, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38000 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526d29         */ v_xor_b32       v41, v41, v54
/*3a546f2a         */ v_xor_b32       v42, v42, v55
/*3a56712b         */ v_xor_b32       v43, v43, v56
/*3a58732c         */ v_xor_b32       v44, v44, v57
/*3a62632c         */ v_xor_b32       v49, v44, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3a         */ v_xor_b32       v39, v58, v39
/*3a50513b         */ v_xor_b32       v40, v59, v40
/*3a42433c         */ v_xor_b32       v33, v60, v33
/*3a44453d         */ v_xor_b32       v34, v61, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*3a4e4f3e         */ v_xor_b32       v39, v62, v39
/*3a50513f         */ v_xor_b32       v40, v63, v40
/*3a424340         */ v_xor_b32       v33, v64, v33
/*3a444541         */ v_xor_b32       v34, v65, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f42         */ v_xor_b32       v39, v66, v39
/*3a505143         */ v_xor_b32       v40, v67, v40
/*3a424344         */ v_xor_b32       v33, v68, v33
/*3a444545         */ v_xor_b32       v34, v69, v34
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa4         */ v_xor_b32       v51, 36, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053a34*/ tbuffer_load_format_xyzw v[58:61], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626327         */ v_xor_b32       v49, v39, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa5         */ v_xor_b32       v51, 37, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053e34*/ tbuffer_load_format_xyzw v[62:65], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626328         */ v_xor_b32       v49, v40, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa6         */ v_xor_b32       v51, 38, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054234*/ tbuffer_load_format_xyzw v[66:69], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626321         */ v_xor_b32       v49, v33, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60027 00026327*/ v_mul_lo_i32    v39, v39, v49
/*d2d60028 00026328*/ v_mul_lo_i32    v40, v40, v49
/*d2d60021 00026321*/ v_mul_lo_i32    v33, v33, v49
/*d2d60022 00026322*/ v_mul_lo_i32    v34, v34, v49
/*7e64020d         */ v_mov_b32       v50, s13
/*3a662aa7         */ v_xor_b32       v51, 39, v21
/*d2d60031 00026333*/ v_mul_lo_i32    v49, v51, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000033 004a3f25*/ v_cndmask_b32   v51, v37, v31, s[18:19]
/*d2d40033 00023733*/ v_mul_hi_u32    v51, v51, v27
/*4c68671b         */ v_sub_i32       v52, vcc, v27, v51
/*4a66671b         */ v_add_i32       v51, vcc, v27, v51
/*d2000033 004a6933*/ v_cndmask_b32   v51, v51, v52, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3400002d*/ ds_read_b32     v52, v45
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20034 00010f34*/ v_lshl_b64      v[52:53], v[52:53], 7
/*4a68680c         */ v_add_i32       v52, vcc, s12, v52
/*50646b32         */ v_addc_u32      v50, vcc, v50, v53, vcc
/*4a685f34         */ v_add_i32       v52, vcc, v52, v47
/*d2506a35 01a90132*/ v_addc_u32      v53, vcc, v50, 0, vcc
/*ebf38010 80053634*/ tbuffer_load_format_xyzw v[54:57], v[52:53], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054634*/ tbuffer_load_format_xyzw v[70:73], v[52:53], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6d27         */ v_xor_b32       v39, v39, v54
/*3a506f28         */ v_xor_b32       v40, v40, v55
/*3a427121         */ v_xor_b32       v33, v33, v56
/*3a447322         */ v_xor_b32       v34, v34, v57
/*3a626322         */ v_xor_b32       v49, v34, v49
/*d2d40032 00026333*/ v_mul_hi_u32    v50, v51, v49
/*d2d20033 00001d32*/ v_mul_lo_u32    v51, v50, s14
/*4c686731         */ v_sub_i32       v52, vcc, v49, v51
/*d18c0018 00026731*/ v_cmp_ge_u32    s[24:25], v49, v51
/*4a666481         */ v_add_i32       v51, vcc, 1, v50
/*4a6a64c1         */ v_add_i32       v53, vcc, -1, v50
/*7d86680e         */ v_cmp_le_u32    vcc, s14, v52
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00646732         */ v_cndmask_b32   v50, v50, v51, vcc
/*d2000032 00626535*/ v_cndmask_b32   v50, v53, v50, s[24:25]
/*d2000032 004a64c1*/ v_cndmask_b32   v50, -1, v50, s[18:19]
/*d2d60032 00001d32*/ v_mul_lo_i32    v50, v50, s14
/*4c626531         */ v_sub_i32       v49, vcc, v49, v50
/*bf8a0000         */ s_barrier
/*d8340c00 00003100*/ ds_write_b32    v0, v49 offset:3072
/*d8d80000 3100002d*/ ds_read_b32     v49, v45
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a5a620c         */ v_add_i32       v45, vcc, s12, v49
/*7e62020d         */ v_mov_b32       v49, s13
/*50626531         */ v_addc_u32      v49, vcc, v49, v50, vcc
/*4a045f2d         */ v_add_i32       v2, vcc, v45, v47
/*d2506a03 01a90131*/ v_addc_u32      v3, vcc, v49, 0, vcc
/*ebf38000 80053302*/ tbuffer_load_format_xyzw v[51:54], v[2:3], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054a02*/ tbuffer_load_format_xyzw v[74:77], v[2:3], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a52533a         */ v_xor_b32       v41, v58, v41
/*3a54553b         */ v_xor_b32       v42, v59, v42
/*3a56573c         */ v_xor_b32       v43, v60, v43
/*3a58593d         */ v_xor_b32       v44, v61, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a52533e         */ v_xor_b32       v41, v62, v41
/*3a54553f         */ v_xor_b32       v42, v63, v42
/*3a565740         */ v_xor_b32       v43, v64, v43
/*3a585941         */ v_xor_b32       v44, v65, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a525342         */ v_xor_b32       v41, v66, v41
/*3a545543         */ v_xor_b32       v42, v67, v42
/*3a565744         */ v_xor_b32       v43, v68, v43
/*3a585945         */ v_xor_b32       v44, v69, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525346         */ v_xor_b32       v41, v70, v41
/*3a545547         */ v_xor_b32       v42, v71, v42
/*3a565748         */ v_xor_b32       v43, v72, v43
/*3a585949         */ v_xor_b32       v44, v73, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526729         */ v_xor_b32       v41, v41, v51
/*3a54692a         */ v_xor_b32       v42, v42, v52
/*3a566b2b         */ v_xor_b32       v43, v43, v53
/*3a586d2c         */ v_xor_b32       v44, v44, v54
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e9527         */ v_xor_b32       v39, v39, v74
/*3a509728         */ v_xor_b32       v40, v40, v75
/*3a429921         */ v_xor_b32       v33, v33, v76
/*3a449b22         */ v_xor_b32       v34, v34, v77
/*bf8a0000         */ s_barrier
/*3a5a2aa8         */ v_xor_b32       v45, 40, v21
/*d2d6002d 0000132d*/ v_mul_lo_i32    v45, v45, s9
/*3a5a5b29         */ v_xor_b32       v45, v41, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d2d40031 00025b31*/ v_mul_hi_u32    v49, v49, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0012 0002652d*/ v_cmp_ge_u32    s[18:19], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 004a6334*/ v_cndmask_b32   v49, v52, v49, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*006262c1         */ v_cndmask_b32   v49, -1, v49, vcc
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a020d         */ v_mov_b32       v45, s13
/*7e6202ff 01000193*/ v_mov_b32       v49, 0x1000193
/*d2d60029 00026329*/ v_mul_lo_i32    v41, v41, v49
/*d2d6002a 0002632a*/ v_mul_lo_i32    v42, v42, v49
/*d2d6002b 0002632b*/ v_mul_lo_i32    v43, v43, v49
/*d2d6002c 0002632c*/ v_mul_lo_i32    v44, v44, v49
/*3a642aa9         */ v_xor_b32       v50, 41, v21
/*d2d60031 00026332*/ v_mul_lo_i32    v49, v50, v49
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*505a692d         */ v_addc_u32      v45, vcc, v45, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a9012d*/ v_addc_u32      v52, vcc, v45, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053933*/ tbuffer_load_format_xyzw v[57:60], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525335         */ v_xor_b32       v41, v53, v41
/*3a545536         */ v_xor_b32       v42, v54, v42
/*3a565737         */ v_xor_b32       v43, v55, v43
/*3a585938         */ v_xor_b32       v44, v56, v44
/*3a5a632a         */ v_xor_b32       v45, v42, v49
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aaa         */ v_xor_b32       v50, 42, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053d33*/ tbuffer_load_format_xyzw v[61:64], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526b29         */ v_xor_b32       v41, v41, v53
/*3a546d2a         */ v_xor_b32       v42, v42, v54
/*3a566f2b         */ v_xor_b32       v43, v43, v55
/*3a58712c         */ v_xor_b32       v44, v44, v56
/*3a5a5b2b         */ v_xor_b32       v45, v43, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aab         */ v_xor_b32       v50, 43, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38000 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054133*/ tbuffer_load_format_xyzw v[65:68], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526b29         */ v_xor_b32       v41, v41, v53
/*3a546d2a         */ v_xor_b32       v42, v42, v54
/*3a566f2b         */ v_xor_b32       v43, v43, v55
/*3a58712c         */ v_xor_b32       v44, v44, v56
/*3a5a5b2c         */ v_xor_b32       v45, v44, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f39         */ v_xor_b32       v39, v57, v39
/*3a50513a         */ v_xor_b32       v40, v58, v40
/*3a42433b         */ v_xor_b32       v33, v59, v33
/*3a44453c         */ v_xor_b32       v34, v60, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f3d         */ v_xor_b32       v39, v61, v39
/*3a50513e         */ v_xor_b32       v40, v62, v40
/*3a42433f         */ v_xor_b32       v33, v63, v33
/*3a444540         */ v_xor_b32       v34, v64, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f41         */ v_xor_b32       v39, v65, v39
/*3a505142         */ v_xor_b32       v40, v66, v40
/*3a424343         */ v_xor_b32       v33, v67, v33
/*3a444544         */ v_xor_b32       v34, v68, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aac         */ v_xor_b32       v50, 44, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053933*/ tbuffer_load_format_xyzw v[57:60], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a5a5b27         */ v_xor_b32       v45, v39, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aad         */ v_xor_b32       v50, 45, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053d33*/ tbuffer_load_format_xyzw v[61:64], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a5a5b28         */ v_xor_b32       v45, v40, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aae         */ v_xor_b32       v50, 46, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054133*/ tbuffer_load_format_xyzw v[65:68], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a5a5b21         */ v_xor_b32       v45, v33, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*3a642aaf         */ v_xor_b32       v50, 47, v21
/*d2d6002d 00025b32*/ v_mul_lo_i32    v45, v50, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000032 004a3f25*/ v_cndmask_b32   v50, v37, v31, s[18:19]
/*d2d40032 00023732*/ v_mul_hi_u32    v50, v50, v27
/*4c66651b         */ v_sub_i32       v51, vcc, v27, v50
/*4a64651b         */ v_add_i32       v50, vcc, v27, v50
/*d2000032 004a6732*/ v_cndmask_b32   v50, v50, v51, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 3300002e*/ ds_read_b32     v51, v46
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20033 00010f33*/ v_lshl_b64      v[51:52], v[51:52], 7
/*4a66660c         */ v_add_i32       v51, vcc, s12, v51
/*50626931         */ v_addc_u32      v49, vcc, v49, v52, vcc
/*4a665f33         */ v_add_i32       v51, vcc, v51, v47
/*d2506a34 01a90131*/ v_addc_u32      v52, vcc, v49, 0, vcc
/*ebf38010 80053533*/ tbuffer_load_format_xyzw v[53:56], v[51:52], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054533*/ tbuffer_load_format_xyzw v[69:72], v[51:52], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*3a5a5b22         */ v_xor_b32       v45, v34, v45
/*d2d40031 00025b32*/ v_mul_hi_u32    v49, v50, v45
/*d2d20032 00001d31*/ v_mul_lo_u32    v50, v49, s14
/*4c66652d         */ v_sub_i32       v51, vcc, v45, v50
/*d18c0018 0002652d*/ v_cmp_ge_u32    s[24:25], v45, v50
/*4a646281         */ v_add_i32       v50, vcc, 1, v49
/*4a6862c1         */ v_add_i32       v52, vcc, -1, v49
/*7d86660e         */ v_cmp_le_u32    vcc, s14, v51
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00626531         */ v_cndmask_b32   v49, v49, v50, vcc
/*d2000031 00626334*/ v_cndmask_b32   v49, v52, v49, s[24:25]
/*d2000031 004a62c1*/ v_cndmask_b32   v49, -1, v49, s[18:19]
/*d2d60031 00001d31*/ v_mul_lo_i32    v49, v49, s14
/*4c5a632d         */ v_sub_i32       v45, vcc, v45, v49
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*d8d80000 2d00002e*/ ds_read_b32     v45, v46
/*7e5c0280         */ v_mov_b32       v46, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c2002d 00010f2d*/ v_lshl_b64      v[45:46], v[45:46], 7
/*4a5a5a0c         */ v_add_i32       v45, vcc, s12, v45
/*7e62020d         */ v_mov_b32       v49, s13
/*505c5d31         */ v_addc_u32      v46, vcc, v49, v46, vcc
/*4a5a5f2d         */ v_add_i32       v45, vcc, v45, v47
/*d2506a2e 01a9012e*/ v_addc_u32      v46, vcc, v46, 0, vcc
/*ebf38000 8005312d*/ tbuffer_load_format_xyzw v[49:52], v[45:46], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 8005352d*/ tbuffer_load_format_xyzw v[53:56], v[45:46], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a525339         */ v_xor_b32       v41, v57, v41
/*3a54553a         */ v_xor_b32       v42, v58, v42
/*3a56573b         */ v_xor_b32       v43, v59, v43
/*3a58593c         */ v_xor_b32       v44, v60, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a52533d         */ v_xor_b32       v41, v61, v41
/*3a54553e         */ v_xor_b32       v42, v62, v42
/*3a56573f         */ v_xor_b32       v43, v63, v43
/*3a585940         */ v_xor_b32       v44, v64, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a525341         */ v_xor_b32       v41, v65, v41
/*3a545542         */ v_xor_b32       v42, v66, v42
/*3a565743         */ v_xor_b32       v43, v67, v43
/*3a585944         */ v_xor_b32       v44, v68, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525345         */ v_xor_b32       v41, v69, v41
/*3a545546         */ v_xor_b32       v42, v70, v42
/*3a565747         */ v_xor_b32       v43, v71, v43
/*3a585948         */ v_xor_b32       v44, v72, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526329         */ v_xor_b32       v41, v41, v49
/*3a54652a         */ v_xor_b32       v42, v42, v50
/*3a56672b         */ v_xor_b32       v43, v43, v51
/*3a58692c         */ v_xor_b32       v44, v44, v52
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e6b27         */ v_xor_b32       v39, v39, v53
/*3a506d28         */ v_xor_b32       v40, v40, v54
/*3a426f21         */ v_xor_b32       v33, v33, v55
/*3a447122         */ v_xor_b32       v34, v34, v56
/*bf8a0000         */ s_barrier
/*3a5a2ab0         */ v_xor_b32       v45, 48, v21
/*d2d6002d 0000132d*/ v_mul_lo_i32    v45, v45, s9
/*3a5a5b29         */ v_xor_b32       v45, v41, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d200002e 004a3f25*/ v_cndmask_b32   v46, v37, v31, s[18:19]
/*d2d4002e 0002372e*/ v_mul_hi_u32    v46, v46, v27
/*4c625d1b         */ v_sub_i32       v49, vcc, v27, v46
/*4a5c5d1b         */ v_add_i32       v46, vcc, v27, v46
/*d200002e 004a632e*/ v_cndmask_b32   v46, v46, v49, s[18:19]
/*d2d4002e 00025b2e*/ v_mul_hi_u32    v46, v46, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0012 0002632d*/ v_cmp_ge_u32    s[18:19], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 004a5d33*/ v_cndmask_b32   v46, v51, v46, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*005c5cc1         */ v_cndmask_b32   v46, -1, v46, vcc
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a020d         */ v_mov_b32       v45, s13
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*3a622ab1         */ v_xor_b32       v49, 49, v21
/*d2d6002e 00025d31*/ v_mul_lo_i32    v46, v49, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505a672d         */ v_addc_u32      v45, vcc, v45, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012d*/ v_addc_u32      v51, vcc, v45, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053832*/ tbuffer_load_format_xyzw v[56:59], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525334         */ v_xor_b32       v41, v52, v41
/*3a545535         */ v_xor_b32       v42, v53, v42
/*3a565736         */ v_xor_b32       v43, v54, v43
/*3a585937         */ v_xor_b32       v44, v55, v44
/*3a5a5d2a         */ v_xor_b32       v45, v42, v46
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab2         */ v_xor_b32       v49, 50, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053c32*/ tbuffer_load_format_xyzw v[60:63], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526929         */ v_xor_b32       v41, v41, v52
/*3a546b2a         */ v_xor_b32       v42, v42, v53
/*3a566d2b         */ v_xor_b32       v43, v43, v54
/*3a586f2c         */ v_xor_b32       v44, v44, v55
/*3a5a5b2b         */ v_xor_b32       v45, v43, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab3         */ v_xor_b32       v49, 51, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38000 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80054032*/ tbuffer_load_format_xyzw v[64:67], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526929         */ v_xor_b32       v41, v41, v52
/*3a546b2a         */ v_xor_b32       v42, v42, v53
/*3a566d2b         */ v_xor_b32       v43, v43, v54
/*3a586f2c         */ v_xor_b32       v44, v44, v55
/*3a5a5b2c         */ v_xor_b32       v45, v44, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f38         */ v_xor_b32       v39, v56, v39
/*3a505139         */ v_xor_b32       v40, v57, v40
/*3a42433a         */ v_xor_b32       v33, v58, v33
/*3a44453b         */ v_xor_b32       v34, v59, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f3c         */ v_xor_b32       v39, v60, v39
/*3a50513d         */ v_xor_b32       v40, v61, v40
/*3a42433e         */ v_xor_b32       v33, v62, v33
/*3a44453f         */ v_xor_b32       v34, v63, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f40         */ v_xor_b32       v39, v64, v39
/*3a505141         */ v_xor_b32       v40, v65, v40
/*3a424342         */ v_xor_b32       v33, v66, v33
/*3a444543         */ v_xor_b32       v34, v67, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab4         */ v_xor_b32       v49, 52, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053832*/ tbuffer_load_format_xyzw v[56:59], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5a5b27         */ v_xor_b32       v45, v39, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab5         */ v_xor_b32       v49, 53, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053c32*/ tbuffer_load_format_xyzw v[60:63], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5a5b28         */ v_xor_b32       v45, v40, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab6         */ v_xor_b32       v49, 54, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054032*/ tbuffer_load_format_xyzw v[64:67], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5a5b21         */ v_xor_b32       v45, v33, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a622ab7         */ v_xor_b32       v49, 55, v21
/*d2d6002d 00025b31*/ v_mul_lo_i32    v45, v49, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000031 004a3f25*/ v_cndmask_b32   v49, v37, v31, s[18:19]
/*d2d40031 00023731*/ v_mul_hi_u32    v49, v49, v27
/*4c64631b         */ v_sub_i32       v50, vcc, v27, v49
/*4a62631b         */ v_add_i32       v49, vcc, v27, v49
/*d2000031 004a6531*/ v_cndmask_b32   v49, v49, v50, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 32000030*/ ds_read_b32     v50, v48
/*7e660280         */ v_mov_b32       v51, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20032 00010f32*/ v_lshl_b64      v[50:51], v[50:51], 7
/*4a64640c         */ v_add_i32       v50, vcc, s12, v50
/*505c672e         */ v_addc_u32      v46, vcc, v46, v51, vcc
/*4a645f32         */ v_add_i32       v50, vcc, v50, v47
/*d2506a33 01a9012e*/ v_addc_u32      v51, vcc, v46, 0, vcc
/*ebf38010 80053432*/ tbuffer_load_format_xyzw v[52:55], v[50:51], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80054432*/ tbuffer_load_format_xyzw v[68:71], v[50:51], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*3a5a5b22         */ v_xor_b32       v45, v34, v45
/*d2d4002e 00025b31*/ v_mul_hi_u32    v46, v49, v45
/*d2d20031 00001d2e*/ v_mul_lo_u32    v49, v46, s14
/*4c64632d         */ v_sub_i32       v50, vcc, v45, v49
/*d18c0018 0002632d*/ v_cmp_ge_u32    s[24:25], v45, v49
/*4a625c81         */ v_add_i32       v49, vcc, 1, v46
/*4a665cc1         */ v_add_i32       v51, vcc, -1, v46
/*7d86640e         */ v_cmp_le_u32    vcc, s14, v50
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c632e         */ v_cndmask_b32   v46, v46, v49, vcc
/*d200002e 00625d33*/ v_cndmask_b32   v46, v51, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*d8d80000 2d000030*/ ds_read_b32     v45, v48
/*7e5c0280         */ v_mov_b32       v46, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c2002d 00010f2d*/ v_lshl_b64      v[45:46], v[45:46], 7
/*4a5a5a0c         */ v_add_i32       v45, vcc, s12, v45
/*7e60020d         */ v_mov_b32       v48, s13
/*505c5d30         */ v_addc_u32      v46, vcc, v48, v46, vcc
/*4a5a5f2d         */ v_add_i32       v45, vcc, v45, v47
/*d2506a2e 01a9012e*/ v_addc_u32      v46, vcc, v46, 0, vcc
/*ebf38000 8005302d*/ tbuffer_load_format_xyzw v[48:51], v[45:46], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 8005342d*/ tbuffer_load_format_xyzw v[52:55], v[45:46], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a525338         */ v_xor_b32       v41, v56, v41
/*3a545539         */ v_xor_b32       v42, v57, v42
/*3a56573a         */ v_xor_b32       v43, v58, v43
/*3a58593b         */ v_xor_b32       v44, v59, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a52533c         */ v_xor_b32       v41, v60, v41
/*3a54553d         */ v_xor_b32       v42, v61, v42
/*3a56573e         */ v_xor_b32       v43, v62, v43
/*3a58593f         */ v_xor_b32       v44, v63, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*3a525340         */ v_xor_b32       v41, v64, v41
/*3a545541         */ v_xor_b32       v42, v65, v42
/*3a565742         */ v_xor_b32       v43, v66, v43
/*3a585943         */ v_xor_b32       v44, v67, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a525344         */ v_xor_b32       v41, v68, v41
/*3a545545         */ v_xor_b32       v42, v69, v42
/*3a565746         */ v_xor_b32       v43, v70, v43
/*3a585947         */ v_xor_b32       v44, v71, v44
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526129         */ v_xor_b32       v41, v41, v48
/*3a54632a         */ v_xor_b32       v42, v42, v49
/*3a56652b         */ v_xor_b32       v43, v43, v50
/*3a58672c         */ v_xor_b32       v44, v44, v51
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e6927         */ v_xor_b32       v39, v39, v52
/*3a506b28         */ v_xor_b32       v40, v40, v53
/*3a426d21         */ v_xor_b32       v33, v33, v54
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*bf8a0000         */ s_barrier
/*3a5a2ab8         */ v_xor_b32       v45, 56, v21
/*d2d6002d 0000132d*/ v_mul_lo_i32    v45, v45, s9
/*3a5a5b29         */ v_xor_b32       v45, v41, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d200002e 004a3f25*/ v_cndmask_b32   v46, v37, v31, s[18:19]
/*d2d4002e 0002372e*/ v_mul_hi_u32    v46, v46, v27
/*4c605d1b         */ v_sub_i32       v48, vcc, v27, v46
/*4a5c5d1b         */ v_add_i32       v46, vcc, v27, v46
/*d200002e 004a612e*/ v_cndmask_b32   v46, v46, v48, s[18:19]
/*d2d4002e 00025b2e*/ v_mul_hi_u32    v46, v46, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0012 0002612d*/ v_cmp_ge_u32    s[18:19], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a12         */ s_and_b64       vcc, s[18:19], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 004a5d32*/ v_cndmask_b32   v46, v50, v46, s[18:19]
/*d10a006a 00001c80*/ v_cmp_lg_i32    vcc, 0, s14
/*005c5cc1         */ v_cndmask_b32   v46, -1, v46, vcc
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a020d         */ v_mov_b32       v45, s13
/*7e5c02ff 01000193*/ v_mov_b32       v46, 0x1000193
/*d2d60029 00025d29*/ v_mul_lo_i32    v41, v41, v46
/*d2d6002a 00025d2a*/ v_mul_lo_i32    v42, v42, v46
/*d2d6002b 00025d2b*/ v_mul_lo_i32    v43, v43, v46
/*d2d6002c 00025d2c*/ v_mul_lo_i32    v44, v44, v46
/*3a602ab9         */ v_xor_b32       v48, 57, v21
/*d2d6002e 00025d30*/ v_mul_lo_i32    v46, v48, v46
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505a652d         */ v_addc_u32      v45, vcc, v45, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012d*/ v_addc_u32      v50, vcc, v45, 0, vcc
/*ebf38000 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053731*/ tbuffer_load_format_xyzw v[55:58], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a525333         */ v_xor_b32       v41, v51, v41
/*3a545534         */ v_xor_b32       v42, v52, v42
/*3a565735         */ v_xor_b32       v43, v53, v43
/*3a585936         */ v_xor_b32       v44, v54, v44
/*3a5a5d2a         */ v_xor_b32       v45, v42, v46
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a602aba         */ v_xor_b32       v48, 58, v21
/*d2d6002d 00025b30*/ v_mul_lo_i32    v45, v48, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505c652e         */ v_addc_u32      v46, vcc, v46, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012e*/ v_addc_u32      v50, vcc, v46, 0, vcc
/*ebf38000 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053b31*/ tbuffer_load_format_xyzw v[59:62], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526729         */ v_xor_b32       v41, v41, v51
/*3a54692a         */ v_xor_b32       v42, v42, v52
/*3a566b2b         */ v_xor_b32       v43, v43, v53
/*3a586d2c         */ v_xor_b32       v44, v44, v54
/*3a5a5b2b         */ v_xor_b32       v45, v43, v45
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60029 00025b29*/ v_mul_lo_i32    v41, v41, v45
/*d2d6002a 00025b2a*/ v_mul_lo_i32    v42, v42, v45
/*d2d6002b 00025b2b*/ v_mul_lo_i32    v43, v43, v45
/*d2d6002c 00025b2c*/ v_mul_lo_i32    v44, v44, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a602abb         */ v_xor_b32       v48, 59, v21
/*d2d6002d 00025b30*/ v_mul_lo_i32    v45, v48, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505c652e         */ v_addc_u32      v46, vcc, v46, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012e*/ v_addc_u32      v50, vcc, v46, 0, vcc
/*ebf38000 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053f31*/ tbuffer_load_format_xyzw v[63:66], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a526729         */ v_xor_b32       v41, v41, v51
/*3a54692a         */ v_xor_b32       v42, v42, v52
/*3a566b2b         */ v_xor_b32       v43, v43, v53
/*3a586d2c         */ v_xor_b32       v44, v44, v54
/*3a5a5b2c         */ v_xor_b32       v45, v44, v45
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f37         */ v_xor_b32       v39, v55, v39
/*3a505138         */ v_xor_b32       v40, v56, v40
/*3a424339         */ v_xor_b32       v33, v57, v33
/*3a44453a         */ v_xor_b32       v34, v58, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*3a4e4f3b         */ v_xor_b32       v39, v59, v39
/*3a50513c         */ v_xor_b32       v40, v60, v40
/*3a42433d         */ v_xor_b32       v33, v61, v33
/*3a44453e         */ v_xor_b32       v34, v62, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a4e4f3f         */ v_xor_b32       v39, v63, v39
/*3a505140         */ v_xor_b32       v40, v64, v40
/*3a424341         */ v_xor_b32       v33, v65, v33
/*3a444542         */ v_xor_b32       v34, v66, v34
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a602abc         */ v_xor_b32       v48, 60, v21
/*d2d6002d 00025b30*/ v_mul_lo_i32    v45, v48, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505c652e         */ v_addc_u32      v46, vcc, v46, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012e*/ v_addc_u32      v50, vcc, v46, 0, vcc
/*ebf38010 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053731*/ tbuffer_load_format_xyzw v[55:58], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6727         */ v_xor_b32       v39, v39, v51
/*3a506928         */ v_xor_b32       v40, v40, v52
/*3a426b21         */ v_xor_b32       v33, v33, v53
/*3a446d22         */ v_xor_b32       v34, v34, v54
/*3a5a5b27         */ v_xor_b32       v45, v39, v45
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a602abd         */ v_xor_b32       v48, 61, v21
/*d2d6002d 00025b30*/ v_mul_lo_i32    v45, v48, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505c652e         */ v_addc_u32      v46, vcc, v46, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012e*/ v_addc_u32      v50, vcc, v46, 0, vcc
/*ebf38010 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053b31*/ tbuffer_load_format_xyzw v[59:62], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6727         */ v_xor_b32       v39, v39, v51
/*3a506928         */ v_xor_b32       v40, v40, v52
/*3a426b21         */ v_xor_b32       v33, v33, v53
/*3a446d22         */ v_xor_b32       v34, v34, v54
/*3a5a5b28         */ v_xor_b32       v45, v40, v45
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a602abe         */ v_xor_b32       v48, 62, v21
/*d2d6002d 00025b30*/ v_mul_lo_i32    v45, v48, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d2000030 004a3f25*/ v_cndmask_b32   v48, v37, v31, s[18:19]
/*d2d40030 00023730*/ v_mul_hi_u32    v48, v48, v27
/*4c62611b         */ v_sub_i32       v49, vcc, v27, v48
/*4a60611b         */ v_add_i32       v48, vcc, v27, v48
/*d2000030 004a6330*/ v_cndmask_b32   v48, v48, v49, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 31000018*/ ds_read_b32     v49, v24
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20031 00010f31*/ v_lshl_b64      v[49:50], v[49:50], 7
/*4a62620c         */ v_add_i32       v49, vcc, s12, v49
/*505c652e         */ v_addc_u32      v46, vcc, v46, v50, vcc
/*4a625f31         */ v_add_i32       v49, vcc, v49, v47
/*d2506a32 01a9012e*/ v_addc_u32      v50, vcc, v46, 0, vcc
/*ebf38010 80053331*/ tbuffer_load_format_xyzw v[51:54], v[49:50], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 80053f31*/ tbuffer_load_format_xyzw v[63:66], v[49:50], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a4e6727         */ v_xor_b32       v39, v39, v51
/*3a506928         */ v_xor_b32       v40, v40, v52
/*3a426b21         */ v_xor_b32       v33, v33, v53
/*3a446d22         */ v_xor_b32       v34, v34, v54
/*3a5a5b21         */ v_xor_b32       v45, v33, v45
/*d2d4002e 00025b30*/ v_mul_hi_u32    v46, v48, v45
/*d2d20030 00001d2e*/ v_mul_lo_u32    v48, v46, s14
/*4c62612d         */ v_sub_i32       v49, vcc, v45, v48
/*d18c0018 0002612d*/ v_cmp_ge_u32    s[24:25], v45, v48
/*4a605c81         */ v_add_i32       v48, vcc, 1, v46
/*4a645cc1         */ v_add_i32       v50, vcc, -1, v46
/*7d86620e         */ v_cmp_le_u32    vcc, s14, v49
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*005c612e         */ v_cndmask_b32   v46, v46, v48, vcc
/*d200002e 00625d32*/ v_cndmask_b32   v46, v50, v46, s[24:25]
/*d200002e 004a5cc1*/ v_cndmask_b32   v46, -1, v46, s[18:19]
/*d2d6002e 00001d2e*/ v_mul_lo_i32    v46, v46, s14
/*4c5a5d2d         */ v_sub_i32       v45, vcc, v45, v46
/*bf8a0000         */ s_barrier
/*d8340c00 00002d00*/ ds_write_b32    v0, v45 offset:3072
/*7e5a02ff 01000193*/ v_mov_b32       v45, 0x1000193
/*d2d60027 00025b27*/ v_mul_lo_i32    v39, v39, v45
/*d2d60028 00025b28*/ v_mul_lo_i32    v40, v40, v45
/*d2d60021 00025b21*/ v_mul_lo_i32    v33, v33, v45
/*d2d60022 00025b22*/ v_mul_lo_i32    v34, v34, v45
/*7e5c020d         */ v_mov_b32       v46, s13
/*3a2a2abf         */ v_xor_b32       v21, 63, v21
/*d2d60015 00025b15*/ v_mul_lo_i32    v21, v21, v45
/*d10a0012 00024680*/ v_cmp_lg_i32    s[18:19], 0, v35
/*d200001f 004a3f25*/ v_cndmask_b32   v31, v37, v31, s[18:19]
/*d2d4001f 0002371f*/ v_mul_hi_u32    v31, v31, v27
/*4c463f1b         */ v_sub_i32       v35, vcc, v27, v31
/*4a363f1b         */ v_add_i32       v27, vcc, v27, v31
/*d200001b 004a471b*/ v_cndmask_b32   v27, v27, v35, s[18:19]
/*d10a0012 00001c80*/ v_cmp_lg_i32    s[18:19], 0, s14
/*d8d80000 30000018*/ ds_read_b32     v48, v24
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20030 00010f30*/ v_lshl_b64      v[48:49], v[48:49], 7
/*4a3e600c         */ v_add_i32       v31, vcc, s12, v48
/*5046632e         */ v_addc_u32      v35, vcc, v46, v49, vcc
/*4a5a5f1f         */ v_add_i32       v45, vcc, v31, v47
/*d2506a2e 01a90123*/ v_addc_u32      v46, vcc, v35, 0, vcc
/*ebf38010 8005302d*/ tbuffer_load_format_xyzw v[48:51], v[45:46], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38000 8005432d*/ tbuffer_load_format_xyzw v[67:70], v[45:46], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a3e6127         */ v_xor_b32       v31, v39, v48
/*3a466328         */ v_xor_b32       v35, v40, v49
/*3a426521         */ v_xor_b32       v33, v33, v50
/*3a446722         */ v_xor_b32       v34, v34, v51
/*3a2a2b22         */ v_xor_b32       v21, v34, v21
/*d2d4001b 00022b1b*/ v_mul_hi_u32    v27, v27, v21
/*d2d20025 00001d1b*/ v_mul_lo_u32    v37, v27, s14
/*4c4e4b15         */ v_sub_i32       v39, vcc, v21, v37
/*d18c0018 00024b15*/ v_cmp_ge_u32    s[24:25], v21, v37
/*4a4a3681         */ v_add_i32       v37, vcc, 1, v27
/*4a5036c1         */ v_add_i32       v40, vcc, -1, v27
/*7d864e0e         */ v_cmp_le_u32    vcc, s14, v39
/*87ea6a18         */ s_and_b64       vcc, s[24:25], vcc
/*00364b1b         */ v_cndmask_b32   v27, v27, v37, vcc
/*d200001b 00623728*/ v_cndmask_b32   v27, v40, v27, s[24:25]
/*d200001b 004a36c1*/ v_cndmask_b32   v27, -1, v27, s[18:19]
/*d2d6001b 00001d1b*/ v_mul_lo_i32    v27, v27, s14
/*4c2a3715         */ v_sub_i32       v21, vcc, v21, v27
/*bf8a0000         */ s_barrier
/*d8340c00 00001500*/ ds_write_b32    v0, v21 offset:3072
/*d8d80000 27000018*/ ds_read_b32     v39, v24
/*7e500280         */ v_mov_b32       v40, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2c20027 00010f27*/ v_lshl_b64      v[39:40], v[39:40], 7
/*4a2a4e0c         */ v_add_i32       v21, vcc, s12, v39
/*7e30020d         */ v_mov_b32       v24, s13
/*50305118         */ v_addc_u32      v24, vcc, v24, v40, vcc
/*4a4e5f15         */ v_add_i32       v39, vcc, v21, v47
/*d2506a28 01a90118*/ v_addc_u32      v40, vcc, v24, 0, vcc
/*ebf38000 80052d27*/ tbuffer_load_format_xyzw v[45:48], v[39:40], s[20:23], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80053127*/ tbuffer_load_format_xyzw v[49:52], v[39:40], s[20:23], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*7e2a02ff 01000193*/ v_mov_b32       v21, 0x1000193
/*d2d60018 00022b29*/ v_mul_lo_i32    v24, v41, v21
/*d2d6001b 00022b2a*/ v_mul_lo_i32    v27, v42, v21
/*d2d60025 00022b2b*/ v_mul_lo_i32    v37, v43, v21
/*d2d60027 00022b2c*/ v_mul_lo_i32    v39, v44, v21
/*3a303137         */ v_xor_b32       v24, v55, v24
/*3a363738         */ v_xor_b32       v27, v56, v27
/*3a4a4b39         */ v_xor_b32       v37, v57, v37
/*3a4e4f3a         */ v_xor_b32       v39, v58, v39
/*d2d60018 00022b18*/ v_mul_lo_i32    v24, v24, v21
/*d2d6001b 00022b1b*/ v_mul_lo_i32    v27, v27, v21
/*d2d60025 00022b25*/ v_mul_lo_i32    v37, v37, v21
/*d2d60027 00022b27*/ v_mul_lo_i32    v39, v39, v21
/*3a30313b         */ v_xor_b32       v24, v59, v24
/*3a36373c         */ v_xor_b32       v27, v60, v27
/*3a4a4b3d         */ v_xor_b32       v37, v61, v37
/*3a4e4f3e         */ v_xor_b32       v39, v62, v39
/*d2d60018 00022b18*/ v_mul_lo_i32    v24, v24, v21
/*d2d6001b 00022b1b*/ v_mul_lo_i32    v27, v27, v21
/*d2d60025 00022b25*/ v_mul_lo_i32    v37, v37, v21
/*d2d60027 00022b27*/ v_mul_lo_i32    v39, v39, v21
/*3a30313f         */ v_xor_b32       v24, v63, v24
/*3a363740         */ v_xor_b32       v27, v64, v27
/*3a4a4b41         */ v_xor_b32       v37, v65, v37
/*3a4e4f42         */ v_xor_b32       v39, v66, v39
/*d2d60018 00022b18*/ v_mul_lo_i32    v24, v24, v21
/*d2d6001b 00022b1b*/ v_mul_lo_i32    v27, v27, v21
/*d2d60025 00022b25*/ v_mul_lo_i32    v37, v37, v21
/*d2d60027 00022b27*/ v_mul_lo_i32    v39, v39, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a303143         */ v_xor_b32       v24, v67, v24
/*3a363744         */ v_xor_b32       v27, v68, v27
/*3a4a4b45         */ v_xor_b32       v37, v69, v37
/*3a4e4f46         */ v_xor_b32       v39, v70, v39
/*d2d60018 00022b18*/ v_mul_lo_i32    v24, v24, v21
/*d2d6001b 00022b1b*/ v_mul_lo_i32    v27, v27, v21
/*d2d60025 00022b25*/ v_mul_lo_i32    v37, v37, v21
/*d2d60027 00022b27*/ v_mul_lo_i32    v39, v39, v21
/*d2d6001f 00022b1f*/ v_mul_lo_i32    v31, v31, v21
/*d2d60023 00022b23*/ v_mul_lo_i32    v35, v35, v21
/*d2d60021 00022b21*/ v_mul_lo_i32    v33, v33, v21
/*d2d60015 00022b22*/ v_mul_lo_i32    v21, v34, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a305b18         */ v_xor_b32       v24, v24, v45
/*3a365d1b         */ v_xor_b32       v27, v27, v46
/*3a445f25         */ v_xor_b32       v34, v37, v47
/*3a4a6127         */ v_xor_b32       v37, v39, v48
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a3e631f         */ v_xor_b32       v31, v31, v49
/*3a466523         */ v_xor_b32       v35, v35, v50
/*3a426721         */ v_xor_b32       v33, v33, v51
/*3a2a6915         */ v_xor_b32       v21, v21, v52
/*bf8a0000         */ s_barrier
/*d2d6001f 0000131f*/ v_mul_lo_i32    v31, v31, s9
/*3a3e3f23         */ v_xor_b32       v31, v35, v31
/*d2d6001f 0000131f*/ v_mul_lo_i32    v31, v31, s9
/*3a3e3f21         */ v_xor_b32       v31, v33, v31
/*d2d6001f 0000131f*/ v_mul_lo_i32    v31, v31, s9
/*3a063f15         */ v_xor_b32       v3, v21, v31
/*d2d60018 00001318*/ v_mul_lo_i32    v24, v24, s9
/*3a30311b         */ v_xor_b32       v24, v27, v24
/*d2d60018 00001318*/ v_mul_lo_i32    v24, v24, s9
/*3a303122         */ v_xor_b32       v24, v34, v24
/*d2d60018 00001318*/ v_mul_lo_i32    v24, v24, s9
/*3a043125         */ v_xor_b32       v2, v37, v24
/*bf8a0000         */ s_barrier
/*d9340000 0000020b*/ ds_write_b64    v11, v[2:3]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be92047e         */ s_mov_b64       s[18:19], exec
/*8afe0a12         */ s_andn2_b64     exec, s[18:19], s[10:11]
/*4a040a88         */ v_add_i32       v2, vcc, 8, v5
/*bf880011         */ s_cbranch_execz .L24240_0
/*4a0e0a98         */ v_add_i32       v7, vcc, 24, v5
/*4a120a90         */ v_add_i32       v9, vcc, 16, v5
/*d9d80000 16000005*/ ds_read_b64     v[22:23], v5
/*d9d80000 52000002*/ ds_read_b64     v[82:83], v2
/*d9d80000 50000007*/ ds_read_b64     v[80:81], v7
/*d9d80000 4e000009*/ ds_read_b64     v[78:79], v9
/*bf8c017f         */ s_waitcnt       lgkmcnt(1)
/*7eb20351         */ v_mov_b32       v89, v81
/*7ea80317         */ v_mov_b32       v84, v23
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7eb4034f         */ v_mov_b32       v90, v79
/*7e9e0352         */ v_mov_b32       v79, v82
/*7ea4035a         */ v_mov_b32       v82, v90
.L24240_0:
/*befe0412         */ s_mov_b64       exec, s[18:19]
/*bf8a0000         */ s_barrier
/*80008100         */ s_add_u32       s0, s0, 1
/*81818101         */ s_sub_i32       s1, s1, 1
/*bf82eb17         */ s_branch        .L2848_0
.L24260_0:
/*7e880280         */ v_mov_b32       v68, 0
/*7e8a0281         */ v_mov_b32       v69, 1
/*7e8c0280         */ v_mov_b32       v70, 0
/*7e8e0280         */ v_mov_b32       v71, 0
/*7e900280         */ v_mov_b32       v72, 0
/*7e920280         */ v_mov_b32       v73, 0
/*7e940280         */ v_mov_b32       v74, 0
/*7e960280         */ v_mov_b32       v75, 0
/*7e9802ff 80000000*/ v_mov_b32       v76, 0x80000000
/*7e160280         */ v_mov_b32       v11, 0
/*7e220280         */ v_mov_b32       v17, 0
/*7e240280         */ v_mov_b32       v18, 0
/*7e2e0280         */ v_mov_b32       v23, 0
/*7e9a0280         */ v_mov_b32       v77, 0
/*7e360280         */ v_mov_b32       v27, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*b0000000         */ s_movk_i32      s0, 0x0
/*7e0e0280         */ v_mov_b32       v7, 0
/*7e300280         */ v_mov_b32       v24, 0
/*7e100280         */ v_mov_b32       v8, 0
/*7e420280         */ v_mov_b32       v33, 0
/*7e440280         */ v_mov_b32       v34, 0
/*7e4e030c         */ v_mov_b32       v39, v12
/*7e50030a         */ v_mov_b32       v40, v10
/*7e52030e         */ v_mov_b32       v41, v14
/*7e54030d         */ v_mov_b32       v42, v13
/*7e5a0314         */ v_mov_b32       v45, v20
/*7e5c0319         */ v_mov_b32       v46, v25
/*7e60031a         */ v_mov_b32       v48, v26
/*7e64031e         */ v_mov_b32       v50, v30
/*7e280280         */ v_mov_b32       v20, 0
/*7e180280         */ v_mov_b32       v12, 0
/*7e320280         */ v_mov_b32       v25, 0
/*7e340280         */ v_mov_b32       v26, 0
/*7e1c0280         */ v_mov_b32       v14, 0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
.L24416_0:
/*bf029600         */ s_cmp_gt_i32    s0, 22
/*bf850197         */ s_cbranch_scc1  .L26052_0
/*bf008008         */ s_cmp_eq_i32    s8, 0
/*bf85fffc         */ s_cbranch_scc1  .L24416_0
/*3a664916         */ v_xor_b32       v51, v22, v36
/*3a682754         */ v_xor_b32       v52, v84, v19
/*3a666747         */ v_xor_b32       v51, v71, v51
/*3a686948         */ v_xor_b32       v52, v72, v52
/*3a66670e         */ v_xor_b32       v51, v14, v51
/*3a686907         */ v_xor_b32       v52, v7, v52
/*3a666717         */ v_xor_b32       v51, v23, v51
/*3a68694d         */ v_xor_b32       v52, v77, v52
/*d29c0035 027e6933*/ v_alignbit_b32  v53, v51, v52, 31
/*d29c0036 027e6734*/ v_alignbit_b32  v54, v52, v51, 31
/*3a6eb130         */ v_xor_b32       v55, v48, v88
/*3a70af1c         */ v_xor_b32       v56, v28, v87
/*3a6e6f50         */ v_xor_b32       v55, v80, v55
/*3a707159         */ v_xor_b32       v56, v89, v56
/*3a6e6f4b         */ v_xor_b32       v55, v75, v55
/*3a70714c         */ v_xor_b32       v56, v76, v56
/*3a6e6f11         */ v_xor_b32       v55, v17, v55
/*3a707112         */ v_xor_b32       v56, v18, v56
/*3a6a6f35         */ v_xor_b32       v53, v53, v55
/*3a6c7136         */ v_xor_b32       v54, v54, v56
/*3a726b45         */ v_xor_b32       v57, v69, v53
/*3a746d46         */ v_xor_b32       v58, v70, v54
/*d29c003b 0256733a*/ v_alignbit_b32  v59, v58, v57, 21
/*d29c0039 02567539*/ v_alignbit_b32  v57, v57, v58, 21
/*3a74ad2e         */ v_xor_b32       v58, v46, v86
/*3a78ab2d         */ v_xor_b32       v60, v45, v85
/*3a067545         */ v_xor_b32       v3, v69, v58
/*3a087946         */ v_xor_b32       v4, v70, v60
/*3a060749         */ v_xor_b32       v3, v73, v3
/*3a08094a         */ v_xor_b32       v4, v74, v4
/*3a060718         */ v_xor_b32       v3, v24, v3
/*3a080908         */ v_xor_b32       v4, v8, v4
/*d29c003a 027e0903*/ v_alignbit_b32  v58, v3, v4, 31
/*d29c003c 027e0704*/ v_alignbit_b32  v60, v4, v3, 31
/*3a7a5132         */ v_xor_b32       v61, v50, v40
/*3a7c4f20         */ v_xor_b32       v62, v32, v39
/*3a7a7b4e         */ v_xor_b32       v61, v78, v61
/*3a7c7d52         */ v_xor_b32       v62, v82, v62
/*3a7a7b19         */ v_xor_b32       v61, v25, v61
/*3a7c7d1a         */ v_xor_b32       v62, v26, v62
/*3a7a7b21         */ v_xor_b32       v61, v33, v61
/*3a7c7d22         */ v_xor_b32       v62, v34, v62
/*3a747b3a         */ v_xor_b32       v58, v58, v61
/*3a787d3c         */ v_xor_b32       v60, v60, v62
/*3a4c7558         */ v_xor_b32       v38, v88, v58
/*3a4a7957         */ v_xor_b32       v37, v87, v60
/*d29c003f 02524d25*/ v_alignbit_b32  v63, v37, v38, 20
/*d29c0025 02524b26*/ v_alignbit_b32  v37, v38, v37, 20
/*3a4c554f         */ v_xor_b32       v38, v79, v42
/*3a805353         */ v_xor_b32       v64, v83, v41
/*3a4c4d0b         */ v_xor_b32       v38, v11, v38
/*3a80810c         */ v_xor_b32       v64, v12, v64
/*3a4c4d1b         */ v_xor_b32       v38, v27, v38
/*3a808151         */ v_xor_b32       v64, v81, v64
/*3a4c4d14         */ v_xor_b32       v38, v20, v38
/*3a808144         */ v_xor_b32       v64, v68, v64
/*d29c0041 027e8126*/ v_alignbit_b32  v65, v38, v64, 31
/*d29c0042 027e4d40*/ v_alignbit_b32  v66, v64, v38, 31
/*3a068303         */ v_xor_b32       v3, v3, v65
/*3a088504         */ v_xor_b32       v4, v4, v66
/*3a3a070e         */ v_xor_b32       v29, v14, v3
/*3a3c0907         */ v_xor_b32       v30, v7, v4
/*d29c0041 022e3d1d*/ v_alignbit_b32  v65, v29, v30, 11
/*d29c001d 022e3b1e*/ v_alignbit_b32  v29, v30, v29, 11
/*3a3c833f         */ v_xor_b32       v30, v63, v65
/*3a843b25         */ v_xor_b32       v66, v37, v29
/*d294001e 047a7f3b*/ v_bfi_b32       v30, v59, v63, v30
/*d2940042 050a4b39*/ v_bfi_b32       v66, v57, v37, v66
/*d29c0043 027e7137*/ v_alignbit_b32  v67, v55, v56, 31
/*d29c0037 027e6f38*/ v_alignbit_b32  v55, v56, v55, 31
/*3a4c8726         */ v_xor_b32       v38, v38, v67
/*3a6e6f40         */ v_xor_b32       v55, v64, v55
/*3a644d32         */ v_xor_b32       v50, v50, v38
/*3a626f20         */ v_xor_b32       v49, v32, v55
/*3a70653b         */ v_xor_b32       v56, v59, v50
/*3a806339         */ v_xor_b32       v64, v57, v49
/*d2940038 04e2653f*/ v_bfi_b32       v56, v63, v50, v56
/*d2940040 05026325*/ v_bfi_b32       v64, v37, v49, v64
/*91019f00         */ s_ashr_i32      s1, s0, 31
/*8f8a8300         */ s_lshl_b64      s[10:11], s[0:1], 3
/*800a0a04         */ s_add_u32       s10, s4, s10
/*820b0b05         */ s_addc_u32      s11, s5, s11
/*938dff1d 00100000*/ s_bfe_u32       s13, s29, 0x100000
/*be8c031c         */ s_mov_b32       s12, s28
/*800a0a0c         */ s_add_u32       s10, s12, s10
/*820b0b0d         */ s_addc_u32      s11, s13, s11
/*c0450b00         */ s_load_dwordx2  s[10:11], s[10:11], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*3a70700a         */ v_xor_b32       v56, s10, v56
/*3a80800b         */ v_xor_b32       v64, s11, v64
/*d29c0043 027e7d3d*/ v_alignbit_b32  v67, v61, v62, 31
/*d29c003d 027e7b3e*/ v_alignbit_b32  v61, v62, v61, 31
/*3a668733         */ v_xor_b32       v51, v51, v67
/*3a687b34         */ v_xor_b32       v52, v52, v61
/*3a006714         */ v_xor_b32       v0, v20, v51
/*3a046944         */ v_xor_b32       v2, v68, v52
/*d29c003d 024a0500*/ v_alignbit_b32  v61, v0, v2, 18
/*d29c0000 024a0102*/ v_alignbit_b32  v0, v2, v0, 18
/*3a046541         */ v_xor_b32       v2, v65, v50
/*3a7c631d         */ v_xor_b32       v62, v29, v49
/*d2940002 040a833d*/ v_bfi_b32       v2, v61, v65, v2
/*d294003e 04fa3b00*/ v_bfi_b32       v62, v0, v29, v62
/*3a867b3b         */ v_xor_b32       v67, v59, v61
/*3a880139         */ v_xor_b32       v68, v57, v0
/*d294003b 050e7741*/ v_bfi_b32       v59, v65, v59, v67
/*d294001d 0512731d*/ v_bfi_b32       v29, v29, v57, v68
/*3a1e674f         */ v_xor_b32       v15, v79, v51
/*3a206953         */ v_xor_b32       v16, v83, v52
/*d29c0039 0232210f*/ v_alignbit_b32  v57, v15, v16, 12
/*d29c000f 02321f10*/ v_alignbit_b32  v15, v16, v15, 12
/*3a1a4d4e         */ v_xor_b32       v13, v78, v38
/*3a1c6f52         */ v_xor_b32       v14, v82, v55
/*d29c0010 02761d0d*/ v_alignbit_b32  v16, v13, v14, 29
/*d29c000d 02761b0e*/ v_alignbit_b32  v13, v14, v13, 29
/*3a1c0724         */ v_xor_b32       v14, v36, v3
/*3a560913         */ v_xor_b32       v43, v19, v4
/*d29c002c 0212570e*/ v_alignbit_b32  v44, v14, v43, 4
/*d29c000e 02121d2b*/ v_alignbit_b32  v14, v43, v14, 4
/*3a565910         */ v_xor_b32       v43, v16, v44
/*3a821d0d         */ v_xor_b32       v65, v13, v14
/*d294002b 04ae5939*/ v_bfi_b32       v43, v57, v44, v43
/*d2940041 05061d0f*/ v_bfi_b32       v65, v15, v14, v65
/*3a7e7b3f         */ v_xor_b32       v63, v63, v61
/*3a4a0125         */ v_xor_b32       v37, v37, v0
/*d2940032 04fe7b32*/ v_bfi_b32       v50, v50, v61, v63
/*d2940000 04960131*/ v_bfi_b32       v0, v49, v0, v37
/*3a3e6b18         */ v_xor_b32       v31, v24, v53
/*3a406d08         */ v_xor_b32       v32, v8, v54
/*d29c0025 020e3f20*/ v_alignbit_b32  v37, v32, v31, 3
/*d29c001f 020e411f*/ v_alignbit_b32  v31, v31, v32, 3
/*3a404b10         */ v_xor_b32       v32, v16, v37
/*3a623f0d         */ v_xor_b32       v49, v13, v31
/*3a12754b         */ v_xor_b32       v9, v75, v58
/*3a14794c         */ v_xor_b32       v10, v76, v60
/*d29c003d 024e130a*/ v_alignbit_b32  v61, v10, v9, 19
/*d29c0009 024e1509*/ v_alignbit_b32  v9, v9, v10, 19
/*d294000a 0482213d*/ v_bfi_b32       v10, v61, v16, v32
/*d2940020 04c61b09*/ v_bfi_b32       v32, v9, v13, v49
/*3a627b39         */ v_xor_b32       v49, v57, v61
/*3a7e130f         */ v_xor_b32       v63, v15, v9
/*d2940058 04c67310*/ v_bfi_b32       v88, v16, v57, v49
/*d2940057 04fe1f0d*/ v_bfi_b32       v87, v13, v15, v63
/*3a627b2c         */ v_xor_b32       v49, v44, v61
/*3a7e130e         */ v_xor_b32       v63, v14, v9
/*d2940031 04c67b25*/ v_bfi_b32       v49, v37, v61, v49
/*d2940009 04fe131f*/ v_bfi_b32       v9, v31, v9, v63
/*3a724b39         */ v_xor_b32       v57, v57, v37
/*3a1e3f0f         */ v_xor_b32       v15, v15, v31
/*d294004f 04e64b2c*/ v_bfi_b32       v79, v44, v37, v57
/*d2940053 043e3f0e*/ v_bfi_b32       v83, v14, v31, v15
/*3a1ead35         */ v_xor_b32       v15, v53, v86
/*3a3eab36         */ v_xor_b32       v31, v54, v85
/*d29c0023 026a3f0f*/ v_alignbit_b32  v35, v15, v31, 26
/*d29c000f 026a1f1f*/ v_alignbit_b32  v15, v31, v15, 26
/*3a3e7530         */ v_xor_b32       v31, v48, v58
/*3a48791c         */ v_xor_b32       v36, v28, v60
/*d29c002c 027e491f*/ v_alignbit_b32  v44, v31, v36, 31
/*d29c001f 027e3f24*/ v_alignbit_b32  v31, v36, v31, 31
/*3a0a0747         */ v_xor_b32       v5, v71, v3
/*3a0c0948         */ v_xor_b32       v6, v72, v4
/*d29c0024 021e0d05*/ v_alignbit_b32  v36, v5, v6, 7
/*d29c0005 021e0b06*/ v_alignbit_b32  v5, v6, v5, 7
/*3a0c492c         */ v_xor_b32       v6, v44, v36
/*3a5e0b1f         */ v_xor_b32       v47, v31, v5
/*d294004e 041a5923*/ v_bfi_b32       v78, v35, v44, v6
/*d2940052 04be3f0f*/ v_bfi_b32       v82, v15, v31, v47
/*3a36671b         */ v_xor_b32       v27, v27, v51
/*3a386951         */ v_xor_b32       v28, v81, v52
/*d29c0030 0262391b*/ v_alignbit_b32  v48, v27, v28, 24
/*d29c001b 0262371c*/ v_alignbit_b32  v27, v28, v27, 24
/*3a386123         */ v_xor_b32       v28, v35, v48
/*3a72370f         */ v_xor_b32       v57, v15, v27
/*d294001c 04724724*/ v_bfi_b32       v28, v36, v35, v28
/*d2940039 04e61f05*/ v_bfi_b32       v57, v5, v15, v57
/*3a7a612c         */ v_xor_b32       v61, v44, v48
/*3a7e371f         */ v_xor_b32       v63, v31, v27
/*3a424d21         */ v_xor_b32       v33, v33, v38
/*3a446f22         */ v_xor_b32       v34, v34, v55
/*d29c0043 023a4521*/ v_alignbit_b32  v67, v33, v34, 14
/*d29c0021 023a4322*/ v_alignbit_b32  v33, v34, v33, 14
/*d2940047 04f66143*/ v_bfi_b32       v71, v67, v48, v61
/*d2940048 04fe3721*/ v_bfi_b32       v72, v33, v27, v63
/*3a7e8724         */ v_xor_b32       v63, v36, v67
/*3a884305         */ v_xor_b32       v68, v5, v33
/*d2940045 04fe4930*/ v_bfi_b32       v69, v48, v36, v63
/*d2940046 05120b1b*/ v_bfi_b32       v70, v27, v5, v68
/*3a267550         */ v_xor_b32       v19, v80, v58
/*3a287959         */ v_xor_b32       v20, v89, v60
/*d29c001b 025a2913*/ v_alignbit_b32  v27, v19, v20, 22
/*d29c0013 025a2714*/ v_alignbit_b32  v19, v20, v19, 22
/*3a28672a         */ v_xor_b32       v20, v42, v51
/*3a526929         */ v_xor_b32       v41, v41, v52
/*d29c002a 02165314*/ v_alignbit_b32  v42, v20, v41, 5
/*d29c0014 02162929*/ v_alignbit_b32  v20, v41, v20, 5
/*3a52551b         */ v_xor_b32       v41, v27, v42
/*3a602913         */ v_xor_b32       v48, v19, v20
/*3a504d28         */ v_xor_b32       v40, v40, v38
/*3a4e6f27         */ v_xor_b32       v39, v39, v55
/*d29c003f 02725127*/ v_alignbit_b32  v63, v39, v40, 28
/*d29c0027 02724f28*/ v_alignbit_b32  v39, v40, v39, 28
/*d2940028 04a6553f*/ v_bfi_b32       v40, v63, v42, v41
/*d2940029 04c22927*/ v_bfi_b32       v41, v39, v20, v48
/*3a468723         */ v_xor_b32       v35, v35, v67
/*3a1e430f         */ v_xor_b32       v15, v15, v33
/*d2940023 048e872c*/ v_bfi_b32       v35, v44, v67, v35
/*d294000f 043e431f*/ v_bfi_b32       v15, v31, v33, v15
/*3a0e6b49         */ v_xor_b32       v7, v73, v53
/*3a106d4a         */ v_xor_b32       v8, v74, v54
/*d29c001f 02461107*/ v_alignbit_b32  v31, v7, v8, 17
/*d29c0007 02460f08*/ v_alignbit_b32  v7, v8, v7, 17
/*3a100717         */ v_xor_b32       v8, v23, v3
/*3a2e094d         */ v_xor_b32       v23, v77, v4
/*d29c0018 02221117*/ v_alignbit_b32  v24, v23, v8, 8
/*d29c0008 02222f08*/ v_alignbit_b32  v8, v8, v23, 8
/*3a2e311b         */ v_xor_b32       v23, v27, v24
/*3a421113         */ v_xor_b32       v33, v19, v8
/*d2940049 045e371f*/ v_bfi_b32       v73, v31, v27, v23
/*d294004a 04862707*/ v_bfi_b32       v74, v7, v19, v33
/*3a583f3f         */ v_xor_b32       v44, v63, v31
/*3a600f27         */ v_xor_b32       v48, v39, v7
/*d294004b 04b27f1b*/ v_bfi_b32       v75, v27, v63, v44
/*d294004c 04c24f13*/ v_bfi_b32       v76, v19, v39, v48
/*3a58313f         */ v_xor_b32       v44, v63, v24
/*3a4e1127         */ v_xor_b32       v39, v39, v8
/*d294001b 04b2312a*/ v_bfi_b32       v27, v42, v24, v44
/*d2940051 049e1114*/ v_bfi_b32       v81, v20, v8, v39
/*3a543f2a         */ v_xor_b32       v42, v42, v31
/*3a280f14         */ v_xor_b32       v20, v20, v7
/*d294000e 04aa3f18*/ v_bfi_b32       v14, v24, v31, v42
/*d2940007 04520f08*/ v_bfi_b32       v7, v8, v7, v20
/*3a10670b         */ v_xor_b32       v8, v11, v51
/*3a16690c         */ v_xor_b32       v11, v12, v52
/*d29c000c 0266110b*/ v_alignbit_b32  v12, v11, v8, 25
/*d29c0008 02661708*/ v_alignbit_b32  v8, v8, v11, 25
/*3a164d19         */ v_xor_b32       v11, v25, v38
/*3a286f1a         */ v_xor_b32       v20, v26, v55
/*d29c0019 025e1714*/ v_alignbit_b32  v25, v20, v11, 23
/*d29c000b 025e290b*/ v_alignbit_b32  v11, v11, v20, 23
/*3a060716         */ v_xor_b32       v3, v22, v3
/*3a080954         */ v_xor_b32       v4, v84, v4
/*d29c0014 02260704*/ v_alignbit_b32  v20, v4, v3, 9
/*d29c0003 02260903*/ v_alignbit_b32  v3, v3, v4, 9
/*3a082919         */ v_xor_b32       v4, v25, v20
/*3a2a070b         */ v_xor_b32       v21, v11, v3
/*d2940004 0412290c*/ v_bfi_b32       v4, v12, v20, v4
/*d2940015 04560708*/ v_bfi_b32       v21, v8, v3, v21
/*3a2c6b2e         */ v_xor_b32       v22, v46, v53
/*3a346d2d         */ v_xor_b32       v26, v45, v54
/*d29c001f 020a2d1a*/ v_alignbit_b32  v31, v26, v22, 2
/*d29c0016 020a3516*/ v_alignbit_b32  v22, v22, v26, 2
/*3a343f0c         */ v_xor_b32       v26, v12, v31
/*3a4c2d08         */ v_xor_b32       v38, v8, v22
/*d2940021 046a3f14*/ v_bfi_b32       v33, v20, v31, v26
/*d2940022 049a2d03*/ v_bfi_b32       v34, v3, v22, v38
/*3a543f19         */ v_xor_b32       v42, v25, v31
/*3a5a2d0b         */ v_xor_b32       v45, v11, v22
/*3a227511         */ v_xor_b32       v17, v17, v58
/*3a247912         */ v_xor_b32       v18, v18, v60
/*d29c002e 027a2511*/ v_alignbit_b32  v46, v17, v18, 30
/*d29c0011 027a2312*/ v_alignbit_b32  v17, v18, v17, 30
/*d2940017 04aa332e*/ v_bfi_b32       v23, v46, v25, v42
/*d294004d 04b61711*/ v_bfi_b32       v77, v17, v11, v45
/*3a5a5d0c         */ v_xor_b32       v45, v12, v46
/*3a602308         */ v_xor_b32       v48, v8, v17
/*d2940018 04b61919*/ v_bfi_b32       v24, v25, v12, v45
/*d2940008 04c2110b*/ v_bfi_b32       v8, v11, v8, v48
/*3a165d14         */ v_xor_b32       v11, v20, v46
/*3a062303         */ v_xor_b32       v3, v3, v17
/*d2940014 042e5d1f*/ v_bfi_b32       v20, v31, v46, v11
/*d2940044 040e2316*/ v_bfi_b32       v68, v22, v17, v3
/*80008100         */ s_add_u32       s0, s0, 1
/*7e160323         */ v_mov_b32       v11, v35
/*7e18030f         */ v_mov_b32       v12, v15
/*7e220304         */ v_mov_b32       v17, v4
/*7e240315         */ v_mov_b32       v18, v21
/*7ea0031c         */ v_mov_b32       v80, v28
/*7eb20339         */ v_mov_b32       v89, v57
/*7e2c0331         */ v_mov_b32       v22, v49
/*7ea80309         */ v_mov_b32       v84, v9
/*7e320328         */ v_mov_b32       v25, v40
/*7e340329         */ v_mov_b32       v26, v41
/*7eaa0320         */ v_mov_b32       v85, v32
/*7eac030a         */ v_mov_b32       v86, v10
/*7e4e0341         */ v_mov_b32       v39, v65
/*7e50032b         */ v_mov_b32       v40, v43
/*7e520300         */ v_mov_b32       v41, v0
/*7e540332         */ v_mov_b32       v42, v50
/*7e26033e         */ v_mov_b32       v19, v62
/*7e480302         */ v_mov_b32       v36, v2
/*7e5a031d         */ v_mov_b32       v45, v29
/*7e5c033b         */ v_mov_b32       v46, v59
/*7e380342         */ v_mov_b32       v28, v66
/*7e60031e         */ v_mov_b32       v48, v30
/*7e400340         */ v_mov_b32       v32, v64
/*7e640338         */ v_mov_b32       v50, v56
/*bf82fe67         */ s_branch        .L24416_0
.L26052_0:
/*3a2a4916         */ v_xor_b32       v21, v22, v36
/*3a2c2754         */ v_xor_b32       v22, v84, v19
/*3a0a2b47         */ v_xor_b32       v5, v71, v21
/*3a0c2d48         */ v_xor_b32       v6, v72, v22
/*3a0a0b0e         */ v_xor_b32       v5, v14, v5
/*3a0c0d07         */ v_xor_b32       v6, v7, v6
/*3a0a0b17         */ v_xor_b32       v5, v23, v5
/*3a0c0d4d         */ v_xor_b32       v6, v77, v6
/*d29c0015 027e0d05*/ v_alignbit_b32  v21, v5, v6, 31
/*d29c0005 027e0b06*/ v_alignbit_b32  v5, v6, v5, 31
/*3a0cb130         */ v_xor_b32       v6, v48, v88
/*3a2caf1c         */ v_xor_b32       v22, v28, v87
/*3a0c0d50         */ v_xor_b32       v6, v80, v6
/*3a262d59         */ v_xor_b32       v19, v89, v22
/*3a0c0d4b         */ v_xor_b32       v6, v75, v6
/*3a12274c         */ v_xor_b32       v9, v76, v19
/*3a0c0d11         */ v_xor_b32       v6, v17, v6
/*3a121312         */ v_xor_b32       v9, v18, v9
/*3a140d15         */ v_xor_b32       v10, v21, v6
/*3a0a1305         */ v_xor_b32       v5, v5, v9
/*3a141545         */ v_xor_b32       v10, v69, v10
/*3a0a0b46         */ v_xor_b32       v5, v70, v5
/*d29c0011 02561505*/ v_alignbit_b32  v17, v5, v10, 21
/*d29c0005 02560b0a*/ v_alignbit_b32  v5, v10, v5, 21
/*3a14ad2e         */ v_xor_b32       v10, v46, v86
/*3a24ab2d         */ v_xor_b32       v18, v45, v85
/*3a061545         */ v_xor_b32       v3, v69, v10
/*3a082546         */ v_xor_b32       v4, v70, v18
/*3a060749         */ v_xor_b32       v3, v73, v3
/*3a08094a         */ v_xor_b32       v4, v74, v4
/*3a060718         */ v_xor_b32       v3, v24, v3
/*3a080908         */ v_xor_b32       v4, v8, v4
/*d29c0007 027e0903*/ v_alignbit_b32  v7, v3, v4, 31
/*d29c0003 027e0704*/ v_alignbit_b32  v3, v4, v3, 31
/*3a085132         */ v_xor_b32       v4, v50, v40
/*3a104f20         */ v_xor_b32       v8, v32, v39
/*3a08094e         */ v_xor_b32       v4, v78, v4
/*3a101152         */ v_xor_b32       v8, v82, v8
/*3a080919         */ v_xor_b32       v4, v25, v4
/*3a10111a         */ v_xor_b32       v8, v26, v8
/*3a080921         */ v_xor_b32       v4, v33, v4
/*3a101122         */ v_xor_b32       v8, v34, v8
/*3a080907         */ v_xor_b32       v4, v7, v4
/*3a061103         */ v_xor_b32       v3, v3, v8
/*3a080958         */ v_xor_b32       v4, v88, v4
/*3a060757         */ v_xor_b32       v3, v87, v3
/*d29c0007 02520903*/ v_alignbit_b32  v7, v3, v4, 20
/*d29c0003 02520704*/ v_alignbit_b32  v3, v4, v3, 20
/*d29c0004 027e1306*/ v_alignbit_b32  v4, v6, v9, 31
/*d29c0006 027e0d09*/ v_alignbit_b32  v6, v9, v6, 31
/*3a10554f         */ v_xor_b32       v8, v79, v42
/*3a125353         */ v_xor_b32       v9, v83, v41
/*3a10110b         */ v_xor_b32       v8, v11, v8
/*3a12130c         */ v_xor_b32       v9, v12, v9
/*3a10111b         */ v_xor_b32       v8, v27, v8
/*3a121351         */ v_xor_b32       v9, v81, v9
/*3a001114         */ v_xor_b32       v0, v20, v8
/*3a041344         */ v_xor_b32       v2, v68, v9
/*3a000104         */ v_xor_b32       v0, v4, v0
/*3a040506         */ v_xor_b32       v2, v6, v2
/*3a000132         */ v_xor_b32       v0, v50, v0
/*3a040520         */ v_xor_b32       v2, v32, v2
/*3a080111         */ v_xor_b32       v4, v17, v0
/*3a0a0505         */ v_xor_b32       v5, v5, v2
/*d2940000 04120107*/ v_bfi_b32       v0, v7, v0, v4
/*d2940002 04160503*/ v_bfi_b32       v2, v3, v2, v5
/*3a0000ff 80008008*/ v_xor_b32       v0, 0x80008008, v0
/*3a0404ff 80000000*/ v_xor_b32       v2, 0x80000000, v2
/*2c060498         */ v_lshrrev_b32   v3, 24, v2
/*b00000ff         */ s_movk_i32      s0, 0xff
/*d2940003 02020600*/ v_bfi_b32       v3, s0, v3, 0
/*d2900004 02212102*/ v_bfe_u32       v4, v2, 16, 8
/*34080888         */ v_lshlrev_b32   v4, 8, v4
/*be8003ff 0000ff00*/ s_mov_b32       s0, 0xff00
/*d2940003 040e0800*/ v_bfi_b32       v3, s0, v4, v3
/*d2900004 02211102*/ v_bfe_u32       v4, v2, 8, 8
/*34080890         */ v_lshlrev_b32   v4, 16, v4
/*be8003ff 00ff0000*/ s_mov_b32       s0, 0xff0000
/*d2940003 040e0800*/ v_bfi_b32       v3, s0, v4, v3
/*d2900002 02210102*/ v_bfe_u32       v2, v2, 0, 8
/*34040498         */ v_lshlrev_b32   v2, 24, v2
/*be8003ff ff000000*/ s_mov_b32       s0, 0xff000000
/*d2940002 040e0400*/ v_bfi_b32       v2, s0, v2, v3
/*2c060098         */ v_lshrrev_b32   v3, 24, v0
/*b00000ff         */ s_movk_i32      s0, 0xff
/*d2940003 02020600*/ v_bfi_b32       v3, s0, v3, 0
/*d2900004 02212100*/ v_bfe_u32       v4, v0, 16, 8
/*34080888         */ v_lshlrev_b32   v4, 8, v4
/*be8003ff 0000ff00*/ s_mov_b32       s0, 0xff00
/*d2940003 040e0800*/ v_bfi_b32       v3, s0, v4, v3
/*d2900004 02211100*/ v_bfe_u32       v4, v0, 8, 8
/*34080890         */ v_lshlrev_b32   v4, 16, v4
/*be8003ff 00ff0000*/ s_mov_b32       s0, 0xff0000
/*d2940003 040e0800*/ v_bfi_b32       v3, s0, v4, v3
/*34000098         */ v_lshlrev_b32   v0, 24, v0
/*be8003ff ff000000*/ s_mov_b32       s0, 0xff000000
/*d2940003 040e0000*/ v_bfi_b32       v3, s0, v0, v3
/*7dc80410         */ v_cmp_gt_u64    vcc, s[16:17], v[2:3]
/*be80246a         */ s_and_saveexec_b64 s[0:1], vcc
/*bf880017         */ s_cbranch_execz .L26676_0
/*c0840360         */ s_load_dwordx4  s[8:11], s[2:3], 0x60
/*7e0002c1         */ v_mov_b32       v0, -1
/*8002ff06 000003fc*/ s_add_u32       s2, s6, 0x3fc
/*82038007         */ s_addc_u32      s3, s7, 0
/*7e040202         */ v_mov_b32       v2, s2
/*7e060203         */ v_mov_b32       v3, s3
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*e0f0c000 80020002*/ buffer_atomic_inc v0, v[2:3], s[8:11], 0 glc addr64
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*260400ff 000000fe*/ v_min_u32       v2, 0xfe, v0
/*7e060280         */ v_mov_b32       v3, 0
/*d2c20002 00010502*/ v_lshl_b64      v[2:3], v[2:3], 2
/*4a080406         */ v_add_i32       v4, vcc, s6, v2
/*7e040207         */ v_mov_b32       v2, s7
/*500a0702         */ v_addc_u32      v5, vcc, v2, v3, vcc
/*bf8c0f0f         */ s_waitcnt       expcnt(0)
/*eba48000 80020104*/ tbuffer_store_format_x v1, v[4:5], s[8:11], 0 addr64 format:[32,float] slc glc
/*bf8c0f00         */ s_waitcnt       vmcnt(0) & expcnt(0)
.L26676_0:
/*bf810000         */ s_endpgm
.kernel GenerateDAG
    .config
        .dims x
        .sgprsnum 35
        .vgprsnum 100
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00000098
        .useconstdata
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg start, "uint", uint
        .arg _Cache, "uint16*", uint16*, global, const, 12
        .arg _DAG, "uint16*", uint16*, global, , 13
        .arg LIGHT_SIZE, "uint", uint
        .arg isolate, "uint", uint
    .text
/*c2400520         */ s_buffer_load_dwordx2 s[0:1], s[4:7], 0x20
/*c2070504         */ s_buffer_load_dword s14, s[4:7], 0x4
/*c2020518         */ s_buffer_load_dword s4, s[4:7], 0x18
/*c2430904         */ s_buffer_load_dwordx2 s[6:7], s[8:11], 0x4
/*c24a0908         */ s_buffer_load_dwordx2 s[20:21], s[8:11], 0x8
/*c2028900         */ s_buffer_load_dword s5, s[8:11], 0x0
/*c207890c         */ s_buffer_load_dword s15, s[8:11], 0xc
/*c2040910         */ s_buffer_load_dword s8, s[8:11], 0x10
/*c08c0360         */ s_load_dwordx4  s[24:27], s[2:3], 0x60
/*c08e0350         */ s_load_dwordx4  s[28:31], s[2:3], 0x50
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*8389ff0e 0000ffff*/ s_min_u32       s9, s14, 0xffff
/*9309090c         */ s_mul_i32       s9, s12, s9
/*80040409         */ s_add_u32       s4, s9, s4
/*80040504         */ s_add_u32       s4, s4, s5
/*4a000004         */ v_add_i32       v0, vcc, s4, v0
/*7e020c0f         */ v_cvt_f32_u32   v1, s15
/*7e025501         */ v_rcp_f32       v1, v1
/*100202ff 4f800000*/ v_mul_f32       v1, 0x4f800000 /* 4.2949673e+9f */, v1
/*7e020f01         */ v_cvt_u32_f32   v1, v1
/*d2d20002 0002020f*/ v_mul_lo_u32    v2, s15, v1
/*d2d40003 0002020f*/ v_mul_hi_u32    v3, s15, v1
/*4c080480         */ v_sub_i32       v4, vcc, 0, v2
/*d10a0004 00020680*/ v_cmp_lg_i32    s[4:5], 0, v3
/*d2000005 00120504*/ v_cndmask_b32   v5, v4, v2, s[4:5]
/*d2d40005 00020305*/ v_mul_hi_u32    v5, v5, v1
/*4c0c0b01         */ v_sub_i32       v6, vcc, v1, v5
/*4a0a0b01         */ v_add_i32       v5, vcc, v1, v5
/*d2000005 00120d05*/ v_cndmask_b32   v5, v5, v6, s[4:5]
/*d2d40005 00020105*/ v_mul_hi_u32    v5, v5, v0
/*d2d20006 00001f05*/ v_mul_lo_u32    v6, v5, s15
/*4c0e0d00         */ v_sub_i32       v7, vcc, v0, v6
/*d18c0004 00020d00*/ v_cmp_ge_u32    s[4:5], v0, v6
/*4a0c0a81         */ v_add_i32       v6, vcc, 1, v5
/*4a100ac1         */ v_add_i32       v8, vcc, -1, v5
/*7d860e0f         */ v_cmp_le_u32    vcc, s15, v7
/*87ea6a04         */ s_and_b64       vcc, s[4:5], vcc
/*000a0d05         */ v_cndmask_b32   v5, v5, v6, vcc
/*d2000005 00120b08*/ v_cndmask_b32   v5, v8, v5, s[4:5]
/*d10a006a 00001e80*/ v_cmp_lg_i32    vcc, 0, s15
/*000a0ac1         */ v_cndmask_b32   v5, -1, v5, vcc
/*d2d60005 00001f05*/ v_mul_lo_i32    v5, v5, s15
/*4c0a0b00         */ v_sub_i32       v5, vcc, v0, v5
/*7e0c0280         */ v_mov_b32       v6, 0
/*d2c20005 00010d05*/ v_lshl_b64      v[5:6], v[5:6], 6
/*4a0a0a06         */ v_add_i32       v5, vcc, s6, v5
/*7e0e0207         */ v_mov_b32       v7, s7
/*500c0d07         */ v_addc_u32      v6, vcc, v7, v6, vcc
/*ebf38000 80061f05*/ tbuffer_load_format_xyzw v[31:34], v[5:6], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061b05*/ tbuffer_load_format_xyzw v[27:30], v[5:6], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80064d05*/ tbuffer_load_format_xyzw v[77:80], v[5:6], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80061305*/ tbuffer_load_format_xyzw v[19:22], v[5:6], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a3e3f00         */ v_xor_b32       v31, v0, v31
/*b0040000         */ s_movk_i32      s4, 0x0
/*7e900280         */ v_mov_b32       v72, 0
/*7e920280         */ v_mov_b32       v73, 0
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*7e0e0313         */ v_mov_b32       v7, v19
/*7e100314         */ v_mov_b32       v8, v20
/*7e940280         */ v_mov_b32       v74, 0
/*7e960280         */ v_mov_b32       v75, 0
/*7e160280         */ v_mov_b32       v11, 0
/*7e180280         */ v_mov_b32       v12, 0
/*7e980280         */ v_mov_b32       v76, 0
/*7e1c0280         */ v_mov_b32       v14, 0
/*7e1e0280         */ v_mov_b32       v15, 0
/*7e200280         */ v_mov_b32       v16, 0
/*7e22031d         */ v_mov_b32       v17, v29
/*7e24031e         */ v_mov_b32       v18, v30
/*7e280350         */ v_mov_b32       v20, v80
/*7e8e0281         */ v_mov_b32       v71, 1
/*7ea0034e         */ v_mov_b32       v80, v78
/*7ea40321         */ v_mov_b32       v82, v33
/*7ea60322         */ v_mov_b32       v83, v34
/*7e420280         */ v_mov_b32       v33, 0
/*7e440280         */ v_mov_b32       v34, 0
/*7e3c0280         */ v_mov_b32       v30, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*7e4a0280         */ v_mov_b32       v37, 0
/*7e4c0280         */ v_mov_b32       v38, 0
/*7e4e0280         */ v_mov_b32       v39, 0
/*7e500280         */ v_mov_b32       v40, 0
/*7e520280         */ v_mov_b32       v41, 0
/*7e880280         */ v_mov_b32       v68, 0
/*7e560280         */ v_mov_b32       v43, 0
/*7e580280         */ v_mov_b32       v44, 0
/*7e5a0280         */ v_mov_b32       v45, 0
/*7e5c0280         */ v_mov_b32       v46, 0
/*7e5e0280         */ v_mov_b32       v47, 0
/*7e600280         */ v_mov_b32       v48, 0
/*7e620280         */ v_mov_b32       v49, 0
/*7e640280         */ v_mov_b32       v50, 0
/*7e660280         */ v_mov_b32       v51, 0
/*7e680280         */ v_mov_b32       v52, 0
/*7e6a0280         */ v_mov_b32       v53, 0
/*7e6c0280         */ v_mov_b32       v54, 0
/*7e9c02ff 80000000*/ v_mov_b32       v78, 0x80000000
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
.L480_1:
/*bf029604         */ s_cmp_gt_i32    s4, 22
/*bf850199         */ s_cbranch_scc1  .L2124_1
/*bf008008         */ s_cmp_eq_i32    s8, 0
/*bf85fffc         */ s_cbranch_scc1  .L480_1
/*3a6e3f4f         */ v_xor_b32       v55, v79, v31
/*3a704114         */ v_xor_b32       v56, v20, v32
/*3a6e6f0f         */ v_xor_b32       v55, v15, v55
/*3a707110         */ v_xor_b32       v56, v16, v56
/*3a6e6f35         */ v_xor_b32       v55, v53, v55
/*3a707136         */ v_xor_b32       v56, v54, v56
/*3a6e6f33         */ v_xor_b32       v55, v51, v55
/*3a707134         */ v_xor_b32       v56, v52, v56
/*d29c0039 027e7137*/ v_alignbit_b32  v57, v55, v56, 31
/*d29c003a 027e6f38*/ v_alignbit_b32  v58, v56, v55, 31
/*3a768f11         */ v_xor_b32       v59, v17, v71
/*3a789d12         */ v_xor_b32       v60, v18, v78
/*3a76772b         */ v_xor_b32       v59, v43, v59
/*3a78792c         */ v_xor_b32       v60, v44, v60
/*3a767729         */ v_xor_b32       v59, v41, v59
/*3a787944         */ v_xor_b32       v60, v68, v60
/*3a767727         */ v_xor_b32       v59, v39, v59
/*3a787928         */ v_xor_b32       v60, v40, v60
/*3a727739         */ v_xor_b32       v57, v57, v59
/*3a74793a         */ v_xor_b32       v58, v58, v60
/*3a7a734a         */ v_xor_b32       v61, v74, v57
/*3a7c754b         */ v_xor_b32       v62, v75, v58
/*d29c003f 024a7d3d*/ v_alignbit_b32  v63, v61, v62, 18
/*d29c003d 024a7b3e*/ v_alignbit_b32  v61, v62, v61, 18
/*3a7c4b4d         */ v_xor_b32       v62, v77, v37
/*3a804d50         */ v_xor_b32       v64, v80, v38
/*3a7c7d1e         */ v_xor_b32       v62, v30, v62
/*3a808151         */ v_xor_b32       v64, v81, v64
/*3a7c7d21         */ v_xor_b32       v62, v33, v62
/*3a808122         */ v_xor_b32       v64, v34, v64
/*3a127d4a         */ v_xor_b32       v9, v74, v62
/*3a14814b         */ v_xor_b32       v10, v75, v64
/*d29c003e 027e1509*/ v_alignbit_b32  v62, v9, v10, 31
/*d29c0040 027e130a*/ v_alignbit_b32  v64, v10, v9, 31
/*3a823715         */ v_xor_b32       v65, v21, v27
/*3a843916         */ v_xor_b32       v66, v22, v28
/*3a82830b         */ v_xor_b32       v65, v11, v65
/*3a84850c         */ v_xor_b32       v66, v12, v66
/*3a828348         */ v_xor_b32       v65, v72, v65
/*3a848549         */ v_xor_b32       v66, v73, v66
/*3a828331         */ v_xor_b32       v65, v49, v65
/*3a848532         */ v_xor_b32       v66, v50, v66
/*3a7c833e         */ v_xor_b32       v62, v62, v65
/*3a808540         */ v_xor_b32       v64, v64, v66
/*3a527d29         */ v_xor_b32       v41, v41, v62
/*3a548144         */ v_xor_b32       v42, v68, v64
/*d29c0043 022e5529*/ v_alignbit_b32  v67, v41, v42, 11
/*d29c0029 022e532a*/ v_alignbit_b32  v41, v42, v41, 11
/*3a54a507         */ v_xor_b32       v42, v7, v82
/*3a88a708         */ v_xor_b32       v68, v8, v83
/*3a54552f         */ v_xor_b32       v42, v47, v42
/*3a888930         */ v_xor_b32       v68, v48, v68
/*3a54552d         */ v_xor_b32       v42, v45, v42
/*3a88892e         */ v_xor_b32       v68, v46, v68
/*3a54554c         */ v_xor_b32       v42, v76, v42
/*3a88890e         */ v_xor_b32       v68, v14, v68
/*d29c0045 027e892a*/ v_alignbit_b32  v69, v42, v68, 31
/*d29c0046 027e5544*/ v_alignbit_b32  v70, v68, v42, 31
/*3a128b09         */ v_xor_b32       v9, v9, v69
/*3a148d0a         */ v_xor_b32       v10, v10, v70
/*3a3e131f         */ v_xor_b32       v31, v31, v9
/*3a401520         */ v_xor_b32       v32, v32, v10
/*3a8a3f43         */ v_xor_b32       v69, v67, v31
/*3a8c4129         */ v_xor_b32       v70, v41, v32
/*d2940045 0516873f*/ v_bfi_b32       v69, v63, v67, v69
/*d2940046 051a533d*/ v_bfi_b32       v70, v61, v41, v70
/*3a2e7d47         */ v_xor_b32       v23, v71, v62
/*3a30814e         */ v_xor_b32       v24, v78, v64
/*d29c0047 02262f18*/ v_alignbit_b32  v71, v24, v23, 9
/*d29c0017 02263117*/ v_alignbit_b32  v23, v23, v24, 9
/*d29c0018 027e8541*/ v_alignbit_b32  v24, v65, v66, 31
/*d29c0041 027e8342*/ v_alignbit_b32  v65, v66, v65, 31
/*3a303137         */ v_xor_b32       v24, v55, v24
/*3a6e8338         */ v_xor_b32       v55, v56, v65
/*3a1a314c         */ v_xor_b32       v13, v76, v24
/*3a1c6f0e         */ v_xor_b32       v14, v14, v55
/*d29c0038 027a1d0d*/ v_alignbit_b32  v56, v13, v14, 30
/*d29c000d 027a1b0e*/ v_alignbit_b32  v13, v14, v13, 30
/*3a1c7147         */ v_xor_b32       v14, v71, v56
/*3a821b17         */ v_xor_b32       v65, v23, v13
/*d29c0042 027e793b*/ v_alignbit_b32  v66, v59, v60, 31
/*d29c003b 027e773c*/ v_alignbit_b32  v59, v60, v59, 31
/*3a54852a         */ v_xor_b32       v42, v42, v66
/*3a767744         */ v_xor_b32       v59, v68, v59
/*3a36551b         */ v_xor_b32       v27, v27, v42
/*3a38771c         */ v_xor_b32       v28, v28, v59
/*d29c003c 020a371c*/ v_alignbit_b32  v60, v28, v27, 2
/*d29c001b 020a391b*/ v_alignbit_b32  v27, v27, v28, 2
/*d294004a 043a713c*/ v_bfi_b32       v74, v60, v56, v14
/*d294004b 05061b1b*/ v_bfi_b32       v75, v27, v13, v65
/*3a6a1335         */ v_xor_b32       v53, v53, v9
/*3a6c1536         */ v_xor_b32       v54, v54, v10
/*d29c0041 025e6b36*/ v_alignbit_b32  v65, v54, v53, 23
/*d29c0035 025e6d35*/ v_alignbit_b32  v53, v53, v54, 23
/*3a6c833c         */ v_xor_b32       v54, v60, v65
/*3a846b1b         */ v_xor_b32       v66, v27, v53
/*d2940036 04da8338*/ v_bfi_b32       v54, v56, v65, v54
/*d2940042 050a6b0d*/ v_bfi_b32       v66, v13, v53, v66
/*3a46731e         */ v_xor_b32       v35, v30, v57
/*3a487551         */ v_xor_b32       v36, v81, v58
/*d29c0044 02664724*/ v_alignbit_b32  v68, v36, v35, 25
/*d29c0023 02664923*/ v_alignbit_b32  v35, v35, v36, 25
/*3a488938         */ v_xor_b32       v36, v56, v68
/*3a1a470d         */ v_xor_b32       v13, v13, v35
/*d2940024 04928941*/ v_bfi_b32       v36, v65, v68, v36
/*d294000d 04364735*/ v_bfi_b32       v13, v53, v35, v13
/*3a708347         */ v_xor_b32       v56, v71, v65
/*3a6a6b17         */ v_xor_b32       v53, v23, v53
/*d294004c 04e28f44*/ v_bfi_b32       v76, v68, v71, v56
/*d294000e 04d62f23*/ v_bfi_b32       v14, v35, v23, v53
/*3a82893c         */ v_xor_b32       v65, v60, v68
/*3a46471b         */ v_xor_b32       v35, v27, v35
/*d294003c 05067947*/ v_bfi_b32       v60, v71, v60, v65
/*d2940017 048e3717*/ v_bfi_b32       v23, v23, v27, v35
/*3a26134f         */ v_xor_b32       v19, v79, v9
/*3a281514         */ v_xor_b32       v20, v20, v10
/*d29c001b 02722714*/ v_alignbit_b32  v27, v20, v19, 28
/*d29c0013 02722913*/ v_alignbit_b32  v19, v19, v20, 28
/*3a287d27         */ v_xor_b32       v20, v39, v62
/*3a468128         */ v_xor_b32       v35, v40, v64
/*d29c0027 02222923*/ v_alignbit_b32  v39, v35, v20, 8
/*d29c0014 02224714*/ v_alignbit_b32  v20, v20, v35, 8
/*3a464f1b         */ v_xor_b32       v35, v27, v39
/*3a502913         */ v_xor_b32       v40, v19, v20
/*3a32734d         */ v_xor_b32       v25, v77, v57
/*3a347550         */ v_xor_b32       v26, v80, v58
/*d29c0041 02163519*/ v_alignbit_b32  v65, v25, v26, 5
/*d29c0019 0216331a*/ v_alignbit_b32  v25, v26, v25, 5
/*d294001a 048e4f41*/ v_bfi_b32       v26, v65, v39, v35
/*d2940023 04a22919*/ v_bfi_b32       v35, v25, v20, v40
/*3a0a5548         */ v_xor_b32       v5, v72, v42
/*3a0c7749         */ v_xor_b32       v6, v73, v59
/*d29c0028 02460d05*/ v_alignbit_b32  v40, v5, v6, 17
/*d29c0005 02460b06*/ v_alignbit_b32  v5, v6, v5, 17
/*3a0c5141         */ v_xor_b32       v6, v65, v40
/*3a880b19         */ v_xor_b32       v68, v25, v5
/*d2940006 041a5127*/ v_bfi_b32       v6, v39, v40, v6
/*d2940044 05120b14*/ v_bfi_b32       v68, v20, v5, v68
/*3a5e312f         */ v_xor_b32       v47, v47, v24
/*3a606f30         */ v_xor_b32       v48, v48, v55
/*d29c0047 025a612f*/ v_alignbit_b32  v71, v47, v48, 22
/*d29c002f 025a5f30*/ v_alignbit_b32  v47, v48, v47, 22
/*3a4e8f27         */ v_xor_b32       v39, v39, v71
/*3a285f14         */ v_xor_b32       v20, v20, v47
/*d2940048 049e8f28*/ v_bfi_b32       v72, v40, v71, v39
/*d2940049 04525f05*/ v_bfi_b32       v73, v5, v47, v20
/*3a50511b         */ v_xor_b32       v40, v27, v40
/*3a0a0b13         */ v_xor_b32       v5, v19, v5
/*d2940028 04a23747*/ v_bfi_b32       v40, v71, v27, v40
/*d2940005 0416272f*/ v_bfi_b32       v5, v47, v19, v5
/*3a608f41         */ v_xor_b32       v48, v65, v71
/*3a5e5f19         */ v_xor_b32       v47, v25, v47
/*d2940035 04c2831b*/ v_bfi_b32       v53, v27, v65, v48
/*d2940013 04be3313*/ v_bfi_b32       v19, v19, v25, v47
/*3a2a5515         */ v_xor_b32       v21, v21, v42
/*3a2c7716         */ v_xor_b32       v22, v22, v59
/*d29c0019 026a2d15*/ v_alignbit_b32  v25, v21, v22, 26
/*d29c0015 026a2b16*/ v_alignbit_b32  v21, v22, v21, 26
/*3a2c1333         */ v_xor_b32       v22, v51, v9
/*3a5e1534         */ v_xor_b32       v47, v52, v10
/*d29c0030 023a5f16*/ v_alignbit_b32  v48, v22, v47, 14
/*d29c0016 023a2d2f*/ v_alignbit_b32  v22, v47, v22, 14
/*3a5e6119         */ v_xor_b32       v47, v25, v48
/*3a662d15         */ v_xor_b32       v51, v21, v22
/*3a3a3152         */ v_xor_b32       v29, v82, v24
/*3a3c6f53         */ v_xor_b32       v30, v83, v55
/*d29c0034 027e3d1d*/ v_alignbit_b32  v52, v29, v30, 31
/*d29c001d 027e3b1e*/ v_alignbit_b32  v29, v30, v29, 31
/*d294001e 04be6134*/ v_bfi_b32       v30, v52, v48, v47
/*d2940051 04ce2d1d*/ v_bfi_b32       v81, v29, v22, v51
/*3a427321         */ v_xor_b32       v33, v33, v57
/*3a447522         */ v_xor_b32       v34, v34, v58
/*d29c0033 02624521*/ v_alignbit_b32  v51, v33, v34, 24
/*d29c0021 02624322*/ v_alignbit_b32  v33, v34, v33, 24
/*3a446734         */ v_xor_b32       v34, v52, v51
/*3a82431d         */ v_xor_b32       v65, v29, v33
/*d2940022 048a6730*/ v_bfi_b32       v34, v48, v51, v34
/*d2940041 05064316*/ v_bfi_b32       v65, v22, v33, v65
/*3a567d2b         */ v_xor_b32       v43, v43, v62
/*3a58812c         */ v_xor_b32       v44, v44, v64
/*d29c0047 021e592b*/ v_alignbit_b32  v71, v43, v44, 7
/*d29c002b 021e572c*/ v_alignbit_b32  v43, v44, v43, 7
/*3a588f30         */ v_xor_b32       v44, v48, v71
/*3a2c5716         */ v_xor_b32       v22, v22, v43
/*d294002c 04b28f33*/ v_bfi_b32       v44, v51, v71, v44
/*d2940016 045a5721*/ v_bfi_b32       v22, v33, v43, v22
/*3a606719         */ v_xor_b32       v48, v25, v51
/*3a424315         */ v_xor_b32       v33, v21, v33
/*d294002f 04c23347*/ v_bfi_b32       v47, v71, v25, v48
/*d2940030 04862b2b*/ v_bfi_b32       v48, v43, v21, v33
/*3a668f34         */ v_xor_b32       v51, v52, v71
/*3a56571d         */ v_xor_b32       v43, v29, v43
/*d2940019 04ce6919*/ v_bfi_b32       v25, v25, v52, v51
/*d2940015 04ae3b15*/ v_bfi_b32       v21, v21, v29, v43
/*3a3a7325         */ v_xor_b32       v29, v37, v57
/*3a4a7526         */ v_xor_b32       v37, v38, v58
/*d29c0026 02324b1d*/ v_alignbit_b32  v38, v29, v37, 12
/*d29c001d 02323b25*/ v_alignbit_b32  v29, v37, v29, 12
/*3a4a5531         */ v_xor_b32       v37, v49, v42
/*3a567732         */ v_xor_b32       v43, v50, v59
/*d29c0031 020e4b2b*/ v_alignbit_b32  v49, v43, v37, 3
/*d29c0025 020e5725*/ v_alignbit_b32  v37, v37, v43, 3
/*3a566326         */ v_xor_b32       v43, v38, v49
/*3a644b1d         */ v_xor_b32       v50, v29, v37
/*3a227d11         */ v_xor_b32       v17, v17, v62
/*3a248112         */ v_xor_b32       v18, v18, v64
/*d29c0033 02122511*/ v_alignbit_b32  v51, v17, v18, 4
/*d29c0011 02122312*/ v_alignbit_b32  v17, v18, v17, 4
/*d2940012 04ae6333*/ v_bfi_b32       v18, v51, v49, v43
/*d294002b 04ca4b11*/ v_bfi_b32       v43, v17, v37, v50
/*3a5a312d         */ v_xor_b32       v45, v45, v24
/*3a5c6f2e         */ v_xor_b32       v46, v46, v55
/*d29c0032 024e5b2e*/ v_alignbit_b32  v50, v46, v45, 19
/*d29c002d 024e5d2d*/ v_alignbit_b32  v45, v45, v46, 19
/*3a5c6533         */ v_xor_b32       v46, v51, v50
/*3a685b11         */ v_xor_b32       v52, v17, v45
/*d2940047 04ba6531*/ v_bfi_b32       v71, v49, v50, v46
/*d294004e 04d25b25*/ v_bfi_b32       v78, v37, v45, v52
/*3a12130f         */ v_xor_b32       v9, v15, v9
/*3a141510         */ v_xor_b32       v10, v16, v10
/*d29c000f 02761509*/ v_alignbit_b32  v15, v9, v10, 29
/*d29c0009 0276130a*/ v_alignbit_b32  v9, v10, v9, 29
/*3a141f31         */ v_xor_b32       v10, v49, v15
/*3a201325         */ v_xor_b32       v16, v37, v9
/*d294000a 042a1f32*/ v_bfi_b32       v10, v50, v15, v10
/*d2940010 0442132d*/ v_bfi_b32       v16, v45, v9, v16
/*3a4a6526         */ v_xor_b32       v37, v38, v50
/*3a5a5b1d         */ v_xor_b32       v45, v29, v45
/*d2940025 04964d0f*/ v_bfi_b32       v37, v15, v38, v37
/*d294002d 04b63b09*/ v_bfi_b32       v45, v9, v29, v45
/*3a1e1f33         */ v_xor_b32       v15, v51, v15
/*3a121311         */ v_xor_b32       v9, v17, v9
/*d294004f 043e6726*/ v_bfi_b32       v79, v38, v51, v15
/*d2940014 0426231d*/ v_bfi_b32       v20, v29, v17, v9
/*3a0e3107         */ v_xor_b32       v7, v7, v24
/*3a106f08         */ v_xor_b32       v8, v8, v55
/*d29c0011 02520f08*/ v_alignbit_b32  v17, v8, v7, 20
/*d29c0007 02521107*/ v_alignbit_b32  v7, v7, v8, 20
/*3a10233f         */ v_xor_b32       v8, v63, v17
/*3a300f3d         */ v_xor_b32       v24, v61, v7
/*d294004d 04227f1f*/ v_bfi_b32       v77, v31, v63, v8
/*d2940050 04627b20*/ v_bfi_b32       v80, v32, v61, v24
/*3a16550b         */ v_xor_b32       v11, v11, v42
/*3a18770c         */ v_xor_b32       v12, v12, v59
/*d29c001d 0256170c*/ v_alignbit_b32  v29, v12, v11, 21
/*d29c000b 0256190b*/ v_alignbit_b32  v11, v11, v12, 21
/*3a183b3f         */ v_xor_b32       v12, v63, v29
/*3a4c173d         */ v_xor_b32       v38, v61, v11
/*d294001b 04323b43*/ v_bfi_b32       v27, v67, v29, v12
/*d294001c 049a1729*/ v_bfi_b32       v28, v41, v11, v38
/*3a542343         */ v_xor_b32       v42, v67, v17
/*3a520f29         */ v_xor_b32       v41, v41, v7
/*d2940052 04aa231d*/ v_bfi_b32       v82, v29, v17, v42
/*d2940053 04a60f0b*/ v_bfi_b32       v83, v11, v7, v41
/*3a3a3b1f         */ v_xor_b32       v29, v31, v29
/*3a161720         */ v_xor_b32       v11, v32, v11
/*d2940011 04763f11*/ v_bfi_b32       v17, v17, v31, v29
/*d2940007 042e4107*/ v_bfi_b32       v7, v7, v32, v11
/*91059f04         */ s_ashr_i32      s5, s4, 31
/*8f8a8304         */ s_lshl_b64      s[10:11], s[4:5], 3
/*800a0a00         */ s_add_u32       s10, s0, s10
/*820b0b01         */ s_addc_u32      s11, s1, s11
/*9397ff1d 00100000*/ s_bfe_u32       s23, s29, 0x100000
/*be96031c         */ s_mov_b32       s22, s28
/*800a0a16         */ s_add_u32       s10, s22, s10
/*820b0b17         */ s_addc_u32      s11, s23, s11
/*c0450b00         */ s_load_dwordx2  s[10:11], s[10:11], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*3a3e220a         */ v_xor_b32       v31, s10, v17
/*3a400e0b         */ v_xor_b32       v32, s11, v7
/*80048104         */ s_add_u32       s4, s4, 1
/*7e0e0325         */ v_mov_b32       v7, v37
/*7e10032d         */ v_mov_b32       v8, v45
/*7e16032c         */ v_mov_b32       v11, v44
/*7e180316         */ v_mov_b32       v12, v22
/*7e1e0319         */ v_mov_b32       v15, v25
/*7e220345         */ v_mov_b32       v17, v69
/*7e2c0310         */ v_mov_b32       v22, v16
/*7e42031a         */ v_mov_b32       v33, v26
/*7e4a0312         */ v_mov_b32       v37, v18
/*7e4c032b         */ v_mov_b32       v38, v43
/*7e4e0336         */ v_mov_b32       v39, v54
/*7e520306         */ v_mov_b32       v41, v6
/*7e560322         */ v_mov_b32       v43, v34
/*7e580341         */ v_mov_b32       v44, v65
/*7e5a0328         */ v_mov_b32       v45, v40
/*7e5c0305         */ v_mov_b32       v46, v5
/*7e620324         */ v_mov_b32       v49, v36
/*7e64030d         */ v_mov_b32       v50, v13
/*7e66033c         */ v_mov_b32       v51, v60
/*7e680317         */ v_mov_b32       v52, v23
/*7e6c0313         */ v_mov_b32       v54, v19
/*7e200315         */ v_mov_b32       v16, v21
/*7e240346         */ v_mov_b32       v18, v70
/*7e2a030a         */ v_mov_b32       v21, v10
/*7e440323         */ v_mov_b32       v34, v35
/*7e500342         */ v_mov_b32       v40, v66
/*bf82fe65         */ s_branch        .L480_1
.L2124_1:
/*3a2e8f11         */ v_xor_b32       v23, v17, v71
/*3a309d12         */ v_xor_b32       v24, v18, v78
/*3a2a3715         */ v_xor_b32       v21, v21, v27
/*3a2c3916         */ v_xor_b32       v22, v22, v28
/*3a2e2f2b         */ v_xor_b32       v23, v43, v23
/*3a30312c         */ v_xor_b32       v24, v44, v24
/*3a36a507         */ v_xor_b32       v27, v7, v82
/*3a38a708         */ v_xor_b32       v28, v8, v83
/*3a2a2b0b         */ v_xor_b32       v21, v11, v21
/*3a2c2d0c         */ v_xor_b32       v22, v12, v22
/*3a263f4f         */ v_xor_b32       v19, v79, v31
/*3a284114         */ v_xor_b32       v20, v20, v32
/*3a2e2f29         */ v_xor_b32       v23, v41, v23
/*3a303144         */ v_xor_b32       v24, v68, v24
/*3a36372f         */ v_xor_b32       v27, v47, v27
/*3a383930         */ v_xor_b32       v28, v48, v28
/*3a324b4d         */ v_xor_b32       v25, v77, v37
/*3a0a2b48         */ v_xor_b32       v5, v72, v21
/*3a0c2d49         */ v_xor_b32       v6, v73, v22
/*3a26270f         */ v_xor_b32       v19, v15, v19
/*3a282910         */ v_xor_b32       v20, v16, v20
/*3a2a2f27         */ v_xor_b32       v21, v39, v23
/*3a2c3128         */ v_xor_b32       v22, v40, v24
/*3a2e372d         */ v_xor_b32       v23, v45, v27
/*3a30392e         */ v_xor_b32       v24, v46, v28
/*3a344d50         */ v_xor_b32       v26, v80, v38
/*3a32331e         */ v_xor_b32       v25, v30, v25
/*3a0a0b31         */ v_xor_b32       v5, v49, v5
/*3a0c0d32         */ v_xor_b32       v6, v50, v6
/*3a262735         */ v_xor_b32       v19, v53, v19
/*3a282936         */ v_xor_b32       v20, v54, v20
/*d29c001b 027e2d15*/ v_alignbit_b32  v27, v21, v22, 31
/*d29c001c 027e2b16*/ v_alignbit_b32  v28, v22, v21, 31
/*3a1a2f4c         */ v_xor_b32       v13, v76, v23
/*3a1c310e         */ v_xor_b32       v14, v14, v24
/*3a2e3551         */ v_xor_b32       v23, v81, v26
/*3a303321         */ v_xor_b32       v24, v33, v25
/*d29c0019 027e0d05*/ v_alignbit_b32  v25, v5, v6, 31
/*d29c001a 027e0b06*/ v_alignbit_b32  v26, v6, v5, 31
/*3a262733         */ v_xor_b32       v19, v51, v19
/*3a282934         */ v_xor_b32       v20, v52, v20
/*3a36370d         */ v_xor_b32       v27, v13, v27
/*3a38390e         */ v_xor_b32       v28, v14, v28
/*d29c001d 027e1d0d*/ v_alignbit_b32  v29, v13, v14, 31
/*3a2e2f22         */ v_xor_b32       v23, v34, v23
/*3a30314a         */ v_xor_b32       v24, v74, v24
/*3a323313         */ v_xor_b32       v25, v19, v25
/*3a343514         */ v_xor_b32       v26, v20, v26
/*3a16370b         */ v_xor_b32       v11, v11, v27
/*3a18390c         */ v_xor_b32       v12, v12, v28
/*d29c000d 027e1b0e*/ v_alignbit_b32  v13, v14, v13, 31
/*3a1c2f4b         */ v_xor_b32       v14, v75, v23
/*3a2e3b18         */ v_xor_b32       v23, v24, v29
/*3a0e3307         */ v_xor_b32       v7, v7, v25
/*3a103508         */ v_xor_b32       v8, v8, v26
/*d29c001d 0256170c*/ v_alignbit_b32  v29, v12, v11, 21
/*3a1a1b0e         */ v_xor_b32       v13, v14, v13
/*3a3c2f1f         */ v_xor_b32       v30, v31, v23
/*d29c001f 027e1d18*/ v_alignbit_b32  v31, v24, v14, 31
/*d29c000e 027e310e*/ v_alignbit_b32  v14, v14, v24, 31
/*d29c0018 02520f08*/ v_alignbit_b32  v24, v8, v7, 20
/*d29c000b 0256190b*/ v_alignbit_b32  v11, v11, v12, 21
/*3a181b20         */ v_xor_b32       v12, v32, v13
/*3a403b1e         */ v_xor_b32       v32, v30, v29
/*3a0a0b1f         */ v_xor_b32       v5, v31, v5
/*3a0c0d0e         */ v_xor_b32       v6, v14, v6
/*d29c0007 02521107*/ v_alignbit_b32  v7, v7, v8, 20
/*3a10170c         */ v_xor_b32       v8, v12, v11
/*d294000e 04823d18*/ v_bfi_b32       v14, v24, v30, v32
/*3a3e0b29         */ v_xor_b32       v31, v41, v5
/*3a400d44         */ v_xor_b32       v32, v68, v6
/*d29c0021 027e2913*/ v_alignbit_b32  v33, v19, v20, 31
/*d29c0013 027e2714*/ v_alignbit_b32  v19, v20, v19, 31
/*d2940008 04221907*/ v_bfi_b32       v8, v7, v12, v8
/*3a1c1cff 80008008*/ v_xor_b32       v14, 0x80008008, v14
/*d29c0014 022e411f*/ v_alignbit_b32  v20, v31, v32, 11
/*3a2a2b21         */ v_xor_b32       v21, v33, v21
/*3a262d13         */ v_xor_b32       v19, v19, v22
/*3a1010ff 80000000*/ v_xor_b32       v8, 0x80000000, v8
/*d29c0016 022e3f20*/ v_alignbit_b32  v22, v32, v31, 11
/*3a3e3114         */ v_xor_b32       v31, v20, v24
/*3a122b4a         */ v_xor_b32       v9, v74, v21
/*3a14274b         */ v_xor_b32       v10, v75, v19
/*3a400f16         */ v_xor_b32       v32, v22, v7
/*d294001f 047e311d*/ v_bfi_b32       v31, v29, v24, v31
/*d29c0021 024a1509*/ v_alignbit_b32  v33, v9, v10, 18
/*d2940020 04820f0b*/ v_bfi_b32       v32, v11, v7, v32
/*d29c0009 024a130a*/ v_alignbit_b32  v9, v10, v9, 18
/*3a143b21         */ v_xor_b32       v10, v33, v29
/*7ea8030e         */ v_mov_b32       v84, v14
/*3a1c1709         */ v_xor_b32       v14, v9, v11
/*d294000a 042a3b14*/ v_bfi_b32       v10, v20, v29, v10
/*7eaa0308         */ v_mov_b32       v85, v8
/*d2940008 043a1716*/ v_bfi_b32       v8, v22, v11, v14
/*3a163d14         */ v_xor_b32       v11, v20, v30
/*7eac031f         */ v_mov_b32       v86, v31
/*3a1c1916         */ v_xor_b32       v14, v22, v12
/*d294000b 042e2921*/ v_bfi_b32       v11, v33, v20, v11
/*7eae0320         */ v_mov_b32       v87, v32
/*d294000e 043a2d09*/ v_bfi_b32       v14, v9, v22, v14
/*3a283121         */ v_xor_b32       v20, v33, v24
/*3a1e2f0f         */ v_xor_b32       v15, v15, v23
/*3a1a1b10         */ v_xor_b32       v13, v16, v13
/*3a0a0b11         */ v_xor_b32       v5, v17, v5
/*3a0c0d12         */ v_xor_b32       v6, v18, v6
/*7eb0030a         */ v_mov_b32       v88, v10
/*3a0e0f09         */ v_xor_b32       v7, v9, v7
/*d294000a 0452431e*/ v_bfi_b32       v10, v30, v33, v20
/*d29c0010 02761b0f*/ v_alignbit_b32  v16, v15, v13, 29
/*d29c0011 02120d05*/ v_alignbit_b32  v17, v5, v6, 4
/*3a242b25         */ v_xor_b32       v18, v37, v21
/*3a262726         */ v_xor_b32       v19, v38, v19
/*7eb20308         */ v_mov_b32       v89, v8
/*d2940007 041e130c*/ v_bfi_b32       v7, v12, v9, v7
/*d29c0008 02761f0d*/ v_alignbit_b32  v8, v13, v15, 29
/*d29c0005 02120b06*/ v_alignbit_b32  v5, v6, v5, 4
/*3a0c2111         */ v_xor_b32       v6, v17, v16
/*d29c0009 02322712*/ v_alignbit_b32  v9, v18, v19, 12
/*3a18332d         */ v_xor_b32       v12, v45, v25
/*3a1a352e         */ v_xor_b32       v13, v46, v26
/*7eb4030b         */ v_mov_b32       v90, v11
/*3a161105         */ v_xor_b32       v11, v5, v8
/*d29c000f 02322513*/ v_alignbit_b32  v15, v19, v18, 12
/*d2940006 041a2309*/ v_bfi_b32       v6, v9, v17, v6
/*d29c0011 024e190d*/ v_alignbit_b32  v17, v13, v12, 19
/*7eb6030e         */ v_mov_b32       v91, v14
/*d2940005 042e0b0f*/ v_bfi_b32       v5, v15, v5, v11
/*d29c000b 024e1b0c*/ v_alignbit_b32  v11, v12, v13, 19
/*3a182309         */ v_xor_b32       v12, v9, v17
/*3a1a3731         */ v_xor_b32       v13, v49, v27
/*3a1c3932         */ v_xor_b32       v14, v50, v28
/*7eb8030a         */ v_mov_b32       v92, v10
/*3a14170f         */ v_xor_b32       v10, v15, v11
/*d2940009 04321310*/ v_bfi_b32       v9, v16, v9, v12
/*d29c000c 020e1b0e*/ v_alignbit_b32  v12, v14, v13, 3
/*7eba0307         */ v_mov_b32       v93, v7
/*d2940007 042a1f08*/ v_bfi_b32       v7, v8, v15, v10
/*d29c000a 020e1d0d*/ v_alignbit_b32  v10, v13, v14, 3
/*3a18210c         */ v_xor_b32       v12, v12, v16
/*7ebc0306         */ v_mov_b32       v94, v6
/*3a0c110a         */ v_xor_b32       v6, v10, v8
/*d294000a 04322111*/ v_bfi_b32       v10, v17, v16, v12
/*7ebe0305         */ v_mov_b32       v95, v5
/*d2940005 041a110b*/ v_bfi_b32       v5, v11, v8, v6
/*7ec00309         */ v_mov_b32       v96, v9
/*7ec20307         */ v_mov_b32       v97, v7
/*7ec4030a         */ v_mov_b32       v98, v10
/*7ec60305         */ v_mov_b32       v99, v5
/*7e0a0354         */ v_mov_b32       v5, v84
/*7e0c0355         */ v_mov_b32       v6, v85
/*7e0e031f         */ v_mov_b32       v7, v31
/*7e100320         */ v_mov_b32       v8, v32
/*7e120358         */ v_mov_b32       v9, v88
/*7e140359         */ v_mov_b32       v10, v89
/*7e16035a         */ v_mov_b32       v11, v90
/*7e18035b         */ v_mov_b32       v12, v91
/*7e1a035c         */ v_mov_b32       v13, v92
/*7e1c035d         */ v_mov_b32       v14, v93
/*7e1e035e         */ v_mov_b32       v15, v94
/*7e20035f         */ v_mov_b32       v16, v95
/*7e220360         */ v_mov_b32       v17, v96
/*7e240361         */ v_mov_b32       v18, v97
/*7e260362         */ v_mov_b32       v19, v98
/*7e280363         */ v_mov_b32       v20, v99
/*b0040001         */ s_movk_i32      s4, 0x1
/*b0050080         */ s_movk_i32      s5, 0x80
/*bf800000         */ s_nop           0x0
.L2976_1:
/*bf088005         */ s_cmp_gt_u32    s5, 0
/*bf840713         */ s_cbranch_scc0  .L10228_1
/*800904c1         */ s_add_u32       s9, -1, s4
/*870a8e09         */ s_and_b32       s10, s9, 14
/*8f0a820a         */ s_lshl_b32      s10, s10, 2
/*9020820a         */ s_lshr_b32      s32, s10, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e2a8754         */ v_movrels_b32   v21, v84
/*d10a000a 00020680*/ v_cmp_lg_i32    s[10:11], 0, v3
/*d2000016 002a0504*/ v_cndmask_b32   v22, v4, v2, s[10:11]
/*3a2e0009         */ v_xor_b32       v23, s9, v0
/*be8903ff 01000193*/ s_mov_b32       s9, 0x1000193
/*d2d40016 00020316*/ v_mul_hi_u32    v22, v22, v1
/*d2d60017 00001317*/ v_mul_lo_i32    v23, v23, s9
/*4c302d01         */ v_sub_i32       v24, vcc, v1, v22
/*4a2c2d01         */ v_add_i32       v22, vcc, v1, v22
/*3a2a2b17         */ v_xor_b32       v21, v23, v21
/*d2000016 002a3116*/ v_cndmask_b32   v22, v22, v24, s[10:11]
/*d2d40017 00022b16*/ v_mul_hi_u32    v23, v22, v21
/*d2d20018 00001f17*/ v_mul_lo_u32    v24, v23, s15
/*4c323115         */ v_sub_i32       v25, vcc, v21, v24
/*d18c000a 00023115*/ v_cmp_ge_u32    s[10:11], v21, v24
/*d18c0016 00001f19*/ v_cmp_ge_u32    s[22:23], v25, s15
/*4a302e81         */ v_add_i32       v24, vcc, 1, v23
/*8796160a         */ s_and_b64       s[22:23], s[10:11], s[22:23]
/*4a322ec1         */ v_add_i32       v25, vcc, -1, v23
/*d2000017 005a3117*/ v_cndmask_b32   v23, v23, v24, s[22:23]
/*d2000017 002a2f19*/ v_cndmask_b32   v23, v25, v23, s[10:11]
/*d10a000a 00001e80*/ v_cmp_lg_i32    s[10:11], 0, s15
/*d2000017 002a2ec1*/ v_cndmask_b32   v23, -1, v23, s[10:11]
/*d2d60017 00001f17*/ v_mul_lo_i32    v23, v23, s15
/*4c2e2f15         */ v_sub_i32       v23, vcc, v21, v23
/*7e300280         */ v_mov_b32       v24, 0
/*d2c20017 00010d17*/ v_lshl_b64      v[23:24], v[23:24], 6
/*4a4c2e06         */ v_add_i32       v38, vcc, s6, v23
/*7e2e0207         */ v_mov_b32       v23, s7
/*504e3117         */ v_addc_u32      v39, vcc, v23, v24, vcc
/*ebf38000 80061a26*/ tbuffer_load_format_xyzw v[26:29], v[38:39], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e26*/ tbuffer_load_format_xyzw v[30:33], v[38:39], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062226*/ tbuffer_load_format_xyzw v[34:37], v[38:39], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062626*/ tbuffer_load_format_xyzw v[38:41], v[38:39], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*7e2a02ff 01000193*/ v_mov_b32       v21, 0x1000193
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*87098f04         */ s_and_b32       s9, s4, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f098209         */ s_lshl_b32      s9, s9, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*90208209         */ s_lshr_b32      s32, s9, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320004         */ v_xor_b32       v25, s4, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098104         */ s_add_u32       s9, s4, 1
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098204         */ s_add_u32       s9, s4, 2
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098304         */ s_add_u32       s9, s4, 3
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098404         */ s_add_u32       s9, s4, 4
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098504         */ s_add_u32       s9, s4, 5
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098604         */ s_add_u32       s9, s4, 6
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098704         */ s_add_u32       s9, s4, 7
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098804         */ s_add_u32       s9, s4, 8
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098904         */ s_add_u32       s9, s4, 9
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098a04         */ s_add_u32       s9, s4, 10
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098b04         */ s_add_u32       s9, s4, 11
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098c04         */ s_add_u32       s9, s4, 12
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3505         */ v_xor_b32       v5, v5, v26
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3706         */ v_xor_b32       v6, v6, v27
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3907         */ v_xor_b32       v7, v7, v28
/*3a103b08         */ v_xor_b32       v8, v8, v29
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123d09         */ v_xor_b32       v9, v9, v30
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143f0a         */ v_xor_b32       v10, v10, v31
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a16410b         */ v_xor_b32       v11, v11, v32
/*7eae0308         */ v_mov_b32       v87, v8
/*3a18430c         */ v_xor_b32       v12, v12, v33
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a450d         */ v_xor_b32       v13, v13, v34
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c470e         */ v_xor_b32       v14, v14, v35
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e490f         */ v_xor_b32       v15, v15, v36
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204b10         */ v_xor_b32       v16, v16, v37
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244f12         */ v_xor_b32       v18, v18, v39
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a265113         */ v_xor_b32       v19, v19, v40
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a285314         */ v_xor_b32       v20, v20, v41
/*80098d04         */ s_add_u32       s9, s4, 13
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8e09         */ s_and_b32       s12, s9, 14
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2d2001a 00001f19*/ v_mul_lo_u32    v26, v25, s15
/*4c363518         */ v_sub_i32       v27, vcc, v24, v26
/*d18c0016 00023518*/ v_cmp_ge_u32    s[22:23], v24, v26
/*d18c001e 00001f1b*/ v_cmp_ge_u32    s[30:31], v27, s15
/*4a343281         */ v_add_i32       v26, vcc, 1, v25
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a3632c1         */ v_add_i32       v27, vcc, -1, v25
/*d2000019 007a3519*/ v_cndmask_b32   v25, v25, v26, s[30:31]
/*d2000019 005a331b*/ v_cndmask_b32   v25, v27, v25, s[22:23]
/*d2000019 002a32c1*/ v_cndmask_b32   v25, -1, v25, s[10:11]
/*d2d60019 00001f19*/ v_mul_lo_i32    v25, v25, s15
/*4c303318         */ v_sub_i32       v24, vcc, v24, v25
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a303006         */ v_add_i32       v24, vcc, s6, v24
/*50323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*ebf38000 80061a18*/ tbuffer_load_format_xyzw v[26:29], v[24:25], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061e18*/ tbuffer_load_format_xyzw v[30:33], v[24:25], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062218*/ tbuffer_load_format_xyzw v[34:37], v[24:25], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062618*/ tbuffer_load_format_xyzw v[38:41], v[24:25], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a0b1a         */ v_xor_b32       v5, v26, v5
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e0f1c         */ v_xor_b32       v7, v28, v7
/*3a10111d         */ v_xor_b32       v8, v29, v8
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a12131e         */ v_xor_b32       v9, v30, v9
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a14151f         */ v_xor_b32       v10, v31, v10
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a161720         */ v_xor_b32       v11, v32, v11
/*7eae0308         */ v_mov_b32       v87, v8
/*3a181921         */ v_xor_b32       v12, v33, v12
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a1b22         */ v_xor_b32       v13, v34, v13
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c1d23         */ v_xor_b32       v14, v35, v14
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e1f24         */ v_xor_b32       v15, v36, v15
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a202125         */ v_xor_b32       v16, v37, v16
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a222326         */ v_xor_b32       v17, v38, v17
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a242527         */ v_xor_b32       v18, v39, v18
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a262728         */ v_xor_b32       v19, v40, v19
/*80098e04         */ s_add_u32       s9, s4, 14
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a282929         */ v_xor_b32       v20, v41, v20
/*7ec00311         */ v_mov_b32       v96, v17
/*870c8f09         */ s_and_b32       s12, s9, 15
/*7ec20312         */ v_mov_b32       v97, v18
/*8f0c820c         */ s_lshl_b32      s12, s12, 2
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*9020820c         */ s_lshr_b32      s32, s12, 2
/*befc0320         */ s_mov_b32       m0, s32
/*7e308754         */ v_movrels_b32   v24, v84
/*3a320009         */ v_xor_b32       v25, s9, v0
/*d2d60019 00022b19*/ v_mul_lo_i32    v25, v25, v21
/*3a303119         */ v_xor_b32       v24, v25, v24
/*d2d40016 00023116*/ v_mul_hi_u32    v22, v22, v24
/*d2d20019 00001f16*/ v_mul_lo_u32    v25, v22, s15
/*4c343318         */ v_sub_i32       v26, vcc, v24, v25
/*d18c0016 00023318*/ v_cmp_ge_u32    s[22:23], v24, v25
/*d18c001e 00001f1a*/ v_cmp_ge_u32    s[30:31], v26, s15
/*4a322c81         */ v_add_i32       v25, vcc, 1, v22
/*879e1e16         */ s_and_b64       s[30:31], s[22:23], s[30:31]
/*4a342cc1         */ v_add_i32       v26, vcc, -1, v22
/*d2000016 007a3316*/ v_cndmask_b32   v22, v22, v25, s[30:31]
/*d2000016 005a2d1a*/ v_cndmask_b32   v22, v26, v22, s[22:23]
/*d2000016 002a2cc1*/ v_cndmask_b32   v22, -1, v22, s[10:11]
/*d2d60016 00001f16*/ v_mul_lo_i32    v22, v22, s15
/*4c302d18         */ v_sub_i32       v24, vcc, v24, v22
/*7e320280         */ v_mov_b32       v25, 0
/*d2c20018 00010d18*/ v_lshl_b64      v[24:25], v[24:25], 6
/*4a2c3006         */ v_add_i32       v22, vcc, s6, v24
/*502e3317         */ v_addc_u32      v23, vcc, v23, v25, vcc
/*ebf38000 80061816*/ tbuffer_load_format_xyzw v[24:27], v[22:23], s[24:27], 0 addr64 format:[32_32_32_32,float] slc glc
/*ebf38010 80061c16*/ tbuffer_load_format_xyzw v[28:31], v[22:23], s[24:27], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf38020 80062016*/ tbuffer_load_format_xyzw v[32:35], v[22:23], s[24:27], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf38030 80062416*/ tbuffer_load_format_xyzw v[36:39], v[22:23], s[24:27], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*d2d60005 00022b05*/ v_mul_lo_i32    v5, v5, v21
/*d2d60006 00022b06*/ v_mul_lo_i32    v6, v6, v21
/*bf8c0f73         */ s_waitcnt       vmcnt(3)
/*3a0a3105         */ v_xor_b32       v5, v5, v24
/*d2d60007 00022b07*/ v_mul_lo_i32    v7, v7, v21
/*3a0c3306         */ v_xor_b32       v6, v6, v25
/*d2d60008 00022b08*/ v_mul_lo_i32    v8, v8, v21
/*3a0e3507         */ v_xor_b32       v7, v7, v26
/*3a103708         */ v_xor_b32       v8, v8, v27
/*d2d60009 00022b09*/ v_mul_lo_i32    v9, v9, v21
/*7ea80305         */ v_mov_b32       v84, v5
/*d2d6000a 00022b0a*/ v_mul_lo_i32    v10, v10, v21
/*bf8c0f72         */ s_waitcnt       vmcnt(2)
/*3a123909         */ v_xor_b32       v9, v9, v28
/*7eaa0306         */ v_mov_b32       v85, v6
/*d2d6000b 00022b0b*/ v_mul_lo_i32    v11, v11, v21
/*3a143b0a         */ v_xor_b32       v10, v10, v29
/*7eac0307         */ v_mov_b32       v86, v7
/*d2d6000c 00022b0c*/ v_mul_lo_i32    v12, v12, v21
/*3a163d0b         */ v_xor_b32       v11, v11, v30
/*7eae0308         */ v_mov_b32       v87, v8
/*3a183f0c         */ v_xor_b32       v12, v12, v31
/*d2d6000d 00022b0d*/ v_mul_lo_i32    v13, v13, v21
/*7eb00309         */ v_mov_b32       v88, v9
/*d2d6000e 00022b0e*/ v_mul_lo_i32    v14, v14, v21
/*bf8c0f71         */ s_waitcnt       vmcnt(1)
/*3a1a410d         */ v_xor_b32       v13, v13, v32
/*7eb2030a         */ v_mov_b32       v89, v10
/*d2d6000f 00022b0f*/ v_mul_lo_i32    v15, v15, v21
/*3a1c430e         */ v_xor_b32       v14, v14, v33
/*7eb4030b         */ v_mov_b32       v90, v11
/*d2d60010 00022b10*/ v_mul_lo_i32    v16, v16, v21
/*3a1e450f         */ v_xor_b32       v15, v15, v34
/*7eb6030c         */ v_mov_b32       v91, v12
/*3a204710         */ v_xor_b32       v16, v16, v35
/*d2d60011 00022b11*/ v_mul_lo_i32    v17, v17, v21
/*7eb8030d         */ v_mov_b32       v92, v13
/*d2d60012 00022b12*/ v_mul_lo_i32    v18, v18, v21
/*bf8c0f70         */ s_waitcnt       vmcnt(0)
/*3a224911         */ v_xor_b32       v17, v17, v36
/*7eba030e         */ v_mov_b32       v93, v14
/*d2d60013 00022b13*/ v_mul_lo_i32    v19, v19, v21
/*3a244b12         */ v_xor_b32       v18, v18, v37
/*7ebc030f         */ v_mov_b32       v94, v15
/*d2d60014 00022b14*/ v_mul_lo_i32    v20, v20, v21
/*3a264d13         */ v_xor_b32       v19, v19, v38
/*7ebe0310         */ v_mov_b32       v95, v16
/*3a284f14         */ v_xor_b32       v20, v20, v39
/*7ec00311         */ v_mov_b32       v96, v17
/*7ec20312         */ v_mov_b32       v97, v18
/*7ec40313         */ v_mov_b32       v98, v19
/*7ec60314         */ v_mov_b32       v99, v20
/*80049004         */ s_add_u32       s4, s4, 16
/*81858805         */ s_sub_i32       s5, s5, 8
/*bf82f8eb         */ s_branch        .L2976_1
.L10228_1:
/*7e36035a         */ v_mov_b32       v27, v90
/*7e38035b         */ v_mov_b32       v28, v91
/*7e4e035e         */ v_mov_b32       v39, v94
/*7e50035f         */ v_mov_b32       v40, v95
/*7e880362         */ v_mov_b32       v68, v98
/*7e8a0363         */ v_mov_b32       v69, v99
/*7e8c0360         */ v_mov_b32       v70, v96
/*7e8e0361         */ v_mov_b32       v71, v97
/*7e52035c         */ v_mov_b32       v41, v92
/*7e02035d         */ v_mov_b32       v1, v93
/*7e040358         */ v_mov_b32       v2, v88
/*7e4c0359         */ v_mov_b32       v38, v89
/*7e2a0356         */ v_mov_b32       v21, v86
/*7e2c0357         */ v_mov_b32       v22, v87
/*7e620354         */ v_mov_b32       v49, v84
/*7e640355         */ v_mov_b32       v50, v85
/*7e900280         */ v_mov_b32       v72, 0
/*7e920280         */ v_mov_b32       v73, 0
/*7e060280         */ v_mov_b32       v3, 0
/*7e080280         */ v_mov_b32       v4, 0
/*7e940280         */ v_mov_b32       v74, 0
/*7e960280         */ v_mov_b32       v75, 0
/*7e980280         */ v_mov_b32       v76, 0
/*7e9a0280         */ v_mov_b32       v77, 0
/*7e1a0280         */ v_mov_b32       v13, 0
/*7e9c0280         */ v_mov_b32       v78, 0
/*7e1e0280         */ v_mov_b32       v15, 0
/*7e200280         */ v_mov_b32       v16, 0
/*7e220280         */ v_mov_b32       v17, 0
/*7e240280         */ v_mov_b32       v18, 0
/*7e9e0280         */ v_mov_b32       v79, 0
/*7ea00280         */ v_mov_b32       v80, 0
/*b0040000         */ s_movk_i32      s4, 0x0
/*7e2e0280         */ v_mov_b32       v23, 0
/*7e300280         */ v_mov_b32       v24, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*7ea40280         */ v_mov_b32       v82, 0
/*7ea60280         */ v_mov_b32       v83, 0
/*7e800280         */ v_mov_b32       v64, 0
/*7e3e0280         */ v_mov_b32       v31, 0
/*7e400280         */ v_mov_b32       v32, 0
/*7e420280         */ v_mov_b32       v33, 0
/*7e440280         */ v_mov_b32       v34, 0
/*7e460280         */ v_mov_b32       v35, 0
/*7e480280         */ v_mov_b32       v36, 0
/*7e560280         */ v_mov_b32       v43, 0
/*7e580280         */ v_mov_b32       v44, 0
/*7e5a0280         */ v_mov_b32       v45, 0
/*7e5c0280         */ v_mov_b32       v46, 0
/*7e100281         */ v_mov_b32       v8, 1
/*7e8602ff 80000000*/ v_mov_b32       v67, 0x80000000
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
/*bf800000         */ s_nop           0x0
.L10464_1:
/*bf029604         */ s_cmp_gt_i32    s4, 22
/*bf850193         */ s_cbranch_scc1  .L12084_1
/*bf008008         */ s_cmp_eq_i32    s8, 0
/*bf85fffc         */ s_cbranch_scc1  .L10464_1
/*3a666327         */ v_xor_b32       v51, v39, v49
/*3a686528         */ v_xor_b32       v52, v40, v50
/*3a66670f         */ v_xor_b32       v51, v15, v51
/*3a686910         */ v_xor_b32       v52, v16, v52
/*3a66670d         */ v_xor_b32       v51, v13, v51
/*3a68694e         */ v_xor_b32       v52, v78, v52
/*3a66672b         */ v_xor_b32       v51, v43, v51
/*3a68692c         */ v_xor_b32       v52, v44, v52
/*d29c0035 027e6933*/ v_alignbit_b32  v53, v51, v52, 31
/*d29c0036 027e6734*/ v_alignbit_b32  v54, v52, v51, 31
/*3a6e111b         */ v_xor_b32       v55, v27, v8
/*3a70871c         */ v_xor_b32       v56, v28, v67
/*3a6e6f11         */ v_xor_b32       v55, v17, v55
/*3a707112         */ v_xor_b32       v56, v18, v56
/*3a6e6f53         */ v_xor_b32       v55, v83, v55
/*3a707140         */ v_xor_b32       v56, v64, v56
/*3a6e6f2d         */ v_xor_b32       v55, v45, v55
/*3a70712e         */ v_xor_b32       v56, v46, v56
/*3a6a6f35         */ v_xor_b32       v53, v53, v55
/*3a6c7136         */ v_xor_b32       v54, v54, v56
/*3a726b4f         */ v_xor_b32       v57, v79, v53
/*3a746d50         */ v_xor_b32       v58, v80, v54
/*d29c003b 024a7539*/ v_alignbit_b32  v59, v57, v58, 18
/*d29c0039 024a733a*/ v_alignbit_b32  v57, v58, v57, 18
/*3a745348         */ v_xor_b32       v58, v72, v41
/*3a780349         */ v_xor_b32       v60, v73, v1
/*3a74754a         */ v_xor_b32       v58, v74, v58
/*3a78794b         */ v_xor_b32       v60, v75, v60
/*3a747523         */ v_xor_b32       v58, v35, v58
/*3a787924         */ v_xor_b32       v60, v36, v60
/*3a26754f         */ v_xor_b32       v19, v79, v58
/*3a287950         */ v_xor_b32       v20, v80, v60
/*d29c003a 027e2913*/ v_alignbit_b32  v58, v19, v20, 31
/*d29c003c 027e2714*/ v_alignbit_b32  v60, v20, v19, 31
/*3a7a0544         */ v_xor_b32       v61, v68, v2
/*3a7c4d45         */ v_xor_b32       v62, v69, v38
/*3a7a7b1f         */ v_xor_b32       v61, v31, v61
/*3a7c7d20         */ v_xor_b32       v62, v32, v62
/*3a7a7b51         */ v_xor_b32       v61, v81, v61
/*3a7c7d52         */ v_xor_b32       v62, v82, v62
/*3a7a7b17         */ v_xor_b32       v61, v23, v61
/*3a7c7d18         */ v_xor_b32       v62, v24, v62
/*3a747b3a         */ v_xor_b32       v58, v58, v61
/*3a787d3c         */ v_xor_b32       v60, v60, v62
/*3a3a7553         */ v_xor_b32       v29, v83, v58
/*3a3c7940         */ v_xor_b32       v30, v64, v60
/*d29c003f 022e3d1d*/ v_alignbit_b32  v63, v29, v30, 11
/*d29c001d 022e3b1e*/ v_alignbit_b32  v29, v30, v29, 11
/*3a3c2b46         */ v_xor_b32       v30, v70, v21
/*3a802d47         */ v_xor_b32       v64, v71, v22
/*3a3c3d21         */ v_xor_b32       v30, v33, v30
/*3a808122         */ v_xor_b32       v64, v34, v64
/*3a3c3d03         */ v_xor_b32       v30, v3, v30
/*3a808104         */ v_xor_b32       v64, v4, v64
/*3a3c3d4c         */ v_xor_b32       v30, v76, v30
/*3a80814d         */ v_xor_b32       v64, v77, v64
/*d29c0041 027e811e*/ v_alignbit_b32  v65, v30, v64, 31
/*d29c0042 027e3d40*/ v_alignbit_b32  v66, v64, v30, 31
/*3a268313         */ v_xor_b32       v19, v19, v65
/*3a288514         */ v_xor_b32       v20, v20, v66
/*3a622731         */ v_xor_b32       v49, v49, v19
/*3a642932         */ v_xor_b32       v50, v50, v20
/*3a82633f         */ v_xor_b32       v65, v63, v49
/*3a84651d         */ v_xor_b32       v66, v29, v50
/*d2940041 05067f3b*/ v_bfi_b32       v65, v59, v63, v65
/*d2940042 050a3b39*/ v_bfi_b32       v66, v57, v29, v66
/*3a5e7508         */ v_xor_b32       v47, v8, v58
/*3a607943         */ v_xor_b32       v48, v67, v60
/*d29c0043 02265f30*/ v_alignbit_b32  v67, v48, v47, 9
/*d29c002f 0226612f*/ v_alignbit_b32  v47, v47, v48, 9
/*d29c0030 027e7d3d*/ v_alignbit_b32  v48, v61, v62, 31
/*d29c003d 027e7b3e*/ v_alignbit_b32  v61, v62, v61, 31
/*3a606133         */ v_xor_b32       v48, v51, v48
/*3a667b34         */ v_xor_b32       v51, v52, v61
/*3a0e614c         */ v_xor_b32       v7, v76, v48
/*3a10674d         */ v_xor_b32       v8, v77, v51
/*d29c0034 027a1107*/ v_alignbit_b32  v52, v7, v8, 30
/*d29c0007 027a0f08*/ v_alignbit_b32  v7, v8, v7, 30
/*3a106943         */ v_xor_b32       v8, v67, v52
/*3a7a0f2f         */ v_xor_b32       v61, v47, v7
/*d29c003e 027e7137*/ v_alignbit_b32  v62, v55, v56, 31
/*d29c0037 027e6f38*/ v_alignbit_b32  v55, v56, v55, 31
/*3a3c7d1e         */ v_xor_b32       v30, v30, v62
/*3a6e6f40         */ v_xor_b32       v55, v64, v55
/*3a4a3d02         */ v_xor_b32       v37, v2, v30
/*3a4c6f26         */ v_xor_b32       v38, v38, v55
/*d29c0038 020a4b26*/ v_alignbit_b32  v56, v38, v37, 2
/*d29c0025 020a4d25*/ v_alignbit_b32  v37, v37, v38, 2
/*d294004f 04226938*/ v_bfi_b32       v79, v56, v52, v8
/*d2940050 04f60f25*/ v_bfi_b32       v80, v37, v7, v61
/*3a1a270d         */ v_xor_b32       v13, v13, v19
/*3a1c294e         */ v_xor_b32       v14, v78, v20
/*d29c003d 025e1b0e*/ v_alignbit_b32  v61, v14, v13, 23
/*d29c000d 025e1d0d*/ v_alignbit_b32  v13, v13, v14, 23
/*3a1c7b38         */ v_xor_b32       v14, v56, v61
/*3a7c1b25         */ v_xor_b32       v62, v37, v13
/*d294000e 043a7b34*/ v_bfi_b32       v14, v52, v61, v14
/*d294003e 04fa1b07*/ v_bfi_b32       v62, v7, v13, v62
/*3a0a6b4a         */ v_xor_b32       v5, v74, v53
/*3a0c6d4b         */ v_xor_b32       v6, v75, v54
/*d29c0040 02660b06*/ v_alignbit_b32  v64, v6, v5, 25
/*d29c0005 02660d05*/ v_alignbit_b32  v5, v5, v6, 25
/*3a0c8134         */ v_xor_b32       v6, v52, v64
/*3a0e0b07         */ v_xor_b32       v7, v7, v5
/*d2940006 041a813d*/ v_bfi_b32       v6, v61, v64, v6
/*d2940007 041e0b0d*/ v_bfi_b32       v7, v13, v5, v7
/*3a687b43         */ v_xor_b32       v52, v67, v61
/*3a1a1b2f         */ v_xor_b32       v13, v47, v13
/*d294004c 04d28740*/ v_bfi_b32       v76, v64, v67, v52
/*d294004d 04365f05*/ v_bfi_b32       v77, v5, v47, v13
/*3a7a8138         */ v_xor_b32       v61, v56, v64
/*3a0a0b25         */ v_xor_b32       v5, v37, v5
/*d2940038 04f67143*/ v_bfi_b32       v56, v67, v56, v61
/*d2940005 04164b2f*/ v_bfi_b32       v5, v47, v37, v5
/*3a4a2727         */ v_xor_b32       v37, v39, v19
/*3a4e2928         */ v_xor_b32       v39, v40, v20
/*d29c0028 02724b27*/ v_alignbit_b32  v40, v39, v37, 28
/*d29c0025 02724f25*/ v_alignbit_b32  v37, v37, v39, 28
/*3a4e752d         */ v_xor_b32       v39, v45, v58
/*3a5a792e         */ v_xor_b32       v45, v46, v60
/*d29c002e 02224f2d*/ v_alignbit_b32  v46, v45, v39, 8
/*d29c0027 02225b27*/ v_alignbit_b32  v39, v39, v45, 8
/*3a5a5d28         */ v_xor_b32       v45, v40, v46
/*3a5e4f25         */ v_xor_b32       v47, v37, v39
/*3a526b29         */ v_xor_b32       v41, v41, v53
/*3a546d01         */ v_xor_b32       v42, v1, v54
/*d29c003d 02165529*/ v_alignbit_b32  v61, v41, v42, 5
/*d29c0029 0216532a*/ v_alignbit_b32  v41, v42, v41, 5
/*d294002a 04b65d3d*/ v_bfi_b32       v42, v61, v46, v45
/*d294002d 04be4f29*/ v_bfi_b32       v45, v41, v39, v47
/*3a323d51         */ v_xor_b32       v25, v81, v30
/*3a346f52         */ v_xor_b32       v26, v82, v55
/*d29c002f 02463519*/ v_alignbit_b32  v47, v25, v26, 17
/*d29c0019 0246331a*/ v_alignbit_b32  v25, v26, v25, 17
/*3a345f3d         */ v_xor_b32       v26, v61, v47
/*3a803329         */ v_xor_b32       v64, v41, v25
/*d2940053 046a5f2e*/ v_bfi_b32       v83, v46, v47, v26
/*d2940040 05023327*/ v_bfi_b32       v64, v39, v25, v64
/*3a426121         */ v_xor_b32       v33, v33, v48
/*3a446722         */ v_xor_b32       v34, v34, v51
/*d29c0043 025a4521*/ v_alignbit_b32  v67, v33, v34, 22
/*d29c0021 025a4322*/ v_alignbit_b32  v33, v34, v33, 22
/*3a44872e         */ v_xor_b32       v34, v46, v67
/*3a4e4327         */ v_xor_b32       v39, v39, v33
/*d2940051 048a872f*/ v_bfi_b32       v81, v47, v67, v34
/*d2940052 049e4319*/ v_bfi_b32       v82, v25, v33, v39
/*3a5c5f28         */ v_xor_b32       v46, v40, v47
/*3a323325         */ v_xor_b32       v25, v37, v25
/*d294002e 04ba5143*/ v_bfi_b32       v46, v67, v40, v46
/*d2940019 04664b21*/ v_bfi_b32       v25, v33, v37, v25
/*3a5e873d         */ v_xor_b32       v47, v61, v67
/*3a424329         */ v_xor_b32       v33, v41, v33
/*d294000d 04be7b28*/ v_bfi_b32       v13, v40, v61, v47
/*d294004e 04865325*/ v_bfi_b32       v78, v37, v41, v33
/*3a123d44         */ v_xor_b32       v9, v68, v30
/*3a146f45         */ v_xor_b32       v10, v69, v55
/*d29c0025 026a1509*/ v_alignbit_b32  v37, v9, v10, 26
/*d29c0009 026a130a*/ v_alignbit_b32  v9, v10, v9, 26
/*3a14272b         */ v_xor_b32       v10, v43, v19
/*3a52292c         */ v_xor_b32       v41, v44, v20
/*d29c002b 023a530a*/ v_alignbit_b32  v43, v10, v41, 14
/*d29c000a 023a1529*/ v_alignbit_b32  v10, v41, v10, 14
/*3a525725         */ v_xor_b32       v41, v37, v43
/*3a581509         */ v_xor_b32       v44, v9, v10
/*3a2a6115         */ v_xor_b32       v21, v21, v48
/*3a2c6716         */ v_xor_b32       v22, v22, v51
/*d29c002f 027e2d15*/ v_alignbit_b32  v47, v21, v22, 31
/*d29c0015 027e2b16*/ v_alignbit_b32  v21, v22, v21, 31
/*d294004a 04a6572f*/ v_bfi_b32       v74, v47, v43, v41
/*d294004b 04b21515*/ v_bfi_b32       v75, v21, v10, v44
/*3a466b23         */ v_xor_b32       v35, v35, v53
/*3a486d24         */ v_xor_b32       v36, v36, v54
/*d29c002c 02624923*/ v_alignbit_b32  v44, v35, v36, 24
/*d29c0023 02624724*/ v_alignbit_b32  v35, v36, v35, 24
/*3a48592f         */ v_xor_b32       v36, v47, v44
/*3a7a4715         */ v_xor_b32       v61, v21, v35
/*d2940024 0492592b*/ v_bfi_b32       v36, v43, v44, v36
/*d294003d 04f6470a*/ v_bfi_b32       v61, v10, v35, v61
/*3a227511         */ v_xor_b32       v17, v17, v58
/*3a247912         */ v_xor_b32       v18, v18, v60
/*d29c0043 021e2511*/ v_alignbit_b32  v67, v17, v18, 7
/*d29c0011 021e2312*/ v_alignbit_b32  v17, v18, v17, 7
/*3a24872b         */ v_xor_b32       v18, v43, v67
/*3a14230a         */ v_xor_b32       v10, v10, v17
/*d2940012 044a872c*/ v_bfi_b32       v18, v44, v67, v18
/*d294000a 042a2323*/ v_bfi_b32       v10, v35, v17, v10
/*3a565925         */ v_xor_b32       v43, v37, v44
/*3a464709         */ v_xor_b32       v35, v9, v35
/*d2940021 04ae4b43*/ v_bfi_b32       v33, v67, v37, v43
/*d2940022 048e1311*/ v_bfi_b32       v34, v17, v9, v35
/*3a58872f         */ v_xor_b32       v44, v47, v67
/*3a222315         */ v_xor_b32       v17, v21, v17
/*d2940025 04b25f25*/ v_bfi_b32       v37, v37, v47, v44
/*d2940009 04462b09*/ v_bfi_b32       v9, v9, v21, v17
/*3a026b48         */ v_xor_b32       v1, v72, v53
/*3a046d49         */ v_xor_b32       v2, v73, v54
/*d29c0011 02320501*/ v_alignbit_b32  v17, v1, v2, 12
/*d29c0001 02320302*/ v_alignbit_b32  v1, v2, v1, 12
/*3a043d17         */ v_xor_b32       v2, v23, v30
/*3a2a6f18         */ v_xor_b32       v21, v24, v55
/*d29c0017 020e0515*/ v_alignbit_b32  v23, v21, v2, 3
/*d29c0002 020e2b02*/ v_alignbit_b32  v2, v2, v21, 3
/*3a2a2f11         */ v_xor_b32       v21, v17, v23
/*3a300501         */ v_xor_b32       v24, v1, v2
/*3a36751b         */ v_xor_b32       v27, v27, v58
/*3a38791c         */ v_xor_b32       v28, v28, v60
/*d29c002c 0212391b*/ v_alignbit_b32  v44, v27, v28, 4
/*d29c001b 0212371c*/ v_alignbit_b32  v27, v28, v27, 4
/*d2940048 04562f2c*/ v_bfi_b32       v72, v44, v23, v21
/*d2940049 0462051b*/ v_bfi_b32       v73, v27, v2, v24
/*3a066103         */ v_xor_b32       v3, v3, v48
/*3a086704         */ v_xor_b32       v4, v4, v51
/*d29c001c 024e0704*/ v_alignbit_b32  v28, v4, v3, 19
/*d29c0003 024e0903*/ v_alignbit_b32  v3, v3, v4, 19
/*3a08392c         */ v_xor_b32       v4, v44, v28
/*3a5e071b         */ v_xor_b32       v47, v27, v3
/*d2940008 04123917*/ v_bfi_b32       v8, v23, v28, v4
/*d2940043 04be0702*/ v_bfi_b32       v67, v2, v3, v47
/*3a1e270f         */ v_xor_b32       v15, v15, v19
/*3a202910         */ v_xor_b32       v16, v16, v20
/*d29c0013 0276210f*/ v_alignbit_b32  v19, v15, v16, 29
/*d29c000f 02761f10*/ v_alignbit_b32  v15, v16, v15, 29
/*3a202717         */ v_xor_b32       v16, v23, v19
/*3a041f02         */ v_xor_b32       v2, v2, v15
/*d2940044 0442271c*/ v_bfi_b32       v68, v28, v19, v16
/*d2940045 040a1f03*/ v_bfi_b32       v69, v3, v15, v2
/*3a283911         */ v_xor_b32       v20, v17, v28
/*3a060701         */ v_xor_b32       v3, v1, v3
/*d2940014 04522313*/ v_bfi_b32       v20, v19, v17, v20
/*d2940003 040e030f*/ v_bfi_b32       v3, v15, v1, v3
/*3a26272c         */ v_xor_b32       v19, v44, v19
/*3a1e1f1b         */ v_xor_b32       v15, v27, v15
/*d2940027 044e5911*/ v_bfi_b32       v39, v17, v44, v19
/*d2940028 043e3701*/ v_bfi_b32       v40, v1, v27, v15
/*3a166146         */ v_xor_b32       v11, v70, v48
/*3a186747         */ v_xor_b32       v12, v71, v51
/*d29c000f 0252170c*/ v_alignbit_b32  v15, v12, v11, 20
/*d29c000b 0252190b*/ v_alignbit_b32  v11, v11, v12, 20
/*3a181f3b         */ v_xor_b32       v12, v59, v15
/*3a261739         */ v_xor_b32       v19, v57, v11
/*d2940029 04327731*/ v_bfi_b32       v41, v49, v59, v12
/*d2940001 044e7332*/ v_bfi_b32       v1, v50, v57, v19
/*3a2e3d1f         */ v_xor_b32       v23, v31, v30
/*3a366f20         */ v_xor_b32       v27, v32, v55
/*d29c001c 02562f1b*/ v_alignbit_b32  v28, v27, v23, 21
/*d29c0017 02563717*/ v_alignbit_b32  v23, v23, v27, 21
/*3a36393b         */ v_xor_b32       v27, v59, v28
/*3a3c2f39         */ v_xor_b32       v30, v57, v23
/*d2940002 046e393f*/ v_bfi_b32       v2, v63, v28, v27
/*d2940026 047a2f1d*/ v_bfi_b32       v38, v29, v23, v30
/*3a3e1f3f         */ v_xor_b32       v31, v63, v15
/*3a3a171d         */ v_xor_b32       v29, v29, v11
/*d2940015 047e1f1c*/ v_bfi_b32       v21, v28, v15, v31
/*d2940016 04761717*/ v_bfi_b32       v22, v23, v11, v29
/*3a383931         */ v_xor_b32       v28, v49, v28
/*3a2e2f32         */ v_xor_b32       v23, v50, v23
/*d294000f 0472630f*/ v_bfi_b32       v15, v15, v49, v28
/*d294000b 045e650b*/ v_bfi_b32       v11, v11, v50, v23
/*91059f04         */ s_ashr_i32      s5, s4, 31
/*8f868304         */ s_lshl_b64      s[6:7], s[4:5], 3
/*80060600         */ s_add_u32       s6, s0, s6
/*82070701         */ s_addc_u32      s7, s1, s7
/*938bff1d 00100000*/ s_bfe_u32       s11, s29, 0x100000
/*be8a031c         */ s_mov_b32       s10, s28
/*8006060a         */ s_add_u32       s6, s10, s6
/*8207070b         */ s_addc_u32      s7, s11, s7
/*c0430700         */ s_load_dwordx2  s[6:7], s[6:7], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*3a621e06         */ v_xor_b32       v49, s6, v15
/*3a641607         */ v_xor_b32       v50, s7, v11
/*80048104         */ s_add_u32       s4, s4, 1
/*7e080319         */ v_mov_b32       v4, v25
/*7e8c0314         */ v_mov_b32       v70, v20
/*7e8e0303         */ v_mov_b32       v71, v3
/*7e1e0325         */ v_mov_b32       v15, v37
/*7e200309         */ v_mov_b32       v16, v9
/*7e220324         */ v_mov_b32       v17, v36
/*7e2e0306         */ v_mov_b32       v23, v6
/*7e300307         */ v_mov_b32       v24, v7
/*7e360341         */ v_mov_b32       v27, v65
/*7e380342         */ v_mov_b32       v28, v66
/*7e3e0312         */ v_mov_b32       v31, v18
/*7e40030a         */ v_mov_b32       v32, v10
/*7e46032a         */ v_mov_b32       v35, v42
/*7e48032d         */ v_mov_b32       v36, v45
/*7e560338         */ v_mov_b32       v43, v56
/*7e580305         */ v_mov_b32       v44, v5
/*7e5a030e         */ v_mov_b32       v45, v14
/*7e06032e         */ v_mov_b32       v3, v46
/*7e24033d         */ v_mov_b32       v18, v61
/*7e5c033e         */ v_mov_b32       v46, v62
/*bf82fe6b         */ s_branch        .L10464_1
.L12084_1:
/*3a120544         */ v_xor_b32       v9, v68, v2
/*3a144d45         */ v_xor_b32       v10, v69, v38
/*3a12131f         */ v_xor_b32       v9, v31, v9
/*3a141520         */ v_xor_b32       v10, v32, v10
/*3a121351         */ v_xor_b32       v9, v81, v9
/*3a141552         */ v_xor_b32       v10, v82, v10
/*3a121317         */ v_xor_b32       v9, v23, v9
/*3a141518         */ v_xor_b32       v10, v24, v10
/*d29c0019 027e1509*/ v_alignbit_b32  v25, v9, v10, 31
/*d29c001a 027e130a*/ v_alignbit_b32  v26, v10, v9, 31
/*3a4a6327         */ v_xor_b32       v37, v39, v49
/*3a4c6528         */ v_xor_b32       v38, v40, v50
/*3a4a4b0f         */ v_xor_b32       v37, v15, v37
/*3a4c4d10         */ v_xor_b32       v38, v16, v38
/*3a1a4b0d         */ v_xor_b32       v13, v13, v37
/*3a1c4d4e         */ v_xor_b32       v14, v78, v38
/*3a1a1b2b         */ v_xor_b32       v13, v43, v13
/*3a1c1d2c         */ v_xor_b32       v14, v44, v14
/*3a32330d         */ v_xor_b32       v25, v13, v25
/*3a34350e         */ v_xor_b32       v26, v14, v26
/*3a4a3346         */ v_xor_b32       v37, v70, v25
/*3a4c3547         */ v_xor_b32       v38, v71, v26
/*d29c0027 02524b26*/ v_alignbit_b32  v39, v38, v37, 20
/*d29c0025 02524d25*/ v_alignbit_b32  v37, v37, v38, 20
/*3a4c111b         */ v_xor_b32       v38, v27, v8
/*3a50871c         */ v_xor_b32       v40, v28, v67
/*3a224d11         */ v_xor_b32       v17, v17, v38
/*3a245112         */ v_xor_b32       v18, v18, v40
/*3a222353         */ v_xor_b32       v17, v83, v17
/*3a242540         */ v_xor_b32       v18, v64, v18
/*3a22232d         */ v_xor_b32       v17, v45, v17
/*3a24252e         */ v_xor_b32       v18, v46, v18
/*d29c0026 027e2511*/ v_alignbit_b32  v38, v17, v18, 31
/*d29c0028 027e2312*/ v_alignbit_b32  v40, v18, v17, 31
/*3a162b46         */ v_xor_b32       v11, v70, v21
/*3a182d47         */ v_xor_b32       v12, v71, v22
/*3a161721         */ v_xor_b32       v11, v33, v11
/*3a181922         */ v_xor_b32       v12, v34, v12
/*3a161703         */ v_xor_b32       v11, v3, v11
/*3a181904         */ v_xor_b32       v12, v4, v12
/*3a0e174c         */ v_xor_b32       v7, v76, v11
/*3a10194d         */ v_xor_b32       v8, v77, v12
/*3a164d07         */ v_xor_b32       v11, v7, v38
/*3a185108         */ v_xor_b32       v12, v8, v40
/*3a2a171f         */ v_xor_b32       v21, v31, v11
/*3a2c1920         */ v_xor_b32       v22, v32, v12
/*d29c001f 02562b16*/ v_alignbit_b32  v31, v22, v21, 21
/*d29c0015 02562d15*/ v_alignbit_b32  v21, v21, v22, 21
/*d29c0016 027e1107*/ v_alignbit_b32  v22, v7, v8, 31
/*d29c0007 027e0f08*/ v_alignbit_b32  v7, v8, v7, 31
/*3a105348         */ v_xor_b32       v8, v72, v41
/*3a400349         */ v_xor_b32       v32, v73, v1
/*3a0a114a         */ v_xor_b32       v5, v74, v8
/*3a0c414b         */ v_xor_b32       v6, v75, v32
/*3a0a0b23         */ v_xor_b32       v5, v35, v5
/*3a0c0d24         */ v_xor_b32       v6, v36, v6
/*3a0a0b4f         */ v_xor_b32       v5, v79, v5
/*3a0c0d50         */ v_xor_b32       v6, v80, v6
/*3a102d05         */ v_xor_b32       v8, v5, v22
/*3a0e0f06         */ v_xor_b32       v7, v6, v7
/*3a2c1131         */ v_xor_b32       v22, v49, v8
/*3a400f32         */ v_xor_b32       v32, v50, v7
/*3a423f16         */ v_xor_b32       v33, v22, v31
/*3a442b20         */ v_xor_b32       v34, v32, v21
/*d2940021 04862d27*/ v_bfi_b32       v33, v39, v22, v33
/*d2940022 048a4125*/ v_bfi_b32       v34, v37, v32, v34
/*3a5842ff 80008008*/ v_xor_b32       v44, 0x80008008, v33
/*3a5a44ff 80000000*/ v_xor_b32       v45, 0x80000000, v34
/*d29c0023 027e0d05*/ v_alignbit_b32  v35, v5, v6, 31
/*d29c0005 027e0b06*/ v_alignbit_b32  v5, v6, v5, 31
/*3a0c1323         */ v_xor_b32       v6, v35, v9
/*3a0a1505         */ v_xor_b32       v5, v5, v10
/*3a120d53         */ v_xor_b32       v9, v83, v6
/*3a140b40         */ v_xor_b32       v10, v64, v5
/*d29c001d 022e1509*/ v_alignbit_b32  v29, v9, v10, 11
/*d29c0009 022e130a*/ v_alignbit_b32  v9, v10, v9, 11
/*3a144f1d         */ v_xor_b32       v10, v29, v39
/*3a3c4b09         */ v_xor_b32       v30, v9, v37
/*d294002e 042a4f1f*/ v_bfi_b32       v46, v31, v39, v10
/*d294002f 047a4b15*/ v_bfi_b32       v47, v21, v37, v30
/*d29c0023 027e1d0d*/ v_alignbit_b32  v35, v13, v14, 31
/*d29c000d 027e1b0e*/ v_alignbit_b32  v13, v14, v13, 31
/*3a1c2323         */ v_xor_b32       v14, v35, v17
/*3a1a250d         */ v_xor_b32       v13, v13, v18
/*3a221d4f         */ v_xor_b32       v17, v79, v14
/*3a241b50         */ v_xor_b32       v18, v80, v13
/*d29c0013 024a2511*/ v_alignbit_b32  v19, v17, v18, 18
/*d29c0011 024a2312*/ v_alignbit_b32  v17, v18, v17, 18
/*3a243f13         */ v_xor_b32       v18, v19, v31
/*3a282b11         */ v_xor_b32       v20, v17, v21
/*d2940028 044a3f1d*/ v_bfi_b32       v40, v29, v31, v18
/*d2940029 04522b09*/ v_bfi_b32       v41, v9, v21, v20
/*3a2a2d1d         */ v_xor_b32       v21, v29, v22
/*3a3e4109         */ v_xor_b32       v31, v9, v32
/*d294002a 04563b13*/ v_bfi_b32       v42, v19, v29, v21
/*d294002b 047e1311*/ v_bfi_b32       v43, v17, v9, v31
/*3a3a4f13         */ v_xor_b32       v29, v19, v39
/*3a3e4b11         */ v_xor_b32       v31, v17, v37
/*d2940023 04762716*/ v_bfi_b32       v35, v22, v19, v29
/*d2940024 047e2320*/ v_bfi_b32       v36, v32, v17, v31
/*3a10110f         */ v_xor_b32       v8, v15, v8
/*3a0e0f10         */ v_xor_b32       v7, v16, v7
/*d29c000f 02760f08*/ v_alignbit_b32  v15, v8, v7, 29
/*d29c0007 02761107*/ v_alignbit_b32  v7, v7, v8, 29
/*3a0c0d1b         */ v_xor_b32       v6, v27, v6
/*3a0a0b1c         */ v_xor_b32       v5, v28, v5
/*d29c0008 02120b06*/ v_alignbit_b32  v8, v6, v5, 4
/*d29c0005 02120d05*/ v_alignbit_b32  v5, v5, v6, 4
/*3a0c1f08         */ v_xor_b32       v6, v8, v15
/*3a200f05         */ v_xor_b32       v16, v5, v7
/*3a021d48         */ v_xor_b32       v1, v72, v14
/*3a041b49         */ v_xor_b32       v2, v73, v13
/*d29c000d 02320501*/ v_alignbit_b32  v13, v1, v2, 12
/*d29c0001 02320302*/ v_alignbit_b32  v1, v2, v1, 12
/*d2940025 041a110d*/ v_bfi_b32       v37, v13, v8, v6
/*d2940026 04420b01*/ v_bfi_b32       v38, v1, v5, v16
/*3a063303         */ v_xor_b32       v3, v3, v25
/*3a083504         */ v_xor_b32       v4, v4, v26
/*d29c0006 024e0704*/ v_alignbit_b32  v6, v4, v3, 19
/*d29c0003 024e0903*/ v_alignbit_b32  v3, v3, v4, 19
/*3a080d0d         */ v_xor_b32       v4, v13, v6
/*3a100701         */ v_xor_b32       v8, v1, v3
/*d2940019 04121b0f*/ v_bfi_b32       v25, v15, v13, v4
/*d294001a 04220307*/ v_bfi_b32       v26, v7, v1, v8
/*3a101717         */ v_xor_b32       v8, v23, v11
/*3a161918         */ v_xor_b32       v11, v24, v12
/*d29c000c 020e110b*/ v_alignbit_b32  v12, v11, v8, 3
/*d29c0008 020e1708*/ v_alignbit_b32  v8, v8, v11, 3
/*3a161f0c         */ v_xor_b32       v11, v12, v15
/*3a100f08         */ v_xor_b32       v8, v8, v7
/*d294001b 042e1f06*/ v_bfi_b32       v27, v6, v15, v11
/*d294001c 04220f03*/ v_bfi_b32       v28, v3, v7, v8
/*7e020280         */ v_mov_b32       v1, 0
/*d2c20007 00010d00*/ v_lshl_b64      v[7:8], v[0:1], 6
/*4a1e0e14         */ v_add_i32       v15, vcc, s20, v7
/*7e0e0215         */ v_mov_b32       v7, s21
/*50201107         */ v_addc_u32      v16, vcc, v7, v8, vcc
/*c0800368         */ s_load_dwordx4  s[0:3], s[2:3], 0x68
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*ebf78030 8000190f*/ tbuffer_store_format_xyzw v[25:28], v[15:16], s[0:3], 0 offset:48 addr64 format:[32_32_32_32,float] slc glc
/*ebf78020 8000230f*/ tbuffer_store_format_xyzw v[35:38], v[15:16], s[0:3], 0 offset:32 addr64 format:[32_32_32_32,float] slc glc
/*ebf78010 8000280f*/ tbuffer_store_format_xyzw v[40:43], v[15:16], s[0:3], 0 offset:16 addr64 format:[32_32_32_32,float] slc glc
/*ebf78000 80002c0f*/ tbuffer_store_format_xyzw v[44:47], v[15:16], s[0:3], 0 addr64 format:[32_32_32_32,float] slc glc
/*bf810000         */ s_endpgm
