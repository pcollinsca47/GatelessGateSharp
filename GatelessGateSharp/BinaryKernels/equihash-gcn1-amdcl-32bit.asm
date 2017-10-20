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
.32bit
.driver_info "@(#) OpenCL 1.2 AMD-APP (2117.14).  Driver version: 2117.14 (VM)"
.kernel kernel_init_ht
    .config
        .dims x
        .sgprsnum 22
        .vgprsnum 7
        .hwlocal 4
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00008098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg round, "uint", uint
        .arg hash_table, "uint*", uint*, global, , 11, unused
        .arg row_counters_src, "uint*", uint*, global, , 11, unused
        .arg row_counters_dst, "uint*", uint*, global, , 11, unused
        .arg sols, "sols_t*", structure*, 32768, global, , 12
        .arg potential_sols, "potential_sols_t*", structure*, 65536, global, , 13
        .arg sync_flags, "uint*", uint*, global, , 14
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x4
        s_buffer_load_dword s1, s[4:7], 0x18
        s_buffer_load_dword s4, s[8:11], 0x0
        s_buffer_load_dword s5, s[8:11], 0x4
        s_buffer_load_dword s6, s[8:11], 0x14
        s_buffer_load_dword s7, s[8:11], 0x18
        s_buffer_load_dword s8, s[8:11], 0x1c
        s_waitcnt       lgkmcnt(0)
        s_min_u32       s0, s0, 0xffff
        s_mul_i32       s0, s12, s0
        s_add_u32       s0, s0, s1
        v_add_i32       v0, vcc, s0, v0
        s_lshl_b32      s0, s4, 1
        s_and_b32       s1, s5, 1
        s_and_b32       s0, s0, -2
        s_or_b32        s0, s1, s0
        s_mulk_i32      s0, 0x556
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[4:5], vcc
        v_mov_b32       v1, s8
        s_cbranch_execz .L180_0
        v_lshl_b64      v[2:3], 0, 0
        v_mov_b32       v4, s7
        v_mov_b32       v5, 0
        v_mov_b32       v6, s6
        v_add_i32       v0, vcc, s0, v0
        v_lshlrev_b32   v0, 2, v0
        s_load_dwordx4  s[8:11], s[2:3], 0x70
        s_load_dwordx4  s[12:15], s[2:3], 0x68
        s_load_dwordx4  s[16:19], s[2:3], 0x60
        s_waitcnt       lgkmcnt(0)
        tbuffer_store_format_xy v[2:3], v1, s[8:11], 0 offen format:[32_32,float]
        tbuffer_store_format_x v5, v4, s[12:15], 0 offen format:[32,float]
        tbuffer_store_format_xy v[2:3], v6, s[16:19], 0 offen format:[32_32,float]
        s_waitcnt       vmcnt(0) & expcnt(0)
        ds_write_b32    v0, v5 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
.L180_0:
        s_andn2_b64     exec, s[4:5], exec
        s_cbranch_execz .L228_0
        s_movk_i32      s1, 0x556
        v_cmp_gt_u32    vcc, s1, v0
        s_and_saveexec_b64 s[2:3], vcc
        v_add_i32       v0, vcc, s0, v0
        s_cbranch_execz .L228_0
        v_lshlrev_b32   v0, 2, v0
        v_mov_b32       v1, 0
        ds_write_b32    v0, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
.L228_0:
        s_endpgm
