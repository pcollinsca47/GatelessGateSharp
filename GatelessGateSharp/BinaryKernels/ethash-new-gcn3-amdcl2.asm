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



/* FIXME: Needs more work for GCN2. */
.ifarch gcn1.1
	.macro v_lshlrev_b32, arg1, arg2, arg3
		v_lshl_b32 \arg1, \arg3, \arg2
	.endm
	.macro v_lshlrev_b64, arg1, arg2, arg3
		v_lshl_b64 \arg1, \arg3, \arg2
	.endm
    .macro v_add_u32, arg1, arg2, arg3, arg4
	    v_add_i32 \arg1, \arg2, \arg3, \arg4
	.endm
    .macro v_mul_lo_u32, arg1, arg2, arg3
	    v_mul_lo_i32 \arg1, \arg2, \arg3
	.endm
.endif



.amdcl2
.64bit
.driver_version 200406
.acl_version "AMD-COMP-LIB-v0.8 (0.0.SC_BUILD_NUMBER)"
.globaldata
.gdata:
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
        .localsize 3840
        .floatmode 0xc0
        .useargs
        .priority 0
        .arg _.global_offset_0, "size_t", long
        .arg _.global_offset_1, "size_t", long
        .arg _.global_offset_2, "size_t", long
        .arg _.printf_buffer, "size_t", void*, global, , rdonly
        .arg _.vqueue_pointer, "size_t", long
        .arg _.aqlwrap_pointer, "size_t", long
        .arg g_output, "uint*", uint*, global, restrict volatile
        .arg g_header, "uint2*", uint2*, constant, const, rdonly
        .arg _g_dag, "ulong8*", ulong8*, global, const, rdonly
        .arg DAG_SIZE, "uint", uint
        .arg start_nonce, "ulong", ulong
        .arg target, "ulong", ulong
        .arg isolate, "uint", uint
    .text
/*befc00ff 00010000*/ s_mov_b32       m0, 0x10000
/*920006ff 000000c0*/ s_mul_i32       s0, 0xc0, s6
/*c0060082 00000000*/ s_load_dwordx2  s[2:3], s[4:5], 0x0
/*c0060182 00000050*/ s_load_dwordx2  s[6:7], s[4:5], 0x50
/*c0060202 00000038*/ s_load_dwordx2  s[8:9], s[4:5], 0x38
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*80000200         */ s_add_u32       s0, s0, s2
/*32020000         */ v_add_u32       v1, vcc, s0, v0
/*d1196a02 00000d01*/ v_add_u32       v2, vcc, v1, s6
/*7e040207         */ v_mov_b32       v2, s7
/*38400480         */ v_addc_u32      v32, vcc, 0, v2, vcc
/*20060082         */ v_lshrrev_b32   v3, 2, v0
/*c00e0204 00000000*/ s_load_dwordx8  s[8:15], s[8:9], 0x0
/*c0020002 00000060*/ s_load_dword    s0, s[4:5], 0x60
/*24060686         */ v_lshlrev_b32   v3, 6, v3
/*324a0206         */ v_add_u32       v37, vcc, s6, v1
/*260a0083         */ v_and_b32       v5, 3, v0
/*7ec60280         */ v_mov_b32       v99, 0
/*7ec80280         */ v_mov_b32       v100, 0
/*7eb40280         */ v_mov_b32       v90, 0
/*7eba0280         */ v_mov_b32       v93, 0
/*7eb00280         */ v_mov_b32       v88, 0
/*7e120280         */ v_mov_b32       v9, 0
/*7eae0280         */ v_mov_b32       v87, 0
/*7eb20280         */ v_mov_b32       v89, 0
/*7e100280         */ v_mov_b32       v8, 0
/*7eb80280         */ v_mov_b32       v92, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*7eb60280         */ v_mov_b32       v91, 0
/*7e040280         */ v_mov_b32       v2, 0
/*7e220280         */ v_mov_b32       v17, 0
/*7e8a0280         */ v_mov_b32       v69, 0
/*7e9c0280         */ v_mov_b32       v78, 0
/*7e280280         */ v_mov_b32       v20, 0
/*7e2a0280         */ v_mov_b32       v21, 0
/*7e9a0280         */ v_mov_b32       v77, 0
/*7e9e0280         */ v_mov_b32       v79, 0
/*7e300280         */ v_mov_b32       v24, 0
/*7ea00280         */ v_mov_b32       v80, 0
/*7e080280         */ v_mov_b32       v4, 0
/*7e360280         */ v_mov_b32       v27, 0
/*7e380280         */ v_mov_b32       v28, 0
/*7e3a0280         */ v_mov_b32       v29, 0
/*7e840280         */ v_mov_b32       v66, 0
/*7e900280         */ v_mov_b32       v72, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7e42020f         */ v_mov_b32       v33, s15
/*7e44020e         */ v_mov_b32       v34, s14
/*7e46020d         */ v_mov_b32       v35, s13
/*7e48020c         */ v_mov_b32       v36, s12
/*7e4c020b         */ v_mov_b32       v38, s11
/*7e4e020a         */ v_mov_b32       v39, s10
/*7e8c0209         */ v_mov_b32       v70, s9
/*7eca0208         */ v_mov_b32       v101, s8
/*7e5402ff 80000000*/ v_mov_b32       v42, 0x80000000
/*7e560281         */ v_mov_b32       v43, 1
/*b0080000         */ s_movk_i32      s8, 0x0
/*7ecc0280         */ v_mov_b32       v102, 0
/*7ece0280         */ v_mov_b32       v103, 0
/*7e0e0280         */ v_mov_b32       v7, 0
/*7ed00280         */ v_mov_b32       v104, 0
/*7ed20280         */ v_mov_b32       v105, 0
/*7ed40280         */ v_mov_b32       v106, 0
/*7ed60280         */ v_mov_b32       v107, 0
/*7ed80280         */ v_mov_b32       v108, 0
/*7e680280         */ v_mov_b32       v52, 0
/*7eda0280         */ v_mov_b32       v109, 0
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
.L320_0:
/*bf059608         */ s_cmp_le_i32    s8, 22
/*bf840180         */ s_cbranch_scc0  .L1864_0
/*bf008000         */ s_cmp_eq_i32    s0, 0
/*bf85fffc         */ s_cbranch_scc1  .L320_0
/*2a6c5765         */ v_xor_b32       v54, v101, v43
/*2a6e8526         */ v_xor_b32       v55, v38, v66
/*2a703b27         */ v_xor_b32       v56, v39, v29
/*2a702938         */ v_xor_b32       v56, v56, v20
/*2a6e2b37         */ v_xor_b32       v55, v55, v21
/*2a6c9b36         */ v_xor_b32       v54, v54, v77
/*2a723923         */ v_xor_b32       v57, v35, v28
/*2a729d39         */ v_xor_b32       v57, v57, v78
/*2a749146         */ v_xor_b32       v58, v70, v72
/*2a749f3a         */ v_xor_b32       v58, v58, v79
/*2a721339         */ v_xor_b32       v57, v57, v9
/*2a6c1136         */ v_xor_b32       v54, v54, v8
/*2a6eb337         */ v_xor_b32       v55, v55, v89
/*2a70af38         */ v_xor_b32       v56, v56, v87
/*2a760922         */ v_xor_b32       v59, v34, v4
/*2a76053b         */ v_xor_b32       v59, v59, v2
/*2a6ed937         */ v_xor_b32       v55, v55, v108
/*2a6c6936         */ v_xor_b32       v54, v54, v52
/*2a72d539         */ v_xor_b32       v57, v57, v106
/*2a74b93a         */ v_xor_b32       v58, v58, v92
/*2a78a120         */ v_xor_b32       v60, v32, v80
/*2a78b73c         */ v_xor_b32       v60, v60, v91
/*2a78c93c         */ v_xor_b32       v60, v60, v100
/*2a76b53b         */ v_xor_b32       v59, v59, v90
/*2a78cf3c         */ v_xor_b32       v60, v60, v103
/*2a70d738         */ v_xor_b32       v56, v56, v107
/*2a74db3a         */ v_xor_b32       v58, v58, v109
/*2a7a3724         */ v_xor_b32       v61, v36, v27
/*2a7a8b3d         */ v_xor_b32       v61, v61, v69
/*2a7ab13d         */ v_xor_b32       v61, v61, v88
/*2a7ad33d         */ v_xor_b32       v61, v61, v105
/*d1ce003e 027e7b39*/ v_alignbit_b32  v62, v57, v61, 31
/*2a7c7d3a         */ v_xor_b32       v62, v58, v62
/*d1ce003f 027e733d*/ v_alignbit_b32  v63, v61, v57, 31
/*2a7e7f36         */ v_xor_b32       v63, v54, v63
/*d1ce0040 027e7137*/ v_alignbit_b32  v64, v55, v56, 31
/*2a80813c         */ v_xor_b32       v64, v60, v64
/*2a760f3b         */ v_xor_b32       v59, v59, v7
/*2a825521         */ v_xor_b32       v65, v33, v42
/*2a822341         */ v_xor_b32       v65, v65, v17
/*2a82bb41         */ v_xor_b32       v65, v65, v93
/*2a82d141         */ v_xor_b32       v65, v65, v104
/*2a508146         */ v_xor_b32       v40, v70, v64
/*2a3a3b3f         */ v_xor_b32       v29, v63, v29
/*2a3c853e         */ v_xor_b32       v30, v62, v66
/*d1ce0042 027e833b*/ v_alignbit_b32  v66, v59, v65, 31
/*2a848538         */ v_xor_b32       v66, v56, v66
/*2a248b42         */ v_xor_b32       v18, v66, v69
/*d1ce0043 027e7741*/ v_alignbit_b32  v67, v65, v59, 31
/*2a868737         */ v_xor_b32       v67, v55, v67
/*2a269d43         */ v_xor_b32       v19, v67, v78
/*d1ce0044 02562712*/ v_alignbit_b32  v68, v18, v19, 21
/*d1ce0045 02523d1d*/ v_alignbit_b32  v69, v29, v30, 20
/*268c8945         */ v_and_b32       v70, v69, v68
/*2a8e8928         */ v_xor_b32       v71, v40, v68
/*2a8c8f46         */ v_xor_b32       v70, v70, v71
/*90099f08         */ s_ashr_i32      s9, s8, 31
/*8e828308         */ s_lshl_b64      s[2:3], s[8:9], 3
/*be8700ff 55555555*/ s_mov_b32       s7, .gdata>>32
/*be8600ff 55555555*/ s_mov_b32       s6, .gdata&0xffffffff
/*80020206         */ s_add_u32       s2, s6, s2
/*82030307         */ s_addc_u32      s3, s7, s3
/*c0060081 00000000*/ s_load_dwordx2  s[2:3], s[2:3], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*2a8c8c03         */ v_xor_b32       v70, s3, v70
/*d1ce0012 02562513*/ v_alignbit_b32  v18, v19, v18, 21
/*d1ce0013 02523b1e*/ v_alignbit_b32  v19, v30, v29, 20
/*d1ce001d 027e6f38*/ v_alignbit_b32  v29, v56, v55, 31
/*2a3c3125         */ v_xor_b32       v30, v37, v24
/*2a3ca31e         */ v_xor_b32       v30, v30, v81
/*2a3cc71e         */ v_xor_b32       v30, v30, v99
/*2a3ccd1e         */ v_xor_b32       v30, v30, v102
/*2a3a3b1e         */ v_xor_b32       v29, v30, v29
/*2a523b65         */ v_xor_b32       v41, v101, v29
/*266e2513         */ v_and_b32       v55, v19, v18
/*2a702529         */ v_xor_b32       v56, v41, v18
/*2a6e7137         */ v_xor_b32       v55, v55, v56
/*2aca6e02         */ v_xor_b32       v101, s2, v55
/*d1ce0038 027e7536*/ v_alignbit_b32  v56, v54, v58, 31
/*d1ce0036 027e6d3a*/ v_alignbit_b32  v54, v58, v54, 31
/*d1ce003a 027e3d3c*/ v_alignbit_b32  v58, v60, v30, 31
/*d1ce001e 027e791e*/ v_alignbit_b32  v30, v30, v60, 31
/*2a3c3d3d         */ v_xor_b32       v30, v61, v30
/*2a6c6d41         */ v_xor_b32       v54, v65, v54
/*2a70713b         */ v_xor_b32       v56, v59, v56
/*2a727539         */ v_xor_b32       v57, v57, v58
/*2a18111d         */ v_xor_b32       v12, v29, v8
/*2a2c3b4d         */ v_xor_b32       v22, v77, v29
/*2a563b2b         */ v_xor_b32       v43, v43, v29
/*2a3a691d         */ v_xor_b32       v29, v29, v52
/*2a64d73f         */ v_xor_b32       v50, v63, v107
/*2a14af3f         */ v_xor_b32       v10, v63, v87
/*2a28293f         */ v_xor_b32       v20, v63, v20
/*2a4e7f27         */ v_xor_b32       v39, v39, v63
/*2a34091e         */ v_xor_b32       v26, v30, v4
/*2a44451e         */ v_xor_b32       v34, v30, v34
/*2a20051e         */ v_xor_b32       v16, v30, v2
/*2a5c0f1e         */ v_xor_b32       v46, v30, v7
/*2a0cb51e         */ v_xor_b32       v6, v30, v90
/*2a3c4743         */ v_xor_b32       v30, v67, v35
/*2a383943         */ v_xor_b32       v28, v67, v28
/*2a46d543         */ v_xor_b32       v35, v67, v106
/*2a121343         */ v_xor_b32       v9, v67, v9
/*2a484942         */ v_xor_b32       v36, v66, v36
/*2a363742         */ v_xor_b32       v27, v66, v27
/*2a60d342         */ v_xor_b32       v48, v66, v105
/*2a10b142         */ v_xor_b32       v8, v66, v88
/*2a62d93e         */ v_xor_b32       v49, v62, v108
/*2a4c7d26         */ v_xor_b32       v38, v38, v62
/*2a16b33e         */ v_xor_b32       v11, v62, v89
/*2a2a2b3e         */ v_xor_b32       v21, v62, v21
/*2a1ca338         */ v_xor_b32       v14, v56, v81
/*2a303138         */ v_xor_b32       v24, v56, v24
/*2a04c738         */ v_xor_b32       v2, v56, v99
/*2a58cd38         */ v_xor_b32       v44, v56, v102
/*2a4a4b38         */ v_xor_b32       v37, v56, v37
/*2a1eb736         */ v_xor_b32       v15, v54, v91
/*2a32a136         */ v_xor_b32       v25, v54, v80
/*2a08c936         */ v_xor_b32       v4, v54, v100
/*2a5acf36         */ v_xor_b32       v45, v54, v103
/*2a404136         */ v_xor_b32       v32, v54, v32
/*2a1ab940         */ v_xor_b32       v13, v64, v92
/*2a2e814f         */ v_xor_b32       v23, v79, v64
/*2a3e8148         */ v_xor_b32       v31, v72, v64
/*2a66db40         */ v_xor_b32       v51, v64, v109
/*2a545539         */ v_xor_b32       v42, v57, v42
/*2a424339         */ v_xor_b32       v33, v57, v33
/*2a222339         */ v_xor_b32       v17, v57, v17
/*2a0ebb39         */ v_xor_b32       v7, v57, v93
/*2a5ed139         */ v_xor_b32       v47, v57, v104
/*bf800000         */ /*s_nop           0x0*/
/*d1ce0034 02661d0f*/ v_alignbit_b32  v52, v15, v14, 25
/*d1ce000e 02661f0e*/ v_alignbit_b32  v14, v14, v15, 25
/*d1ce000f 0226352a*/ v_alignbit_b32  v15, v42, v26, 9
/*d1ce001a 0226551a*/ v_alignbit_b32  v26, v26, v42, 9
/*d1ce002a 025e190d*/ v_alignbit_b32  v42, v13, v12, 23
/*d1ce000c 025e1b0c*/ v_alignbit_b32  v12, v12, v13, 23
/*d1ce000d 027a6332*/ v_alignbit_b32  v13, v50, v49, 30
/*d1ce0031 027a6531*/ v_alignbit_b32  v49, v49, v50, 30
/*d1ce0032 020a491e*/ v_alignbit_b32  v50, v30, v36, 2
/*d1ce001e 020a3d24*/ v_alignbit_b32  v30, v36, v30, 2
/*d1ce0024 02323119*/ v_alignbit_b32  v36, v25, v24, 12
/*d1ce0018 02323318*/ v_alignbit_b32  v24, v24, v25, 12
/*d1ce0019 02124521*/ v_alignbit_b32  v25, v33, v34, 4
/*d1ce0021 02124322*/ v_alignbit_b32  v33, v34, v33, 4
/*d1ce0022 02762d17*/ v_alignbit_b32  v34, v23, v22, 29
/*d1ce0016 02762f16*/ v_alignbit_b32  v22, v22, v23, 29
/*d1ce0017 024e170a*/ v_alignbit_b32  v23, v10, v11, 19
/*d1ce000a 024e150b*/ v_alignbit_b32  v10, v11, v10, 19
/*d1ce000b 020e4730*/ v_alignbit_b32  v11, v48, v35, 3
/*d1ce0023 020e6123*/ v_alignbit_b32  v35, v35, v48, 3
/*d1ce0030 026a371c*/ v_alignbit_b32  v48, v28, v27, 26
/*d1ce001b 026a391b*/ v_alignbit_b32  v27, v27, v28, 26
/*d1ce001c 027e4f26*/ v_alignbit_b32  v28, v38, v39, 31
/*d1ce0026 027e4d27*/ v_alignbit_b32  v38, v39, v38, 31
/*d1ce0027 021e2111*/ v_alignbit_b32  v39, v17, v16, 7
/*d1ce0010 021e2310*/ v_alignbit_b32  v16, v16, v17, 7
/*d1cf0011 020e0504*/ v_alignbyte_b32 v17, v4, v2, 3
/*d1cf0002 020e0902*/ v_alignbyte_b32 v2, v2, v4, 3
/*d1ce0004 023a3b33*/ v_alignbit_b32  v4, v51, v29, 14
/*d1ce001d 023a671d*/ v_alignbit_b32  v29, v29, v51, 14
/*d1ce0033 0272571f*/ v_alignbit_b32  v51, v31, v43, 28
/*d1ce001f 02723f2b*/ v_alignbit_b32  v31, v43, v31, 28
/*d1ce002b 02164125*/ v_alignbit_b32  v43, v37, v32, 5
/*d1ce0020 02164b20*/ v_alignbit_b32  v32, v32, v37, 5
/*d1ce0025 025a2b14*/ v_alignbit_b32  v37, v20, v21, 22
/*d1ce0014 025a2915*/ v_alignbit_b32  v20, v21, v20, 22
/*d1ce0015 02461308*/ v_alignbit_b32  v21, v8, v9, 17
/*d1ce0008 02461109*/ v_alignbit_b32  v8, v9, v8, 17
/*d1cf0009 02065d2f*/ v_alignbyte_b32 v9, v47, v46, 1
/*d1cf002e 02065f2e*/ v_alignbyte_b32 v46, v46, v47, 1
/*d1ce002f 024a5b2c*/ v_alignbit_b32  v47, v44, v45, 18
/*d1ce002c 024a592d*/ v_alignbit_b32  v44, v45, v44, 18
/*d1ce002d 022e0f06*/ v_alignbit_b32  v45, v6, v7, 11
/*d1ce0006 022e0d07*/ v_alignbit_b32  v6, v7, v6, 11
/*260e1b32         */ v_and_b32       v7, v50, v13
/*2a6a5532         */ v_xor_b32       v53, v50, v42
/*266c1f32         */ v_and_b32       v54, v50, v15
/*2a646932         */ v_xor_b32       v50, v50, v52
/*2a701b0f         */ v_xor_b32       v56, v15, v13
/*2672690f         */ v_and_b32       v57, v15, v52
/*2a1e550f         */ v_xor_b32       v15, v15, v42
/*2674692a         */ v_and_b32       v58, v42, v52
/*2654550d         */ v_and_b32       v42, v13, v42
/*2a1a1b34         */ v_xor_b32       v13, v52, v13
/*2668631e         */ v_and_b32       v52, v30, v49
/*2a76191e         */ v_xor_b32       v59, v30, v12
/*2678351e         */ v_and_b32       v60, v30, v26
/*2a3c1d1e         */ v_xor_b32       v30, v30, v14
/*2a7a631a         */ v_xor_b32       v61, v26, v49
/*267c1d1a         */ v_and_b32       v62, v26, v14
/*2a34191a         */ v_xor_b32       v26, v26, v12
/*267e1d0c         */ v_and_b32       v63, v12, v14
/*26181931         */ v_and_b32       v12, v49, v12
/*2a1c630e         */ v_xor_b32       v14, v14, v49
/*26624517         */ v_and_b32       v49, v23, v34
/*2a802f24         */ v_xor_b32       v64, v36, v23
/*26822f0b         */ v_and_b32       v65, v11, v23
/*2a2e2f19         */ v_xor_b32       v23, v25, v23
/*2a841722         */ v_xor_b32       v66, v34, v11
/*26861719         */ v_and_b32       v67, v25, v11
/*2a161724         */ v_xor_b32       v11, v36, v11
/*2a8e4519         */ v_xor_b32       v71, v25, v34
/*26324919         */ v_and_b32       v25, v25, v36
/*26444524         */ v_and_b32       v34, v36, v34
/*26481523         */ v_and_b32       v36, v35, v10
/*2a904716         */ v_xor_b32       v72, v22, v35
/*26924721         */ v_and_b32       v73, v33, v35
/*2a464718         */ v_xor_b32       v35, v24, v35
/*2a942d21         */ v_xor_b32       v74, v33, v22
/*26962d0a         */ v_and_b32       v75, v10, v22
/*262c2d18         */ v_and_b32       v22, v24, v22
/*2a981518         */ v_xor_b32       v76, v24, v10
/*26303121         */ v_and_b32       v24, v33, v24
/*2a141521         */ v_xor_b32       v10, v33, v10
/*26424f11         */ v_and_b32       v33, v17, v39
/*2a9a2330         */ v_xor_b32       v77, v48, v17
/*269c2304         */ v_and_b32       v78, v4, v17
/*2a22231c         */ v_xor_b32       v17, v28, v17
/*2a9e4f1c         */ v_xor_b32       v79, v28, v39
/*26a0091c         */ v_and_b32       v80, v28, v4
/*2638611c         */ v_and_b32       v28, v28, v48
/*2aa20930         */ v_xor_b32       v81, v48, v4
/*26604f30         */ v_and_b32       v48, v48, v39
/*2a080927         */ v_xor_b32       v4, v39, v4
/*264e051d         */ v_and_b32       v39, v29, v2
/*2aa43b10         */ v_xor_b32       v82, v16, v29
/*26a63b26         */ v_and_b32       v83, v38, v29
/*2a3a3b1b         */ v_xor_b32       v29, v27, v29
/*2aa82126         */ v_xor_b32       v84, v38, v16
/*26aa2102         */ v_and_b32       v85, v2, v16
/*2620211b         */ v_and_b32       v16, v27, v16
/*2aac051b         */ v_xor_b32       v86, v27, v2
/*26363726         */ v_and_b32       v27, v38, v27
/*2a040526         */ v_xor_b32       v2, v38, v2
/*264c4b15         */ v_and_b32       v38, v21, v37
/*2aae2b33         */ v_xor_b32       v87, v51, v21
/*26b02b09         */ v_and_b32       v88, v9, v21
/*2a2a2b2b         */ v_xor_b32       v21, v43, v21
/*2ab21325         */ v_xor_b32       v89, v37, v9
/*26b4132b         */ v_and_b32       v90, v43, v9
/*2a121333         */ v_xor_b32       v9, v51, v9
/*2ab64b2b         */ v_xor_b32       v91, v43, v37
/*2656672b         */ v_and_b32       v43, v43, v51
/*264a4b33         */ v_and_b32       v37, v51, v37
/*2666112e         */ v_and_b32       v51, v46, v8
/*2ab85d14         */ v_xor_b32       v92, v20, v46
/*26ba5d20         */ v_and_b32       v93, v32, v46
/*2a5c5d1f         */ v_xor_b32       v46, v31, v46
/*2abc2920         */ v_xor_b32       v94, v32, v20
/*2abe1120         */ v_xor_b32       v95, v32, v8
/*26403f20         */ v_and_b32       v32, v32, v31
/*26c02908         */ v_and_b32       v96, v8, v20
/*2628291f         */ v_and_b32       v20, v31, v20
/*2a10111f         */ v_xor_b32       v8, v31, v8
/*2ace7b3c         */ v_xor_b32       v103, v60, v61
/*2acc7136         */ v_xor_b32       v102, v54, v56
/*2ad0693b         */ v_xor_b32       v104, v59, v52
/*2a0e0f35         */ v_xor_b32       v7, v53, v7
/*266a252d         */ v_and_b32       v53, v45, v18
/*2a245f12         */ v_xor_b32       v18, v18, v47
/*2a705f13         */ v_xor_b32       v56, v19, v47
/*26765b2f         */ v_and_b32       v59, v47, v45
/*265e5f29         */ v_and_b32       v47, v41, v47
/*2a785b13         */ v_xor_b32       v60, v19, v45
/*2a5a5b29         */ v_xor_b32       v45, v41, v45
/*26262729         */ v_and_b32       v19, v41, v19
/*26528906         */ v_and_b32       v41, v6, v68
/*2a7a5944         */ v_xor_b32       v61, v68, v44
/*2a885945         */ v_xor_b32       v68, v69, v44
/*26c20d2c         */ v_and_b32       v97, v44, v6
/*26585928         */ v_and_b32       v44, v40, v44
/*2ac40d45         */ v_xor_b32       v98, v69, v6
/*2a0c0d28         */ v_xor_b32       v6, v40, v6
/*26508b28         */ v_and_b32       v40, v40, v69
/*2ad4190e         */ v_xor_b32       v106, v14, v12
/*2ad2550d         */ v_xor_b32       v105, v13, v42
/*2ad87f1a         */ v_xor_b32       v108, v26, v63
/*2ad6750f         */ v_xor_b32       v107, v15, v58
/*2ada3d3e         */ v_xor_b32       v109, v62, v30
/*2a686539         */ v_xor_b32       v52, v57, v50
/*2ac85d20         */ v_xor_b32       v100, v32, v46
/*2ac6132b         */ v_xor_b32       v99, v43, v9
/*2ababb5f         */ v_xor_b32       v93, v95, v93
/*2ab4b515         */ v_xor_b32       v90, v21, v90
/*2a12675c         */ v_xor_b32       v9, v92, v51
/*2ab0b159         */ v_xor_b32       v88, v89, v88
/*2ab2c108         */ v_xor_b32       v89, v8, v96
/*2aae4d57         */ v_xor_b32       v87, v87, v38
/*2ab8bd14         */ v_xor_b32       v92, v20, v94
/*2a10b725         */ v_xor_b32       v8, v37, v91
/*2ab6a31c         */ v_xor_b32       v91, v28, v81
/*2aa23b1b         */ v_xor_b32       v81, v27, v29
/*2a22a111         */ v_xor_b32       v17, v17, v80
/*2a04a702         */ v_xor_b32       v2, v2, v83
/*2a9c9d04         */ v_xor_b32       v78, v4, v78
/*2a8a4f52         */ v_xor_b32       v69, v82, v39
/*2a2a434d         */ v_xor_b32       v21, v77, v33
/*2a28ab56         */ v_xor_b32       v20, v86, v85
/*2a9e9f30         */ v_xor_b32       v79, v48, v79
/*2a9aa910         */ v_xor_b32       v77, v16, v84
/*2aa01719         */ v_xor_b32       v80, v25, v11
/*2a304718         */ v_xor_b32       v24, v24, v35
/*2a548717         */ v_xor_b32       v42, v23, v67
/*2a08930a         */ v_xor_b32       v4, v10, v73
/*2a388342         */ v_xor_b32       v28, v66, v65
/*2a364948         */ v_xor_b32       v27, v72, v36
/*2a846340         */ v_xor_b32       v66, v64, v49
/*2a3a974c         */ v_xor_b32       v29, v76, v75
/*2a908f22         */ v_xor_b32       v72, v34, v71
/*2a569516         */ v_xor_b32       v43, v22, v74
/*2a46c33d         */ v_xor_b32       v35, v61, v97
/*2a487712         */ v_xor_b32       v36, v18, v59
/*2a4c5362         */ v_xor_b32       v38, v98, v41
/*2a408928         */ v_xor_b32       v32, v40, v68
/*2a4e6b3c         */ v_xor_b32       v39, v60, v53
/*2a4a7113         */ v_xor_b32       v37, v19, v56
/*2a425906         */ v_xor_b32       v33, v6, v44
/*2a445f2d         */ v_xor_b32       v34, v45, v47
/*80088108         */ s_add_u32       s8, s8, 1
/*bf82fe7e         */ s_branch        .L320_0
.L1864_0:
/*2a340922         */ v_xor_b32       v26, v34, v4
/*2a545521         */ v_xor_b32       v42, v33, v42
/*2a3e9146         */ v_xor_b32       v31, v70, v72
/*2a20051a         */ v_xor_b32       v16, v26, v2
/*2a349f1f         */ v_xor_b32       v26, v31, v79
/*2a3ea120         */ v_xor_b32       v31, v32, v80
/*2a403125         */ v_xor_b32       v32, v37, v24
/*2a22232a         */ v_xor_b32       v17, v42, v17
/*2a4a5765         */ v_xor_b32       v37, v101, v43
/*2a4a9b25         */ v_xor_b32       v37, v37, v77
/*2a181125         */ v_xor_b32       v12, v37, v8
/*2a22bb11         */ v_xor_b32       v17, v17, v93
/*2a20b510         */ v_xor_b32       v16, v16, v90
/*2a1ca320         */ v_xor_b32       v14, v32, v81
/*2a1eb71f         */ v_xor_b32       v15, v31, v91
/*2a1ab91a         */ v_xor_b32       v13, v26, v92
/*2a343b27         */ v_xor_b32       v26, v39, v29
/*2a28291a         */ v_xor_b32       v20, v26, v20
/*2a200f10         */ v_xor_b32       v16, v16, v7
/*2a22d111         */ v_xor_b32       v17, v17, v104
/*2a18690c         */ v_xor_b32       v12, v12, v52
/*2a1adb0d         */ v_xor_b32       v13, v13, v109
/*2a348526         */ v_xor_b32       v26, v38, v66
/*2a2a2b1a         */ v_xor_b32       v21, v26, v21
/*2a08c90f         */ v_xor_b32       v4, v15, v100
/*2a04c70e         */ v_xor_b32       v2, v14, v99
/*2a1c3724         */ v_xor_b32       v14, v36, v27
/*2a1c8b0e         */ v_xor_b32       v14, v14, v69
/*2a10b10e         */ v_xor_b32       v8, v14, v88
/*2a1c3923         */ v_xor_b32       v14, v35, v28
/*2a1c9d0e         */ v_xor_b32       v14, v14, v78
/*2a12130e         */ v_xor_b32       v9, v14, v9
/*2a1caf14         */ v_xor_b32       v14, v20, v87
/*2a1cd70e         */ v_xor_b32       v14, v14, v107
/*2a1eb315         */ v_xor_b32       v15, v21, v89
/*2a1ed90f         */ v_xor_b32       v15, v15, v108
/*d1ce0014 027e190d*/ v_alignbit_b32  v20, v13, v12, 31
/*2a282911         */ v_xor_b32       v20, v17, v20
/*d1ce0015 027e2111*/ v_alignbit_b32  v21, v17, v16, 31
/*d1ce0011 027e2310*/ v_alignbit_b32  v17, v16, v17, 31
/*d1ce001a 027e1b0c*/ v_alignbit_b32  v26, v12, v13, 31
/*2a203510         */ v_xor_b32       v16, v16, v26
/*2a12d509         */ v_xor_b32       v9, v9, v106
/*2a10d308         */ v_xor_b32       v8, v8, v105
/*2a04cd02         */ v_xor_b32       v2, v2, v102
/*2a08cf04         */ v_xor_b32       v4, v4, v103
/*d1ce001a 027e0902*/ v_alignbit_b32  v26, v2, v4, 31
/*2a343508         */ v_xor_b32       v26, v8, v26
/*d1ce001f 027e1308*/ v_alignbit_b32  v31, v8, v9, 31
/*d1ce0008 027e1109*/ v_alignbit_b32  v8, v9, v8, 31
/*d1ce0020 027e0504*/ v_alignbit_b32  v32, v4, v2, 31
/*2a124109         */ v_xor_b32       v9, v9, v32
/*2a183f0c         */ v_xor_b32       v12, v12, v31
/*d1ce001f 027e1f0e*/ v_alignbit_b32  v31, v14, v15, 31
/*2a043f02         */ v_xor_b32       v2, v2, v31
/*263e0081         */ v_and_b32       v31, 1, v0
/*243e3e85         */ v_lshlrev_b32   v31, 5, v31
/*24400a83         */ v_lshlrev_b32   v32, 3, v5
/*32404103         */ v_add_u32       v32, vcc, v3, v32
/*323e3f03         */ v_add_u32       v31, vcc, v3, v31
/*2a46cf14         */ v_xor_b32       v35, v20, v103
/*2a28a114         */ v_xor_b32       v20, v20, v80
/*2a22230e         */ v_xor_b32       v17, v14, v17
/*d1ce000e 027e1d0f*/ v_alignbit_b32  v14, v15, v14, 31
/*2a1e2b0f         */ v_xor_b32       v15, v15, v21
/*2a081d04         */ v_xor_b32       v4, v4, v14
/*2a1c4309         */ v_xor_b32       v14, v9, v33
/*2a0ebb09         */ v_xor_b32       v7, v9, v93
/*2a123110         */ v_xor_b32       v9, v16, v24
/*2a20cd10         */ v_xor_b32       v16, v16, v102
/*2a10110d         */ v_xor_b32       v8, v13, v8
/*2a1a451a         */ v_xor_b32       v13, v26, v34
/*2a0cb51a         */ v_xor_b32       v6, v26, v90
/*242a0082         */ v_lshlrev_b32   v21, 2, v0
/*d1ce0018 02121d0d*/ v_alignbit_b32  v24, v13, v14, 4
/*d1ce000d 02121b0e*/ v_alignbit_b32  v13, v14, v13, 4
/*2a1cd50f         */ v_xor_b32       v14, v15, v106
/*2a32d311         */ v_xor_b32       v25, v17, v105
/*d1ce001a 020e330e*/ v_alignbit_b32  v26, v14, v25, 3
/*d1ce000e 020e1d19*/ v_alignbit_b32  v14, v25, v14, 3
/*d1ce0019 02322909*/ v_alignbit_b32  v25, v9, v20, 12
/*d1ce0009 02321314*/ v_alignbit_b32  v9, v20, v9, 12
/*2a28054d         */ v_xor_b32       v20, v77, v2
/*2a2c094f         */ v_xor_b32       v22, v79, v4
/*d1ce0017 02762d14*/ v_alignbit_b32  v23, v20, v22, 29
/*d1ce0014 02762916*/ v_alignbit_b32  v20, v22, v20, 29
/*2a16b308         */ v_xor_b32       v11, v8, v89
/*2a14af0c         */ v_xor_b32       v10, v12, v87
/*d1ce0016 024e150b*/ v_alignbit_b32  v22, v11, v10, 19
/*d1ce000a 024e170a*/ v_alignbit_b32  v10, v10, v11, 19
/*2a040565         */ v_xor_b32       v2, v101, v2
/*d1ce000b 024a4710*/ v_alignbit_b32  v11, v16, v35, 18
/*d1ce0010 024a2123*/ v_alignbit_b32  v16, v35, v16, 18
/*d1ce0021 022e0f06*/ v_alignbit_b32  v33, v6, v7, 11
/*d1ce0006 022e0d07*/ v_alignbit_b32  v6, v7, v6, 11
/*2a0e9d0f         */ v_xor_b32       v7, v15, v78
/*2a248b11         */ v_xor_b32       v18, v17, v69
/*d1ce0013 02562507*/ v_alignbit_b32  v19, v7, v18, 21
/*d1ce0007 02560f12*/ v_alignbit_b32  v7, v18, v7, 21
/*2a248508         */ v_xor_b32       v18, v8, v66
/*2a3a3b0c         */ v_xor_b32       v29, v12, v29
/*d1ce001e 02523b12*/ v_alignbit_b32  v30, v18, v29, 20
/*d1ce0012 0252251d*/ v_alignbit_b32  v18, v29, v18, 20
/*2a080946         */ v_xor_b32       v4, v70, v4
/*2a223711         */ v_xor_b32       v17, v17, v27
/*2a101126         */ v_xor_b32       v8, v38, v8
/*26363518         */ v_and_b32       v27, v24, v26
/*2a3a2d18         */ v_xor_b32       v29, v24, v22
/*26443318         */ v_and_b32       v34, v24, v25
/*2a302f18         */ v_xor_b32       v24, v24, v23
/*2a463519         */ v_xor_b32       v35, v25, v26
/*26482f19         */ v_and_b32       v36, v25, v23
/*2a322d19         */ v_xor_b32       v25, v25, v22
/*2a4a3517         */ v_xor_b32       v37, v23, v26
/*262e2f16         */ v_and_b32       v23, v22, v23
/*262c2d1a         */ v_and_b32       v22, v26, v22
/*2a1e390f         */ v_xor_b32       v15, v15, v28
/*2a181927         */ v_xor_b32       v12, v39, v12
/*2634290a         */ v_and_b32       v26, v10, v20
/*2a381509         */ v_xor_b32       v28, v9, v10
/*264c150e         */ v_and_b32       v38, v14, v10
/*2a14150d         */ v_xor_b32       v10, v13, v10
/*264e1d0d         */ v_and_b32       v39, v13, v14
/*2650130d         */ v_and_b32       v40, v13, v9
/*2a1a290d         */ v_xor_b32       v13, v13, v20
/*2a521d09         */ v_xor_b32       v41, v9, v14
/*2a1c1d14         */ v_xor_b32       v14, v20, v14
/*26122909         */ v_and_b32       v9, v9, v20
/*2628271e         */ v_and_b32       v20, v30, v19
/*2a542702         */ v_xor_b32       v42, v2, v19
/*26562721         */ v_and_b32       v43, v33, v19
/*2a261713         */ v_xor_b32       v19, v19, v11
/*2a58171e         */ v_xor_b32       v44, v30, v11
/*265a430b         */ v_and_b32       v45, v11, v33
/*26161702         */ v_and_b32       v11, v2, v11
/*2a5c431e         */ v_xor_b32       v46, v30, v33
/*2a424302         */ v_xor_b32       v33, v2, v33
/*26043d02         */ v_and_b32       v2, v2, v30
/*263c0f12         */ v_and_b32       v30, v18, v7
/*2a5e0f04         */ v_xor_b32       v47, v4, v7
/*26600f06         */ v_and_b32       v48, v6, v7
/*2a0e2107         */ v_xor_b32       v7, v7, v16
/*2a622112         */ v_xor_b32       v49, v18, v16
/*26640d10         */ v_and_b32       v50, v16, v6
/*26202104         */ v_and_b32       v16, v4, v16
/*2a660d12         */ v_xor_b32       v51, v18, v6
/*2a0c0d04         */ v_xor_b32       v6, v4, v6
/*26082504         */ v_and_b32       v4, v4, v18
/*2ad05328         */ v_xor_b32       v104, v40, v41
/*2a3c5f1e         */ v_xor_b32       v30, v30, v47
/*2ace4722         */ v_xor_b32       v103, v34, v35
/*2a285514         */ v_xor_b32       v20, v20, v42
/*2ab64f0a         */ v_xor_b32       v91, v10, v39
/*2aae371d         */ v_xor_b32       v87, v29, v27
/*d1ce004d 027e1908*/ v_alignbit_b32  v77, v8, v12, 31
/*d1ce0008 027e110c*/ v_alignbit_b32  v8, v12, v8, 31
/*2aa04d0e         */ v_xor_b32       v80, v14, v38
/*2a9e2d25         */ v_xor_b32       v79, v37, v22
/*d1ce004e 026a230f*/ v_alignbit_b32  v78, v15, v17, 26
/*d1ce001b 026a1f11*/ v_alignbit_b32  v27, v17, v15, 26
/*2a96351c         */ v_xor_b32       v75, v28, v26
/*2a942f19         */ v_xor_b32       v74, v25, v23
/*2a921b09         */ v_xor_b32       v73, v9, v13
/*2a903124         */ v_xor_b32       v72, v36, v24
/*2aa46507         */ v_xor_b32       v82, v7, v50
/*2aa25b13         */ v_xor_b32       v81, v19, v45
/*2a8e6133         */ v_xor_b32       v71, v51, v48
/*2aa86304         */ v_xor_b32       v84, v4, v49
/*2a8c572e         */ v_xor_b32       v70, v46, v43
/*2aa65902         */ v_xor_b32       v83, v2, v44
/*2aac2106         */ v_xor_b32       v86, v6, v16
/*2aaa1721         */ v_xor_b32       v85, v33, v11
/*260000ff 000000fc*/ v_and_b32       v0, 0xfc, v0
/*2ad83cff 80000000*/ v_xor_b32       v108, 0x80000000, v30
/*2ad628ff 80008008*/ v_xor_b32       v107, 0x80008008, v20
/*24340a85         */ v_lshlrev_b32   v26, 5, v5
/*d0c50002 00010105*/ v_cmp_lg_i32    s[2:3], v5, 0
/*be86017e         */ s_mov_b64       s[6:7], exec
/*89fe0206         */ s_andn2_b64     exec, s[6:7], s[2:3]
/*bf880008         */ s_cbranch_execz .L2760_0
/*d89c0100 00466b03*/ ds_write2_b64   v3, v[107:108], v[70:71] offset1:1
/*d89c0302 00555103*/ ds_write2_b64   v3, v[81:82], v[85:86] offset0:2 offset1:3
/*d89c0504 00485303*/ ds_write2_b64   v3, v[83:84], v[72:73] offset0:4 offset1:5
/*d89c0706 004f4a03*/ ds_write2_b64   v3, v[74:75], v[79:80] offset0:6 offset1:7
.L2760_0:
/*befe0106         */ s_mov_b64       exec, s[6:7]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*c0020042 00000048*/ s_load_dword    s1, s[4:5], 0x48
/*c0060182 00000040*/ s_load_dwordx2  s[6:7], s[4:5], 0x40
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*be8800ff 01000193*/ s_mov_b32       s8, 0x1000193
/*7e380c01         */ v_cvt_f32_u32   v28, s1
/*7e38451c         */ v_rcp_f32       v28, v28
/*0a3838ff 4f800000*/ v_mul_f32       v28, 0x4f800000 /* 4.2949673e+9f */, v28
/*7e380f1c         */ v_cvt_u32_f32   v28, v28
/*d285001e 00023801*/ v_mul_lo_u32    v30, s1, v28
/*d2860021 00023801*/ v_mul_hi_u32    v33, s1, v28
/*34463c80         */ v_sub_u32       v35, vcc, 0, v30
/*d0c5000a 00024280*/ v_cmp_lg_i32    s[10:11], 0, v33
/*d1000024 002a3d23*/ v_cndmask_b32   v36, v35, v30, s[10:11]
/*d2860024 00023924*/ v_mul_hi_u32    v36, v36, v28
/*344a491c         */ v_sub_u32       v37, vcc, v28, v36
/*3248491c         */ v_add_u32       v36, vcc, v28, v36
/*d1000024 002a4b24*/ v_cndmask_b32   v36, v36, v37, s[10:11]
/*d0c5000a 00000280*/ v_cmp_lg_i32    s[10:11], 0, s1
/*244a0082         */ v_lshlrev_b32   v37, 2, v0
/*7e4c0207         */ v_mov_b32       v38, s7
/*7e4e02ff 01000193*/ v_mov_b32       v39, 0x1000193
/*d8ee0302 2800001f*/ ds_read2_b64    v[40:43], v31 offset0:2 offset1:3
/*d8ee0100 2c00001f*/ ds_read2_b64    v[44:47], v31 offset1:1
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf800000         */ /*s_nop           0x0*/
/*d285002d 0000112d*/ v_mul_lo_u32    v45, v45, s8
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850030 00024f2c*/ v_mul_lo_u32    v48, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0000 31000003*/ ds_read_b32     v49, v3
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2850032 00001131*/ v_mul_lo_u32    v50, v49, s8
/*2a585932         */ v_xor_b32       v44, v50, v44
/*d2860032 00025924*/ v_mul_hi_u32    v50, v36, v44
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*3466652c         */ v_sub_u32       v51, vcc, v44, v50
/*d0ce000c 0002652c*/ v_cmp_ge_u32    s[12:13], v44, v50
/*36586601         */ v_subrev_u32    v44, vcc, s1, v51
/*7d966601         */ v_cmp_le_u32    vcc, s1, v51
/*86ea6a0c         */ s_and_b64       vcc, s[12:13], vcc
/*00585933         */ v_cndmask_b32   v44, v51, v44, vcc
/*32645801         */ v_add_u32       v50, vcc, s1, v44
/*d100002c 00325932*/ v_cndmask_b32   v44, v50, v44, s[12:13]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a586281         */ v_xor_b32       v44, 1, v49
/*d285002c 0000112c*/ v_mul_lo_u32    v44, v44, s8
/*2a646287         */ v_xor_b32       v50, 7, v49
/*2a666286         */ v_xor_b32       v51, 6, v49
/*2a686285         */ v_xor_b32       v52, 5, v49
/*2a6a6284         */ v_xor_b32       v53, 4, v49
/*2a6c6283         */ v_xor_b32       v54, 3, v49
/*2a6e6282         */ v_xor_b32       v55, 2, v49
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*d2850033 00024f33*/ v_mul_lo_u32    v51, v51, v39
/*d2850032 00024f32*/ v_mul_lo_u32    v50, v50, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32707006         */ v_add_u32       v56, vcc, s6, v56
/*38727326         */ v_addc_u32      v57, vcc, v38, v57, vcc
/*32703538         */ v_add_u32       v56, vcc, v56, v26
/*d11c6a39 01a90139*/ v_addc_u32      v57, vcc, v57, 0, vcc
/*d1196a06 00012138*/ v_add_u32       v6, vcc, v56, 16
/*d11c6a07 01a90139*/ v_addc_u32      v7, vcc, v57, 0, vcc
/*dc5c0000 3c000038*/ flat_load_dwordx4 v[60:63], v[56:57] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58592d         */ v_xor_b32       v44, v45, v44
/*d286003d 00025924*/ v_mul_hi_u32    v61, v36, v44
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*34807b2c         */ v_sub_u32       v64, vcc, v44, v61
/*d0ce0008 00027b2c*/ v_cmp_ge_u32    s[8:9], v44, v61
/*36588001         */ v_subrev_u32    v44, vcc, s1, v64
/*7d968001         */ v_cmp_le_u32    vcc, s1, v64
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00585940         */ v_cndmask_b32   v44, v64, v44, vcc
/*327a5801         */ v_add_u32       v61, vcc, s1, v44
/*d100002c 0022593d*/ v_cndmask_b32   v44, v61, v44, s[8:9]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a587930         */ v_xor_b32       v44, v48, v60
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*bf800000         */ /*s_nop           0x0*/
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38707326         */ v_addc_u32      v56, vcc, v38, v57, vcc
/*32763530         */ v_add_u32       v59, vcc, v48, v26
/*d11c6a3c 01a90138*/ v_addc_u32      v60, vcc, v56, 0, vcc
/*d1196a38 0001213b*/ v_add_u32       v56, vcc, v59, 16
/*d11c6a39 01a9013c*/ v_addc_u32      v57, vcc, v60, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000038*/ flat_load_dwordx4 v[63:66], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a606f2e         */ v_xor_b32       v48, v46, v55
/*d2860037 00026124*/ v_mul_hi_u32    v55, v36, v48
/*d2850037 00000337*/ v_mul_lo_u32    v55, v55, s1
/*34706f30         */ v_sub_u32       v56, vcc, v48, v55
/*d0ce0008 00026f30*/ v_cmp_ge_u32    s[8:9], v48, v55
/*36607001         */ v_subrev_u32    v48, vcc, s1, v56
/*7d967001         */ v_cmp_le_u32    vcc, s1, v56
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606138         */ v_cndmask_b32   v48, v56, v48, vcc
/*326e6001         */ v_add_u32       v55, vcc, s1, v48
/*d1000030 00226137*/ v_cndmask_b32   v48, v55, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56852b         */ v_xor_b32       v43, v43, v66
/*2a54832a         */ v_xor_b32       v42, v42, v65
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*2a507f28         */ v_xor_b32       v40, v40, v63
/*2a528129         */ v_xor_b32       v41, v41, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 37000025*/ ds_read_b32     v55, v37 offset:3072
/*7e700280         */ v_mov_b32       v56, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0037 00026e87*/ v_lshlrev_b64   v[55:56], 7, v[55:56]
/*32606e06         */ v_add_u32       v48, vcc, s6, v55
/*386e7126         */ v_addc_u32      v55, vcc, v38, v56, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90137*/ v_addc_u32      v61, vcc, v55, 0, vcc
/*d1196a38 0001213c*/ v_add_u32       v56, vcc, v60, 16
/*d11c6a39 01a9013d*/ v_addc_u32      v57, vcc, v61, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527329         */ v_xor_b32       v41, v41, v57
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a606d2f         */ v_xor_b32       v48, v47, v54
/*d2860036 00026124*/ v_mul_hi_u32    v54, v36, v48
/*d2850036 00000336*/ v_mul_lo_u32    v54, v54, s1
/*346e6d30         */ v_sub_u32       v55, vcc, v48, v54
/*d0ce0008 00026d30*/ v_cmp_ge_u32    s[8:9], v48, v54
/*36606e01         */ v_subrev_u32    v48, vcc, s1, v55
/*7d966e01         */ v_cmp_le_u32    vcc, s1, v55
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606137         */ v_cndmask_b32   v48, v55, v48, vcc
/*326c6001         */ v_add_u32       v54, vcc, s1, v48
/*d1000030 00226136*/ v_cndmask_b32   v48, v54, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*2a507128         */ v_xor_b32       v40, v40, v56
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 36000025*/ ds_read_b32     v54, v37 offset:3072
/*7e6e0280         */ v_mov_b32       v55, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0036 00026c87*/ v_lshlrev_b64   v[54:55], 7, v[54:55]
/*32606c06         */ v_add_u32       v48, vcc, s6, v54
/*386c6f26         */ v_addc_u32      v54, vcc, v38, v55, vcc
/*32763530         */ v_add_u32       v59, vcc, v48, v26
/*d11c6a3c 01a90136*/ v_addc_u32      v60, vcc, v54, 0, vcc
/*d1196a37 0001213b*/ v_add_u32       v55, vcc, v59, 16
/*d11c6a38 01a9013c*/ v_addc_u32      v56, vcc, v60, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a606b28         */ v_xor_b32       v48, v40, v53
/*d2860035 00026124*/ v_mul_hi_u32    v53, v36, v48
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b30         */ v_sub_u32       v54, vcc, v48, v53
/*d0ce0008 00026b30*/ v_cmp_ge_u32    s[8:9], v48, v53
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*326a6001         */ v_add_u32       v53, vcc, s1, v48
/*d1000030 00226135*/ v_cndmask_b32   v48, v53, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a56752b         */ v_xor_b32       v43, v43, v58
/*2a54732a         */ v_xor_b32       v42, v42, v57
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32606a06         */ v_add_u32       v48, vcc, s6, v53
/*386a6d26         */ v_addc_u32      v53, vcc, v38, v54, vcc
/*32743530         */ v_add_u32       v58, vcc, v48, v26
/*d11c6a3b 01a90135*/ v_addc_u32      v59, vcc, v53, 0, vcc
/*d1196a36 0001213a*/ v_add_u32       v54, vcc, v58, 16
/*d11c6a37 01a9013b*/ v_addc_u32      v55, vcc, v59, 0, vcc
/*dc5c0000 36000036*/ flat_load_dwordx4 v[54:57], v[54:55] slc glc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a526f29         */ v_xor_b32       v41, v41, v55
/*2a606929         */ v_xor_b32       v48, v41, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56732b         */ v_xor_b32       v43, v43, v57
/*2a54712a         */ v_xor_b32       v42, v42, v56
/*2a506d28         */ v_xor_b32       v40, v40, v54
/*2a5a772d         */ v_xor_b32       v45, v45, v59
/*2a58752c         */ v_xor_b32       v44, v44, v58
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e7b2f         */ v_xor_b32       v47, v47, v61
/*2a5c792e         */ v_xor_b32       v46, v46, v60
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a35 00012106*/ v_add_u32       v53, vcc, v6, 16
/*d11c6a36 01a90107*/ v_addc_u32      v54, vcc, v7, 0, vcc
/*2a6e6288         */ v_xor_b32       v55, 8, v49
/*dc5c0000 38000035*/ flat_load_dwordx4 v[56:59], v[53:54] slc glc
/*dc5c0000 3c000006*/ flat_load_dwordx4 v[60:63], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a60672a         */ v_xor_b32       v48, v42, v51
/*d2860033 00026124*/ v_mul_hi_u32    v51, v36, v48
/*d2850033 00000333*/ v_mul_lo_u32    v51, v51, s1
/*34686730         */ v_sub_u32       v52, vcc, v48, v51
/*d0ce0008 00026730*/ v_cmp_ge_u32    s[8:9], v48, v51
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32666001         */ v_add_u32       v51, vcc, s1, v48
/*d1000030 00226133*/ v_cndmask_b32   v48, v51, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f37*/ v_mul_lo_u32    v48, v55, v39
/*28660081         */ v_or_b32        v51, 1, v0
/*24666682         */ v_lshlrev_b32   v51, 2, v51
/*2a686289         */ v_xor_b32       v52, 9, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a628f         */ v_xor_b32       v53, 15, v49
/*2a6c628e         */ v_xor_b32       v54, 14, v49
/*2a6e628d         */ v_xor_b32       v55, 13, v49
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32707006         */ v_add_u32       v56, vcc, s6, v56
/*38727326         */ v_addc_u32      v57, vcc, v38, v57, vcc
/*32703538         */ v_add_u32       v56, vcc, v56, v26
/*d11c6a39 01a90139*/ v_addc_u32      v57, vcc, v57, 0, vcc
/*d1196a3a 00012138*/ v_add_u32       v58, vcc, v56, 16
/*d11c6a3b 01a90139*/ v_addc_u32      v59, vcc, v57, 0, vcc
/*2a78628c         */ v_xor_b32       v60, 12, v49
/*2a7a628b         */ v_xor_b32       v61, 11, v49
/*2a7c628a         */ v_xor_b32       v62, 10, v49
/*dc5c0000 3f00003a*/ flat_load_dwordx4 v[63:66], v[58:59] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56852b         */ v_xor_b32       v43, v43, v66
/*2a64652b         */ v_xor_b32       v50, v43, v50
/*d2860042 00026524*/ v_mul_hi_u32    v66, v36, v50
/*d2850042 00000342*/ v_mul_lo_u32    v66, v66, s1
/*34868532         */ v_sub_u32       v67, vcc, v50, v66
/*d0ce0008 00028532*/ v_cmp_ge_u32    s[8:9], v50, v66
/*36648601         */ v_subrev_u32    v50, vcc, s1, v67
/*7d968601         */ v_cmp_le_u32    vcc, s1, v67
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00646543         */ v_cndmask_b32   v50, v67, v50, vcc
/*32846401         */ v_add_u32       v66, vcc, s1, v50
/*d1000032 00226542*/ v_cndmask_b32   v50, v66, v50, s[8:9]
/*d1000032 002a64c1*/ v_cndmask_b32   v50, -1, v50, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003215*/ ds_write_b32    v21, v50 offset:3072
/*2a54832a         */ v_xor_b32       v42, v42, v65
/*2a528129         */ v_xor_b32       v41, v41, v64
/*2a507f28         */ v_xor_b32       v40, v40, v63
/*2a5e772f         */ v_xor_b32       v47, v47, v59
/*2a5c752e         */ v_xor_b32       v46, v46, v58
/*2a5a732d         */ v_xor_b32       v45, v45, v57
/*2a58712c         */ v_xor_b32       v44, v44, v56
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850032 00024f3e*/ v_mul_lo_u32    v50, v62, v39
/*d2850038 00024f3d*/ v_mul_lo_u32    v56, v61, v39
/*d2850039 00024f3c*/ v_mul_lo_u32    v57, v60, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a3c 0001213a*/ v_add_u32       v60, vcc, v58, 16
/*d11c6a3d 01a9013b*/ v_addc_u32      v61, vcc, v59, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567f2b         */ v_xor_b32       v43, v43, v63
/*2a547d2a         */ v_xor_b32       v42, v42, v62
/*2a527b29         */ v_xor_b32       v41, v41, v61
/*2a507928         */ v_xor_b32       v40, v40, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e872f         */ v_xor_b32       v47, v47, v67
/*2a5c852e         */ v_xor_b32       v46, v46, v66
/*2a5a832d         */ v_xor_b32       v45, v45, v65
/*2a58812c         */ v_xor_b32       v44, v44, v64
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003a 00026124*/ v_mul_hi_u32    v58, v36, v48
/*d285003a 0000033a*/ v_mul_lo_u32    v58, v58, s1
/*34767530         */ v_sub_u32       v59, vcc, v48, v58
/*d0ce0008 00027530*/ v_cmp_ge_u32    s[8:9], v48, v58
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32746001         */ v_add_u32       v58, vcc, s1, v48
/*d1000030 0022613a*/ v_cndmask_b32   v48, v58, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3a000033*/ ds_read_b32     v58, v51 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34746930         */ v_sub_u32       v58, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000033*/ ds_read_b32     v58, v51 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90134*/ v_addc_u32      v61, vcc, v52, 0, vcc
/*d1196a3a 0001213c*/ v_add_u32       v58, vcc, v60, 16
/*d11c6a3b 01a9013d*/ v_addc_u32      v59, vcc, v61, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a60652e         */ v_xor_b32       v48, v46, v50
/*d2860032 00026124*/ v_mul_hi_u32    v50, v36, v48
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*34686530         */ v_sub_u32       v52, vcc, v48, v50
/*d0ce0008 00026530*/ v_cmp_ge_u32    s[8:9], v48, v50
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32646001         */ v_add_u32       v50, vcc, s1, v48
/*d1000030 00226132*/ v_cndmask_b32   v48, v50, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000033*/ ds_read_b32     v58, v51 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38647726         */ v_addc_u32      v50, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90132*/ v_addc_u32      v63, vcc, v50, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a60712f         */ v_xor_b32       v48, v47, v56
/*d2860032 00026124*/ v_mul_hi_u32    v50, v36, v48
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*34686530         */ v_sub_u32       v52, vcc, v48, v50
/*d0ce0008 00026530*/ v_cmp_ge_u32    s[8:9], v48, v50
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32646001         */ v_add_u32       v50, vcc, s1, v48
/*d1000030 00226132*/ v_cndmask_b32   v48, v50, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000033*/ ds_read_b32     v58, v51 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38647726         */ v_addc_u32      v50, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90132*/ v_addc_u32      v63, vcc, v50, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860032 00026124*/ v_mul_hi_u32    v50, v36, v48
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*34686530         */ v_sub_u32       v52, vcc, v48, v50
/*d0ce0008 00026530*/ v_cmp_ge_u32    s[8:9], v48, v50
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32646001         */ v_add_u32       v50, vcc, s1, v48
/*d1000030 00226132*/ v_cndmask_b32   v48, v50, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 38000033*/ ds_read_b32     v56, v51 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38647326         */ v_addc_u32      v50, vcc, v38, v57, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90132*/ v_addc_u32      v61, vcc, v50, 0, vcc
/*d1196a38 0001213c*/ v_add_u32       v56, vcc, v60, 16
/*d11c6a39 01a9013d*/ v_addc_u32      v57, vcc, v61, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a606f29         */ v_xor_b32       v48, v41, v55
/*d2860032 00026124*/ v_mul_hi_u32    v50, v36, v48
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*34686530         */ v_sub_u32       v52, vcc, v48, v50
/*d0ce0008 00026530*/ v_cmp_ge_u32    s[8:9], v48, v50
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32646001         */ v_add_u32       v50, vcc, s1, v48
/*d1000030 00226132*/ v_cndmask_b32   v48, v50, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 37000033*/ ds_read_b32     v55, v51 offset:3072
/*7e700280         */ v_mov_b32       v56, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0037 00026e87*/ v_lshlrev_b64   v[55:56], 7, v[55:56]
/*32606e06         */ v_add_u32       v48, vcc, s6, v55
/*38647126         */ v_addc_u32      v50, vcc, v38, v56, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90132*/ v_addc_u32      v62, vcc, v50, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*2a706290         */ v_xor_b32       v56, 16, v49
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a606d2a         */ v_xor_b32       v48, v42, v54
/*d2860032 00026124*/ v_mul_hi_u32    v50, v36, v48
/*d2850032 00000332*/ v_mul_lo_u32    v50, v50, s1
/*34686530         */ v_sub_u32       v52, vcc, v48, v50
/*d0ce0008 00026530*/ v_cmp_ge_u32    s[8:9], v48, v50
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32646001         */ v_add_u32       v50, vcc, s1, v48
/*d1000030 00226132*/ v_cndmask_b32   v48, v50, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f38*/ v_mul_lo_u32    v48, v56, v39
/*28640082         */ v_or_b32        v50, 2, v0
/*24646482         */ v_lshlrev_b32   v50, 2, v50
/*2a686291         */ v_xor_b32       v52, 17, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c6297         */ v_xor_b32       v54, 23, v49
/*2a6e6296         */ v_xor_b32       v55, 22, v49
/*2a706295         */ v_xor_b32       v56, 21, v49
/*d86c0c00 39000033*/ ds_read_b32     v57, v51 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32727206         */ v_add_u32       v57, vcc, s6, v57
/*38747526         */ v_addc_u32      v58, vcc, v38, v58, vcc
/*32723539         */ v_add_u32       v57, vcc, v57, v26
/*d11c6a3a 01a9013a*/ v_addc_u32      v58, vcc, v58, 0, vcc
/*d1196a3b 00012139*/ v_add_u32       v59, vcc, v57, 16
/*d11c6a3c 01a9013a*/ v_addc_u32      v60, vcc, v58, 0, vcc
/*2a7a6294         */ v_xor_b32       v61, 20, v49
/*2a7c6293         */ v_xor_b32       v62, 19, v49
/*2a7e6292         */ v_xor_b32       v63, 18, v49
/*dc5c0000 4000003b*/ flat_load_dwordx4 v[64:67], v[59:60] slc glc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e792f         */ v_xor_b32       v47, v47, v60
/*2a5c772e         */ v_xor_b32       v46, v46, v59
/*2a5a752d         */ v_xor_b32       v45, v45, v58
/*2a58732c         */ v_xor_b32       v44, v44, v57
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d2850039 00024f3e*/ v_mul_lo_u32    v57, v62, v39
/*d285003a 00024f3d*/ v_mul_lo_u32    v58, v61, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60732f         */ v_xor_b32       v48, v47, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a607528         */ v_xor_b32       v48, v40, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a726298         */ v_xor_b32       v57, 24, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*28000083         */ v_or_b32        v0, 3, v0
/*24000082         */ v_lshlrev_b32   v0, 2, v0
/*2a686299         */ v_xor_b32       v52, 25, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a629f         */ v_xor_b32       v53, 31, v49
/*2a6e629e         */ v_xor_b32       v55, 30, v49
/*2a70629d         */ v_xor_b32       v56, 29, v49
/*d86c0c00 39000032*/ ds_read_b32     v57, v50 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32727206         */ v_add_u32       v57, vcc, s6, v57
/*38747526         */ v_addc_u32      v58, vcc, v38, v58, vcc
/*32723539         */ v_add_u32       v57, vcc, v57, v26
/*d11c6a3a 01a9013a*/ v_addc_u32      v58, vcc, v58, 0, vcc
/*d1196a3b 00012139*/ v_add_u32       v59, vcc, v57, 16
/*d11c6a3c 01a9013a*/ v_addc_u32      v60, vcc, v58, 0, vcc
/*2a7a629c         */ v_xor_b32       v61, 28, v49
/*2a7c629b         */ v_xor_b32       v62, 27, v49
/*2a7e629a         */ v_xor_b32       v63, 26, v49
/*dc5c0000 4000003b*/ flat_load_dwordx4 v[64:67], v[59:60] slc glc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e792f         */ v_xor_b32       v47, v47, v60
/*2a5c772e         */ v_xor_b32       v46, v46, v59
/*2a5a752d         */ v_xor_b32       v45, v45, v58
/*2a58732c         */ v_xor_b32       v44, v44, v57
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d2850039 00024f3e*/ v_mul_lo_u32    v57, v62, v39
/*d285003a 00024f3d*/ v_mul_lo_u32    v58, v61, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60732f         */ v_xor_b32       v48, v47, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a607528         */ v_xor_b32       v48, v40, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000000*/ ds_read_b32     v57, v0 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000000*/ ds_read_b32     v56, v0 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262a0         */ v_xor_b32       v57, 32, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a1         */ v_xor_b32       v52, 33, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62a7         */ v_xor_b32       v54, 39, v49
/*2a6e62a6         */ v_xor_b32       v55, 38, v49
/*2a7062a5         */ v_xor_b32       v56, 37, v49
/*2a7262a4         */ v_xor_b32       v57, 36, v49
/*2a7462a3         */ v_xor_b32       v58, 35, v49
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62a2         */ v_xor_b32       v63, 34, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262a8         */ v_xor_b32       v57, 40, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a9         */ v_xor_b32       v52, 41, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62af         */ v_xor_b32       v53, 47, v49
/*2a6e62ae         */ v_xor_b32       v55, 46, v49
/*2a7062ad         */ v_xor_b32       v56, 45, v49
/*2a7262ac         */ v_xor_b32       v57, 44, v49
/*2a7462ab         */ v_xor_b32       v58, 43, v49
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62aa         */ v_xor_b32       v63, 42, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000033*/ ds_read_b32     v58, v51 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000033*/ ds_read_b32     v57, v51 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000033*/ ds_read_b32     v56, v51 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262b0         */ v_xor_b32       v57, 48, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b1         */ v_xor_b32       v52, 49, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62b7         */ v_xor_b32       v54, 55, v49
/*2a6e62b6         */ v_xor_b32       v55, 54, v49
/*2a7062b5         */ v_xor_b32       v56, 53, v49
/*2a7262b4         */ v_xor_b32       v57, 52, v49
/*2a7462b3         */ v_xor_b32       v58, 51, v49
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62b2         */ v_xor_b32       v63, 50, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262b8         */ v_xor_b32       v57, 56, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b9         */ v_xor_b32       v52, 57, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62bf         */ v_xor_b32       v53, 63, v49
/*2a6e62be         */ v_xor_b32       v55, 62, v49
/*2a7062bd         */ v_xor_b32       v56, 61, v49
/*2a7262bc         */ v_xor_b32       v57, 60, v49
/*2a7462bb         */ v_xor_b32       v58, 59, v49
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a6262ba         */ v_xor_b32       v49, 58, v49
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d286003b 00026d24*/ v_mul_hi_u32    v59, v36, v54
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787736         */ v_sub_u32       v60, vcc, v54, v59
/*d0ce0008 00027736*/ v_cmp_ge_u32    s[8:9], v54, v59
/*366c7801         */ v_subrev_u32    v54, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d3c         */ v_cndmask_b32   v54, v60, v54, vcc
/*32766c01         */ v_add_u32       v59, vcc, s1, v54
/*d1000036 00226d3b*/ v_cndmask_b32   v54, v59, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850031 00024f31*/ v_mul_lo_u32    v49, v49, v39
/*d2850036 00024f3a*/ v_mul_lo_u32    v54, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a3c 0001213a*/ v_add_u32       v60, vcc, v58, 16
/*d11c6a3d 01a9013b*/ v_addc_u32      v61, vcc, v59, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567f2b         */ v_xor_b32       v43, v43, v63
/*2a547d2a         */ v_xor_b32       v42, v42, v62
/*2a527b29         */ v_xor_b32       v41, v41, v61
/*2a507928         */ v_xor_b32       v40, v40, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e872f         */ v_xor_b32       v47, v47, v67
/*2a5c852e         */ v_xor_b32       v46, v46, v66
/*2a5a832d         */ v_xor_b32       v45, v45, v65
/*2a58812c         */ v_xor_b32       v44, v44, v64
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003a 00026124*/ v_mul_hi_u32    v58, v36, v48
/*d285003a 0000033a*/ v_mul_lo_u32    v58, v58, s1
/*34767530         */ v_sub_u32       v59, vcc, v48, v58
/*d0ce0008 00027530*/ v_cmp_ge_u32    s[8:9], v48, v58
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32746001         */ v_add_u32       v58, vcc, s1, v48
/*d1000030 0022613a*/ v_cndmask_b32   v48, v58, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34746930         */ v_sub_u32       v58, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90134*/ v_addc_u32      v61, vcc, v52, 0, vcc
/*d1196a3a 0001213c*/ v_add_u32       v58, vcc, v60, 16
/*d11c6a3b 01a9013d*/ v_addc_u32      v59, vcc, v61, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a60632e         */ v_xor_b32       v48, v46, v49
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a3a 00012130*/ v_add_u32       v58, vcc, v48, 16
/*d11c6a3b 01a90131*/ v_addc_u32      v59, vcc, v49, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a606d2f         */ v_xor_b32       v48, v47, v54
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a3a 00012130*/ v_add_u32       v58, vcc, v48, 16
/*d11c6a3b 01a90131*/ v_addc_u32      v59, vcc, v49, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a39 00012130*/ v_add_u32       v57, vcc, v48, 16
/*d11c6a3a 01a90131*/ v_addc_u32      v58, vcc, v49, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000030*/ flat_load_dwordx4 v[61:64], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a38 00012130*/ v_add_u32       v56, vcc, v48, 16
/*d11c6a39 01a90131*/ v_addc_u32      v57, vcc, v49, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c000030*/ flat_load_dwordx4 v[60:63], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a36 00012130*/ v_add_u32       v54, vcc, v48, 16
/*d11c6a37 01a90131*/ v_addc_u32      v55, vcc, v49, 0, vcc
/*dc5c0000 36000036*/ flat_load_dwordx4 v[54:57], v[54:55] slc glc
/*dc5c0000 3a000030*/ flat_load_dwordx4 v[58:61], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56732b         */ v_xor_b32       v43, v43, v57
/*2a606b2b         */ v_xor_b32       v48, v43, v53
/*d2860024 00026124*/ v_mul_hi_u32    v36, v36, v48
/*d2850024 00000324*/ v_mul_lo_u32    v36, v36, s1
/*34624930         */ v_sub_u32       v49, vcc, v48, v36
/*d0ce0008 00024930*/ v_cmp_ge_u32    s[8:9], v48, v36
/*36486201         */ v_subrev_u32    v36, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00484931         */ v_cndmask_b32   v36, v49, v36, vcc
/*32604801         */ v_add_u32       v48, vcc, s1, v36
/*d1000024 00224930*/ v_cndmask_b32   v36, v48, v36, s[8:9]
/*d1000024 002a48c1*/ v_cndmask_b32   v36, -1, v36, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002415*/ ds_write_b32    v21, v36 offset:3072
/*2a48712a         */ v_xor_b32       v36, v42, v56
/*2a526f29         */ v_xor_b32       v41, v41, v55
/*2a506d28         */ v_xor_b32       v40, v40, v54
/*2a547b2f         */ v_xor_b32       v42, v47, v61
/*2a5c792e         */ v_xor_b32       v46, v46, v60
/*2a5a772d         */ v_xor_b32       v45, v45, v59
/*2a58752c         */ v_xor_b32       v44, v44, v58
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 2f000000*/ ds_read_b32     v47, v0 offset:3072
/*7e600280         */ v_mov_b32       v48, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002f 00025e87*/ v_lshlrev_b64   v[47:48], 7, v[47:48]
/*325e5e06         */ v_add_u32       v47, vcc, s6, v47
/*384c6126         */ v_addc_u32      v38, vcc, v38, v48, vcc
/*320c352f         */ v_add_u32       v6, vcc, v47, v26
/*d11c6a07 01a90126*/ v_addc_u32      v7, vcc, v38, 0, vcc
/*d1196a30 00012106*/ v_add_u32       v48, vcc, v6, 16
/*d11c6a31 01a90107*/ v_addc_u32      v49, vcc, v7, 0, vcc
/*dc5c0000 34000030*/ flat_load_dwordx4 v[52:55], v[48:49] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4c6f2b         */ v_xor_b32       v38, v43, v55
/*2a486d24         */ v_xor_b32       v36, v36, v54
/*2a526b29         */ v_xor_b32       v41, v41, v53
/*2a506928         */ v_xor_b32       v40, v40, v52
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a56752e         */ v_xor_b32       v43, v46, v58
/*2a5a732d         */ v_xor_b32       v45, v45, v57
/*2a58712c         */ v_xor_b32       v44, v44, v56
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a585b2c         */ v_xor_b32       v44, v44, v45
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a56572c         */ v_xor_b32       v43, v44, v43
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a0c552b         */ v_xor_b32       v6, v43, v42
/*2a505328         */ v_xor_b32       v40, v40, v41
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a484928         */ v_xor_b32       v36, v40, v36
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*2a0e4d24         */ v_xor_b32       v7, v36, v38
/*d89a0000 00000620*/ ds_write_b64    v32, v[6:7]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be88017e         */ s_mov_b64       s[8:9], exec
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf88000c         */ s_cbranch_execz .L20264_0
/*d8ee0302 08000003*/ ds_read2_b64    v[8:11], v3 offset0:2 offset1:3
/*d8ee0100 5a000003*/ ds_read2_b64    v[90:93], v3 offset1:1
/*bf8c017f         */ s_waitcnt       lgkmcnt(0)
/*7e9a0309         */ v_mov_b32       v77, v9
/*7e9c030b         */ v_mov_b32       v78, v11
/*7e36030a         */ v_mov_b32       v27, v10
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7ed0035d         */ v_mov_b32       v104, v93
/*7ece035c         */ v_mov_b32       v103, v92
/*7eae035a         */ v_mov_b32       v87, v90
.L20264_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8a0000         */ s_barrier
/*d0c50002 00010305*/ v_cmp_lg_i32    s[2:3], v5, 1
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf880008         */ s_cbranch_execz .L20320_0
/*d89c0100 00466b03*/ ds_write2_b64   v3, v[107:108], v[70:71] offset1:1
/*d89c0302 00555103*/ ds_write2_b64   v3, v[81:82], v[85:86] offset0:2 offset1:3
/*d89c0504 00485303*/ ds_write2_b64   v3, v[83:84], v[72:73] offset0:4 offset1:5
/*d89c0706 004f4a03*/ ds_write2_b64   v3, v[74:75], v[79:80] offset0:6 offset1:7
.L20320_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be8800ff 01000193*/ s_mov_b32       s8, 0x1000193
/*d0c5000a 00024280*/ v_cmp_lg_i32    s[10:11], 0, v33
/*d1000024 002a3d23*/ v_cndmask_b32   v36, v35, v30, s[10:11]
/*d2860024 00023924*/ v_mul_hi_u32    v36, v36, v28
/*344c491c         */ v_sub_u32       v38, vcc, v28, v36
/*3248491c         */ v_add_u32       v36, vcc, v28, v36
/*d1000024 002a4d24*/ v_cndmask_b32   v36, v36, v38, s[10:11]
/*d0c5000a 00000280*/ v_cmp_lg_i32    s[10:11], 0, s1
/*7e4c0207         */ v_mov_b32       v38, s7
/*7e4e02ff 01000193*/ v_mov_b32       v39, 0x1000193
/*d8ee0302 2800001f*/ ds_read2_b64    v[40:43], v31 offset0:2 offset1:3
/*d8ee0100 2c00001f*/ ds_read2_b64    v[44:47], v31 offset1:1
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf800000         */ /*s_nop           0x0*/
/*d285002d 0000112d*/ v_mul_lo_u32    v45, v45, s8
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850030 00024f2c*/ v_mul_lo_u32    v48, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0000 31000003*/ ds_read_b32     v49, v3
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2850034 00001131*/ v_mul_lo_u32    v52, v49, s8
/*2a585934         */ v_xor_b32       v44, v52, v44
/*d2860034 00025924*/ v_mul_hi_u32    v52, v36, v44
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a692c         */ v_sub_u32       v53, vcc, v44, v52
/*d0ce000c 0002692c*/ v_cmp_ge_u32    s[12:13], v44, v52
/*36586a01         */ v_subrev_u32    v44, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a0c         */ s_and_b64       vcc, s[12:13], vcc
/*00585935         */ v_cndmask_b32   v44, v53, v44, vcc
/*32685801         */ v_add_u32       v52, vcc, s1, v44
/*d100002c 00325934*/ v_cndmask_b32   v44, v52, v44, s[12:13]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a586281         */ v_xor_b32       v44, 1, v49
/*d285002c 0000112c*/ v_mul_lo_u32    v44, v44, s8
/*2a686287         */ v_xor_b32       v52, 7, v49
/*2a6a6286         */ v_xor_b32       v53, 6, v49
/*2a6c6285         */ v_xor_b32       v54, 5, v49
/*2a6e6284         */ v_xor_b32       v55, 4, v49
/*2a706283         */ v_xor_b32       v56, 3, v49
/*2a726282         */ v_xor_b32       v57, 2, v49
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a06 0001213a*/ v_add_u32       v6, vcc, v58, 16
/*d11c6a07 01a9013b*/ v_addc_u32      v7, vcc, v59, 0, vcc
/*dc5c0000 3e00003a*/ flat_load_dwordx4 v[62:65], v[58:59] slc glc
/*dc5c0000 3a000006*/ flat_load_dwordx4 v[58:61], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a58592d         */ v_xor_b32       v44, v45, v44
/*d286003f 00025924*/ v_mul_hi_u32    v63, v36, v44
/*d285003f 0000033f*/ v_mul_lo_u32    v63, v63, s1
/*34847f2c         */ v_sub_u32       v66, vcc, v44, v63
/*d0ce0008 00027f2c*/ v_cmp_ge_u32    s[8:9], v44, v63
/*36588401         */ v_subrev_u32    v44, vcc, s1, v66
/*7d968401         */ v_cmp_le_u32    vcc, s1, v66
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00585942         */ v_cndmask_b32   v44, v66, v44, vcc
/*327e5801         */ v_add_u32       v63, vcc, s1, v44
/*d100002c 0022593f*/ v_cndmask_b32   v44, v63, v44, s[8:9]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a587d30         */ v_xor_b32       v44, v48, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*bf800000         */ /*s_nop           0x0*/
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a60732e         */ v_xor_b32       v48, v46, v57
/*d2860039 00026124*/ v_mul_hi_u32    v57, v36, v48
/*d2850039 00000339*/ v_mul_lo_u32    v57, v57, s1
/*34747330         */ v_sub_u32       v58, vcc, v48, v57
/*d0ce0008 00027330*/ v_cmp_ge_u32    s[8:9], v48, v57
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32726001         */ v_add_u32       v57, vcc, s1, v48
/*d1000030 00226139*/ v_cndmask_b32   v48, v57, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000025*/ ds_read_b32     v57, v37 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38727526         */ v_addc_u32      v57, vcc, v38, v58, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90139*/ v_addc_u32      v63, vcc, v57, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a60712f         */ v_xor_b32       v48, v47, v56
/*d2860038 00026124*/ v_mul_hi_u32    v56, v36, v48
/*d2850038 00000338*/ v_mul_lo_u32    v56, v56, s1
/*34727130         */ v_sub_u32       v57, vcc, v48, v56
/*d0ce0008 00027130*/ v_cmp_ge_u32    s[8:9], v48, v56
/*36607201         */ v_subrev_u32    v48, vcc, s1, v57
/*7d967201         */ v_cmp_le_u32    vcc, s1, v57
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606139         */ v_cndmask_b32   v48, v57, v48, vcc
/*32706001         */ v_add_u32       v56, vcc, s1, v48
/*d1000030 00226138*/ v_cndmask_b32   v48, v56, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38707326         */ v_addc_u32      v56, vcc, v38, v57, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90138*/ v_addc_u32      v62, vcc, v56, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a606f28         */ v_xor_b32       v48, v40, v55
/*d2860037 00026124*/ v_mul_hi_u32    v55, v36, v48
/*d2850037 00000337*/ v_mul_lo_u32    v55, v55, s1
/*34706f30         */ v_sub_u32       v56, vcc, v48, v55
/*d0ce0008 00026f30*/ v_cmp_ge_u32    s[8:9], v48, v55
/*36607001         */ v_subrev_u32    v48, vcc, s1, v56
/*7d967001         */ v_cmp_le_u32    vcc, s1, v56
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606138         */ v_cndmask_b32   v48, v56, v48, vcc
/*326e6001         */ v_add_u32       v55, vcc, s1, v48
/*d1000030 00226137*/ v_cndmask_b32   v48, v55, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 37000025*/ ds_read_b32     v55, v37 offset:3072
/*7e700280         */ v_mov_b32       v56, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0037 00026e87*/ v_lshlrev_b64   v[55:56], 7, v[55:56]
/*32606e06         */ v_add_u32       v48, vcc, s6, v55
/*386e7126         */ v_addc_u32      v55, vcc, v38, v56, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90137*/ v_addc_u32      v61, vcc, v55, 0, vcc
/*d1196a38 0001213c*/ v_add_u32       v56, vcc, v60, 16
/*d11c6a39 01a9013d*/ v_addc_u32      v57, vcc, v61, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a606d29         */ v_xor_b32       v48, v41, v54
/*d2860036 00026124*/ v_mul_hi_u32    v54, v36, v48
/*d2850036 00000336*/ v_mul_lo_u32    v54, v54, s1
/*346e6d30         */ v_sub_u32       v55, vcc, v48, v54
/*d0ce0008 00026d30*/ v_cmp_ge_u32    s[8:9], v48, v54
/*36606e01         */ v_subrev_u32    v48, vcc, s1, v55
/*7d966e01         */ v_cmp_le_u32    vcc, s1, v55
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606137         */ v_cndmask_b32   v48, v55, v48, vcc
/*326c6001         */ v_add_u32       v54, vcc, s1, v48
/*d1000030 00226136*/ v_cndmask_b32   v48, v54, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 36000025*/ ds_read_b32     v54, v37 offset:3072
/*7e6e0280         */ v_mov_b32       v55, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0036 00026c87*/ v_lshlrev_b64   v[54:55], 7, v[54:55]
/*32606c06         */ v_add_u32       v48, vcc, s6, v54
/*386c6f26         */ v_addc_u32      v54, vcc, v38, v55, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90136*/ v_addc_u32      v7, vcc, v54, 0, vcc
/*d1196a37 00012106*/ v_add_u32       v55, vcc, v6, 16
/*d11c6a38 01a90107*/ v_addc_u32      v56, vcc, v7, 0, vcc
/*2a726288         */ v_xor_b32       v57, 8, v49
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606b2a         */ v_xor_b32       v48, v42, v53
/*d2860035 00026124*/ v_mul_hi_u32    v53, v36, v48
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b30         */ v_sub_u32       v54, vcc, v48, v53
/*d0ce0008 00026b30*/ v_cmp_ge_u32    s[8:9], v48, v53
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*326a6001         */ v_add_u32       v53, vcc, s1, v48
/*d1000030 00226135*/ v_cndmask_b32   v48, v53, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6a6289         */ v_xor_b32       v53, 9, v49
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*2a6c628f         */ v_xor_b32       v54, 15, v49
/*2a6e628e         */ v_xor_b32       v55, 14, v49
/*2a70628d         */ v_xor_b32       v56, 13, v49
/*2a72628c         */ v_xor_b32       v57, 12, v49
/*2a74628b         */ v_xor_b32       v58, 11, v49
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e628a         */ v_xor_b32       v63, 10, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a68692b         */ v_xor_b32       v52, v43, v52
/*d2860043 00026924*/ v_mul_hi_u32    v67, v36, v52
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888734         */ v_sub_u32       v68, vcc, v52, v67
/*d0ce0008 00028734*/ v_cmp_ge_u32    s[8:9], v52, v67
/*36688801         */ v_subrev_u32    v52, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00686944         */ v_cndmask_b32   v52, v68, v52, vcc
/*32866801         */ v_add_u32       v67, vcc, s1, v52
/*d1000034 00226943*/ v_cndmask_b32   v52, v67, v52, s[8:9]
/*d1000034 002a68c1*/ v_cndmask_b32   v52, -1, v52, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003415*/ ds_write_b32    v21, v52 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850034 00024f3f*/ v_mul_lo_u32    v52, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a606b2d         */ v_xor_b32       v48, v45, v53
/*d2860035 00026124*/ v_mul_hi_u32    v53, v36, v48
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*34766b30         */ v_sub_u32       v59, vcc, v48, v53
/*d0ce0008 00026b30*/ v_cmp_ge_u32    s[8:9], v48, v53
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*326a6001         */ v_add_u32       v53, vcc, s1, v48
/*d1000030 00226135*/ v_cndmask_b32   v48, v53, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*386a7926         */ v_addc_u32      v53, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90135*/ v_addc_u32      v62, vcc, v53, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a60692e         */ v_xor_b32       v48, v46, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a726290         */ v_xor_b32       v57, 16, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a686291         */ v_xor_b32       v52, 17, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a6297         */ v_xor_b32       v53, 23, v49
/*2a6e6296         */ v_xor_b32       v55, 22, v49
/*2a706295         */ v_xor_b32       v56, 21, v49
/*2a726294         */ v_xor_b32       v57, 20, v49
/*2a746293         */ v_xor_b32       v58, 19, v49
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e6292         */ v_xor_b32       v63, 18, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000032*/ ds_read_b32     v57, v50 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000032*/ ds_read_b32     v56, v50 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a726298         */ v_xor_b32       v57, 24, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a686299         */ v_xor_b32       v52, 25, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c629f         */ v_xor_b32       v54, 31, v49
/*2a6e629e         */ v_xor_b32       v55, 30, v49
/*2a70629d         */ v_xor_b32       v56, 29, v49
/*2a72629c         */ v_xor_b32       v57, 28, v49
/*2a74629b         */ v_xor_b32       v58, 27, v49
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e629a         */ v_xor_b32       v63, 26, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262a0         */ v_xor_b32       v57, 32, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a1         */ v_xor_b32       v52, 33, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62a7         */ v_xor_b32       v53, 39, v49
/*2a6e62a6         */ v_xor_b32       v55, 38, v49
/*2a7062a5         */ v_xor_b32       v56, 37, v49
/*2a7262a4         */ v_xor_b32       v57, 36, v49
/*2a7462a3         */ v_xor_b32       v58, 35, v49
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62a2         */ v_xor_b32       v63, 34, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000025*/ ds_read_b32     v57, v37 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262a8         */ v_xor_b32       v57, 40, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a9         */ v_xor_b32       v52, 41, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62af         */ v_xor_b32       v54, 47, v49
/*2a6e62ae         */ v_xor_b32       v55, 46, v49
/*2a7062ad         */ v_xor_b32       v56, 45, v49
/*2a7262ac         */ v_xor_b32       v57, 44, v49
/*2a7462ab         */ v_xor_b32       v58, 43, v49
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62aa         */ v_xor_b32       v63, 42, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262b0         */ v_xor_b32       v57, 48, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b1         */ v_xor_b32       v52, 49, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62b7         */ v_xor_b32       v53, 55, v49
/*2a6e62b6         */ v_xor_b32       v55, 54, v49
/*2a7062b5         */ v_xor_b32       v56, 53, v49
/*2a7262b4         */ v_xor_b32       v57, 52, v49
/*2a7462b3         */ v_xor_b32       v58, 51, v49
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62b2         */ v_xor_b32       v63, 50, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000032*/ ds_read_b32     v57, v50 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000032*/ ds_read_b32     v56, v50 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262b8         */ v_xor_b32       v57, 56, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b9         */ v_xor_b32       v52, 57, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62bf         */ v_xor_b32       v54, 63, v49
/*2a6e62be         */ v_xor_b32       v55, 62, v49
/*2a7062bd         */ v_xor_b32       v56, 61, v49
/*2a7262bc         */ v_xor_b32       v57, 60, v49
/*2a7462bb         */ v_xor_b32       v58, 59, v49
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a6262ba         */ v_xor_b32       v49, 58, v49
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d286003b 00026b24*/ v_mul_hi_u32    v59, v36, v53
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787735         */ v_sub_u32       v60, vcc, v53, v59
/*d0ce0008 00027735*/ v_cmp_ge_u32    s[8:9], v53, v59
/*366a7801         */ v_subrev_u32    v53, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b3c         */ v_cndmask_b32   v53, v60, v53, vcc
/*32766a01         */ v_add_u32       v59, vcc, s1, v53
/*d1000035 00226b3b*/ v_cndmask_b32   v53, v59, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850031 00024f31*/ v_mul_lo_u32    v49, v49, v39
/*d2850035 00024f3a*/ v_mul_lo_u32    v53, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a3c 0001213a*/ v_add_u32       v60, vcc, v58, 16
/*d11c6a3d 01a9013b*/ v_addc_u32      v61, vcc, v59, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567f2b         */ v_xor_b32       v43, v43, v63
/*2a547d2a         */ v_xor_b32       v42, v42, v62
/*2a527b29         */ v_xor_b32       v41, v41, v61
/*2a507928         */ v_xor_b32       v40, v40, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e872f         */ v_xor_b32       v47, v47, v67
/*2a5c852e         */ v_xor_b32       v46, v46, v66
/*2a5a832d         */ v_xor_b32       v45, v45, v65
/*2a58812c         */ v_xor_b32       v44, v44, v64
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003a 00026124*/ v_mul_hi_u32    v58, v36, v48
/*d285003a 0000033a*/ v_mul_lo_u32    v58, v58, s1
/*34767530         */ v_sub_u32       v59, vcc, v48, v58
/*d0ce0008 00027530*/ v_cmp_ge_u32    s[8:9], v48, v58
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32746001         */ v_add_u32       v58, vcc, s1, v48
/*d1000030 0022613a*/ v_cndmask_b32   v48, v58, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34746930         */ v_sub_u32       v58, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90134*/ v_addc_u32      v61, vcc, v52, 0, vcc
/*d1196a3a 0001213c*/ v_add_u32       v58, vcc, v60, 16
/*d11c6a3b 01a9013d*/ v_addc_u32      v59, vcc, v61, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a60632e         */ v_xor_b32       v48, v46, v49
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a3a 00012130*/ v_add_u32       v58, vcc, v48, 16
/*d11c6a3b 01a90131*/ v_addc_u32      v59, vcc, v49, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a606b2f         */ v_xor_b32       v48, v47, v53
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 3a000034*/ flat_load_dwordx4 v[58:61], v[52:53] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 39000034*/ flat_load_dwordx4 v[57:60], v[52:53] slc glc
/*dc5c0000 3d000030*/ flat_load_dwordx4 v[61:64], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 38000034*/ flat_load_dwordx4 v[56:59], v[52:53] slc glc
/*dc5c0000 3c000030*/ flat_load_dwordx4 v[60:63], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 37000034*/ flat_load_dwordx4 v[55:58], v[52:53] slc glc
/*dc5c0000 3b000030*/ flat_load_dwordx4 v[59:62], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56752b         */ v_xor_b32       v43, v43, v58
/*2a606d2b         */ v_xor_b32       v48, v43, v54
/*d2860024 00026124*/ v_mul_hi_u32    v36, v36, v48
/*d2850024 00000324*/ v_mul_lo_u32    v36, v36, s1
/*34624930         */ v_sub_u32       v49, vcc, v48, v36
/*d0ce0008 00024930*/ v_cmp_ge_u32    s[8:9], v48, v36
/*36486201         */ v_subrev_u32    v36, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00484931         */ v_cndmask_b32   v36, v49, v36, vcc
/*32604801         */ v_add_u32       v48, vcc, s1, v36
/*d1000024 00224930*/ v_cndmask_b32   v36, v48, v36, s[8:9]
/*d1000024 002a48c1*/ v_cndmask_b32   v36, -1, v36, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002415*/ ds_write_b32    v21, v36 offset:3072
/*2a48732a         */ v_xor_b32       v36, v42, v57
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a547d2f         */ v_xor_b32       v42, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 2f000000*/ ds_read_b32     v47, v0 offset:3072
/*7e600280         */ v_mov_b32       v48, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002f 00025e87*/ v_lshlrev_b64   v[47:48], 7, v[47:48]
/*325e5e06         */ v_add_u32       v47, vcc, s6, v47
/*384c6126         */ v_addc_u32      v38, vcc, v38, v48, vcc
/*320c352f         */ v_add_u32       v6, vcc, v47, v26
/*d11c6a07 01a90126*/ v_addc_u32      v7, vcc, v38, 0, vcc
/*d1196a30 00012106*/ v_add_u32       v48, vcc, v6, 16
/*d11c6a31 01a90107*/ v_addc_u32      v49, vcc, v7, 0, vcc
/*dc5c0000 34000030*/ flat_load_dwordx4 v[52:55], v[48:49] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4c6f2b         */ v_xor_b32       v38, v43, v55
/*2a486d24         */ v_xor_b32       v36, v36, v54
/*2a526b29         */ v_xor_b32       v41, v41, v53
/*2a506928         */ v_xor_b32       v40, v40, v52
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a56752e         */ v_xor_b32       v43, v46, v58
/*2a5a732d         */ v_xor_b32       v45, v45, v57
/*2a58712c         */ v_xor_b32       v44, v44, v56
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a585b2c         */ v_xor_b32       v44, v44, v45
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a56572c         */ v_xor_b32       v43, v44, v43
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a0c552b         */ v_xor_b32       v6, v43, v42
/*2a505328         */ v_xor_b32       v40, v40, v41
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a484928         */ v_xor_b32       v36, v40, v36
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*2a0e4d24         */ v_xor_b32       v7, v36, v38
/*d89a0000 00000620*/ ds_write_b64    v32, v[6:7]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be88017e         */ s_mov_b64       s[8:9], exec
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf88000b         */ s_cbranch_execz .L37732_0
/*d8ee0302 08000003*/ ds_read2_b64    v[8:11], v3 offset0:2 offset1:3
/*d8ee0100 65000003*/ ds_read2_b64    v[101:104], v3 offset1:1
/*bf8c017f         */ s_waitcnt       lgkmcnt(0)
/*7e9a0309         */ v_mov_b32       v77, v9
/*7e9c030b         */ v_mov_b32       v78, v11
/*7e36030a         */ v_mov_b32       v27, v10
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7eb60366         */ v_mov_b32       v91, v102
/*7eae0365         */ v_mov_b32       v87, v101
.L37732_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8a0000         */ s_barrier
/*d0c50002 00010505*/ v_cmp_lg_i32    s[2:3], v5, 2
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf880008         */ s_cbranch_execz .L37788_0
/*d89c0100 00466b03*/ ds_write2_b64   v3, v[107:108], v[70:71] offset1:1
/*d89c0302 00555103*/ ds_write2_b64   v3, v[81:82], v[85:86] offset0:2 offset1:3
/*d89c0504 00485303*/ ds_write2_b64   v3, v[83:84], v[72:73] offset0:4 offset1:5
/*d89c0706 004f4a03*/ ds_write2_b64   v3, v[74:75], v[79:80] offset0:6 offset1:7
.L37788_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be8800ff 01000193*/ s_mov_b32       s8, 0x1000193
/*d0c5000a 00024280*/ v_cmp_lg_i32    s[10:11], 0, v33
/*d1000024 002a3d23*/ v_cndmask_b32   v36, v35, v30, s[10:11]
/*d2860024 00023924*/ v_mul_hi_u32    v36, v36, v28
/*344c491c         */ v_sub_u32       v38, vcc, v28, v36
/*3248491c         */ v_add_u32       v36, vcc, v28, v36
/*d1000024 002a4d24*/ v_cndmask_b32   v36, v36, v38, s[10:11]
/*d0c5000a 00000280*/ v_cmp_lg_i32    s[10:11], 0, s1
/*7e4c0207         */ v_mov_b32       v38, s7
/*7e4e02ff 01000193*/ v_mov_b32       v39, 0x1000193
/*d8ee0302 2800001f*/ ds_read2_b64    v[40:43], v31 offset0:2 offset1:3
/*d8ee0100 2c00001f*/ ds_read2_b64    v[44:47], v31 offset1:1
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d285002d 0000112d*/ v_mul_lo_u32    v45, v45, s8
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850030 00024f2c*/ v_mul_lo_u32    v48, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0000 31000003*/ ds_read_b32     v49, v3
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d2850034 00001131*/ v_mul_lo_u32    v52, v49, s8
/*2a585934         */ v_xor_b32       v44, v52, v44
/*d2860034 00025924*/ v_mul_hi_u32    v52, v36, v44
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a692c         */ v_sub_u32       v53, vcc, v44, v52
/*d0ce000c 0002692c*/ v_cmp_ge_u32    s[12:13], v44, v52
/*36586a01         */ v_subrev_u32    v44, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a0c         */ s_and_b64       vcc, s[12:13], vcc
/*00585935         */ v_cndmask_b32   v44, v53, v44, vcc
/*32685801         */ v_add_u32       v52, vcc, s1, v44
/*d100002c 00325934*/ v_cndmask_b32   v44, v52, v44, s[12:13]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a586281         */ v_xor_b32       v44, 1, v49
/*d285002c 0000112c*/ v_mul_lo_u32    v44, v44, s8
/*2a686287         */ v_xor_b32       v52, 7, v49
/*2a6a6286         */ v_xor_b32       v53, 6, v49
/*2a6c6285         */ v_xor_b32       v54, 5, v49
/*2a6e6284         */ v_xor_b32       v55, 4, v49
/*2a706283         */ v_xor_b32       v56, 3, v49
/*2a726282         */ v_xor_b32       v57, 2, v49
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a06 0001213a*/ v_add_u32       v6, vcc, v58, 16
/*d11c6a07 01a9013b*/ v_addc_u32      v7, vcc, v59, 0, vcc
/*dc5c0000 3e00003a*/ flat_load_dwordx4 v[62:65], v[58:59] slc glc
/*dc5c0000 3a000006*/ flat_load_dwordx4 v[58:61], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a58592d         */ v_xor_b32       v44, v45, v44
/*d286003f 00025924*/ v_mul_hi_u32    v63, v36, v44
/*d285003f 0000033f*/ v_mul_lo_u32    v63, v63, s1
/*34847f2c         */ v_sub_u32       v66, vcc, v44, v63
/*d0ce0008 00027f2c*/ v_cmp_ge_u32    s[8:9], v44, v63
/*36588401         */ v_subrev_u32    v44, vcc, s1, v66
/*7d968401         */ v_cmp_le_u32    vcc, s1, v66
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00585942         */ v_cndmask_b32   v44, v66, v44, vcc
/*327e5801         */ v_add_u32       v63, vcc, s1, v44
/*d100002c 0022593f*/ v_cndmask_b32   v44, v63, v44, s[8:9]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a587d30         */ v_xor_b32       v44, v48, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*bf800000         */ /*s_nop           0x0*/
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a60732e         */ v_xor_b32       v48, v46, v57
/*d2860039 00026124*/ v_mul_hi_u32    v57, v36, v48
/*d2850039 00000339*/ v_mul_lo_u32    v57, v57, s1
/*34747330         */ v_sub_u32       v58, vcc, v48, v57
/*d0ce0008 00027330*/ v_cmp_ge_u32    s[8:9], v48, v57
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32726001         */ v_add_u32       v57, vcc, s1, v48
/*d1000030 00226139*/ v_cndmask_b32   v48, v57, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000025*/ ds_read_b32     v57, v37 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38727526         */ v_addc_u32      v57, vcc, v38, v58, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90139*/ v_addc_u32      v63, vcc, v57, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a60712f         */ v_xor_b32       v48, v47, v56
/*d2860038 00026124*/ v_mul_hi_u32    v56, v36, v48
/*d2850038 00000338*/ v_mul_lo_u32    v56, v56, s1
/*34727130         */ v_sub_u32       v57, vcc, v48, v56
/*d0ce0008 00027130*/ v_cmp_ge_u32    s[8:9], v48, v56
/*36607201         */ v_subrev_u32    v48, vcc, s1, v57
/*7d967201         */ v_cmp_le_u32    vcc, s1, v57
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606139         */ v_cndmask_b32   v48, v57, v48, vcc
/*32706001         */ v_add_u32       v56, vcc, s1, v48
/*d1000030 00226138*/ v_cndmask_b32   v48, v56, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38707326         */ v_addc_u32      v56, vcc, v38, v57, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90138*/ v_addc_u32      v62, vcc, v56, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a606f28         */ v_xor_b32       v48, v40, v55
/*d2860037 00026124*/ v_mul_hi_u32    v55, v36, v48
/*d2850037 00000337*/ v_mul_lo_u32    v55, v55, s1
/*34706f30         */ v_sub_u32       v56, vcc, v48, v55
/*d0ce0008 00026f30*/ v_cmp_ge_u32    s[8:9], v48, v55
/*36607001         */ v_subrev_u32    v48, vcc, s1, v56
/*7d967001         */ v_cmp_le_u32    vcc, s1, v56
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606138         */ v_cndmask_b32   v48, v56, v48, vcc
/*326e6001         */ v_add_u32       v55, vcc, s1, v48
/*d1000030 00226137*/ v_cndmask_b32   v48, v55, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 37000025*/ ds_read_b32     v55, v37 offset:3072
/*7e700280         */ v_mov_b32       v56, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0037 00026e87*/ v_lshlrev_b64   v[55:56], 7, v[55:56]
/*32606e06         */ v_add_u32       v48, vcc, s6, v55
/*386e7126         */ v_addc_u32      v55, vcc, v38, v56, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90137*/ v_addc_u32      v61, vcc, v55, 0, vcc
/*d1196a38 0001213c*/ v_add_u32       v56, vcc, v60, 16
/*d11c6a39 01a9013d*/ v_addc_u32      v57, vcc, v61, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a606d29         */ v_xor_b32       v48, v41, v54
/*d2860036 00026124*/ v_mul_hi_u32    v54, v36, v48
/*d2850036 00000336*/ v_mul_lo_u32    v54, v54, s1
/*346e6d30         */ v_sub_u32       v55, vcc, v48, v54
/*d0ce0008 00026d30*/ v_cmp_ge_u32    s[8:9], v48, v54
/*36606e01         */ v_subrev_u32    v48, vcc, s1, v55
/*7d966e01         */ v_cmp_le_u32    vcc, s1, v55
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606137         */ v_cndmask_b32   v48, v55, v48, vcc
/*326c6001         */ v_add_u32       v54, vcc, s1, v48
/*d1000030 00226136*/ v_cndmask_b32   v48, v54, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 36000025*/ ds_read_b32     v54, v37 offset:3072
/*7e6e0280         */ v_mov_b32       v55, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0036 00026c87*/ v_lshlrev_b64   v[54:55], 7, v[54:55]
/*32606c06         */ v_add_u32       v48, vcc, s6, v54
/*386c6f26         */ v_addc_u32      v54, vcc, v38, v55, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90136*/ v_addc_u32      v7, vcc, v54, 0, vcc
/*d1196a37 00012106*/ v_add_u32       v55, vcc, v6, 16
/*d11c6a38 01a90107*/ v_addc_u32      v56, vcc, v7, 0, vcc
/*2a726288         */ v_xor_b32       v57, 8, v49
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606b2a         */ v_xor_b32       v48, v42, v53
/*d2860035 00026124*/ v_mul_hi_u32    v53, v36, v48
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b30         */ v_sub_u32       v54, vcc, v48, v53
/*d0ce0008 00026b30*/ v_cmp_ge_u32    s[8:9], v48, v53
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*326a6001         */ v_add_u32       v53, vcc, s1, v48
/*d1000030 00226135*/ v_cndmask_b32   v48, v53, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6a6289         */ v_xor_b32       v53, 9, v49
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*2a6c628f         */ v_xor_b32       v54, 15, v49
/*2a6e628e         */ v_xor_b32       v55, 14, v49
/*2a70628d         */ v_xor_b32       v56, 13, v49
/*2a72628c         */ v_xor_b32       v57, 12, v49
/*2a74628b         */ v_xor_b32       v58, 11, v49
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e628a         */ v_xor_b32       v63, 10, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a68692b         */ v_xor_b32       v52, v43, v52
/*d2860043 00026924*/ v_mul_hi_u32    v67, v36, v52
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888734         */ v_sub_u32       v68, vcc, v52, v67
/*d0ce0008 00028734*/ v_cmp_ge_u32    s[8:9], v52, v67
/*36688801         */ v_subrev_u32    v52, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00686944         */ v_cndmask_b32   v52, v68, v52, vcc
/*32866801         */ v_add_u32       v67, vcc, s1, v52
/*d1000034 00226943*/ v_cndmask_b32   v52, v67, v52, s[8:9]
/*d1000034 002a68c1*/ v_cndmask_b32   v52, -1, v52, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003415*/ ds_write_b32    v21, v52 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850034 00024f3f*/ v_mul_lo_u32    v52, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a606b2d         */ v_xor_b32       v48, v45, v53
/*d2860035 00026124*/ v_mul_hi_u32    v53, v36, v48
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*34766b30         */ v_sub_u32       v59, vcc, v48, v53
/*d0ce0008 00026b30*/ v_cmp_ge_u32    s[8:9], v48, v53
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*326a6001         */ v_add_u32       v53, vcc, s1, v48
/*d1000030 00226135*/ v_cndmask_b32   v48, v53, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*386a7926         */ v_addc_u32      v53, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90135*/ v_addc_u32      v62, vcc, v53, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a60692e         */ v_xor_b32       v48, v46, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a726290         */ v_xor_b32       v57, 16, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a686291         */ v_xor_b32       v52, 17, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a6297         */ v_xor_b32       v53, 23, v49
/*2a6e6296         */ v_xor_b32       v55, 22, v49
/*2a706295         */ v_xor_b32       v56, 21, v49
/*2a726294         */ v_xor_b32       v57, 20, v49
/*2a746293         */ v_xor_b32       v58, 19, v49
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e6292         */ v_xor_b32       v63, 18, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000032*/ ds_read_b32     v57, v50 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000032*/ ds_read_b32     v56, v50 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a726298         */ v_xor_b32       v57, 24, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a686299         */ v_xor_b32       v52, 25, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c629f         */ v_xor_b32       v54, 31, v49
/*2a6e629e         */ v_xor_b32       v55, 30, v49
/*2a70629d         */ v_xor_b32       v56, 29, v49
/*2a72629c         */ v_xor_b32       v57, 28, v49
/*2a74629b         */ v_xor_b32       v58, 27, v49
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e629a         */ v_xor_b32       v63, 26, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000000*/ ds_read_b32     v52, v0 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262a0         */ v_xor_b32       v57, 32, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a1         */ v_xor_b32       v52, 33, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62a7         */ v_xor_b32       v53, 39, v49
/*2a6e62a6         */ v_xor_b32       v55, 38, v49
/*2a7062a5         */ v_xor_b32       v56, 37, v49
/*2a7262a4         */ v_xor_b32       v57, 36, v49
/*2a7462a3         */ v_xor_b32       v58, 35, v49
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62a2         */ v_xor_b32       v63, 34, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000000*/ ds_read_b32     v59, v0 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000025*/ ds_read_b32     v58, v37 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000025*/ ds_read_b32     v57, v37 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000025*/ ds_read_b32     v56, v37 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262a8         */ v_xor_b32       v57, 40, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862a9         */ v_xor_b32       v52, 41, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62af         */ v_xor_b32       v54, 47, v49
/*2a6e62ae         */ v_xor_b32       v55, 46, v49
/*2a7062ad         */ v_xor_b32       v56, 45, v49
/*2a7262ac         */ v_xor_b32       v57, 44, v49
/*2a7462ab         */ v_xor_b32       v58, 43, v49
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62aa         */ v_xor_b32       v63, 42, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d2860043 00026b24*/ v_mul_hi_u32    v67, v36, v53
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888735         */ v_sub_u32       v68, vcc, v53, v67
/*d0ce0008 00028735*/ v_cmp_ge_u32    s[8:9], v53, v67
/*366a8801         */ v_subrev_u32    v53, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b44         */ v_cndmask_b32   v53, v68, v53, vcc
/*32866a01         */ v_add_u32       v67, vcc, s1, v53
/*d1000035 00226b43*/ v_cndmask_b32   v53, v67, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850035 00024f3f*/ v_mul_lo_u32    v53, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3b000025*/ ds_read_b32     v59, v37 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606b2e         */ v_xor_b32       v48, v46, v53
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3b 00012106*/ v_add_u32       v59, vcc, v6, 16
/*d11c6a3c 01a90107*/ v_addc_u32      v60, vcc, v7, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f000006*/ flat_load_dwordx4 v[63:66], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a39 00012106*/ v_add_u32       v57, vcc, v6, 16
/*d11c6a3a 01a90107*/ v_addc_u32      v58, vcc, v7, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d000006*/ flat_load_dwordx4 v[61:64], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32606806         */ v_add_u32       v48, vcc, s6, v52
/*38686b26         */ v_addc_u32      v52, vcc, v38, v53, vcc
/*320c3530         */ v_add_u32       v6, vcc, v48, v26
/*d11c6a07 01a90134*/ v_addc_u32      v7, vcc, v52, 0, vcc
/*d1196a3a 00012106*/ v_add_u32       v58, vcc, v6, 16
/*d11c6a3b 01a90107*/ v_addc_u32      v59, vcc, v7, 0, vcc
/*2a7262b0         */ v_xor_b32       v57, 48, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000006*/ flat_load_dwordx4 v[62:65], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346a6930         */ v_sub_u32       v53, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606a01         */ v_subrev_u32    v48, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606135         */ v_cndmask_b32   v48, v53, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b1         */ v_xor_b32       v52, 49, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6a62b7         */ v_xor_b32       v53, 55, v49
/*2a6e62b6         */ v_xor_b32       v55, 54, v49
/*2a7062b5         */ v_xor_b32       v56, 53, v49
/*2a7262b4         */ v_xor_b32       v57, 52, v49
/*2a7462b3         */ v_xor_b32       v58, 51, v49
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a7e62b2         */ v_xor_b32       v63, 50, v49
/*dc5c0000 4000003d*/ flat_load_dwordx4 v[64:67], v[61:62] slc glc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a6c6d2b         */ v_xor_b32       v54, v43, v54
/*d2860043 00026d24*/ v_mul_hi_u32    v67, v36, v54
/*d2850043 00000343*/ v_mul_lo_u32    v67, v67, s1
/*34888736         */ v_sub_u32       v68, vcc, v54, v67
/*d0ce0008 00028736*/ v_cmp_ge_u32    s[8:9], v54, v67
/*366c8801         */ v_subrev_u32    v54, vcc, s1, v68
/*7d968801         */ v_cmp_le_u32    vcc, s1, v68
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006c6d44         */ v_cndmask_b32   v54, v68, v54, vcc
/*32866c01         */ v_add_u32       v67, vcc, s1, v54
/*d1000036 00226d43*/ v_cndmask_b32   v54, v67, v54, s[8:9]
/*d1000036 002a6cc1*/ v_cndmask_b32   v54, -1, v54, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003615*/ ds_write_b32    v21, v54 offset:3072
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a5e7d2f         */ v_xor_b32       v47, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850036 00024f3f*/ v_mul_lo_u32    v54, v63, v39
/*d285003a 00024f3a*/ v_mul_lo_u32    v58, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850035 00024f35*/ v_mul_lo_u32    v53, v53, v39
/*d86c0c00 3b000033*/ ds_read_b32     v59, v51 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003b 00026124*/ v_mul_hi_u32    v59, v36, v48
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787730         */ v_sub_u32       v60, vcc, v48, v59
/*d0ce0008 00027730*/ v_cmp_ge_u32    s[8:9], v48, v59
/*36607801         */ v_subrev_u32    v48, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613c         */ v_cndmask_b32   v48, v60, v48, vcc
/*32766001         */ v_add_u32       v59, vcc, s1, v48
/*d1000030 0022613b*/ v_cndmask_b32   v48, v59, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38767926         */ v_addc_u32      v59, vcc, v38, v60, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a9013b*/ v_addc_u32      v63, vcc, v59, 0, vcc
/*d1196a3b 0001213e*/ v_add_u32       v59, vcc, v62, 16
/*d11c6a3c 01a9013f*/ v_addc_u32      v60, vcc, v63, 0, vcc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*dc5c0000 4200003b*/ flat_load_dwordx4 v[66:69], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34766930         */ v_sub_u32       v59, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a568b2b         */ v_xor_b32       v43, v43, v69
/*2a54892a         */ v_xor_b32       v42, v42, v68
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a508528         */ v_xor_b32       v40, v40, v66
/*2a528729         */ v_xor_b32       v41, v41, v67
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a3b 0001213d*/ v_add_u32       v59, vcc, v61, 16
/*d11c6a3c 01a9013e*/ v_addc_u32      v60, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*2a606d2e         */ v_xor_b32       v48, v46, v54
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32607606         */ v_add_u32       v48, vcc, s6, v59
/*38687926         */ v_addc_u32      v52, vcc, v38, v60, vcc
/*327e3530         */ v_add_u32       v63, vcc, v48, v26
/*d11c6a40 01a90134*/ v_addc_u32      v64, vcc, v52, 0, vcc
/*d1196a3b 0001213f*/ v_add_u32       v59, vcc, v63, 16
/*d11c6a3c 01a90140*/ v_addc_u32      v60, vcc, v64, 0, vcc
/*dc5c0000 3b00003b*/ flat_load_dwordx4 v[59:62], v[59:60] slc glc
/*dc5c0000 3f00003f*/ flat_load_dwordx4 v[63:66], v[63:64] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e852f         */ v_xor_b32       v47, v47, v66
/*2a60752f         */ v_xor_b32       v48, v47, v58
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c832e         */ v_xor_b32       v46, v46, v65
/*2a567d2b         */ v_xor_b32       v43, v43, v62
/*2a547b2a         */ v_xor_b32       v42, v42, v61
/*2a5a812d         */ v_xor_b32       v45, v45, v64
/*2a587f2c         */ v_xor_b32       v44, v44, v63
/*2a507728         */ v_xor_b32       v40, v40, v59
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 39000032*/ ds_read_b32     v57, v50 offset:3072
/*7e740280         */ v_mov_b32       v58, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0039 00027287*/ v_lshlrev_b64   v[57:58], 7, v[57:58]
/*32607206         */ v_add_u32       v48, vcc, s6, v57
/*38687526         */ v_addc_u32      v52, vcc, v38, v58, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a90134*/ v_addc_u32      v62, vcc, v52, 0, vcc
/*d1196a39 0001213d*/ v_add_u32       v57, vcc, v61, 16
/*d11c6a3a 01a9013e*/ v_addc_u32      v58, vcc, v62, 0, vcc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 38000032*/ ds_read_b32     v56, v50 offset:3072
/*7e720280         */ v_mov_b32       v57, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0038 00027087*/ v_lshlrev_b64   v[56:57], 7, v[56:57]
/*32607006         */ v_add_u32       v48, vcc, s6, v56
/*38687326         */ v_addc_u32      v52, vcc, v38, v57, vcc
/*327c3530         */ v_add_u32       v62, vcc, v48, v26
/*d11c6a3f 01a90134*/ v_addc_u32      v63, vcc, v52, 0, vcc
/*d1196a3a 0001213e*/ v_add_u32       v58, vcc, v62, 16
/*d11c6a3b 01a9013f*/ v_addc_u32      v59, vcc, v63, 0, vcc
/*2a7262b8         */ v_xor_b32       v57, 56, v49
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e00003e*/ flat_load_dwordx4 v[62:65], v[62:63] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*346c6930         */ v_sub_u32       v54, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36606c01         */ v_subrev_u32    v48, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606136         */ v_cndmask_b32   v48, v54, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850030 00024f39*/ v_mul_lo_u32    v48, v57, v39
/*2a6862b9         */ v_xor_b32       v52, 57, v49
/*d2850034 00024f34*/ v_mul_lo_u32    v52, v52, v39
/*2a6c62bf         */ v_xor_b32       v54, 63, v49
/*2a6e62be         */ v_xor_b32       v55, 62, v49
/*2a7062bd         */ v_xor_b32       v56, 61, v49
/*2a7262bc         */ v_xor_b32       v57, 60, v49
/*2a7462bb         */ v_xor_b32       v58, 59, v49
/*d86c0c00 3b000032*/ ds_read_b32     v59, v50 offset:3072
/*7e780280         */ v_mov_b32       v60, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003b 00027687*/ v_lshlrev_b64   v[59:60], 7, v[59:60]
/*32767606         */ v_add_u32       v59, vcc, s6, v59
/*38787926         */ v_addc_u32      v60, vcc, v38, v60, vcc
/*3276353b         */ v_add_u32       v59, vcc, v59, v26
/*d11c6a3c 01a9013c*/ v_addc_u32      v60, vcc, v60, 0, vcc
/*d1196a3d 0001213b*/ v_add_u32       v61, vcc, v59, 16
/*d11c6a3e 01a9013c*/ v_addc_u32      v62, vcc, v60, 0, vcc
/*2a6262ba         */ v_xor_b32       v49, 58, v49
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003b*/ flat_load_dwordx4 v[65:68], v[59:60] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56812b         */ v_xor_b32       v43, v43, v64
/*2a6a6b2b         */ v_xor_b32       v53, v43, v53
/*d286003b 00026b24*/ v_mul_hi_u32    v59, v36, v53
/*d285003b 0000033b*/ v_mul_lo_u32    v59, v59, s1
/*34787735         */ v_sub_u32       v60, vcc, v53, v59
/*d0ce0008 00027735*/ v_cmp_ge_u32    s[8:9], v53, v59
/*366a7801         */ v_subrev_u32    v53, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*006a6b3c         */ v_cndmask_b32   v53, v60, v53, vcc
/*32766a01         */ v_add_u32       v59, vcc, s1, v53
/*d1000035 00226b3b*/ v_cndmask_b32   v53, v59, v53, s[8:9]
/*d1000035 002a6ac1*/ v_cndmask_b32   v53, -1, v53, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003515*/ ds_write_b32    v21, v53 offset:3072
/*2a547f2a         */ v_xor_b32       v42, v42, v63
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a5e892f         */ v_xor_b32       v47, v47, v68
/*2a5c872e         */ v_xor_b32       v46, v46, v67
/*2a5a852d         */ v_xor_b32       v45, v45, v66
/*2a58832c         */ v_xor_b32       v44, v44, v65
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850031 00024f31*/ v_mul_lo_u32    v49, v49, v39
/*d2850035 00024f3a*/ v_mul_lo_u32    v53, v58, v39
/*d2850039 00024f39*/ v_mul_lo_u32    v57, v57, v39
/*d2850038 00024f38*/ v_mul_lo_u32    v56, v56, v39
/*d2850037 00024f37*/ v_mul_lo_u32    v55, v55, v39
/*d2850036 00024f36*/ v_mul_lo_u32    v54, v54, v39
/*d86c0c00 3a000032*/ ds_read_b32     v58, v50 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32747406         */ v_add_u32       v58, vcc, s6, v58
/*38767726         */ v_addc_u32      v59, vcc, v38, v59, vcc
/*3274353a         */ v_add_u32       v58, vcc, v58, v26
/*d11c6a3b 01a9013b*/ v_addc_u32      v59, vcc, v59, 0, vcc
/*d1196a3c 0001213a*/ v_add_u32       v60, vcc, v58, 16
/*d11c6a3d 01a9013b*/ v_addc_u32      v61, vcc, v59, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a567f2b         */ v_xor_b32       v43, v43, v63
/*2a547d2a         */ v_xor_b32       v42, v42, v62
/*2a527b29         */ v_xor_b32       v41, v41, v61
/*2a507928         */ v_xor_b32       v40, v40, v60
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e872f         */ v_xor_b32       v47, v47, v67
/*2a5c852e         */ v_xor_b32       v46, v46, v66
/*2a5a832d         */ v_xor_b32       v45, v45, v65
/*2a58812c         */ v_xor_b32       v44, v44, v64
/*2a605930         */ v_xor_b32       v48, v48, v44
/*d286003a 00026124*/ v_mul_hi_u32    v58, v36, v48
/*d285003a 0000033a*/ v_mul_lo_u32    v58, v58, s1
/*34767530         */ v_sub_u32       v59, vcc, v48, v58
/*d0ce0008 00027530*/ v_cmp_ge_u32    s[8:9], v48, v58
/*36607601         */ v_subrev_u32    v48, vcc, s1, v59
/*7d967601         */ v_cmp_le_u32    vcc, s1, v59
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613b         */ v_cndmask_b32   v48, v59, v48, vcc
/*32746001         */ v_add_u32       v58, vcc, s1, v48
/*d1000030 0022613a*/ v_cndmask_b32   v48, v58, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38747726         */ v_addc_u32      v58, vcc, v38, v59, vcc
/*327a3530         */ v_add_u32       v61, vcc, v48, v26
/*d11c6a3e 01a9013a*/ v_addc_u32      v62, vcc, v58, 0, vcc
/*d1196a3a 0001213d*/ v_add_u32       v58, vcc, v61, 16
/*d11c6a3b 01a9013e*/ v_addc_u32      v59, vcc, v62, 0, vcc
/*dc5c0000 3d00003d*/ flat_load_dwordx4 v[61:64], v[61:62] slc glc
/*dc5c0000 4100003a*/ flat_load_dwordx4 v[65:68], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a60692d         */ v_xor_b32       v48, v45, v52
/*d2860034 00026124*/ v_mul_hi_u32    v52, v36, v48
/*d2850034 00000334*/ v_mul_lo_u32    v52, v52, s1
/*34746930         */ v_sub_u32       v58, vcc, v48, v52
/*d0ce0008 00026930*/ v_cmp_ge_u32    s[8:9], v48, v52
/*36607401         */ v_subrev_u32    v48, vcc, s1, v58
/*7d967401         */ v_cmp_le_u32    vcc, s1, v58
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0060613a         */ v_cndmask_b32   v48, v58, v48, vcc
/*32686001         */ v_add_u32       v52, vcc, s1, v48
/*d1000030 00226134*/ v_cndmask_b32   v48, v52, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56892b         */ v_xor_b32       v43, v43, v68
/*2a54872a         */ v_xor_b32       v42, v42, v67
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*2a508328         */ v_xor_b32       v40, v40, v65
/*2a528529         */ v_xor_b32       v41, v41, v66
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 3a000000*/ ds_read_b32     v58, v0 offset:3072
/*7e760280         */ v_mov_b32       v59, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f003a 00027487*/ v_lshlrev_b64   v[58:59], 7, v[58:59]
/*32607406         */ v_add_u32       v48, vcc, s6, v58
/*38687726         */ v_addc_u32      v52, vcc, v38, v59, vcc
/*32783530         */ v_add_u32       v60, vcc, v48, v26
/*d11c6a3d 01a90134*/ v_addc_u32      v61, vcc, v52, 0, vcc
/*d1196a3a 0001213c*/ v_add_u32       v58, vcc, v60, 16
/*d11c6a3b 01a9013d*/ v_addc_u32      v59, vcc, v61, 0, vcc
/*dc5c0000 3c00003c*/ flat_load_dwordx4 v[60:63], v[60:61] slc glc
/*dc5c0000 4000003a*/ flat_load_dwordx4 v[64:67], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a60632e         */ v_xor_b32       v48, v46, v49
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56872b         */ v_xor_b32       v43, v43, v67
/*2a54852a         */ v_xor_b32       v42, v42, v66
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*2a508128         */ v_xor_b32       v40, v40, v64
/*2a528329         */ v_xor_b32       v41, v41, v65
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a3a 00012130*/ v_add_u32       v58, vcc, v48, 16
/*d11c6a3b 01a90131*/ v_addc_u32      v59, vcc, v49, 0, vcc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*2a606b2f         */ v_xor_b32       v48, v47, v53
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 3a000034*/ flat_load_dwordx4 v[58:61], v[52:53] slc glc
/*dc5c0000 3e000030*/ flat_load_dwordx4 v[62:65], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a607328         */ v_xor_b32       v48, v40, v57
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*2a5c812e         */ v_xor_b32       v46, v46, v64
/*2a567b2b         */ v_xor_b32       v43, v43, v61
/*2a54792a         */ v_xor_b32       v42, v42, v60
/*2a5a7f2d         */ v_xor_b32       v45, v45, v63
/*2a587d2c         */ v_xor_b32       v44, v44, v62
/*2a5e832f         */ v_xor_b32       v47, v47, v65
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 39000034*/ flat_load_dwordx4 v[57:60], v[52:53] slc glc
/*dc5c0000 3d000030*/ flat_load_dwordx4 v[61:64], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527529         */ v_xor_b32       v41, v41, v58
/*2a607129         */ v_xor_b32       v48, v41, v56
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*2a56792b         */ v_xor_b32       v43, v43, v60
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a5a7d2d         */ v_xor_b32       v45, v45, v62
/*2a587b2c         */ v_xor_b32       v44, v44, v61
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a5e812f         */ v_xor_b32       v47, v47, v64
/*2a5c7f2e         */ v_xor_b32       v46, v46, v63
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 38000034*/ flat_load_dwordx4 v[56:59], v[52:53] slc glc
/*dc5c0000 3c000030*/ flat_load_dwordx4 v[60:63], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56772b         */ v_xor_b32       v43, v43, v59
/*2a54752a         */ v_xor_b32       v42, v42, v58
/*2a606f2a         */ v_xor_b32       v48, v42, v55
/*d2860031 00026124*/ v_mul_hi_u32    v49, v36, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34686330         */ v_sub_u32       v52, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606801         */ v_subrev_u32    v48, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606134         */ v_cndmask_b32   v48, v52, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*2a527329         */ v_xor_b32       v41, v41, v57
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a5e7f2f         */ v_xor_b32       v47, v47, v63
/*2a5c7d2e         */ v_xor_b32       v46, v46, v62
/*2a5a7b2d         */ v_xor_b32       v45, v45, v61
/*2a58792c         */ v_xor_b32       v44, v44, v60
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002f 00024f2f*/ v_mul_lo_u32    v47, v47, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d86c0c00 30000000*/ ds_read_b32     v48, v0 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32606006         */ v_add_u32       v48, vcc, s6, v48
/*38626326         */ v_addc_u32      v49, vcc, v38, v49, vcc
/*32603530         */ v_add_u32       v48, vcc, v48, v26
/*d11c6a31 01a90131*/ v_addc_u32      v49, vcc, v49, 0, vcc
/*d1196a34 00012130*/ v_add_u32       v52, vcc, v48, 16
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*dc5c0000 37000034*/ flat_load_dwordx4 v[55:58], v[52:53] slc glc
/*dc5c0000 3b000030*/ flat_load_dwordx4 v[59:62], v[48:49] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a56752b         */ v_xor_b32       v43, v43, v58
/*2a606d2b         */ v_xor_b32       v48, v43, v54
/*d2860024 00026124*/ v_mul_hi_u32    v36, v36, v48
/*d2850024 00000324*/ v_mul_lo_u32    v36, v36, s1
/*34624930         */ v_sub_u32       v49, vcc, v48, v36
/*d0ce0008 00024930*/ v_cmp_ge_u32    s[8:9], v48, v36
/*36486201         */ v_subrev_u32    v36, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00484931         */ v_cndmask_b32   v36, v49, v36, vcc
/*32604801         */ v_add_u32       v48, vcc, s1, v36
/*d1000024 00224930*/ v_cndmask_b32   v36, v48, v36, s[8:9]
/*d1000024 002a48c1*/ v_cndmask_b32   v36, -1, v36, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002415*/ ds_write_b32    v21, v36 offset:3072
/*2a48732a         */ v_xor_b32       v36, v42, v57
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a547d2f         */ v_xor_b32       v42, v47, v62
/*2a5c7b2e         */ v_xor_b32       v46, v46, v61
/*2a5a792d         */ v_xor_b32       v45, v45, v60
/*2a58772c         */ v_xor_b32       v44, v44, v59
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*d285002d 00024f2d*/ v_mul_lo_u32    v45, v45, v39
/*d285002e 00024f2e*/ v_mul_lo_u32    v46, v46, v39
/*d285002a 00024f2a*/ v_mul_lo_u32    v42, v42, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*d2850029 00024f29*/ v_mul_lo_u32    v41, v41, v39
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d86c0c00 2f000000*/ ds_read_b32     v47, v0 offset:3072
/*7e600280         */ v_mov_b32       v48, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002f 00025e87*/ v_lshlrev_b64   v[47:48], 7, v[47:48]
/*325e5e06         */ v_add_u32       v47, vcc, s6, v47
/*384c6126         */ v_addc_u32      v38, vcc, v38, v48, vcc
/*320c352f         */ v_add_u32       v6, vcc, v47, v26
/*d11c6a07 01a90126*/ v_addc_u32      v7, vcc, v38, 0, vcc
/*d1196a30 00012106*/ v_add_u32       v48, vcc, v6, 16
/*d11c6a31 01a90107*/ v_addc_u32      v49, vcc, v7, 0, vcc
/*dc5c0000 34000030*/ flat_load_dwordx4 v[52:55], v[48:49] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4c6f2b         */ v_xor_b32       v38, v43, v55
/*2a486d24         */ v_xor_b32       v36, v36, v54
/*2a526b29         */ v_xor_b32       v41, v41, v53
/*2a506928         */ v_xor_b32       v40, v40, v52
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a54772a         */ v_xor_b32       v42, v42, v59
/*2a56752e         */ v_xor_b32       v43, v46, v58
/*2a5a732d         */ v_xor_b32       v45, v45, v57
/*2a58712c         */ v_xor_b32       v44, v44, v56
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a585b2c         */ v_xor_b32       v44, v44, v45
/*d285002c 00024f2c*/ v_mul_lo_u32    v44, v44, v39
/*2a56572c         */ v_xor_b32       v43, v44, v43
/*d285002b 00024f2b*/ v_mul_lo_u32    v43, v43, v39
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a0c552b         */ v_xor_b32       v6, v43, v42
/*2a505328         */ v_xor_b32       v40, v40, v41
/*d2850028 00024f28*/ v_mul_lo_u32    v40, v40, v39
/*2a484928         */ v_xor_b32       v36, v40, v36
/*d2850024 00024f24*/ v_mul_lo_u32    v36, v36, v39
/*2a0e4d24         */ v_xor_b32       v7, v36, v38
/*d89a0000 00000620*/ ds_write_b64    v32, v[6:7]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be88017e         */ s_mov_b64       s[8:9], exec
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf88000c         */ s_cbranch_execz .L55200_0
/*d8ee0302 08000003*/ ds_read2_b64    v[8:11], v3 offset0:2 offset1:3
/*d8ee0100 57000003*/ ds_read2_b64    v[87:90], v3 offset1:1
/*bf8c017f         */ s_waitcnt       lgkmcnt(0)
/*7e9a0309         */ v_mov_b32       v77, v9
/*7e9c030b         */ v_mov_b32       v78, v11
/*7e36030a         */ v_mov_b32       v27, v10
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7eb60358         */ v_mov_b32       v91, v88
/*7ed0035a         */ v_mov_b32       v104, v90
/*7ece0359         */ v_mov_b32       v103, v89
.L55200_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8a0000         */ s_barrier
/*d0c50002 00010705*/ v_cmp_lg_i32    s[2:3], v5, 3
/*89fe0208         */ s_andn2_b64     exec, s[8:9], s[2:3]
/*bf880008         */ s_cbranch_execz .L55256_0
/*d89c0100 00466b03*/ ds_write2_b64   v3, v[107:108], v[70:71] offset1:1
/*d89c0302 00555103*/ ds_write2_b64   v3, v[81:82], v[85:86] offset0:2 offset1:3
/*d89c0504 00485303*/ ds_write2_b64   v3, v[83:84], v[72:73] offset0:4 offset1:5
/*d89c0706 004f4a03*/ ds_write2_b64   v3, v[74:75], v[79:80] offset0:6 offset1:7
.L55256_0:
/*befe0108         */ s_mov_b64       exec, s[8:9]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be8800ff 01000193*/ s_mov_b32       s8, 0x1000193
/*d0c5000a 00024280*/ v_cmp_lg_i32    s[10:11], 0, v33
/*d1000005 002a3d23*/ v_cndmask_b32   v5, v35, v30, s[10:11]
/*d2860005 00023905*/ v_mul_hi_u32    v5, v5, v28
/*343c0b1c         */ v_sub_u32       v30, vcc, v28, v5
/*320a0b1c         */ v_add_u32       v5, vcc, v28, v5
/*d1000005 002a3d05*/ v_cndmask_b32   v5, v5, v30, s[10:11]
/*d0c5000a 00000280*/ v_cmp_lg_i32    s[10:11], 0, s1
/*7e380207         */ v_mov_b32       v28, s7
/*7e3c02ff 01000193*/ v_mov_b32       v30, 0x1000193
/*d8ee0302 2600001f*/ ds_read2_b64    v[38:41], v31 offset0:2 offset1:3
/*d8ee0100 2a00001f*/ ds_read2_b64    v[42:45], v31 offset1:1
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf800000         */ /*s_nop           0x0*/
/*d285001f 0000112b*/ v_mul_lo_u32    v31, v43, s8
/*d2850021 00023d27*/ v_mul_lo_u32    v33, v39, v30
/*d2850023 00023d26*/ v_mul_lo_u32    v35, v38, v30
/*d2850024 00023d2a*/ v_mul_lo_u32    v36, v42, v30
/*d2850026 00023d28*/ v_mul_lo_u32    v38, v40, v30
/*d2850027 00023d29*/ v_mul_lo_u32    v39, v41, v30
/*d2850028 00023d2c*/ v_mul_lo_u32    v40, v44, v30
/*d2850029 00023d2d*/ v_mul_lo_u32    v41, v45, v30
/*d86c0000 2b000003*/ ds_read_b32     v43, v3
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d285002c 0000112b*/ v_mul_lo_u32    v44, v43, s8
/*2a54552c         */ v_xor_b32       v42, v44, v42
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce000c 0002592a*/ v_cmp_ge_u32    s[12:13], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a0c         */ s_and_b64       vcc, s[12:13], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0032552c*/ v_cndmask_b32   v42, v44, v42, s[12:13]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a545681         */ v_xor_b32       v42, 1, v43
/*d285002a 0000112a*/ v_mul_lo_u32    v42, v42, s8
/*2a585687         */ v_xor_b32       v44, 7, v43
/*2a5a5686         */ v_xor_b32       v45, 6, v43
/*2a5c5685         */ v_xor_b32       v46, 5, v43
/*2a5e5684         */ v_xor_b32       v47, 4, v43
/*2a605683         */ v_xor_b32       v48, 3, v43
/*2a625682         */ v_xor_b32       v49, 2, v43
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002e 00023d2e*/ v_mul_lo_u32    v46, v46, v30
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32686806         */ v_add_u32       v52, vcc, s6, v52
/*386a6b1c         */ v_addc_u32      v53, vcc, v28, v53, vcc
/*32683534         */ v_add_u32       v52, vcc, v52, v26
/*d11c6a35 01a90135*/ v_addc_u32      v53, vcc, v53, 0, vcc
/*d1196a06 00012134*/ v_add_u32       v6, vcc, v52, 16
/*d11c6a07 01a90135*/ v_addc_u32      v7, vcc, v53, 0, vcc
/*dc5c0000 38000034*/ flat_load_dwordx4 v[56:59], v[52:53] slc glc
/*dc5c0000 34000006*/ flat_load_dwordx4 v[52:55], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a54551f         */ v_xor_b32       v42, v31, v42
/*d2860039 00025505*/ v_mul_hi_u32    v57, v5, v42
/*d2850039 00000339*/ v_mul_lo_u32    v57, v57, s1
/*3478732a         */ v_sub_u32       v60, vcc, v42, v57
/*d0ce0008 0002732a*/ v_cmp_ge_u32    s[8:9], v42, v57
/*36547801         */ v_subrev_u32    v42, vcc, s1, v60
/*7d967801         */ v_cmp_le_u32    vcc, s1, v60
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054553c         */ v_cndmask_b32   v42, v60, v42, vcc
/*32725401         */ v_add_u32       v57, vcc, s1, v42
/*d100002a 00225539*/ v_cndmask_b32   v42, v57, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*bf800000         */ /*s_nop           0x0*/
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38686b1c         */ v_addc_u32      v52, vcc, v28, v53, vcc
/*326e352a         */ v_add_u32       v55, vcc, v42, v26
/*d11c6a38 01a90134*/ v_addc_u32      v56, vcc, v52, 0, vcc
/*d1196a34 00012137*/ v_add_u32       v52, vcc, v55, 16
/*d11c6a35 01a90138*/ v_addc_u32      v53, vcc, v56, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000034*/ flat_load_dwordx4 v[59:62], v[52:53] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a546328         */ v_xor_b32       v42, v40, v49
/*d2860031 00025505*/ v_mul_hi_u32    v49, v5, v42
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*3468632a         */ v_sub_u32       v52, vcc, v42, v49
/*d0ce0008 0002632a*/ v_cmp_ge_u32    s[8:9], v42, v49
/*36546801         */ v_subrev_u32    v42, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545534         */ v_cndmask_b32   v42, v52, v42, vcc
/*32625401         */ v_add_u32       v49, vcc, s1, v42
/*d100002a 00225531*/ v_cndmask_b32   v42, v49, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7d27         */ v_xor_b32       v39, v39, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a527529         */ v_xor_b32       v41, v41, v58
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38626b1c         */ v_addc_u32      v49, vcc, v28, v53, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a90131*/ v_addc_u32      v57, vcc, v49, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a546129         */ v_xor_b32       v42, v41, v48
/*d2860030 00025505*/ v_mul_hi_u32    v48, v5, v42
/*d2850030 00000330*/ v_mul_lo_u32    v48, v48, s1
/*3462612a         */ v_sub_u32       v49, vcc, v42, v48
/*d0ce0008 0002612a*/ v_cmp_ge_u32    s[8:9], v42, v48
/*36546201         */ v_subrev_u32    v42, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545531         */ v_cndmask_b32   v42, v49, v42, vcc
/*32605401         */ v_add_u32       v48, vcc, s1, v42
/*d100002a 00225530*/ v_cndmask_b32   v42, v48, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a466923         */ v_xor_b32       v35, v35, v52
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 30000025*/ ds_read_b32     v48, v37 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32546006         */ v_add_u32       v42, vcc, s6, v48
/*3860631c         */ v_addc_u32      v48, vcc, v28, v49, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a90130*/ v_addc_u32      v7, vcc, v48, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a545f23         */ v_xor_b32       v42, v35, v47
/*d286002f 00025505*/ v_mul_hi_u32    v47, v5, v42
/*d285002f 0000032f*/ v_mul_lo_u32    v47, v47, s1
/*34605f2a         */ v_sub_u32       v48, vcc, v42, v47
/*d0ce0008 00025f2a*/ v_cmp_ge_u32    s[8:9], v42, v47
/*36546001         */ v_subrev_u32    v42, vcc, s1, v48
/*7d966001         */ v_cmp_le_u32    vcc, s1, v48
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545530         */ v_cndmask_b32   v42, v48, v42, vcc
/*325e5401         */ v_add_u32       v47, vcc, s1, v42
/*d100002a 0022552f*/ v_cndmask_b32   v42, v47, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a527729         */ v_xor_b32       v41, v41, v59
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2f000025*/ ds_read_b32     v47, v37 offset:3072
/*7e600280         */ v_mov_b32       v48, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002f 00025e87*/ v_lshlrev_b64   v[47:48], 7, v[47:48]
/*32545e06         */ v_add_u32       v42, vcc, s6, v47
/*385e611c         */ v_addc_u32      v47, vcc, v28, v48, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012f*/ v_addc_u32      v7, vcc, v47, 0, vcc
/*d1196a30 00012106*/ v_add_u32       v48, vcc, v6, 16
/*d11c6a31 01a90107*/ v_addc_u32      v49, vcc, v7, 0, vcc
/*dc5c0000 34000030*/ flat_load_dwordx4 v[52:55], v[48:49] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a545d21         */ v_xor_b32       v42, v33, v46
/*d286002e 00025505*/ v_mul_hi_u32    v46, v5, v42
/*d285002e 0000032e*/ v_mul_lo_u32    v46, v46, s1
/*345e5d2a         */ v_sub_u32       v47, vcc, v42, v46
/*d0ce0008 00025d2a*/ v_cmp_ge_u32    s[8:9], v42, v46
/*36545e01         */ v_subrev_u32    v42, vcc, s1, v47
/*7d965e01         */ v_cmp_le_u32    vcc, s1, v47
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552f         */ v_cndmask_b32   v42, v47, v42, vcc
/*325c5401         */ v_add_u32       v46, vcc, s1, v42
/*d100002a 0022552e*/ v_cndmask_b32   v42, v46, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 2e000025*/ ds_read_b32     v46, v37 offset:3072
/*7e5e0280         */ v_mov_b32       v47, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002e 00025c87*/ v_lshlrev_b64   v[46:47], 7, v[46:47]
/*32545c06         */ v_add_u32       v42, vcc, s6, v46
/*385c5f1c         */ v_addc_u32      v46, vcc, v28, v47, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012e*/ v_addc_u32      v7, vcc, v46, 0, vcc
/*d1196a2f 00012106*/ v_add_u32       v47, vcc, v6, 16
/*d11c6a30 01a90107*/ v_addc_u32      v48, vcc, v7, 0, vcc
/*2a625688         */ v_xor_b32       v49, 8, v43
/*dc5c0000 3400002f*/ flat_load_dwordx4 v[52:55], v[47:48] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a545b26         */ v_xor_b32       v42, v38, v45
/*d286002d 00025505*/ v_mul_hi_u32    v45, v5, v42
/*d285002d 0000032d*/ v_mul_lo_u32    v45, v45, s1
/*345c5b2a         */ v_sub_u32       v46, vcc, v42, v45
/*d0ce0008 00025b2a*/ v_cmp_ge_u32    s[8:9], v42, v45
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*325a5401         */ v_add_u32       v45, vcc, s1, v42
/*d100002a 0022552d*/ v_cndmask_b32   v42, v45, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d285002a 00023d31*/ v_mul_lo_u32    v42, v49, v30
/*2a5a5689         */ v_xor_b32       v45, 9, v43
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*2a5c568f         */ v_xor_b32       v46, 15, v43
/*2a5e568e         */ v_xor_b32       v47, 14, v43
/*2a60568d         */ v_xor_b32       v48, 13, v43
/*2a62568c         */ v_xor_b32       v49, 12, v43
/*2a68568b         */ v_xor_b32       v52, 11, v43
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*2a72568a         */ v_xor_b32       v57, 10, v43
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b27         */ v_xor_b32       v39, v39, v61
/*2a585927         */ v_xor_b32       v44, v39, v44
/*d286003d 00025905*/ v_mul_hi_u32    v61, v5, v44
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*347c7b2c         */ v_sub_u32       v62, vcc, v44, v61
/*d0ce0008 00027b2c*/ v_cmp_ge_u32    s[8:9], v44, v61
/*36587c01         */ v_subrev_u32    v44, vcc, s1, v62
/*7d967c01         */ v_cmp_le_u32    vcc, s1, v62
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0058593e         */ v_cndmask_b32   v44, v62, v44, vcc
/*327a5801         */ v_add_u32       v61, vcc, s1, v44
/*d100002c 0022593d*/ v_cndmask_b32   v44, v61, v44, s[8:9]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d285002c 00023d39*/ v_mul_lo_u32    v44, v57, v30
/*d2850034 00023d34*/ v_mul_lo_u32    v52, v52, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002e 00023d2e*/ v_mul_lo_u32    v46, v46, v30
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a4c7326         */ v_xor_b32       v38, v38, v57
/*2a427121         */ v_xor_b32       v33, v33, v56
/*2a466f23         */ v_xor_b32       v35, v35, v55
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a3e791f         */ v_xor_b32       v31, v31, v60
/*2a487724         */ v_xor_b32       v36, v36, v59
/*2a54492a         */ v_xor_b32       v42, v42, v36
/*d2860035 00025505*/ v_mul_hi_u32    v53, v5, v42
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b2a         */ v_sub_u32       v54, vcc, v42, v53
/*d0ce0008 00026b2a*/ v_cmp_ge_u32    s[8:9], v42, v53
/*36546c01         */ v_subrev_u32    v42, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545536         */ v_cndmask_b32   v42, v54, v42, vcc
/*326a5401         */ v_add_u32       v53, vcc, s1, v42
/*d100002a 00225535*/ v_cndmask_b32   v42, v53, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d86c0c00 35000033*/ ds_read_b32     v53, v51 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*386a6d1c         */ v_addc_u32      v53, vcc, v28, v54, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a90135*/ v_addc_u32      v57, vcc, v53, 0, vcc
/*d1196a35 00012138*/ v_add_u32       v53, vcc, v56, 16
/*d11c6a36 01a90139*/ v_addc_u32      v54, vcc, v57, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c000035*/ flat_load_dwordx4 v[60:63], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a545b1f         */ v_xor_b32       v42, v31, v45
/*d286002d 00025505*/ v_mul_hi_u32    v45, v5, v42
/*d285002d 0000032d*/ v_mul_lo_u32    v45, v45, s1
/*346a5b2a         */ v_sub_u32       v53, vcc, v42, v45
/*d0ce0008 00025b2a*/ v_cmp_ge_u32    s[8:9], v42, v45
/*36546a01         */ v_subrev_u32    v42, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545535         */ v_cndmask_b32   v42, v53, v42, vcc
/*325a5401         */ v_add_u32       v45, vcc, s1, v42
/*d100002a 0022552d*/ v_cndmask_b32   v42, v45, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7f27         */ v_xor_b32       v39, v39, v63
/*2a4c7d26         */ v_xor_b32       v38, v38, v62
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a467923         */ v_xor_b32       v35, v35, v60
/*2a427b21         */ v_xor_b32       v33, v33, v61
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 35000033*/ ds_read_b32     v53, v51 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*385a6d1c         */ v_addc_u32      v45, vcc, v28, v54, vcc
/*326e352a         */ v_add_u32       v55, vcc, v42, v26
/*d11c6a38 01a9012d*/ v_addc_u32      v56, vcc, v45, 0, vcc
/*d1196a35 00012137*/ v_add_u32       v53, vcc, v55, 16
/*d11c6a36 01a90138*/ v_addc_u32      v54, vcc, v56, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a545928         */ v_xor_b32       v42, v40, v44
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7d27         */ v_xor_b32       v39, v39, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a527529         */ v_xor_b32       v41, v41, v58
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000033*/ ds_read_b32     v44, v51 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a35 00012106*/ v_add_u32       v53, vcc, v6, 16
/*d11c6a36 01a90107*/ v_addc_u32      v54, vcc, v7, 0, vcc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000006*/ flat_load_dwordx4 v[57:60], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a546929         */ v_xor_b32       v42, v41, v52
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000033*/ ds_read_b32     v44, v51 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a546323         */ v_xor_b32       v42, v35, v49
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a527729         */ v_xor_b32       v41, v41, v59
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000033*/ ds_read_b32     v44, v51 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a546121         */ v_xor_b32       v42, v33, v48
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 2c000033*/ ds_read_b32     v44, v51 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*2a625690         */ v_xor_b32       v49, 16, v43
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a545f26         */ v_xor_b32       v42, v38, v47
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d285002a 00023d31*/ v_mul_lo_u32    v42, v49, v30
/*2a585691         */ v_xor_b32       v44, 17, v43
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*2a5a5697         */ v_xor_b32       v45, 23, v43
/*2a5e5696         */ v_xor_b32       v47, 22, v43
/*2a605695         */ v_xor_b32       v48, 21, v43
/*2a625694         */ v_xor_b32       v49, 20, v43
/*2a685693         */ v_xor_b32       v52, 19, v43
/*d86c0c00 35000033*/ ds_read_b32     v53, v51 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*2a725692         */ v_xor_b32       v57, 18, v43
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b27         */ v_xor_b32       v39, v39, v61
/*2a5c5d27         */ v_xor_b32       v46, v39, v46
/*d286003d 00025d05*/ v_mul_hi_u32    v61, v5, v46
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*347c7b2e         */ v_sub_u32       v62, vcc, v46, v61
/*d0ce0008 00027b2e*/ v_cmp_ge_u32    s[8:9], v46, v61
/*365c7c01         */ v_subrev_u32    v46, vcc, s1, v62
/*7d967c01         */ v_cmp_le_u32    vcc, s1, v62
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005c5d3e         */ v_cndmask_b32   v46, v62, v46, vcc
/*327a5c01         */ v_add_u32       v61, vcc, s1, v46
/*d100002e 00225d3d*/ v_cndmask_b32   v46, v61, v46, s[8:9]
/*d100002e 002a5cc1*/ v_cndmask_b32   v46, -1, v46, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002e15*/ ds_write_b32    v21, v46 offset:3072
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d285002e 00023d39*/ v_mul_lo_u32    v46, v57, v30
/*d2850034 00023d34*/ v_mul_lo_u32    v52, v52, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*d86c0c00 35000033*/ ds_read_b32     v53, v51 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a4c7326         */ v_xor_b32       v38, v38, v57
/*2a427121         */ v_xor_b32       v33, v33, v56
/*2a466f23         */ v_xor_b32       v35, v35, v55
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a3e791f         */ v_xor_b32       v31, v31, v60
/*2a487724         */ v_xor_b32       v36, v36, v59
/*2a54492a         */ v_xor_b32       v42, v42, v36
/*d2860035 00025505*/ v_mul_hi_u32    v53, v5, v42
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b2a         */ v_sub_u32       v54, vcc, v42, v53
/*d0ce0008 00026b2a*/ v_cmp_ge_u32    s[8:9], v42, v53
/*36546c01         */ v_subrev_u32    v42, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545536         */ v_cndmask_b32   v42, v54, v42, vcc
/*326a5401         */ v_add_u32       v53, vcc, s1, v42
/*d100002a 00225535*/ v_cndmask_b32   v42, v53, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d86c0c00 35000032*/ ds_read_b32     v53, v50 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*386a6d1c         */ v_addc_u32      v53, vcc, v28, v54, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a90135*/ v_addc_u32      v57, vcc, v53, 0, vcc
/*d1196a35 00012138*/ v_add_u32       v53, vcc, v56, 16
/*d11c6a36 01a90139*/ v_addc_u32      v54, vcc, v57, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c000035*/ flat_load_dwordx4 v[60:63], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a54591f         */ v_xor_b32       v42, v31, v44
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*346a592a         */ v_sub_u32       v53, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36546a01         */ v_subrev_u32    v42, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545535         */ v_cndmask_b32   v42, v53, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7f27         */ v_xor_b32       v39, v39, v63
/*2a4c7d26         */ v_xor_b32       v38, v38, v62
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a467923         */ v_xor_b32       v35, v35, v60
/*2a427b21         */ v_xor_b32       v33, v33, v61
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 35000032*/ ds_read_b32     v53, v50 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*38586d1c         */ v_addc_u32      v44, vcc, v28, v54, vcc
/*326e352a         */ v_add_u32       v55, vcc, v42, v26
/*d11c6a38 01a9012c*/ v_addc_u32      v56, vcc, v44, 0, vcc
/*d1196a35 00012137*/ v_add_u32       v53, vcc, v55, 16
/*d11c6a36 01a90138*/ v_addc_u32      v54, vcc, v56, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a545d28         */ v_xor_b32       v42, v40, v46
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7d27         */ v_xor_b32       v39, v39, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a527529         */ v_xor_b32       v41, v41, v58
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 35000032*/ ds_read_b32     v53, v50 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*38586d1c         */ v_addc_u32      v44, vcc, v28, v54, vcc
/*3272352a         */ v_add_u32       v57, vcc, v42, v26
/*d11c6a3a 01a9012c*/ v_addc_u32      v58, vcc, v44, 0, vcc
/*d1196a35 00012139*/ v_add_u32       v53, vcc, v57, 16
/*d11c6a36 01a9013a*/ v_addc_u32      v54, vcc, v58, 0, vcc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a546929         */ v_xor_b32       v42, v41, v52
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38586b1c         */ v_addc_u32      v44, vcc, v28, v53, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a546323         */ v_xor_b32       v42, v35, v49
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a527729         */ v_xor_b32       v41, v41, v59
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 34000032*/ ds_read_b32     v52, v50 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38586b1c         */ v_addc_u32      v44, vcc, v28, v53, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a546121         */ v_xor_b32       v42, v33, v48
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 30000032*/ ds_read_b32     v48, v50 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32546006         */ v_add_u32       v42, vcc, s6, v48
/*3858631c         */ v_addc_u32      v44, vcc, v28, v49, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*2a625698         */ v_xor_b32       v49, 24, v43
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a545f26         */ v_xor_b32       v42, v38, v47
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d285002a 00023d31*/ v_mul_lo_u32    v42, v49, v30
/*2a585699         */ v_xor_b32       v44, 25, v43
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*2a5c569f         */ v_xor_b32       v46, 31, v43
/*2a5e569e         */ v_xor_b32       v47, 30, v43
/*2a60569d         */ v_xor_b32       v48, 29, v43
/*2a62569c         */ v_xor_b32       v49, 28, v43
/*2a68569b         */ v_xor_b32       v52, 27, v43
/*d86c0c00 35000032*/ ds_read_b32     v53, v50 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*2a72569a         */ v_xor_b32       v57, 26, v43
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b27         */ v_xor_b32       v39, v39, v61
/*2a5a5b27         */ v_xor_b32       v45, v39, v45
/*d286003d 00025b05*/ v_mul_hi_u32    v61, v5, v45
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*347c7b2d         */ v_sub_u32       v62, vcc, v45, v61
/*d0ce0008 00027b2d*/ v_cmp_ge_u32    s[8:9], v45, v61
/*365a7c01         */ v_subrev_u32    v45, vcc, s1, v62
/*7d967c01         */ v_cmp_le_u32    vcc, s1, v62
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005a5b3e         */ v_cndmask_b32   v45, v62, v45, vcc
/*327a5a01         */ v_add_u32       v61, vcc, s1, v45
/*d100002d 00225b3d*/ v_cndmask_b32   v45, v61, v45, s[8:9]
/*d100002d 002a5ac1*/ v_cndmask_b32   v45, -1, v45, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002d15*/ ds_write_b32    v21, v45 offset:3072
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d285002d 00023d39*/ v_mul_lo_u32    v45, v57, v30
/*d2850034 00023d34*/ v_mul_lo_u32    v52, v52, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002e 00023d2e*/ v_mul_lo_u32    v46, v46, v30
/*d86c0c00 35000032*/ ds_read_b32     v53, v50 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a4c7326         */ v_xor_b32       v38, v38, v57
/*2a427121         */ v_xor_b32       v33, v33, v56
/*2a466f23         */ v_xor_b32       v35, v35, v55
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a3e791f         */ v_xor_b32       v31, v31, v60
/*2a487724         */ v_xor_b32       v36, v36, v59
/*2a54492a         */ v_xor_b32       v42, v42, v36
/*d2860035 00025505*/ v_mul_hi_u32    v53, v5, v42
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b2a         */ v_sub_u32       v54, vcc, v42, v53
/*d0ce0008 00026b2a*/ v_cmp_ge_u32    s[8:9], v42, v53
/*36546c01         */ v_subrev_u32    v42, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545536         */ v_cndmask_b32   v42, v54, v42, vcc
/*326a5401         */ v_add_u32       v53, vcc, s1, v42
/*d100002a 00225535*/ v_cndmask_b32   v42, v53, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d86c0c00 35000000*/ ds_read_b32     v53, v0 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*386a6d1c         */ v_addc_u32      v53, vcc, v28, v54, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a90135*/ v_addc_u32      v57, vcc, v53, 0, vcc
/*d1196a35 00012138*/ v_add_u32       v53, vcc, v56, 16
/*d11c6a36 01a90139*/ v_addc_u32      v54, vcc, v57, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c000035*/ flat_load_dwordx4 v[60:63], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a54591f         */ v_xor_b32       v42, v31, v44
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*346a592a         */ v_sub_u32       v53, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36546a01         */ v_subrev_u32    v42, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545535         */ v_cndmask_b32   v42, v53, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7f27         */ v_xor_b32       v39, v39, v63
/*2a4c7d26         */ v_xor_b32       v38, v38, v62
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a467923         */ v_xor_b32       v35, v35, v60
/*2a427b21         */ v_xor_b32       v33, v33, v61
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 35000000*/ ds_read_b32     v53, v0 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*38586d1c         */ v_addc_u32      v44, vcc, v28, v54, vcc
/*326e352a         */ v_add_u32       v55, vcc, v42, v26
/*d11c6a38 01a9012c*/ v_addc_u32      v56, vcc, v44, 0, vcc
/*d1196a35 00012137*/ v_add_u32       v53, vcc, v55, 16
/*d11c6a36 01a90138*/ v_addc_u32      v54, vcc, v56, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a545b28         */ v_xor_b32       v42, v40, v45
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7d27         */ v_xor_b32       v39, v39, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a527529         */ v_xor_b32       v41, v41, v58
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000000*/ ds_read_b32     v44, v0 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a35 00012106*/ v_add_u32       v53, vcc, v6, 16
/*d11c6a36 01a90107*/ v_addc_u32      v54, vcc, v7, 0, vcc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000006*/ flat_load_dwordx4 v[57:60], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a546929         */ v_xor_b32       v42, v41, v52
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000000*/ ds_read_b32     v44, v0 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a546323         */ v_xor_b32       v42, v35, v49
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a527729         */ v_xor_b32       v41, v41, v59
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 2c000000*/ ds_read_b32     v44, v0 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a546121         */ v_xor_b32       v42, v33, v48
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 2c000000*/ ds_read_b32     v44, v0 offset:3072
/*7e5a0280         */ v_mov_b32       v45, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f002c 00025887*/ v_lshlrev_b64   v[44:45], 7, v[44:45]
/*32545806         */ v_add_u32       v42, vcc, s6, v44
/*38585b1c         */ v_addc_u32      v44, vcc, v28, v45, vcc
/*320c352a         */ v_add_u32       v6, vcc, v42, v26
/*d11c6a07 01a9012c*/ v_addc_u32      v7, vcc, v44, 0, vcc
/*d1196a34 00012106*/ v_add_u32       v52, vcc, v6, 16
/*d11c6a35 01a90107*/ v_addc_u32      v53, vcc, v7, 0, vcc
/*2a6256a0         */ v_xor_b32       v49, 32, v43
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000006*/ flat_load_dwordx4 v[56:59], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a545f26         */ v_xor_b32       v42, v38, v47
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345a592a         */ v_sub_u32       v45, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545a01         */ v_subrev_u32    v42, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552d         */ v_cndmask_b32   v42, v45, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d285002a 00023d31*/ v_mul_lo_u32    v42, v49, v30
/*2a5856a1         */ v_xor_b32       v44, 33, v43
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*2a5a56a7         */ v_xor_b32       v45, 39, v43
/*2a5e56a6         */ v_xor_b32       v47, 38, v43
/*2a6056a5         */ v_xor_b32       v48, 37, v43
/*2a6256a4         */ v_xor_b32       v49, 36, v43
/*2a6856a3         */ v_xor_b32       v52, 35, v43
/*d86c0c00 35000000*/ ds_read_b32     v53, v0 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*2a7256a2         */ v_xor_b32       v57, 34, v43
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b27         */ v_xor_b32       v39, v39, v61
/*2a5c5d27         */ v_xor_b32       v46, v39, v46
/*d286003d 00025d05*/ v_mul_hi_u32    v61, v5, v46
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*347c7b2e         */ v_sub_u32       v62, vcc, v46, v61
/*d0ce0008 00027b2e*/ v_cmp_ge_u32    s[8:9], v46, v61
/*365c7c01         */ v_subrev_u32    v46, vcc, s1, v62
/*7d967c01         */ v_cmp_le_u32    vcc, s1, v62
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005c5d3e         */ v_cndmask_b32   v46, v62, v46, vcc
/*327a5c01         */ v_add_u32       v61, vcc, s1, v46
/*d100002e 00225d3d*/ v_cndmask_b32   v46, v61, v46, s[8:9]
/*d100002e 002a5cc1*/ v_cndmask_b32   v46, -1, v46, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002e15*/ ds_write_b32    v21, v46 offset:3072
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d285002e 00023d39*/ v_mul_lo_u32    v46, v57, v30
/*d2850034 00023d34*/ v_mul_lo_u32    v52, v52, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*d86c0c00 35000000*/ ds_read_b32     v53, v0 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a4c7326         */ v_xor_b32       v38, v38, v57
/*2a427121         */ v_xor_b32       v33, v33, v56
/*2a466f23         */ v_xor_b32       v35, v35, v55
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527d29         */ v_xor_b32       v41, v41, v62
/*2a507b28         */ v_xor_b32       v40, v40, v61
/*2a3e791f         */ v_xor_b32       v31, v31, v60
/*2a487724         */ v_xor_b32       v36, v36, v59
/*2a54492a         */ v_xor_b32       v42, v42, v36
/*d2860035 00025505*/ v_mul_hi_u32    v53, v5, v42
/*d2850035 00000335*/ v_mul_lo_u32    v53, v53, s1
/*346c6b2a         */ v_sub_u32       v54, vcc, v42, v53
/*d0ce0008 00026b2a*/ v_cmp_ge_u32    s[8:9], v42, v53
/*36546c01         */ v_subrev_u32    v42, vcc, s1, v54
/*7d966c01         */ v_cmp_le_u32    vcc, s1, v54
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545536         */ v_cndmask_b32   v42, v54, v42, vcc
/*326a5401         */ v_add_u32       v53, vcc, s1, v42
/*d100002a 00225535*/ v_cndmask_b32   v42, v53, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*386a6d1c         */ v_addc_u32      v53, vcc, v28, v54, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a90135*/ v_addc_u32      v57, vcc, v53, 0, vcc
/*d1196a35 00012138*/ v_add_u32       v53, vcc, v56, 16
/*d11c6a36 01a90139*/ v_addc_u32      v54, vcc, v57, 0, vcc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*dc5c0000 3c000035*/ flat_load_dwordx4 v[60:63], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a54591f         */ v_xor_b32       v42, v31, v44
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*346a592a         */ v_sub_u32       v53, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36546a01         */ v_subrev_u32    v42, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00545535         */ v_cndmask_b32   v42, v53, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7f27         */ v_xor_b32       v39, v39, v63
/*2a4c7d26         */ v_xor_b32       v38, v38, v62
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a467923         */ v_xor_b32       v35, v35, v60
/*2a427b21         */ v_xor_b32       v33, v33, v61
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*38586d1c         */ v_addc_u32      v44, vcc, v28, v54, vcc
/*326e352a         */ v_add_u32       v55, vcc, v42, v26
/*d11c6a38 01a9012c*/ v_addc_u32      v56, vcc, v44, 0, vcc
/*d1196a35 00012137*/ v_add_u32       v53, vcc, v55, 16
/*d11c6a36 01a90138*/ v_addc_u32      v54, vcc, v56, 0, vcc
/*dc5c0000 37000037*/ flat_load_dwordx4 v[55:58], v[55:56] slc glc
/*dc5c0000 3b000035*/ flat_load_dwordx4 v[59:62], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a545d28         */ v_xor_b32       v42, v40, v46
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e7d27         */ v_xor_b32       v39, v39, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a527529         */ v_xor_b32       v41, v41, v58
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*32546a06         */ v_add_u32       v42, vcc, s6, v53
/*38586d1c         */ v_addc_u32      v44, vcc, v28, v54, vcc
/*3272352a         */ v_add_u32       v57, vcc, v42, v26
/*d11c6a3a 01a9012c*/ v_addc_u32      v58, vcc, v44, 0, vcc
/*d1196a35 00012139*/ v_add_u32       v53, vcc, v57, 16
/*d11c6a36 01a9013a*/ v_addc_u32      v54, vcc, v58, 0, vcc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000039*/ flat_load_dwordx4 v[57:60], v[57:58] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a527929         */ v_xor_b32       v41, v41, v60
/*2a546929         */ v_xor_b32       v42, v41, v52
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38586b1c         */ v_addc_u32      v44, vcc, v28, v53, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a546323         */ v_xor_b32       v42, v35, v49
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a527729         */ v_xor_b32       v41, v41, v59
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 34000025*/ ds_read_b32     v52, v37 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32546806         */ v_add_u32       v42, vcc, s6, v52
/*38586b1c         */ v_addc_u32      v44, vcc, v28, v53, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a546121         */ v_xor_b32       v42, v33, v48
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 30000025*/ ds_read_b32     v48, v37 offset:3072
/*7e620280         */ v_mov_b32       v49, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0030 00026087*/ v_lshlrev_b64   v[48:49], 7, v[48:49]
/*32546006         */ v_add_u32       v42, vcc, s6, v48
/*3858631c         */ v_addc_u32      v44, vcc, v28, v49, vcc
/*3270352a         */ v_add_u32       v56, vcc, v42, v26
/*d11c6a39 01a9012c*/ v_addc_u32      v57, vcc, v44, 0, vcc
/*d1196a34 00012138*/ v_add_u32       v52, vcc, v56, 16
/*d11c6a35 01a90139*/ v_addc_u32      v53, vcc, v57, 0, vcc
/*2a6256a8         */ v_xor_b32       v49, 40, v43
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000038*/ flat_load_dwordx4 v[56:59], v[56:57] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a545f26         */ v_xor_b32       v42, v38, v47
/*d286002c 00025505*/ v_mul_hi_u32    v44, v5, v42
/*d285002c 0000032c*/ v_mul_lo_u32    v44, v44, s1
/*345c592a         */ v_sub_u32       v46, vcc, v42, v44
/*d0ce0008 0002592a*/ v_cmp_ge_u32    s[8:9], v42, v44
/*36545c01         */ v_subrev_u32    v42, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0054552e         */ v_cndmask_b32   v42, v46, v42, vcc
/*32585401         */ v_add_u32       v44, vcc, s1, v42
/*d100002a 0022552c*/ v_cndmask_b32   v42, v44, v42, s[8:9]
/*d100002a 002a54c1*/ v_cndmask_b32   v42, -1, v42, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002a15*/ ds_write_b32    v21, v42 offset:3072
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a527729         */ v_xor_b32       v41, v41, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d285002a 00023d31*/ v_mul_lo_u32    v42, v49, v30
/*2a5856a9         */ v_xor_b32       v44, 41, v43
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*2a5c56af         */ v_xor_b32       v46, 47, v43
/*2a5e56ae         */ v_xor_b32       v47, 46, v43
/*2a6056ad         */ v_xor_b32       v48, 45, v43
/*2a6256ac         */ v_xor_b32       v49, 44, v43
/*2a6856ab         */ v_xor_b32       v52, 43, v43
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*326a6a06         */ v_add_u32       v53, vcc, s6, v53
/*386c6d1c         */ v_addc_u32      v54, vcc, v28, v54, vcc
/*326a3535         */ v_add_u32       v53, vcc, v53, v26
/*d11c6a36 01a90136*/ v_addc_u32      v54, vcc, v54, 0, vcc
/*d1196a37 00012135*/ v_add_u32       v55, vcc, v53, 16
/*d11c6a38 01a90136*/ v_addc_u32      v56, vcc, v54, 0, vcc
/*2a7256aa         */ v_xor_b32       v57, 42, v43
/*dc5c0000 3a000037*/ flat_load_dwordx4 v[58:61], v[55:56] slc glc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b27         */ v_xor_b32       v39, v39, v61
/*2a5a5b27         */ v_xor_b32       v45, v39, v45
/*d286003d 00025b05*/ v_mul_hi_u32    v61, v5, v45
/*d285003d 0000033d*/ v_mul_lo_u32    v61, v61, s1
/*347c7b2d         */ v_sub_u32       v62, vcc, v45, v61
/*d0ce0008 00027b2d*/ v_cmp_ge_u32    s[8:9], v45, v61
/*365a7c01         */ v_subrev_u32    v45, vcc, s1, v62
/*7d967c01         */ v_cmp_le_u32    vcc, s1, v62
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005a5b3e         */ v_cndmask_b32   v45, v62, v45, vcc
/*327a5a01         */ v_add_u32       v61, vcc, s1, v45
/*d100002d 00225b3d*/ v_cndmask_b32   v45, v61, v45, s[8:9]
/*d100002d 002a5ac1*/ v_cndmask_b32   v45, -1, v45, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002d15*/ ds_write_b32    v21, v45 offset:3072
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a527129         */ v_xor_b32       v41, v41, v56
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850029 00023d29*/ v_mul_lo_u32    v41, v41, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d285002d 00023d39*/ v_mul_lo_u32    v45, v57, v30
/*d2850034 00023d34*/ v_mul_lo_u32    v52, v52, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002e 00023d2e*/ v_mul_lo_u32    v46, v46, v30
/*d86c0c00 35000025*/ ds_read_b32     v53, v37 offset:3072
/*7e6c0280         */ v_mov_b32       v54, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0035 00026a87*/ v_lshlrev_b64   v[53:54], 7, v[53:54]
/*324a6a06         */ v_add_u32       v37, vcc, s6, v53
/*386a6d1c         */ v_addc_u32      v53, vcc, v28, v54, vcc
/*32743525         */ v_add_u32       v58, vcc, v37, v26
/*d11c6a3b 01a90135*/ v_addc_u32      v59, vcc, v53, 0, vcc
/*d1196a36 0001213a*/ v_add_u32       v54, vcc, v58, 16
/*d11c6a37 01a9013b*/ v_addc_u32      v55, vcc, v59, 0, vcc
/*dc5c0000 36000036*/ flat_load_dwordx4 v[54:57], v[54:55] slc glc
/*dc5c0000 3a00003a*/ flat_load_dwordx4 v[58:61], v[58:59] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a7327         */ v_xor_b32       v37, v39, v57
/*2a4c7126         */ v_xor_b32       v38, v38, v56
/*2a426f21         */ v_xor_b32       v33, v33, v55
/*2a466d23         */ v_xor_b32       v35, v35, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7b29         */ v_xor_b32       v39, v41, v61
/*2a507928         */ v_xor_b32       v40, v40, v60
/*2a3e771f         */ v_xor_b32       v31, v31, v59
/*2a487524         */ v_xor_b32       v36, v36, v58
/*2a52492a         */ v_xor_b32       v41, v42, v36
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*346a5529         */ v_sub_u32       v53, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36526a01         */ v_subrev_u32    v41, vcc, s1, v53
/*7d966a01         */ v_cmp_le_u32    vcc, s1, v53
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00525335         */ v_cndmask_b32   v41, v53, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a06 00012129*/ v_add_u32       v6, vcc, v41, 16
/*d11c6a07 01a9012a*/ v_addc_u32      v7, vcc, v42, 0, vcc
/*dc5c0000 37000029*/ flat_load_dwordx4 v[55:58], v[41:42] slc glc
/*dc5c0000 3b000006*/ flat_load_dwordx4 v[59:62], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a52591f         */ v_xor_b32       v41, v31, v44
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7d25         */ v_xor_b32       v37, v37, v62
/*2a4c7b26         */ v_xor_b32       v38, v38, v61
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a467723         */ v_xor_b32       v35, v35, v59
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a06 00012129*/ v_add_u32       v6, vcc, v41, 16
/*d11c6a07 01a9012a*/ v_addc_u32      v7, vcc, v42, 0, vcc
/*dc5c0000 36000029*/ flat_load_dwordx4 v[54:57], v[41:42] slc glc
/*dc5c0000 3a000006*/ flat_load_dwordx4 v[58:61], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a507128         */ v_xor_b32       v40, v40, v56
/*2a525b28         */ v_xor_b32       v41, v40, v45
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7b25         */ v_xor_b32       v37, v37, v61
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a3e6f1f         */ v_xor_b32       v31, v31, v55
/*2a486d24         */ v_xor_b32       v36, v36, v54
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a4e7327         */ v_xor_b32       v39, v39, v57
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2c 00012129*/ v_add_u32       v44, vcc, v41, 16
/*d11c6a2d 01a9012a*/ v_addc_u32      v45, vcc, v42, 0, vcc
/*dc5c0000 3500002c*/ flat_load_dwordx4 v[53:56], v[44:45] slc glc
/*dc5c0000 39000029*/ flat_load_dwordx4 v[57:60], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7927         */ v_xor_b32       v39, v39, v60
/*2a526927         */ v_xor_b32       v41, v39, v52
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a4a7125         */ v_xor_b32       v37, v37, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2c 00012129*/ v_add_u32       v44, vcc, v41, 16
/*d11c6a2d 01a9012a*/ v_addc_u32      v45, vcc, v42, 0, vcc
/*dc5c0000 3400002c*/ flat_load_dwordx4 v[52:55], v[44:45] slc glc
/*dc5c0000 38000029*/ flat_load_dwordx4 v[56:59], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a526323         */ v_xor_b32       v41, v35, v49
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a4a6f25         */ v_xor_b32       v37, v37, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*2a4e7727         */ v_xor_b32       v39, v39, v59
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2c 00012129*/ v_add_u32       v44, vcc, v41, 16
/*d11c6a2d 01a9012a*/ v_addc_u32      v45, vcc, v42, 0, vcc
/*dc5c0000 3400002c*/ flat_load_dwordx4 v[52:55], v[44:45] slc glc
/*dc5c0000 38000029*/ flat_load_dwordx4 v[56:59], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a526121         */ v_xor_b32       v41, v33, v48
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a6f25         */ v_xor_b32       v37, v37, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a4e7727         */ v_xor_b32       v39, v39, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 29000033*/ ds_read_b32     v41, v51 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2c 00012129*/ v_add_u32       v44, vcc, v41, 16
/*d11c6a2d 01a9012a*/ v_addc_u32      v45, vcc, v42, 0, vcc
/*2a6056b0         */ v_xor_b32       v48, 48, v43
/*dc5c0000 3400002c*/ flat_load_dwordx4 v[52:55], v[44:45] slc glc
/*dc5c0000 38000029*/ flat_load_dwordx4 v[56:59], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a6f25         */ v_xor_b32       v37, v37, v55
/*2a4c6d26         */ v_xor_b32       v38, v38, v54
/*2a525f26         */ v_xor_b32       v41, v38, v47
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34585529         */ v_sub_u32       v44, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525801         */ v_subrev_u32    v41, vcc, s1, v44
/*7d965801         */ v_cmp_le_u32    vcc, s1, v44
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532c         */ v_cndmask_b32   v41, v44, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a426b21         */ v_xor_b32       v33, v33, v53
/*2a466923         */ v_xor_b32       v35, v35, v52
/*2a4e7727         */ v_xor_b32       v39, v39, v59
/*2a507528         */ v_xor_b32       v40, v40, v58
/*2a3e731f         */ v_xor_b32       v31, v31, v57
/*2a487124         */ v_xor_b32       v36, v36, v56
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850029 00023d30*/ v_mul_lo_u32    v41, v48, v30
/*2a5456b1         */ v_xor_b32       v42, 49, v43
/*d285002a 00023d2a*/ v_mul_lo_u32    v42, v42, v30
/*2a5856b7         */ v_xor_b32       v44, 55, v43
/*2a5a56b6         */ v_xor_b32       v45, 54, v43
/*2a5e56b5         */ v_xor_b32       v47, 53, v43
/*2a6056b4         */ v_xor_b32       v48, 52, v43
/*2a6256b3         */ v_xor_b32       v49, 51, v43
/*d86c0c00 34000033*/ ds_read_b32     v52, v51 offset:3072
/*7e6a0280         */ v_mov_b32       v53, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0034 00026887*/ v_lshlrev_b64   v[52:53], 7, v[52:53]
/*32686806         */ v_add_u32       v52, vcc, s6, v52
/*386a6b1c         */ v_addc_u32      v53, vcc, v28, v53, vcc
/*32683534         */ v_add_u32       v52, vcc, v52, v26
/*d11c6a35 01a90135*/ v_addc_u32      v53, vcc, v53, 0, vcc
/*d1196a36 00012134*/ v_add_u32       v54, vcc, v52, 16
/*d11c6a37 01a90135*/ v_addc_u32      v55, vcc, v53, 0, vcc
/*2a7056b2         */ v_xor_b32       v56, 50, v43
/*dc5c0000 39000036*/ flat_load_dwordx4 v[57:60], v[54:55] slc glc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a7925         */ v_xor_b32       v37, v37, v60
/*2a5c5d25         */ v_xor_b32       v46, v37, v46
/*d286003c 00025d05*/ v_mul_hi_u32    v60, v5, v46
/*d285003c 0000033c*/ v_mul_lo_u32    v60, v60, s1
/*347a792e         */ v_sub_u32       v61, vcc, v46, v60
/*d0ce0008 0002792e*/ v_cmp_ge_u32    s[8:9], v46, v60
/*365c7a01         */ v_subrev_u32    v46, vcc, s1, v61
/*7d967a01         */ v_cmp_le_u32    vcc, s1, v61
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005c5d3d         */ v_cndmask_b32   v46, v61, v46, vcc
/*32785c01         */ v_add_u32       v60, vcc, s1, v46
/*d100002e 00225d3c*/ v_cndmask_b32   v46, v60, v46, s[8:9]
/*d100002e 002a5cc1*/ v_cndmask_b32   v46, -1, v46, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002e15*/ ds_write_b32    v21, v46 offset:3072
/*2a4c7726         */ v_xor_b32       v38, v38, v59
/*2a427521         */ v_xor_b32       v33, v33, v58
/*2a467323         */ v_xor_b32       v35, v35, v57
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a506d28         */ v_xor_b32       v40, v40, v54
/*2a3e6b1f         */ v_xor_b32       v31, v31, v53
/*2a486924         */ v_xor_b32       v36, v36, v52
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d285002e 00023d38*/ v_mul_lo_u32    v46, v56, v30
/*d2850031 00023d31*/ v_mul_lo_u32    v49, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*d285002c 00023d2c*/ v_mul_lo_u32    v44, v44, v30
/*d86c0c00 33000033*/ ds_read_b32     v51, v51 offset:3072
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0033 00026687*/ v_lshlrev_b64   v[51:52], 7, v[51:52]
/*32666606         */ v_add_u32       v51, vcc, s6, v51
/*3868691c         */ v_addc_u32      v52, vcc, v28, v52, vcc
/*32663533         */ v_add_u32       v51, vcc, v51, v26
/*d11c6a34 01a90134*/ v_addc_u32      v52, vcc, v52, 0, vcc
/*d1196a35 00012133*/ v_add_u32       v53, vcc, v51, 16
/*d11c6a36 01a90134*/ v_addc_u32      v54, vcc, v52, 0, vcc
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000033*/ flat_load_dwordx4 v[57:60], v[51:52] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a7125         */ v_xor_b32       v37, v37, v56
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7927         */ v_xor_b32       v39, v39, v60
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*2a524929         */ v_xor_b32       v41, v41, v36
/*d2860033 00025305*/ v_mul_hi_u32    v51, v5, v41
/*d2850033 00000333*/ v_mul_lo_u32    v51, v51, s1
/*34686729         */ v_sub_u32       v52, vcc, v41, v51
/*d0ce0008 00026729*/ v_cmp_ge_u32    s[8:9], v41, v51
/*36526801         */ v_subrev_u32    v41, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00525334         */ v_cndmask_b32   v41, v52, v41, vcc
/*32665201         */ v_add_u32       v51, vcc, s1, v41
/*d1000029 00225333*/ v_cndmask_b32   v41, v51, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 33000032*/ ds_read_b32     v51, v50 offset:3072
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0033 00026687*/ v_lshlrev_b64   v[51:52], 7, v[51:52]
/*32526606         */ v_add_u32       v41, vcc, s6, v51
/*3866691c         */ v_addc_u32      v51, vcc, v28, v52, vcc
/*326c3529         */ v_add_u32       v54, vcc, v41, v26
/*d11c6a37 01a90133*/ v_addc_u32      v55, vcc, v51, 0, vcc
/*d1196a33 00012136*/ v_add_u32       v51, vcc, v54, 16
/*d11c6a34 01a90137*/ v_addc_u32      v52, vcc, v55, 0, vcc
/*dc5c0000 36000036*/ flat_load_dwordx4 v[54:57], v[54:55] slc glc
/*dc5c0000 3a000033*/ flat_load_dwordx4 v[58:61], v[51:52] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e6f1f         */ v_xor_b32       v31, v31, v55
/*2a52551f         */ v_xor_b32       v41, v31, v42
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34665529         */ v_sub_u32       v51, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36526601         */ v_subrev_u32    v41, vcc, s1, v51
/*7d966601         */ v_cmp_le_u32    vcc, s1, v51
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00525333         */ v_cndmask_b32   v41, v51, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7b25         */ v_xor_b32       v37, v37, v61
/*2a4c7926         */ v_xor_b32       v38, v38, v60
/*2a486d24         */ v_xor_b32       v36, v36, v54
/*2a467523         */ v_xor_b32       v35, v35, v58
/*2a427721         */ v_xor_b32       v33, v33, v59
/*2a4e7327         */ v_xor_b32       v39, v39, v57
/*2a507128         */ v_xor_b32       v40, v40, v56
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d86c0c00 29000032*/ ds_read_b32     v41, v50 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a06 00012129*/ v_add_u32       v6, vcc, v41, 16
/*d11c6a07 01a9012a*/ v_addc_u32      v7, vcc, v42, 0, vcc
/*dc5c0000 35000029*/ flat_load_dwordx4 v[53:56], v[41:42] slc glc
/*dc5c0000 39000006*/ flat_load_dwordx4 v[57:60], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a525d28         */ v_xor_b32       v41, v40, v46
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*345c5529         */ v_sub_u32       v46, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525c01         */ v_subrev_u32    v41, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532e         */ v_cndmask_b32   v41, v46, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7925         */ v_xor_b32       v37, v37, v60
/*2a4c7726         */ v_xor_b32       v38, v38, v59
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*2a467323         */ v_xor_b32       v35, v35, v57
/*2a427521         */ v_xor_b32       v33, v33, v58
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000032*/ ds_read_b32     v41, v50 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a33 00012129*/ v_add_u32       v51, vcc, v41, 16
/*d11c6a34 01a9012a*/ v_addc_u32      v52, vcc, v42, 0, vcc
/*dc5c0000 33000033*/ flat_load_dwordx4 v[51:54], v[51:52] slc glc
/*dc5c0000 37000029*/ flat_load_dwordx4 v[55:58], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426921         */ v_xor_b32       v33, v33, v52
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a526327         */ v_xor_b32       v41, v39, v49
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*345c5529         */ v_sub_u32       v46, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525c01         */ v_subrev_u32    v41, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532e         */ v_cndmask_b32   v41, v46, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a4a6d25         */ v_xor_b32       v37, v37, v54
/*2a4c6b26         */ v_xor_b32       v38, v38, v53
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a466723         */ v_xor_b32       v35, v35, v51
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000032*/ ds_read_b32     v41, v50 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a33 00012129*/ v_add_u32       v51, vcc, v41, 16
/*d11c6a34 01a9012a*/ v_addc_u32      v52, vcc, v42, 0, vcc
/*dc5c0000 33000033*/ flat_load_dwordx4 v[51:54], v[51:52] slc glc
/*dc5c0000 37000029*/ flat_load_dwordx4 v[55:58], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426921         */ v_xor_b32       v33, v33, v52
/*2a466723         */ v_xor_b32       v35, v35, v51
/*2a526123         */ v_xor_b32       v41, v35, v48
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*345c5529         */ v_sub_u32       v46, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525c01         */ v_subrev_u32    v41, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532e         */ v_cndmask_b32   v41, v46, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a4a6d25         */ v_xor_b32       v37, v37, v54
/*2a4c6b26         */ v_xor_b32       v38, v38, v53
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000032*/ ds_read_b32     v41, v50 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a30 00012129*/ v_add_u32       v48, vcc, v41, 16
/*d11c6a31 01a9012a*/ v_addc_u32      v49, vcc, v42, 0, vcc
/*dc5c0000 33000030*/ flat_load_dwordx4 v[51:54], v[48:49] slc glc
/*dc5c0000 37000029*/ flat_load_dwordx4 v[55:58], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426921         */ v_xor_b32       v33, v33, v52
/*2a525f21         */ v_xor_b32       v41, v33, v47
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*345c5529         */ v_sub_u32       v46, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525c01         */ v_subrev_u32    v41, vcc, s1, v46
/*7d965c01         */ v_cmp_le_u32    vcc, s1, v46
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532e         */ v_cndmask_b32   v41, v46, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a6d25         */ v_xor_b32       v37, v37, v54
/*2a4c6b26         */ v_xor_b32       v38, v38, v53
/*2a466723         */ v_xor_b32       v35, v35, v51
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 29000032*/ ds_read_b32     v41, v50 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2e 00012129*/ v_add_u32       v46, vcc, v41, 16
/*d11c6a2f 01a9012a*/ v_addc_u32      v47, vcc, v42, 0, vcc
/*2a6056b8         */ v_xor_b32       v48, 56, v43
/*dc5c0000 3300002e*/ flat_load_dwordx4 v[51:54], v[46:47] slc glc
/*dc5c0000 37000029*/ flat_load_dwordx4 v[55:58], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a6d25         */ v_xor_b32       v37, v37, v54
/*2a4c6b26         */ v_xor_b32       v38, v38, v53
/*2a525b26         */ v_xor_b32       v41, v38, v45
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*345a5529         */ v_sub_u32       v45, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525a01         */ v_subrev_u32    v41, vcc, s1, v45
/*7d965a01         */ v_cmp_le_u32    vcc, s1, v45
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532d         */ v_cndmask_b32   v41, v45, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a426921         */ v_xor_b32       v33, v33, v52
/*2a466723         */ v_xor_b32       v35, v35, v51
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850029 00023d30*/ v_mul_lo_u32    v41, v48, v30
/*2a5456b9         */ v_xor_b32       v42, 57, v43
/*d285002a 00023d2a*/ v_mul_lo_u32    v42, v42, v30
/*2a5a56bf         */ v_xor_b32       v45, 63, v43
/*2a5c56be         */ v_xor_b32       v46, 62, v43
/*2a5e56bd         */ v_xor_b32       v47, 61, v43
/*2a6056bc         */ v_xor_b32       v48, 60, v43
/*2a6256bb         */ v_xor_b32       v49, 59, v43
/*d86c0c00 33000032*/ ds_read_b32     v51, v50 offset:3072
/*7e680280         */ v_mov_b32       v52, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0033 00026687*/ v_lshlrev_b64   v[51:52], 7, v[51:52]
/*32666606         */ v_add_u32       v51, vcc, s6, v51
/*3868691c         */ v_addc_u32      v52, vcc, v28, v52, vcc
/*32663533         */ v_add_u32       v51, vcc, v51, v26
/*d11c6a34 01a90134*/ v_addc_u32      v52, vcc, v52, 0, vcc
/*d1196a35 00012133*/ v_add_u32       v53, vcc, v51, 16
/*d11c6a36 01a90134*/ v_addc_u32      v54, vcc, v52, 0, vcc
/*2a5656ba         */ v_xor_b32       v43, 58, v43
/*dc5c0000 35000035*/ flat_load_dwordx4 v[53:56], v[53:54] slc glc
/*dc5c0000 39000033*/ flat_load_dwordx4 v[57:60], v[51:52] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a7125         */ v_xor_b32       v37, v37, v56
/*2a585925         */ v_xor_b32       v44, v37, v44
/*d2860033 00025905*/ v_mul_hi_u32    v51, v5, v44
/*d2850033 00000333*/ v_mul_lo_u32    v51, v51, s1
/*3468672c         */ v_sub_u32       v52, vcc, v44, v51
/*d0ce0008 0002672c*/ v_cmp_ge_u32    s[8:9], v44, v51
/*36586801         */ v_subrev_u32    v44, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00585934         */ v_cndmask_b32   v44, v52, v44, vcc
/*32665801         */ v_add_u32       v51, vcc, s1, v44
/*d100002c 00225933*/ v_cndmask_b32   v44, v51, v44, s[8:9]
/*d100002c 002a58c1*/ v_cndmask_b32   v44, -1, v44, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002c15*/ ds_write_b32    v21, v44 offset:3072
/*2a4c6f26         */ v_xor_b32       v38, v38, v55
/*2a426d21         */ v_xor_b32       v33, v33, v54
/*2a466b23         */ v_xor_b32       v35, v35, v53
/*2a4e7927         */ v_xor_b32       v39, v39, v60
/*2a507728         */ v_xor_b32       v40, v40, v59
/*2a3e751f         */ v_xor_b32       v31, v31, v58
/*2a487324         */ v_xor_b32       v36, v36, v57
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d285002b 00023d2b*/ v_mul_lo_u32    v43, v43, v30
/*d285002c 00023d31*/ v_mul_lo_u32    v44, v49, v30
/*d2850030 00023d30*/ v_mul_lo_u32    v48, v48, v30
/*d285002f 00023d2f*/ v_mul_lo_u32    v47, v47, v30
/*d285002e 00023d2e*/ v_mul_lo_u32    v46, v46, v30
/*d285002d 00023d2d*/ v_mul_lo_u32    v45, v45, v30
/*d86c0c00 31000032*/ ds_read_b32     v49, v50 offset:3072
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0031 00026287*/ v_lshlrev_b64   v[49:50], 7, v[49:50]
/*32626206         */ v_add_u32       v49, vcc, s6, v49
/*3864651c         */ v_addc_u32      v50, vcc, v28, v50, vcc
/*32623531         */ v_add_u32       v49, vcc, v49, v26
/*d11c6a32 01a90132*/ v_addc_u32      v50, vcc, v50, 0, vcc
/*d1196a33 00012131*/ v_add_u32       v51, vcc, v49, 16
/*d11c6a34 01a90132*/ v_addc_u32      v52, vcc, v50, 0, vcc
/*dc5c0000 33000033*/ flat_load_dwordx4 v[51:54], v[51:52] slc glc
/*dc5c0000 37000031*/ flat_load_dwordx4 v[55:58], v[49:50] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a6d25         */ v_xor_b32       v37, v37, v54
/*2a4c6b26         */ v_xor_b32       v38, v38, v53
/*2a426921         */ v_xor_b32       v33, v33, v52
/*2a466723         */ v_xor_b32       v35, v35, v51
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7527         */ v_xor_b32       v39, v39, v58
/*2a507328         */ v_xor_b32       v40, v40, v57
/*2a3e711f         */ v_xor_b32       v31, v31, v56
/*2a486f24         */ v_xor_b32       v36, v36, v55
/*2a524929         */ v_xor_b32       v41, v41, v36
/*d2860031 00025305*/ v_mul_hi_u32    v49, v5, v41
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34646329         */ v_sub_u32       v50, vcc, v41, v49
/*d0ce0008 00026329*/ v_cmp_ge_u32    s[8:9], v41, v49
/*36526401         */ v_subrev_u32    v41, vcc, s1, v50
/*7d966401         */ v_cmp_le_u32    vcc, s1, v50
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00525332         */ v_cndmask_b32   v41, v50, v41, vcc
/*32625201         */ v_add_u32       v49, vcc, s1, v41
/*d1000029 00225331*/ v_cndmask_b32   v41, v49, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d86c0c00 31000000*/ ds_read_b32     v49, v0 offset:3072
/*7e640280         */ v_mov_b32       v50, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0031 00026287*/ v_lshlrev_b64   v[49:50], 7, v[49:50]
/*32526206         */ v_add_u32       v41, vcc, s6, v49
/*3862651c         */ v_addc_u32      v49, vcc, v28, v50, vcc
/*32683529         */ v_add_u32       v52, vcc, v41, v26
/*d11c6a35 01a90131*/ v_addc_u32      v53, vcc, v49, 0, vcc
/*d1196a31 00012134*/ v_add_u32       v49, vcc, v52, 16
/*d11c6a32 01a90135*/ v_addc_u32      v50, vcc, v53, 0, vcc
/*dc5c0000 34000034*/ flat_load_dwordx4 v[52:55], v[52:53] slc glc
/*dc5c0000 38000031*/ flat_load_dwordx4 v[56:59], v[49:50] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a3e6b1f         */ v_xor_b32       v31, v31, v53
/*2a52551f         */ v_xor_b32       v41, v31, v42
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34625529         */ v_sub_u32       v49, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36526201         */ v_subrev_u32    v41, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00525331         */ v_cndmask_b32   v41, v49, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7725         */ v_xor_b32       v37, v37, v59
/*2a4c7526         */ v_xor_b32       v38, v38, v58
/*2a486924         */ v_xor_b32       v36, v36, v52
/*2a467123         */ v_xor_b32       v35, v35, v56
/*2a427321         */ v_xor_b32       v33, v33, v57
/*2a4e6f27         */ v_xor_b32       v39, v39, v55
/*2a506d28         */ v_xor_b32       v40, v40, v54
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a06 00012129*/ v_add_u32       v6, vcc, v41, 16
/*d11c6a07 01a9012a*/ v_addc_u32      v7, vcc, v42, 0, vcc
/*dc5c0000 33000029*/ flat_load_dwordx4 v[51:54], v[41:42] slc glc
/*dc5c0000 37000006*/ flat_load_dwordx4 v[55:58], v[6:7] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a506b28         */ v_xor_b32       v40, v40, v53
/*2a525728         */ v_xor_b32       v41, v40, v43
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34565529         */ v_sub_u32       v43, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525601         */ v_subrev_u32    v41, vcc, s1, v43
/*7d965601         */ v_cmp_le_u32    vcc, s1, v43
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532b         */ v_cndmask_b32   v41, v43, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*2a4a7525         */ v_xor_b32       v37, v37, v58
/*2a4c7326         */ v_xor_b32       v38, v38, v57
/*2a3e691f         */ v_xor_b32       v31, v31, v52
/*2a486724         */ v_xor_b32       v36, v36, v51
/*2a466f23         */ v_xor_b32       v35, v35, v55
/*2a427121         */ v_xor_b32       v33, v33, v56
/*2a4e6d27         */ v_xor_b32       v39, v39, v54
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a31 00012129*/ v_add_u32       v49, vcc, v41, 16
/*d11c6a32 01a9012a*/ v_addc_u32      v50, vcc, v42, 0, vcc
/*dc5c0000 31000031*/ flat_load_dwordx4 v[49:52], v[49:50] slc glc
/*dc5c0000 35000029*/ flat_load_dwordx4 v[53:56], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426521         */ v_xor_b32       v33, v33, v50
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4e7127         */ v_xor_b32       v39, v39, v56
/*2a525927         */ v_xor_b32       v41, v39, v44
/*d286002a 00025305*/ v_mul_hi_u32    v42, v5, v41
/*d285002a 0000032a*/ v_mul_lo_u32    v42, v42, s1
/*34565529         */ v_sub_u32       v43, vcc, v41, v42
/*d0ce0008 00025529*/ v_cmp_ge_u32    s[8:9], v41, v42
/*36525601         */ v_subrev_u32    v41, vcc, s1, v43
/*7d965601         */ v_cmp_le_u32    vcc, s1, v43
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*0052532b         */ v_cndmask_b32   v41, v43, v41, vcc
/*32545201         */ v_add_u32       v42, vcc, s1, v41
/*d1000029 0022532a*/ v_cndmask_b32   v41, v42, v41, s[8:9]
/*d1000029 002a52c1*/ v_cndmask_b32   v41, -1, v41, s[10:11]
/*d81a0c00 00002915*/ ds_write_b32    v21, v41 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a506f28         */ v_xor_b32       v40, v40, v55
/*2a4a6925         */ v_xor_b32       v37, v37, v52
/*2a4c6726         */ v_xor_b32       v38, v38, v51
/*2a3e6d1f         */ v_xor_b32       v31, v31, v54
/*2a486b24         */ v_xor_b32       v36, v36, v53
/*2a466323         */ v_xor_b32       v35, v35, v49
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2b 00012129*/ v_add_u32       v43, vcc, v41, 16
/*d11c6a2c 01a9012a*/ v_addc_u32      v44, vcc, v42, 0, vcc
/*dc5c0000 3100002b*/ flat_load_dwordx4 v[49:52], v[43:44] slc glc
/*dc5c0000 29000029*/ flat_load_dwordx4 v[41:44], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426521         */ v_xor_b32       v33, v33, v50
/*2a466323         */ v_xor_b32       v35, v35, v49
/*2a606123         */ v_xor_b32       v48, v35, v48
/*d2860031 00026105*/ v_mul_hi_u32    v49, v5, v48
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*34646330         */ v_sub_u32       v50, vcc, v48, v49
/*d0ce0008 00026330*/ v_cmp_ge_u32    s[8:9], v48, v49
/*36606401         */ v_subrev_u32    v48, vcc, s1, v50
/*7d966401         */ v_cmp_le_u32    vcc, s1, v50
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*00606132         */ v_cndmask_b32   v48, v50, v48, vcc
/*32626001         */ v_add_u32       v49, vcc, s1, v48
/*d1000030 00226131*/ v_cndmask_b32   v48, v49, v48, s[8:9]
/*d1000030 002a60c1*/ v_cndmask_b32   v48, -1, v48, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00003015*/ ds_write_b32    v21, v48 offset:3072
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*2a505728         */ v_xor_b32       v40, v40, v43
/*2a4a6925         */ v_xor_b32       v37, v37, v52
/*2a4c6726         */ v_xor_b32       v38, v38, v51
/*2a3e551f         */ v_xor_b32       v31, v31, v42
/*2a485324         */ v_xor_b32       v36, v36, v41
/*2a4e5927         */ v_xor_b32       v39, v39, v44
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2b 00012129*/ v_add_u32       v43, vcc, v41, 16
/*d11c6a2c 01a9012a*/ v_addc_u32      v44, vcc, v42, 0, vcc
/*dc5c0000 3000002b*/ flat_load_dwordx4 v[48:51], v[43:44] slc glc
/*dc5c0000 29000029*/ flat_load_dwordx4 v[41:44], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a426321         */ v_xor_b32       v33, v33, v49
/*2a5e5f21         */ v_xor_b32       v47, v33, v47
/*d2860031 00025f05*/ v_mul_hi_u32    v49, v5, v47
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*3468632f         */ v_sub_u32       v52, vcc, v47, v49
/*d0ce0008 0002632f*/ v_cmp_ge_u32    s[8:9], v47, v49
/*365e6801         */ v_subrev_u32    v47, vcc, s1, v52
/*7d966801         */ v_cmp_le_u32    vcc, s1, v52
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005e5f34         */ v_cndmask_b32   v47, v52, v47, vcc
/*32625e01         */ v_add_u32       v49, vcc, s1, v47
/*d100002f 00225f31*/ v_cndmask_b32   v47, v49, v47, s[8:9]
/*d100002f 002a5ec1*/ v_cndmask_b32   v47, -1, v47, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002f15*/ ds_write_b32    v21, v47 offset:3072
/*2a4a6725         */ v_xor_b32       v37, v37, v51
/*2a4c6526         */ v_xor_b32       v38, v38, v50
/*2a466123         */ v_xor_b32       v35, v35, v48
/*2a3e551f         */ v_xor_b32       v31, v31, v42
/*2a485324         */ v_xor_b32       v36, v36, v41
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a4e5927         */ v_xor_b32       v39, v39, v44
/*2a505728         */ v_xor_b32       v40, v40, v43
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2b 00012129*/ v_add_u32       v43, vcc, v41, 16
/*d11c6a2c 01a9012a*/ v_addc_u32      v44, vcc, v42, 0, vcc
/*dc5c0000 2f00002b*/ flat_load_dwordx4 v[47:50], v[43:44] slc glc
/*dc5c0000 29000029*/ flat_load_dwordx4 v[41:44], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a6525         */ v_xor_b32       v37, v37, v50
/*2a4c6326         */ v_xor_b32       v38, v38, v49
/*2a5c5d26         */ v_xor_b32       v46, v38, v46
/*d2860031 00025d05*/ v_mul_hi_u32    v49, v5, v46
/*d2850031 00000331*/ v_mul_lo_u32    v49, v49, s1
/*3464632e         */ v_sub_u32       v50, vcc, v46, v49
/*d0ce0008 0002632e*/ v_cmp_ge_u32    s[8:9], v46, v49
/*365c6401         */ v_subrev_u32    v46, vcc, s1, v50
/*7d966401         */ v_cmp_le_u32    vcc, s1, v50
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*005c5d32         */ v_cndmask_b32   v46, v50, v46, vcc
/*32625c01         */ v_add_u32       v49, vcc, s1, v46
/*d100002e 00225d31*/ v_cndmask_b32   v46, v49, v46, s[8:9]
/*d100002e 002a5cc1*/ v_cndmask_b32   v46, -1, v46, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00002e15*/ ds_write_b32    v21, v46 offset:3072
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*2a426121         */ v_xor_b32       v33, v33, v48
/*2a465f23         */ v_xor_b32       v35, v35, v47
/*2a4e5927         */ v_xor_b32       v39, v39, v44
/*2a505728         */ v_xor_b32       v40, v40, v43
/*2a3e551f         */ v_xor_b32       v31, v31, v42
/*2a485324         */ v_xor_b32       v36, v36, v41
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850028 00023d28*/ v_mul_lo_u32    v40, v40, v30
/*d2850027 00023d27*/ v_mul_lo_u32    v39, v39, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d86c0c00 29000000*/ ds_read_b32     v41, v0 offset:3072
/*7e540280         */ v_mov_b32       v42, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0029 00025287*/ v_lshlrev_b64   v[41:42], 7, v[41:42]
/*32525206         */ v_add_u32       v41, vcc, s6, v41
/*3854551c         */ v_addc_u32      v42, vcc, v28, v42, vcc
/*32523529         */ v_add_u32       v41, vcc, v41, v26
/*d11c6a2a 01a9012a*/ v_addc_u32      v42, vcc, v42, 0, vcc
/*d1196a2b 00012129*/ v_add_u32       v43, vcc, v41, 16
/*d11c6a2c 01a9012a*/ v_addc_u32      v44, vcc, v42, 0, vcc
/*dc5c0000 2e00002b*/ flat_load_dwordx4 v[46:49], v[43:44] slc glc
/*dc5c0000 29000029*/ flat_load_dwordx4 v[41:44], v[41:42] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a4a6325         */ v_xor_b32       v37, v37, v49
/*2a5a5b25         */ v_xor_b32       v45, v37, v45
/*d2860005 00025b05*/ v_mul_hi_u32    v5, v5, v45
/*d2850005 00000305*/ v_mul_lo_u32    v5, v5, s1
/*34620b2d         */ v_sub_u32       v49, vcc, v45, v5
/*d0ce0008 00020b2d*/ v_cmp_ge_u32    s[8:9], v45, v5
/*360a6201         */ v_subrev_u32    v5, vcc, s1, v49
/*7d966201         */ v_cmp_le_u32    vcc, s1, v49
/*86ea6a08         */ s_and_b64       vcc, s[8:9], vcc
/*000a0b31         */ v_cndmask_b32   v5, v49, v5, vcc
/*325a0a01         */ v_add_u32       v45, vcc, s1, v5
/*d1000005 00220b2d*/ v_cndmask_b32   v5, v45, v5, s[8:9]
/*d1000005 002a0ac1*/ v_cndmask_b32   v5, -1, v5, s[10:11]
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*d81a0c00 00000515*/ ds_write_b32    v21, v5 offset:3072
/*2a0a6126         */ v_xor_b32       v5, v38, v48
/*2a2a5f21         */ v_xor_b32       v21, v33, v47
/*2a425d23         */ v_xor_b32       v33, v35, v46
/*2a465927         */ v_xor_b32       v35, v39, v44
/*2a4c5728         */ v_xor_b32       v38, v40, v43
/*2a3e551f         */ v_xor_b32       v31, v31, v42
/*2a485324         */ v_xor_b32       v36, v36, v41
/*d2850024 00023d24*/ v_mul_lo_u32    v36, v36, v30
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d2850026 00023d26*/ v_mul_lo_u32    v38, v38, v30
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*d2850021 00023d21*/ v_mul_lo_u32    v33, v33, v30
/*d2850015 00023d15*/ v_mul_lo_u32    v21, v21, v30
/*d2850005 00023d05*/ v_mul_lo_u32    v5, v5, v30
/*d2850025 00023d25*/ v_mul_lo_u32    v37, v37, v30
/*d86c0c00 27000000*/ ds_read_b32     v39, v0 offset:3072
/*7e500280         */ v_mov_b32       v40, 0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*d28f0027 00024e87*/ v_lshlrev_b64   v[39:40], 7, v[39:40]
/*32004e06         */ v_add_u32       v0, vcc, s6, v39
/*3838511c         */ v_addc_u32      v28, vcc, v28, v40, vcc
/*32563500         */ v_add_u32       v43, vcc, v0, v26
/*d11c6a2c 01a9011c*/ v_addc_u32      v44, vcc, v28, 0, vcc
/*d1196a27 0001212b*/ v_add_u32       v39, vcc, v43, 16
/*d11c6a28 01a9012c*/ v_addc_u32      v40, vcc, v44, 0, vcc
/*dc5c0000 27000027*/ flat_load_dwordx4 v[39:42], v[39:40] slc glc
/*dc5c0000 2b00002b*/ flat_load_dwordx4 v[43:46], v[43:44] slc glc
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a005525         */ v_xor_b32       v0, v37, v42
/*2a0a5305         */ v_xor_b32       v5, v5, v41
/*2a2a5115         */ v_xor_b32       v21, v21, v40
/*2a344f21         */ v_xor_b32       v26, v33, v39
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a385d23         */ v_xor_b32       v28, v35, v46
/*2a425b26         */ v_xor_b32       v33, v38, v45
/*2a3e591f         */ v_xor_b32       v31, v31, v44
/*2a465724         */ v_xor_b32       v35, v36, v43
/*d2850023 00023d23*/ v_mul_lo_u32    v35, v35, v30
/*2a3e3f23         */ v_xor_b32       v31, v35, v31
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*2a3e431f         */ v_xor_b32       v31, v31, v33
/*d285001f 00023d1f*/ v_mul_lo_u32    v31, v31, v30
/*d285001a 00023d1a*/ v_mul_lo_u32    v26, v26, v30
/*2a08391f         */ v_xor_b32       v4, v31, v28
/*2a2a2b1a         */ v_xor_b32       v21, v26, v21
/*d2850015 00023d15*/ v_mul_lo_u32    v21, v21, v30
/*2a0a0b15         */ v_xor_b32       v5, v21, v5
/*d2850005 00023d05*/ v_mul_lo_u32    v5, v5, v30
/*2a0a0105         */ v_xor_b32       v5, v5, v0
/*d89a0000 00000420*/ ds_write_b64    v32, v[4:5]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*bf8a0000         */ s_barrier
/*be86017e         */ s_mov_b64       s[6:7], exec
/*89fe0206         */ s_andn2_b64     exec, s[6:7], s[2:3]
/*bf88000c         */ s_cbranch_execz .L72672_0
/*d8ee0302 08000003*/ ds_read2_b64    v[8:11], v3 offset0:2 offset1:3
/*d8ee0100 57000003*/ ds_read2_b64    v[87:90], v3 offset1:1
/*bf8c017f         */ s_waitcnt       lgkmcnt(0)
/*7e9a0309         */ v_mov_b32       v77, v9
/*7e9c030b         */ v_mov_b32       v78, v11
/*7e36030a         */ v_mov_b32       v27, v10
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7eb60358         */ v_mov_b32       v91, v88
/*7ed0035a         */ v_mov_b32       v104, v90
/*7ece0359         */ v_mov_b32       v103, v89
.L72672_0:
/*befe0106         */ s_mov_b64       exec, s[6:7]
/*bf8a0000         */ s_barrier
/*7eb20280         */ v_mov_b32       v89, 0
/*7ec00280         */ v_mov_b32       v96, 0
/*7eb00280         */ v_mov_b32       v88, 0
/*7eb40280         */ v_mov_b32       v90, 0
/*7eb80280         */ v_mov_b32       v92, 0
/*7e060280         */ v_mov_b32       v3, 0
/*7eba0280         */ v_mov_b32       v93, 0
/*7e160280         */ v_mov_b32       v11, 0
/*7e180280         */ v_mov_b32       v12, 0
/*7e480280         */ v_mov_b32       v36, 0
/*7ec20280         */ v_mov_b32       v97, 0
/*7ec40280         */ v_mov_b32       v98, 0
/*7e400280         */ v_mov_b32       v32, 0
/*7e1a0280         */ v_mov_b32       v13, 0
/*7ec602ff 80000000*/ v_mov_b32       v99, 0x80000000
/*7e200281         */ v_mov_b32       v16, 1
/*7ec80280         */ v_mov_b32       v100, 0
/*7eca0280         */ v_mov_b32       v101, 0
/*7ecc0280         */ v_mov_b32       v102, 0
/*7ed20280         */ v_mov_b32       v105, 0
/*b0080000         */ s_movk_i32      s8, 0x0
/*7ed40280         */ v_mov_b32       v106, 0
/*7e580280         */ v_mov_b32       v44, 0
/*7e1c0280         */ v_mov_b32       v14, 0
/*7e600280         */ v_mov_b32       v48, 0
/*7e620280         */ v_mov_b32       v49, 0
/*7e420280         */ v_mov_b32       v33, 0
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
.L72800_0:
/*bf059608         */ s_cmp_le_i32    s8, 22
/*bf840180         */ s_cbranch_scc0  .L74344_0
/*bf008000         */ s_cmp_eq_i32    s0, 0
/*bf85fffc         */ s_cbranch_scc1  .L72800_0
/*2a66916b         */ v_xor_b32       v51, v107, v72
/*2a689747         */ v_xor_b32       v52, v71, v75
/*2a6a9546         */ v_xor_b32       v53, v70, v74
/*2a6a3735         */ v_xor_b32       v53, v53, v27
/*2a689d34         */ v_xor_b32       v52, v52, v78
/*2a661133         */ v_xor_b32       v51, v51, v8
/*2a6ca152         */ v_xor_b32       v54, v82, v80
/*2a6c6136         */ v_xor_b32       v54, v54, v48
/*2a6e936c         */ v_xor_b32       v55, v108, v73
/*2a6e9b37         */ v_xor_b32       v55, v55, v77
/*2a6c5936         */ v_xor_b32       v54, v54, v44
/*2a661733         */ v_xor_b32       v51, v51, v11
/*2a68c734         */ v_xor_b32       v52, v52, v99
/*2a6ab335         */ v_xor_b32       v53, v53, v89
/*2a70af55         */ v_xor_b32       v56, v85, v87
/*2a70bb38         */ v_xor_b32       v56, v56, v93
/*2a684334         */ v_xor_b32       v52, v52, v33
/*2a666333         */ v_xor_b32       v51, v51, v49
/*2a6c0736         */ v_xor_b32       v54, v54, v3
/*2a6ec537         */ v_xor_b32       v55, v55, v98
/*2a72d154         */ v_xor_b32       v57, v84, v104
/*2a72b139         */ v_xor_b32       v57, v57, v88
/*2a72c939         */ v_xor_b32       v57, v57, v100
/*2a70b938         */ v_xor_b32       v56, v56, v92
/*2a72cd39         */ v_xor_b32       v57, v57, v102
/*2a6a1b35         */ v_xor_b32       v53, v53, v13
/*2a6ed337         */ v_xor_b32       v55, v55, v105
/*2a749f51         */ v_xor_b32       v58, v81, v79
/*2a74213a         */ v_xor_b32       v58, v58, v16
/*2a74b53a         */ v_xor_b32       v58, v58, v90
/*2a74c13a         */ v_xor_b32       v58, v58, v96
/*d1ce003b 027e7536*/ v_alignbit_b32  v59, v54, v58, 31
/*2a767737         */ v_xor_b32       v59, v55, v59
/*d1ce003c 027e6d3a*/ v_alignbit_b32  v60, v58, v54, 31
/*2a787933         */ v_xor_b32       v60, v51, v60
/*d1ce003d 027e6b34*/ v_alignbit_b32  v61, v52, v53, 31
/*2a7a7b39         */ v_xor_b32       v61, v57, v61
/*2a701d38         */ v_xor_b32       v56, v56, v14
/*2a7cb756         */ v_xor_b32       v62, v86, v91
/*2a7c193e         */ v_xor_b32       v62, v62, v12
/*2a7cc33e         */ v_xor_b32       v62, v62, v97
/*2a7ccb3e         */ v_xor_b32       v62, v62, v101
/*2a527b6c         */ v_xor_b32       v41, v108, v61
/*2a24953c         */ v_xor_b32       v18, v60, v74
/*2a0e973b         */ v_xor_b32       v7, v59, v75
/*d1ce003f 027e7d38*/ v_alignbit_b32  v63, v56, v62, 31
/*2a7e7f35         */ v_xor_b32       v63, v53, v63
/*2a30213f         */ v_xor_b32       v24, v63, v16
/*d1ce0040 027e713e*/ v_alignbit_b32  v64, v62, v56, 31
/*2a808134         */ v_xor_b32       v64, v52, v64
/*2a606140         */ v_xor_b32       v48, v64, v48
/*d1ce0041 02566118*/ v_alignbit_b32  v65, v24, v48, 21
/*d1ce0042 02520f12*/ v_alignbit_b32  v66, v18, v7, 20
/*26868342         */ v_and_b32       v67, v66, v65
/*2a888329         */ v_xor_b32       v68, v41, v65
/*2a868943         */ v_xor_b32       v67, v67, v68
/*90099f08         */ s_ashr_i32      s9, s8, 31
/*8e828308         */ s_lshl_b64      s[2:3], s[8:9], 3
/*be8700ff 55555555*/ s_mov_b32       s7, .gdata>>32
/*be8600ff 55555555*/ s_mov_b32       s6, .gdata&0xffffffff
/*80020206         */ s_add_u32       s2, s6, s2
/*82030307         */ s_addc_u32      s3, s7, s3
/*c0060081 00000000*/ s_load_dwordx2  s[2:3], s[2:3], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*2ad88603         */ v_xor_b32       v108, s3, v67
/*d1ce0018 02563130*/ v_alignbit_b32  v24, v48, v24, 21
/*d1ce0007 02522507*/ v_alignbit_b32  v7, v7, v18, 20
/*d1ce0012 027e6935*/ v_alignbit_b32  v18, v53, v52, 31
/*2a60cf53         */ v_xor_b32       v48, v83, v103
/*2a604930         */ v_xor_b32       v48, v48, v36
/*2a604130         */ v_xor_b32       v48, v48, v32
/*2a60d530         */ v_xor_b32       v48, v48, v106
/*2a242530         */ v_xor_b32       v18, v48, v18
/*2a44256b         */ v_xor_b32       v34, v107, v18
/*26683107         */ v_and_b32       v52, v7, v24
/*2a6a3122         */ v_xor_b32       v53, v34, v24
/*2a686b34         */ v_xor_b32       v52, v52, v53
/*2ad66802         */ v_xor_b32       v107, s2, v52
/*d1ce0035 027e6f33*/ v_alignbit_b32  v53, v51, v55, 31
/*d1ce0033 027e6737*/ v_alignbit_b32  v51, v55, v51, 31
/*d1ce0037 027e6139*/ v_alignbit_b32  v55, v57, v48, 31
/*d1ce0030 027e7330*/ v_alignbit_b32  v48, v48, v57, 31
/*2a60613a         */ v_xor_b32       v48, v58, v48
/*2a66673e         */ v_xor_b32       v51, v62, v51
/*2a6a6b38         */ v_xor_b32       v53, v56, v53
/*2a6c6f36         */ v_xor_b32       v54, v54, v55
/*2a161712         */ v_xor_b32       v11, v18, v11
/*2a282508         */ v_xor_b32       v20, v8, v18
/*2a102548         */ v_xor_b32       v8, v72, v18
/*2a246312         */ v_xor_b32       v18, v18, v49
/*2a2c1b3c         */ v_xor_b32       v22, v60, v13
/*2a00b33c         */ v_xor_b32       v0, v60, v89
/*2a36373c         */ v_xor_b32       v27, v60, v27
/*2a4a7946         */ v_xor_b32       v37, v70, v60
/*2a56af30         */ v_xor_b32       v43, v48, v87
/*2a5eab30         */ v_xor_b32       v47, v48, v85
/*2a14bb30         */ v_xor_b32       v10, v48, v93
/*2a5a1d30         */ v_xor_b32       v45, v48, v14
/*2a0cb930         */ v_xor_b32       v6, v48, v92
/*2a26a540         */ v_xor_b32       v19, v64, v82
/*2a3aa140         */ v_xor_b32       v29, v64, v80
/*2a120740         */ v_xor_b32       v9, v64, v3
/*2a585940         */ v_xor_b32       v44, v64, v44
/*2a5ca33f         */ v_xor_b32       v46, v63, v81
/*2a389f3f         */ v_xor_b32       v28, v63, v79
/*2a04c13f         */ v_xor_b32       v2, v63, v96
/*2a0ab53f         */ v_xor_b32       v5, v63, v90
/*2a60433b         */ v_xor_b32       v48, v59, v33
/*2a087747         */ v_xor_b32       v4, v71, v59
/*2a2ec73b         */ v_xor_b32       v23, v59, v99
/*2a349d3b         */ v_xor_b32       v26, v59, v78
/*2a1a4935         */ v_xor_b32       v13, v53, v36
/*2a4ecf35         */ v_xor_b32       v39, v53, v103
/*2a204135         */ v_xor_b32       v16, v53, v32
/*2a50d535         */ v_xor_b32       v40, v53, v106
/*2a40a735         */ v_xor_b32       v32, v53, v83
/*2a06b133         */ v_xor_b32       v3, v51, v88
/*2a46d133         */ v_xor_b32       v35, v51, v104
/*2a32c933         */ v_xor_b32       v25, v51, v100
/*2a3ecd33         */ v_xor_b32       v31, v51, v102
/*2a48a933         */ v_xor_b32       v36, v51, v84
/*2a1ec53d         */ v_xor_b32       v15, v61, v98
/*2a2a7b4d         */ v_xor_b32       v21, v77, v61
/*2a227b49         */ v_xor_b32       v17, v73, v61
/*2a4cd33d         */ v_xor_b32       v38, v61, v105
/*2a42b736         */ v_xor_b32       v33, v54, v91
/*2a54ad36         */ v_xor_b32       v42, v54, v86
/*2a181936         */ v_xor_b32       v12, v54, v12
/*2a1cc336         */ v_xor_b32       v14, v54, v97
/*2a3ccb36         */ v_xor_b32       v30, v54, v101
/*bf800000         */ /*s_nop           0x0*/
/*d1ce0031 02661b03*/ v_alignbit_b32  v49, v3, v13, 25
/*d1ce0003 0266070d*/ v_alignbit_b32  v3, v13, v3, 25
/*d1ce000d 02265721*/ v_alignbit_b32  v13, v33, v43, 9
/*d1ce0021 0226432b*/ v_alignbit_b32  v33, v43, v33, 9
/*d1ce002b 025e170f*/ v_alignbit_b32  v43, v15, v11, 23
/*d1ce000b 025e1f0b*/ v_alignbit_b32  v11, v11, v15, 23
/*d1ce000f 027a6116*/ v_alignbit_b32  v15, v22, v48, 30
/*d1ce0016 027a2d30*/ v_alignbit_b32  v22, v48, v22, 30
/*d1ce0030 020a5d13*/ v_alignbit_b32  v48, v19, v46, 2
/*d1ce0013 020a272e*/ v_alignbit_b32  v19, v46, v19, 2
/*d1ce002e 02324f23*/ v_alignbit_b32  v46, v35, v39, 12
/*d1ce0023 02324727*/ v_alignbit_b32  v35, v39, v35, 12
/*d1ce0027 02125f2a*/ v_alignbit_b32  v39, v42, v47, 4
/*d1ce002a 0212552f*/ v_alignbit_b32  v42, v47, v42, 4
/*d1ce002f 02762915*/ v_alignbit_b32  v47, v21, v20, 29
/*d1ce0014 02762b14*/ v_alignbit_b32  v20, v20, v21, 29
/*d1ce0015 024e2f00*/ v_alignbit_b32  v21, v0, v23, 19
/*d1ce0000 024e0117*/ v_alignbit_b32  v0, v23, v0, 19
/*d1ce0017 020e1302*/ v_alignbit_b32  v23, v2, v9, 3
/*d1ce0002 020e0509*/ v_alignbit_b32  v2, v9, v2, 3
/*d1ce0009 026a391d*/ v_alignbit_b32  v9, v29, v28, 26
/*d1ce001c 026a3b1c*/ v_alignbit_b32  v28, v28, v29, 26
/*d1ce001d 027e4b04*/ v_alignbit_b32  v29, v4, v37, 31
/*d1ce0004 027e0925*/ v_alignbit_b32  v4, v37, v4, 31
/*d1ce0025 021e150c*/ v_alignbit_b32  v37, v12, v10, 7
/*d1ce000a 021e190a*/ v_alignbit_b32  v10, v10, v12, 7
/*d1cf000c 020e2119*/ v_alignbyte_b32 v12, v25, v16, 3
/*d1cf0010 020e3310*/ v_alignbyte_b32 v16, v16, v25, 3
/*d1ce0019 023a2526*/ v_alignbit_b32  v25, v38, v18, 14
/*d1ce0012 023a4d12*/ v_alignbit_b32  v18, v18, v38, 14
/*d1ce0026 02721111*/ v_alignbit_b32  v38, v17, v8, 28
/*d1ce0008 02722308*/ v_alignbit_b32  v8, v8, v17, 28
/*d1ce0011 02164920*/ v_alignbit_b32  v17, v32, v36, 5
/*d1ce0020 02164124*/ v_alignbit_b32  v32, v36, v32, 5
/*d1ce0024 025a351b*/ v_alignbit_b32  v36, v27, v26, 22
/*d1ce001a 025a371a*/ v_alignbit_b32  v26, v26, v27, 22
/*d1ce001b 02465905*/ v_alignbit_b32  v27, v5, v44, 17
/*d1ce0005 02460b2c*/ v_alignbit_b32  v5, v44, v5, 17
/*d1cf002c 02065b1e*/ v_alignbyte_b32 v44, v30, v45, 1
/*d1cf001e 02063d2d*/ v_alignbyte_b32 v30, v45, v30, 1
/*d1ce002d 024a3f28*/ v_alignbit_b32  v45, v40, v31, 18
/*d1ce001f 024a511f*/ v_alignbit_b32  v31, v31, v40, 18
/*d1ce0028 022e1d06*/ v_alignbit_b32  v40, v6, v14, 11
/*d1ce0006 022e0d0e*/ v_alignbit_b32  v6, v14, v6, 11
/*261c1f30         */ v_and_b32       v14, v48, v15
/*2a645730         */ v_xor_b32       v50, v48, v43
/*26661b30         */ v_and_b32       v51, v48, v13
/*2a606330         */ v_xor_b32       v48, v48, v49
/*2a6a1f0d         */ v_xor_b32       v53, v13, v15
/*266c630d         */ v_and_b32       v54, v13, v49
/*2a1a570d         */ v_xor_b32       v13, v13, v43
/*266e632b         */ v_and_b32       v55, v43, v49
/*2656570f         */ v_and_b32       v43, v15, v43
/*2a1e1f31         */ v_xor_b32       v15, v49, v15
/*26622d13         */ v_and_b32       v49, v19, v22
/*2a701713         */ v_xor_b32       v56, v19, v11
/*26724313         */ v_and_b32       v57, v19, v33
/*2a260713         */ v_xor_b32       v19, v19, v3
/*2a742d21         */ v_xor_b32       v58, v33, v22
/*26760721         */ v_and_b32       v59, v33, v3
/*2a421721         */ v_xor_b32       v33, v33, v11
/*2678070b         */ v_and_b32       v60, v11, v3
/*26161716         */ v_and_b32       v11, v22, v11
/*2a062d03         */ v_xor_b32       v3, v3, v22
/*262c5f15         */ v_and_b32       v22, v21, v47
/*2a7a2b2e         */ v_xor_b32       v61, v46, v21
/*267c2b17         */ v_and_b32       v62, v23, v21
/*2a2a2b27         */ v_xor_b32       v21, v39, v21
/*2a7e2f2f         */ v_xor_b32       v63, v47, v23
/*26802f27         */ v_and_b32       v64, v39, v23
/*2a2e2f2e         */ v_xor_b32       v23, v46, v23
/*2a885f27         */ v_xor_b32       v68, v39, v47
/*264e5d27         */ v_and_b32       v39, v39, v46
/*265c5f2e         */ v_and_b32       v46, v46, v47
/*265e0102         */ v_and_b32       v47, v2, v0
/*2a8a0514         */ v_xor_b32       v69, v20, v2
/*268c052a         */ v_and_b32       v70, v42, v2
/*2a040523         */ v_xor_b32       v2, v35, v2
/*2a8e292a         */ v_xor_b32       v71, v42, v20
/*26902900         */ v_and_b32       v72, v0, v20
/*26282923         */ v_and_b32       v20, v35, v20
/*2a920123         */ v_xor_b32       v73, v35, v0
/*2646472a         */ v_and_b32       v35, v42, v35
/*2a00012a         */ v_xor_b32       v0, v42, v0
/*26544b0c         */ v_and_b32       v42, v12, v37
/*2a941909         */ v_xor_b32       v74, v9, v12
/*26961919         */ v_and_b32       v75, v25, v12
/*2a18191d         */ v_xor_b32       v12, v29, v12
/*2a984b1d         */ v_xor_b32       v76, v29, v37
/*269a331d         */ v_and_b32       v77, v29, v25
/*263a131d         */ v_and_b32       v29, v29, v9
/*2a9c3309         */ v_xor_b32       v78, v9, v25
/*26124b09         */ v_and_b32       v9, v9, v37
/*2a323325         */ v_xor_b32       v25, v37, v25
/*264a2112         */ v_and_b32       v37, v18, v16
/*2a9e250a         */ v_xor_b32       v79, v10, v18
/*26a02504         */ v_and_b32       v80, v4, v18
/*2a24251c         */ v_xor_b32       v18, v28, v18
/*2aa21504         */ v_xor_b32       v81, v4, v10
/*26a41510         */ v_and_b32       v82, v16, v10
/*2614151c         */ v_and_b32       v10, v28, v10
/*2aa6211c         */ v_xor_b32       v83, v28, v16
/*26383904         */ v_and_b32       v28, v4, v28
/*2a082104         */ v_xor_b32       v4, v4, v16
/*2620491b         */ v_and_b32       v16, v27, v36
/*2aa83726         */ v_xor_b32       v84, v38, v27
/*26aa372c         */ v_and_b32       v85, v44, v27
/*2a363711         */ v_xor_b32       v27, v17, v27
/*2aac5924         */ v_xor_b32       v86, v36, v44
/*26ae5911         */ v_and_b32       v87, v17, v44
/*2a585926         */ v_xor_b32       v44, v38, v44
/*2ab04911         */ v_xor_b32       v88, v17, v36
/*26224d11         */ v_and_b32       v17, v17, v38
/*26484926         */ v_and_b32       v36, v38, v36
/*264c0b1e         */ v_and_b32       v38, v30, v5
/*2ab23d1a         */ v_xor_b32       v89, v26, v30
/*26b43d20         */ v_and_b32       v90, v32, v30
/*2a3c3d08         */ v_xor_b32       v30, v8, v30
/*2ab63520         */ v_xor_b32       v91, v32, v26
/*2ab80b20         */ v_xor_b32       v92, v32, v5
/*26401120         */ v_and_b32       v32, v32, v8
/*26ba3505         */ v_and_b32       v93, v5, v26
/*26343508         */ v_and_b32       v26, v8, v26
/*2a0a0b08         */ v_xor_b32       v5, v8, v5
/*2acc7539         */ v_xor_b32       v102, v57, v58
/*2ad46b33         */ v_xor_b32       v106, v51, v53
/*2aca6338         */ v_xor_b32       v101, v56, v49
/*2a1c1d32         */ v_xor_b32       v14, v50, v14
/*26643128         */ v_and_b32       v50, v40, v24
/*2a305b18         */ v_xor_b32       v24, v24, v45
/*2a6a5b07         */ v_xor_b32       v53, v7, v45
/*2670512d         */ v_and_b32       v56, v45, v40
/*265a5b22         */ v_and_b32       v45, v34, v45
/*2a725107         */ v_xor_b32       v57, v7, v40
/*2a505122         */ v_xor_b32       v40, v34, v40
/*260e0f22         */ v_and_b32       v7, v34, v7
/*26448306         */ v_and_b32       v34, v6, v65
/*2a743f41         */ v_xor_b32       v58, v65, v31
/*2a823f42         */ v_xor_b32       v65, v66, v31
/*26bc0d1f         */ v_and_b32       v94, v31, v6
/*263e3f29         */ v_and_b32       v31, v41, v31
/*2abe0d42         */ v_xor_b32       v95, v66, v6
/*2a0c0d29         */ v_xor_b32       v6, v41, v6
/*26528529         */ v_and_b32       v41, v41, v66
/*2a061703         */ v_xor_b32       v3, v3, v11
/*2ac0570f         */ v_xor_b32       v96, v15, v43
/*2a427921         */ v_xor_b32       v33, v33, v60
/*2a1a6f0d         */ v_xor_b32       v13, v13, v55
/*2ad2273b         */ v_xor_b32       v105, v59, v19
/*2a626136         */ v_xor_b32       v49, v54, v48
/*2ac83d20         */ v_xor_b32       v100, v32, v30
/*2a405911         */ v_xor_b32       v32, v17, v44
/*2ac2b55c         */ v_xor_b32       v97, v92, v90
/*2ab8af1b         */ v_xor_b32       v92, v27, v87
/*2a584d59         */ v_xor_b32       v44, v89, v38
/*2ab4ab56         */ v_xor_b32       v90, v86, v85
/*2ac6bb05         */ v_xor_b32       v99, v5, v93
/*2ab22154         */ v_xor_b32       v89, v84, v16
/*2ac4b71a         */ v_xor_b32       v98, v26, v91
/*2a16b124         */ v_xor_b32       v11, v36, v88
/*2ab09d1d         */ v_xor_b32       v88, v29, v78
/*2a48251c         */ v_xor_b32       v36, v28, v18
/*2a189b0c         */ v_xor_b32       v12, v12, v77
/*2abaa104         */ v_xor_b32       v93, v4, v80
/*2a609719         */ v_xor_b32       v48, v25, v75
/*2a204b4f         */ v_xor_b32       v16, v79, v37
/*2a9c554a         */ v_xor_b32       v78, v74, v42
/*2a36a553         */ v_xor_b32       v27, v83, v82
/*2a9a9909         */ v_xor_b32       v77, v9, v76
/*2a10a30a         */ v_xor_b32       v8, v10, v81
/*2ad02f27         */ v_xor_b32       v104, v39, v23
/*2ace0523         */ v_xor_b32       v103, v35, v2
/*2ab68115         */ v_xor_b32       v91, v21, v64
/*2aae8d00         */ v_xor_b32       v87, v0, v70
/*2aa07d3f         */ v_xor_b32       v80, v63, v62
/*2a9e5f45         */ v_xor_b32       v79, v69, v47
/*2a962d3d         */ v_xor_b32       v75, v61, v22
/*2a949149         */ v_xor_b32       v74, v73, v72
/*2a92892e         */ v_xor_b32       v73, v46, v68
/*2a908f14         */ v_xor_b32       v72, v20, v71
/*2aa4bd3a         */ v_xor_b32       v82, v58, v94
/*2aa27118         */ v_xor_b32       v81, v24, v56
/*2a8e455f         */ v_xor_b32       v71, v95, v34
/*2aa88329         */ v_xor_b32       v84, v41, v65
/*2a8c6539         */ v_xor_b32       v70, v57, v50
/*2aa66b07         */ v_xor_b32       v83, v7, v53
/*2aac3f06         */ v_xor_b32       v86, v6, v31
/*2aaa5b28         */ v_xor_b32       v85, v40, v45
/*80088108         */ s_add_u32       s8, s8, 1
/*bf82fe7e         */ s_branch        .L72800_0
.L74344_0:
/*c0060002 00000058*/ s_load_dwordx2  s[0:1], s[4:5], 0x58
/*2a26a152         */ v_xor_b32       v19, v82, v80
/*2a389f51         */ v_xor_b32       v28, v81, v79
/*2a22936c         */ v_xor_b32       v17, v108, v73
/*2a38211c         */ v_xor_b32       v28, v28, v16
/*2a266113         */ v_xor_b32       v19, v19, v48
/*2a265913         */ v_xor_b32       v19, v19, v44
/*2a0ab51c         */ v_xor_b32       v5, v28, v90
/*2a229b11         */ v_xor_b32       v17, v17, v77
/*2a2aaf55         */ v_xor_b32       v21, v85, v87
/*2a1ec511         */ v_xor_b32       v15, v17, v98
/*2a22b756         */ v_xor_b32       v17, v86, v91
/*2a04c105         */ v_xor_b32       v2, v5, v96
/*2a0a0713         */ v_xor_b32       v5, v19, v3
/*d1ce0009 027e0505*/ v_alignbit_b32  v9, v5, v2, 31
/*2a089747         */ v_xor_b32       v4, v71, v75
/*2a181911         */ v_xor_b32       v12, v17, v12
/*2a1ed30f         */ v_xor_b32       v15, v15, v105
/*2a14bb15         */ v_xor_b32       v10, v21, v93
/*2a0cb90a         */ v_xor_b32       v6, v10, v92
/*2a12130f         */ v_xor_b32       v9, v15, v9
/*2a14c30c         */ v_xor_b32       v10, v12, v97
/*2a089d04         */ v_xor_b32       v4, v4, v78
/*2a08c704         */ v_xor_b32       v4, v4, v99
/*2a084304         */ v_xor_b32       v4, v4, v33
/*2a0c1d06         */ v_xor_b32       v6, v6, v14
/*2a14cb0a         */ v_xor_b32       v10, v10, v101
/*2a0e9709         */ v_xor_b32       v7, v9, v75
/*d1ce0009 027e0d0a*/ v_alignbit_b32  v9, v10, v6, 31
/*2a121304         */ v_xor_b32       v9, v4, v9
/*d1ce0002 027e0b02*/ v_alignbit_b32  v2, v2, v5, 31
/*2a0a916b         */ v_xor_b32       v5, v107, v72
/*2a0a1105         */ v_xor_b32       v5, v5, v8
/*2a0a1705         */ v_xor_b32       v5, v5, v11
/*2a0a6305         */ v_xor_b32       v5, v5, v49
/*2a040505         */ v_xor_b32       v2, v5, v2
/*2a049502         */ v_xor_b32       v2, v2, v74
/*d1ce0005 02520507*/ v_alignbit_b32  v5, v7, v2, 20
/*2a106109         */ v_xor_b32       v8, v9, v48
/*d1ce0006 027e1506*/ v_alignbit_b32  v6, v6, v10, 31
/*2a129546         */ v_xor_b32       v9, v70, v74
/*2a123709         */ v_xor_b32       v9, v9, v27
/*2a00b309         */ v_xor_b32       v0, v9, v89
/*2a001b00         */ v_xor_b32       v0, v0, v13
/*2a0c0d00         */ v_xor_b32       v6, v0, v6
/*2a0c2106         */ v_xor_b32       v6, v6, v16
/*d1ce0009 02560d08*/ v_alignbit_b32  v9, v8, v6, 21
/*260a0b09         */ v_and_b32       v5, v9, v5
/*d1ce000a 027e0900*/ v_alignbit_b32  v10, v0, v4, 31
/*2a16cf53         */ v_xor_b32       v11, v83, v103
/*2a16490b         */ v_xor_b32       v11, v11, v36
/*2a16410b         */ v_xor_b32       v11, v11, v32
/*2a16d50b         */ v_xor_b32       v11, v11, v106
/*2a14150b         */ v_xor_b32       v10, v11, v10
/*2a14156b         */ v_xor_b32       v10, v107, v10
/*2a12130a         */ v_xor_b32       v9, v10, v9
/*2a0a0b09         */ v_xor_b32       v5, v9, v5
/*2a0a0aff 80008008*/ v_xor_b32       v5, 0x80008008, v5
/*24120a88         */ v_lshlrev_b32   v9, 8, v5
/*281212f9 06010605*/ v_or_b32        v9, v5, v9 src0_sel:byte1
/*d1ce0002 02520f02*/ v_alignbit_b32  v2, v2, v7, 20
/*d1ce0006 02561106*/ v_alignbit_b32  v6, v6, v8, 21
/*26040506         */ v_and_b32       v2, v6, v2
/*d1ce0000 027e0104*/ v_alignbit_b32  v0, v4, v0, 31
/*2a08d154         */ v_xor_b32       v4, v84, v104
/*2a06b104         */ v_xor_b32       v3, v4, v88
/*2a06c903         */ v_xor_b32       v3, v3, v100
/*2a06cd03         */ v_xor_b32       v3, v3, v102
/*2a000103         */ v_xor_b32       v0, v3, v0
/*2a00016c         */ v_xor_b32       v0, v108, v0
/*2a000d00         */ v_xor_b32       v0, v0, v6
/*be8200ff 05040203*/ s_mov_b32       s2, 0x5040203
/*d1ed0003 000a0b09*/ v_perm_b32      v3, v9, v5, s2
/*2a000500         */ v_xor_b32       v0, v0, v2
/*2a0000ff 80000000*/ v_xor_b32       v0, 0x80000000, v0
/*24040088         */ v_lshlrev_b32   v2, 8, v0
/*280404f9 06010600*/ v_or_b32        v2, v0, v2 src0_sel:byte1
/*d1ed0002 000a0102*/ v_perm_b32      v2, v2, v0, s2
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*7dd80400         */ v_cmp_gt_u64    vcc, s[0:1], v[2:3]
/*be80206a         */ s_and_saveexec_b64 s[0:1], vcc
/*bf880016         */ s_cbranch_execz .L74832_0
/*c0060082 00000030*/ s_load_dwordx2  s[2:3], s[4:5], 0x30
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*8004ff02 000003fc*/ s_add_u32       s4, s2, 0x3fc
/*82058003         */ s_addc_u32      s5, s3, 0
/*7e000281         */ v_mov_b32       v0, 1
/*7e040204         */ v_mov_b32       v2, s4
/*7e060205         */ v_mov_b32       v3, s5
/*dd090000 00000002*/ flat_atomic_add v0, v[2:3], v0 glc slc glc
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*1c0400ff 000000fe*/ v_min_u32       v2, 0xfe, v0
/*7e060280         */ v_mov_b32       v3, 0
/*d28f0002 00020482*/ v_lshlrev_b64   v[2:3], 2, v[2:3]
/*32080402         */ v_add_u32       v4, vcc, s2, v2
/*7e040203         */ v_mov_b32       v2, s3
/*380a0702         */ v_addc_u32      v5, vcc, v2, v3, vcc
/*dc700000 00000104*/ flat_store_dword v[4:5], v1 slc glc
.L74832_0:
/*bf810000         */ s_endpgm
.kernel GenerateDAG
    .config
        .dims x
        .sgprsnum 21
        .vgprsnum 128
        .floatmode 0xc0
        .pgmrsrc1 0x00ac009f
        .pgmrsrc2 0x00000090
        .dx10clamp
        .ieeemode
        .useargs
        .usesetup
        .priority 0
        .arg _.global_offset_0, "size_t", long
        .arg _.global_offset_1, "size_t", long
        .arg _.global_offset_2, "size_t", long
        .arg _.printf_buffer, "size_t", void*, global, , rdonly
        .arg _.vqueue_pointer, "size_t", long
        .arg _.aqlwrap_pointer, "size_t", long
        .arg start, "uint", uint
        .arg _Cache, "uint16*", uint16*, global, const, rdonly
        .arg _DAG, "uint16*", uint16*, global, 
        .arg LIGHT_SIZE, "uint", uint
        .arg isolate, "uint", uint
    .text
/*c0020102 00000004*/ s_load_dword    s4, s[4:5], 0x4
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*8604ff04 0000ffff*/ s_and_b32       s4, s4, 0xffff
/*92040804         */ s_mul_i32       s4, s4, s8
/*32000004         */ v_add_u32       v0, vcc, s4, v0
/*c0060103 00000000*/ s_load_dwordx2  s[4:5], s[6:7], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*c0020143 00000030*/ s_load_dword    s5, s[6:7], 0x30
/*c0060283 00000048*/ s_load_dwordx2  s[10:11], s[6:7], 0x48
/*c0060303 00000038*/ s_load_dwordx2  s[12:13], s[6:7], 0x38
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*80040504         */ s_add_u32       s4, s4, s5
/*32000004         */ v_add_u32       v0, vcc, s4, v0
/*7e020c0a         */ v_cvt_f32_u32   v1, s10
/*7e024501         */ v_rcp_f32       v1, v1
/*0a0202ff 4f800000*/ v_mul_f32       v1, 0x4f800000 /* 4.2949673e+9f */, v1
/*7e020f01         */ v_cvt_u32_f32   v1, v1
/*d2850002 0002020a*/ v_mul_lo_u32    v2, s10, v1
/*d2860003 0002020a*/ v_mul_hi_u32    v3, s10, v1
/*34080480         */ v_sub_u32       v4, vcc, 0, v2
/*d0c50004 00020680*/ v_cmp_lg_i32    s[4:5], 0, v3
/*d1000005 00120504*/ v_cndmask_b32   v5, v4, v2, s[4:5]
/*d2860005 00020305*/ v_mul_hi_u32    v5, v5, v1
/*340c0b01         */ v_sub_u32       v6, vcc, v1, v5
/*320a0b01         */ v_add_u32       v5, vcc, v1, v5
/*d1000005 00120d05*/ v_cndmask_b32   v5, v5, v6, s[4:5]
/*d2860005 00020105*/ v_mul_hi_u32    v5, v5, v0
/*d2850005 00001505*/ v_mul_lo_u32    v5, v5, s10
/*340c0b00         */ v_sub_u32       v6, vcc, v0, v5
/*d0ce0004 00020b00*/ v_cmp_ge_u32    s[4:5], v0, v5
/*360a0c0a         */ v_subrev_u32    v5, vcc, s10, v6
/*7d960c0a         */ v_cmp_le_u32    vcc, s10, v6
/*86ea6a04         */ s_and_b64       vcc, s[4:5], vcc
/*000a0b06         */ v_cndmask_b32   v5, v6, v5, vcc
/*320c0a0a         */ v_add_u32       v6, vcc, s10, v5
/*d1000005 00120b06*/ v_cndmask_b32   v5, v6, v5, s[4:5]
/*d0c5006a 00001480*/ v_cmp_lg_i32    vcc, 0, s10
/*000a0ac1         */ v_cndmask_b32   v5, -1, v5, vcc
/*7e0c0280         */ v_mov_b32       v6, 0
/*d28f0005 00020a86*/ v_lshlrev_b64   v[5:6], 6, v[5:6]
/*320a0a0c         */ v_add_u32       v5, vcc, s12, v5
/*7e0e020d         */ v_mov_b32       v7, s13
/*380c0d07         */ v_addc_u32      v6, vcc, v7, v6, vcc
/*d1196a07 00016105*/ v_add_u32       v7, vcc, v5, 48
/*d11c6a08 01a90106*/ v_addc_u32      v8, vcc, v6, 0, vcc
/*d1196a09 00014105*/ v_add_u32       v9, vcc, v5, 32
/*d11c6a0a 01a90106*/ v_addc_u32      v10, vcc, v6, 0, vcc
/*d1196a0b 00012105*/ v_add_u32       v11, vcc, v5, 16
/*d11c6a0c 01a90106*/ v_addc_u32      v12, vcc, v6, 0, vcc
/*dc5c0000 52000007*/ flat_load_dwordx4 v[82:85], v[7:8] slc glc
/*dc5c0000 4a000009*/ flat_load_dwordx4 v[74:77], v[9:10] slc glc
/*dc5c0000 6000000b*/ flat_load_dwordx4 v[96:99], v[11:12] slc glc
/*dc5c0000 0a000005*/ flat_load_dwordx4 v[10:13], v[5:6] slc glc
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2adc010a         */ v_xor_b32       v110, v10, v0
/*7eb00280         */ v_mov_b32       v88, 0
/*7eb20280         */ v_mov_b32       v89, 0
/*7eb40280         */ v_mov_b32       v90, 0
/*7eb60280         */ v_mov_b32       v91, 0
/*7eba0280         */ v_mov_b32       v93, 0
/*7ebc0280         */ v_mov_b32       v94, 0
/*7ec80280         */ v_mov_b32       v100, 0
/*7eca0280         */ v_mov_b32       v101, 0
/*7ecc0280         */ v_mov_b32       v102, 0
/*7ece0280         */ v_mov_b32       v103, 0
/*7ed00280         */ v_mov_b32       v104, 0
/*7ed20280         */ v_mov_b32       v105, 0
/*7ed40280         */ v_mov_b32       v106, 0
/*7ed60280         */ v_mov_b32       v107, 0
/*7ed80280         */ v_mov_b32       v108, 0
/*7e420360         */ v_mov_b32       v33, v96
/*7eda0280         */ v_mov_b32       v109, 0
/*b0040000         */ s_movk_i32      s4, 0x0
/*7ede0280         */ v_mov_b32       v111, 0
/*7e4c0281         */ v_mov_b32       v38, 1
/*7e4e02ff 80000000*/ v_mov_b32       v39, 0x80000000
/*7e8e030b         */ v_mov_b32       v71, v11
/*7e9c0280         */ v_mov_b32       v78, 0
/*7e560280         */ v_mov_b32       v43, 0
/*7e9e0280         */ v_mov_b32       v79, 0
/*7e260280         */ v_mov_b32       v19, 0
/*7e5c0280         */ v_mov_b32       v46, 0
/*7e3c0280         */ v_mov_b32       v30, 0
/*7e8c0280         */ v_mov_b32       v70, 0
/*7ea20280         */ v_mov_b32       v81, 0
/*7e640280         */ v_mov_b32       v50, 0
/*7e660280         */ v_mov_b32       v51, 0
/*7e680280         */ v_mov_b32       v52, 0
/*7e6a0280         */ v_mov_b32       v53, 0
/*7ebe0280         */ v_mov_b32       v95, 0
/*7ec00280         */ v_mov_b32       v96, 0
/*7e160280         */ v_mov_b32       v11, 0
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
.L512_1:
/*bf059604         */ s_cmp_le_i32    s4, 22
/*bf840180         */ s_cbranch_scc0  .L2056_1
/*bf00800b         */ s_cmp_eq_i32    s11, 0
/*bf85fffc         */ s_cbranch_scc1  .L512_1
/*2a6e996e         */ v_xor_b32       v55, v110, v76
/*2a70a70d         */ v_xor_b32       v56, v13, v83
/*2a72a50c         */ v_xor_b32       v57, v12, v82
/*2a723d39         */ v_xor_b32       v57, v57, v30
/*2a705d38         */ v_xor_b32       v56, v56, v46
/*2a6e2737         */ v_xor_b32       v55, v55, v19
/*2a74ab61         */ v_xor_b32       v58, v97, v85
/*2a748d3a         */ v_xor_b32       v58, v58, v70
/*2a769b47         */ v_xor_b32       v59, v71, v77
/*2a769f3b         */ v_xor_b32       v59, v59, v79
/*2a74b73a         */ v_xor_b32       v58, v58, v91
/*2a6eb137         */ v_xor_b32       v55, v55, v88
/*2a70b338         */ v_xor_b32       v56, v56, v89
/*2a72b539         */ v_xor_b32       v57, v57, v90
/*2a784d62         */ v_xor_b32       v60, v98, v38
/*2a78673c         */ v_xor_b32       v60, v60, v51
/*2a70d138         */ v_xor_b32       v56, v56, v104
/*2a6ecf37         */ v_xor_b32       v55, v55, v103
/*2a74d53a         */ v_xor_b32       v58, v58, v106
/*2a76bf3b         */ v_xor_b32       v59, v59, v95
/*2a7a9d4b         */ v_xor_b32       v61, v75, v78
/*2a7a693d         */ v_xor_b32       v61, v61, v52
/*2a7ac93d         */ v_xor_b32       v61, v61, v100
/*2a78c13c         */ v_xor_b32       v60, v60, v96
/*2a7adb3d         */ v_xor_b32       v61, v61, v109
/*2a72d339         */ v_xor_b32       v57, v57, v105
/*2a76cd3b         */ v_xor_b32       v59, v59, v102
/*2a7ca921         */ v_xor_b32       v62, v33, v84
/*2a7ca33e         */ v_xor_b32       v62, v62, v81
/*2a7cbb3e         */ v_xor_b32       v62, v62, v93
/*2a7cd73e         */ v_xor_b32       v62, v62, v107
/*d1ce003f 027e7d3a*/ v_alignbit_b32  v63, v58, v62, 31
/*2a7e7f3b         */ v_xor_b32       v63, v59, v63
/*d1ce0040 027e753e*/ v_alignbit_b32  v64, v62, v58, 31
/*2a808137         */ v_xor_b32       v64, v55, v64
/*d1ce0041 027e7338*/ v_alignbit_b32  v65, v56, v57, 31
/*2a82833d         */ v_xor_b32       v65, v61, v65
/*2a78173c         */ v_xor_b32       v60, v60, v11
/*2a844f63         */ v_xor_b32       v66, v99, v39
/*2a846542         */ v_xor_b32       v66, v66, v50
/*2a84bd42         */ v_xor_b32       v66, v66, v94
/*2a84d942         */ v_xor_b32       v66, v66, v108
/*2a508347         */ v_xor_b32       v40, v71, v65
/*2a32a540         */ v_xor_b32       v25, v64, v82
/*2a30a73f         */ v_xor_b32       v24, v63, v83
/*d1ce0043 027e853c*/ v_alignbit_b32  v67, v60, v66, 31
/*2a868739         */ v_xor_b32       v67, v57, v67
/*2a62a343         */ v_xor_b32       v49, v67, v81
/*d1ce0044 027e7942*/ v_alignbit_b32  v68, v66, v60, 31
/*2a888938         */ v_xor_b32       v68, v56, v68
/*2a608d44         */ v_xor_b32       v48, v68, v70
/*d1ce0045 02566131*/ v_alignbit_b32  v69, v49, v48, 21
/*d1ce0046 02523119*/ v_alignbit_b32  v70, v25, v24, 20
/*268e8b46         */ v_and_b32       v71, v70, v69
/*2a908b28         */ v_xor_b32       v72, v40, v69
/*2a8e9147         */ v_xor_b32       v71, v71, v72
/*90059f04         */ s_ashr_i32      s5, s4, 31
/*8e8e8304         */ s_lshl_b64      s[14:15], s[4:5], 3
/*be9100ff 55555555*/ s_mov_b32       s17, .gdata>>32
/*be9000ff 55555555*/ s_mov_b32       s16, .gdata&0xffffffff
/*800e0e10         */ s_add_u32       s14, s16, s14
/*820f0f11         */ s_addc_u32      s15, s17, s15
/*c0060387 00000000*/ s_load_dwordx2  s[14:15], s[14:15], 0x0
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*2a8e8e0f         */ v_xor_b32       v71, s15, v71
/*d1ce0030 02566330*/ v_alignbit_b32  v48, v48, v49, 21
/*d1ce0018 02523318*/ v_alignbit_b32  v24, v24, v25, 20
/*d1ce0019 027e7139*/ v_alignbit_b32  v25, v57, v56, 31
/*2a62574a         */ v_xor_b32       v49, v74, v43
/*2a626b31         */ v_xor_b32       v49, v49, v53
/*2a62cb31         */ v_xor_b32       v49, v49, v101
/*2a62df31         */ v_xor_b32       v49, v49, v111
/*2a323331         */ v_xor_b32       v25, v49, v25
/*2a54336e         */ v_xor_b32       v42, v110, v25
/*26706118         */ v_and_b32       v56, v24, v48
/*2a72612a         */ v_xor_b32       v57, v42, v48
/*2a707338         */ v_xor_b32       v56, v56, v57
/*2adc700e         */ v_xor_b32       v110, s14, v56
/*d1ce0039 027e7737*/ v_alignbit_b32  v57, v55, v59, 31
/*d1ce0037 027e6f3b*/ v_alignbit_b32  v55, v59, v55, 31
/*d1ce003b 027e633d*/ v_alignbit_b32  v59, v61, v49, 31
/*d1ce0031 027e7b31*/ v_alignbit_b32  v49, v49, v61, 31
/*2a62633e         */ v_xor_b32       v49, v62, v49
/*2a6e6f42         */ v_xor_b32       v55, v66, v55
/*2a72733c         */ v_xor_b32       v57, v60, v57
/*2a74773a         */ v_xor_b32       v58, v58, v59
/*2a0ab119         */ v_xor_b32       v5, v25, v88
/*2a5a3313         */ v_xor_b32       v45, v19, v25
/*2a36334c         */ v_xor_b32       v27, v76, v25
/*2a1ecf19         */ v_xor_b32       v15, v25, v103
/*2a22d340         */ v_xor_b32       v17, v64, v105
/*2a0eb540         */ v_xor_b32       v7, v64, v90
/*2a323d40         */ v_xor_b32       v25, v64, v30
/*2a46810c         */ v_xor_b32       v35, v12, v64
/*2a4c4d31         */ v_xor_b32       v38, v49, v38
/*2a3ec531         */ v_xor_b32       v31, v49, v98
/*2a5e6731         */ v_xor_b32       v47, v49, v51
/*2a2a1731         */ v_xor_b32       v21, v49, v11
/*2a16c131         */ v_xor_b32       v11, v49, v96
/*2a40c344         */ v_xor_b32       v32, v68, v97
/*2a2cab44         */ v_xor_b32       v22, v68, v85
/*2a24d544         */ v_xor_b32       v18, v68, v106
/*2a10b744         */ v_xor_b32       v8, v68, v91
/*2a424343         */ v_xor_b32       v33, v67, v33
/*2a2ea943         */ v_xor_b32       v23, v67, v84
/*2a26d743         */ v_xor_b32       v19, v67, v107
/*2a12bb43         */ v_xor_b32       v9, v67, v93
/*2a20d13f         */ v_xor_b32       v16, v63, v104
/*2a447f0d         */ v_xor_b32       v34, v13, v63
/*2a0cb33f         */ v_xor_b32       v6, v63, v89
/*2a5c5d3f         */ v_xor_b32       v46, v63, v46
/*2a626b39         */ v_xor_b32       v49, v57, v53
/*2a565739         */ v_xor_b32       v43, v57, v43
/*2a1acb39         */ v_xor_b32       v13, v57, v101
/*2a4adf39         */ v_xor_b32       v37, v57, v111
/*2a3a9539         */ v_xor_b32       v29, v57, v74
/*2a666937         */ v_xor_b32       v51, v55, v52
/*2a529d37         */ v_xor_b32       v41, v55, v78
/*2a18c937         */ v_xor_b32       v12, v55, v100
/*2a48db37         */ v_xor_b32       v36, v55, v109
/*2a389737         */ v_xor_b32       v28, v55, v75
/*2a68bf41         */ v_xor_b32       v52, v65, v95
/*2a58834f         */ v_xor_b32       v44, v79, v65
/*2a34834d         */ v_xor_b32       v26, v77, v65
/*2a1ccd41         */ v_xor_b32       v14, v65, v102
/*2a4e4f3a         */ v_xor_b32       v39, v58, v39
/*2a3cc73a         */ v_xor_b32       v30, v58, v99
/*2a64653a         */ v_xor_b32       v50, v58, v50
/*2a14bd3a         */ v_xor_b32       v10, v58, v94
/*2a28d93a         */ v_xor_b32       v20, v58, v108
/*bf800000         */ /*s_nop           0x0*/
/*d1ce0035 02666333*/ v_alignbit_b32  v53, v51, v49, 25
/*d1ce0031 02666731*/ v_alignbit_b32  v49, v49, v51, 25
/*d1ce0033 02264d27*/ v_alignbit_b32  v51, v39, v38, 9
/*d1ce0026 02264f26*/ v_alignbit_b32  v38, v38, v39, 9
/*d1ce0027 025e0b34*/ v_alignbit_b32  v39, v52, v5, 23
/*d1ce0005 025e6905*/ v_alignbit_b32  v5, v5, v52, 23
/*d1ce0034 027a2111*/ v_alignbit_b32  v52, v17, v16, 30
/*d1ce0010 027a2310*/ v_alignbit_b32  v16, v16, v17, 30
/*d1ce0011 020a4320*/ v_alignbit_b32  v17, v32, v33, 2
/*d1ce0020 020a4121*/ v_alignbit_b32  v32, v33, v32, 2
/*d1ce0021 02325729*/ v_alignbit_b32  v33, v41, v43, 12
/*d1ce0029 0232532b*/ v_alignbit_b32  v41, v43, v41, 12
/*d1ce002b 02123f1e*/ v_alignbit_b32  v43, v30, v31, 4
/*d1ce001e 02123d1f*/ v_alignbit_b32  v30, v31, v30, 4
/*d1ce001f 02765b2c*/ v_alignbit_b32  v31, v44, v45, 29
/*d1ce002c 0276592d*/ v_alignbit_b32  v44, v45, v44, 29
/*d1ce002d 024e0d07*/ v_alignbit_b32  v45, v7, v6, 19
/*d1ce0006 024e0f06*/ v_alignbit_b32  v6, v6, v7, 19
/*d1ce0007 020e2513*/ v_alignbit_b32  v7, v19, v18, 3
/*d1ce0012 020e2712*/ v_alignbit_b32  v18, v18, v19, 3
/*d1ce0013 026a2f16*/ v_alignbit_b32  v19, v22, v23, 26
/*d1ce0016 026a2d17*/ v_alignbit_b32  v22, v23, v22, 26
/*d1ce0017 027e4722*/ v_alignbit_b32  v23, v34, v35, 31
/*d1ce0022 027e4523*/ v_alignbit_b32  v34, v35, v34, 31
/*d1ce0023 021e5f32*/ v_alignbit_b32  v35, v50, v47, 7
/*d1ce002f 021e652f*/ v_alignbit_b32  v47, v47, v50, 7
/*d1cf0032 020e1b0c*/ v_alignbyte_b32 v50, v12, v13, 3
/*d1cf000c 020e190d*/ v_alignbyte_b32 v12, v13, v12, 3
/*d1ce000d 023a1f0e*/ v_alignbit_b32  v13, v14, v15, 14
/*d1ce000e 023a1d0f*/ v_alignbit_b32  v14, v15, v14, 14
/*d1ce000f 0272371a*/ v_alignbit_b32  v15, v26, v27, 28
/*d1ce001a 0272351b*/ v_alignbit_b32  v26, v27, v26, 28
/*d1ce001b 0216391d*/ v_alignbit_b32  v27, v29, v28, 5
/*d1ce001c 02163b1c*/ v_alignbit_b32  v28, v28, v29, 5
/*d1ce001d 025a5d19*/ v_alignbit_b32  v29, v25, v46, 22
/*d1ce0019 025a332e*/ v_alignbit_b32  v25, v46, v25, 22
/*d1ce002e 02461109*/ v_alignbit_b32  v46, v9, v8, 17
/*d1ce0008 02461308*/ v_alignbit_b32  v8, v8, v9, 17
/*d1cf0009 02062b14*/ v_alignbyte_b32 v9, v20, v21, 1
/*d1cf0014 02062915*/ v_alignbyte_b32 v20, v21, v20, 1
/*d1ce0015 024a4925*/ v_alignbit_b32  v21, v37, v36, 18
/*d1ce0024 024a4b24*/ v_alignbit_b32  v36, v36, v37, 18
/*d1ce0025 022e150b*/ v_alignbit_b32  v37, v11, v10, 11
/*d1ce000a 022e170a*/ v_alignbit_b32  v10, v10, v11, 11
/*26166911         */ v_and_b32       v11, v17, v52
/*2a6c4f11         */ v_xor_b32       v54, v17, v39
/*266e6711         */ v_and_b32       v55, v17, v51
/*2a226b11         */ v_xor_b32       v17, v17, v53
/*2a726933         */ v_xor_b32       v57, v51, v52
/*26746b33         */ v_and_b32       v58, v51, v53
/*2a664f33         */ v_xor_b32       v51, v51, v39
/*26766b27         */ v_and_b32       v59, v39, v53
/*264e4f34         */ v_and_b32       v39, v52, v39
/*2a686935         */ v_xor_b32       v52, v53, v52
/*266a2120         */ v_and_b32       v53, v32, v16
/*2a780b20         */ v_xor_b32       v60, v32, v5
/*267a4d20         */ v_and_b32       v61, v32, v38
/*2a406320         */ v_xor_b32       v32, v32, v49
/*2a7c2126         */ v_xor_b32       v62, v38, v16
/*267e6326         */ v_and_b32       v63, v38, v49
/*2a4c0b26         */ v_xor_b32       v38, v38, v5
/*26806305         */ v_and_b32       v64, v5, v49
/*260a0b10         */ v_and_b32       v5, v16, v5
/*2a202131         */ v_xor_b32       v16, v49, v16
/*26623f2d         */ v_and_b32       v49, v45, v31
/*2a825b21         */ v_xor_b32       v65, v33, v45
/*26845b07         */ v_and_b32       v66, v7, v45
/*2a5a5b2b         */ v_xor_b32       v45, v43, v45
/*2a860f1f         */ v_xor_b32       v67, v31, v7
/*26880f2b         */ v_and_b32       v68, v43, v7
/*2a0e0f21         */ v_xor_b32       v7, v33, v7
/*2a903f2b         */ v_xor_b32       v72, v43, v31
/*2656432b         */ v_and_b32       v43, v43, v33
/*263e3f21         */ v_and_b32       v31, v33, v31
/*26420d12         */ v_and_b32       v33, v18, v6
/*2a92252c         */ v_xor_b32       v73, v44, v18
/*2694251e         */ v_and_b32       v74, v30, v18
/*2a242529         */ v_xor_b32       v18, v41, v18
/*2a96591e         */ v_xor_b32       v75, v30, v44
/*26985906         */ v_and_b32       v76, v6, v44
/*26585929         */ v_and_b32       v44, v41, v44
/*2a9a0d29         */ v_xor_b32       v77, v41, v6
/*2652531e         */ v_and_b32       v41, v30, v41
/*2a0c0d1e         */ v_xor_b32       v6, v30, v6
/*263c4732         */ v_and_b32       v30, v50, v35
/*2a9c6513         */ v_xor_b32       v78, v19, v50
/*269e650d         */ v_and_b32       v79, v13, v50
/*2a646517         */ v_xor_b32       v50, v23, v50
/*2aa04717         */ v_xor_b32       v80, v23, v35
/*26a21b17         */ v_and_b32       v81, v23, v13
/*262e2717         */ v_and_b32       v23, v23, v19
/*2aa41b13         */ v_xor_b32       v82, v19, v13
/*26264713         */ v_and_b32       v19, v19, v35
/*2a1a1b23         */ v_xor_b32       v13, v35, v13
/*2646190e         */ v_and_b32       v35, v14, v12
/*2aa61d2f         */ v_xor_b32       v83, v47, v14
/*26a81d22         */ v_and_b32       v84, v34, v14
/*2a1c1d16         */ v_xor_b32       v14, v22, v14
/*2aaa5f22         */ v_xor_b32       v85, v34, v47
/*26ac5f0c         */ v_and_b32       v86, v12, v47
/*265e5f16         */ v_and_b32       v47, v22, v47
/*2aae1916         */ v_xor_b32       v87, v22, v12
/*262c2d22         */ v_and_b32       v22, v34, v22
/*2a181922         */ v_xor_b32       v12, v34, v12
/*26443b2e         */ v_and_b32       v34, v46, v29
/*2ab05d0f         */ v_xor_b32       v88, v15, v46
/*26b25d09         */ v_and_b32       v89, v9, v46
/*2a5c5d1b         */ v_xor_b32       v46, v27, v46
/*2ab4131d         */ v_xor_b32       v90, v29, v9
/*26b6131b         */ v_and_b32       v91, v27, v9
/*2a12130f         */ v_xor_b32       v9, v15, v9
/*2ab83b1b         */ v_xor_b32       v92, v27, v29
/*26361f1b         */ v_and_b32       v27, v27, v15
/*261e3b0f         */ v_and_b32       v15, v15, v29
/*263a1114         */ v_and_b32       v29, v20, v8
/*2aba2919         */ v_xor_b32       v93, v25, v20
/*26bc291c         */ v_and_b32       v94, v28, v20
/*2a28291a         */ v_xor_b32       v20, v26, v20
/*2abe331c         */ v_xor_b32       v95, v28, v25
/*2ac0111c         */ v_xor_b32       v96, v28, v8
/*2638351c         */ v_and_b32       v28, v28, v26
/*26c23308         */ v_and_b32       v97, v8, v25
/*2632331a         */ v_and_b32       v25, v26, v25
/*2a10111a         */ v_xor_b32       v8, v26, v8
/*2ada7d3d         */ v_xor_b32       v109, v61, v62
/*2ade7337         */ v_xor_b32       v111, v55, v57
/*2ad86b3c         */ v_xor_b32       v108, v60, v53
/*2a161736         */ v_xor_b32       v11, v54, v11
/*266c6125         */ v_and_b32       v54, v37, v48
/*2a602b30         */ v_xor_b32       v48, v48, v21
/*2a722b18         */ v_xor_b32       v57, v24, v21
/*26784b15         */ v_and_b32       v60, v21, v37
/*262a2b2a         */ v_and_b32       v21, v42, v21
/*2a7a4b18         */ v_xor_b32       v61, v24, v37
/*2a4a4b2a         */ v_xor_b32       v37, v42, v37
/*2630312a         */ v_and_b32       v24, v42, v24
/*26548b0a         */ v_and_b32       v42, v10, v69
/*2a7c4945         */ v_xor_b32       v62, v69, v36
/*2a8a4946         */ v_xor_b32       v69, v70, v36
/*26c41524         */ v_and_b32       v98, v36, v10
/*26484928         */ v_and_b32       v36, v40, v36
/*2ac61546         */ v_xor_b32       v99, v70, v10
/*2a141528         */ v_xor_b32       v10, v40, v10
/*26508d28         */ v_and_b32       v40, v40, v70
/*2ad40b10         */ v_xor_b32       v106, v16, v5
/*2ad64f34         */ v_xor_b32       v107, v52, v39
/*2ad08126         */ v_xor_b32       v104, v38, v64
/*2ad27733         */ v_xor_b32       v105, v51, v59
/*2acc413f         */ v_xor_b32       v102, v63, v32
/*2ace233a         */ v_xor_b32       v103, v58, v17
/*2ac8291c         */ v_xor_b32       v100, v28, v20
/*2aca131b         */ v_xor_b32       v101, v27, v9
/*2abcbd60         */ v_xor_b32       v94, v96, v94
/*2ac0b72e         */ v_xor_b32       v96, v46, v91
/*2ab63b5d         */ v_xor_b32       v91, v93, v29
/*2abab35a         */ v_xor_b32       v93, v90, v89
/*2ab2c308         */ v_xor_b32       v89, v8, v97
/*2ab44558         */ v_xor_b32       v90, v88, v34
/*2abebf19         */ v_xor_b32       v95, v25, v95
/*2ab0b90f         */ v_xor_b32       v88, v15, v92
/*2a68a517         */ v_xor_b32       v52, v23, v82
/*2a6a1d16         */ v_xor_b32       v53, v22, v14
/*2a64a332         */ v_xor_b32       v50, v50, v81
/*2a66a90c         */ v_xor_b32       v51, v12, v84
/*2a8c9f0d         */ v_xor_b32       v70, v13, v79
/*2aa24753         */ v_xor_b32       v81, v83, v35
/*2a5c3d4e         */ v_xor_b32       v46, v78, v30
/*2a3cad57         */ v_xor_b32       v30, v87, v86
/*2a9ea113         */ v_xor_b32       v79, v19, v80
/*2a26ab2f         */ v_xor_b32       v19, v47, v85
/*2a9c0f2b         */ v_xor_b32       v78, v43, v7
/*2a562529         */ v_xor_b32       v43, v41, v18
/*2a4e892d         */ v_xor_b32       v39, v45, v68
/*2a4c9506         */ v_xor_b32       v38, v6, v74
/*2aaa8543         */ v_xor_b32       v85, v67, v66
/*2aa84349         */ v_xor_b32       v84, v73, v33
/*2aa66341         */ v_xor_b32       v83, v65, v49
/*2aa4994d         */ v_xor_b32       v82, v77, v76
/*2a9a911f         */ v_xor_b32       v77, v31, v72
/*2a98972c         */ v_xor_b32       v76, v44, v75
/*2ac2c53e         */ v_xor_b32       v97, v62, v98
/*2a427930         */ v_xor_b32       v33, v48, v60
/*2a1a5563         */ v_xor_b32       v13, v99, v42
/*2a968b28         */ v_xor_b32       v75, v40, v69
/*2a186d3d         */ v_xor_b32       v12, v61, v54
/*2a947318         */ v_xor_b32       v74, v24, v57
/*2ac6490a         */ v_xor_b32       v99, v10, v36
/*2ac42b25         */ v_xor_b32       v98, v37, v21
/*80048104         */ s_add_u32       s4, s4, 1
/*bf82fe7e         */ s_branch        .L512_1
.L2056_1:
/*2a2cab61         */ v_xor_b32       v22, v97, v85
/*2a2ea921         */ v_xor_b32       v23, v33, v84
/*2a404f63         */ v_xor_b32       v32, v99, v39
/*2a424d62         */ v_xor_b32       v33, v98, v38
/*2a36996e         */ v_xor_b32       v27, v110, v76
/*2a349b47         */ v_xor_b32       v26, v71, v77
/*2a2ea317         */ v_xor_b32       v23, v23, v81
/*2a2c8d16         */ v_xor_b32       v22, v22, v70
/*2a406520         */ v_xor_b32       v32, v32, v50
/*2a44a70d         */ v_xor_b32       v34, v13, v83
/*2a426721         */ v_xor_b32       v33, v33, v51
/*2a46a50c         */ v_xor_b32       v35, v12, v82
/*2a349f1a         */ v_xor_b32       v26, v26, v79
/*2a36271b         */ v_xor_b32       v27, v27, v19
/*2a10b716         */ v_xor_b32       v8, v22, v91
/*2a12bb17         */ v_xor_b32       v9, v23, v93
/*2a2c5d22         */ v_xor_b32       v22, v34, v46
/*2a2e3d23         */ v_xor_b32       v23, v35, v30
/*2a42c121         */ v_xor_b32       v33, v33, v96
/*2a40bd20         */ v_xor_b32       v32, v32, v94
/*2a3a574a         */ v_xor_b32       v29, v74, v43
/*2a34bf1a         */ v_xor_b32       v26, v26, v95
/*2a0ab11b         */ v_xor_b32       v5, v27, v88
/*2a369d4b         */ v_xor_b32       v27, v75, v78
/*2a2a1721         */ v_xor_b32       v21, v33, v11
/*2a28d920         */ v_xor_b32       v20, v32, v108
/*2a12d709         */ v_xor_b32       v9, v9, v107
/*2a10d508         */ v_xor_b32       v8, v8, v106
/*2a2cb316         */ v_xor_b32       v22, v22, v89
/*2a2eb517         */ v_xor_b32       v23, v23, v90
/*2a386b1d         */ v_xor_b32       v28, v29, v53
/*2a1ccd1a         */ v_xor_b32       v14, v26, v102
/*2a0acf05         */ v_xor_b32       v5, v5, v103
/*2a1e691b         */ v_xor_b32       v15, v27, v52
/*d1ce001a 027e1109*/ v_alignbit_b32  v26, v9, v8, 31
/*d1ce001b 027e1308*/ v_alignbit_b32  v27, v8, v9, 31
/*2a20d116         */ v_xor_b32       v16, v22, v104
/*2a22d317         */ v_xor_b32       v17, v23, v105
/*2a1acb1c         */ v_xor_b32       v13, v28, v101
/*d1ce0016 027e2915*/ v_alignbit_b32  v22, v21, v20, 31
/*d1ce0017 027e2b14*/ v_alignbit_b32  v23, v20, v21, 31
/*2a343505         */ v_xor_b32       v26, v5, v26
/*2a36370e         */ v_xor_b32       v27, v14, v27
/*2a18c90f         */ v_xor_b32       v12, v15, v100
/*2a1adf0d         */ v_xor_b32       v13, v13, v111
/*2a1e2d11         */ v_xor_b32       v15, v17, v22
/*2a2c2f10         */ v_xor_b32       v22, v16, v23
/*d1ce0017 027e2111*/ v_alignbit_b32  v23, v17, v16, 31
/*2a18db0c         */ v_xor_b32       v12, v12, v109
/*d1ce0010 027e2310*/ v_alignbit_b32  v16, v16, v17, 31
/*2a222f0d         */ v_xor_b32       v17, v13, v23
/*2a2ea71b         */ v_xor_b32       v23, v27, v83
/*2a30a51a         */ v_xor_b32       v24, v26, v82
/*2a328d16         */ v_xor_b32       v25, v22, v70
/*2a38a30f         */ v_xor_b32       v28, v15, v81
/*d1ce001d 027e190d*/ v_alignbit_b32  v29, v13, v12, 31
/*d1ce000d 027e1b0c*/ v_alignbit_b32  v13, v12, v13, 31
/*d1ce0020 02523117*/ v_alignbit_b32  v32, v23, v24, 20
/*d1ce0021 02563919*/ v_alignbit_b32  v33, v25, v28, 21
/*2a44236e         */ v_xor_b32       v34, v110, v17
/*2a18210c         */ v_xor_b32       v12, v12, v16
/*2a123b09         */ v_xor_b32       v9, v9, v29
/*2a101b08         */ v_xor_b32       v8, v8, v13
/*d1ce000d 02522f18*/ v_alignbit_b32  v13, v24, v23, 20
/*d1ce0010 0256331c*/ v_alignbit_b32  v16, v28, v25, 21
/*2a2e1947         */ v_xor_b32       v23, v71, v12
/*26304320         */ v_and_b32       v24, v32, v33
/*2a324322         */ v_xor_b32       v25, v34, v33
/*d1ce001c 027e0b0e*/ v_alignbit_b32  v28, v14, v5, 31
/*d1ce0005 027e1d05*/ v_alignbit_b32  v5, v5, v14, 31
/*2a14bd08         */ v_xor_b32       v10, v8, v94
/*2a16c109         */ v_xor_b32       v11, v9, v96
/*2a1c3318         */ v_xor_b32       v14, v24, v25
/*2630210d         */ v_and_b32       v24, v13, v16
/*2a322117         */ v_xor_b32       v25, v23, v16
/*2a0a0b15         */ v_xor_b32       v5, v21, v5
/*2a283914         */ v_xor_b32       v20, v20, v28
/*d1ce0015 022e150b*/ v_alignbit_b32  v21, v11, v10, 11
/*2a303318         */ v_xor_b32       v24, v24, v25
/*2adc1cff 80008008*/ v_xor_b32       v110, 0x80008008, v14
/*d1ce000a 022e170a*/ v_alignbit_b32  v10, v10, v11, 11
/*2a16db14         */ v_xor_b32       v11, v20, v109
/*2a32df05         */ v_xor_b32       v25, v5, v111
/*26384315         */ v_and_b32       v28, v21, v33
/*2a3a2b20         */ v_xor_b32       v29, v32, v21
/*2ada30ff 80000000*/ v_xor_b32       v109, 0x80000000, v24
/*d1ce0023 024a1719*/ v_alignbit_b32  v35, v25, v11, 18
/*2a94391d         */ v_xor_b32       v74, v29, v28
/*263a210a         */ v_and_b32       v29, v10, v16
/*2a48150d         */ v_xor_b32       v36, v13, v10
/*d1ce000b 024a330b*/ v_alignbit_b32  v11, v11, v25, 18
/*26322b23         */ v_and_b32       v25, v35, v21
/*2a424721         */ v_xor_b32       v33, v33, v35
/*2a983b24         */ v_xor_b32       v76, v36, v29
/*7ee0036e         */ v_mov_b32       v112, v110
/*2a8a3321         */ v_xor_b32       v69, v33, v25
/*2642150b         */ v_and_b32       v33, v11, v10
/*2a201710         */ v_xor_b32       v16, v16, v11
/*7ee2036d         */ v_mov_b32       v113, v109
/*2a904310         */ v_xor_b32       v72, v16, v33
/*2a2a2b22         */ v_xor_b32       v21, v34, v21
/*26424722         */ v_and_b32       v33, v34, v35
/*7ee4034a         */ v_mov_b32       v114, v74
/*2a9a4315         */ v_xor_b32       v77, v21, v33
/*2a141517         */ v_xor_b32       v10, v23, v10
/*26421717         */ v_and_b32       v33, v23, v11
/*7ee6034c         */ v_mov_b32       v115, v76
/*2a222313         */ v_xor_b32       v17, v19, v17
/*2a18194f         */ v_xor_b32       v12, v79, v12
/*2a10c708         */ v_xor_b32       v8, v8, v99
/*2a289d14         */ v_xor_b32       v20, v20, v78
/*2a0a5705         */ v_xor_b32       v5, v5, v43
/*2a12c509         */ v_xor_b32       v9, v9, v98
/*2a9c430a         */ v_xor_b32       v78, v10, v33
/*2a3c4720         */ v_xor_b32       v30, v32, v35
/*263e4122         */ v_and_b32       v31, v34, v32
/*7ee80345         */ v_mov_b32       v116, v69
/*d1ce0020 02761911*/ v_alignbit_b32  v32, v17, v12, 29
/*d1ce0021 02121109*/ v_alignbit_b32  v33, v9, v8, 4
/*d1ce0022 02322905*/ v_alignbit_b32  v34, v5, v20, 12
/*2aa23d1f         */ v_xor_b32       v81, v31, v30
/*7eea0348         */ v_mov_b32       v117, v72
/*2a16170d         */ v_xor_b32       v11, v13, v11
/*261a1b17         */ v_and_b32       v13, v23, v13
/*d1ce000c 0276230c*/ v_alignbit_b32  v12, v12, v17, 29
/*d1ce0008 02121308*/ v_alignbit_b32  v8, v8, v9, 4
/*d1ce0005 02320b14*/ v_alignbit_b32  v5, v20, v5, 12
/*2a0cb31b         */ v_xor_b32       v6, v27, v89
/*2a0eb51a         */ v_xor_b32       v7, v26, v90
/*2a124121         */ v_xor_b32       v9, v33, v32
/*26224122         */ v_and_b32       v17, v34, v32
/*7eec034d         */ v_mov_b32       v118, v77
/*2a8c170d         */ v_xor_b32       v70, v13, v11
/*d1ce000d 024e0f06*/ v_alignbit_b32  v13, v6, v7, 19
/*2a881311         */ v_xor_b32       v68, v17, v9
/*2a101908         */ v_xor_b32       v8, v8, v12
/*26221905         */ v_and_b32       v17, v5, v12
/*7eee034e         */ v_mov_b32       v119, v78
/*d1ce0006 024e0d07*/ v_alignbit_b32  v6, v7, v6, 19
/*2a861111         */ v_xor_b32       v67, v17, v8
/*2a101b22         */ v_xor_b32       v8, v34, v13
/*2622410d         */ v_and_b32       v17, v13, v32
/*2a24d516         */ v_xor_b32       v18, v22, v106
/*2a1ed70f         */ v_xor_b32       v15, v15, v107
/*7ef00351         */ v_mov_b32       v120, v81
/*2a0a0d05         */ v_xor_b32       v5, v5, v6
/*26261906         */ v_and_b32       v19, v6, v12
/*d1ce0014 020e1f12*/ v_alignbit_b32  v20, v18, v15, 3
/*7ef20346         */ v_mov_b32       v121, v70
/*2aa42308         */ v_xor_b32       v82, v8, v17
/*7ef40344         */ v_mov_b32       v122, v68
/*2aae2705         */ v_xor_b32       v87, v5, v19
/*261a1b14         */ v_and_b32       v13, v20, v13
/*2a222920         */ v_xor_b32       v17, v32, v20
/*d1ce000f 020e250f*/ v_alignbit_b32  v15, v15, v18, 3
/*7ef60343         */ v_mov_b32       v123, v67
/*2a961b11         */ v_xor_b32       v75, v17, v13
/*260c0d0f         */ v_and_b32       v6, v15, v6
/*2a181f0c         */ v_xor_b32       v12, v12, v15
/*2aa80d0c         */ v_xor_b32       v84, v12, v6
/*7ef80352         */ v_mov_b32       v124, v82
/*7efa0357         */ v_mov_b32       v125, v87
/*7efc034b         */ v_mov_b32       v126, v75
/*7efe0354         */ v_mov_b32       v127, v84
/*b0040003         */ s_movk_i32      s4, 0x3
/*b0050040         */ s_movk_i32      s5, 0x40
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
.L2848_1:
/*bf088005         */ s_cmp_gt_u32    s5, 0
/*bf8407b3         */ s_cbranch_scc0  .L10740_1
/*8008c304         */ s_add_u32       s8, s4, -3
/*860e8c08         */ s_and_b32       s14, s8, 12
/*8e0e820e         */ s_lshl_b32      s14, s14, 2
/*8f14820e         */ s_lshr_b32      s20, s14, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e2a0370         */ v_mov_b32       v21, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*d0c5000e 00020680*/ v_cmp_lg_i32    s[14:15], 0, v3
/*d1000016 003a0504*/ v_cndmask_b32   v22, v4, v2, s[14:15]
/*2a2e0008         */ v_xor_b32       v23, s8, v0
/*be8800ff 01000193*/ s_mov_b32       s8, 0x1000193
/*d2860016 00020316*/ v_mul_hi_u32    v22, v22, v1
/*d2850017 00001117*/ v_mul_lo_u32    v23, v23, s8
/*34302d01         */ v_sub_u32       v24, vcc, v1, v22
/*322c2d01         */ v_add_u32       v22, vcc, v1, v22
/*2a2a2f15         */ v_xor_b32       v21, v21, v23
/*d1000016 003a3116*/ v_cndmask_b32   v22, v22, v24, s[14:15]
/*d2860017 00022b16*/ v_mul_hi_u32    v23, v22, v21
/*d2850017 00001517*/ v_mul_lo_u32    v23, v23, s10
/*34302f15         */ v_sub_u32       v24, vcc, v21, v23
/*d0ce000e 00022f15*/ v_cmp_ge_u32    s[14:15], v21, v23
/*d0ce0010 00001518*/ v_cmp_ge_u32    s[16:17], v24, s10
/*362a300a         */ v_subrev_u32    v21, vcc, s10, v24
/*86ea100e         */ s_and_b64       vcc, s[14:15], s[16:17]
/*002a2b18         */ v_cndmask_b32   v21, v24, v21, vcc
/*322e2a0a         */ v_add_u32       v23, vcc, s10, v21
/*d1000015 003a2b17*/ v_cndmask_b32   v21, v23, v21, s[14:15]
/*d0c5000e 00001480*/ v_cmp_lg_i32    s[14:15], 0, s10
/*d1000017 003a2ac1*/ v_cndmask_b32   v23, -1, v21, s[14:15]
/*7e300280         */ v_mov_b32       v24, 0
/*d28f0017 00022e86*/ v_lshlrev_b64   v[23:24], 6, v[23:24]
/*d1191005 00022e0c*/ v_add_u32       v5, s[16:17], s12, v23
/*7e2e020d         */ v_mov_b32       v23, s13
/*d11c6a06 00423117*/ v_addc_u32      v6, vcc, v23, v24, s[16:17]
/*dc5c0000 19000005*/ flat_load_dwordx4 v[25:28], v[5:6] slc glc
/*d1196a1d 00012105*/ v_add_u32       v29, vcc, v5, 16
/*d11c6a1e 01a90106*/ v_addc_u32      v30, vcc, v6, 0, vcc
/*dc5c0000 1d00001d*/ flat_load_dwordx4 v[29:32], v[29:30] slc glc
/*d1196a21 00014105*/ v_add_u32       v33, vcc, v5, 32
/*d11c6a22 01a90106*/ v_addc_u32      v34, vcc, v6, 0, vcc
/*dc5c0000 21000021*/ flat_load_dwordx4 v[33:36], v[33:34] slc glc
/*d1196a25 00016105*/ v_add_u32       v37, vcc, v5, 48
/*d11c6a26 01a90106*/ v_addc_u32      v38, vcc, v6, 0, vcc
/*dc5c0000 25000025*/ flat_load_dwordx4 v[37:40], v[37:38] slc glc
/*7e2a02ff 01000193*/ v_mov_b32       v21, 0x1000193
/*d2850012 00022b6e*/ v_mul_lo_u32    v18, v110, v21
/*d2850011 00022b6d*/ v_mul_lo_u32    v17, v109, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243312         */ v_xor_b32       v18, v18, v25
/*d285000c 00022b4a*/ v_mul_lo_u32    v12, v74, v21
/*2a223511         */ v_xor_b32       v17, v17, v26
/*d285000e 00022b4c*/ v_mul_lo_u32    v14, v76, v21
/*2a18370c         */ v_xor_b32       v12, v12, v27
/*d2850007 00022b45*/ v_mul_lo_u32    v7, v69, v21
/*2a1c390e         */ v_xor_b32       v14, v14, v28
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b48*/ v_mul_lo_u32    v10, v72, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3b07         */ v_xor_b32       v7, v7, v29
/*d285000f 00022b4d*/ v_mul_lo_u32    v15, v77, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143d0a         */ v_xor_b32       v10, v10, v30
/*d2850010 00022b4e*/ v_mul_lo_u32    v16, v78, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e3f0f         */ v_xor_b32       v15, v15, v31
/*d2850013 00022b51*/ v_mul_lo_u32    v19, v81, v21
/*2a204110         */ v_xor_b32       v16, v16, v32
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b46*/ v_mul_lo_u32    v8, v70, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264313         */ v_xor_b32       v19, v19, v33
/*d2850006 00022b44*/ v_mul_lo_u32    v6, v68, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104508         */ v_xor_b32       v8, v8, v34
/*d2850005 00022b43*/ v_mul_lo_u32    v5, v67, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4706         */ v_xor_b32       v6, v6, v35
/*2a0a4905         */ v_xor_b32       v5, v5, v36
/*7ef00313         */ v_mov_b32       v120, v19
/*d2850014 00022b52*/ v_mul_lo_u32    v20, v82, v21
/*d285000b 00022b57*/ v_mul_lo_u32    v11, v87, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284b14         */ v_xor_b32       v20, v20, v37
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164d0b         */ v_xor_b32       v11, v11, v38
/*d285000d 00022b4b*/ v_mul_lo_u32    v13, v75, v21
/*8008c204         */ s_add_u32       s8, s4, -2
/*7ef60305         */ v_mov_b32       v123, v5
/*d2850009 00022b54*/ v_mul_lo_u32    v9, v84, v21
/*2a1a4f0d         */ v_xor_b32       v13, v13, v39
/*86108d08         */ s_and_b32       s16, s8, 13
/*2a125109         */ v_xor_b32       v9, v9, v40
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*8008c104         */ s_add_u32       s8, s4, -1
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108e08         */ s_and_b32       s16, s8, 14
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86088f04         */ s_and_b32       s8, s4, 15
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e088208         */ s_lshl_b32      s8, s8, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148208         */ s_lshr_b32      s20, s8, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320004         */ v_xor_b32       v25, s4, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*80088104         */ s_add_u32       s8, s4, 1
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*86108c08         */ s_and_b32       s16, s8, 12
/*7efa030b         */ v_mov_b32       v125, v11
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*80088204         */ s_add_u32       s8, s4, 2
/*7ef60305         */ v_mov_b32       v123, v5
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108d08         */ s_and_b32       s16, s8, 13
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*80088304         */ s_add_u32       s8, s4, 3
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108e08         */ s_and_b32       s16, s8, 14
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*80088404         */ s_add_u32       s8, s4, 4
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108f08         */ s_and_b32       s16, s8, 15
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*80088504         */ s_add_u32       s8, s4, 5
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*86108c08         */ s_and_b32       s16, s8, 12
/*7efa030b         */ v_mov_b32       v125, v11
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*80088604         */ s_add_u32       s8, s4, 6
/*7ef60305         */ v_mov_b32       v123, v5
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108d08         */ s_and_b32       s16, s8, 13
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*80088704         */ s_add_u32       s8, s4, 7
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108e08         */ s_and_b32       s16, s8, 14
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*80088804         */ s_add_u32       s8, s4, 8
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108f08         */ s_and_b32       s16, s8, 15
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*80088904         */ s_add_u32       s8, s4, 9
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*86108c08         */ s_and_b32       s16, s8, 12
/*7efa030b         */ v_mov_b32       v125, v11
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*80088a04         */ s_add_u32       s8, s4, 10
/*7ef60305         */ v_mov_b32       v123, v5
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108d08         */ s_and_b32       s16, s8, 13
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*80088b04         */ s_add_u32       s8, s4, 11
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108e08         */ s_and_b32       s16, s8, 14
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860019 00023116*/ v_mul_hi_u32    v25, v22, v24
/*d2850019 00001519*/ v_mul_lo_u32    v25, v25, s10
/*34343318         */ v_sub_u32       v26, vcc, v24, v25
/*d0ce0010 00023318*/ v_cmp_ge_u32    s[16:17], v24, v25
/*d0ce0012 0000151a*/ v_cmp_ge_u32    s[18:19], v26, s10
/*3630340a         */ v_subrev_u32    v24, vcc, s10, v26
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*0030311a         */ v_cndmask_b32   v24, v26, v24, vcc
/*3232300a         */ v_add_u32       v25, vcc, s10, v24
/*d1000018 00423119*/ v_cndmask_b32   v24, v25, v24, s[16:17]
/*d1000018 003a30c1*/ v_cndmask_b32   v24, -1, v24, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*3230300c         */ v_add_u32       v24, vcc, s12, v24
/*38323317         */ v_addc_u32      v25, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 1a000018*/ flat_load_dwordx4 v[26:29], v[24:25] slc glc
/*d1196a1e 00012118*/ v_add_u32       v30, vcc, v24, 16
/*d11c6a1f 01a90119*/ v_addc_u32      v31, vcc, v25, 0, vcc
/*dc5c0000 1e00001e*/ flat_load_dwordx4 v[30:33], v[30:31] slc glc
/*d1196a22 00014118*/ v_add_u32       v34, vcc, v24, 32
/*d11c6a23 01a90119*/ v_addc_u32      v35, vcc, v25, 0, vcc
/*dc5c0000 22000022*/ flat_load_dwordx4 v[34:37], v[34:35] slc glc
/*d1196a18 00016118*/ v_add_u32       v24, vcc, v24, 48
/*d11c6a19 01a90119*/ v_addc_u32      v25, vcc, v25, 0, vcc
/*dc5c0000 26000018*/ flat_load_dwordx4 v[38:41], v[24:25] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a243512         */ v_xor_b32       v18, v18, v26
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2a223711         */ v_xor_b32       v17, v17, v27
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a1c3b0e         */ v_xor_b32       v14, v14, v29
/*7ee00312         */ v_mov_b32       v112, v18
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee20311         */ v_mov_b32       v113, v17
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a0e3d07         */ v_xor_b32       v7, v7, v30
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4030c         */ v_mov_b32       v114, v12
/*2a143f0a         */ v_xor_b32       v10, v10, v31
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6030e         */ v_mov_b32       v115, v14
/*2a1e410f         */ v_xor_b32       v15, v15, v32
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a204310         */ v_xor_b32       v16, v16, v33
/*7ee80307         */ v_mov_b32       v116, v7
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea030a         */ v_mov_b32       v117, v10
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a264513         */ v_xor_b32       v19, v19, v34
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec030f         */ v_mov_b32       v118, v15
/*2a104708         */ v_xor_b32       v8, v8, v35
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee0310         */ v_mov_b32       v119, v16
/*2a0c4906         */ v_xor_b32       v6, v6, v36
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a0a4b05         */ v_xor_b32       v5, v5, v37
/*7ef00313         */ v_mov_b32       v120, v19
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20308         */ v_mov_b32       v121, v8
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a284d14         */ v_xor_b32       v20, v20, v38
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40306         */ v_mov_b32       v122, v6
/*2a164f0b         */ v_xor_b32       v11, v11, v39
/*80088c04         */ s_add_u32       s8, s4, 12
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60305         */ v_mov_b32       v123, v5
/*2a1a510d         */ v_xor_b32       v13, v13, v40
/*86108f08         */ s_and_b32       s16, s8, 15
/*2a125309         */ v_xor_b32       v9, v9, v41
/*7ef80314         */ v_mov_b32       v124, v20
/*8e108210         */ s_lshl_b32      s16, s16, 2
/*7efa030b         */ v_mov_b32       v125, v11
/*7efc030d         */ v_mov_b32       v126, v13
/*7efe0309         */ v_mov_b32       v127, v9
/*8f148210         */ s_lshr_b32      s20, s16, 2
/*bf110114         */ s_set_gpr_idx_on s20, 0x1
/*7e300370         */ v_mov_b32       v24, v112
/*bf9c0000         */ s_set_gpr_idx_off
/*2a320008         */ v_xor_b32       v25, s8, v0
/*d2850019 00022b19*/ v_mul_lo_u32    v25, v25, v21
/*2a303318         */ v_xor_b32       v24, v24, v25
/*d2860016 00023116*/ v_mul_hi_u32    v22, v22, v24
/*d2850016 00001516*/ v_mul_lo_u32    v22, v22, s10
/*34322d18         */ v_sub_u32       v25, vcc, v24, v22
/*d0ce0010 00022d18*/ v_cmp_ge_u32    s[16:17], v24, v22
/*d0ce0012 00001519*/ v_cmp_ge_u32    s[18:19], v25, s10
/*362c320a         */ v_subrev_u32    v22, vcc, s10, v25
/*86ea1210         */ s_and_b64       vcc, s[16:17], s[18:19]
/*002c2d19         */ v_cndmask_b32   v22, v25, v22, vcc
/*32302c0a         */ v_add_u32       v24, vcc, s10, v22
/*d1000016 00422d18*/ v_cndmask_b32   v22, v24, v22, s[16:17]
/*d1000018 003a2cc1*/ v_cndmask_b32   v24, -1, v22, s[14:15]
/*7e320280         */ v_mov_b32       v25, 0
/*d28f0018 00023086*/ v_lshlrev_b64   v[24:25], 6, v[24:25]
/*322c300c         */ v_add_u32       v22, vcc, s12, v24
/*382e3317         */ v_addc_u32      v23, vcc, v23, v25, vcc
/*bf800000         */ /*s_nop           0x0*/
/*dc5c0000 18000016*/ flat_load_dwordx4 v[24:27], v[22:23] slc glc
/*d1196a1c 00012116*/ v_add_u32       v28, vcc, v22, 16
/*d11c6a1d 01a90117*/ v_addc_u32      v29, vcc, v23, 0, vcc
/*dc5c0000 1c00001c*/ flat_load_dwordx4 v[28:31], v[28:29] slc glc
/*d1196a20 00014116*/ v_add_u32       v32, vcc, v22, 32
/*d11c6a21 01a90117*/ v_addc_u32      v33, vcc, v23, 0, vcc
/*dc5c0000 20000020*/ flat_load_dwordx4 v[32:35], v[32:33] slc glc
/*d1196a16 00016116*/ v_add_u32       v22, vcc, v22, 48
/*d11c6a17 01a90117*/ v_addc_u32      v23, vcc, v23, 0, vcc
/*dc5c0000 24000016*/ flat_load_dwordx4 v[36:39], v[22:23] slc glc
/*d2850012 00022b12*/ v_mul_lo_u32    v18, v18, v21
/*d2850011 00022b11*/ v_mul_lo_u32    v17, v17, v21
/*bf8c0373         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2adc3112         */ v_xor_b32       v110, v18, v24
/*d285000c 00022b0c*/ v_mul_lo_u32    v12, v12, v21
/*2ada3311         */ v_xor_b32       v109, v17, v25
/*d285000e 00022b0e*/ v_mul_lo_u32    v14, v14, v21
/*2a94350c         */ v_xor_b32       v74, v12, v26
/*d2850007 00022b07*/ v_mul_lo_u32    v7, v7, v21
/*2a98370e         */ v_xor_b32       v76, v14, v27
/*7ee0036e         */ v_mov_b32       v112, v110
/*d285000a 00022b0a*/ v_mul_lo_u32    v10, v10, v21
/*7ee2036d         */ v_mov_b32       v113, v109
/*bf8c0272         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2a8a3907         */ v_xor_b32       v69, v7, v28
/*d285000f 00022b0f*/ v_mul_lo_u32    v15, v15, v21
/*7ee4034a         */ v_mov_b32       v114, v74
/*2a903b0a         */ v_xor_b32       v72, v10, v29
/*d2850010 00022b10*/ v_mul_lo_u32    v16, v16, v21
/*7ee6034c         */ v_mov_b32       v115, v76
/*2a9a3d0f         */ v_xor_b32       v77, v15, v30
/*d2850013 00022b13*/ v_mul_lo_u32    v19, v19, v21
/*2a9c3f10         */ v_xor_b32       v78, v16, v31
/*7ee80345         */ v_mov_b32       v116, v69
/*d2850008 00022b08*/ v_mul_lo_u32    v8, v8, v21
/*7eea0348         */ v_mov_b32       v117, v72
/*bf8c0171         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2aa24113         */ v_xor_b32       v81, v19, v32
/*d2850006 00022b06*/ v_mul_lo_u32    v6, v6, v21
/*7eec034d         */ v_mov_b32       v118, v77
/*2a8c4308         */ v_xor_b32       v70, v8, v33
/*d2850005 00022b05*/ v_mul_lo_u32    v5, v5, v21
/*7eee034e         */ v_mov_b32       v119, v78
/*2a884506         */ v_xor_b32       v68, v6, v34
/*d2850014 00022b14*/ v_mul_lo_u32    v20, v20, v21
/*2a864705         */ v_xor_b32       v67, v5, v35
/*7ef00351         */ v_mov_b32       v120, v81
/*d285000b 00022b0b*/ v_mul_lo_u32    v11, v11, v21
/*7ef20346         */ v_mov_b32       v121, v70
/*bf8c0070         */ s_sleep 100; s_waitcnt       vmcnt(0) & lgkmcnt(0)
/*2aa44914         */ v_xor_b32       v82, v20, v36
/*d285000d 00022b0d*/ v_mul_lo_u32    v13, v13, v21
/*7ef40344         */ v_mov_b32       v122, v68
/*2aae4b0b         */ v_xor_b32       v87, v11, v37
/*d2850009 00022b09*/ v_mul_lo_u32    v9, v9, v21
/*7ef60343         */ v_mov_b32       v123, v67
/*2a964d0d         */ v_xor_b32       v75, v13, v38
/*2aa84f09         */ v_xor_b32       v84, v9, v39
/*7ef80352         */ v_mov_b32       v124, v82
/*7efa0357         */ v_mov_b32       v125, v87
/*7efc034b         */ v_mov_b32       v126, v75
/*80049004         */ s_add_u32       s4, s4, 16
/*7efe0354         */ v_mov_b32       v127, v84
/*81858405         */ s_sub_i32       s5, s5, 4
/*bf82f84b         */ s_branch        .L2848_1
.L10740_1:
/*7ec80280         */ v_mov_b32       v100, 0
/*7ea602ff 80000000*/ v_mov_b32       v83, 0x80000000
/*7eaa0280         */ v_mov_b32       v85, 0
/*7eb40280         */ v_mov_b32       v90, 0
/*7eca0280         */ v_mov_b32       v101, 0
/*7eac0280         */ v_mov_b32       v86, 0
/*7ecc0280         */ v_mov_b32       v102, 0
/*7ece0280         */ v_mov_b32       v103, 0
/*7ed00280         */ v_mov_b32       v104, 0
/*7e0c0280         */ v_mov_b32       v6, 0
/*7e4e0280         */ v_mov_b32       v39, 0
/*7e260280         */ v_mov_b32       v19, 0
/*7e020281         */ v_mov_b32       v1, 1
/*7e2a0280         */ v_mov_b32       v21, 0
/*7eb20280         */ v_mov_b32       v89, 0
/*7eb00280         */ v_mov_b32       v88, 0
/*7e3c0280         */ v_mov_b32       v30, 0
/*7eb60280         */ v_mov_b32       v91, 0
/*7eb80280         */ v_mov_b32       v92, 0
/*7eba0280         */ v_mov_b32       v93, 0
/*7ed20280         */ v_mov_b32       v105, 0
/*7ed40280         */ v_mov_b32       v106, 0
/*7ed60280         */ v_mov_b32       v107, 0
/*7ed80280         */ v_mov_b32       v108, 0
/*b0000000         */ s_movk_i32      s0, 0x0
/*7ede0280         */ v_mov_b32       v111, 0
/*7e440280         */ v_mov_b32       v34, 0
/*7e560280         */ v_mov_b32       v43, 0
/*7e580280         */ v_mov_b32       v44, 0
/*7e5a0280         */ v_mov_b32       v45, 0
/*7e5c0280         */ v_mov_b32       v46, 0
/*7e5e0280         */ v_mov_b32       v47, 0
/*7e2c0280         */ v_mov_b32       v22, 0
/*7e620280         */ v_mov_b32       v49, 0
/*7e640280         */ v_mov_b32       v50, 0
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
/*bf800000         */ /*s_nop           0x0*/
.L10912_1:
/*bf059600         */ s_cmp_le_i32    s0, 22
/*bf84017f         */ s_cbranch_scc0  .L12452_1
/*bf00800b         */ s_cmp_eq_i32    s11, 0
/*bf85fffc         */ s_cbranch_scc1  .L10912_1
/*2a66a948         */ v_xor_b32       v51, v72, v84
/*2a68034d         */ v_xor_b32       v52, v77, v1
/*2a6a9745         */ v_xor_b32       v53, v69, v75
/*2a6ca74e         */ v_xor_b32       v54, v78, v83
/*2a6e896e         */ v_xor_b32       v55, v110, v68
/*2a70af4c         */ v_xor_b32       v56, v76, v87
/*2a72a54a         */ v_xor_b32       v57, v74, v82
/*2a665b33         */ v_xor_b32       v51, v51, v45
/*2a74876d         */ v_xor_b32       v58, v109, v67
/*2a685934         */ v_xor_b32       v52, v52, v44
/*2a76b146         */ v_xor_b32       v59, v70, v88
/*2a6a3d35         */ v_xor_b32       v53, v53, v30
/*2a6c4536         */ v_xor_b32       v54, v54, v34
/*90019f00         */ s_ashr_i32      s1, s0, 31
/*2a786351         */ v_xor_b32       v60, v81, v49
/*2a725739         */ v_xor_b32       v57, v57, v43
/*2a705f38         */ v_xor_b32       v56, v56, v47
/*2a6eb937         */ v_xor_b32       v55, v55, v92
/*2a74d33a         */ v_xor_b32       v58, v58, v105
/*2a660d33         */ v_xor_b32       v51, v51, v6
/*2a76bb3b         */ v_xor_b32       v59, v59, v93
/*2a685d34         */ v_xor_b32       v52, v52, v46
/*2a6a2735         */ v_xor_b32       v53, v53, v19
/*2a6cb536         */ v_xor_b32       v54, v54, v90
/*2a78b73c         */ v_xor_b32       v60, v60, v91
/*2a6e4f37         */ v_xor_b32       v55, v55, v39
/*2a70ad38         */ v_xor_b32       v56, v56, v86
/*2a72ab39         */ v_xor_b32       v57, v57, v85
/*2a66d733         */ v_xor_b32       v51, v51, v107
/*2a74b33a         */ v_xor_b32       v58, v58, v89
/*2a76cb3b         */ v_xor_b32       v59, v59, v101
/*2a6ad935         */ v_xor_b32       v53, v53, v108
/*2a68df34         */ v_xor_b32       v52, v52, v111
/*2a6cd536         */ v_xor_b32       v54, v54, v106
/*8e828300         */ s_lshl_b64      s[2:3], s[0:1], 3
/*be8500ff 55555555*/ s_mov_b32       s5, .gdata>>32
/*be8400ff 55555555*/ s_mov_b32       s4, .gdata&0xffffffff
/*2a78c93c         */ v_xor_b32       v60, v60, v100
/*2a702d38         */ v_xor_b32       v56, v56, v22
/*2a6e6537         */ v_xor_b32       v55, v55, v50
/*2a76d13b         */ v_xor_b32       v59, v59, v104
/*2a722b39         */ v_xor_b32       v57, v57, v21
/*2a74cd3a         */ v_xor_b32       v58, v58, v102
/*d1ce003d 027e6b33*/ v_alignbit_b32  v61, v51, v53, 31
/*d1ce003e 027e6735*/ v_alignbit_b32  v62, v53, v51, 31
/*d1ce003f 027e6d34*/ v_alignbit_b32  v63, v52, v54, 31
/*d1ce0040 027e6936*/ v_alignbit_b32  v64, v54, v52, 31
/*80020204         */ s_add_u32       s2, s4, s2
/*82030305         */ s_addc_u32      s3, s5, s3
/*2a78cf3c         */ v_xor_b32       v60, v60, v103
/*c0060081 00000000*/ s_load_dwordx2  s[2:3], s[2:3], 0x0
/*2a7a7b3a         */ v_xor_b32       v61, v58, v61
/*2a7c7d37         */ v_xor_b32       v62, v55, v62
/*d1ce0041 027e7338*/ v_alignbit_b32  v65, v56, v57, 31
/*2a7e7f39         */ v_xor_b32       v63, v57, v63
/*2a808138         */ v_xor_b32       v64, v56, v64
/*d1ce0038 027e7139*/ v_alignbit_b32  v56, v57, v56, 31
/*d1ce0039 027e7537*/ v_alignbit_b32  v57, v55, v58, 31
/*d1ce0037 027e6f3a*/ v_alignbit_b32  v55, v58, v55, 31
/*d1ce003a 027e793b*/ v_alignbit_b32  v58, v59, v60, 31
/*d1ce0042 027e773c*/ v_alignbit_b32  v66, v60, v59, 31
/*2a76833b         */ v_xor_b32       v59, v59, v65
/*2a50a53e         */ v_xor_b32       v40, v62, v82
/*2a20af3d         */ v_xor_b32       v16, v61, v87
/*2a343d3f         */ v_xor_b32       v26, v63, v30
/*2a5a5b40         */ v_xor_b32       v45, v64, v45
/*2a70713c         */ v_xor_b32       v56, v60, v56
/*2a6a8535         */ v_xor_b32       v53, v53, v66
/*2a6c6f36         */ v_xor_b32       v54, v54, v55
/*2a687334         */ v_xor_b32       v52, v52, v57
/*2a667533         */ v_xor_b32       v51, v51, v58
/*2a4a776d         */ v_xor_b32       v37, v109, v59
/*d1ce0037 02565b1a*/ v_alignbit_b32  v55, v26, v45, 21
/*d1ce0039 02522128*/ v_alignbit_b32  v57, v40, v16, 20
/*d1ce001a 0256352d*/ v_alignbit_b32  v26, v45, v26, 21
/*d1ce0010 02525110*/ v_alignbit_b32  v16, v16, v40, 20
/*2a4c716e         */ v_xor_b32       v38, v110, v56
/*2a244f38         */ v_xor_b32       v18, v56, v39
/*2a38715c         */ v_xor_b32       v28, v92, v56
/*2a047144         */ v_xor_b32       v2, v68, v56
/*2a506538         */ v_xor_b32       v40, v56, v50
/*2a2a2b3e         */ v_xor_b32       v21, v62, v21
/*2a10ab3e         */ v_xor_b32       v8, v62, v85
/*2a56573e         */ v_xor_b32       v43, v62, v43
/*2a307d4a         */ v_xor_b32       v24, v74, v62
/*2a280335         */ v_xor_b32       v20, v53, v1
/*2a3e9b35         */ v_xor_b32       v31, v53, v77
/*2a585935         */ v_xor_b32       v44, v53, v44
/*2a52df35         */ v_xor_b32       v41, v53, v111
/*2a5a5d35         */ v_xor_b32       v45, v53, v46
/*2a1e9140         */ v_xor_b32       v15, v64, v72
/*2a0ea940         */ v_xor_b32       v7, v64, v84
/*2a46d740         */ v_xor_b32       v35, v64, v107
/*2a220d40         */ v_xor_b32       v17, v64, v6
/*2a0a8b3f         */ v_xor_b32       v5, v63, v69
/*2a32973f         */ v_xor_b32       v25, v63, v75
/*2a48d93f         */ v_xor_b32       v36, v63, v108
/*2a26273f         */ v_xor_b32       v19, v63, v19
/*2a5c2d3d         */ v_xor_b32       v46, v61, v22
/*2a3c7b4c         */ v_xor_b32       v30, v76, v61
/*2a16ad3d         */ v_xor_b32       v11, v61, v86
/*2a5e5f3d         */ v_xor_b32       v47, v61, v47
/*2a36b734         */ v_xor_b32       v27, v52, v91
/*2a606334         */ v_xor_b32       v48, v52, v49
/*2a06c934         */ v_xor_b32       v3, v52, v100
/*2a1acf34         */ v_xor_b32       v13, v52, v103
/*2a4ea334         */ v_xor_b32       v39, v52, v81
/*2a3abb36         */ v_xor_b32       v29, v54, v93
/*2a2eb136         */ v_xor_b32       v23, v54, v88
/*2a14cb36         */ v_xor_b32       v10, v54, v101
/*2a1cd136         */ v_xor_b32       v14, v54, v104
/*2a0c8d36         */ v_xor_b32       v6, v54, v70
/*2a2cb33b         */ v_xor_b32       v22, v59, v89
/*2a427769         */ v_xor_b32       v33, v105, v59
/*2a027743         */ v_xor_b32       v1, v67, v59
/*2a18cd3b         */ v_xor_b32       v12, v59, v102
/*2a08a733         */ v_xor_b32       v4, v51, v83
/*2a409d33         */ v_xor_b32       v32, v51, v78
/*2a544533         */ v_xor_b32       v42, v51, v34
/*2a12b533         */ v_xor_b32       v9, v51, v90
/*2a44d533         */ v_xor_b32       v34, v51, v106
/*26626f39         */ v_and_b32       v49, v57, v55
/*2a646f25         */ v_xor_b32       v50, v37, v55
/*26663510         */ v_and_b32       v51, v16, v26
/*2a683526         */ v_xor_b32       v52, v38, v26
/*d1ce0035 0266371d*/ v_alignbit_b32  v53, v29, v27, 25
/*d1ce001b 02663b1b*/ v_alignbit_b32  v27, v27, v29, 25
/*d1ce001d 02262904*/ v_alignbit_b32  v29, v4, v20, 9
/*d1ce0004 02260914*/ v_alignbit_b32  v4, v20, v4, 9
/*d1ce0014 025e2516*/ v_alignbit_b32  v20, v22, v18, 23
/*d1ce0012 025e2d12*/ v_alignbit_b32  v18, v18, v22, 23
/*d1ce0016 027a5d15*/ v_alignbit_b32  v22, v21, v46, 30
/*d1ce0015 027a2b2e*/ v_alignbit_b32  v21, v46, v21, 30
/*d1ce002e 020a0b0f*/ v_alignbit_b32  v46, v15, v5, 2
/*d1ce0005 020a1f05*/ v_alignbit_b32  v5, v5, v15, 2
/*d1ce000f 02326117*/ v_alignbit_b32  v15, v23, v48, 12
/*d1ce0017 02322f30*/ v_alignbit_b32  v23, v48, v23, 12
/*d1ce0030 02123f20*/ v_alignbit_b32  v48, v32, v31, 4
/*d1ce001f 0212411f*/ v_alignbit_b32  v31, v31, v32, 4
/*d1ce0020 02763921*/ v_alignbit_b32  v32, v33, v28, 29
/*d1ce001c 0276431c*/ v_alignbit_b32  v28, v28, v33, 29
/*d1ce0021 024e1708*/ v_alignbit_b32  v33, v8, v11, 19
/*d1ce0008 024e110b*/ v_alignbit_b32  v8, v11, v8, 19
/*d1ce000b 020e4724*/ v_alignbit_b32  v11, v36, v35, 3
/*d1ce0023 020e4923*/ v_alignbit_b32  v35, v35, v36, 3
/*d1ce0024 026a3307*/ v_alignbit_b32  v36, v7, v25, 26
/*d1ce0007 026a0f19*/ v_alignbit_b32  v7, v25, v7, 26
/*d1ce0019 027e311e*/ v_alignbit_b32  v25, v30, v24, 31
/*d1ce0018 027e3d18*/ v_alignbit_b32  v24, v24, v30, 31
/*d1ce001e 021e592a*/ v_alignbit_b32  v30, v42, v44, 7
/*d1ce002a 021e552c*/ v_alignbit_b32  v42, v44, v42, 7
/*d1cf002c 020e070a*/ v_alignbyte_b32 v44, v10, v3, 3
/*d1cf0003 020e1503*/ v_alignbyte_b32 v3, v3, v10, 3
/*d1ce000a 023a510c*/ v_alignbit_b32  v10, v12, v40, 14
/*d1ce000c 023a1928*/ v_alignbit_b32  v12, v40, v12, 14
/*d1ce0028 02720501*/ v_alignbit_b32  v40, v1, v2, 28
/*d1ce0001 02720302*/ v_alignbit_b32  v1, v2, v1, 28
/*d1ce0002 02160d27*/ v_alignbit_b32  v2, v39, v6, 5
/*d1ce0006 02164f06*/ v_alignbit_b32  v6, v6, v39, 5
/*d1ce0027 025a5f2b*/ v_alignbit_b32  v39, v43, v47, 22
/*d1ce002b 025a572f*/ v_alignbit_b32  v43, v47, v43, 22
/*d1ce002f 02462313*/ v_alignbit_b32  v47, v19, v17, 17
/*d1ce0011 02462711*/ v_alignbit_b32  v17, v17, v19, 17
/*d1cf0013 02065322*/ v_alignbyte_b32 v19, v34, v41, 1
/*d1cf0022 02064529*/ v_alignbyte_b32 v34, v41, v34, 1
/*d1ce0029 024a1d0d*/ v_alignbit_b32  v41, v13, v14, 18
/*d1ce000d 024a1b0e*/ v_alignbit_b32  v13, v14, v13, 18
/*d1ce000e 022e132d*/ v_alignbit_b32  v14, v45, v9, 11
/*d1ce0009 022e5b09*/ v_alignbit_b32  v9, v9, v45, 11
/*2a5a6531         */ v_xor_b32       v45, v49, v50
/*2a626933         */ v_xor_b32       v49, v51, v52
/*26642d2e         */ v_and_b32       v50, v46, v22
/*2a66292e         */ v_xor_b32       v51, v46, v20
/*26683b2e         */ v_and_b32       v52, v46, v29
/*2a5c6b2e         */ v_xor_b32       v46, v46, v53
/*2a6c2d1d         */ v_xor_b32       v54, v29, v22
/*26706b1d         */ v_and_b32       v56, v29, v53
/*2a3a291d         */ v_xor_b32       v29, v29, v20
/*26746b14         */ v_and_b32       v58, v20, v53
/*26282916         */ v_and_b32       v20, v22, v20
/*2a2c2d35         */ v_xor_b32       v22, v53, v22
/*266a2b05         */ v_and_b32       v53, v5, v21
/*2a762505         */ v_xor_b32       v59, v5, v18
/*26780905         */ v_and_b32       v60, v5, v4
/*2a0a3705         */ v_xor_b32       v5, v5, v27
/*2a7a2b04         */ v_xor_b32       v61, v4, v21
/*267c3704         */ v_and_b32       v62, v4, v27
/*2a082504         */ v_xor_b32       v4, v4, v18
/*267e3712         */ v_and_b32       v63, v18, v27
/*26242515         */ v_and_b32       v18, v21, v18
/*2a2a2b1b         */ v_xor_b32       v21, v27, v21
/*26364121         */ v_and_b32       v27, v33, v32
/*2a80430f         */ v_xor_b32       v64, v15, v33
/*2682430b         */ v_and_b32       v65, v11, v33
/*2a424330         */ v_xor_b32       v33, v48, v33
/*2a841720         */ v_xor_b32       v66, v32, v11
/*26861730         */ v_and_b32       v67, v48, v11
/*2a16170f         */ v_xor_b32       v11, v15, v11
/*2a884130         */ v_xor_b32       v68, v48, v32
/*26601f30         */ v_and_b32       v48, v48, v15
/*261e410f         */ v_and_b32       v15, v15, v32
/*26401123         */ v_and_b32       v32, v35, v8
/*2a8a471c         */ v_xor_b32       v69, v28, v35
/*268c471f         */ v_and_b32       v70, v31, v35
/*2a464717         */ v_xor_b32       v35, v23, v35
/*2a8e391f         */ v_xor_b32       v71, v31, v28
/*26903908         */ v_and_b32       v72, v8, v28
/*26383917         */ v_and_b32       v28, v23, v28
/*2a921117         */ v_xor_b32       v73, v23, v8
/*262e2f1f         */ v_and_b32       v23, v31, v23
/*2a10111f         */ v_xor_b32       v8, v31, v8
/*263e3d2c         */ v_and_b32       v31, v44, v30
/*2a945924         */ v_xor_b32       v74, v36, v44
/*2696590a         */ v_and_b32       v75, v10, v44
/*2a585919         */ v_xor_b32       v44, v25, v44
/*2a983d19         */ v_xor_b32       v76, v25, v30
/*269a1519         */ v_and_b32       v77, v25, v10
/*26324919         */ v_and_b32       v25, v25, v36
/*2a9c1524         */ v_xor_b32       v78, v36, v10
/*26483d24         */ v_and_b32       v36, v36, v30
/*2a14151e         */ v_xor_b32       v10, v30, v10
/*263c070c         */ v_and_b32       v30, v12, v3
/*2a9e192a         */ v_xor_b32       v79, v42, v12
/*26a01918         */ v_and_b32       v80, v24, v12
/*2a181907         */ v_xor_b32       v12, v7, v12
/*2aa25518         */ v_xor_b32       v81, v24, v42
/*26a45503         */ v_and_b32       v82, v3, v42
/*26545507         */ v_and_b32       v42, v7, v42
/*2aa60707         */ v_xor_b32       v83, v7, v3
/*260e0f18         */ v_and_b32       v7, v24, v7
/*2a060718         */ v_xor_b32       v3, v24, v3
/*26304f2f         */ v_and_b32       v24, v47, v39
/*2aa85f28         */ v_xor_b32       v84, v40, v47
/*26aa5f13         */ v_and_b32       v85, v19, v47
/*2a5e5f02         */ v_xor_b32       v47, v2, v47
/*2aac2727         */ v_xor_b32       v86, v39, v19
/*26ae2702         */ v_and_b32       v87, v2, v19
/*2a262728         */ v_xor_b32       v19, v40, v19
/*2ab04f02         */ v_xor_b32       v88, v2, v39
/*26045102         */ v_and_b32       v2, v2, v40
/*264e4f28         */ v_and_b32       v39, v40, v39
/*26502322         */ v_and_b32       v40, v34, v17
/*2ab2452b         */ v_xor_b32       v89, v43, v34
/*26b44506         */ v_and_b32       v90, v6, v34
/*2a444501         */ v_xor_b32       v34, v1, v34
/*2ab65706         */ v_xor_b32       v91, v6, v43
/*2ab82306         */ v_xor_b32       v92, v6, v17
/*260c0306         */ v_and_b32       v6, v6, v1
/*26ba5711         */ v_and_b32       v93, v17, v43
/*26565701         */ v_and_b32       v43, v1, v43
/*2a022301         */ v_xor_b32       v1, v1, v17
/*2622350e         */ v_and_b32       v17, v14, v26
/*2a34531a         */ v_xor_b32       v26, v26, v41
/*2abc5310         */ v_xor_b32       v94, v16, v41
/*26be1d29         */ v_and_b32       v95, v41, v14
/*26525326         */ v_and_b32       v41, v38, v41
/*2ac01d10         */ v_xor_b32       v96, v16, v14
/*2a1c1d26         */ v_xor_b32       v14, v38, v14
/*26202126         */ v_and_b32       v16, v38, v16
/*264c6f09         */ v_and_b32       v38, v9, v55
/*2a6e1b37         */ v_xor_b32       v55, v55, v13
/*2ac21b39         */ v_xor_b32       v97, v57, v13
/*26c4130d         */ v_and_b32       v98, v13, v9
/*261a1b25         */ v_and_b32       v13, v37, v13
/*2ac61339         */ v_xor_b32       v99, v57, v9
/*2a121325         */ v_xor_b32       v9, v37, v9
/*264a7325         */ v_and_b32       v37, v37, v57
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*2ada5a03         */ v_xor_b32       v109, s3, v45
/*2adc6202         */ v_xor_b32       v110, s2, v49
/*2ad07b3c         */ v_xor_b32       v104, v60, v61
/*2ace6d34         */ v_xor_b32       v103, v52, v54
/*2ad46b3b         */ v_xor_b32       v106, v59, v53
/*2ade6533         */ v_xor_b32       v111, v51, v50
/*2ad62515         */ v_xor_b32       v107, v21, v18
/*2ad82916         */ v_xor_b32       v108, v22, v20
/*2a2c7f04         */ v_xor_b32       v22, v4, v63
/*2a2a751d         */ v_xor_b32       v21, v29, v58
/*2acc0b3e         */ v_xor_b32       v102, v62, v5
/*2a645d38         */ v_xor_b32       v50, v56, v46
/*2aca4506         */ v_xor_b32       v101, v6, v34
/*2ac82702         */ v_xor_b32       v100, v2, v19
/*2ab4b55c         */ v_xor_b32       v90, v92, v90
/*2a5caf2f         */ v_xor_b32       v46, v47, v87
/*2a0c5159         */ v_xor_b32       v6, v89, v40
/*2a26ab56         */ v_xor_b32       v19, v86, v85
/*2aacbb01         */ v_xor_b32       v86, v1, v93
/*2aaa3154         */ v_xor_b32       v85, v84, v24
/*2ab2b72b         */ v_xor_b32       v89, v43, v91
/*2a4eb127         */ v_xor_b32       v39, v39, v88
/*2aba9d19         */ v_xor_b32       v93, v25, v78
/*2ab61907         */ v_xor_b32       v91, v7, v12
/*2a449b2c         */ v_xor_b32       v34, v44, v77
/*2a58a103         */ v_xor_b32       v44, v3, v80
/*2a5a970a         */ v_xor_b32       v45, v10, v75
/*2a3c3d4f         */ v_xor_b32       v30, v79, v30
/*2a5e3f4a         */ v_xor_b32       v47, v74, v31
/*2a56a553         */ v_xor_b32       v43, v83, v82
/*2ad29924         */ v_xor_b32       v105, v36, v76
/*2ab8a32a         */ v_xor_b32       v92, v42, v81
/*2ab01730         */ v_xor_b32       v88, v48, v11
/*2a624717         */ v_xor_b32       v49, v23, v35
/*2aa68721         */ v_xor_b32       v83, v33, v67
/*2a028d08         */ v_xor_b32       v1, v8, v70
/*2aa88342         */ v_xor_b32       v84, v66, v65
/*2a964145         */ v_xor_b32       v75, v69, v32
/*2aae3740         */ v_xor_b32       v87, v64, v27
/*2aa49149         */ v_xor_b32       v82, v73, v72
/*2a86890f         */ v_xor_b32       v67, v15, v68
/*2a888f1c         */ v_xor_b32       v68, v28, v71
/*2a90c537         */ v_xor_b32       v72, v55, v98
/*2a8abf1a         */ v_xor_b32       v69, v26, v95
/*2a984d63         */ v_xor_b32       v76, v99, v38
/*2a8cc325         */ v_xor_b32       v70, v37, v97
/*2a942360         */ v_xor_b32       v74, v96, v17
/*2aa2bd10         */ v_xor_b32       v81, v16, v94
/*2a9c1b09         */ v_xor_b32       v78, v9, v13
/*2a9a530e         */ v_xor_b32       v77, v14, v41
/*80008100         */ s_add_u32       s0, s0, 1
/*bf82fe7f         */ s_branch        .L10912_1
.L12452_1:
/*c0060003 00000040*/ s_load_dwordx2  s[0:1], s[6:7], 0x40
/*2a0a9745         */ v_xor_b32       v5, v69, v75
/*2a0ea948         */ v_xor_b32       v7, v72, v84
/*2a1e6351         */ v_xor_b32       v15, v81, v49
/*2a0e5b07         */ v_xor_b32       v7, v7, v45
/*2a30a54a         */ v_xor_b32       v24, v74, v82
/*2a0a3d05         */ v_xor_b32       v5, v5, v30
/*2a1eb70f         */ v_xor_b32       v15, v15, v91
/*2a0e0d07         */ v_xor_b32       v7, v7, v6
/*2a06c90f         */ v_xor_b32       v3, v15, v100
/*2a0a2705         */ v_xor_b32       v5, v5, v19
/*2a1eaf4c         */ v_xor_b32       v15, v76, v87
/*2a08a74e         */ v_xor_b32       v4, v78, v83
/*2a225718         */ v_xor_b32       v17, v24, v43
/*2a0cb146         */ v_xor_b32       v6, v70, v88
/*2a0cbb06         */ v_xor_b32       v6, v6, v93
/*2a0ed707         */ v_xor_b32       v7, v7, v107
/*2a0ccb06         */ v_xor_b32       v6, v6, v101
/*2a14ab11         */ v_xor_b32       v10, v17, v85
/*2a084504         */ v_xor_b32       v4, v4, v34
/*2a1e5f0f         */ v_xor_b32       v15, v15, v47
/*2a0ad905         */ v_xor_b32       v5, v5, v108
/*2a06cf03         */ v_xor_b32       v3, v3, v103
/*2a08b504         */ v_xor_b32       v4, v4, v90
/*2a22034d         */ v_xor_b32       v17, v77, v1
/*2a225911         */ v_xor_b32       v17, v17, v44
/*2a08d504         */ v_xor_b32       v4, v4, v106
/*2a142b0a         */ v_xor_b32       v10, v10, v21
/*2a0cd106         */ v_xor_b32       v6, v6, v104
/*d1ce0013 027e0d03*/ v_alignbit_b32  v19, v3, v6, 31
/*2a262705         */ v_xor_b32       v19, v5, v19
/*d1ce0014 027e0b07*/ v_alignbit_b32  v20, v7, v5, 31
/*d1ce0005 027e0f05*/ v_alignbit_b32  v5, v5, v7, 31
/*d1ce0015 027e0706*/ v_alignbit_b32  v21, v6, v3, 31
/*2a0e2b07         */ v_xor_b32       v7, v7, v21
/*2a02876d         */ v_xor_b32       v1, v109, v67
/*2a02d301         */ v_xor_b32       v1, v1, v105
/*2a02b301         */ v_xor_b32       v1, v1, v89
/*2a225d11         */ v_xor_b32       v17, v17, v46
/*2a22df11         */ v_xor_b32       v17, v17, v111
/*2a1ead0f         */ v_xor_b32       v15, v15, v86
/*2a1e2d0f         */ v_xor_b32       v15, v15, v22
/*2a04896e         */ v_xor_b32       v2, v110, v68
/*2a04b902         */ v_xor_b32       v2, v2, v92
/*2a044f02         */ v_xor_b32       v2, v2, v39
/*2a046502         */ v_xor_b32       v2, v2, v50
/*d1ce0012 027e1f0a*/ v_alignbit_b32  v18, v10, v15, 31
/*2a062503         */ v_xor_b32       v3, v3, v18
/*d1ce0012 027e2304*/ v_alignbit_b32  v18, v4, v17, 31
/*2a24250f         */ v_xor_b32       v18, v15, v18
/*d1ce0015 027e0911*/ v_alignbit_b32  v21, v17, v4, 31
/*2a2a2b0a         */ v_xor_b32       v21, v10, v21
/*d1ce000a 027e150f*/ v_alignbit_b32  v10, v15, v10, 31
/*2a02cd01         */ v_xor_b32       v1, v1, v102
/*2a183d15         */ v_xor_b32       v12, v21, v30
/*2a1e5b12         */ v_xor_b32       v15, v18, v45
/*d1ce0016 02561f0c*/ v_alignbit_b32  v22, v12, v15, 21
/*d1ce000c 0256190f*/ v_alignbit_b32  v12, v15, v12, 21
/*2a12b507         */ v_xor_b32       v9, v7, v90
/*2a1e5d13         */ v_xor_b32       v15, v19, v46
/*d1ce0018 022e1f09*/ v_alignbit_b32  v24, v9, v15, 11
/*d1ce0009 022e130f*/ v_alignbit_b32  v9, v15, v9, 11
/*2a0a0b02         */ v_xor_b32       v5, v2, v5
/*2a1e2901         */ v_xor_b32       v15, v1, v20
/*d1ce0014 027e0302*/ v_alignbit_b32  v20, v2, v1, 31
/*d1ce0001 027e0501*/ v_alignbit_b32  v1, v1, v2, 31
/*2a041506         */ v_xor_b32       v2, v6, v10
/*2a0caf0f         */ v_xor_b32       v6, v15, v87
/*2a14a505         */ v_xor_b32       v10, v5, v82
/*d1ce0010 02521506*/ v_alignbit_b32  v16, v6, v10, 20
/*d1ce0006 02520d0a*/ v_alignbit_b32  v6, v10, v6, 20
/*2a0e9d07         */ v_xor_b32       v7, v7, v78
/*2a14075c         */ v_xor_b32       v10, v92, v3
/*2a06076e         */ v_xor_b32       v3, v110, v3
/*2a269b13         */ v_xor_b32       v19, v19, v77
/*2a32056d         */ v_xor_b32       v25, v109, v2
/*2a040569         */ v_xor_b32       v2, v105, v2
/*2a020304         */ v_xor_b32       v1, v4, v1
/*2a082911         */ v_xor_b32       v4, v17, v20
/*26221909         */ v_and_b32       v17, v9, v12
/*2a281310         */ v_xor_b32       v20, v16, v9
/*2a522314         */ v_xor_b32       v41, v20, v17
/*26282d18         */ v_and_b32       v20, v24, v22
/*2a343106         */ v_xor_b32       v26, v6, v24
/*2a54291a         */ v_xor_b32       v42, v26, v20
/*26342d06         */ v_and_b32       v26, v6, v22
/*2a362d19         */ v_xor_b32       v27, v25, v22
/*2a34371a         */ v_xor_b32       v26, v26, v27
/*26361910         */ v_and_b32       v27, v16, v12
/*2a381903         */ v_xor_b32       v28, v3, v12
/*2a36391b         */ v_xor_b32       v27, v27, v28
/*2a1acf04         */ v_xor_b32       v13, v4, v103
/*2a1cd101         */ v_xor_b32       v14, v1, v104
/*d1ce001c 024a1d0d*/ v_alignbit_b32  v28, v13, v14, 18
/*d1ce000d 024a1b0e*/ v_alignbit_b32  v13, v14, v13, 18
/*d1ce000e 0276050a*/ v_alignbit_b32  v14, v10, v2, 29
/*d1ce0002 02761502*/ v_alignbit_b32  v2, v2, v10, 29
/*d1ce000a 02120f13*/ v_alignbit_b32  v10, v19, v7, 4
/*d1ce0007 02122707*/ v_alignbit_b32  v7, v7, v19, 4
/*2a16ad0f         */ v_xor_b32       v11, v15, v86
/*2a086304         */ v_xor_b32       v4, v4, v49
/*2a02b101         */ v_xor_b32       v1, v1, v88
/*7e3a0300         */ v_mov_b32       v29, v0
/*7e3c0280         */ v_mov_b32       v30, 0
/*d28f001d 00023a86*/ v_lshlrev_b64   v[29:30], 6, v[29:30]
/*bf8c007f         */ s_waitcnt       lgkmcnt(0)
/*324a3a00         */ v_add_u32       v37, vcc, s0, v29
/*7e1e0201         */ v_mov_b32       v15, s1
/*384c3d0f         */ v_addc_u32      v38, vcc, v15, v30, vcc
/*2a261b16         */ v_xor_b32       v19, v22, v13
/*2a18390c         */ v_xor_b32       v12, v12, v28
/*2a4e36ff 80008008*/ v_xor_b32       v39, 0x80008008, v27
/*2a5034ff 80000000*/ v_xor_b32       v40, 0x80000000, v26
/*2634131c         */ v_and_b32       v26, v28, v9
/*2a42350c         */ v_xor_b32       v33, v12, v26
/*2634310d         */ v_and_b32       v26, v13, v24
/*2a303119         */ v_xor_b32       v24, v25, v24
/*2a121303         */ v_xor_b32       v9, v3, v9
/*2a443513         */ v_xor_b32       v34, v19, v26
/*26343903         */ v_and_b32       v26, v3, v28
/*2a363910         */ v_xor_b32       v27, v16, v28
/*2a0e0507         */ v_xor_b32       v7, v7, v2
/*2a141d0a         */ v_xor_b32       v10, v10, v14
/*2a463509         */ v_xor_b32       v35, v9, v26
/*26341b19         */ v_and_b32       v26, v25, v13
/*2a483518         */ v_xor_b32       v36, v24, v26
/*d1ce001a 02320304*/ v_alignbit_b32  v26, v4, v1, 12
/*d1ce0001 02320901*/ v_alignbit_b32  v1, v1, v4, 12
/*26080501         */ v_and_b32       v4, v1, v2
/*2a0aab05         */ v_xor_b32       v5, v5, v85
/*26101d1a         */ v_and_b32       v8, v26, v14
/*26062103         */ v_and_b32       v3, v3, v16
/*d1ce0010 024e0b0b*/ v_alignbit_b32  v16, v11, v5, 19
/*d1ce0005 024e1705*/ v_alignbit_b32  v5, v5, v11, 19
/*2a3e1508         */ v_xor_b32       v31, v8, v10
/*2a400f04         */ v_xor_b32       v32, v4, v7
/*260e0505         */ v_and_b32       v7, v5, v2
/*2a020b01         */ v_xor_b32       v1, v1, v5
/*26141d10         */ v_and_b32       v10, v16, v14
/*2a16211a         */ v_xor_b32       v11, v26, v16
/*2a3a3703         */ v_xor_b32       v29, v3, v27
/*2a1a1b06         */ v_xor_b32       v13, v6, v13
/*260c0d19         */ v_and_b32       v6, v25, v6
/*2a3c1b06         */ v_xor_b32       v30, v6, v13
/*2a1ad712         */ v_xor_b32       v13, v18, v107
/*2a24d915         */ v_xor_b32       v18, v21, v108
/*d1ce0015 020e250d*/ v_alignbit_b32  v21, v13, v18, 3
/*2a32150b         */ v_xor_b32       v25, v11, v10
/*2a340f01         */ v_xor_b32       v26, v1, v7
/*260e2115         */ v_and_b32       v7, v21, v16
/*2a162b0e         */ v_xor_b32       v11, v14, v21
/*2a360f0b         */ v_xor_b32       v27, v11, v7
/*d1ce000b 020e1b12*/ v_alignbit_b32  v11, v18, v13, 3
/*260a0b0b         */ v_and_b32       v5, v11, v5
/*2a041702         */ v_xor_b32       v2, v2, v11
/*2a380b02         */ v_xor_b32       v28, v2, v5
/*bf800000         */ /*s_nop           0x0*/
/*d1196a0d 00016125*/ v_add_u32       v13, vcc, v37, 48
/*d11c6a0e 01a90126*/ v_addc_u32      v14, vcc, v38, 0, vcc
/*dc7c0000 0000190d*/ flat_store_dwordx4 v[13:14], v[25:28] slc glc
/*d1196a01 00014125*/ v_add_u32       v1, vcc, v37, 32
/*d11c6a02 01a90126*/ v_addc_u32      v2, vcc, v38, 0, vcc
/*dc7c0000 00001d01*/ flat_store_dwordx4 v[1:2], v[29:32] slc glc
/*d1196a01 00012125*/ v_add_u32       v1, vcc, v37, 16
/*d11c6a02 01a90126*/ v_addc_u32      v2, vcc, v38, 0, vcc
/*dc7c0000 00002101*/ flat_store_dwordx4 v[1:2], v[33:36] slc glc
/*dc7c0000 00002725*/ flat_store_dwordx4 v[37:38], v[39:42] slc glc
/*bf810000         */ s_endpgm