.kernel kernel_round0
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 66
        .vgprsnum 50
        .hwlocal 4
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00008098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg blake_state, "ulong*", ulong*, constant, , 0, 12
        .arg ht, "char*", char*, global, , 13
        .arg row_counters, "uint*", uint*, global, , 11, unused
        .arg sync_flags, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[8:11], 0x4
        s_load_dwordx4  s[16:19], s[2:3], 0x60
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s1, s0, 32
        s_buffer_load_dwordx8 s[20:27], s[16:19], s0
        s_buffer_load_dwordx8 s[28:35], s[16:19], s1
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s26, s34
        s_addc_u32      s1, s27, s35
        s_xor_b32       s51, 0x137e2179, s0
        s_xor_b32       s50, 0x5be0cd19, s1
        s_mov_b32       s16, 0x5f1d36f1
        s_mov_b32       s17, 0xa54ff53a
        s_add_u32       s16, s50, s16
        s_addc_u32      s17, s51, s17
        s_xor_b32       s14, s34, s16
        s_xor_b32       s15, s35, s17
        s_add_u32       s34, s22, s30
        s_addc_u32      s35, s23, s31
        s_xor_b32       s59, 0x2b3e6c1f, s34
        s_xor_b32       s58, 0x9b05688c, s35
        s_mov_b32       s38, 0x84caa73b
        s_mov_b32       s39, 0xbb67ae85
        s_lshr_b64      s[40:41], s[14:15], 24
        s_lshl_b32      s15, s14, 8
        s_or_b32        s15, s41, s15
        s_add_u32       s38, s58, s38
        s_addc_u32      s39, s59, s39
        s_add_u32       s42, s24, s32
        s_addc_u32      s43, s25, s33
        s_xor_b32       s18, s30, s38
        s_xor_b32       s19, s31, s39
        s_add_u32       s44, s28, s20
        s_addc_u32      s45, s29, s21
        s_mov_b32       s14, s40
        s_add_u32       s0, s14, s0
        s_addc_u32      s1, s15, s1
        s_xor_b32       s61, 0x4be4294, s42
        s_xor_b32       s60, 0xe07c2654, s43
        s_mov_b32       s54, 0xfe94f82b
        s_mov_b32       s55, 0x3c6ef372
        s_buffer_load_dword s4, s[4:7], 0x18
        s_xor_b32       s63, 0xade68241, s44
        s_xor_b32       s62, 0x510e527f, s45
        s_mov_b32       s48, 0xf3bcc908
        s_mov_b32       s49, 0x6a09e667
        s_xor_b32       s6, s50, s0
        s_xor_b32       s7, s51, s1
        s_lshr_b64      s[50:51], s[18:19], 24
        s_lshl_b32      s18, s18, 8
        s_add_u32       s52, s60, s54
        s_addc_u32      s53, s61, s55
        s_or_b32        s51, s51, s18
        s_add_u32       s48, s62, s48
        s_addc_u32      s49, s63, s49
        s_lshr_b64      s[54:55], s[6:7], 16
        s_lshl_b32      s7, s6, 16
        s_xor_b32       s18, s32, s52
        s_xor_b32       s19, s33, s53
        s_xor_b32       s36, s28, s48
        s_xor_b32       s37, s29, s49
        s_or_b32        s7, s55, s7
        s_lshl_b32      s12, s12, 8
        s_add_u32       s34, s34, s50
        s_addc_u32      s35, s35, s51
        s_lshr_b64      s[56:57], s[18:19], 24
        s_lshl_b32      s13, s18, 8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s4, s12, s4
        s_xor_b32       s46, s58, s34
        s_xor_b32       s47, s59, s35
        s_lshr_b64      s[58:59], s[36:37], 24
        s_lshl_b32      s19, s36, 8
        s_or_b32        s57, s57, s13
        s_mov_b32       s6, s54
        s_add_u32       s16, s6, s16
        s_addc_u32      s17, s7, s17
        v_add_i32       v0, vcc, s4, v0
        s_or_b32        s4, s59, s19
        s_mov_b64       vcc, 0
        v_mov_b32       v1, s45
        v_mov_b32       v2, s58
        s_xor_b32       s18, s40, s16
        s_xor_b32       s19, s15, s17
        s_lshr_b64      s[36:37], s[46:47], 16
        s_lshl_b32      s12, s46, 16
        v_addc_u32      v1, vcc, v0, v1, vcc
        v_add_i32       v2, vcc, s44, v2
        v_mov_b32       v3, s4
        v_addc_u32      v1, vcc, v1, v3, vcc
        s_add_u32       s42, s42, s56
        s_addc_u32      s43, s43, s57
        s_or_b32        s13, s37, s12
        s_xor_b32       s46, s60, s42
        s_xor_b32       s47, s61, s43
        s_lshr_b32      s40, s19, 31
        s_lshl_b64      s[44:45], s[18:19], 1
        s_or_b32        s44, s40, s44
        v_xor_b32       v3, s62, v2
        v_xor_b32       v4, s63, v1
        s_mov_b32       s12, s36
        s_add_u32       s38, s12, s38
        s_addc_u32      s39, s13, s39
        s_lshr_b64      s[40:41], s[46:47], 16
        s_lshl_b32      s5, s46, 16
        s_xor_b32       s14, s50, s38
        s_xor_b32       s15, s51, s39
        s_or_b32        s41, s41, s5
        s_add_u32       s18, s42, s44
        s_addc_u32      s19, s43, s45
        v_lshr_b64      v[4:5], v[3:4], 16
        v_lshlrev_b32   v3, 16, v3
        s_xor_b32       s36, s36, s18
        s_xor_b32       s12, s13, s19
        v_or_b32        v3, v5, v3
        v_add_i32       v5, vcc, v4, s48
        v_mov_b32       v6, s49
        v_addc_u32      v6, vcc, v3, v6, vcc
        s_lshr_b32      s37, s15, 31
        s_lshl_b64      s[42:43], s[14:15], 1
        s_add_u32       s46, s40, s52
        s_addc_u32      s47, s41, s53
        v_add_i32       v7, vcc, s12, v5
        v_mov_b32       v8, s36
        v_addc_u32      v8, vcc, v8, v6, vcc
        s_or_b32        s6, s37, s42
        v_xor_b32       v5, s58, v5
        v_xor_b32       v6, s4, v6
        s_xor_b32       s4, s56, s46
        s_xor_b32       s5, s57, s47
        v_add_i32       v2, vcc, v2, s6
        v_mov_b32       v9, s43
        v_addc_u32      v1, vcc, v1, v9, vcc
        v_xor_b32       v9, s44, v7
        v_xor_b32       v10, s45, v8
        v_lshrrev_b32   v11, 31, v6
        v_lshl_b64      v[5:6], v[5:6], 1
        s_lshr_b32      s14, s5, 31
        s_lshl_b64      s[44:45], s[4:5], 1
        v_xor_b32       v12, s7, v1
        v_lshr_b64      v[13:14], v[9:10], 24
        v_lshlrev_b32   v9, 8, v9
        v_or_b32        v5, v11, v5
        s_or_b32        s4, s14, s44
        v_xor_b32       v10, s54, v2
        v_add_i32       v11, vcc, v12, s46
        v_mov_b32       v15, s47
        v_addc_u32      v15, vcc, v10, v15, vcc
        v_or_b32        v9, v14, v9
        v_add_i32       v14, vcc, s18, v13
        v_mov_b32       v16, s19
        v_addc_u32      v16, vcc, v16, v9, vcc
        v_add_i32       v17, vcc, v5, s0
        v_mov_b32       v18, s1
        v_addc_u32      v18, vcc, v6, v18, vcc
        s_mov_b32       s5, s45
        s_add_u32       s0, s4, s34
        s_addc_u32      s1, s5, s35
        v_xor_b32       v19, s6, v11
        v_xor_b32       v20, s43, v15
        v_xor_b32       v21, s12, v14
        v_xor_b32       v22, s36, v16
        v_xor_b32       v23, s41, v18
        v_xor_b32       v3, s1, v3
        v_xor_b32       v24, s40, v17
        v_add_i32       v25, vcc, v23, s38
        v_mov_b32       v26, s39
        v_addc_u32      v26, vcc, v24, v26, vcc
        v_xor_b32       v4, s0, v4
        v_add_i32       v27, vcc, v3, s16
        v_mov_b32       v28, s17
        v_addc_u32      v28, vcc, v4, v28, vcc
        v_lshr_b64      v[29:30], v[19:20], 24
        v_lshlrev_b32   v19, 8, v19
        v_lshr_b64      v[31:32], v[21:22], 16
        v_lshlrev_b32   v20, 16, v21
        v_or_b32        v19, v30, v19
        v_add_i32       v2, vcc, v2, v29
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v20, v32, v20
        v_add_i32       v7, vcc, v31, v7
        v_addc_u32      v8, vcc, v20, v8, vcc
        v_xor_b32       v5, v5, v25
        v_xor_b32       v6, v6, v26
        v_xor_b32       v21, s4, v27
        v_xor_b32       v22, s45, v28
        v_xor_b32       v37, v12, v2
        v_xor_b32       v38, v10, v1
        v_xor_b32       v39, v13, v7
        v_xor_b32       v40, v9, v8
        v_lshr_b64      v[32:33], v[5:6], 24
        v_lshlrev_b32   v5, 8, v5
        v_lshr_b64      v[34:35], v[21:22], 24
        v_lshlrev_b32   v6, 8, v21
        v_or_b32        v5, v33, v5
        v_add_i32       v17, vcc, v32, v17
        v_addc_u32      v18, vcc, v5, v18, vcc
        v_or_b32        v6, v35, v6
        v_add_i32       v21, vcc, v34, s0
        v_mov_b32       v22, s1
        v_addc_u32      v22, vcc, v6, v22, vcc
        v_lshr_b64      v[35:36], v[37:38], 16
        v_lshlrev_b32   v10, 16, v37
        v_lshrrev_b32   v12, 31, v40
        v_lshl_b64      v[37:38], v[39:40], 1
        v_or_b32        v9, v36, v10
        v_add_i32       v10, vcc, v35, v11
        v_addc_u32      v11, vcc, v9, v15, vcc
        v_or_b32        v12, v12, v37
        v_xor_b32       v36, v23, v17
        v_xor_b32       v37, v24, v18
        v_xor_b32       v3, v3, v21
        v_xor_b32       v4, v4, v22
        v_add_i32       v17, vcc, v17, v12
        v_addc_u32      v18, vcc, v18, v38, vcc
        v_xor_b32       v39, v29, v10
        v_xor_b32       v40, v19, v11
        v_lshr_b64      v[29:30], v[36:37], 16
        v_lshlrev_b32   v13, 16, v36
        v_lshr_b64      v[36:37], v[3:4], 16
        v_lshlrev_b32   v3, 16, v3
        v_or_b32        v4, v30, v13
        v_add_i32       v13, vcc, v29, v25
        v_addc_u32      v15, vcc, v4, v26, vcc
        v_or_b32        v3, v37, v3
        v_add_i32       v24, vcc, v36, v27
        v_addc_u32      v25, vcc, v3, v28, vcc
        v_xor_b32       v9, v9, v18
        v_lshrrev_b32   v26, 31, v40
        v_lshl_b64      v[27:28], v[39:40], 1
        v_xor_b32       v19, v35, v17
        v_add_i32       v23, vcc, v9, v24
        v_addc_u32      v30, vcc, v19, v25, vcc
        v_or_b32        v26, v26, v27
        v_xor_b32       v39, v32, v13
        v_xor_b32       v40, v5, v15
        v_xor_b32       v41, v34, v24
        v_xor_b32       v42, v6, v25
        v_add_i32       v21, vcc, v21, v26
        v_addc_u32      v22, vcc, v22, v28, vcc
        v_xor_b32       v43, v12, v23
        v_xor_b32       v44, v38, v30
        v_lshrrev_b32   v32, 31, v40
        v_lshl_b64      v[33:34], v[39:40], 1
        v_lshrrev_b32   v5, 31, v42
        v_lshl_b64      v[37:38], v[41:42], 1
        v_or_b32        v6, v32, v33
        v_or_b32        v5, v5, v37
        v_xor_b32       v20, v20, v22
        v_lshr_b64      v[24:25], v[43:44], 24
        v_lshlrev_b32   v12, 8, v43
        v_xor_b32       v27, v31, v21
        v_add_i32       v13, vcc, v20, v13
        v_addc_u32      v15, vcc, v27, v15, vcc
        v_add_i32       v2, vcc, v6, v2
        v_addc_u32      v1, vcc, v34, v1, vcc
        v_or_b32        v12, v25, v12
        v_add_i32       v17, vcc, v24, v17
        v_addc_u32      v18, vcc, v12, v18, vcc
        v_add_i32       v14, vcc, v14, v5
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_xor_b32       v25, v26, v13
        v_xor_b32       v26, v28, v15
        v_xor_b32       v3, v3, v1
        v_xor_b32       v39, v9, v17
        v_xor_b32       v40, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v28, v36, v2
        v_add_i32       v7, vcc, v3, v7
        v_addc_u32      v8, vcc, v28, v8, vcc
        v_xor_b32       v29, v29, v14
        v_add_i32       v10, vcc, v4, v10
        v_addc_u32      v11, vcc, v29, v11, vcc
        v_lshr_b64      v[31:32], v[25:26], 24
        v_lshlrev_b32   v25, 8, v25
        v_lshr_b64      v[35:36], v[39:40], 16
        v_lshlrev_b32   v9, 16, v39
        v_or_b32        v19, v32, v25
        v_add_i32       v21, vcc, v21, v31
        v_addc_u32      v22, vcc, v22, v19, vcc
        v_xor_b32       v39, v6, v7
        v_xor_b32       v40, v34, v8
        v_or_b32        v9, v36, v9
        v_xor_b32       v36, v5, v10
        v_xor_b32       v37, v38, v11
        v_add_i32       v23, vcc, v35, v23
        v_addc_u32      v30, vcc, v9, v30, vcc
        v_xor_b32       v41, v20, v21
        v_xor_b32       v42, v27, v22
        v_lshr_b64      v[32:33], v[39:40], 24
        v_lshlrev_b32   v6, 8, v39
        v_lshr_b64      v[25:26], v[36:37], 24
        v_lshlrev_b32   v5, 8, v36
        v_xor_b32       v36, v24, v23
        v_xor_b32       v37, v12, v30
        v_or_b32        v6, v33, v6
        v_add_i32       v2, vcc, v2, v32
        v_addc_u32      v1, vcc, v1, v6, vcc
        v_or_b32        v5, v26, v5
        v_add_i32       v14, vcc, v14, v25
        v_addc_u32      v16, vcc, v16, v5, vcc
        v_lshr_b64      v[26:27], v[41:42], 16
        v_lshlrev_b32   v20, 16, v41
        v_lshrrev_b32   v33, 31, v37
        v_lshl_b64      v[36:37], v[36:37], 1
        v_or_b32        v12, v27, v20
        v_add_i32       v13, vcc, v26, v13
        v_addc_u32      v15, vcc, v12, v15, vcc
        v_xor_b32       v38, v4, v14
        v_xor_b32       v39, v29, v16
        v_or_b32        v24, v33, v36
        v_xor_b32       v40, v3, v2
        v_xor_b32       v41, v28, v1
        v_add_i32       v14, vcc, v14, v24
        v_addc_u32      v16, vcc, v16, v37, vcc
        v_xor_b32       v27, v31, v13
        v_xor_b32       v28, v19, v15
        v_lshr_b64      v[33:34], v[38:39], 16
        v_lshlrev_b32   v4, 16, v38
        v_lshr_b64      v[38:39], v[40:41], 16
        v_lshlrev_b32   v3, 16, v40
        v_or_b32        v4, v34, v4
        v_add_i32       v10, vcc, v33, v10
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_xor_b32       v12, v12, v16
        v_or_b32        v3, v39, v3
        v_add_i32       v7, vcc, v38, v7
        v_addc_u32      v8, vcc, v3, v8, vcc
        v_lshrrev_b32   v20, 31, v28
        v_lshl_b64      v[27:28], v[27:28], 1
        v_xor_b32       v19, v26, v14
        v_add_i32       v26, vcc, v12, v7
        v_addc_u32      v29, vcc, v19, v8, vcc
        v_or_b32        v20, v20, v27
        s_mov_b64       vcc, 0
        v_xor_b32       v31, v32, v7
        v_xor_b32       v32, v6, v8
        v_xor_b32       v39, v25, v10
        v_xor_b32       v40, v5, v11
        v_addc_u32      v1, vcc, v1, v0, vcc
        v_add_i32       v2, vcc, v2, v20
        v_addc_u32      v1, vcc, v1, v28, vcc
        v_xor_b32       v24, v24, v26
        v_xor_b32       v25, v37, v29
        v_lshrrev_b32   v27, 31, v32
        v_lshl_b64      v[6:7], v[31:32], 1
        v_lshrrev_b32   v31, 31, v40
        v_lshl_b64      v[36:37], v[39:40], 1
        v_xor_b32       v5, v1, v9
        v_lshr_b64      v[8:9], v[24:25], 24
        v_lshlrev_b32   v24, 8, v24
        v_or_b32        v6, v27, v6
        v_or_b32        v25, v31, v36
        v_xor_b32       v27, v2, v35
        v_add_i32       v10, vcc, v5, v10
        v_addc_u32      v11, vcc, v27, v11, vcc
        v_or_b32        v9, v9, v24
        v_add_i32       v14, vcc, v14, v8
        v_addc_u32      v16, vcc, v16, v9, vcc
        v_add_i32       v17, vcc, v6, v17
        v_addc_u32      v18, vcc, v7, v18, vcc
        v_add_i32       v21, vcc, v25, v21
        v_addc_u32      v22, vcc, v37, v22, vcc
        v_xor_b32       v34, v20, v10
        v_xor_b32       v35, v28, v11
        v_xor_b32       v39, v12, v14
        v_xor_b32       v40, v19, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v22
        v_xor_b32       v28, v33, v17
        v_add_i32       v13, vcc, v4, v13
        v_addc_u32      v15, vcc, v28, v15, vcc
        v_xor_b32       v31, v38, v21
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v30, vcc, v31, v30, vcc
        v_lshr_b64      v[32:33], v[34:35], 24
        v_lshlrev_b32   v20, 8, v34
        v_lshr_b64      v[34:35], v[39:40], 16
        v_lshlrev_b32   v12, 16, v39
        v_or_b32        v19, v33, v20
        v_add_i32       v2, vcc, v2, v32
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v12, v35, v12
        v_add_i32       v20, vcc, v34, v26
        v_addc_u32      v24, vcc, v12, v29, vcc
        v_xor_b32       v6, v6, v13
        v_xor_b32       v7, v7, v15
        v_xor_b32       v25, v25, v23
        v_xor_b32       v26, v37, v30
        v_xor_b32       v39, v5, v2
        v_xor_b32       v40, v27, v1
        v_xor_b32       v8, v8, v20
        v_xor_b32       v9, v9, v24
        v_lshr_b64      v[35:36], v[6:7], 24
        v_lshlrev_b32   v6, 8, v6
        v_lshr_b64      v[37:38], v[25:26], 24
        v_lshlrev_b32   v7, 8, v25
        v_or_b32        v6, v36, v6
        v_add_i32       v17, vcc, v35, v17
        v_addc_u32      v18, vcc, v6, v18, vcc
        v_or_b32        v7, v38, v7
        v_add_i32       v21, vcc, v37, v21
        v_addc_u32      v22, vcc, v7, v22, vcc
        v_lshr_b64      v[25:26], v[39:40], 16
        v_lshlrev_b32   v5, 16, v39
        v_lshrrev_b32   v27, 31, v9
        v_lshl_b64      v[8:9], v[8:9], 1
        v_or_b32        v5, v26, v5
        v_add_i32       v10, vcc, v25, v10
        v_addc_u32      v11, vcc, v5, v11, vcc
        v_or_b32        v8, v27, v8
        v_xor_b32       v38, v4, v17
        v_xor_b32       v39, v28, v18
        v_xor_b32       v40, v3, v21
        v_xor_b32       v41, v31, v22
        v_add_i32       v17, vcc, v17, v8
        v_addc_u32      v18, vcc, v18, v9, vcc
        v_xor_b32       v42, v32, v10
        v_xor_b32       v43, v19, v11
        v_lshr_b64      v[31:32], v[38:39], 16
        v_lshlrev_b32   v4, 16, v38
        v_lshr_b64      v[26:27], v[40:41], 16
        v_lshlrev_b32   v3, 16, v40
        v_or_b32        v4, v32, v4
        v_add_i32       v13, vcc, v31, v13
        v_addc_u32      v15, vcc, v4, v15, vcc
        v_or_b32        v3, v27, v3
        v_add_i32       v23, vcc, v26, v23
        v_addc_u32      v27, vcc, v3, v30, vcc
        v_xor_b32       v5, v5, v18
        v_lshrrev_b32   v29, 31, v43
        v_lshl_b64      v[32:33], v[42:43], 1
        v_xor_b32       v19, v25, v17
        v_add_i32       v25, vcc, v5, v23
        v_addc_u32      v28, vcc, v19, v27, vcc
        v_or_b32        v29, v29, v32
        v_xor_b32       v35, v35, v13
        v_xor_b32       v36, v6, v15
        v_xor_b32       v37, v37, v23
        v_xor_b32       v38, v7, v27
        v_add_i32       v21, vcc, v21, v29
        v_addc_u32      v22, vcc, v22, v33, vcc
        v_xor_b32       v8, v8, v25
        v_xor_b32       v9, v9, v28
        v_lshrrev_b32   v27, 31, v36
        v_lshl_b64      v[35:36], v[35:36], 1
        v_lshrrev_b32   v6, 31, v38
        v_lshl_b64      v[37:38], v[37:38], 1
        v_or_b32        v7, v27, v35
        v_or_b32        v6, v6, v37
        v_xor_b32       v12, v12, v22
        v_lshr_b64      v[39:40], v[8:9], 24
        v_lshlrev_b32   v8, 8, v8
        v_xor_b32       v9, v34, v21
        v_add_i32       v13, vcc, v12, v13
        v_addc_u32      v15, vcc, v9, v15, vcc
        v_add_i32       v2, vcc, v7, v2
        v_addc_u32      v1, vcc, v36, v1, vcc
        v_or_b32        v8, v40, v8
        v_add_i32       v17, vcc, v39, v17
        v_addc_u32      v18, vcc, v8, v18, vcc
        v_add_i32       v14, vcc, v14, v6
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_xor_b32       v32, v29, v13
        v_xor_b32       v33, v33, v15
        v_xor_b32       v3, v3, v1
        v_xor_b32       v34, v5, v17
        v_xor_b32       v35, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v26, v26, v2
        v_add_i32       v20, vcc, v3, v20
        v_addc_u32      v24, vcc, v26, v24, vcc
        v_xor_b32       v29, v31, v14
        v_add_i32       v10, vcc, v4, v10
        v_addc_u32      v11, vcc, v29, v11, vcc
        v_lshr_b64      v[30:31], v[32:33], 24
        v_lshlrev_b32   v23, 8, v32
        v_lshr_b64      v[32:33], v[34:35], 16
        v_lshlrev_b32   v5, 16, v34
        v_or_b32        v19, v31, v23
        v_add_i32       v21, vcc, v21, v30
        v_addc_u32      v22, vcc, v22, v19, vcc
        v_xor_b32       v35, v7, v20
        v_xor_b32       v36, v36, v24
        v_or_b32        v5, v33, v5
        v_xor_b32       v37, v6, v10
        v_xor_b32       v38, v38, v11
        v_add_i32       v25, vcc, v32, v25
        v_addc_u32      v28, vcc, v5, v28, vcc
        v_xor_b32       v40, v12, v21
        v_xor_b32       v41, v9, v22
        v_lshr_b64      v[33:34], v[35:36], 24
        v_lshlrev_b32   v7, 8, v35
        v_lshr_b64      v[35:36], v[37:38], 24
        v_lshlrev_b32   v6, 8, v37
        v_xor_b32       v38, v39, v25
        v_xor_b32       v39, v8, v28
        v_or_b32        v7, v34, v7
        v_add_i32       v2, vcc, v2, v33
        v_addc_u32      v1, vcc, v1, v7, vcc
        v_or_b32        v6, v36, v6
        v_add_i32       v14, vcc, v14, v35
        v_addc_u32      v16, vcc, v16, v6, vcc
        v_lshr_b64      v[36:37], v[40:41], 16
        v_lshlrev_b32   v9, 16, v40
        v_lshrrev_b32   v12, 31, v39
        v_lshl_b64      v[38:39], v[38:39], 1
        v_or_b32        v8, v37, v9
        v_add_i32       v9, vcc, v36, v13
        v_addc_u32      v13, vcc, v8, v15, vcc
        v_xor_b32       v40, v4, v14
        v_xor_b32       v41, v29, v16
        v_or_b32        v12, v12, v38
        v_xor_b32       v42, v3, v2
        v_xor_b32       v43, v26, v1
        v_add_i32       v14, vcc, v14, v12
        v_addc_u32      v16, vcc, v16, v39, vcc
        v_xor_b32       v26, v30, v9
        v_xor_b32       v27, v19, v13
        v_lshr_b64      v[29:30], v[40:41], 16
        v_lshlrev_b32   v4, 16, v40
        v_lshr_b64      v[37:38], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_or_b32        v4, v30, v4
        v_add_i32       v10, vcc, v29, v10
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v38, v3
        v_add_i32       v15, vcc, v37, v20
        v_addc_u32      v20, vcc, v3, v24, vcc
        v_lshrrev_b32   v23, 31, v27
        v_lshl_b64      v[26:27], v[26:27], 1
        v_xor_b32       v19, v36, v14
        v_add_i32       v24, vcc, v8, v15
        v_addc_u32      v30, vcc, v19, v20, vcc
        v_or_b32        v23, v23, v26
        v_xor_b32       v33, v33, v15
        v_xor_b32       v34, v7, v20
        v_xor_b32       v35, v35, v10
        v_xor_b32       v36, v6, v11
        v_add_i32       v2, vcc, v2, v23
        v_addc_u32      v1, vcc, v1, v27, vcc
        v_xor_b32       v40, v12, v24
        v_xor_b32       v41, v39, v30
        v_lshrrev_b32   v31, 31, v34
        v_lshl_b64      v[33:34], v[33:34], 1
        v_lshrrev_b32   v7, 31, v36
        v_lshl_b64      v[35:36], v[35:36], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[38:39], v[40:41], 24
        v_lshlrev_b32   v6, 8, v40
        s_mov_b64       s[0:1], 0
        v_or_b32        v12, v31, v33
        v_or_b32        v7, v7, v35
        v_xor_b32       v15, v2, v32
        v_add_i32       v10, vcc, v5, v10
        v_addc_u32      v11, vcc, v15, v11, vcc
        v_or_b32        v6, v39, v6
        v_addc_u32      v16, vcc, v16, v0, s[0:1]
        v_add_i32       v14, vcc, v14, v38
        v_addc_u32      v16, vcc, v16, v6, vcc
        v_add_i32       v17, vcc, v12, v17
        v_addc_u32      v18, vcc, v34, v18, vcc
        v_add_i32       v20, vcc, v7, v21
        v_addc_u32      v21, vcc, v36, v22, vcc
        v_xor_b32       v22, v23, v10
        v_xor_b32       v23, v27, v11
        v_xor_b32       v41, v8, v14
        v_xor_b32       v42, v19, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v21
        v_xor_b32       v26, v29, v17
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v13, vcc, v26, v13, vcc
        v_xor_b32       v27, v37, v20
        v_add_i32       v25, vcc, v3, v25
        v_addc_u32      v28, vcc, v27, v28, vcc
        v_lshr_b64      v[31:32], v[22:23], 24
        v_lshlrev_b32   v22, 8, v22
        v_lshr_b64      v[39:40], v[41:42], 16
        v_lshlrev_b32   v8, 16, v41
        v_or_b32        v19, v32, v22
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v8, v40, v8
        v_add_i32       v22, vcc, v39, v24
        v_addc_u32      v23, vcc, v8, v30, vcc
        v_xor_b32       v40, v12, v9
        v_xor_b32       v41, v34, v13
        v_xor_b32       v42, v7, v25
        v_xor_b32       v43, v36, v28
        v_xor_b32       v44, v5, v2
        v_xor_b32       v45, v15, v1
        v_xor_b32       v29, v38, v22
        v_xor_b32       v30, v6, v23
        v_lshr_b64      v[32:33], v[40:41], 24
        v_lshlrev_b32   v12, 8, v40
        v_lshr_b64      v[34:35], v[42:43], 24
        v_lshlrev_b32   v7, 8, v42
        v_or_b32        v12, v33, v12
        v_add_i32       v17, vcc, v32, v17
        v_addc_u32      v18, vcc, v12, v18, vcc
        v_or_b32        v7, v35, v7
        v_add_i32       v20, vcc, v34, v20
        v_addc_u32      v21, vcc, v7, v21, vcc
        v_lshr_b64      v[35:36], v[44:45], 16
        v_lshlrev_b32   v5, 16, v44
        v_lshrrev_b32   v15, 31, v30
        v_lshl_b64      v[29:30], v[29:30], 1
        v_or_b32        v5, v36, v5
        v_add_i32       v6, vcc, v35, v10
        v_addc_u32      v10, vcc, v5, v11, vcc
        v_or_b32        v11, v15, v29
        v_xor_b32       v40, v4, v17
        v_xor_b32       v41, v26, v18
        v_xor_b32       v42, v3, v20
        v_xor_b32       v43, v27, v21
        v_add_i32       v17, vcc, v17, v11
        v_addc_u32      v18, vcc, v18, v30, vcc
        v_xor_b32       v26, v31, v6
        v_xor_b32       v27, v19, v10
        v_lshr_b64      v[36:37], v[40:41], 16
        v_lshlrev_b32   v4, 16, v40
        v_lshr_b64      v[40:41], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_or_b32        v4, v37, v4
        v_add_i32       v9, vcc, v36, v9
        v_addc_u32      v13, vcc, v4, v13, vcc
        v_or_b32        v3, v41, v3
        v_add_i32       v15, vcc, v40, v25
        v_addc_u32      v24, vcc, v3, v28, vcc
        v_xor_b32       v5, v5, v18
        v_lshrrev_b32   v25, 31, v27
        v_lshl_b64      v[26:27], v[26:27], 1
        v_xor_b32       v19, v35, v17
        v_add_i32       v28, vcc, v5, v15
        v_addc_u32      v29, vcc, v19, v24, vcc
        v_or_b32        v25, v25, v26
        v_xor_b32       v31, v32, v9
        v_xor_b32       v32, v12, v13
        v_xor_b32       v33, v34, v15
        v_xor_b32       v34, v7, v24
        v_add_i32       v20, vcc, v20, v25
        v_addc_u32      v21, vcc, v21, v27, vcc
        v_xor_b32       v37, v11, v28
        v_xor_b32       v38, v30, v29
        v_lshrrev_b32   v30, 31, v32
        v_lshl_b64      v[31:32], v[31:32], 1
        v_lshrrev_b32   v12, 31, v34
        v_lshl_b64      v[33:34], v[33:34], 1
        v_or_b32        v7, v30, v31
        v_or_b32        v12, v12, v33
        v_xor_b32       v8, v8, v21
        v_lshr_b64      v[30:31], v[37:38], 24
        v_lshlrev_b32   v11, 8, v37
        v_xor_b32       v15, v39, v20
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v13, vcc, v15, v13, vcc
        v_add_i32       v2, vcc, v7, v2
        v_addc_u32      v1, vcc, v32, v1, vcc
        v_or_b32        v11, v31, v11
        v_add_i32       v17, vcc, v30, v17
        v_addc_u32      v18, vcc, v11, v18, vcc
        v_add_i32       v14, vcc, v14, v12
        v_addc_u32      v16, vcc, v16, v34, vcc
        v_xor_b32       v24, v25, v9
        v_xor_b32       v25, v27, v13
        v_xor_b32       v3, v3, v1
        v_xor_b32       v41, v5, v17
        v_xor_b32       v42, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v26, v40, v2
        v_add_i32       v22, vcc, v3, v22
        v_addc_u32      v23, vcc, v26, v23, vcc
        v_xor_b32       v27, v36, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v27, v10, vcc
        v_lshr_b64      v[35:36], v[24:25], 24
        v_lshlrev_b32   v24, 8, v24
        s_mov_b64       vcc, 0
        v_lshr_b64      v[37:38], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_or_b32        v19, v36, v24
        v_addc_u32      v21, vcc, v21, v0, vcc
        v_add_i32       v20, vcc, v20, v35
        v_addc_u32      v21, vcc, v21, v19, vcc
        v_xor_b32       v39, v7, v22
        v_xor_b32       v40, v32, v23
        v_or_b32        v5, v38, v5
        v_xor_b32       v33, v12, v6
        v_xor_b32       v34, v34, v10
        v_add_i32       v28, vcc, v37, v28
        v_addc_u32      v29, vcc, v5, v29, vcc
        v_xor_b32       v41, v8, v20
        v_xor_b32       v42, v15, v21
        v_lshr_b64      v[31:32], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_lshr_b64      v[24:25], v[33:34], 24
        v_lshlrev_b32   v12, 8, v33
        v_xor_b32       v38, v30, v28
        v_xor_b32       v39, v11, v29
        v_or_b32        v7, v32, v7
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v7, vcc
        v_or_b32        v12, v25, v12
        v_add_i32       v14, vcc, v14, v24
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_lshr_b64      v[32:33], v[41:42], 16
        v_lshlrev_b32   v8, 16, v41
        v_lshrrev_b32   v15, 31, v39
        v_lshl_b64      v[38:39], v[38:39], 1
        v_or_b32        v8, v33, v8
        v_add_i32       v9, vcc, v32, v9
        v_addc_u32      v11, vcc, v8, v13, vcc
        v_xor_b32       v40, v4, v14
        v_xor_b32       v41, v27, v16
        v_or_b32        v15, v15, v38
        v_xor_b32       v42, v3, v2
        v_xor_b32       v43, v26, v1
        v_add_i32       v14, vcc, v14, v15
        v_addc_u32      v16, vcc, v16, v39, vcc
        v_xor_b32       v25, v35, v9
        v_xor_b32       v26, v19, v11
        v_lshr_b64      v[33:34], v[40:41], 16
        v_lshlrev_b32   v4, 16, v40
        v_lshr_b64      v[35:36], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_or_b32        v4, v34, v4
        v_add_i32       v6, vcc, v33, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v36, v3
        v_add_i32       v13, vcc, v35, v22
        v_addc_u32      v22, vcc, v3, v23, vcc
        v_lshrrev_b32   v23, 31, v26
        v_lshl_b64      v[25:26], v[25:26], 1
        v_xor_b32       v19, v32, v14
        v_add_i32       v27, vcc, v8, v13
        v_addc_u32      v30, vcc, v19, v22, vcc
        v_or_b32        v23, v23, v25
        v_xor_b32       v31, v31, v13
        v_xor_b32       v32, v7, v22
        v_xor_b32       v40, v24, v6
        v_xor_b32       v41, v12, v10
        v_add_i32       v2, vcc, v2, v23
        v_addc_u32      v1, vcc, v1, v26, vcc
        v_xor_b32       v42, v15, v27
        v_xor_b32       v43, v39, v30
        v_lshrrev_b32   v25, 31, v32
        v_lshl_b64      v[31:32], v[31:32], 1
        v_lshrrev_b32   v7, 31, v41
        v_lshl_b64      v[12:13], v[40:41], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[38:39], v[42:43], 24
        v_lshlrev_b32   v15, 8, v42
        v_or_b32        v22, v25, v31
        v_or_b32        v7, v7, v12
        v_xor_b32       v12, v2, v37
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v12, v10, vcc
        v_or_b32        v15, v39, v15
        v_add_i32       v14, vcc, v14, v38
        v_addc_u32      v16, vcc, v16, v15, vcc
        v_add_i32       v17, vcc, v22, v17
        v_addc_u32      v18, vcc, v32, v18, vcc
        v_add_i32       v20, vcc, v7, v20
        v_addc_u32      v21, vcc, v13, v21, vcc
        v_xor_b32       v23, v23, v6
        v_xor_b32       v24, v26, v10
        v_xor_b32       v39, v8, v14
        v_xor_b32       v40, v19, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v21
        v_xor_b32       v25, v33, v17
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v25, v11, vcc
        v_xor_b32       v26, v35, v20
        v_add_i32       v28, vcc, v3, v28
        v_addc_u32      v29, vcc, v26, v29, vcc
        v_lshr_b64      v[33:34], v[23:24], 24
        v_lshlrev_b32   v23, 8, v23
        v_lshr_b64      v[35:36], v[39:40], 16
        v_lshlrev_b32   v8, 16, v39
        v_or_b32        v19, v34, v23
        v_add_i32       v2, vcc, v2, v33
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v8, v36, v8
        v_add_i32       v23, vcc, v35, v27
        v_addc_u32      v24, vcc, v8, v30, vcc
        v_xor_b32       v36, v22, v9
        v_xor_b32       v37, v32, v11
        v_xor_b32       v39, v7, v28
        v_xor_b32       v40, v13, v29
        v_xor_b32       v41, v5, v2
        v_xor_b32       v42, v12, v1
        v_xor_b32       v43, v38, v23
        v_xor_b32       v44, v15, v24
        v_lshr_b64      v[31:32], v[36:37], 24
        v_lshlrev_b32   v22, 8, v36
        v_lshr_b64      v[36:37], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_or_b32        v13, v32, v22
        v_add_i32       v17, vcc, v31, v17
        v_addc_u32      v18, vcc, v13, v18, vcc
        v_or_b32        v7, v37, v7
        v_add_i32       v20, vcc, v36, v20
        v_addc_u32      v21, vcc, v7, v21, vcc
        v_lshr_b64      v[37:38], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_lshrrev_b32   v12, 31, v44
        v_lshl_b64      v[39:40], v[43:44], 1
        v_or_b32        v5, v38, v5
        v_add_i32       v6, vcc, v37, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_or_b32        v12, v12, v39
        v_xor_b32       v38, v4, v17
        v_xor_b32       v39, v25, v18
        v_xor_b32       v41, v3, v20
        v_xor_b32       v42, v26, v21
        v_add_i32       v17, vcc, v17, v12
        v_addc_u32      v18, vcc, v18, v40, vcc
        v_xor_b32       v43, v33, v6
        v_xor_b32       v44, v19, v10
        v_lshr_b64      v[26:27], v[38:39], 16
        v_lshlrev_b32   v4, 16, v38
        v_lshr_b64      v[32:33], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_or_b32        v4, v27, v4
        v_add_i32       v9, vcc, v26, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v33, v3
        v_add_i32       v15, vcc, v32, v28
        v_addc_u32      v22, vcc, v3, v29, vcc
        v_xor_b32       v5, v5, v18
        v_lshrrev_b32   v27, 31, v44
        v_lshl_b64      v[28:29], v[43:44], 1
        v_xor_b32       v19, v37, v17
        v_add_i32       v25, vcc, v5, v15
        v_addc_u32      v30, vcc, v19, v22, vcc
        v_or_b32        v27, v27, v28
        v_xor_b32       v33, v31, v9
        v_xor_b32       v34, v13, v11
        v_xor_b32       v36, v36, v15
        v_xor_b32       v37, v7, v22
        v_add_i32       v20, vcc, v20, v27
        v_addc_u32      v21, vcc, v21, v29, vcc
        v_xor_b32       v41, v12, v25
        v_xor_b32       v42, v40, v30
        v_lshrrev_b32   v31, 31, v34
        v_lshl_b64      v[33:34], v[33:34], 1
        v_lshrrev_b32   v13, 31, v37
        v_lshl_b64      v[36:37], v[36:37], 1
        v_or_b32        v7, v31, v33
        v_or_b32        v13, v13, v36
        v_xor_b32       v8, v8, v21
        v_lshr_b64      v[38:39], v[41:42], 24
        v_lshlrev_b32   v12, 8, v41
        v_xor_b32       v15, v35, v20
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v15, v11, vcc
        v_add_i32       v2, vcc, v7, v2
        v_addc_u32      v1, vcc, v34, v1, vcc
        v_or_b32        v12, v39, v12
        v_add_i32       v17, vcc, v38, v17
        v_addc_u32      v18, vcc, v12, v18, vcc
        v_add_i32       v14, vcc, v14, v13
        v_addc_u32      v16, vcc, v16, v37, vcc
        v_xor_b32       v35, v27, v9
        v_xor_b32       v36, v29, v11
        v_xor_b32       v3, v3, v1
        v_xor_b32       v39, v5, v17
        v_xor_b32       v40, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v28, v32, v2
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v24, vcc, v28, v24, vcc
        v_xor_b32       v26, v26, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v26, v10, vcc
        v_lshr_b64      v[31:32], v[35:36], 24
        v_lshlrev_b32   v22, 8, v35
        v_lshr_b64      v[35:36], v[39:40], 16
        v_lshlrev_b32   v5, 16, v39
        v_or_b32        v19, v32, v22
        v_add_i32       v20, vcc, v20, v31
        v_addc_u32      v21, vcc, v21, v19, vcc
        v_xor_b32       v39, v7, v23
        v_xor_b32       v40, v34, v24
        v_or_b32        v5, v36, v5
        v_xor_b32       v41, v13, v6
        v_xor_b32       v42, v37, v10
        v_add_i32       v25, vcc, v35, v25
        v_addc_u32      v29, vcc, v5, v30, vcc
        v_xor_b32       v43, v8, v20
        v_xor_b32       v44, v15, v21
        v_lshr_b64      v[32:33], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_lshr_b64      v[36:37], v[41:42], 24
        v_lshlrev_b32   v13, 8, v41
        v_xor_b32       v38, v38, v25
        v_xor_b32       v39, v12, v29
        v_or_b32        v7, v33, v7
        v_add_i32       v2, vcc, v2, v32
        v_addc_u32      v1, vcc, v1, v7, vcc
        v_or_b32        v13, v37, v13
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v13, vcc
        v_lshr_b64      v[33:34], v[43:44], 16
        v_lshlrev_b32   v8, 16, v43
        v_lshrrev_b32   v15, 31, v39
        v_lshl_b64      v[37:38], v[38:39], 1
        v_or_b32        v8, v34, v8
        v_add_i32       v9, vcc, v33, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_xor_b32       v39, v4, v14
        v_xor_b32       v40, v26, v16
        v_or_b32        v15, v15, v37
        v_xor_b32       v41, v3, v2
        v_xor_b32       v42, v28, v1
        v_add_i32       v14, vcc, v14, v15
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_xor_b32       v43, v31, v9
        v_xor_b32       v44, v19, v11
        v_lshr_b64      v[27:28], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[30:31], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_or_b32        v4, v28, v4
        v_add_i32       v6, vcc, v27, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v31, v3
        v_add_i32       v12, vcc, v30, v23
        v_addc_u32      v22, vcc, v3, v24, vcc
        v_lshrrev_b32   v23, 31, v44
        v_lshl_b64      v[39:40], v[43:44], 1
        v_xor_b32       v19, v33, v14
        v_add_i32       v24, vcc, v8, v12
        v_addc_u32      v26, vcc, v19, v22, vcc
        v_or_b32        v23, v23, v39
        v_xor_b32       v32, v32, v12
        v_xor_b32       v33, v7, v22
        v_xor_b32       v12, v36, v6
        v_xor_b32       v13, v13, v10
        v_add_i32       v2, vcc, v2, v23
        v_addc_u32      v1, vcc, v1, v40, vcc
        v_xor_b32       v41, v15, v24
        v_xor_b32       v42, v38, v26
        v_lshrrev_b32   v31, 31, v33
        v_lshl_b64      v[32:33], v[32:33], 1
        v_lshrrev_b32   v7, 31, v13
        v_lshl_b64      v[12:13], v[12:13], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[36:37], v[41:42], 24
        v_lshlrev_b32   v15, 8, v41
        v_or_b32        v22, v31, v32
        v_or_b32        v7, v7, v12
        v_xor_b32       v12, v2, v35
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v12, v10, vcc
        v_or_b32        v15, v37, v15
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v15, vcc
        v_add_i32       v17, vcc, v22, v17
        v_addc_u32      v18, vcc, v33, v18, vcc
        v_add_i32       v20, vcc, v7, v20
        v_addc_u32      v21, vcc, v13, v21, vcc
        v_xor_b32       v34, v23, v6
        v_xor_b32       v35, v40, v10
        v_xor_b32       v37, v8, v14
        v_xor_b32       v38, v19, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v21
        v_xor_b32       v27, v27, v17
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v27, v11, vcc
        v_xor_b32       v30, v30, v20
        v_add_i32       v25, vcc, v3, v25
        v_addc_u32      v29, vcc, v30, v29, vcc
        v_lshr_b64      v[31:32], v[34:35], 24
        v_lshlrev_b32   v23, 8, v34
        s_mov_b64       vcc, 0
        v_lshr_b64      v[34:35], v[37:38], 16
        v_lshlrev_b32   v8, 16, v37
        v_or_b32        v19, v32, v23
        v_addc_u32      v1, vcc, v1, v0, vcc
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v8, v35, v8
        v_add_i32       v23, vcc, v34, v24
        v_addc_u32      v24, vcc, v8, v26, vcc
        v_xor_b32       v37, v22, v9
        v_xor_b32       v38, v33, v11
        v_xor_b32       v39, v7, v25
        v_xor_b32       v40, v13, v29
        v_xor_b32       v41, v5, v2
        v_xor_b32       v42, v12, v1
        v_xor_b32       v43, v36, v23
        v_xor_b32       v44, v15, v24
        v_lshr_b64      v[32:33], v[37:38], 24
        v_lshlrev_b32   v22, 8, v37
        v_lshr_b64      v[35:36], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_or_b32        v13, v33, v22
        v_add_i32       v17, vcc, v32, v17
        v_addc_u32      v18, vcc, v13, v18, vcc
        v_or_b32        v7, v36, v7
        v_add_i32       v20, vcc, v35, v20
        v_addc_u32      v21, vcc, v7, v21, vcc
        v_lshr_b64      v[36:37], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_lshrrev_b32   v12, 31, v44
        v_lshl_b64      v[38:39], v[43:44], 1
        v_or_b32        v5, v37, v5
        v_add_i32       v6, vcc, v36, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_or_b32        v12, v12, v38
        v_xor_b32       v37, v4, v17
        v_xor_b32       v38, v27, v18
        v_xor_b32       v40, v3, v20
        v_xor_b32       v41, v30, v21
        v_add_i32       v17, vcc, v17, v12
        v_addc_u32      v18, vcc, v18, v39, vcc
        v_xor_b32       v42, v31, v6
        v_xor_b32       v43, v19, v10
        v_lshr_b64      v[27:28], v[37:38], 16
        v_lshlrev_b32   v4, 16, v37
        v_lshr_b64      v[30:31], v[40:41], 16
        v_lshlrev_b32   v3, 16, v40
        v_or_b32        v4, v28, v4
        v_add_i32       v9, vcc, v27, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v31, v3
        v_add_i32       v15, vcc, v30, v25
        v_addc_u32      v22, vcc, v3, v29, vcc
        v_xor_b32       v5, v5, v18
        v_lshrrev_b32   v25, 31, v43
        v_lshl_b64      v[28:29], v[42:43], 1
        v_xor_b32       v19, v36, v17
        v_add_i32       v26, vcc, v5, v15
        v_addc_u32      v31, vcc, v19, v22, vcc
        v_or_b32        v25, v25, v28
        v_xor_b32       v36, v32, v9
        v_xor_b32       v37, v13, v11
        v_xor_b32       v40, v35, v15
        v_xor_b32       v41, v7, v22
        v_add_i32       v20, vcc, v20, v25
        v_addc_u32      v21, vcc, v21, v29, vcc
        v_xor_b32       v42, v12, v26
        v_xor_b32       v43, v39, v31
        v_lshrrev_b32   v32, 31, v37
        v_lshl_b64      v[35:36], v[36:37], 1
        v_lshrrev_b32   v13, 31, v41
        v_lshl_b64      v[37:38], v[40:41], 1
        v_or_b32        v7, v32, v35
        v_or_b32        v13, v13, v37
        v_xor_b32       v8, v8, v21
        v_lshr_b64      v[32:33], v[42:43], 24
        v_lshlrev_b32   v12, 8, v42
        v_xor_b32       v15, v34, v20
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v15, v11, vcc
        v_add_i32       v2, vcc, v7, v2
        v_addc_u32      v1, vcc, v36, v1, vcc
        v_or_b32        v12, v33, v12
        v_add_i32       v17, vcc, v32, v17
        v_addc_u32      v18, vcc, v12, v18, vcc
        v_add_i32       v14, vcc, v14, v13
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_xor_b32       v33, v25, v9
        v_xor_b32       v34, v29, v11
        v_xor_b32       v3, v3, v1
        v_xor_b32       v39, v5, v17
        v_xor_b32       v40, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v28, v30, v2
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v24, vcc, v28, v24, vcc
        v_xor_b32       v27, v27, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v27, v10, vcc
        v_lshr_b64      v[29:30], v[33:34], 24
        v_lshlrev_b32   v22, 8, v33
        v_lshr_b64      v[33:34], v[39:40], 16
        v_lshlrev_b32   v5, 16, v39
        v_or_b32        v19, v30, v22
        v_add_i32       v20, vcc, v20, v29
        v_addc_u32      v21, vcc, v21, v19, vcc
        v_xor_b32       v39, v7, v23
        v_xor_b32       v40, v36, v24
        v_or_b32        v5, v34, v5
        v_xor_b32       v41, v13, v6
        v_xor_b32       v42, v38, v10
        v_add_i32       v26, vcc, v33, v26
        v_addc_u32      v30, vcc, v5, v31, vcc
        v_xor_b32       v43, v8, v20
        v_xor_b32       v44, v15, v21
        v_lshr_b64      v[34:35], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_lshr_b64      v[36:37], v[41:42], 24
        v_lshlrev_b32   v13, 8, v41
        v_xor_b32       v38, v32, v26
        v_xor_b32       v39, v12, v30
        v_or_b32        v7, v35, v7
        v_add_i32       v2, vcc, v2, v34
        v_addc_u32      v1, vcc, v1, v7, vcc
        v_or_b32        v13, v37, v13
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v13, vcc
        v_lshr_b64      v[31:32], v[43:44], 16
        v_lshlrev_b32   v8, 16, v43
        v_lshrrev_b32   v15, 31, v39
        v_lshl_b64      v[37:38], v[38:39], 1
        v_or_b32        v8, v32, v8
        v_add_i32       v9, vcc, v31, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_xor_b32       v39, v4, v14
        v_xor_b32       v40, v27, v16
        v_or_b32        v15, v15, v37
        v_xor_b32       v41, v3, v2
        v_xor_b32       v42, v28, v1
        v_add_i32       v14, vcc, v14, v15
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_xor_b32       v43, v29, v9
        v_xor_b32       v44, v19, v11
        v_lshr_b64      v[27:28], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[39:40], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_or_b32        v4, v28, v4
        v_add_i32       v6, vcc, v27, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v40, v3
        v_add_i32       v12, vcc, v39, v23
        v_addc_u32      v22, vcc, v3, v24, vcc
        v_lshrrev_b32   v23, 31, v44
        v_lshl_b64      v[24:25], v[43:44], 1
        v_xor_b32       v19, v31, v14
        v_add_i32       v28, vcc, v8, v12
        v_addc_u32      v29, vcc, v19, v22, vcc
        v_or_b32        v23, v23, v24
        v_xor_b32       v34, v34, v12
        v_xor_b32       v35, v7, v22
        v_xor_b32       v12, v36, v6
        v_xor_b32       v13, v13, v10
        v_add_i32       v2, vcc, v2, v23
        v_addc_u32      v1, vcc, v1, v25, vcc
        v_xor_b32       v40, v15, v28
        v_xor_b32       v41, v38, v29
        v_lshrrev_b32   v31, 31, v35
        v_lshl_b64      v[34:35], v[34:35], 1
        v_lshrrev_b32   v7, 31, v13
        v_lshl_b64      v[12:13], v[12:13], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[36:37], v[40:41], 24
        v_lshlrev_b32   v15, 8, v40
        v_or_b32        v22, v31, v34
        s_mov_b64       s[0:1], 0
        v_or_b32        v7, v7, v12
        v_xor_b32       v12, v2, v33
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v12, v10, vcc
        v_or_b32        v15, v37, v15
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v15, vcc
        v_addc_u32      v24, vcc, v35, v0, s[0:1]
        v_add_i32       v17, vcc, v22, v17
        v_addc_u32      v18, vcc, v24, v18, vcc
        v_add_i32       v20, vcc, v7, v20
        v_addc_u32      v21, vcc, v13, v21, vcc
        v_xor_b32       v23, v23, v6
        v_xor_b32       v24, v25, v10
        v_xor_b32       v37, v8, v14
        v_xor_b32       v38, v19, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v21
        v_xor_b32       v25, v27, v17
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v25, v11, vcc
        v_xor_b32       v27, v39, v20
        v_add_i32       v26, vcc, v3, v26
        v_addc_u32      v30, vcc, v27, v30, vcc
        v_lshr_b64      v[31:32], v[23:24], 24
        v_lshlrev_b32   v23, 8, v23
        v_lshr_b64      v[33:34], v[37:38], 16
        v_lshlrev_b32   v8, 16, v37
        v_or_b32        v19, v32, v23
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v8, v34, v8
        v_add_i32       v23, vcc, v33, v28
        v_addc_u32      v24, vcc, v8, v29, vcc
        v_xor_b32       v37, v22, v9
        v_xor_b32       v38, v35, v11
        v_xor_b32       v39, v7, v26
        v_xor_b32       v40, v13, v30
        v_xor_b32       v41, v5, v2
        v_xor_b32       v42, v12, v1
        v_xor_b32       v28, v36, v23
        v_xor_b32       v29, v15, v24
        v_lshr_b64      v[34:35], v[37:38], 24
        v_lshlrev_b32   v22, 8, v37
        v_lshr_b64      v[36:37], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_or_b32        v13, v35, v22
        v_add_i32       v17, vcc, v34, v17
        v_addc_u32      v18, vcc, v13, v18, vcc
        v_or_b32        v7, v37, v7
        v_add_i32       v20, vcc, v36, v20
        v_addc_u32      v21, vcc, v7, v21, vcc
        v_lshr_b64      v[37:38], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_lshrrev_b32   v12, 31, v29
        v_lshl_b64      v[28:29], v[28:29], 1
        v_or_b32        v5, v38, v5
        v_add_i32       v6, vcc, v37, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_or_b32        v12, v12, v28
        v_xor_b32       v38, v4, v17
        v_xor_b32       v39, v25, v18
        v_xor_b32       v40, v3, v20
        v_xor_b32       v41, v27, v21
        v_add_i32       v17, vcc, v17, v12
        v_addc_u32      v18, vcc, v18, v29, vcc
        v_xor_b32       v42, v31, v6
        v_xor_b32       v43, v19, v10
        v_lshr_b64      v[27:28], v[38:39], 16
        v_lshlrev_b32   v4, 16, v38
        v_lshr_b64      v[31:32], v[40:41], 16
        v_lshlrev_b32   v3, 16, v40
        v_or_b32        v4, v28, v4
        v_add_i32       v9, vcc, v27, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v32, v3
        v_add_i32       v15, vcc, v31, v26
        v_addc_u32      v22, vcc, v3, v30, vcc
        v_xor_b32       v5, v5, v18
        v_lshrrev_b32   v26, 31, v43
        v_lshl_b64      v[38:39], v[42:43], 1
        v_xor_b32       v19, v37, v17
        v_add_i32       v25, vcc, v5, v15
        v_addc_u32      v28, vcc, v19, v22, vcc
        v_or_b32        v26, v26, v38
        v_xor_b32       v34, v34, v9
        v_xor_b32       v35, v13, v11
        v_xor_b32       v36, v36, v15
        v_xor_b32       v37, v7, v22
        v_add_i32       v20, vcc, v20, v26
        v_addc_u32      v21, vcc, v21, v39, vcc
        v_xor_b32       v40, v12, v25
        v_xor_b32       v41, v29, v28
        v_lshrrev_b32   v29, 31, v35
        v_lshl_b64      v[34:35], v[34:35], 1
        v_lshrrev_b32   v13, 31, v37
        v_lshl_b64      v[36:37], v[36:37], 1
        s_mov_b64       vcc, 0
        v_or_b32        v7, v29, v34
        v_or_b32        v13, v13, v36
        v_addc_u32      v15, vcc, v21, v0, vcc
        v_lshr_b64      v[21:22], v[40:41], 24
        v_lshlrev_b32   v12, 8, v40
        v_xor_b32       v8, v8, v15
        v_add_i32       v2, vcc, v7, v2
        v_addc_u32      v1, vcc, v35, v1, vcc
        v_or_b32        v12, v22, v12
        v_add_i32       v17, vcc, v21, v17
        v_addc_u32      v18, vcc, v12, v18, vcc
        v_add_i32       v14, vcc, v14, v13
        v_addc_u32      v16, vcc, v16, v37, vcc
        v_xor_b32       v22, v33, v20
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v22, v11, vcc
        v_xor_b32       v3, v3, v1
        v_xor_b32       v33, v5, v17
        v_xor_b32       v34, v19, v18
        v_xor_b32       v4, v4, v16
        v_xor_b32       v38, v26, v9
        v_xor_b32       v39, v39, v11
        v_xor_b32       v30, v31, v2
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v24, vcc, v30, v24, vcc
        v_xor_b32       v27, v27, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v27, v10, vcc
        v_lshr_b64      v[31:32], v[33:34], 16
        v_lshlrev_b32   v5, 16, v33
        v_lshr_b64      v[33:34], v[38:39], 24
        v_lshlrev_b32   v19, 8, v38
        v_xor_b32       v38, v7, v23
        v_xor_b32       v39, v35, v24
        v_or_b32        v5, v32, v5
        v_xor_b32       v40, v13, v6
        v_xor_b32       v41, v37, v10
        v_add_i32       v25, vcc, v31, v25
        v_addc_u32      v28, vcc, v5, v28, vcc
        v_or_b32        v19, v34, v19
        v_add_i32       v20, vcc, v20, v33
        v_addc_u32      v15, vcc, v15, v19, vcc
        v_lshr_b64      v[34:35], v[38:39], 24
        v_lshlrev_b32   v7, 8, v38
        v_lshr_b64      v[36:37], v[40:41], 24
        v_lshlrev_b32   v13, 8, v40
        v_xor_b32       v38, v21, v25
        v_xor_b32       v39, v12, v28
        v_xor_b32       v40, v8, v20
        v_xor_b32       v41, v22, v15
        v_or_b32        v7, v35, v7
        v_add_i32       v2, vcc, v2, v34
        v_addc_u32      v1, vcc, v1, v7, vcc
        v_or_b32        v13, v37, v13
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v13, vcc
        v_lshrrev_b32   v26, 31, v39
        v_lshl_b64      v[37:38], v[38:39], 1
        v_lshr_b64      v[21:22], v[40:41], 16
        v_lshlrev_b32   v8, 16, v40
        v_xor_b32       v39, v4, v14
        v_xor_b32       v40, v27, v16
        v_or_b32        v26, v26, v37
        v_xor_b32       v41, v3, v2
        v_xor_b32       v42, v30, v1
        v_or_b32        v8, v22, v8
        v_add_i32       v9, vcc, v21, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_add_i32       v14, vcc, v14, v26
        v_addc_u32      v16, vcc, v16, v38, vcc
        v_lshr_b64      v[29:30], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[39:40], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_xor_b32       v32, v33, v9
        v_xor_b32       v33, v19, v11
        v_or_b32        v4, v30, v4
        v_add_i32       v6, vcc, v29, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v40, v3
        v_add_i32       v22, vcc, v39, v23
        v_addc_u32      v23, vcc, v3, v24, vcc
        v_xor_b32       v21, v21, v14
        v_add_i32       v24, vcc, v8, v22
        v_addc_u32      v27, vcc, v21, v23, vcc
        v_lshrrev_b32   v30, 31, v33
        v_lshl_b64      v[32:33], v[32:33], 1
        v_xor_b32       v34, v34, v22
        v_xor_b32       v35, v7, v23
        v_xor_b32       v12, v36, v6
        v_xor_b32       v13, v13, v10
        v_or_b32        v22, v30, v32
        v_xor_b32       v40, v26, v24
        v_xor_b32       v41, v38, v27
        v_add_i32       v2, vcc, v2, v22
        v_addc_u32      v1, vcc, v1, v33, vcc
        v_lshrrev_b32   v30, 31, v35
        v_lshl_b64      v[34:35], v[34:35], 1
        v_lshrrev_b32   v7, 31, v13
        v_lshl_b64      v[12:13], v[12:13], 1
        v_lshr_b64      v[36:37], v[40:41], 24
        v_lshlrev_b32   v19, 8, v40
        v_or_b32        v23, v30, v34
        v_or_b32        v7, v7, v12
        v_xor_b32       v5, v1, v5
        v_or_b32        v12, v37, v19
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_add_i32       v17, vcc, v23, v17
        v_addc_u32      v18, vcc, v35, v18, vcc
        v_add_i32       v19, vcc, v7, v20
        v_addc_u32      v15, vcc, v13, v15, vcc
        v_xor_b32       v20, v2, v31
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v20, v10, vcc
        v_xor_b32       v37, v8, v14
        v_xor_b32       v38, v21, v16
        v_xor_b32       v4, v4, v18
        v_xor_b32       v3, v3, v15
        v_xor_b32       v21, v22, v6
        v_xor_b32       v22, v33, v10
        v_xor_b32       v29, v29, v17
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v29, v11, vcc
        v_xor_b32       v30, v39, v19
        v_add_i32       v25, vcc, v3, v25
        v_addc_u32      v28, vcc, v30, v28, vcc
        v_lshr_b64      v[31:32], v[37:38], 16
        v_lshlrev_b32   v8, 16, v37
        v_lshr_b64      v[33:34], v[21:22], 24
        v_lshlrev_b32   v21, 8, v21
        v_or_b32        v8, v32, v8
        v_add_i32       v22, vcc, v31, v24
        v_addc_u32      v24, vcc, v8, v27, vcc
        v_xor_b32       v37, v23, v9
        v_xor_b32       v38, v35, v11
        v_xor_b32       v39, v7, v25
        v_xor_b32       v40, v13, v28
        v_or_b32        v21, v34, v21
        v_add_i32       v2, vcc, v2, v33
        v_addc_u32      v1, vcc, v1, v21, vcc
        v_xor_b32       v26, v36, v22
        v_xor_b32       v27, v12, v24
        v_lshr_b64      v[34:35], v[37:38], 24
        v_lshlrev_b32   v23, 8, v37
        v_lshr_b64      v[36:37], v[39:40], 24
        v_lshlrev_b32   v7, 8, v39
        v_xor_b32       v38, v5, v2
        v_xor_b32       v39, v20, v1
        v_or_b32        v20, v35, v23
        v_add_i32       v17, vcc, v34, v17
        v_addc_u32      v18, vcc, v20, v18, vcc
        v_or_b32        v7, v37, v7
        v_add_i32       v19, vcc, v36, v19
        v_addc_u32      v15, vcc, v7, v15, vcc
        v_lshrrev_b32   v23, 31, v27
        v_lshl_b64      v[26:27], v[26:27], 1
        v_lshr_b64      v[12:13], v[38:39], 16
        v_lshlrev_b32   v5, 16, v38
        v_or_b32        v23, v23, v26
        v_xor_b32       v39, v4, v17
        v_xor_b32       v40, v29, v18
        v_xor_b32       v41, v3, v19
        v_xor_b32       v42, v30, v15
        v_or_b32        v5, v13, v5
        v_add_i32       v6, vcc, v12, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_add_i32       v13, vcc, v17, v23
        v_addc_u32      v17, vcc, v18, v27, vcc
        v_lshr_b64      v[37:38], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[29:30], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_xor_b32       v39, v33, v6
        v_xor_b32       v40, v21, v10
        v_or_b32        v4, v38, v4
        v_add_i32       v9, vcc, v37, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v30, v3
        v_add_i32       v25, vcc, v29, v25
        v_addc_u32      v26, vcc, v3, v28, vcc
        v_xor_b32       v5, v5, v17
        v_xor_b32       v12, v12, v13
        v_add_i32       v28, vcc, v5, v25
        v_addc_u32      v30, vcc, v12, v26, vcc
        v_lshrrev_b32   v32, 31, v40
        v_lshl_b64      v[38:39], v[39:40], 1
        v_xor_b32       v33, v34, v9
        v_xor_b32       v34, v20, v11
        v_xor_b32       v20, v36, v25
        v_xor_b32       v21, v7, v26
        v_or_b32        v25, v32, v38
        v_xor_b32       v35, v23, v28
        v_xor_b32       v36, v27, v30
        v_lshrrev_b32   v27, 31, v34
        v_lshl_b64      v[32:33], v[33:34], 1
        v_lshrrev_b32   v18, 31, v21
        v_lshl_b64      v[20:21], v[20:21], 1
        v_add_i32       v7, vcc, v19, v25
        v_addc_u32      v15, vcc, v15, v39, vcc
        v_or_b32        v19, v27, v32
        v_or_b32        v18, v18, v20
        v_lshr_b64      v[26:27], v[35:36], 24
        v_lshlrev_b32   v20, 8, v35
        v_xor_b32       v8, v8, v15
        v_add_i32       v2, vcc, v19, v2
        v_addc_u32      v1, vcc, v33, v1, vcc
        v_or_b32        v20, v27, v20
        v_add_i32       v13, vcc, v26, v13
        v_addc_u32      v17, vcc, v20, v17, vcc
        v_add_i32       v14, vcc, v14, v18
        v_addc_u32      v16, vcc, v16, v21, vcc
        v_xor_b32       v23, v31, v7
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v23, v11, vcc
        v_xor_b32       v3, v3, v1
        v_xor_b32       v40, v5, v13
        v_xor_b32       v41, v12, v17
        v_xor_b32       v4, v4, v16
        v_xor_b32       v38, v25, v9
        v_xor_b32       v39, v39, v11
        v_xor_b32       v29, v29, v2
        v_add_i32       v22, vcc, v3, v22
        v_addc_u32      v24, vcc, v29, v24, vcc
        v_xor_b32       v31, v37, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v31, v10, vcc
        v_lshr_b64      v[34:35], v[40:41], 16
        v_lshlrev_b32   v5, 16, v40
        v_lshr_b64      v[36:37], v[38:39], 24
        v_lshlrev_b32   v12, 8, v38
        v_xor_b32       v38, v19, v22
        v_xor_b32       v39, v33, v24
        v_or_b32        v5, v35, v5
        v_xor_b32       v40, v18, v6
        v_xor_b32       v41, v21, v10
        v_add_i32       v27, vcc, v34, v28
        v_addc_u32      v28, vcc, v5, v30, vcc
        v_or_b32        v12, v37, v12
        v_add_i32       v7, vcc, v7, v36
        v_addc_u32      v15, vcc, v15, v12, vcc
        v_lshr_b64      v[32:33], v[38:39], 24
        v_lshlrev_b32   v19, 8, v38
        v_lshr_b64      v[37:38], v[40:41], 24
        v_lshlrev_b32   v18, 8, v40
        s_mov_b64       s[0:1], 0
        v_xor_b32       v39, v26, v27
        v_xor_b32       v40, v20, v28
        v_xor_b32       v41, v8, v7
        v_xor_b32       v42, v23, v15
        v_or_b32        v19, v33, v19
        v_add_i32       v2, vcc, v2, v32
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v18, v38, v18
        v_addc_u32      v16, vcc, v16, v0, s[0:1]
        v_add_i32       v14, vcc, v14, v37
        v_addc_u32      v16, vcc, v16, v18, vcc
        v_lshrrev_b32   v25, 31, v40
        v_lshl_b64      v[20:21], v[39:40], 1
        v_lshr_b64      v[38:39], v[41:42], 16
        v_lshlrev_b32   v8, 16, v41
        v_xor_b32       v40, v4, v14
        v_xor_b32       v41, v31, v16
        v_or_b32        v20, v25, v20
        v_xor_b32       v42, v3, v2
        v_xor_b32       v43, v29, v1
        v_or_b32        v8, v39, v8
        v_add_i32       v9, vcc, v38, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_add_i32       v14, vcc, v14, v20
        v_addc_u32      v16, vcc, v16, v21, vcc
        v_lshr_b64      v[29:30], v[40:41], 16
        v_lshlrev_b32   v4, 16, v40
        v_lshr_b64      v[25:26], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_xor_b32       v35, v36, v9
        v_xor_b32       v36, v12, v11
        v_or_b32        v4, v30, v4
        v_add_i32       v6, vcc, v29, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v26, v3
        v_add_i32       v22, vcc, v25, v22
        v_addc_u32      v24, vcc, v3, v24, vcc
        v_xor_b32       v26, v38, v14
        v_add_i32       v30, vcc, v8, v22
        v_addc_u32      v31, vcc, v26, v24, vcc
        v_lshrrev_b32   v33, 31, v36
        v_lshl_b64      v[35:36], v[35:36], 1
        v_xor_b32       v38, v32, v22
        v_xor_b32       v39, v19, v24
        v_xor_b32       v40, v37, v6
        v_xor_b32       v41, v18, v10
        v_or_b32        v23, v33, v35
        v_xor_b32       v20, v20, v30
        v_xor_b32       v21, v21, v31
        v_add_i32       v2, vcc, v2, v23
        v_addc_u32      v1, vcc, v1, v36, vcc
        v_lshrrev_b32   v24, 31, v39
        v_lshl_b64      v[32:33], v[38:39], 1
        v_lshrrev_b32   v12, 31, v41
        v_lshl_b64      v[18:19], v[40:41], 1
        v_lshr_b64      v[21:22], v[20:21], 24
        v_lshlrev_b32   v20, 8, v20
        v_or_b32        v24, v24, v32
        v_or_b32        v12, v12, v18
        v_xor_b32       v5, v1, v5
        v_or_b32        v18, v22, v20
        v_add_i32       v14, vcc, v14, v21
        v_addc_u32      v16, vcc, v16, v18, vcc
        v_add_i32       v13, vcc, v24, v13
        v_addc_u32      v17, vcc, v33, v17, vcc
        v_add_i32       v7, vcc, v12, v7
        v_addc_u32      v15, vcc, v19, v15, vcc
        v_xor_b32       v20, v2, v34
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v20, v10, vcc
        v_xor_b32       v37, v8, v14
        v_xor_b32       v38, v26, v16
        v_xor_b32       v4, v4, v17
        v_xor_b32       v3, v3, v15
        v_xor_b32       v22, v23, v6
        v_xor_b32       v23, v36, v10
        v_xor_b32       v29, v29, v13
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v29, v11, vcc
        v_xor_b32       v25, v25, v7
        v_add_i32       v27, vcc, v3, v27
        v_addc_u32      v28, vcc, v25, v28, vcc
        v_lshr_b64      v[34:35], v[37:38], 16
        v_lshlrev_b32   v8, 16, v37
        v_lshr_b64      v[36:37], v[22:23], 24
        v_lshlrev_b32   v22, 8, v22
        v_or_b32        v8, v35, v8
        v_add_i32       v23, vcc, v34, v30
        v_addc_u32      v26, vcc, v8, v31, vcc
        v_xor_b32       v32, v24, v9
        v_xor_b32       v33, v33, v11
        v_xor_b32       v38, v12, v27
        v_xor_b32       v39, v19, v28
        v_or_b32        v22, v37, v22
        v_add_i32       v2, vcc, v2, v36
        v_addc_u32      v1, vcc, v1, v22, vcc
        v_xor_b32       v40, v21, v23
        v_xor_b32       v41, v18, v26
        v_lshr_b64      v[30:31], v[32:33], 24
        v_lshlrev_b32   v24, 8, v32
        v_lshr_b64      v[32:33], v[38:39], 24
        v_lshlrev_b32   v12, 8, v38
        v_xor_b32       v42, v5, v2
        v_xor_b32       v43, v20, v1
        v_or_b32        v20, v31, v24
        v_add_i32       v13, vcc, v30, v13
        v_addc_u32      v17, vcc, v20, v17, vcc
        v_or_b32        v12, v33, v12
        v_add_i32       v7, vcc, v32, v7
        v_addc_u32      v15, vcc, v12, v15, vcc
        v_lshrrev_b32   v24, 31, v41
        v_lshl_b64      v[37:38], v[40:41], 1
        v_lshr_b64      v[18:19], v[42:43], 16
        v_lshlrev_b32   v5, 16, v42
        v_or_b32        v21, v24, v37
        v_xor_b32       v41, v4, v13
        v_xor_b32       v42, v29, v17
        v_xor_b32       v43, v3, v7
        v_xor_b32       v44, v25, v15
        v_or_b32        v5, v19, v5
        v_add_i32       v6, vcc, v18, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_add_i32       v13, vcc, v13, v21
        v_addc_u32      v17, vcc, v17, v38, vcc
        v_lshr_b64      v[39:40], v[41:42], 16
        v_lshlrev_b32   v4, 16, v41
        v_lshr_b64      v[24:25], v[43:44], 16
        v_lshlrev_b32   v3, 16, v43
        v_xor_b32       v35, v36, v6
        v_xor_b32       v36, v22, v10
        v_or_b32        v4, v40, v4
        v_add_i32       v9, vcc, v39, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v25, v3
        v_add_i32       v25, vcc, v24, v27
        v_addc_u32      v27, vcc, v3, v28, vcc
        v_xor_b32       v5, v5, v17
        v_xor_b32       v18, v18, v13
        v_add_i32       v28, vcc, v5, v25
        v_addc_u32      v29, vcc, v18, v27, vcc
        v_lshrrev_b32   v31, 31, v36
        v_lshl_b64      v[35:36], v[35:36], 1
        v_xor_b32       v19, v30, v9
        v_xor_b32       v20, v20, v11
        v_or_b32        v22, v31, v35
        v_xor_b32       v31, v32, v25
        v_xor_b32       v32, v12, v27
        v_xor_b32       v40, v21, v28
        v_xor_b32       v41, v38, v29
        v_lshrrev_b32   v30, 31, v20
        v_lshl_b64      v[19:20], v[19:20], 1
        v_add_i32       v7, vcc, v7, v22
        v_addc_u32      v15, vcc, v15, v36, vcc
        v_or_b32        v19, v30, v19
        v_lshrrev_b32   v30, 31, v32
        v_lshl_b64      v[31:32], v[31:32], 1
        v_lshr_b64      v[37:38], v[40:41], 24
        v_lshlrev_b32   v12, 8, v40
        v_or_b32        v21, v30, v31
        v_xor_b32       v8, v8, v15
        v_add_i32       v2, vcc, v19, v2
        v_addc_u32      v1, vcc, v20, v1, vcc
        v_or_b32        v12, v38, v12
        v_add_i32       v13, vcc, v37, v13
        v_addc_u32      v17, vcc, v12, v17, vcc
        v_xor_b32       v25, v34, v7
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v25, v11, vcc
        v_add_i32       v14, vcc, v14, v21
        v_addc_u32      v16, vcc, v16, v32, vcc
        v_xor_b32       v3, v3, v1
        v_xor_b32       v33, v5, v13
        v_xor_b32       v34, v18, v17
        v_xor_b32       v35, v22, v9
        v_xor_b32       v36, v36, v11
        v_xor_b32       v24, v24, v2
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v26, vcc, v24, v26, vcc
        v_xor_b32       v4, v4, v16
        v_lshr_b64      v[30:31], v[33:34], 16
        v_lshlrev_b32   v5, 16, v33
        v_xor_b32       v18, v39, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v18, v10, vcc
        v_lshr_b64      v[33:34], v[35:36], 24
        v_lshlrev_b32   v22, 8, v35
        v_xor_b32       v19, v19, v23
        v_xor_b32       v20, v20, v26
        v_or_b32        v5, v31, v5
        v_add_i32       v27, vcc, v30, v28
        v_addc_u32      v28, vcc, v5, v29, vcc
        v_or_b32        v22, v34, v22
        v_add_i32       v7, vcc, v7, v33
        v_addc_u32      v15, vcc, v15, v22, vcc
        v_xor_b32       v38, v21, v6
        v_xor_b32       v39, v32, v10
        v_lshr_b64      v[31:32], v[19:20], 24
        v_lshlrev_b32   v19, 8, v19
        v_xor_b32       v36, v37, v27
        v_xor_b32       v37, v12, v28
        v_xor_b32       v40, v8, v7
        v_xor_b32       v41, v25, v15
        v_or_b32        v19, v32, v19
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_lshr_b64      v[34:35], v[38:39], 24
        v_lshlrev_b32   v21, 8, v38
        v_or_b32        v21, v35, v21
        v_add_i32       v14, vcc, v14, v34
        v_addc_u32      v16, vcc, v16, v21, vcc
        v_lshrrev_b32   v29, 31, v37
        v_lshl_b64      v[35:36], v[36:37], 1
        v_lshr_b64      v[37:38], v[40:41], 16
        v_lshlrev_b32   v8, 16, v40
        v_or_b32        v12, v29, v35
        s_mov_b64       s[0:1], 0
        v_xor_b32       v39, v3, v2
        v_xor_b32       v40, v24, v1
        v_or_b32        v8, v38, v8
        v_add_i32       v9, vcc, v37, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_xor_b32       v41, v4, v14
        v_xor_b32       v42, v18, v16
        v_addc_u32      v16, vcc, v16, v0, s[0:1]
        v_add_i32       v14, vcc, v14, v12
        v_addc_u32      v16, vcc, v16, v36, vcc
        v_lshr_b64      v[24:25], v[39:40], 16
        v_lshlrev_b32   v3, 16, v39
        v_xor_b32       v38, v33, v9
        v_xor_b32       v39, v22, v11
        v_lshr_b64      v[32:33], v[41:42], 16
        v_lshlrev_b32   v4, 16, v41
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v25, v3
        v_add_i32       v18, vcc, v24, v23
        v_addc_u32      v23, vcc, v3, v26, vcc
        v_or_b32        v4, v33, v4
        v_add_i32       v6, vcc, v32, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v25, v37, v14
        v_add_i32       v26, vcc, v8, v18
        v_addc_u32      v29, vcc, v25, v23, vcc
        v_lshrrev_b32   v33, 31, v39
        v_lshl_b64      v[37:38], v[38:39], 1
        v_or_b32        v20, v33, v37
        v_xor_b32       v35, v12, v26
        v_xor_b32       v36, v36, v29
        v_xor_b32       v18, v31, v18
        v_xor_b32       v19, v19, v23
        v_xor_b32       v39, v34, v6
        v_xor_b32       v40, v21, v10
        v_add_i32       v2, vcc, v2, v20
        v_addc_u32      v1, vcc, v1, v38, vcc
        v_lshr_b64      v[33:34], v[35:36], 24
        v_lshlrev_b32   v12, 8, v35
        v_lshrrev_b32   v22, 31, v19
        v_lshl_b64      v[18:19], v[18:19], 1
        v_lshrrev_b32   v31, 31, v40
        v_lshl_b64      v[35:36], v[39:40], 1
        v_xor_b32       v5, v1, v5
        v_or_b32        v12, v34, v12
        v_add_i32       v14, vcc, v14, v33
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_or_b32        v18, v22, v18
        v_or_b32        v21, v31, v35
        v_xor_b32       v22, v2, v30
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v22, v10, vcc
        v_add_i32       v13, vcc, v18, v13
        v_addc_u32      v17, vcc, v19, v17, vcc
        v_add_i32       v7, vcc, v21, v7
        v_addc_u32      v15, vcc, v36, v15, vcc
        v_xor_b32       v34, v8, v14
        v_xor_b32       v35, v25, v16
        v_xor_b32       v37, v20, v6
        v_xor_b32       v38, v38, v10
        v_xor_b32       v4, v4, v17
        v_xor_b32       v3, v3, v15
        v_lshr_b64      v[30:31], v[34:35], 16
        v_lshlrev_b32   v8, 16, v34
        v_xor_b32       v23, v32, v13
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v23, v11, vcc
        v_xor_b32       v24, v24, v7
        v_add_i32       v27, vcc, v3, v27
        v_addc_u32      v28, vcc, v24, v28, vcc
        v_lshr_b64      v[34:35], v[37:38], 24
        v_lshlrev_b32   v20, 8, v37
        v_or_b32        v8, v31, v8
        v_add_i32       v25, vcc, v30, v26
        v_addc_u32      v26, vcc, v8, v29, vcc
        v_or_b32        v20, v35, v20
        v_add_i32       v2, vcc, v2, v34
        v_addc_u32      v1, vcc, v1, v20, vcc
        v_xor_b32       v18, v18, v9
        v_xor_b32       v19, v19, v11
        v_xor_b32       v37, v21, v27
        v_xor_b32       v38, v36, v28
        v_xor_b32       v39, v33, v25
        v_xor_b32       v40, v12, v26
        v_xor_b32       v41, v5, v2
        v_xor_b32       v42, v22, v1
        v_lshr_b64      v[32:33], v[18:19], 24
        v_lshlrev_b32   v18, 8, v18
        v_lshr_b64      v[35:36], v[37:38], 24
        v_lshlrev_b32   v19, 8, v37
        v_lshrrev_b32   v21, 31, v40
        v_lshl_b64      v[37:38], v[39:40], 1
        v_or_b32        v12, v33, v18
        v_add_i32       v13, vcc, v32, v13
        v_addc_u32      v17, vcc, v12, v17, vcc
        v_or_b32        v18, v36, v19
        v_add_i32       v7, vcc, v35, v7
        v_addc_u32      v15, vcc, v18, v15, vcc
        v_lshr_b64      v[39:40], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_or_b32        v19, v21, v37
        v_or_b32        v5, v40, v5
        v_add_i32       v6, vcc, v39, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_xor_b32       v36, v4, v13
        v_xor_b32       v37, v23, v17
        v_xor_b32       v40, v3, v7
        v_xor_b32       v41, v24, v15
        v_add_i32       v13, vcc, v13, v19
        v_addc_u32      v17, vcc, v17, v38, vcc
        s_mov_b64       vcc, 0
        v_xor_b32       v42, v34, v6
        v_xor_b32       v43, v20, v10
        v_lshr_b64      v[33:34], v[36:37], 16
        v_lshlrev_b32   v4, 16, v36
        v_lshr_b64      v[21:22], v[40:41], 16
        v_lshlrev_b32   v3, 16, v40
        v_addc_u32      v17, vcc, v17, v0, vcc
        v_or_b32        v4, v34, v4
        v_add_i32       v9, vcc, v33, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v22, v3
        v_add_i32       v22, vcc, v21, v27
        v_addc_u32      v24, vcc, v3, v28, vcc
        v_xor_b32       v5, v5, v17
        v_lshrrev_b32   v27, 31, v43
        v_lshl_b64      v[28:29], v[42:43], 1
        v_xor_b32       v20, v39, v13
        v_add_i32       v23, vcc, v5, v22
        v_addc_u32      v31, vcc, v20, v24, vcc
        v_or_b32        v27, v27, v28
        v_xor_b32       v36, v32, v9
        v_xor_b32       v37, v12, v11
        v_xor_b32       v39, v35, v22
        v_xor_b32       v40, v18, v24
        v_add_i32       v7, vcc, v7, v27
        v_addc_u32      v15, vcc, v15, v29, vcc
        v_xor_b32       v41, v19, v23
        v_xor_b32       v42, v38, v31
        v_lshrrev_b32   v32, 31, v37
        v_lshl_b64      v[34:35], v[36:37], 1
        v_lshrrev_b32   v12, 31, v40
        v_lshl_b64      v[36:37], v[39:40], 1
        v_or_b32        v18, v32, v34
        v_or_b32        v12, v12, v36
        v_xor_b32       v8, v8, v15
        v_lshr_b64      v[38:39], v[41:42], 24
        v_lshlrev_b32   v19, 8, v41
        v_xor_b32       v22, v30, v7
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v22, v11, vcc
        v_add_i32       v2, vcc, v18, v2
        v_addc_u32      v1, vcc, v35, v1, vcc
        v_or_b32        v19, v39, v19
        v_add_i32       v13, vcc, v38, v13
        v_addc_u32      v17, vcc, v19, v17, vcc
        v_add_i32       v14, vcc, v14, v12
        v_addc_u32      v16, vcc, v16, v37, vcc
        v_xor_b32       v39, v27, v9
        v_xor_b32       v40, v29, v11
        v_xor_b32       v3, v3, v1
        v_xor_b32       v41, v5, v13
        v_xor_b32       v42, v20, v17
        v_xor_b32       v4, v4, v16
        v_xor_b32       v21, v21, v2
        v_add_i32       v25, vcc, v3, v25
        v_addc_u32      v26, vcc, v21, v26, vcc
        v_xor_b32       v28, v33, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v28, v10, vcc
        v_lshr_b64      v[29:30], v[39:40], 24
        v_lshlrev_b32   v24, 8, v39
        v_lshr_b64      v[32:33], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_or_b32        v20, v30, v24
        v_add_i32       v7, vcc, v7, v29
        v_addc_u32      v15, vcc, v15, v20, vcc
        v_xor_b32       v39, v18, v25
        v_xor_b32       v40, v35, v26
        v_or_b32        v5, v33, v5
        v_xor_b32       v41, v12, v6
        v_xor_b32       v42, v37, v10
        v_add_i32       v23, vcc, v32, v23
        v_addc_u32      v30, vcc, v5, v31, vcc
        v_xor_b32       v43, v8, v7
        v_xor_b32       v44, v22, v15
        v_lshr_b64      v[33:34], v[39:40], 24
        v_lshlrev_b32   v18, 8, v39
        v_lshr_b64      v[35:36], v[41:42], 24
        v_lshlrev_b32   v12, 8, v41
        v_xor_b32       v38, v38, v23
        v_xor_b32       v39, v19, v30
        v_or_b32        v18, v34, v18
        v_add_i32       v2, vcc, v2, v33
        v_addc_u32      v1, vcc, v1, v18, vcc
        v_or_b32        v12, v36, v12
        v_add_i32       v14, vcc, v14, v35
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_lshr_b64      v[36:37], v[43:44], 16
        v_lshlrev_b32   v8, 16, v43
        v_lshrrev_b32   v22, 31, v39
        v_lshl_b64      v[38:39], v[38:39], 1
        v_or_b32        v8, v37, v8
        v_add_i32       v9, vcc, v36, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_xor_b32       v40, v4, v14
        v_xor_b32       v41, v28, v16
        v_or_b32        v22, v22, v38
        v_xor_b32       v42, v3, v2
        v_xor_b32       v43, v21, v1
        v_add_i32       v14, vcc, v14, v22
        v_addc_u32      v16, vcc, v16, v39, vcc
        v_xor_b32       v44, v29, v9
        v_xor_b32       v45, v20, v11
        v_lshr_b64      v[27:28], v[40:41], 16
        v_lshlrev_b32   v4, 16, v40
        v_lshr_b64      v[37:38], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_or_b32        v4, v28, v4
        v_add_i32       v6, vcc, v27, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v38, v3
        v_add_i32       v19, vcc, v37, v25
        v_addc_u32      v21, vcc, v3, v26, vcc
        v_lshrrev_b32   v25, 31, v45
        v_lshl_b64      v[28:29], v[44:45], 1
        v_xor_b32       v20, v36, v14
        v_add_i32       v24, vcc, v8, v19
        v_addc_u32      v26, vcc, v20, v21, vcc
        v_or_b32        v25, v25, v28
        v_xor_b32       v33, v33, v19
        v_xor_b32       v34, v18, v21
        v_xor_b32       v35, v35, v6
        v_xor_b32       v36, v12, v10
        v_add_i32       v2, vcc, v2, v25
        v_addc_u32      v1, vcc, v1, v29, vcc
        v_xor_b32       v21, v22, v24
        v_xor_b32       v22, v39, v26
        v_lshrrev_b32   v31, 31, v34
        v_lshl_b64      v[18:19], v[33:34], 1
        v_lshrrev_b32   v33, 31, v36
        v_lshl_b64      v[34:35], v[35:36], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[38:39], v[21:22], 24
        v_lshlrev_b32   v12, 8, v21
        v_or_b32        v18, v31, v18
        v_or_b32        v21, v33, v34
        v_xor_b32       v22, v2, v32
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v22, v10, vcc
        v_or_b32        v12, v39, v12
        v_add_i32       v14, vcc, v14, v38
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_add_i32       v13, vcc, v18, v13
        v_addc_u32      v17, vcc, v19, v17, vcc
        v_add_i32       v7, vcc, v21, v7
        v_addc_u32      v15, vcc, v35, v15, vcc
        v_xor_b32       v33, v25, v6
        v_xor_b32       v34, v29, v10
        v_xor_b32       v39, v8, v14
        v_xor_b32       v40, v20, v16
        v_xor_b32       v4, v4, v17
        v_xor_b32       v3, v3, v15
        v_xor_b32       v27, v27, v13
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v27, v11, vcc
        v_xor_b32       v29, v37, v7
        v_add_i32       v23, vcc, v3, v23
        v_addc_u32      v30, vcc, v29, v30, vcc
        v_lshr_b64      v[31:32], v[33:34], 24
        v_lshlrev_b32   v25, 8, v33
        v_lshr_b64      v[33:34], v[39:40], 16
        v_lshlrev_b32   v8, 16, v39
        v_or_b32        v20, v32, v25
        v_add_i32       v2, vcc, v2, v31
        v_addc_u32      v1, vcc, v1, v20, vcc
        v_or_b32        v8, v34, v8
        v_add_i32       v24, vcc, v33, v24
        v_addc_u32      v25, vcc, v8, v26, vcc
        v_xor_b32       v18, v18, v9
        v_xor_b32       v19, v19, v11
        v_xor_b32       v39, v21, v23
        v_xor_b32       v40, v35, v30
        v_xor_b32       v41, v5, v2
        v_xor_b32       v42, v22, v1
        v_xor_b32       v43, v38, v24
        v_xor_b32       v44, v12, v25
        v_lshr_b64      v[34:35], v[18:19], 24
        v_lshlrev_b32   v18, 8, v18
        v_lshr_b64      v[36:37], v[39:40], 24
        v_lshlrev_b32   v19, 8, v39
        v_or_b32        v18, v35, v18
        v_add_i32       v13, vcc, v34, v13
        v_addc_u32      v17, vcc, v18, v17, vcc
        v_or_b32        v19, v37, v19
        v_add_i32       v7, vcc, v36, v7
        v_addc_u32      v15, vcc, v19, v15, vcc
        v_lshr_b64      v[21:22], v[41:42], 16
        v_lshlrev_b32   v5, 16, v41
        v_lshrrev_b32   v26, 31, v44
        v_lshl_b64      v[37:38], v[43:44], 1
        v_or_b32        v5, v22, v5
        v_add_i32       v6, vcc, v21, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_or_b32        v12, v26, v37
        v_xor_b32       v39, v4, v13
        v_xor_b32       v40, v27, v17
        v_xor_b32       v41, v3, v7
        v_xor_b32       v42, v29, v15
        v_add_i32       v13, vcc, v13, v12
        v_addc_u32      v17, vcc, v17, v38, vcc
        v_xor_b32       v43, v31, v6
        v_xor_b32       v44, v20, v10
        v_lshr_b64      v[28:29], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[31:32], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_or_b32        v4, v29, v4
        v_add_i32       v9, vcc, v28, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v32, v3
        v_add_i32       v22, vcc, v31, v23
        v_addc_u32      v23, vcc, v3, v30, vcc
        v_xor_b32       v5, v5, v17
        v_lshrrev_b32   v26, 31, v44
        v_lshl_b64      v[29:30], v[43:44], 1
        v_xor_b32       v20, v21, v13
        v_add_i32       v21, vcc, v5, v22
        v_addc_u32      v27, vcc, v20, v23, vcc
        v_or_b32        v26, v26, v29
        v_xor_b32       v34, v34, v9
        v_xor_b32       v35, v18, v11
        v_xor_b32       v36, v36, v22
        v_xor_b32       v37, v19, v23
        v_add_i32       v7, vcc, v7, v26
        v_addc_u32      v15, vcc, v15, v30, vcc
        v_xor_b32       v39, v12, v21
        v_xor_b32       v40, v38, v27
        v_lshrrev_b32   v32, 31, v35
        v_lshl_b64      v[34:35], v[34:35], 1
        v_lshrrev_b32   v18, 31, v37
        v_lshl_b64      v[36:37], v[36:37], 1
        v_or_b32        v19, v32, v34
        v_or_b32        v18, v18, v36
        v_xor_b32       v8, v8, v15
        v_lshr_b64      v[22:23], v[39:40], 24
        v_lshlrev_b32   v12, 8, v39
        v_xor_b32       v29, v33, v7
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v29, v11, vcc
        v_add_i32       v2, vcc, v19, v2
        v_addc_u32      v1, vcc, v35, v1, vcc
        v_or_b32        v12, v23, v12
        v_add_i32       v13, vcc, v22, v13
        v_addc_u32      v17, vcc, v12, v17, vcc
        v_add_i32       v14, vcc, v14, v18
        v_addc_u32      v16, vcc, v16, v37, vcc
        v_xor_b32       v33, v26, v9
        v_xor_b32       v34, v30, v11
        v_xor_b32       v3, v3, v1
        v_xor_b32       v38, v5, v13
        v_xor_b32       v39, v20, v17
        v_xor_b32       v4, v4, v16
        v_xor_b32       v30, v31, v2
        v_add_i32       v24, vcc, v3, v24
        v_addc_u32      v25, vcc, v30, v25, vcc
        v_xor_b32       v28, v28, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v28, v10, vcc
        v_lshr_b64      v[31:32], v[33:34], 24
        v_lshlrev_b32   v23, 8, v33
        v_lshr_b64      v[33:34], v[38:39], 16
        v_lshlrev_b32   v5, 16, v38
        v_or_b32        v20, v32, v23
        v_add_i32       v7, vcc, v7, v31
        v_addc_u32      v15, vcc, v15, v20, vcc
        v_xor_b32       v38, v19, v24
        v_xor_b32       v39, v35, v25
        v_or_b32        v5, v34, v5
        v_xor_b32       v40, v18, v6
        v_xor_b32       v41, v37, v10
        v_add_i32       v21, vcc, v33, v21
        v_addc_u32      v27, vcc, v5, v27, vcc
        v_xor_b32       v42, v8, v7
        v_xor_b32       v43, v29, v15
        v_lshr_b64      v[34:35], v[38:39], 24
        v_lshlrev_b32   v19, 8, v38
        s_mov_b64       vcc, 0
        v_lshr_b64      v[36:37], v[40:41], 24
        v_lshlrev_b32   v18, 8, v40
        v_xor_b32       v39, v22, v21
        v_xor_b32       v40, v12, v27
        v_or_b32        v19, v35, v19
        v_addc_u32      v1, vcc, v0, v1, vcc
        v_add_i32       v2, vcc, v2, v34
        v_addc_u32      v1, vcc, v1, v19, vcc
        v_or_b32        v18, v37, v18
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v18, vcc
        v_lshr_b64      v[37:38], v[42:43], 16
        v_lshlrev_b32   v8, 16, v42
        v_lshrrev_b32   v23, 31, v40
        v_lshl_b64      v[39:40], v[39:40], 1
        v_or_b32        v8, v38, v8
        v_add_i32       v9, vcc, v37, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_xor_b32       v41, v4, v14
        v_xor_b32       v42, v28, v16
        v_or_b32        v22, v23, v39
        v_xor_b32       v38, v3, v2
        v_xor_b32       v39, v30, v1
        v_add_i32       v14, vcc, v14, v22
        v_addc_u32      v16, vcc, v16, v40, vcc
        v_xor_b32       v43, v31, v9
        v_xor_b32       v44, v20, v11
        v_lshr_b64      v[28:29], v[41:42], 16
        v_lshlrev_b32   v4, 16, v41
        v_lshr_b64      v[30:31], v[38:39], 16
        v_lshlrev_b32   v3, 16, v38
        v_or_b32        v4, v29, v4
        v_add_i32       v6, vcc, v28, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_xor_b32       v8, v8, v16
        v_or_b32        v3, v31, v3
        v_add_i32       v12, vcc, v30, v24
        v_addc_u32      v23, vcc, v3, v25, vcc
        v_lshrrev_b32   v24, 31, v44
        v_lshl_b64      v[25:26], v[43:44], 1
        v_xor_b32       v20, v37, v14
        v_add_i32       v29, vcc, v8, v12
        v_addc_u32      v31, vcc, v20, v23, vcc
        v_or_b32        v24, v24, v25
        v_xor_b32       v34, v34, v12
        v_xor_b32       v35, v19, v23
        v_xor_b32       v36, v36, v6
        v_xor_b32       v37, v18, v10
        v_add_i32       v2, vcc, v2, v24
        v_addc_u32      v1, vcc, v1, v26, vcc
        v_xor_b32       v22, v22, v29
        v_xor_b32       v23, v40, v31
        v_lshrrev_b32   v32, 31, v35
        v_lshl_b64      v[34:35], v[34:35], 1
        v_lshrrev_b32   v12, 31, v37
        v_lshl_b64      v[18:19], v[36:37], 1
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[36:37], v[22:23], 24
        v_lshlrev_b32   v22, 8, v22
        v_or_b32        v23, v32, v34
        v_or_b32        v12, v12, v18
        v_xor_b32       v18, v2, v33
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v18, v10, vcc
        v_or_b32        v22, v37, v22
        v_add_i32       v14, vcc, v14, v36
        v_addc_u32      v16, vcc, v16, v22, vcc
        v_add_i32       v13, vcc, v23, v13
        v_addc_u32      v17, vcc, v35, v17, vcc
        v_add_i32       v7, vcc, v12, v7
        v_addc_u32      v15, vcc, v19, v15, vcc
        v_xor_b32       v24, v24, v6
        v_xor_b32       v25, v26, v10
        v_xor_b32       v39, v8, v14
        v_xor_b32       v40, v20, v16
        v_xor_b32       v4, v4, v17
        v_xor_b32       v3, v3, v15
        v_xor_b32       v26, v28, v13
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v26, v11, vcc
        v_xor_b32       v28, v30, v7
        v_add_i32       v21, vcc, v3, v21
        v_addc_u32      v27, vcc, v28, v27, vcc
        v_lshr_b64      v[32:33], v[24:25], 24
        v_lshlrev_b32   v24, 8, v24
        v_lshr_b64      v[37:38], v[39:40], 16
        v_lshlrev_b32   v8, 16, v39
        v_or_b32        v20, v33, v24
        v_add_i32       v2, vcc, v2, v32
        v_addc_u32      v1, vcc, v1, v20, vcc
        v_or_b32        v8, v38, v8
        v_add_i32       v24, vcc, v37, v29
        v_addc_u32      v25, vcc, v8, v31, vcc
        v_xor_b32       v38, v23, v9
        v_xor_b32       v39, v35, v11
        v_xor_b32       v40, v12, v21
        v_xor_b32       v41, v19, v27
        v_xor_b32       v42, v5, v2
        v_xor_b32       v43, v18, v1
        v_xor_b32       v29, v36, v24
        v_xor_b32       v30, v22, v25
        v_lshr_b64      v[33:34], v[38:39], 24
        v_lshlrev_b32   v23, 8, v38
        v_lshr_b64      v[35:36], v[40:41], 24
        v_lshlrev_b32   v12, 8, v40
        v_or_b32        v19, v34, v23
        v_add_i32       v13, vcc, v33, v13
        v_addc_u32      v17, vcc, v19, v17, vcc
        v_or_b32        v12, v36, v12
        v_add_i32       v7, vcc, v35, v7
        v_addc_u32      v15, vcc, v12, v15, vcc
        v_lshr_b64      v[38:39], v[42:43], 16
        v_lshlrev_b32   v5, 16, v42
        v_lshrrev_b32   v18, 31, v30
        v_lshl_b64      v[22:23], v[29:30], 1
        v_or_b32        v5, v39, v5
        v_add_i32       v6, vcc, v38, v6
        v_addc_u32      v10, vcc, v5, v10, vcc
        v_or_b32        v18, v18, v22
        v_xor_b32       v39, v4, v13
        v_xor_b32       v40, v26, v17
        v_xor_b32       v41, v3, v7
        v_xor_b32       v42, v28, v15
        v_add_i32       v13, vcc, v13, v18
        v_addc_u32      v17, vcc, v17, v23, vcc
        v_xor_b32       v43, v32, v6
        v_xor_b32       v44, v20, v10
        v_lshr_b64      v[29:30], v[39:40], 16
        v_lshlrev_b32   v4, 16, v39
        v_lshr_b64      v[31:32], v[41:42], 16
        v_lshlrev_b32   v3, 16, v41
        v_or_b32        v4, v30, v4
        v_add_i32       v9, vcc, v29, v9
        v_addc_u32      v11, vcc, v4, v11, vcc
        v_or_b32        v3, v32, v3
        v_add_i32       v21, vcc, v31, v21
        v_addc_u32      v22, vcc, v3, v27, vcc
        v_xor_b32       v5, v5, v17
        v_lshrrev_b32   v26, 31, v44
        v_lshl_b64      v[27:28], v[43:44], 1
        v_xor_b32       v20, v38, v13
        v_add_i32       v30, vcc, v5, v21
        v_addc_u32      v32, vcc, v20, v22, vcc
        v_or_b32        v26, v26, v27
        v_xor_b32       v38, v33, v9
        v_xor_b32       v39, v19, v11
        v_add_i32       v7, vcc, v7, v26
        v_addc_u32      v15, vcc, v15, v28, vcc
        v_xor_b32       v40, v18, v30
        v_xor_b32       v41, v23, v32
        v_lshrrev_b32   v33, 31, v39
        v_lshl_b64      v[38:39], v[38:39], 1
        v_xor_b32       v34, v35, v21
        v_xor_b32       v35, v12, v22
        v_or_b32        v21, v33, v38
        v_xor_b32       v8, v8, v15
        v_lshr_b64      v[22:23], v[40:41], 24
        v_lshlrev_b32   v18, 8, v40
        v_lshrrev_b32   v27, 31, v35
        v_lshl_b64      v[33:34], v[34:35], 1
        v_xor_b32       v12, v37, v7
        v_add_i32       v9, vcc, v8, v9
        v_addc_u32      v11, vcc, v12, v11, vcc
        v_add_i32       v2, vcc, v21, v2
        v_addc_u32      v1, vcc, v39, v1, vcc
        v_or_b32        v18, v23, v18
        v_add_i32       v13, vcc, v22, v13
        v_addc_u32      v17, vcc, v18, v17, vcc
        v_or_b32        v19, v27, v33
        v_xor_b32       v37, v26, v9
        v_xor_b32       v38, v28, v11
        v_xor_b32       v3, v3, v1
        v_xor_b32       v40, v5, v13
        v_xor_b32       v41, v20, v17
        v_add_i32       v14, vcc, v14, v19
        v_addc_u32      v16, vcc, v16, v34, vcc
        v_xor_b32       v27, v31, v2
        v_add_i32       v24, vcc, v3, v24
        v_addc_u32      v25, vcc, v27, v25, vcc
        v_lshr_b64      v[35:36], v[37:38], 24
        v_lshlrev_b32   v23, 8, v37
        v_lshr_b64      v[37:38], v[40:41], 16
        v_lshlrev_b32   v5, 16, v40
        v_xor_b32       v4, v4, v16
        v_or_b32        v20, v36, v23
        v_add_i32       v7, vcc, v7, v35
        v_addc_u32      v15, vcc, v15, v20, vcc
        v_xor_b32       v40, v21, v24
        v_xor_b32       v41, v39, v25
        v_or_b32        v5, v38, v5
        v_xor_b32       v26, v29, v14
        v_add_i32       v6, vcc, v4, v6
        v_addc_u32      v10, vcc, v26, v10, vcc
        v_add_i32       v28, vcc, v37, v30
        v_addc_u32      v29, vcc, v5, v32, vcc
        v_xor_b32       v38, v8, v7
        v_xor_b32       v39, v12, v15
        v_lshr_b64      v[30:31], v[40:41], 24
        v_lshlrev_b32   v21, 8, v40
        v_xor_b32       v40, v19, v6
        v_xor_b32       v41, v34, v10
        v_xor_b32       v22, v22, v28
        v_xor_b32       v23, v18, v29
        v_or_b32        v21, v31, v21
        v_add_i32       v2, vcc, v2, v30
        v_addc_u32      v1, vcc, v1, v21, vcc
        v_lshr_b64      v[31:32], v[38:39], 16
        v_lshlrev_b32   v8, 16, v38
        v_lshr_b64      v[33:34], v[40:41], 24
        v_lshlrev_b32   v12, 8, v40
        v_lshrrev_b32   v19, 31, v23
        v_lshl_b64      v[22:23], v[22:23], 1
        v_or_b32        v8, v32, v8
        v_add_i32       v9, vcc, v31, v9
        v_addc_u32      v11, vcc, v8, v11, vcc
        v_or_b32        v12, v34, v12
        v_add_i32       v14, vcc, v14, v33
        v_addc_u32      v16, vcc, v16, v12, vcc
        v_or_b32        v18, v19, v22
        v_xor_b32       v38, v3, v2
        v_xor_b32       v39, v27, v1
        v_add_i32       v22, vcc, v14, v18
        v_addc_u32      v27, vcc, v16, v23, vcc
        v_xor_b32       v40, v35, v9
        v_xor_b32       v41, v20, v11
        v_xor_b32       v42, v4, v14
        v_xor_b32       v43, v26, v16
        v_lshr_b64      v[34:35], v[38:39], 16
        v_lshlrev_b32   v3, 16, v38
        v_xor_b32       v8, v8, v27
        v_or_b32        v3, v35, v3
        v_add_i32       v16, vcc, v34, v24
        v_addc_u32      v19, vcc, v3, v25, vcc
        v_lshrrev_b32   v24, 31, v41
        v_lshl_b64      v[25:26], v[40:41], 1
        v_lshr_b64      v[35:36], v[42:43], 16
        v_lshlrev_b32   v4, 16, v42
        v_xor_b32       v14, v31, v22
        v_add_i32       v20, vcc, v8, v16
        v_addc_u32      v31, vcc, v14, v19, vcc
        v_or_b32        v24, v24, v25
        s_mov_b64       s[0:1], 0
        v_or_b32        v4, v36, v4
        v_add_i32       v6, vcc, v35, v6
        v_addc_u32      v10, vcc, v4, v10, vcc
        v_addc_u32      v1, vcc, v1, v0, s[0:1]
        v_add_i32       v2, vcc, v2, v24
        v_addc_u32      v1, vcc, v1, v26, vcc
        v_xor_b32       v38, v18, v20
        v_xor_b32       v39, v23, v31
        v_xor_b32       v40, v30, v16
        v_xor_b32       v41, v21, v19
        v_xor_b32       v42, v33, v6
        v_xor_b32       v43, v12, v10
        v_xor_b32       v5, v1, v5
        v_lshr_b64      v[32:33], v[38:39], 24
        v_lshlrev_b32   v18, 8, v38
        v_xor_b32       v23, v2, v37
        v_add_i32       v6, vcc, v5, v6
        v_addc_u32      v10, vcc, v23, v10, vcc
        v_or_b32        v18, v33, v18
        v_add_i32       v22, vcc, v22, v32
        v_addc_u32      v18, vcc, v27, v18, vcc
        v_lshrrev_b32   v25, 31, v41
        v_lshl_b64      v[32:33], v[40:41], 1
        v_lshrrev_b32   v16, 31, v43
        v_lshl_b64      v[36:37], v[42:43], 1
        v_or_b32        v12, v25, v32
        v_or_b32        v16, v16, v36
        v_xor_b32       v38, v24, v6
        v_xor_b32       v39, v26, v10
        v_xor_b32       v41, v8, v22
        v_xor_b32       v42, v14, v18
        v_add_i32       v13, vcc, v12, v13
        v_addc_u32      v17, vcc, v33, v17, vcc
        v_add_i32       v7, vcc, v16, v7
        v_addc_u32      v15, vcc, v37, v15, vcc
        v_lshr_b64      v[24:25], v[38:39], 24
        v_lshr_b64      v[26:27], v[41:42], 16
        v_xor_b32       v4, v4, v17
        v_xor_b32       v3, v3, v15
        v_add_i32       v2, s[0:1], v2, v24
        v_add_i32       v14, s[4:5], v26, v20
        v_xor_b32       v20, v35, v13
        v_add_i32       v9, vcc, v4, v9
        v_addc_u32      v11, vcc, v20, v11, vcc
        v_xor_b32       v21, v34, v7
        v_add_i32       v28, vcc, v3, v28
        v_addc_u32      v29, vcc, v21, v29, vcc
        v_xor_b32       v14, v14, v2
        v_xor_b32       v39, v12, v9
        v_xor_b32       v40, v33, v11
        v_xor_b32       v42, v16, v28
        v_xor_b32       v43, v37, v29
        v_xor_b32       v44, s20, v14
        v_and_b32       v33, 0xfff, v44
        s_mov_b32       s6, 0x55555555
        s_buffer_load_dword s7, s[8:11], 0x0
        v_lshlrev_b32   v19, 8, v38
        v_lshr_b64      v[34:35], v[39:40], 24
        v_lshlrev_b32   v12, 8, v39
        v_lshr_b64      v[36:37], v[42:43], 24
        v_lshlrev_b32   v16, 8, v42
        v_lshrrev_b32   v30, 1, v33
        v_mul_lo_i32    v32, v33, s6
        v_or_b32        v19, v25, v19
        v_or_b32        v12, v35, v12
        v_add_i32       v13, vcc, v34, v13
        v_addc_u32      v17, vcc, v12, v17, vcc
        v_or_b32        v16, v37, v16
        v_add_i32       v7, vcc, v36, v7
        v_addc_u32      v15, vcc, v16, v15, vcc
        v_add_i32       v25, vcc, v30, v32
        v_lshrrev_b32   v30, 3, v33
        v_addc_u32      v1, vcc, v1, v19, s[0:1]
        v_sub_i32       v25, vcc, v25, v30
        v_xor_b32       v39, v5, v2
        v_xor_b32       v40, v23, v1
        v_xor_b32       v4, v4, v13
        v_xor_b32       v5, v20, v17
        v_xor_b32       v42, v3, v7
        v_xor_b32       v43, v21, v15
        v_lshrrev_b32   v23, 30, v25
        v_sub_i32       v25, vcc, v33, v23
        s_mov_b32       s0, 0xaaaaaaab
        v_lshr_b64      v[37:38], v[39:40], 16
        v_lshlrev_b32   v2, 16, v39
        v_lshr_b64      v[39:40], v[4:5], 16
        v_lshlrev_b32   v4, 16, v4
        v_lshr_b64      v[20:21], v[42:43], 16
        v_lshlrev_b32   v3, 16, v42
        v_mul_lo_i32    v5, v23, 10
        v_mul_lo_i32    v23, v25, s0
        s_waitcnt       lgkmcnt(0)
        s_mulk_i32      s7, 0xaac
        v_or_b32        v2, v38, v2
        v_add_i32       v6, vcc, v37, v6
        v_addc_u32      v2, vcc, v2, v10, vcc
        v_or_b32        v4, v40, v4
        v_add_i32       v9, vcc, v39, v9
        v_addc_u32      v10, vcc, v4, v11, vcc
        v_or_b32        v3, v21, v3
        v_add_i32       v11, vcc, v20, v28
        v_addc_u32      v21, vcc, v3, v29, vcc
        v_and_b32       v5, 30, v5
        v_add_i32       v23, vcc, s7, v23
        v_lshlrev_b32   v8, 16, v41
        v_lshl_b32      v25, 1, v5
        v_lshlrev_b32   v23, 2, v23
        v_xor_b32       v29, v24, v6
        v_xor_b32       v30, v19, v2
        v_or_b32        v8, v27, v8
        v_xor_b32       v34, v34, v9
        v_xor_b32       v35, v12, v10
        v_xor_b32       v27, v36, v11
        v_xor_b32       v28, v16, v21
        ds_add_rtn_u32  v23, v23, v25 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_xor_b32       v11, v11, v13
        v_xor_b32       v13, v21, v17
        v_addc_u32      v17, vcc, v8, v31, s[4:5]
        v_lshr_b32      v5, v23, v5
        v_xor_b32       v31, s26, v11
        v_xor_b32       v32, s27, v13
        v_lshrrev_b32   v21, 31, v30
        v_lshl_b64      v[23:24], v[29:30], 1
        v_lshrrev_b32   v19, 31, v35
        v_lshl_b64      v[29:30], v[34:35], 1
        v_lshrrev_b32   v12, 31, v28
        v_lshl_b64      v[27:28], v[27:28], 1
        v_xor_b32       v1, v17, v1
        v_and_b32       v5, 0x3ff, v5
        s_movk_i32      s0, 0x2ab
        s_buffer_load_dword s1, s[8:11], 0x8
        v_or_b32        v16, v21, v23
        v_or_b32        v17, v19, v29
        v_or_b32        v12, v12, v27
        v_xor_b32       v45, s21, v1
        v_cmp_ge_u32    vcc, s0, v5
        v_lshr_b64      v[34:35], v[31:32], 8
        v_lshlrev_b32   v48, 1, v0
        s_and_saveexec_b64 s[4:5], vcc
        s_cbranch_execz .L11440_1
        s_movk_i32      s0, 0x2ac
        v_mul_lo_i32    v19, v33, s0
        v_xor_b32       v6, v6, v22
        v_xor_b32       v2, v2, v18
        v_add_i32       v5, vcc, v5, v19
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_xor_b32       v7, v9, v7
        v_xor_b32       v9, v10, v15
        v_xor_b32       v21, s24, v6
        v_xor_b32       v22, s25, v2
        v_lshlrev_b32   v5, 5, v5
        v_xor_b32       v36, s22, v7
        v_xor_b32       v37, s23, v9
        s_waitcnt       lgkmcnt(0)
        v_add_i32       v5, vcc, s1, v5
        v_lshrrev_b32   v10, 8, v22
        v_lshlrev_b32   v11, 24, v31
        v_lshrrev_b32   v15, 8, v21
        v_lshr_b64      v[18:19], v[21:22], 8
        s_mov_b32       s0, 0xff000000
        v_or_b32        v47, v10, v11
        v_bfi_b32       v46, s0, v18, v15
        v_lshlrev_b32   v6, 24, v21
        v_lshrrev_b32   v11, 8, v37
        v_lshrrev_b32   v15, 8, v44
        v_lshr_b64      v[18:19], v[44:45], 8
        v_lshrrev_b32   v14, 8, v36
        v_lshr_b64      v[21:22], v[36:37], 8
        v_lshlrev_b32   v7, 24, v36
        v_lshrrev_b32   v1, 8, v45
        v_or_b32        v43, v6, v11
        v_bfi_b32       v40, s0, v18, v15
        v_bfi_b32       v42, s0, v21, v14
        v_or_b32        v41, v7, v1
        v_mov_b32       v49, v46
        tbuffer_store_format_xyzw v[46:49], v5, s[8:11], 0 offen offset:16 format:[32_32_32_32,float]
        tbuffer_store_format_xyzw v[40:43], v5, s[8:11], 0 offen format:[32_32_32_32,float]
.L11440_1:
        s_mov_b64       exec, s[4:5]
        v_and_b32       v1, 0xfff, v34
        v_lshrrev_b32   v2, 1, v1
        s_mov_b32       s0, 0x55555555
        v_mul_lo_i32    v5, v1, s0
        v_add_i32       v2, vcc, v2, v5
        v_lshrrev_b32   v5, 3, v1
        v_sub_i32       v2, vcc, v2, v5
        v_lshrrev_b32   v2, 30, v2
        v_mul_lo_i32    v5, v2, 10
        v_and_b32       v5, 30, v5
        v_lshl_b32      v6, 1, v5
        v_sub_i32       v2, vcc, v1, v2
        s_mov_b32       s0, 0xaaaaaaab
        v_mul_lo_i32    v2, v2, s0
        v_add_i32       v2, vcc, s7, v2
        v_lshlrev_b32   v2, 2, v2
        ds_add_rtn_u32  v2, v2, v6 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v2, v2, v5
        v_and_b32       v2, 0x3ff, v2
        s_movk_i32      s0, 0x2ab
        v_cmp_ge_u32    vcc, s0, v2
        s_and_saveexec_b64 s[4:5], vcc
        v_xor_b32       v5, v26, v16
        s_cbranch_execz .L11844_1
        v_xor_b32       v6, v8, v24
        s_movk_i32      s0, 0x2ac
        v_xor_b32       v7, v20, v17
        v_xor_b32       v3, v3, v30
        v_xor_b32       v8, v39, v12
        v_xor_b32       v4, v4, v28
        v_xor_b32       v9, s30, v5
        v_xor_b32       v10, s31, v6
        v_mul_lo_i32    v1, v1, s0
        v_xor_b32       v15, s28, v7
        v_xor_b32       v16, s29, v3
        v_xor_b32       v7, s32, v8
        v_xor_b32       v8, s33, v4
        v_add_i32       v1, vcc, v2, v1
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_lshlrev_b32   v2, 24, v7
        v_lshr_b64      v[11:12], v[9:10], 8
        v_lshlrev_b32   v1, 5, v1
        v_lshlrev_b32   v14, 24, v15
        v_lshr_b64      v[17:18], v[15:16], 8
        v_lshlrev_b32   v5, 24, v9
        v_or_b32        v2, v2, v12
        v_lshr_b64      v[7:8], v[7:8], 8
        v_lshrrev_b32   v4, 8, v10
        v_lshr_b64      v[8:9], v[9:10], 16
        v_add_i32       v1, vcc, s1, v1
        v_or_b32        v6, v35, v14
        v_or_b32        v5, v18, v5
        v_lshrrev_b32   v9, 8, v32
        v_lshrrev_b32   v3, 8, v16
        v_lshrrev_b32   v2, 8, v2
        v_lshlrev_b32   v7, 24, v7
        v_lshlrev_b32   v4, 24, v4
        v_and_b32       v8, 0xffffff, v8
        v_lshr_b64      v[12:13], v[31:32], 16
        v_lshr_b64      v[13:14], v[15:16], 16
        v_or_b32        v15, v2, v7
        v_or_b32        v14, v4, v8
        v_add_i32       v16, vcc, 1, v48
        v_lshrrev_b32   v5, 8, v5
        v_lshlrev_b32   v7, 24, v11
        v_lshlrev_b32   v8, 24, v9
        v_and_b32       v9, 0xffffff, v12
        v_lshlrev_b32   v3, 24, v3
        v_and_b32       v10, 0xffffff, v13
        v_lshlrev_b32   v11, 24, v17
        v_lshrrev_b32   v6, 8, v6
        v_or_b32        v5, v5, v7
        v_or_b32        v2, v8, v9
        v_or_b32        v4, v3, v10
        v_or_b32        v3, v11, v6
        v_mov_b32       v17, v14
        s_waitcnt       lgkmcnt(0)
        tbuffer_store_format_xyzw v[14:17], v1, s[8:11], 0 offen offset:16 format:[32_32_32_32,float]
        tbuffer_store_format_xyzw v[2:5], v1, s[8:11], 0 offen format:[32_32_32_32,float]
.L11844_1:
        s_endpgm
.kernel kernel_round1
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 38
        .vgprsnum 45
        .hwlocal 22304
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x002b8098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        v_mov_b32       v1, 0
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        v_mov_b32       v29, 0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L2096_2
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L160_2
        v_add_i32       v1, vcc, 0x4cc0, v1
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L96_2:
        v_mov_b32       v3, 0x2ac
        ds_write_b32    v1, v3
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x100
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L160_2
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_2
.L160_2:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L428_2
        s_mul_i32       s10, s1, 0xaac
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x50c0, v1
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L224_2:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s11, 0x2ac
        v_cmp_gt_u32    vcc, s11, v2
        s_mov_b64       s[22:23], exec
        s_andn2_b64     exec, s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L288_2
        s_and_b64       exec, s[22:23], s[20:21]
        s_branch        .L224_2
.L288_2:
        s_mov_b64       exec, s[14:15]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L412_2
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s12, s0, 0x55555555
        s_add_u32       s11, s11, s12
        s_lshr_b32      s12, s0, 3
        s_sub_u32       s11, s11, s12
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s12, s0, s11
        s_mul_i32       s12, s12, 0xaaaaaaab
        s_add_u32       s10, s10, s12
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v1, s10
        ds_read_b32     v1, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v1, s10, v1
        v_and_b32       v1, 0x3ff, v1
        v_min_u32       v4, 0x2ac, v1
        v_mov_b32       v2, 0
        ds_write_b32    v2, v4 offset:19632
        v_mov_b32       v1, 1
.L412_2:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[14:15]
.L428_2:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v3, 0
        ds_read_b32     v3, v3 offset:19632
        v_bfe_i32       v1, v1, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v3, v4, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L512_2
        ds_write_b32    v1, v1 offset:19632
.L512_2:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L872_2
        v_add_i32       v1, vcc, 0x50c0, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v4, vcc, s10, v0
        v_lshlrev_b32   v4, 5, v4
        v_add_i32       v4, vcc, s4, v4
        v_lshlrev_b32   v5, 2, v0
        v_add_i32       v5, vcc, 0x3580, v5
        s_load_dwordx4  s[20:23], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v25, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L608_2:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[7:10], v4, s[20:23], 0 offen format:[32_32_32_32,float]
        tbuffer_load_format_xy v[11:12], v4, s[20:23], 0 offen offset:16 format:[32_32,float]
        v_add_i32       v13, vcc, 0xffffca90, v5
        s_waitcnt       vmcnt(1)
        ds_write_b32    v13, v7
        v_add_i32       v13, vcc, 0xffffd540, v5
        ds_write_b32    v13, v8
        v_add_i32       v8, vcc, 0xffffdff0, v5
        ds_write_b32    v8, v9
        v_add_i32       v8, vcc, 0xffffeaa0, v5
        v_and_b32       v9, 0xf0, v7
        v_bfe_u32       v7, v7, 12, 4
        ds_write_b32    v8, v10
        v_add_i32       v8, vcc, 0xfffff550, v5
        v_or_b32        v7, v9, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v8, v11
        v_lshlrev_b32   v7, 2, v7
        ds_write_b32    v5, v12
        v_add_i32       v7, vcc, 0x4cc0, v7
        ds_wrxchg_rtn_b32 v7, v7, v25
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v7, v7, 0, 16
        v_add_i32       v25, vcc, 0x100, v25
        ds_write_b16    v1, v7
        v_add_i32       v4, vcc, 0x2000, v4
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    s[24:25], v2, v25
        s_mov_b64       s[26:27], exec
        s_andn2_b64     exec, s[26:27], s[24:25]
        v_cndmask_b32   v26, 0, -1, s[24:25]
        s_cbranch_execz .L852_2
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L860_2
.L852_2:
        s_and_b64       exec, s[26:27], s[14:15]
        s_branch        .L608_2
.L860_2:
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v27, 0x100
.L872_2:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v27, v3
        v_mov_b32       v25, v3
        v_mov_b32       v26, v3
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1152_2
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v5, v0
.L920_2:
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v5
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L960_2:
        v_lshlrev_b32   v6, 1, v2
        v_add_i32       v6, vcc, 0x50c0, v6
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v6, v6
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v6, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1108_2
        s_and_b64       exec, s[22:23], s[20:21]
        v_mov_b32       v6, 0
        v_mov_b32       v8, -1
        ds_inc_rtn_u32  v6, v6, v8 offset:19632
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_lt_u32    vcc, s4, v6
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1108_2
        s_and_b64       exec, s[22:23], s[20:21]
        v_lshlrev_b32   v6, 1, v6
        v_add_i32       v8, vcc, 0x4030, v6
        v_bfe_u32       v9, v5, 0, 16
        ds_write_b16    v8, v9
        v_add_i32       v6, vcc, 0x4670, v6
        ds_write_b16    v6, v2
        s_branch        .L960_2
.L1108_2:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v5, vcc, 0x100, v5
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v5
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1152_2
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L920_2
.L1152_2:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v5, 0
        ds_read_b32     v5, v5 offset:19632
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v5, 0x31a, v5
        v_mov_b32       v6, 0
        v_cmp_lg_i32    vcc, v5, v6
        s_cbranch_vccz  .L2096_2
        s_lshl_b32      s1, s1, 1
        v_and_b32       v6, 1, v0
        v_lshlrev_b32   v7, 4, v6
        v_or_b32        v8, 32, v7
        v_lshrrev_b32   v9, 1, v0
        v_and_b32       v0, -2, v0
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0x556
        v_not_b32       v10, v9
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v5
        v_mov_b32       v4, v3
.L1248_2:
        v_cmp_gt_u32    vcc, s2, v9
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v10
        s_cbranch_execz .L1336_2
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x4670, v1
        v_add_i32       v1, vcc, 0x4030, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v27, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v27
        v_lshlrev_b32   v5, 2, v1
        v_add_i32       v25, vcc, 16, v3
        v_add_i32       v26, vcc, 16, v5
.L1336_2:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        v_cmp_eq_i32    vcc, 0, v6
        s_and_b64       exec, s[6:7], vcc
        s_waitcnt       expcnt(0)
        v_mov_b32       v11, 0x2ac
        s_cbranch_execz .L1384_2
        ds_write_b16    v0, v11 offset:22048
.L1384_2:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v4, vcc, 0xab0, v26
        s_cbranch_execz .L1908_2
        s_nop           0x0
        v_add_i32       v11, vcc, 0xab0, v25
        v_add_i32       v12, vcc, 0x1560, v25
        v_add_i32       v13, vcc, 0x1560, v26
        ds_read_b32     v14, v26
        ds_read_b32     v15, v25
        ds_read_b32     v4, v4
        ds_read_b32     v11, v11
        v_add_i32       v16, vcc, 0x2010, v25
        v_add_i32       v17, vcc, 0x2010, v26
        ds_read_b32     v12, v12
        ds_read_b32     v13, v13
        v_add_i32       v18, vcc, 0x2ac0, v25
        v_add_i32       v19, vcc, 0x2ac0, v26
        ds_read_b32     v16, v16
        ds_read_b32     v17, v17
        v_add_i32       v20, vcc, 0x3570, v25
        v_add_i32       v21, vcc, 0x3570, v26
        ds_read_b32     v18, v18
        ds_read_b32     v19, v19
        ds_read_b32     v20, v20
        ds_read_b32     v21, v21
        s_waitcnt       lgkmcnt(0)
        v_xor_b32       v22, v14, v15
        v_xor_b32       v23, v4, v11
        v_alignbit_b32  v24, v23, v22, 8
        v_xor_b32       v12, v12, v13
        v_alignbit_b32  v13, v12, v23, 8
        v_xor_b32       v16, v16, v17
        v_alignbit_b32  v12, v16, v12, 8
        v_xor_b32       v17, v18, v19
        v_alignbit_b32  v16, v17, v16, 8
        v_xor_b32       v18, v20, v21
        v_lshlrev_b32   v19, 10, v27
        v_cmp_eq_i32    s[14:15], v14, v15
        v_cmp_eq_i32    vcc, v4, v11
        v_mov_b32       v37, v24
        v_alignbit_b32  v4, v18, v17, 8
        v_and_b32       v11, 0xffc00, v19
        v_mov_b32       v38, v13
        v_lshrrev_b32   v13, 8, v18
        v_or_b32        v11, s0, v11
        v_and_b32       v5, 0x3ff, v1
        v_mov_b32       v39, v12
        v_or_b32        v5, v11, v5
        v_mov_b32       v40, v16
        s_and_b64       vcc, s[14:15], vcc
        v_mov_b32       v41, v4
        v_lshrrev_b32   v4, 24, v22
        v_cndmask_b32   v11, 0, -1, vcc
        v_mov_b32       v42, v13
        v_lshrrev_b32   v12, 8, v22
        v_and_b32       v4, 0xf0, v4
        s_movk_i32      s3, 0xf0f
        v_or_b32        v11, v6, v11
        v_mov_b32       v43, v5
        v_bfi_b32       v4, s3, v12, v4
        v_bfe_i32       v5, v11, 0, 1
        v_cmp_eq_u32    vcc, 0, v5
        s_and_saveexec_b64 s[14:15], vcc
        v_lshrrev_b32   v5, 1, v4
        s_cbranch_execz .L1908_2
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v11, v4, s3
        v_add_i32       v5, vcc, v5, v11
        v_lshrrev_b32   v11, 3, v4
        v_sub_i32       v5, vcc, v5, v11
        v_lshrrev_b32   v5, 30, v5
        v_mul_lo_i32    v11, v5, 10
        v_and_b32       v11, 30, v11
        v_lshl_b32      v12, 1, v11
        v_sub_i32       v5, vcc, v4, v5
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v5, v5, s3
        v_add_i32       v5, vcc, s1, v5
        v_lshlrev_b32   v5, 2, v5
        v_add_i32       v5, vcc, 0x1558, v5
        ds_add_rtn_u32  v5, v5, v12 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v5, v5, v11
        v_and_b32       v5, 0x3ff, v5
        ds_write_b16    v0, v5 offset:22048
.L1908_2:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        ds_read_u16     v5, v0 offset:22048
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v5, 0xffff, v5
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v5
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L2064_2
        v_lshrrev_b32   v28, 2, v8
        s_cbranch_execz .L2028_2
        s_mov_b32       s29, m0
        s_mov_b64       s[30:31], exec
.L1972_2:
        v_readfirstlane_b32 s28, v28
        s_mov_b32       m0, s28
        s_mov_b64       s[32:33], exec
        v_cmpx_eq_i32   s[34:35], s28, v28
        s_andn2_b64     s[32:33], s[32:33], s[34:35]
        v_movrels_b32   v11, v29
        v_movrels_b32   v12, v30
        v_movrels_b32   v13, v31
        v_movrels_b32   v14, v32
        s_mov_b64       exec, s[32:33]
        s_cbranch_execnz .L1972_2
        s_mov_b64       exec, s[30:31]
        s_mov_b32       m0, s29
.L2028_2:
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v15, v4, s3
        v_add_i32       v5, vcc, v5, v15
        v_lshlrev_b32   v5, 5, v5
        v_add_i32       v5, vcc, s5, v5
        v_add_i32       v5, vcc, v7, v5
        tbuffer_store_format_xyzw v[11:14], v5, s[8:11], 0 offen format:[32_32_32_32,float]
.L2064_2:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x80
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L2096_2
        s_mov_b32       s2, s4
        s_branch        .L1248_2
.L2096_2:
        s_endpgm
.kernel kernel_round2
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 38
        .vgprsnum 42
        .hwlocal 22304
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x002b8098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        v_mov_b32       v1, 0
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        v_mov_b32       v26, 0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L2028_3
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L160_3
        v_add_i32       v1, vcc, 0x4cc0, v1
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L96_3:
        v_mov_b32       v3, 0x2ac
        ds_write_b32    v1, v3
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x100
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L160_3
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_3
.L160_3:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L436_3
        s_lshl_b32      s10, s1, 1
        s_mulk_i32      s10, 0x556
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x50c0, v1
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L224_3:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s11, 0x2ac
        v_cmp_gt_u32    vcc, s11, v2
        s_mov_b64       s[22:23], exec
        s_andn2_b64     exec, s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L288_3
        s_and_b64       exec, s[22:23], s[20:21]
        s_branch        .L224_3
.L288_3:
        s_mov_b64       exec, s[14:15]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L420_3
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s12, s0, 0x55555555
        s_add_u32       s11, s11, s12
        s_lshr_b32      s12, s0, 3
        s_sub_u32       s11, s11, s12
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s12, s0, s11
        s_mul_i32       s12, s12, 0xaaaaaaab
        s_add_u32       s10, s10, s12
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v1, s10
        v_add_i32       v1, vcc, 0x1558, v1
        ds_read_b32     v1, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v1, s10, v1
        v_and_b32       v1, 0x3ff, v1
        v_min_u32       v4, 0x2ac, v1
        v_mov_b32       v2, 0
        ds_write_b32    v2, v4 offset:19632
        v_mov_b32       v1, 1
.L420_3:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[14:15]
.L436_3:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v3, 0
        ds_read_b32     v3, v3 offset:19632
        v_bfe_i32       v1, v1, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v3, v4, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L520_3
        ds_write_b32    v1, v1 offset:19632
.L520_3:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L876_3
        v_add_i32       v1, vcc, 0x50c0, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v3, vcc, s10, v0
        v_lshlrev_b32   v3, 5, v3
        v_add_i32       v3, vcc, s4, v3
        v_lshlrev_b32   v4, 2, v0
        v_add_i32       v4, vcc, 0x3580, v4
        s_load_dwordx4  s[20:23], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v23, v0
        s_nop           0x0
.L608_3:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[14:17], v3, s[20:23], 0 offen format:[32_32_32_32,float]
        tbuffer_load_format_xy v[10:11], v3, s[20:23], 0 offen offset:16 format:[32_32,float]
        v_add_i32       v12, vcc, 0xffffca90, v4
        s_waitcnt       vmcnt(1)
        ds_write_b32    v12, v14
        v_add_i32       v12, vcc, 0xffffd540, v4
        ds_write_b32    v12, v15
        v_add_i32       v7, vcc, 0xffffdff0, v4
        v_lshrrev_b32   v12, 8, v14
        ds_write_b32    v7, v16
        v_add_i32       v7, vcc, 0xffffeaa0, v4
        v_bfe_u32       v6, v14, 16, 4
        v_and_b32       v12, 0xf0, v12
        ds_write_b32    v7, v17
        v_add_i32       v7, vcc, 0xfffff550, v4
        v_or_b32        v6, v6, v12
        s_waitcnt       vmcnt(0)
        ds_write_b32    v7, v10
        v_lshlrev_b32   v6, 2, v6
        ds_write_b32    v4, v11
        v_add_i32       v6, vcc, 0x4cc0, v6
        ds_wrxchg_rtn_b32 v6, v6, v23
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        v_add_i32       v23, vcc, 0x100, v23
        ds_write_b16    v1, v6
        v_add_i32       v3, vcc, 0x2000, v3
        v_add_i32       v4, vcc, 0x400, v4
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    s[24:25], v2, v23
        s_mov_b64       s[26:27], exec
        s_andn2_b64     exec, s[26:27], s[24:25]
        v_cndmask_b32   v3, 0, -1, s[24:25]
        s_cbranch_execz .L856_3
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L864_3
.L856_3:
        s_and_b64       exec, s[26:27], s[14:15]
        s_branch        .L608_3
.L864_3:
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v24, 0x100
.L876_3:
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L900_3
        v_mov_b32       v24, v1
        v_mov_b32       v23, v1
        v_mov_b32       v3, v1
        v_mov_b32       v16, v1
.L900_3:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1152_3
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v5, v0
.L932_3:
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v5
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L960_3:
        v_lshlrev_b32   v6, 1, v2
        v_add_i32       v6, vcc, 0x50c0, v6
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v6, v6
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v6, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1108_3
        s_and_b64       exec, s[22:23], s[20:21]
        v_mov_b32       v6, 0
        v_mov_b32       v8, -1
        ds_inc_rtn_u32  v6, v6, v8 offset:19632
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_lt_u32    vcc, s4, v6
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1108_3
        s_and_b64       exec, s[22:23], s[20:21]
        v_lshlrev_b32   v6, 1, v6
        v_add_i32       v8, vcc, 0x4030, v6
        v_bfe_u32       v9, v5, 0, 16
        ds_write_b16    v8, v9
        v_add_i32       v6, vcc, 0x4670, v6
        ds_write_b16    v6, v2
        s_branch        .L960_3
.L1108_3:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v5, vcc, 0x100, v5
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v5
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1152_3
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L932_3
.L1152_3:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v5, 0
        ds_read_b32     v5, v5 offset:19632
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v5, 0x31a, v5
        v_mov_b32       v6, 0
        v_cmp_lg_i32    vcc, v5, v6
        s_cbranch_vccz  .L2028_3
        v_and_b32       v6, 1, v0
        v_lshlrev_b32   v7, 4, v6
        v_or_b32        v8, 32, v7
        v_lshrrev_b32   v9, 1, v0
        v_and_b32       v0, -2, v0
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0xaac
        v_not_b32       v10, v9
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v5
        s_nop           0x0
        s_nop           0x0
.L1248_3:
        v_cmp_gt_u32    vcc, s2, v9
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v10
        s_cbranch_execz .L1336_3
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x4670, v1
        v_add_i32       v1, vcc, 0x4030, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v24, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v24
        v_lshlrev_b32   v5, 2, v1
        v_add_i32       v23, vcc, 16, v3
        v_add_i32       v3, vcc, 16, v5
.L1336_3:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        v_cmp_eq_i32    vcc, 0, v6
        s_and_b64       exec, s[6:7], vcc
        s_waitcnt       expcnt(0)
        v_mov_b32       v11, 0x2ac
        s_cbranch_execz .L1384_3
        ds_write_b16    v0, v11 offset:22048
.L1384_3:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v4, vcc, 0xab0, v3
        s_cbranch_execz .L1840_3
        s_nop           0x0
        v_add_i32       v11, vcc, 0xab0, v23
        v_add_i32       v12, vcc, 0x1560, v23
        v_add_i32       v13, vcc, 0x1560, v3
        ds_read_b32     v4, v4
        ds_read_b32     v11, v11
        ds_read_b32     v14, v23
        ds_read_b32     v15, v3
        v_add_i32       v16, vcc, 0x2010, v23
        v_add_i32       v17, vcc, 0x2010, v3
        ds_read_b32     v12, v12
        ds_read_b32     v13, v13
        v_add_i32       v18, vcc, 0x2ac0, v23
        v_add_i32       v19, vcc, 0x2ac0, v3
        ds_read_b32     v16, v16
        ds_read_b32     v17, v17
        v_add_i32       v20, vcc, 0x3570, v23
        v_add_i32       v21, vcc, 0x3570, v3
        ds_read_b32     v18, v18
        ds_read_b32     v19, v19
        ds_read_b32     v20, v20
        ds_read_b32     v21, v21
        s_waitcnt       lgkmcnt(0)
        v_xor_b32       v22, v4, v11
        v_xor_b32       v14, v14, v15
        v_xor_b32       v12, v12, v13
        v_alignbit_b32  v13, v22, v14, 24
        v_xor_b32       v14, v16, v17
        v_lshlrev_b32   v15, 10, v24
        v_cmp_eq_i32    s[14:15], v13, 0
        v_cmp_eq_i32    vcc, v4, v11
        v_xor_b32       v4, v18, v19
        v_and_b32       v11, 0xffc00, v15
        v_mov_b32       v34, v22
        v_xor_b32       v15, v20, v21
        v_or_b32        v11, s0, v11
        v_and_b32       v5, 0x3ff, v1
        v_mov_b32       v35, v12
        v_or_b32        v5, v11, v5
        v_mov_b32       v36, v14
        s_and_b64       vcc, s[14:15], vcc
        v_mov_b32       v37, v4
        v_cndmask_b32   v4, 0, -1, vcc
        v_mov_b32       v38, v15
        v_or_b32        v4, v6, v4
        v_mov_b32       v39, v5
        v_and_b32       v16, 0xfff, v13
        v_bfe_i32       v4, v4, 0, 1
        v_cmp_eq_u32    vcc, 0, v4
        s_and_saveexec_b64 s[14:15], vcc
        v_lshrrev_b32   v4, 1, v16
        s_cbranch_execz .L1840_3
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v11, v16, s3
        v_add_i32       v4, vcc, v4, v11
        v_lshrrev_b32   v11, 3, v16
        v_sub_i32       v4, vcc, v4, v11
        v_lshrrev_b32   v4, 30, v4
        v_mul_lo_i32    v11, v4, 10
        v_and_b32       v11, 30, v11
        v_lshl_b32      v12, 1, v11
        v_sub_i32       v4, vcc, v16, v4
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v4, v4, s3
        v_add_i32       v4, vcc, s1, v4
        v_lshlrev_b32   v4, 2, v4
        ds_add_rtn_u32  v4, v4, v12 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v4, v4, v11
        v_and_b32       v4, 0x3ff, v4
        ds_write_b16    v0, v4 offset:22048
.L1840_3:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        ds_read_u16     v5, v0 offset:22048
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v5, 0xffff, v5
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v5
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L1996_3
        v_lshrrev_b32   v25, 2, v8
        s_cbranch_execz .L1960_3
        s_mov_b32       s29, m0
        s_mov_b64       s[30:31], exec
.L1904_3:
        v_readfirstlane_b32 s28, v25
        s_mov_b32       m0, s28
        s_mov_b64       s[32:33], exec
        v_cmpx_eq_i32   s[34:35], s28, v25
        s_andn2_b64     s[32:33], s[32:33], s[34:35]
        v_movrels_b32   v11, v26
        v_movrels_b32   v12, v27
        v_movrels_b32   v13, v28
        v_movrels_b32   v14, v29
        s_mov_b64       exec, s[32:33]
        s_cbranch_execnz .L1904_3
        s_mov_b64       exec, s[30:31]
        s_mov_b32       m0, s29
.L1960_3:
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v15, v16, s3
        v_add_i32       v5, vcc, v5, v15
        v_lshlrev_b32   v5, 5, v5
        v_add_i32       v5, vcc, s5, v5
        v_add_i32       v5, vcc, v7, v5
        tbuffer_store_format_xyzw v[11:14], v5, s[8:11], 0 offen format:[32_32_32_32,float]
.L1996_3:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x80
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L2028_3
        s_mov_b32       s2, s4
        s_branch        .L1248_3
.L2028_3:
        s_endpgm
.kernel kernel_round3
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 38
        .vgprsnum 43
        .hwlocal 19568
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00268098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        v_mov_b32       v1, 0
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        v_mov_b32       v27, 0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L2016_4
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L160_4
        v_add_i32       v1, vcc, 0x4210, v1
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L96_4:
        v_mov_b32       v3, 0x2ac
        ds_write_b32    v1, v3
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x100
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L160_4
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_4
.L160_4:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L428_4
        s_mul_i32       s10, s1, 0xaac
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x4610, v1
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L224_4:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s11, 0x2ac
        v_cmp_gt_u32    vcc, s11, v2
        s_mov_b64       s[22:23], exec
        s_andn2_b64     exec, s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L288_4
        s_and_b64       exec, s[22:23], s[20:21]
        s_branch        .L224_4
.L288_4:
        s_mov_b64       exec, s[14:15]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L412_4
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s12, s0, 0x55555555
        s_add_u32       s11, s11, s12
        s_lshr_b32      s12, s0, 3
        s_sub_u32       s11, s11, s12
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s12, s0, s11
        s_mul_i32       s12, s12, 0xaaaaaaab
        s_add_u32       s10, s10, s12
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v1, s10
        ds_read_b32     v1, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v1, s10, v1
        v_and_b32       v1, 0x3ff, v1
        v_min_u32       v4, 0x2ac, v1
        v_mov_b32       v2, 0
        ds_write_b32    v2, v4 offset:16896
        v_mov_b32       v1, 1
.L412_4:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[14:15]
.L428_4:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v3, 0
        ds_read_b32     v3, v3 offset:16896
        v_bfe_i32       v1, v1, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v3, v4, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L512_4
        ds_write_b32    v1, v1 offset:16896
.L512_4:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L856_4
        v_add_i32       v1, vcc, 0x4610, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v4, vcc, s10, v0
        v_lshlrev_b32   v4, 5, v4
        v_add_i32       v4, vcc, s4, v4
        v_lshlrev_b32   v5, 2, v0
        v_add_i32       v5, vcc, 0x2ad0, v5
        s_load_dwordx4  s[20:23], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v23, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L608_4:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[7:10], v4, s[20:23], 0 offen format:[32_32_32_32,float]
        tbuffer_load_format_x v11, v4, s[20:23], 0 offen offset:16 format:[32,float]
        v_add_i32       v12, vcc, 0xffffd540, v5
        s_waitcnt       vmcnt(1)
        ds_write_b32    v12, v7
        v_add_i32       v12, vcc, 0xffffdff0, v5
        ds_write_b32    v12, v8
        v_add_i32       v8, vcc, 0xffffeaa0, v5
        v_and_b32       v12, 0xf0, v7
        v_bfe_u32       v7, v7, 12, 4
        ds_write_b32    v8, v9
        v_add_i32       v8, vcc, 0xfffff550, v5
        v_or_b32        v7, v12, v7
        ds_write_b32    v8, v10
        v_lshlrev_b32   v7, 2, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v5, v11
        v_add_i32       v7, vcc, 0x4210, v7
        ds_wrxchg_rtn_b32 v7, v7, v23
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v7, v7, 0, 16
        v_add_i32       v23, vcc, 0x100, v23
        ds_write_b16    v1, v7
        v_add_i32       v4, vcc, 0x2000, v4
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    s[24:25], v2, v23
        s_mov_b64       s[26:27], exec
        s_andn2_b64     exec, s[26:27], s[24:25]
        v_cndmask_b32   v24, 0, -1, s[24:25]
        s_cbranch_execz .L836_4
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L844_4
.L836_4:
        s_and_b64       exec, s[26:27], s[14:15]
        s_branch        .L608_4
.L844_4:
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v25, 0x100
.L856_4:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v25, v3
        v_mov_b32       v23, v3
        v_mov_b32       v24, v3
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1120_4
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v5, v0
.L904_4:
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v5
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L928_4:
        v_lshlrev_b32   v6, 1, v2
        v_add_i32       v6, vcc, 0x4610, v6
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v6, v6
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v6, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1076_4
        s_and_b64       exec, s[22:23], s[20:21]
        v_mov_b32       v6, 0
        v_mov_b32       v8, -1
        ds_inc_rtn_u32  v6, v6, v8 offset:16896
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_lt_u32    vcc, s4, v6
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1076_4
        s_and_b64       exec, s[22:23], s[20:21]
        v_lshlrev_b32   v6, 1, v6
        v_add_i32       v8, vcc, 0x3580, v6
        v_bfe_u32       v9, v5, 0, 16
        ds_write_b16    v8, v9
        v_add_i32       v6, vcc, 0x3bc0, v6
        ds_write_b16    v6, v2
        s_branch        .L928_4
.L1076_4:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v5, vcc, 0x100, v5
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v5
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1120_4
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L904_4
.L1120_4:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v5, 0
        ds_read_b32     v5, v5 offset:16896
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v5, 0x31a, v5
        v_mov_b32       v6, 0
        v_cmp_lg_i32    vcc, v5, v6
        s_cbranch_vccz  .L2016_4
        s_lshl_b32      s1, s1, 1
        v_and_b32       v6, 1, v0
        v_lshlrev_b32   v7, 4, v6
        v_or_b32        v8, 32, v7
        v_lshrrev_b32   v9, 1, v0
        v_and_b32       v0, -2, v0
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0x556
        v_not_b32       v10, v9
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v5
        v_mov_b32       v4, v3
.L1216_4:
        v_cmp_gt_u32    vcc, s2, v9
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v10
        s_cbranch_execz .L1304_4
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x3bc0, v1
        v_add_i32       v1, vcc, 0x3580, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v25, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v25
        v_lshlrev_b32   v5, 2, v1
        v_add_i32       v23, vcc, 16, v3
        v_add_i32       v24, vcc, 16, v5
.L1304_4:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        v_cmp_eq_i32    vcc, 0, v6
        s_and_b64       exec, s[6:7], vcc
        s_waitcnt       expcnt(0)
        v_mov_b32       v11, 0x2ac
        s_cbranch_execz .L1352_4
        ds_write_b16    v0, v11 offset:19312
.L1352_4:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v4, vcc, 0xab0, v24
        s_cbranch_execz .L1828_4
        s_nop           0x0
        v_add_i32       v11, vcc, 0xab0, v23
        v_add_i32       v12, vcc, 0x1560, v23
        v_add_i32       v13, vcc, 0x1560, v24
        ds_read_b32     v14, v24
        ds_read_b32     v15, v23
        ds_read_b32     v4, v4
        ds_read_b32     v11, v11
        v_add_i32       v16, vcc, 0x2010, v23
        v_add_i32       v17, vcc, 0x2010, v24
        ds_read_b32     v12, v12
        ds_read_b32     v13, v13
        v_add_i32       v18, vcc, 0x2ac0, v23
        v_add_i32       v19, vcc, 0x2ac0, v24
        ds_read_b32     v16, v16
        ds_read_b32     v17, v17
        ds_read_b32     v18, v18
        ds_read_b32     v19, v19
        s_waitcnt       lgkmcnt(0)
        v_xor_b32       v20, v14, v15
        v_xor_b32       v21, v4, v11
        v_alignbit_b32  v22, v21, v20, 8
        v_xor_b32       v12, v12, v13
        v_alignbit_b32  v13, v12, v21, 8
        v_xor_b32       v16, v16, v17
        v_alignbit_b32  v12, v16, v12, 8
        v_xor_b32       v17, v18, v19
        v_lshlrev_b32   v18, 10, v25
        v_cmp_eq_i32    s[14:15], v14, v15
        v_cmp_eq_i32    vcc, v4, v11
        v_alignbit_b32  v4, v17, v16, 8
        v_and_b32       v11, 0xffc00, v18
        v_mov_b32       v35, v22
        v_lshrrev_b32   v14, 8, v17
        v_or_b32        v11, s0, v11
        v_and_b32       v5, 0x3ff, v1
        v_mov_b32       v36, v13
        v_or_b32        v5, v11, v5
        v_mov_b32       v37, v12
        s_and_b64       vcc, s[14:15], vcc
        v_mov_b32       v38, v4
        v_lshrrev_b32   v4, 24, v20
        v_cndmask_b32   v11, 0, -1, vcc
        v_mov_b32       v39, v14
        v_lshrrev_b32   v12, 8, v20
        v_and_b32       v4, 0xf0, v4
        s_movk_i32      s3, 0xf0f
        v_or_b32        v11, v6, v11
        v_mov_b32       v40, v5
        v_bfi_b32       v4, s3, v12, v4
        v_bfe_i32       v5, v11, 0, 1
        v_cmp_eq_u32    vcc, 0, v5
        s_and_saveexec_b64 s[14:15], vcc
        v_lshrrev_b32   v5, 1, v4
        s_cbranch_execz .L1828_4
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v11, v4, s3
        v_add_i32       v5, vcc, v5, v11
        v_lshrrev_b32   v11, 3, v4
        v_sub_i32       v5, vcc, v5, v11
        v_lshrrev_b32   v5, 30, v5
        v_mul_lo_i32    v11, v5, 10
        v_and_b32       v11, 30, v11
        v_lshl_b32      v12, 1, v11
        v_sub_i32       v5, vcc, v4, v5
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v5, v5, s3
        v_add_i32       v5, vcc, s1, v5
        v_lshlrev_b32   v5, 2, v5
        v_add_i32       v5, vcc, 0x1558, v5
        ds_add_rtn_u32  v5, v5, v12 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v5, v5, v11
        v_and_b32       v5, 0x3ff, v5
        ds_write_b16    v0, v5 offset:19312
.L1828_4:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        ds_read_u16     v5, v0 offset:19312
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v5, 0xffff, v5
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v5
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L1984_4
        v_lshrrev_b32   v26, 2, v8
        s_cbranch_execz .L1948_4
        s_mov_b32       s29, m0
        s_mov_b64       s[30:31], exec
.L1892_4:
        v_readfirstlane_b32 s28, v26
        s_mov_b32       m0, s28
        s_mov_b64       s[32:33], exec
        v_cmpx_eq_i32   s[34:35], s28, v26
        s_andn2_b64     s[32:33], s[32:33], s[34:35]
        v_movrels_b32   v11, v27
        v_movrels_b32   v12, v28
        v_movrels_b32   v13, v29
        v_movrels_b32   v14, v30
        s_mov_b64       exec, s[32:33]
        s_cbranch_execnz .L1892_4
        s_mov_b64       exec, s[30:31]
        s_mov_b32       m0, s29
.L1948_4:
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v15, v4, s3
        v_add_i32       v5, vcc, v5, v15
        v_lshlrev_b32   v5, 5, v5
        v_add_i32       v5, vcc, s5, v5
        v_add_i32       v5, vcc, v7, v5
        tbuffer_store_format_xyzw v[11:14], v5, s[8:11], 0 offen format:[32_32_32_32,float]
.L1984_4:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x80
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L2016_4
        s_mov_b32       s2, s4
        s_branch        .L1216_4
.L2016_4:
        s_endpgm
.kernel kernel_round4
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 38
        .vgprsnum 40
        .hwlocal 19568
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00268098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        v_mov_b32       v1, 0
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        v_mov_b32       v24, 0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L1984_5
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L160_5
        v_add_i32       v1, vcc, 0x4210, v1
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L96_5:
        v_mov_b32       v3, 0x2ac
        ds_write_b32    v1, v3
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x100
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L160_5
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_5
.L160_5:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L436_5
        s_lshl_b32      s10, s1, 1
        s_mulk_i32      s10, 0x556
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x4610, v1
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L224_5:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s11, 0x2ac
        v_cmp_gt_u32    vcc, s11, v2
        s_mov_b64       s[22:23], exec
        s_andn2_b64     exec, s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L288_5
        s_and_b64       exec, s[22:23], s[20:21]
        s_branch        .L224_5
.L288_5:
        s_mov_b64       exec, s[14:15]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L420_5
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s12, s0, 0x55555555
        s_add_u32       s11, s11, s12
        s_lshr_b32      s12, s0, 3
        s_sub_u32       s11, s11, s12
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s12, s0, s11
        s_mul_i32       s12, s12, 0xaaaaaaab
        s_add_u32       s10, s10, s12
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v1, s10
        v_add_i32       v1, vcc, 0x1558, v1
        ds_read_b32     v1, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v1, s10, v1
        v_and_b32       v1, 0x3ff, v1
        v_min_u32       v4, 0x2ac, v1
        v_mov_b32       v2, 0
        ds_write_b32    v2, v4 offset:16896
        v_mov_b32       v1, 1
.L420_5:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[14:15]
.L436_5:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v3, 0
        ds_read_b32     v3, v3 offset:16896
        v_bfe_i32       v1, v1, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v3, v4, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L520_5
        ds_write_b32    v1, v1 offset:16896
.L520_5:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L860_5
        v_add_i32       v1, vcc, 0x4610, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v3, vcc, s10, v0
        v_lshlrev_b32   v3, 5, v3
        v_add_i32       v3, vcc, s4, v3
        v_lshlrev_b32   v4, 2, v0
        v_add_i32       v4, vcc, 0x2ad0, v4
        s_load_dwordx4  s[20:23], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v21, v0
        s_nop           0x0
.L608_5:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[6:9], v3, s[20:23], 0 offen format:[32_32_32_32,float]
        tbuffer_load_format_x v10, v3, s[20:23], 0 offen offset:16 format:[32,float]
        v_add_i32       v11, vcc, 0xffffd540, v4
        s_waitcnt       vmcnt(1)
        ds_write_b32    v11, v6
        v_add_i32       v11, vcc, 0xffffdff0, v4
        v_lshrrev_b32   v12, 8, v6
        ds_write_b32    v11, v7
        v_add_i32       v7, vcc, 0xffffeaa0, v4
        v_bfe_u32       v6, v6, 16, 4
        v_and_b32       v11, 0xf0, v12
        ds_write_b32    v7, v8
        v_add_i32       v7, vcc, 0xfffff550, v4
        v_or_b32        v6, v6, v11
        ds_write_b32    v7, v9
        v_lshlrev_b32   v6, 2, v6
        s_waitcnt       vmcnt(0)
        ds_write_b32    v4, v10
        v_add_i32       v6, vcc, 0x4210, v6
        ds_wrxchg_rtn_b32 v6, v6, v21
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        v_add_i32       v21, vcc, 0x100, v21
        ds_write_b16    v1, v6
        v_add_i32       v3, vcc, 0x2000, v3
        v_add_i32       v4, vcc, 0x400, v4
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    s[24:25], v2, v21
        s_mov_b64       s[26:27], exec
        s_andn2_b64     exec, s[26:27], s[24:25]
        v_cndmask_b32   v3, 0, -1, s[24:25]
        s_cbranch_execz .L840_5
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L848_5
.L840_5:
        s_and_b64       exec, s[26:27], s[14:15]
        s_branch        .L608_5
.L848_5:
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v22, 0x100
.L860_5:
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L880_5
        v_mov_b32       v22, v1
        v_mov_b32       v21, v1
        v_mov_b32       v3, v1
.L880_5:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1120_5
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v4, v0
.L912_5:
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v4
        s_nop           0x0
.L928_5:
        v_lshlrev_b32   v5, 1, v2
        v_add_i32       v5, vcc, 0x4610, v5
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v5, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v5, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1076_5
        s_and_b64       exec, s[22:23], s[20:21]
        v_mov_b32       v5, 0
        v_mov_b32       v7, -1
        ds_inc_rtn_u32  v5, v5, v7 offset:16896
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_lt_u32    vcc, s4, v5
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1076_5
        s_and_b64       exec, s[22:23], s[20:21]
        v_lshlrev_b32   v5, 1, v5
        v_add_i32       v7, vcc, 0x3580, v5
        v_bfe_u32       v8, v4, 0, 16
        ds_write_b16    v7, v8
        v_add_i32       v5, vcc, 0x3bc0, v5
        ds_write_b16    v5, v2
        s_branch        .L928_5
.L1076_5:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v4
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1120_5
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L912_5
.L1120_5:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v4, 0
        ds_read_b32     v4, v4 offset:16896
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v4, 0x31a, v4
        v_mov_b32       v5, 0
        v_cmp_lg_i32    vcc, v4, v5
        s_cbranch_vccz  .L1984_5
        v_and_b32       v5, 1, v0
        v_lshlrev_b32   v6, 4, v5
        v_or_b32        v7, 32, v6
        v_lshrrev_b32   v8, 1, v0
        v_and_b32       v0, -2, v0
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0xaac
        v_not_b32       v9, v8
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v4
        s_nop           0x0
        s_nop           0x0
.L1216_5:
        v_cmp_gt_u32    vcc, s2, v8
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v9
        s_cbranch_execz .L1304_5
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x3bc0, v1
        v_add_i32       v1, vcc, 0x3580, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v22, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v22
        v_lshlrev_b32   v4, 2, v1
        v_add_i32       v21, vcc, 16, v3
        v_add_i32       v3, vcc, 16, v4
.L1304_5:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        v_cmp_eq_i32    s[14:15], v5, 0
        s_and_b64       exec, s[6:7], s[14:15]
        v_mov_b32       v10, 0x2ac
        s_cbranch_execz .L1360_5
        ds_write_b16    v0, v10 offset:19312
        v_mov_b32       v4, 0x2ac
.L1360_5:
        s_andn2_b64     exec, s[6:7], exec
        v_cndmask_b32   v4, 0, -1, s[14:15]
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v10, vcc, 0xab0, v3
        s_cbranch_execz .L1792_5
        s_waitcnt       expcnt(0)
        s_nop           0x0
        v_add_i32       v11, vcc, 0xab0, v21
        ds_read_b32     v10, v10
        ds_read_b32     v11, v11
        ds_read_b32     v12, v21
        ds_read_b32     v13, v3
        v_add_i32       v14, vcc, 0x1560, v21
        v_add_i32       v15, vcc, 0x1560, v3
        v_add_i32       v16, vcc, 0x2010, v21
        v_add_i32       v17, vcc, 0x2010, v3
        ds_read_b32     v14, v14
        ds_read_b32     v15, v15
        v_add_i32       v18, vcc, 0x2ac0, v21
        v_add_i32       v19, vcc, 0x2ac0, v3
        ds_read_b32     v16, v16
        ds_read_b32     v17, v17
        ds_read_b32     v18, v18
        ds_read_b32     v19, v19
        s_waitcnt       lgkmcnt(0)
        v_xor_b32       v20, v10, v11
        v_xor_b32       v12, v12, v13
        v_alignbit_b32  v12, v20, v12, 24
        v_xor_b32       v13, v14, v15
        v_lshlrev_b32   v14, 10, v22
        v_cmp_eq_i32    s[14:15], v12, 0
        v_cmp_eq_i32    vcc, v10, v11
        v_xor_b32       v10, v16, v17
        v_and_b32       v11, 0xffc00, v14
        v_xor_b32       v14, v18, v19
        v_or_b32        v11, s0, v11
        v_and_b32       v4, 0x3ff, v1
        v_mov_b32       v32, v20
        v_or_b32        v4, v11, v4
        v_mov_b32       v33, v13
        s_and_b64       vcc, s[14:15], vcc
        v_mov_b32       v34, v10
        v_cndmask_b32   v10, 0, -1, vcc
        v_mov_b32       v35, v14
        v_or_b32        v10, v5, v10
        v_mov_b32       v36, v4
        v_and_b32       v4, 0xfff, v12
        v_bfe_i32       v10, v10, 0, 1
        v_cmp_eq_u32    vcc, 0, v10
        s_and_saveexec_b64 s[14:15], vcc
        v_lshrrev_b32   v10, 1, v4
        s_cbranch_execz .L1792_5
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v11, v4, s3
        v_add_i32       v10, vcc, v10, v11
        v_lshrrev_b32   v11, 3, v4
        v_sub_i32       v10, vcc, v10, v11
        v_lshrrev_b32   v10, 30, v10
        v_mul_lo_i32    v11, v10, 10
        v_and_b32       v11, 30, v11
        v_lshl_b32      v12, 1, v11
        v_sub_i32       v10, vcc, v4, v10
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v10, v10, s3
        v_add_i32       v10, vcc, s1, v10
        v_lshlrev_b32   v10, 2, v10
        ds_add_rtn_u32  v10, v10, v12 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v10, v10, v11
        v_and_b32       v10, 0x3ff, v10
        ds_write_b16    v0, v10 offset:19312
.L1792_5:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        ds_read_u16     v10, v0 offset:19312
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v10, 0xffff, v10
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v10
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L1952_5
        v_lshrrev_b32   v23, 2, v7
        s_waitcnt       expcnt(0)
        s_cbranch_execz .L1916_5
        s_mov_b32       s29, m0
        s_mov_b64       s[30:31], exec
.L1860_5:
        v_readfirstlane_b32 s28, v23
        s_mov_b32       m0, s28
        s_mov_b64       s[32:33], exec
        v_cmpx_eq_i32   s[34:35], s28, v23
        s_andn2_b64     s[32:33], s[32:33], s[34:35]
        v_movrels_b32   v11, v24
        v_movrels_b32   v12, v25
        v_movrels_b32   v13, v26
        v_movrels_b32   v14, v27
        s_mov_b64       exec, s[32:33]
        s_cbranch_execnz .L1860_5
        s_mov_b64       exec, s[30:31]
        s_mov_b32       m0, s29
.L1916_5:
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v4, v4, s3
        v_add_i32       v4, vcc, v10, v4
        v_lshlrev_b32   v4, 5, v4
        v_add_i32       v4, vcc, s5, v4
        v_add_i32       v4, vcc, v6, v4
        tbuffer_store_format_xyzw v[11:14], v4, s[8:11], 0 offen format:[32_32_32_32,float]
.L1952_5:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x80
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L1984_5
        s_mov_b32       s2, s4
        s_branch        .L1216_5
.L1984_5:
        s_endpgm
.kernel kernel_round5
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 38
        .vgprsnum 41
        .hwlocal 16832
        .floatmode 0xc0
        .uavid 11
        .uavprivate 64
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00210098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        v_mov_b32       v1, 0
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        v_mov_b32       v25, 0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L1964_6
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L160_6
        v_add_i32       v1, vcc, 0x3760, v1
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L96_6:
        v_mov_b32       v3, 0x2ac
        ds_write_b32    v1, v3
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x100
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L160_6
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_6
.L160_6:
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L428_6
        s_mul_i32       s10, s1, 0xaac
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x3b60, v1
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v0
        s_nop           0x0
.L224_6:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s11, 0x2ac
        v_cmp_gt_u32    vcc, s11, v2
        s_mov_b64       s[22:23], exec
        s_andn2_b64     exec, s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L288_6
        s_and_b64       exec, s[22:23], s[20:21]
        s_branch        .L224_6
.L288_6:
        s_mov_b64       exec, s[14:15]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L412_6
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s12, s0, 0x55555555
        s_add_u32       s11, s11, s12
        s_lshr_b32      s12, s0, 3
        s_sub_u32       s11, s11, s12
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s12, s0, s11
        s_mul_i32       s12, s12, 0xaaaaaaab
        s_add_u32       s10, s10, s12
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v1, s10
        ds_read_b32     v1, v1 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v1, s10, v1
        v_and_b32       v1, 0x3ff, v1
        v_min_u32       v4, 0x2ac, v1
        v_mov_b32       v2, 0
        ds_write_b32    v2, v4 offset:14160
        v_mov_b32       v1, 1
.L412_6:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[14:15]
.L428_6:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v1, 0
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v3, 0
        ds_read_b32     v3, v3 offset:14160
        v_bfe_i32       v1, v1, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v3, v4, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L512_6
        ds_write_b32    v1, v1 offset:14160
.L512_6:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L828_6
        v_add_i32       v1, vcc, 0x3b60, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v3, vcc, s10, v0
        v_lshlrev_b32   v3, 5, v3
        v_add_i32       v3, vcc, s4, v3
        v_lshlrev_b32   v4, 2, v0
        v_add_i32       v4, vcc, 0x1570, v4
        s_load_dwordx4  s[20:23], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v21, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L608_6:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[6:9], v3, s[20:23], 0 offen format:[32_32_32_32,float]
        v_add_i32       v10, vcc, 0xffffeaa0, v4
        s_waitcnt       vmcnt(0)
        ds_write_b32    v10, v6
        v_add_i32       v10, vcc, 0xfffff550, v4
        v_and_b32       v11, 0xf0, v6
        v_bfe_u32       v6, v6, 12, 4
        ds_write_b32    v10, v7
        v_or_b32        v6, v11, v6
        ds_write_b32    v4, v8
        v_add_i32       v7, vcc, 0xab0, v4
        v_lshlrev_b32   v6, 2, v6
        ds_write_b32    v7, v9
        v_add_i32       v6, vcc, 0x3760, v6
        ds_wrxchg_rtn_b32 v6, v6, v21
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        v_add_i32       v21, vcc, 0x100, v21
        ds_write_b16    v1, v6
        v_add_i32       v3, vcc, 0x2000, v3
        v_add_i32       v4, vcc, 0x400, v4
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    s[24:25], v2, v21
        s_mov_b64       s[26:27], exec
        s_andn2_b64     exec, s[26:27], s[24:25]
        v_cndmask_b32   v22, 0, -1, s[24:25]
        s_cbranch_execz .L808_6
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L816_6
.L808_6:
        s_and_b64       exec, s[26:27], s[14:15]
        s_branch        .L608_6
.L816_6:
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v23, 0x100
.L828_6:
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L848_6
        v_mov_b32       v23, v1
        v_mov_b32       v21, v1
        v_mov_b32       v22, v1
.L848_6:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1088_6
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v4, v0
.L880_6:
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[20:21], exec
        v_mov_b32       v2, v4
        s_nop           0x0
.L896_6:
        v_lshlrev_b32   v5, 1, v2
        v_add_i32       v5, vcc, 0x3b60, v5
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v5, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v5, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1044_6
        s_and_b64       exec, s[22:23], s[20:21]
        v_mov_b32       v5, 0
        v_mov_b32       v7, -1
        ds_inc_rtn_u32  v5, v5, v7 offset:14160
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_lt_u32    vcc, s4, v5
        s_and_saveexec_b64 s[22:23], vcc
        s_andn2_b64     s[20:21], s[20:21], exec
        s_cbranch_scc0  .L1044_6
        s_and_b64       exec, s[22:23], s[20:21]
        v_lshlrev_b32   v5, 1, v5
        v_add_i32       v7, vcc, 0x2ad0, v5
        v_bfe_u32       v8, v4, 0, 16
        ds_write_b16    v7, v8
        v_add_i32       v5, vcc, 0x3110, v5
        ds_write_b16    v5, v2
        s_branch        .L896_6
.L1044_6:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v4
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1088_6
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L880_6
.L1088_6:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v4, 0
        ds_read_b32     v4, v4 offset:14160
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v4, 0x31a, v4
        v_mov_b32       v5, 0
        v_cmp_lg_i32    vcc, v4, v5
        s_cbranch_vccz  .L1964_6
        s_lshl_b32      s1, s1, 1
        v_and_b32       v5, 1, v0
        v_lshlrev_b32   v6, 4, v5
        v_or_b32        v7, 32, v6
        v_lshrrev_b32   v8, 1, v0
        v_and_b32       v0, -2, v0
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0x556
        v_not_b32       v9, v8
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v4
        s_nop           0x0
.L1184_6:
        v_cmp_gt_u32    vcc, s2, v8
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v9
        s_cbranch_execz .L1272_6
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x3110, v1
        v_add_i32       v1, vcc, 0x2ad0, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v23, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v23
        v_lshlrev_b32   v4, 2, v1
        v_add_i32       v21, vcc, 16, v3
        v_add_i32       v22, vcc, 16, v4
.L1272_6:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        v_cmp_eq_i32    s[14:15], v5, 0
        s_and_b64       exec, s[6:7], s[14:15]
        v_mov_b32       v10, 0x2ac
        s_cbranch_execz .L1328_6
        ds_write_b16    v0, v10 offset:16576
        v_mov_b32       v3, 0x2ac
.L1328_6:
        s_andn2_b64     exec, s[6:7], exec
        v_cndmask_b32   v3, 0, -1, s[14:15]
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v10, vcc, 0xab0, v22
        s_cbranch_execz .L1772_6
        s_waitcnt       expcnt(0)
        s_nop           0x0
        v_add_i32       v11, vcc, 0xab0, v21
        v_add_i32       v12, vcc, 0x1560, v21
        v_add_i32       v13, vcc, 0x1560, v22
        ds_read_b32     v14, v22
        ds_read_b32     v15, v21
        ds_read_b32     v10, v10
        ds_read_b32     v11, v11
        v_add_i32       v16, vcc, 0x2010, v21
        v_add_i32       v17, vcc, 0x2010, v22
        ds_read_b32     v12, v12
        ds_read_b32     v13, v13
        ds_read_b32     v16, v16
        ds_read_b32     v17, v17
        s_waitcnt       lgkmcnt(0)
        v_xor_b32       v18, v14, v15
        v_xor_b32       v19, v10, v11
        v_alignbit_b32  v20, v19, v18, 8
        v_xor_b32       v12, v12, v13
        v_alignbit_b32  v13, v12, v19, 8
        v_xor_b32       v16, v16, v17
        v_lshlrev_b32   v17, 10, v23
        v_cmp_eq_i32    s[14:15], v14, v15
        v_cmp_eq_i32    vcc, v10, v11
        v_alignbit_b32  v10, v16, v12, 8
        v_and_b32       v11, 0xffc00, v17
        v_lshrrev_b32   v12, 8, v16
        v_or_b32        v11, s0, v11
        v_and_b32       v3, 0x3ff, v1
        v_mov_b32       v33, v20
        v_or_b32        v3, v11, v3
        v_mov_b32       v34, v13
        s_and_b64       vcc, s[14:15], vcc
        v_mov_b32       v35, v10
        v_lshrrev_b32   v10, 24, v18
        v_cndmask_b32   v11, 0, -1, vcc
        v_mov_b32       v36, v12
        v_lshrrev_b32   v12, 8, v18
        v_and_b32       v10, 0xf0, v10
        s_movk_i32      s3, 0xf0f
        v_or_b32        v11, v5, v11
        v_mov_b32       v37, v3
        v_bfi_b32       v3, s3, v12, v10
        v_bfe_i32       v10, v11, 0, 1
        v_cmp_eq_u32    vcc, 0, v10
        s_and_saveexec_b64 s[14:15], vcc
        v_lshrrev_b32   v10, 1, v3
        s_cbranch_execz .L1772_6
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v11, v3, s3
        v_add_i32       v10, vcc, v10, v11
        v_lshrrev_b32   v11, 3, v3
        v_sub_i32       v10, vcc, v10, v11
        v_lshrrev_b32   v10, 30, v10
        v_mul_lo_i32    v11, v10, 10
        v_and_b32       v11, 30, v11
        v_lshl_b32      v12, 1, v11
        v_sub_i32       v10, vcc, v3, v10
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v10, v10, s3
        v_add_i32       v10, vcc, s1, v10
        v_lshlrev_b32   v10, 2, v10
        v_add_i32       v10, vcc, 0x1558, v10
        ds_add_rtn_u32  v10, v10, v12 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v10, v10, v11
        v_and_b32       v10, 0x3ff, v10
        ds_write_b16    v0, v10 offset:16576
.L1772_6:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        ds_read_u16     v10, v0 offset:16576
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v10, 0xffff, v10
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v10
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L1932_6
        v_lshrrev_b32   v24, 2, v7
        s_waitcnt       expcnt(0)
        s_cbranch_execz .L1896_6
        s_mov_b32       s29, m0
        s_mov_b64       s[30:31], exec
.L1840_6:
        v_readfirstlane_b32 s28, v24
        s_mov_b32       m0, s28
        s_mov_b64       s[32:33], exec
        v_cmpx_eq_i32   s[34:35], s28, v24
        s_andn2_b64     s[32:33], s[32:33], s[34:35]
        v_movrels_b32   v11, v25
        v_movrels_b32   v12, v26
        v_movrels_b32   v13, v27
        v_movrels_b32   v14, v28
        s_mov_b64       exec, s[32:33]
        s_cbranch_execnz .L1840_6
        s_mov_b64       exec, s[30:31]
        s_mov_b32       m0, s29
.L1896_6:
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v3, v3, s3
        v_add_i32       v3, vcc, v10, v3
        v_lshlrev_b32   v3, 5, v3
        v_add_i32       v3, vcc, s5, v3
        v_add_i32       v3, vcc, v6, v3
        tbuffer_store_format_xyzw v[11:14], v3, s[8:11], 0 offen format:[32_32_32_32,float]
.L1932_6:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x80
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L1964_6
        s_mov_b32       s2, s4
        s_branch        .L1184_6
.L1964_6:
        s_endpgm
.kernel kernel_round6
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 22
        .vgprsnum 18
        .hwlocal 16568
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00208098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L1736_7
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v2, 2, v0
        s_cbranch_execz .L180_7
        v_add_i32       v2, vcc, 0x3760, v2
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v3, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L96_7:
        v_mov_b32       v4, 0x2ac
        ds_write_b32    v2, v4
        v_add_i32       v2, vcc, 0x400, v2
        v_add_i32       v3, vcc, 0x100, v3
        s_movk_i32      s12, 0x100
        v_cmp_lt_u32    s[12:13], v3, s12
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], s[12:13]
        v_cndmask_b32   v15, 0, -1, s[12:13]
        s_cbranch_execz .L168_7
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L176_7
.L168_7:
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_7
.L176_7:
        s_mov_b64       exec, s[8:9]
.L180_7:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v15, v1
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L496_7
        s_lshl_b32      s10, s1, 1
        s_mulk_i32      s10, 0x556
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x3b60, v1
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v16, v0
        s_nop           0x0
        s_nop           0x0
.L256_7:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v16, vcc, 0x100, v16
        s_movk_i32      s11, 0x2ac
        v_cmp_lt_u32    s[16:17], v16, s11
        s_mov_b64       s[18:19], exec
        s_andn2_b64     exec, s[18:19], s[16:17]
        v_cndmask_b32   v17, 0, -1, s[16:17]
        s_cbranch_execz .L328_7
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L336_7
.L328_7:
        s_and_b64       exec, s[18:19], s[14:15]
        s_branch        .L256_7
.L336_7:
        s_mov_b64       exec, s[12:13]
        v_cmp_eq_i32    s[12:13], v0, 0
        s_and_saveexec_b64 s[14:15], s[12:13]
        s_cbranch_execz .L472_7
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s16, s0, 0x55555555
        s_add_u32       s11, s11, s16
        s_lshr_b32      s16, s0, 3
        s_sub_u32       s11, s11, s16
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s16, s0, s11
        s_mul_i32       s16, s16, 0xaaaaaaab
        s_add_u32       s10, s10, s16
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v3, s10
        v_add_i32       v3, vcc, 0x1558, v3
        ds_read_b32     v3, v3 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v3, s10, v3
        v_and_b32       v3, 0x3ff, v3
        v_min_u32       v8, 0x2ac, v3
        v_mov_b32       v4, 0
        ds_write_b32    v4, v8 offset:14160
        v_mov_b32       v7, 1
.L472_7:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v7, 0
        v_mov_b32       v8, 0
        s_mov_b64       exec, s[14:15]
        v_cndmask_b32   v15, 0, -1, s[12:13]
.L496_7:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v7, 0
        v_mov_b32       v8, 0
        v_mov_b32       v16, v1
        v_mov_b32       v17, v1
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v6, 0
        ds_read_b32     v6, v6 offset:14160
        v_bfe_i32       v1, v7, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v6, v8, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L588_7
        ds_write_b32    v1, v1 offset:14160
.L588_7:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L872_7
        v_add_i32       v1, vcc, 0x3b60, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v3, vcc, s10, v0
        v_lshlrev_b32   v3, 5, v3
        v_add_i32       v3, vcc, s4, v3
        v_lshlrev_b32   v4, 2, v0
        v_add_i32       v15, vcc, 0x1570, v4
        s_load_dwordx4  s[12:15], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        v_mov_b32       v5, v0
        s_nop           0x0
.L672_7:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyzw v[6:9], v3, s[12:15], 0 offen format:[32_32_32_32,float]
        v_add_i32       v10, vcc, 0xffffeaa0, v15
        s_waitcnt       vmcnt(0)
        v_lshrrev_b32   v11, 8, v6
        ds_write_b32    v10, v6
        v_add_i32       v10, vcc, 0xfffff550, v15
        v_bfe_u32       v6, v6, 16, 4
        v_and_b32       v11, 0xf0, v11
        ds_write_b32    v10, v7
        v_or_b32        v6, v6, v11
        ds_write_b32    v15, v8
        v_add_i32       v7, vcc, 0xab0, v15
        v_lshlrev_b32   v6, 2, v6
        ds_write_b32    v7, v9
        v_add_i32       v6, vcc, 0x3760, v6
        ds_wrxchg_rtn_b32 v6, v6, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        v_add_i32       v5, vcc, 0x100, v5
        ds_write_b16    v1, v6
        v_add_i32       v3, vcc, 0x2000, v3
        v_add_i32       v15, vcc, 0x400, v15
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    vcc, v2, v5
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L672_7
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v16, 0x2000
        v_mov_b32       v17, 0x400
.L872_7:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1144_7
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v1, v0
.L904_7:
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v2, v1
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L928_7:
        v_lshlrev_b32   v4, 1, v2
        v_add_i32       v4, vcc, 0x3b60, v4
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v4, v4
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v4, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[16:17], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1100_7
        s_and_b64       exec, s[16:17], s[14:15]
        v_mov_b32       v4, 0
        v_mov_b32       v5, -1
        ds_inc_rtn_u32  v4, v4, v5 offset:14160
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_gt_u32    s[16:17], v4, s4
        s_and_saveexec_b64 s[18:19], s[16:17]
        v_cndmask_b32   v15, 0, -1, s[16:17]
        s_cbranch_execz .L1040_7
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1100_7
.L1040_7:
        s_and_b64       exec, s[18:19], s[14:15]
        v_lshlrev_b32   v4, 1, v4
        v_add_i32       v5, vcc, 0x2ad0, v4
        v_bfe_u32       v7, v1, 0, 16
        ds_write_b16    v5, v7
        v_add_i32       v4, vcc, 0x3110, v4
        ds_write_b16    v4, v2
        v_mov_b32       v15, 0x3110
        s_branch        .L928_7
.L1100_7:
        s_mov_b64       exec, s[12:13]
        v_add_i32       v1, vcc, 0x100, v1
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v1
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1144_7
        s_and_b64       exec, s[12:13], s[10:11]
        s_branch        .L904_7
.L1144_7:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v4, 0
        ds_read_b32     v4, v4 offset:14160
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v4, 0x31a, v4
        v_mov_b32       v5, 0
        v_cmp_lg_i32    vcc, v4, v5
        s_cbranch_vccz  .L1736_7
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0xaac
        v_not_b32       v5, v0
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v4
        s_nop           0x0
.L1216_7:
        v_cmp_gt_u32    vcc, s2, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v5
        s_cbranch_execz .L1304_7
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v2, vcc, 0x3110, v1
        v_add_i32       v1, vcc, 0x2ad0, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v15, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v15
        v_lshlrev_b32   v4, 2, v1
        v_add_i32       v16, vcc, 16, v3
        v_add_i32       v17, vcc, 16, v4
.L1304_7:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v6, vcc, 0xab0, v17
        s_cbranch_execz .L1704_7
        v_add_i32       v7, vcc, 0xab0, v16
        ds_read_b32     v6, v6
        ds_read_b32     v7, v7
        ds_read_b32     v8, v17
        ds_read_b32     v9, v16
        s_waitcnt       expcnt(0) & lgkmcnt(0)
        v_xor_b32       v10, v6, v7
        v_xor_b32       v8, v8, v9
        v_alignbit_b32  v8, v10, v8, 24
        v_cmp_eq_i32    s[12:13], v8, 0
        v_cmp_eq_i32    vcc, v6, v7
        s_and_b64       vcc, s[12:13], vcc
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        v_and_b32       v6, 0xfff, v8
        s_cbranch_execz .L1704_7
        s_mov_b32       s3, 0x55555555
        v_lshrrev_b32   v7, 1, v6
        v_mul_lo_i32    v8, v6, s3
        v_add_i32       v7, vcc, v7, v8
        v_lshrrev_b32   v8, 3, v6
        v_sub_i32       v7, vcc, v7, v8
        v_lshrrev_b32   v7, 30, v7
        v_sub_i32       v8, vcc, v6, v7
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v7, v7, 10
        v_mul_lo_i32    v8, v8, s3
        v_add_i32       v9, vcc, 0x1560, v17
        v_add_i32       v11, vcc, 0x1560, v16
        v_add_i32       v12, vcc, 0x2010, v17
        v_add_i32       v13, vcc, 0x2010, v16
        v_and_b32       v7, 30, v7
        v_add_i32       v8, vcc, s1, v8
        v_lshl_b32      v14, 1, v7
        v_lshlrev_b32   v8, 2, v8
        ds_read_b32     v9, v9
        ds_read_b32     v11, v11
        ds_read_b32     v12, v12
        ds_read_b32     v13, v13
        ds_add_rtn_u32  v8, v8, v14 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v7, v8, v7
        v_and_b32       v7, 0x3ff, v7
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v7
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L1704_7
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v6, v6, s3
        v_add_i32       v6, vcc, v7, v6
        v_lshlrev_b32   v6, 4, v6
        v_add_i32       v6, vcc, s5, v6
        v_cmp_lg_i32    vcc, 0, v6
        s_and_saveexec_b64 s[16:17], vcc
        v_xor_b32       v11, v9, v11
        s_cbranch_execz .L1704_7
        v_xor_b32       v12, v12, v13
        v_lshlrev_b32   v9, 10, v15
        v_and_b32       v9, 0xffc00, v9
        v_or_b32        v9, s0, v9
        v_and_b32       v4, 0x3ff, v1
        v_or_b32        v13, v9, v4
        tbuffer_store_format_xyzw v[10:13], v6, s[8:11], 0 offen format:[32_32_32_32,float]
.L1704_7:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x100
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L1736_7
        s_mov_b32       s2, s4
        s_branch        .L1216_7
.L1736_7:
        s_endpgm
.kernel kernel_round7
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 22
        .vgprsnum 19
        .hwlocal 13832
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x001b0098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L1724_8
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v3, 2, v0
        s_cbranch_execz .L180_8
        v_add_i32       v3, vcc, 0x2cb0, v3
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v4, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L96_8:
        v_mov_b32       v5, 0x2ac
        ds_write_b32    v3, v5
        v_add_i32       v3, vcc, 0x400, v3
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s12, 0x100
        v_cmp_lt_u32    s[12:13], v4, s12
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], s[12:13]
        v_cndmask_b32   v16, 0, -1, s[12:13]
        s_cbranch_execz .L168_8
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L176_8
.L168_8:
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_8
.L176_8:
        s_mov_b64       exec, s[8:9]
.L180_8:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v16, v1
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L488_8
        s_mul_i32       s10, s1, 0xaac
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x30b0, v1
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v17, v0
        s_nop           0x0
        s_nop           0x0
.L256_8:
        v_mov_b32       v4, 0x2ac
        ds_write_b16    v1, v4
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v17, vcc, 0x100, v17
        s_movk_i32      s11, 0x2ac
        v_cmp_lt_u32    s[16:17], v17, s11
        s_mov_b64       s[18:19], exec
        s_andn2_b64     exec, s[18:19], s[16:17]
        v_cndmask_b32   v18, 0, -1, s[16:17]
        s_cbranch_execz .L328_8
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L336_8
.L328_8:
        s_and_b64       exec, s[18:19], s[14:15]
        s_branch        .L256_8
.L336_8:
        s_mov_b64       exec, s[12:13]
        v_cmp_eq_i32    s[12:13], v0, 0
        s_and_saveexec_b64 s[14:15], s[12:13]
        s_cbranch_execz .L464_8
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s16, s0, 0x55555555
        s_add_u32       s11, s11, s16
        s_lshr_b32      s16, s0, 3
        s_sub_u32       s11, s11, s16
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s16, s0, s11
        s_mul_i32       s16, s16, 0xaaaaaaab
        s_add_u32       s10, s10, s16
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v4, s10
        ds_read_b32     v4, v4 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v4, s10, v4
        v_and_b32       v4, 0x3ff, v4
        v_min_u32       v9, 0x2ac, v4
        v_mov_b32       v5, 0
        ds_write_b32    v5, v9 offset:11424
        v_mov_b32       v8, 1
.L464_8:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v8, 0
        v_mov_b32       v9, 0
        s_mov_b64       exec, s[14:15]
        v_cndmask_b32   v16, 0, -1, s[12:13]
.L488_8:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v8, 0
        v_mov_b32       v9, 0
        v_mov_b32       v17, v1
        v_mov_b32       v18, v1
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v7, 0
        ds_read_b32     v7, v7 offset:11424
        v_bfe_i32       v1, v8, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v3, v7, v9, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L580_8
        ds_write_b32    v1, v1 offset:11424
.L580_8:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v3
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L852_8
        v_add_i32       v1, vcc, 0x30b0, v1
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v4, vcc, s10, v0
        v_lshlrev_b32   v4, 4, v4
        v_add_i32       v4, vcc, s4, v4
        v_lshlrev_b32   v5, 2, v0
        v_add_i32       v16, vcc, 0xac0, v5
        s_load_dwordx4  s[12:15], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        v_mov_b32       v6, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L672_8:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xyz v[7:9], v4, s[12:15], 0 offen format:[32_32_32,float]
        v_add_i32       v10, vcc, 0xfffff550, v16
        s_waitcnt       vmcnt(0)
        v_and_b32       v11, 0xf0, v7
        v_bfe_u32       v12, v7, 12, 4
        ds_write_b32    v10, v7
        v_or_b32        v7, v11, v12
        ds_write_b32    v16, v8
        v_add_i32       v8, vcc, 0xab0, v16
        v_lshlrev_b32   v7, 2, v7
        ds_write_b32    v8, v9
        v_add_i32       v7, vcc, 0x2cb0, v7
        ds_wrxchg_rtn_b32 v7, v7, v6
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v7, v7, 0, 16
        v_add_i32       v6, vcc, 0x100, v6
        ds_write_b16    v1, v7
        v_add_i32       v4, vcc, 0x1000, v4
        v_add_i32       v16, vcc, 0x400, v16
        v_add_i32       v1, vcc, 0x200, v1
        v_cmp_gt_u32    vcc, v3, v6
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L672_8
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v17, 0x1000
        v_mov_b32       v18, 0x400
.L852_8:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1112_8
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v1, v0
.L884_8:
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v3, v1
.L896_8:
        v_lshlrev_b32   v5, 1, v3
        v_add_i32       v5, vcc, 0x30b0, v5
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v5, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v3, v5, 0, 16
        v_cmp_lt_u32    vcc, s4, v3
        s_and_saveexec_b64 s[16:17], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1068_8
        s_and_b64       exec, s[16:17], s[14:15]
        v_mov_b32       v5, 0
        v_mov_b32       v6, -1
        ds_inc_rtn_u32  v5, v5, v6 offset:11424
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_gt_u32    s[16:17], v5, s4
        s_and_saveexec_b64 s[18:19], s[16:17]
        v_cndmask_b32   v16, 0, -1, s[16:17]
        s_cbranch_execz .L1008_8
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1068_8
.L1008_8:
        s_and_b64       exec, s[18:19], s[14:15]
        v_lshlrev_b32   v5, 1, v5
        v_add_i32       v6, vcc, 0x2020, v5
        v_bfe_u32       v8, v1, 0, 16
        ds_write_b16    v6, v8
        v_add_i32       v5, vcc, 0x2660, v5
        ds_write_b16    v5, v3
        v_mov_b32       v16, 0x2660
        s_branch        .L896_8
.L1068_8:
        s_mov_b64       exec, s[12:13]
        v_add_i32       v1, vcc, 0x100, v1
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v1
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1112_8
        s_and_b64       exec, s[12:13], s[10:11]
        s_branch        .L884_8
.L1112_8:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v5, 0
        ds_read_b32     v5, v5 offset:11424
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v5, 0x31a, v5
        v_mov_b32       v6, 0
        v_cmp_lg_i32    vcc, v5, v6
        s_cbranch_vccz  .L1724_8
        s_lshl_b32      s1, s1, 1
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0x556
        v_not_b32       v6, v0
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v5
.L1184_8:
        v_cmp_gt_u32    vcc, s2, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v6
        s_cbranch_execz .L1272_8
        v_lshlrev_b32   v1, 1, v1
        v_add_i32       v3, vcc, 0x2660, v1
        v_add_i32       v1, vcc, 0x2020, v1
        ds_read_u16     v3, v3
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v16, 0xffff, v3
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v4, 2, v16
        v_lshlrev_b32   v5, 2, v1
        v_add_i32       v17, vcc, 16, v4
        v_add_i32       v18, vcc, 16, v5
.L1272_8:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v7, vcc, 0xab0, v18
        s_cbranch_execz .L1692_8
        v_add_i32       v8, vcc, 0xab0, v17
        ds_read_b32     v9, v18
        ds_read_b32     v10, v17
        ds_read_b32     v7, v7
        ds_read_b32     v8, v8
        s_waitcnt       lgkmcnt(0)
        v_cmp_eq_i32    s[12:13], v9, v10
        v_cmp_eq_i32    vcc, v7, v8
        s_waitcnt       expcnt(0)
        v_lshlrev_b32   v11, 10, v16
        v_and_b32       v11, 0xffc00, v11
        v_or_b32        v11, s0, v11
        v_and_b32       v5, 0x3ff, v1
        s_and_b64       vcc, s[12:13], vcc
        v_or_b32        v5, v11, v5
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        v_xor_b32       v9, v9, v10
        s_cbranch_execz .L1692_8
        v_lshrrev_b32   v10, 24, v9
        v_lshrrev_b32   v11, 8, v9
        v_and_b32       v10, 0xf0, v10
        s_movk_i32      s3, 0xf0f
        v_bfi_b32       v10, s3, v11, v10
        s_mov_b32       s3, 0x55555555
        v_lshrrev_b32   v11, 1, v10
        v_mul_lo_i32    v12, v10, s3
        v_add_i32       v11, vcc, v11, v12
        v_lshrrev_b32   v12, 3, v10
        v_sub_i32       v11, vcc, v11, v12
        v_lshrrev_b32   v11, 30, v11
        v_sub_i32       v12, vcc, v10, v11
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v12, v12, s3
        v_mul_lo_i32    v11, v11, 10
        v_add_i32       v12, vcc, s1, v12
        v_add_i32       v13, vcc, 0x1560, v18
        v_add_i32       v14, vcc, 0x1560, v17
        v_and_b32       v11, 30, v11
        v_lshlrev_b32   v12, 2, v12
        v_lshl_b32      v15, 1, v11
        v_add_i32       v12, vcc, 0x1558, v12
        ds_read_b32     v13, v13
        ds_read_b32     v14, v14
        ds_add_rtn_u32  v12, v12, v15 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v11, v12, v11
        v_and_b32       v11, 0x3ff, v11
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v11
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L1692_8
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v10, v10, s3
        v_add_i32       v10, vcc, v11, v10
        v_lshlrev_b32   v10, 4, v10
        v_add_i32       v10, vcc, s5, v10
        v_cmp_lg_i32    vcc, 0, v10
        s_and_saveexec_b64 s[16:17], vcc
        v_xor_b32       v7, v7, v8
        s_cbranch_execz .L1692_8
        v_alignbit_b32  v3, v7, v9, 8
        v_xor_b32       v9, v13, v14
        v_alignbit_b32  v4, v9, v7, 8
        v_mov_b32       v13, v5
        v_mov_b32       v14, v2
        v_mov_b32       v11, v3
        v_mov_b32       v12, v4
        tbuffer_store_format_xyzw v[11:14], v10, s[8:11], 0 offen format:[32_32_32_32,float]
.L1692_8:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x100
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L1724_8
        s_mov_b32       s2, s4
        s_branch        .L1184_8
.L1724_8:
        s_endpgm
.kernel kernel_round8
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 22
        .vgprsnum 14
        .hwlocal 11096
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00160098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg ht_dst, "char*", char*, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
        .arg rowCountersDst, "uint*", uint*, global, , 11, unused
        .arg debug, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x1c
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s12, s0
        s_cmp_le_u32    s0, 0xfff
        s_cbranch_scc0  .L1636_9
        s_movk_i32      s6, 0xff
        v_cmp_ge_u32    vcc, s6, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_lshlrev_b32   v2, 2, v0
        s_cbranch_execz .L180_9
        v_add_i32       v2, vcc, 0x2200, v2
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v3, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L96_9:
        v_mov_b32       v4, 0x2ac
        ds_write_b32    v2, v4
        v_add_i32       v2, vcc, 0x400, v2
        v_add_i32       v3, vcc, 0x100, v3
        s_movk_i32      s12, 0x100
        v_cmp_lt_u32    s[12:13], v3, s12
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], s[12:13]
        v_cndmask_b32   v11, 0, -1, s[12:13]
        s_cbranch_execz .L168_9
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L176_9
.L168_9:
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L96_9
.L176_9:
        s_mov_b64       exec, s[8:9]
.L180_9:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v11, v1
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s6, 0x2ab
        v_cmp_gt_u32    s[6:7], v0, s6
        s_mov_b64       s[8:9], exec
        s_andn2_b64     exec, s[8:9], s[6:7]
        s_cbranch_execz .L496_9
        s_lshl_b32      s10, s1, 1
        s_mulk_i32      s10, 0x556
        v_lshlrev_b32   v1, 1, v0
        v_add_i32       v1, vcc, 0x2600, v1
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v12, v0
        s_nop           0x0
        s_nop           0x0
.L256_9:
        v_mov_b32       v3, 0x2ac
        ds_write_b16    v1, v3
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v12, vcc, 0x100, v12
        s_movk_i32      s11, 0x2ac
        v_cmp_lt_u32    s[16:17], v12, s11
        s_mov_b64       s[18:19], exec
        s_andn2_b64     exec, s[18:19], s[16:17]
        v_cndmask_b32   v13, 0, -1, s[16:17]
        s_cbranch_execz .L328_9
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L336_9
.L328_9:
        s_and_b64       exec, s[18:19], s[14:15]
        s_branch        .L256_9
.L336_9:
        s_mov_b64       exec, s[12:13]
        v_cmp_eq_i32    s[12:13], v0, 0
        s_and_saveexec_b64 s[14:15], s[12:13]
        s_cbranch_execz .L472_9
        s_lshr_b32      s11, s0, 1
        s_mul_i32       s16, s0, 0x55555555
        s_add_u32       s11, s11, s16
        s_lshr_b32      s16, s0, 3
        s_sub_u32       s11, s11, s16
        s_lshr_b32      s11, s11, 30
        s_sub_u32       s16, s0, s11
        s_mul_i32       s16, s16, 0xaaaaaaab
        s_add_u32       s10, s10, s16
        s_lshl_b32      s10, s10, 2
        v_mov_b32       v3, s10
        v_add_i32       v3, vcc, 0x1558, v3
        ds_read_b32     v3, v3 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        s_mul_i32       s10, s11, 10
        s_and_b32       s10, s10, 30
        v_lshrrev_b32   v3, s10, v3
        v_and_b32       v3, 0x3ff, v3
        v_min_u32       v8, 0x2ac, v3
        v_mov_b32       v4, 0
        ds_write_b32    v4, v8 offset:8688
        v_mov_b32       v7, 1
.L472_9:
        s_andn2_b64     exec, s[14:15], exec
        v_mov_b32       v7, 0
        v_mov_b32       v8, 0
        s_mov_b64       exec, s[14:15]
        v_cndmask_b32   v11, 0, -1, s[12:13]
.L496_9:
        s_andn2_b64     exec, s[8:9], exec
        v_mov_b32       v7, 0
        v_mov_b32       v8, 0
        v_mov_b32       v12, v1
        v_mov_b32       v13, v1
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v6, 0
        ds_read_b32     v6, v6 offset:8688
        v_bfe_i32       v1, v7, 0, 1
        v_cmp_lg_i32    vcc, 0, v1
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v2, v6, v8, vcc
        s_barrier
        v_cmp_lg_u32    vcc, 0, v1
        s_and_saveexec_b64 s[8:9], vcc
        v_mov_b32       v1, 0
        s_cbranch_execz .L588_9
        ds_write_b32    v1, v1 offset:8688
.L588_9:
        s_mov_b64       exec, s[8:9]
        v_cmp_lt_u32    vcc, v0, v2
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], vcc
        v_lshlrev_b32   v1, 2, v0
        s_cbranch_execz .L840_9
        v_add_i32       v1, vcc, 16, v1
        v_lshlrev_b32   v3, 1, v0
        v_add_i32       v3, vcc, 0x2600, v3
        s_mul_i32       s10, s0, 0x2ac
        v_add_i32       v4, vcc, s10, v0
        v_lshlrev_b32   v4, 4, v4
        v_add_i32       v11, vcc, s4, v4
        s_load_dwordx4  s[12:15], s[2:3], 0x60
        s_mov_b64       s[10:11], exec
        v_mov_b32       v5, v0
        s_nop           0x0
        s_nop           0x0
.L672_9:
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xy v[6:7], v11, s[12:15], 0 offen format:[32_32,float]
        s_waitcnt       vmcnt(0)
        ds_write_b32    v1, v6
        v_add_i32       v8, vcc, 0xab0, v1
        ds_write_b32    v8, v7
        v_bfe_u32       v7, v6, 16, 4
        v_lshrrev_b32   v6, 8, v6
        v_and_b32       v6, 0xf0, v6
        v_or_b32        v6, v7, v6
        v_lshlrev_b32   v6, 2, v6
        v_add_i32       v6, vcc, 0x2200, v6
        ds_wrxchg_rtn_b32 v6, v6, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        ds_write_b16    v3, v6
        v_add_i32       v11, vcc, 0x1000, v11
        v_add_i32       v1, vcc, 0x400, v1
        v_add_i32       v3, vcc, 0x200, v3
        v_add_i32       v5, vcc, 0x100, v5
        v_cmp_gt_u32    vcc, v2, v5
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L672_9
        s_mov_b64       exec, s[10:11]
        v_mov_b32       v12, 0x1000
        v_mov_b32       v13, 0x400
.L840_9:
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_and_b64       exec, s[8:9], s[6:7]
        s_andn2_b64     exec, s[8:9], exec
        s_cbranch_execz .L1112_9
        s_mov_b64       s[6:7], exec
        s_mov_b64       s[10:11], exec
        v_mov_b32       v1, v0
.L872_9:
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v2, v1
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L896_9:
        v_lshlrev_b32   v4, 1, v2
        v_add_i32       v4, vcc, 0x2600, v4
        s_movk_i32      s4, 0x2ab
        ds_read_u16     v4, v4
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v2, v4, 0, 16
        v_cmp_lt_u32    vcc, s4, v2
        s_and_saveexec_b64 s[16:17], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1068_9
        s_and_b64       exec, s[16:17], s[14:15]
        v_mov_b32       v4, 0
        v_mov_b32       v5, -1
        ds_inc_rtn_u32  v4, v4, v5 offset:8688
        s_movk_i32      s4, 0x319
        s_waitcnt       lgkmcnt(0)
        v_cmp_gt_u32    s[16:17], v4, s4
        s_and_saveexec_b64 s[18:19], s[16:17]
        v_cndmask_b32   v11, 0, -1, s[16:17]
        s_cbranch_execz .L1008_9
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1068_9
.L1008_9:
        s_and_b64       exec, s[18:19], s[14:15]
        v_lshlrev_b32   v4, 1, v4
        v_add_i32       v5, vcc, 0x1570, v4
        v_bfe_u32       v7, v1, 0, 16
        ds_write_b16    v5, v7
        v_add_i32       v4, vcc, 0x1bb0, v4
        ds_write_b16    v4, v2
        v_mov_b32       v11, 0x1bb0
        s_branch        .L896_9
.L1068_9:
        s_mov_b64       exec, s[12:13]
        v_add_i32       v1, vcc, 0x100, v1
        s_movk_i32      s4, 0x2ac
        v_cmp_gt_u32    vcc, s4, v1
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L1112_9
        s_and_b64       exec, s[12:13], s[10:11]
        s_branch        .L872_9
.L1112_9:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v4, 0
        ds_read_b32     v4, v4 offset:8688
        s_waitcnt       lgkmcnt(0)
        v_min_u32       v4, 0x31a, v4
        v_mov_b32       v5, 0
        v_cmp_lg_i32    vcc, v4, v5
        s_cbranch_vccz  .L1636_9
        s_lshl_b32      s0, s0, 20
        s_mulk_i32      s1, 0xaac
        v_not_b32       v5, v0
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_readfirstlane_b32 s2, v4
        s_nop           0x0
.L1184_9:
        v_cmp_gt_u32    vcc, s2, v0
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v1, vcc, s2, v5
        s_cbranch_execz .L1276_9
        v_lshlrev_b32   v1, 1, v1
        s_waitcnt       expcnt(0)
        v_add_i32       v2, vcc, 0x1bb0, v1
        v_add_i32       v1, vcc, 0x1570, v1
        ds_read_u16     v2, v2
        ds_read_u16     v1, v1
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v11, 0xffff, v2
        v_and_b32       v1, 0xffff, v1
        v_lshlrev_b32   v3, 2, v11
        v_lshlrev_b32   v4, 2, v1
        v_add_i32       v12, vcc, 16, v3
        v_add_i32       v13, vcc, 16, v4
.L1276_9:
        s_andn2_b64     exec, s[6:7], exec
        v_mov_b32       v1, 0x2ac
        s_mov_b64       exec, s[6:7]
        s_movk_i32      s3, 0x2ac
        v_cmp_gt_u32    vcc, s3, v1
        s_and_saveexec_b64 s[6:7], vcc
        v_add_i32       v6, vcc, 0xab0, v13
        s_cbranch_execz .L1604_9
        v_add_i32       v7, vcc, 0xab0, v12
        ds_read_b32     v6, v6
        ds_read_b32     v7, v7
        ds_read_b32     v8, v13
        ds_read_b32     v9, v12
        s_waitcnt       expcnt(0) & lgkmcnt(0)
        v_xor_b32       v2, v6, v7
        v_xor_b32       v8, v8, v9
        v_alignbit_b32  v8, v2, v8, 24
        v_cmp_eq_i32    s[12:13], v8, 0
        v_cmp_eq_i32    vcc, v6, v7
        s_and_b64       vcc, s[12:13], vcc
        s_mov_b64       s[12:13], exec
        s_andn2_b64     exec, s[12:13], vcc
        v_and_b32       v6, 0xfff, v8
        s_cbranch_execz .L1604_9
        v_lshrrev_b32   v7, 1, v6
        s_mov_b32       s3, 0x55555555
        v_mul_lo_i32    v8, v6, s3
        v_add_i32       v7, vcc, v7, v8
        v_lshrrev_b32   v8, 3, v6
        v_sub_i32       v7, vcc, v7, v8
        v_lshrrev_b32   v7, 30, v7
        v_mul_lo_i32    v8, v7, 10
        v_and_b32       v8, 30, v8
        v_lshl_b32      v9, 1, v8
        v_sub_i32       v7, vcc, v6, v7
        s_mov_b32       s3, 0xaaaaaaab
        v_mul_lo_i32    v7, v7, s3
        v_add_i32       v7, vcc, s1, v7
        v_lshlrev_b32   v7, 2, v7
        ds_add_rtn_u32  v7, v7, v9 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_lshr_b32      v7, v7, v8
        v_and_b32       v7, 0x3ff, v7
        s_movk_i32      s3, 0x2ab
        v_cmp_ge_u32    vcc, s3, v7
        s_and_saveexec_b64 s[14:15], vcc
        s_cbranch_execz .L1604_9
        s_movk_i32      s3, 0x2ac
        v_mul_lo_i32    v6, v6, s3
        v_add_i32       v6, vcc, v7, v6
        v_lshlrev_b32   v6, 3, v6
        v_add_i32       v6, vcc, s5, v6
        v_cmp_lg_i32    vcc, 0, v6
        s_and_saveexec_b64 s[16:17], vcc
        v_lshlrev_b32   v7, 10, v11
        s_cbranch_execz .L1604_9
        v_and_b32       v7, 0xffc00, v7
        v_or_b32        v7, s0, v7
        v_and_b32       v4, 0x3ff, v1
        v_or_b32        v3, v7, v4
        tbuffer_store_format_xy v[2:3], v6, s[8:11], 0 offen format:[32_32,float]
.L1604_9:
        s_mov_b64       exec, s[6:7]
        s_min_u32       s3, s2, 0x100
        s_sub_u32       s4, s2, s3
        s_cmp_eq_i32    s2, s3
        s_cbranch_scc1  .L1636_9
        s_mov_b32       s2, s4
        s_branch        .L1184_9
.L1636_9:
        s_endpgm
.kernel kernel_potential_sols
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 20
        .vgprsnum 10
        .hwlocal 7892
        .floatmode 0xc0
        .uavid 11
        .uavprivate 0
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x000f8098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg device_thread, "uint", uint
        .arg ht_src, "char*", char*, global, const, 12
        .arg potential_sols, "potential_sols_t*", structure*, 65536, global, , 13
        .arg rowCountersSrc, "uint*", uint*, global, , 11, unused
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[4:7], 0x18
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s4, s[8:11], 0x4
        s_buffer_load_dword s5, s[8:11], 0x8
        s_lshl_b32      s6, s12, 8
        s_waitcnt       lgkmcnt(0)
        s_add_u32       s0, s6, s0
        v_add_i32       v9, vcc, s0, v0
        v_cmp_eq_i32    vcc, 0, v9
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L76_10
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_mov_b32       v2, s5
        v_mov_b32       v3, 0
        s_waitcnt       lgkmcnt(0)
        tbuffer_store_format_x v3, v2, s[8:11], 0 offen format:[32,float]
.L76_10:
        s_mov_b64       exec, s[6:7]
        s_waitcnt       vmcnt(0) & expcnt(0)
        s_barrier
        v_lshrrev_b32   v2, 8, v9
        s_movk_i32      s0, 0xfff
        v_cmp_ge_u32    vcc, s0, v2
        s_and_saveexec_b64 s[6:7], vcc
        s_cbranch_execz .L1240_10
        s_movk_i32      s0, 0xff
        v_cmp_gt_u32    s[8:9], v0, s0
        s_mov_b64       s[10:11], exec
        s_andn2_b64     exec, s[10:11], s[8:9]
        v_lshlrev_b32   v3, 2, v0
        s_cbranch_execz .L228_10
        v_add_i32       v7, vcc, 0x1570, v3
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v4, v0
        s_nop           0x0
.L160_10:
        v_mov_b32       v5, 0x2ac
        ds_write_b32    v7, v5
        v_add_i32       v7, vcc, 0x400, v7
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s0, 0x100
        v_cmp_gt_u32    vcc, s0, v4
        s_mov_b64       s[16:17], exec
        s_andn2_b64     exec, s[16:17], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L224_10
        s_and_b64       exec, s[16:17], s[14:15]
        s_branch        .L160_10
.L224_10:
        s_mov_b64       exec, s[12:13]
.L228_10:
        s_andn2_b64     exec, s[10:11], exec
        v_cndmask_b32   v7, 0, -1, s[8:9]
        s_mov_b64       exec, s[10:11]
        s_movk_i32      s0, 0x2ab
        v_cmp_gt_u32    s[8:9], v0, s0
        s_mov_b64       s[10:11], exec
        s_andn2_b64     exec, s[10:11], s[8:9]
        s_cbranch_execz .L552_10
        s_mulk_i32      s1, 0xaac
        v_lshlrev_b32   v3, 1, v0
        v_add_i32       v3, vcc, 0x1970, v3
        s_mov_b64       s[12:13], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v4, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L320_10:
        v_mov_b32       v5, 0x2ac
        ds_write_b16    v3, v5
        v_add_i32       v3, vcc, 0x200, v3
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s0, 0x2ac
        v_cmp_gt_u32    vcc, s0, v4
        s_mov_b64       s[16:17], exec
        s_andn2_b64     exec, s[16:17], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L384_10
        s_and_b64       exec, s[16:17], s[14:15]
        s_branch        .L320_10
.L384_10:
        s_mov_b64       exec, s[12:13]
        v_cmp_eq_i32    vcc, 0, v0
        s_and_saveexec_b64 s[12:13], vcc
        s_cbranch_execz .L528_10
        s_mov_b32       s0, 0x55555555
        v_lshrrev_b32   v3, 9, v9
        v_mul_lo_i32    v4, v2, s0
        v_add_i32       v3, vcc, v3, v4
        v_lshrrev_b32   v4, 11, v9
        v_sub_i32       v3, vcc, v3, v4
        v_lshrrev_b32   v3, 30, v3
        v_sub_i32       v4, vcc, v2, v3
        s_mov_b32       s0, 0xaaaaaaab
        v_mul_lo_i32    v4, v4, s0
        v_add_i32       v4, vcc, s1, v4
        v_lshlrev_b32   v4, 2, v4
        ds_read_b32     v4, v4 gds
        s_waitcnt       lgkmcnt(0) & expcnt(0)
        v_mul_lo_i32    v5, v3, 10
        v_and_b32       v5, 30, v5
        v_lshr_b32      v4, v4, v5
        v_and_b32       v4, 0x3ff, v4
        v_min_u32       v7, 0x2ac, v4
        v_mov_b32       v5, 0
        v_sub_i32       v1, vcc, 0, v3
        ds_write_b32    v5, v7 offset:7888
        v_mov_b32       v4, 1
.L528_10:
        s_andn2_b64     exec, s[12:13], exec
        v_mov_b32       v7, s1
        v_mov_b32       v4, 0
        v_mov_b32       v1, 0x200
        s_mov_b64       exec, s[12:13]
.L552_10:
        s_andn2_b64     exec, s[10:11], exec
        v_cndmask_b32   v1, 0, -1, s[8:9]
        v_mov_b32       v4, 0
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v6, 0
        ds_read_b32     v6, v6 offset:7888
        v_bfe_i32       v4, v4, 0, 1
        v_cmp_lg_i32    vcc, 0, v4
        s_waitcnt       lgkmcnt(0)
        v_cndmask_b32   v3, v6, v7, vcc
        v_cmp_lt_u32    vcc, v0, v3
        s_barrier
        s_and_saveexec_b64 s[0:1], vcc
        v_lshlrev_b32   v1, 1, v0
        s_cbranch_execz .L840_10
        v_add_i32       v1, vcc, 0x1970, v1
        s_movk_i32      s8, 0x2ac
        v_mul_lo_i32    v2, v2, s8
        v_add_i32       v2, vcc, v0, v2
        v_lshlrev_b32   v2, 3, v2
        v_add_i32       v9, vcc, s4, v2
        v_lshlrev_b32   v4, 2, v0
        s_load_dwordx4  s[8:11], s[2:3], 0x60
        s_mov_b64       s[12:13], exec
        v_mov_b32       v5, v0
.L680_10:
        v_add_i32       v6, vcc, 16, v4
        s_waitcnt       lgkmcnt(0)
        tbuffer_load_format_xy v[7:8], v9, s[8:11], 0 offen format:[32_32,float]
        s_waitcnt       vmcnt(0)
        ds_write_b32    v6, v8
        v_add_i32       v6, vcc, 0xac0, v4
        ds_write_b32    v6, v7
        v_and_b32       v6, 0xf0, v7
        v_bfe_u32       v7, v7, 12, 4
        v_or_b32        v6, v6, v7
        v_lshlrev_b32   v6, 2, v6
        v_add_i32       v6, vcc, 0x1570, v6
        ds_wrxchg_rtn_b32 v6, v6, v5
        s_waitcnt       lgkmcnt(0)
        v_bfe_u32       v6, v6, 0, 16
        ds_write_b16    v1, v6
        v_add_i32       v9, vcc, 0x800, v9
        v_add_i32       v1, vcc, 0x200, v1
        v_add_i32       v4, vcc, 0x400, v4
        v_add_i32       v5, vcc, 0x100, v5
        v_cmp_gt_u32    vcc, v3, v5
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L680_10
        s_mov_b64       exec, s[12:13]
        v_mov_b32       v1, 0x200
.L840_10:
        s_mov_b64       exec, s[0:1]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_mov_b64       s[0:1], exec
        s_mov_b64       s[8:9], exec
        v_mov_b32       v6, v4
        v_mov_b32       v4, 0
.L868_10:
        v_lshlrev_b32   v9, 2, v0
        v_cmp_ge_u32    s[10:11], v0, v3
        s_and_saveexec_b64 s[12:13], s[10:11]
        v_cndmask_b32   v9, 0, -1, s[10:11]
        s_cbranch_execz .L908_10
        v_mov_b32       v6, 0
        s_andn2_b64     s[8:9], s[8:9], exec
        s_cbranch_scc0  .L1140_10
.L908_10:
        s_and_b64       exec, s[12:13], s[8:9]
        s_waitcnt       lgkmcnt(0)
        v_add_i32       v5, vcc, 0xac0, v9
        ds_read_b32     v5, v5
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[12:13], exec
        v_mov_b32       v2, v0
        v_mov_b32       v6, 0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L960_10:
        v_lshlrev_b32   v2, 1, v2
        v_add_i32       v2, vcc, 0x1970, v2
        s_movk_i32      s4, 0x2ac
        ds_read_u16     v2, v2
        s_waitcnt       lgkmcnt(0)
        v_and_b32       v2, 0xffff, v2
        v_lshlrev_b32   v1, 2, v2
        v_cmp_lt_u32    s[14:15], v2, s4
        s_mov_b64       s[16:17], exec
        s_andn2_b64     exec, s[16:17], s[14:15]
        v_cndmask_b32   v1, 0, -1, s[14:15]
        s_cbranch_execz .L1036_10
        s_andn2_b64     s[12:13], s[12:13], exec
        s_cbranch_scc0  .L1104_10
.L1036_10:
        s_and_b64       exec, s[16:17], s[12:13]
        v_add_i32       v7, vcc, 0xac0, v1
        ds_read_b32     v7, v7
        s_waitcnt       lgkmcnt(0)
        v_cmp_lg_i32    vcc, v5, v7
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        v_mov_b32       v4, 1
        s_cbranch_execz .L1092_10
        v_mov_b32       v6, 1
        s_andn2_b64     s[12:13], s[12:13], exec
        s_cbranch_scc0  .L1104_10
.L1092_10:
        s_and_b64       exec, s[14:15], s[12:13]
        v_mov_b32       v6, 1
        s_branch        .L960_10
.L1104_10:
        s_mov_b64       exec, s[10:11]
        v_cmp_lg_u32    vcc, 0, v4
        s_and_saveexec_b64 s[10:11], vcc
        s_andn2_b64     s[8:9], s[8:9], exec
        s_cbranch_scc0  .L1140_10
        s_and_b64       exec, s[10:11], s[8:9]
        v_add_i32       v0, vcc, 0x100, v0
        s_branch        .L868_10
.L1140_10:
        s_mov_b64       exec, s[0:1]
        v_cmp_lg_i32    vcc, 0, v6
        s_and_saveexec_b64 s[0:1], vcc
        s_cbranch_execz .L1240_10
        s_load_dwordx4  s[8:11], s[2:3], 0x68
        v_add_i32       v1, vcc, 16, v1
        v_add_i32       v0, vcc, 16, v9
        v_mov_b32       v2, s5
        v_mov_b32       v3, -1
        s_movk_i32      s2, 0xfff
        ds_read_b32     v1, v1
        ds_read_b32     v0, v0
        s_waitcnt       lgkmcnt(0)
        buffer_atomic_inc v3, v2, s[8:11], 0 offen glc
        s_waitcnt       vmcnt(0)
        v_cmp_ge_u32    vcc, s2, v3
        s_and_saveexec_b64 s[2:3], vcc
        v_lshlrev_b32   v2, 3, v3
        s_cbranch_execz .L1240_10
        v_add_i32       v2, vcc, s5, v2
        tbuffer_store_format_xy v[0:1], v2, s[8:11], 0 offen offset:4 format:[32_32,float]
.L1240_10:
        s_endpgm
.kernel kernel_sols
    .config
        .dims x
        .cws 256, 1, 1
        .sgprsnum 28
        .vgprsnum 13
        .hwlocal 3092
        .floatmode 0xc0
        .uavid 0
        .uavprivate 48
        .printfid 9
        .privateid 8
        .cbid 10
        .earlyexit 0
        .condout 0
        .pgmrsrc2 0x00068098
        .userdata ptr_uav_table, 0, 2, 2
        .userdata imm_const_buffer, 0, 4, 4
        .userdata imm_const_buffer, 1, 8, 4
        .arg ht0, "char*", char*, global, , 11
        .arg ht1, "char*", char*, global, , 11
        .arg sols, "sols_t*", structure*, 32768, global, , 12
        .arg rowCountersSrc, "uint*", uint*, global, , 11
        .arg rowCountersDst, "uint*", uint*, global, , 11
        .arg ht2, "char*", char*, global, , 11
        .arg ht3, "char*", char*, global, , 11
        .arg ht4, "char*", char*, global, , 11
        .arg ht5, "char*", char*, global, , 11
        .arg ht6, "char*", char*, global, , 11
        .arg ht7, "char*", char*, global, , 11
        .arg ht8, "char*", char*, global, , 11
        .arg potential_sols, "potential_sols_t*", structure*, 65536, global, const, 13
    .text
        s_mov_b32       m0, 0xffff
        s_buffer_load_dword s0, s[8:11], 0x30
        s_load_dwordx4  s[16:19], s[2:3], 0x68
        s_buffer_load_dword s1, s[4:7], 0x18
        s_waitcnt       lgkmcnt(0)
        s_buffer_load_dword s4, s[16:19], s0
        s_lshl_b32      s5, s12, 8
        s_add_u32       s1, s5, s1
        v_add_i32       v1, vcc, s1, v0
        v_lshrrev_b32   v1, 8, v1
        s_movk_i32      s1, 0x1000
        s_waitcnt       lgkmcnt(0)
        v_cmp_gt_u32    s[4:5], s4, v1
        v_cmp_lt_u32    s[6:7], v1, s1
        s_buffer_load_dword s1, s[8:11], 0x0
        s_buffer_load_dword s12, s[8:11], 0x4
        s_buffer_load_dword s13, s[8:11], 0x8
        s_buffer_load_dword s14, s[8:11], 0x14
        s_buffer_load_dword s15, s[8:11], 0x18
        s_buffer_load_dword s20, s[8:11], 0x1c
        s_buffer_load_dword s21, s[8:11], 0x20
        s_buffer_load_dword s22, s[8:11], 0x24
        s_buffer_load_dword s8, s[8:11], 0x28
        s_and_b64       vcc, s[4:5], s[6:7]
        s_and_saveexec_b64 s[4:5], vcc
        s_cbranch_execz .L2328_11
        v_cmp_eq_i32    s[6:7], v0, 0
        s_and_saveexec_b64 s[10:11], s[6:7]
        v_lshlrev_b32   v1, 3, v1
        s_cbranch_execz .L184_11
        v_add_i32       v1, vcc, s0, v1
        tbuffer_load_format_x v2, v1, s[16:19], 0 offen offset:4 format:[32,float]
        tbuffer_load_format_x v1, v1, s[16:19], 0 offen offset:8 format:[32,float]
        v_mov_b32       v3, 0
        s_waitcnt       vmcnt(1)
        ds_write2st64_b32 v3, v3, v2 offset0:12
        s_waitcnt       vmcnt(0)
        ds_write_b32    v3, v1 offset:4
.L184_11:
        s_mov_b64       exec, s[10:11]
        v_lshlrev_b32   v1, 2, v0
        v_add_i32       v2, vcc, 0x800, v1
        v_lshlrev_b32   v3, 3, v0
        v_add_i32       v12, vcc, 4, v3
        v_add_i32       v11, vcc, 0x804, v3
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 2, v0
        s_and_saveexec_b64 s[10:11], vcc
        s_cbranch_execz .L408_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[24:25], exec
        v_mov_b32       v5, v1
        v_mov_b32       v6, v11
        v_mov_b32       v7, v0
.L256_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 4, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s8, v10
        v_lshlrev_b32   v8, 4, v8
        s_add_u32       s0, s8, 8
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:8 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 2, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L256_11
.L408_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 4, v0
        s_and_b64       exec, s[10:11], vcc
        s_cbranch_execz .L604_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[8:9], exec
        v_mov_b32       v5, v2
        v_mov_b32       v6, v12
        v_mov_b32       v7, v0
.L452_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 4, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s22, v10
        v_lshlrev_b32   v8, 4, v8
        s_add_u32       s0, s22, 12
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:12 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 4, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L452_11
.L604_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 8, v0
        s_and_b64       exec, s[10:11], vcc
        s_cbranch_execz .L800_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[8:9], exec
        v_mov_b32       v5, v1
        v_mov_b32       v6, v11
        v_mov_b32       v7, v0
.L648_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 5, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s21, v10
        v_lshlrev_b32   v8, 5, v8
        s_add_u32       s0, s21, 16
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:16 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 8, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L648_11
.L800_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 16, v0
        s_and_b64       exec, s[10:11], vcc
        s_cbranch_execz .L996_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[8:9], exec
        v_mov_b32       v5, v2
        v_mov_b32       v6, v12
        v_mov_b32       v7, v0
.L844_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 5, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s20, v10
        v_lshlrev_b32   v8, 5, v8
        s_add_u32       s0, s20, 16
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:16 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 16, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L844_11
.L996_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 32, v0
        s_and_b64       exec, s[10:11], vcc
        s_cbranch_execz .L1192_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[8:9], exec
        v_mov_b32       v5, v1
        v_mov_b32       v6, v11
        v_mov_b32       v7, v0
.L1040_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 5, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s15, v10
        v_lshlrev_b32   v8, 5, v8
        s_add_u32       s0, s15, 20
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:20 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 32, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L1040_11
.L1192_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_cmp_gt_u32    vcc, 64, v0
        s_and_b64       exec, s[10:11], vcc
        s_cbranch_execz .L1400_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[8:9], exec
        v_mov_b32       v5, v2
        v_mov_b32       v6, v12
        v_mov_b32       v7, v0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L1248_11:
        ds_read_b32     v8, v5
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v9, 20, v8
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v10, v8, 10, 10
        v_mul_lo_i32    v9, v9, s0
        v_add_i32       v10, vcc, v10, v9
        v_and_b32       v8, 0x3ff, v8
        v_lshlrev_b32   v10, 5, v10
        v_add_i32       v8, vcc, v9, v8
        v_add_i32       v9, vcc, s14, v10
        v_lshlrev_b32   v8, 5, v8
        s_add_u32       s0, s14, 20
        v_add_i32       v8, vcc, s0, v8
        tbuffer_load_format_x v9, v9, s[16:19], 0 offen offset:20 format:[32,float]
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v6, v9
        v_add_i32       v9, vcc, -4, v6
        v_add_i32       v7, vcc, 0x100, v7
        s_waitcnt       vmcnt(0)
        ds_write_b32    v9, v8
        v_add_i32       v5, vcc, 0x400, v5
        v_add_i32       v6, vcc, 0x800, v6
        v_cmp_gt_u32    vcc, 64, v7
        s_and_b64       exec, exec, vcc
        s_cbranch_execnz .L1248_11
.L1400_11:
        s_mov_b64       exec, s[10:11]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_movk_i32      s0, 0x80
        v_cmp_gt_u32    vcc, s0, v0
        s_and_saveexec_b64 s[8:9], vcc
        s_cbranch_execz .L1620_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v3, v1
        v_mov_b32       v6, v0
.L1448_11:
        ds_read_b32     v7, v3
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v8, 20, v7
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v9, v7, 10, 10
        v_mul_lo_i32    v8, v8, s0
        v_add_i32       v9, vcc, v9, v8
        v_and_b32       v7, 0x3ff, v7
        v_lshlrev_b32   v9, 5, v9
        v_add_i32       v7, vcc, v8, v7
        v_add_i32       v8, vcc, s12, v9
        v_lshlrev_b32   v7, 5, v7
        s_add_u32       s0, s12, 24
        v_add_i32       v7, vcc, s0, v7
        tbuffer_load_format_x v8, v8, s[16:19], 0 offen offset:24 format:[32,float]
        tbuffer_load_format_x v7, v7, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v11, v8
        v_add_i32       v8, vcc, -4, v11
        v_add_i32       v6, vcc, 0x100, v6
        s_movk_i32      s0, 0x80
        s_waitcnt       vmcnt(0)
        ds_write_b32    v8, v7
        v_add_i32       v3, vcc, 0x400, v3
        v_add_i32       v11, vcc, 0x800, v11
        v_cmp_gt_u32    vcc, s0, v6
        s_mov_b64       s[20:21], exec
        s_andn2_b64     exec, s[20:21], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1620_11
        s_and_b64       exec, s[20:21], s[14:15]
        s_branch        .L1448_11
.L1620_11:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        s_movk_i32      s0, 0x100
        v_cmp_gt_u32    vcc, s0, v0
        s_and_saveexec_b64 s[8:9], vcc
        s_cbranch_execz .L1836_11
        s_load_dwordx4  s[16:19], s[2:3], 0x58
        s_mov_b64       s[10:11], exec
        s_mov_b64       s[14:15], exec
        v_mov_b32       v4, v0
.L1664_11:
        ds_read_b32     v5, v2
        s_waitcnt       lgkmcnt(0)
        v_lshrrev_b32   v6, 20, v5
        s_movk_i32      s0, 0x2ac
        v_bfe_u32       v7, v5, 10, 10
        v_mul_lo_i32    v6, v6, s0
        v_add_i32       v7, vcc, v7, v6
        v_and_b32       v5, 0x3ff, v5
        v_lshlrev_b32   v7, 5, v7
        v_add_i32       v5, vcc, v6, v5
        v_add_i32       v6, vcc, s1, v7
        v_lshlrev_b32   v5, 5, v5
        s_add_u32       s0, s1, 24
        v_add_i32       v5, vcc, s0, v5
        tbuffer_load_format_x v6, v6, s[16:19], 0 offen offset:24 format:[32,float]
        tbuffer_load_format_x v5, v5, s[16:19], 0 offen format:[32,float]
        s_waitcnt       vmcnt(1)
        ds_write_b32    v12, v6
        v_add_i32       v6, vcc, -4, v12
        v_add_i32       v4, vcc, 0x100, v4
        s_movk_i32      s0, 0x100
        s_waitcnt       vmcnt(0)
        ds_write_b32    v6, v5
        v_add_i32       v2, vcc, 0x400, v2
        v_add_i32       v12, vcc, 0x800, v12
        v_cmp_gt_u32    vcc, s0, v4
        s_mov_b64       s[20:21], exec
        s_andn2_b64     exec, s[20:21], vcc
        s_andn2_b64     s[14:15], s[14:15], exec
        s_cbranch_scc0  .L1836_11
        s_and_b64       exec, s[20:21], s[14:15]
        s_branch        .L1664_11
.L1836_11:
        s_mov_b64       exec, s[8:9]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_add_i32       v2, vcc, 3, v0
        s_movk_i32      s0, 0x1fd
        v_cmp_ge_u32    vcc, s0, v2
        s_and_saveexec_b64 s[0:1], vcc
        v_mov_b32       v3, 0
        s_cbranch_execz .L2012_11
        v_add_i32       v4, vcc, 12, v1
        ds_read_b32     v3, v3 offset:2044
        s_mov_b64       s[8:9], exec
        s_mov_b64       s[10:11], exec
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L1920_11:
        ds_read_b32     v5, v4
        s_waitcnt       lgkmcnt(0)
        v_cmp_eq_i32    vcc, v3, v5
        s_and_saveexec_b64 s[14:15], vcc
        v_mov_b32       v5, 0
        s_cbranch_execz .L1960_11
        v_mov_b32       v6, -1
        ds_inc_u32      v5, v6 offset:3072
.L1960_11:
        s_mov_b64       exec, s[14:15]
        v_add_i32       v4, vcc, 0x400, v4
        v_add_i32       v2, vcc, 0x100, v2
        s_movk_i32      s12, 0x1fe
        v_cmp_gt_u32    vcc, s12, v2
        s_mov_b64       s[14:15], exec
        s_andn2_b64     exec, s[14:15], vcc
        s_andn2_b64     s[10:11], s[10:11], exec
        s_cbranch_scc0  .L2012_11
        s_and_b64       exec, s[14:15], s[10:11]
        s_branch        .L1920_11
.L2012_11:
        s_mov_b64       exec, s[0:1]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v2, 0
        ds_read_b32     v2, v2 offset:3072
        s_waitcnt       lgkmcnt(0)
        v_or_b32        v2, v0, v2
        v_cmp_eq_i32    vcc, 0, v2
        s_and_saveexec_b64 s[0:1], vcc
        s_cbranch_execz .L2096_11
        s_load_dwordx4  s[8:11], s[2:3], 0x60
        v_mov_b32       v2, s13
        v_mov_b32       v3, -1
        v_mov_b32       v4, 0
        s_waitcnt       lgkmcnt(0)
        buffer_atomic_inc v3, v2, s[8:11], 0 offen glc
        s_waitcnt       vmcnt(0)
        ds_write_b32    v4, v3 offset:3088
.L2096_11:
        s_mov_b64       exec, s[0:1]
        s_waitcnt       lgkmcnt(0)
        s_barrier
        v_mov_b32       v2, 0xc00
        s_waitcnt       expcnt(0)
        ds_read2_b32    v[2:3], v2 offset1:4
        s_waitcnt       lgkmcnt(0)
        v_cmp_eq_i32    s[0:1], v2, 0
        v_cmp_gt_u32    vcc, 11, v3
        s_and_b64       vcc, s[0:1], vcc
        s_and_b64       vcc, vcc, exec
        s_cbranch_vccz  .L2324_11
        s_movk_i32      s0, 0x1ff
        v_cmp_ge_u32    vcc, s0, v0
        s_and_saveexec_b64 s[0:1], vcc
        v_add_i32       v2, vcc, s13, v1
        s_cbranch_execz .L2292_11
        s_load_dwordx4  s[8:11], s[2:3], 0x60
        s_mov_b64       s[14:15], exec
        s_mov_b64       s[16:17], exec
        v_mov_b32       v4, 0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
        s_nop           0x0
.L2208_11:
        s_waitcnt       expcnt(0)
        v_add_i32       v5, vcc, v1, v4
        v_lshlrev_b32   v6, 11, v3
        ds_read_b32     v5, v5
        v_add_i32       v6, vcc, v4, v6
        v_add_i32       v6, vcc, v2, v6
        v_add_i32       v0, vcc, 0x100, v0
        s_movk_i32      s12, 0x1ff
        s_waitcnt       lgkmcnt(0)
        tbuffer_store_format_x v5, v6, s[8:11], 0 offen offset:20 format:[32,float]
        v_cmp_lt_u32    vcc, s12, v0
        s_and_saveexec_b64 s[18:19], vcc
        s_andn2_b64     s[16:17], s[16:17], exec
        s_cbranch_scc0  .L2292_11
        s_and_b64       exec, s[18:19], s[16:17]
        v_add_i32       v4, vcc, 0x400, v4
        s_branch        .L2208_11
.L2292_11:
        s_and_b64       exec, s[0:1], s[6:7]
        v_add_i32       v0, vcc, s13, v3
        s_cbranch_execz .L2324_11
        s_load_dwordx4  s[8:11], s[2:3], 0x60
        v_mov_b32       v1, 1
        s_waitcnt       lgkmcnt(0)
        buffer_store_byte v1, v0, s[8:11], 0 offen offset:8 glc
.L2324_11:
        s_barrier
.L2328_11:
        s_endpgm
