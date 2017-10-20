// Gateless Gate, a Zcash miner
// Copyright 2016-2017 zawawa @ bitcointalk.org
//
// The initial version of this software was based on:
// SILENTARMY v5
// The MIT License (MIT) Copyright (c) 2016 Marc Bevand, Genoil, eXtremal
//
// This program is free software : you can redistribute it and / or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#ifndef PARAM_N
#define PARAM_N				   200
#endif
#ifndef PARAM_K
#define PARAM_K			       9
#endif

#include "../kernel/equihash-param.h"

#pragma OPENCL EXTENSION cl_khr_global_int32_base_atomics : enable
#ifdef AMD
#pragma OPENCL EXTENSION cl_amd_vec3 : enable
#endif
//#pragma OPENCL EXTENSION cl_ext_atomic_counters_32 : enable



/////////////////
// HASH TABLES //
/////////////////

/*
** With the new hash tables, each slot has this layout (length in bytes in parens):
**
** round 0, table 0: i(4) pad(0) Xi(24) pad(4)
** round 1, table 1: i(4) pad(3) Xi(20) pad(5)
** round 2, table 2: i(4) pad(0) Xi(19) pad(9)
** round 3, table 3: i(4) pad(3) Xi(15) pad(10)
** round 4, table 4: i(4) pad(0) Xi(14) pad(14)
** round 5, table 5: i(4) pad(3) Xi(10) pad(15)
** round 6, table 6: i(4) pad(0) Xi( 9) pad(19)
** round 7, table 7: i(4) pad(3) Xi( 5) pad(20)
** round 8, table 8: i(4) pad(0) Xi( 4) pad(24)
*/

typedef union {
    struct {
        uint xi[7];
        uint padding;
    } slot;
    uint8 ui8;
    uint4 ui4[2];
    uint2 ui2[4];
    uint  ui[8];
#ifdef AMD
    ulong3 ul3;
    uint3 ui3[2];
#endif
} slot_t;

typedef __global slot_t *global_pointer_to_slot_t;



/*
** OBSOLETE
** If xi0,xi1,xi2,xi3 are stored consecutively in little endian then they
** represent (hex notation, group of 5 hex digits are a group of PREFIX bits):
**   aa aa ab bb bb cc cc cd dd...  [round 0]
**         --------------------
**      ...ab bb bb cc cc cd dd...  [odd round]
**               --------------
**               ...cc cc cd dd...  [next even round]
**                        -----
** Bytes underlined are going to be stored in the slot. Preceding bytes
** (and possibly part of the underlined bytes, depending on NR_ROWS_LOG) are
** used to compute the row number.
**
** Round 0: xi0,xi1,xi2,xi3 is a 25-byte Xi (xi3: only the low byte matter)
** Round 1: xi0,xi1,xi2 is a 23-byte Xi (incl. the colliding PREFIX nibble)
** TODO: update lines below with padding nibbles
** Round 2: xi0,xi1,xi2 is a 20-byte Xi (xi2: only the low 4 bytes matter)
** Round 3: xi0,xi1,xi2 is a 17.5-byte Xi (xi2: only the low 1.5 bytes matter)
** Round 4: xi0,xi1 is a 15-byte Xi (xi1: only the low 7 bytes matter)
** Round 5: xi0,xi1 is a 12.5-byte Xi (xi1: only the low 4.5 bytes matter)
** Round 6: xi0,xi1 is a 10-byte Xi (xi1: only the low 2 bytes matter)
** Round 7: xi0 is a 7.5-byte Xi (xi0: only the low 7.5 bytes matter)
** Round 8: xi0 is a 5-byte Xi (xi0: only the low 5 bytes matter)
**
** Return 0 if successfully stored, or 1 if the row overflowed.
*/

__global char *get_slot_ptr(__global char *ht, uint round, uint row, uint slot)
{
#if 0
    if (round <= 5) {
        return ht + (slot >> 4) * _NR_ROWS(round) * 16            * _SLOT_LEN(round)
                  +               row             * 16            * _SLOT_LEN(round)
                  +                                 (slot & 0xf)  * _SLOT_LEN(round);
    } else if (round <= 7) {
        return ht + (slot >> 5) * _NR_ROWS(round) * 32            * _SLOT_LEN(round)
                  +               row             * 32            * _SLOT_LEN(round)
                  +                                 (slot & 0x1f) * _SLOT_LEN(round);
    } else {
        return ht + (slot >> 6) * _NR_ROWS(round) * 64            * _SLOT_LEN(round)
                  +               row             * 64            * _SLOT_LEN(round)
                  +                                 (slot & 0x3f) * _SLOT_LEN(round);
    }
#else
        return ht + (row * _NR_SLOTS(round) + slot) * _SLOT_LEN(round);
#endif
}

__global uint *get_xi_ptr(__global char *ht, uint round, uint row, uint slot)
{
    return (__global uint *)get_slot_ptr(ht, round, row, slot);
}

__global uint *get_ref_ptr(__global char *ht, uint round, uint row, uint slot)
{
    return get_xi_ptr(ht, round, row, slot) + UINTS_IN_XI(round);
}

uint get_row(uint round, uint xi0)
{
    uint           row = 0;

    if (_NR_ROWS_LOG(round) == 12) {
        if (!(round % 2))
            row = (xi0 & 0xfff);
        else
            row = ((xi0 & 0x0f0f00) >> 8) | ((xi0 & 0xf0000000) >> 24);
    } else if (_NR_ROWS_LOG(round) == 13) {
        if (!(round % 2))
            row = (xi0 & 0x1fff);
        else
            row = ((xi0 & 0x1f0f00) >> 8) | ((xi0 & 0xf0000000) >> 24);
    }

    return row;
}

void get_row_counters_index(uint *row_counter_index, uint *row_counter_offset, uint row)
{
#ifdef OPTIM_FAST_INTEGER_DIVISION
    if (ROWS_PER_UINT == 3) {
        uint r = (0x55555555 * row + (row >> 1) - (row >> 3)) >> 30;
        *row_counter_index = (row - r) * 0xAAAAAAAB;
        *row_counter_offset = BITS_PER_ROW * r;
    } else if (ROWS_PER_UINT == 6) {
        uint r = (0x55555555 * row + (row >> 1) - (row >> 3)) >> 29;
        *row_counter_index = (row - r) * 0xAAAAAAAB * 2;
        *row_counter_offset = BITS_PER_ROW * r;
    } else
#endif
    {
        *row_counter_index = row / ROWS_PER_UINT;
        *row_counter_offset = BITS_PER_ROW * (row % ROWS_PER_UINT);
    }
}

uint get_nr_slots(uint device_thread, uint round, __global uint *row_counters, uint row_index)
{
    uint row_counter_index, row_counter_offset, nr_slots;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row_index);
    nr_slots = (row_counters[row_counter_index] >> row_counter_offset) & ROW_MASK;
    nr_slots = min(nr_slots, (uint)_NR_SLOTS(round)); // handle possible overflow in last round
    return nr_slots;
}

#ifndef GDS_SEGMENT_SIZE
#define GDS_SEGMENT_SIZE 0
#endif

uint inc_gds_row_counter(uint device_thread, uint round, __global uint *row_counters, uint row)
{
    uint row_counter_index, row_counter_offset;
    get_row_counters_index(&row_counter_index, &row_counter_offset, row);

    uint nr_slots;
    if (row_counter_index < (GDS_SEGMENT_SIZE >> 2)) {
        __asm volatile
             ("s_mov_b32   m0, %[gds_segment_size]\n"
              "s_nop       0\n"
              "ds_add_rtn_u32 %[nr_slots], %[shifted_row_counter_index], %[shifted_row_counter_offset] gds\n"
              //"s_waitcnt   lgkmcnt(0) expcnt(0)\n"
              "s_waitcnt   lgkmcnt(0)\n"
              : [nr_slots] "=v" (nr_slots)
              : [shifted_row_counter_index] "v" (row_counter_index << 2),
                [shifted_row_counter_offset] "v" (1U << row_counter_offset),
                [gds_segment_size] "s" (GDS_SEGMENT_SIZE)
              : "m0", "memory");
    } else {
        nr_slots = atomic_add(row_counters + row_counter_index, 1U << row_counter_offset);
    }

    nr_slots = (nr_slots >> row_counter_offset) & ROW_MASK;
/*
#ifndef OPTIM_IGNORE_ROW_COUNTER_OVERFLOWS
    if (nr_slots >= _NR_SLOTS(round)) {
        // avoid overflows
        atomic_sub(row_counters + row_counter_index, 1 << row_counter_offset);
    }
#endif
*/
    return nr_slots;
}

/*
** Reset counters in a hash table.
*/

__kernel
void kernel_init_ht(uint device_thread, uint round, __global uint *hash_table, __global uint *row_counters_src, __global uint *row_counters_dst, __global sols_t *sols, __global potential_sols_t *potential_sols, __global uint *sync_flags)
{
    if (get_global_id(0) < (_NR_ROWS(round) + ROWS_PER_UINT - 1) / ROWS_PER_UINT) {
        uint gds_index = (get_global_id(0) << 2) ;
        if (gds_index < GDS_SEGMENT_SIZE && gds_index < ROW_COUNTERS_SIZE) {
            uint gds_value;
            __asm volatile
                 ("s_mov_b32   m0, %[gds_segment_size]\n"
                  "s_nop       0\n"
                  "ds_read_b32 %0, %1 gds\n"
                  //"s_waitcnt lgkmcnt(0) expcnt(0)\n"
                  "ds_write_b32 %1, %2 gds\n"
                  "s_waitcnt lgkmcnt(0) expcnt(0)\n"
                  : "=v" (gds_value)
                  : "v" (gds_index), "v" (0), [gds_segment_size] "s" (GDS_SEGMENT_SIZE)
                  : "m0", "memory");
            row_counters_src[get_global_id(0)] = gds_value;
        }
        if (round <= 8)
            row_counters_dst[get_global_id(0)] = 0;
    }
    if (round == 0 && !get_global_id(0))
        sols->nr = sols->likely_invalids = potential_sols->nr = 0;
}



/////////////
// ROUND 0 //
/////////////

__constant ulong blake_iv[] =
{
    0x6a09e667f3bcc908, 0xbb67ae8584caa73b,
    0x3c6ef372fe94f82b, 0xa54ff53a5f1d36f1,
    0x510e527fade682d1, 0x9b05688c2b3e6c1f,
    0x1f83d9abfb41bd6b, 0x5be0cd19137e2179,
};

#define mix_0_y(va, vb, vc, vd, vy) \
    __asm("v_add_u32_e32  %[a].x, vcc, %[a].x, %[b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[b].y, vcc\n"\
          "v_xor_b32_e32  %[temp_d].y, %[d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].x, %[d].y, %[a].y\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[temp_d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[temp_d].y, vcc\n"\
          "v_xor_b32_e32  %[b].x, %[b].x, %[c].x\n"\
          "v_xor_b32_e32  %[b].y, %[b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[temp_b].x, %[b].y, %[b].x, 24\n"\
          "v_alignbit_b32_e32 %[temp_b].y, %[b].x, %[b].y, 24\n"\
          "v_add_u32_e32  %[a].x, vcc, %[a].x, %[temp_b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[temp_b].y, vcc\n"\
          "v_add_u32_e32 %[a].y, vcc, %[a].y, %[y].y\n"\
          "v_xor_b32_e32  %[temp_d].x, %[temp_d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].y, %[temp_d].y, %[a].y\n"\
          "v_alignbit_b32_e32 %[d].x, %[temp_d].y, %[temp_d].x, 16\n"\
          "v_alignbit_b32_e32 %[d].y, %[temp_d].x, %[temp_d].y, 16\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[d].y, vcc\n"\
          "v_xor_b32_e32  %[temp_b].x, %[temp_b].x, %[c].x\n"\
          "v_xor_b32_e32  %[temp_b].y, %[temp_b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[b].y, %[temp_b].y, %[temp_b].x, 31\n"\
          "v_alignbit_b32_e32 %[b].x, %[temp_b].x, %[temp_b].y, 31\n"\
          : [a] "=&v" (va),\
            [b] "=&v" (vb),\
            [c] "=&v" (vc),\
            [d] "=&v" (vd),\
            [temp_b] "=&v" (temp_vb),\
            [temp_d] "=&v" (temp_vd)\
          : [a] "0"   (va),\
            [b] "1"   (vb),\
            [c] "2"   (vc),\
            [d] "3"   (vd),\
            [y] "v"   (vy)\
          : "vcc");

#define mix_x_0(va, vb, vc, vd, vx) \
    __asm("v_add_u32_e32  %[a].x, vcc, %[a].x, %[b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[b].y, vcc\n"\
          "v_add_u32_e32 %[a].y, vcc, %[a].y, %[x].y\n"\
          "v_xor_b32_e32  %[temp_d].y, %[d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].x, %[d].y, %[a].y\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[temp_d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[temp_d].y, vcc\n"\
          "v_xor_b32_e32  %[b].x, %[b].x, %[c].x\n"\
          "v_xor_b32_e32  %[b].y, %[b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[temp_b].x, %[b].y, %[b].x, 24\n"\
          "v_alignbit_b32_e32 %[temp_b].y, %[b].x, %[b].y, 24\n"\
          "v_add_u32_e32  %[a].x, vcc, %[a].x, %[temp_b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[temp_b].y, vcc\n"\
          "v_xor_b32_e32  %[temp_d].x, %[temp_d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].y, %[temp_d].y, %[a].y\n"\
          "v_alignbit_b32_e32 %[d].x, %[temp_d].y, %[temp_d].x, 16\n"\
          "v_alignbit_b32_e32 %[d].y, %[temp_d].x, %[temp_d].y, 16\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[d].y, vcc\n"\
          "v_xor_b32_e32  %[temp_b].x, %[temp_b].x, %[c].x\n"\
          "v_xor_b32_e32  %[temp_b].y, %[temp_b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[b].y, %[temp_b].y, %[temp_b].x, 31\n"\
          "v_alignbit_b32_e32 %[b].x, %[temp_b].x, %[temp_b].y, 31\n"\
          : [a] "=&v" (va),\
            [b] "=&v" (vb),\
            [c] "=&v" (vc),\
            [d] "=&v" (vd),\
            [temp_b] "=&v" (temp_vb),\
            [temp_d] "=&v" (temp_vd)\
          : [a] "0"   (va),\
            [b] "1"   (vb),\
            [c] "2"   (vc),\
            [d] "3"   (vd),\
            [x] "v"   (vx)\
          : "vcc");

#define mix_0_0(va, vb, vc, vd) \
    __asm("v_add_u32_e32  %[a].x, vcc, %[a].x, %[b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[b].y, vcc\n"\
          "v_xor_b32_e32  %[temp_d].y, %[d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].x, %[d].y, %[a].y\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[temp_d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[temp_d].y, vcc\n"\
          "v_xor_b32_e32  %[b].x, %[b].x, %[c].x\n"\
          "v_xor_b32_e32  %[b].y, %[b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[temp_b].x, %[b].y, %[b].x, 24\n"\
          "v_alignbit_b32_e32 %[temp_b].y, %[b].x, %[b].y, 24\n"\
          "v_add_u32_e32  %[a].x, vcc, %[a].x, %[temp_b].x\n"\
          "v_addc_u32_e32 %[a].y, vcc, %[a].y, %[temp_b].y, vcc\n"\
          "v_xor_b32_e32  %[temp_d].x, %[temp_d].x, %[a].x\n"\
          "v_xor_b32_e32  %[temp_d].y, %[temp_d].y, %[a].y\n"\
          "v_alignbit_b32_e32 %[d].x, %[temp_d].y, %[temp_d].x, 16\n"\
          "v_alignbit_b32_e32 %[d].y, %[temp_d].x, %[temp_d].y, 16\n"\
          "v_add_u32_e32  %[c].x, vcc, %[c].x, %[d].x\n"\
          "v_addc_u32_e32 %[c].y, vcc, %[c].y, %[d].y, vcc\n"\
          "v_xor_b32_e32  %[temp_b].x, %[temp_b].x, %[c].x\n"\
          "v_xor_b32_e32  %[temp_b].y, %[temp_b].y, %[c].y\n"\
          "v_alignbit_b32_e32 %[b].y, %[temp_b].y, %[temp_b].x, 31\n"\
          "v_alignbit_b32_e32 %[b].x, %[temp_b].x, %[temp_b].y, 31\n"\
          : [a] "=&v" (va),\
            [b] "=&v" (vb),\
            [c] "=&v" (vc),\
            [d] "=&v" (vd),\
            [temp_b] "=&v" (temp_vb),\
            [temp_d] "=&v" (temp_vd)\
          : [a] "0"   (va),\
            [b] "1"   (vb),\
            [c] "2"   (vc),\
            [d] "3"   (vd)\
          : "vcc");

/*
** Execute round 0 (blake).
*/

__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_ROUND0, 1, 1)))
void kernel_round0(uint device_thread, __constant ulong *blake_state, __global char *ht,
    __global uint *row_counters, __global uint *sync_flags)
{
    ulong               v[16], temp_va, temp_vb, temp_vd;
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;
    slot_t slot;
    ulong               h[7];

    uint input = get_global_id(0);

    // shift "i" to occupy the high 32 bits of the second ulong word in the
    // message block
    ulong word1 = (ulong)input << 32;
    // init vector v
    v[0] = blake_state[0];
    v[1] = blake_state[1];
    v[2] = blake_state[2];
    v[3] = blake_state[3];
    v[4] = blake_state[4];
    v[5] = blake_state[5];
    v[6] = blake_state[6];
    v[7] = blake_state[7];
    v[8] = blake_iv[0];
    v[9] = blake_iv[1];
    v[10] = blake_iv[2];
    v[11] = blake_iv[3];
    v[12] = blake_iv[4];
    v[13] = blake_iv[5];
    v[14] = blake_iv[6];
    v[15] = blake_iv[7];
    // mix in length of data
    v[12] ^= ZCASH_BLOCK_HEADER_LEN + 4 /* length of "i" */;
    // last block
    v[14] ^= (ulong)-1;

    mix_0_y(v[0], v[4], v[8], v[12], word1);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_x_0(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);
    
    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_y(v[2], v[7], v[8], v[13], word1);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_y(v[1], v[5], v[9], v[13], word1);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_y(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_x_0(v[3], v[4], v[9], v[14], word1);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_x_0(v[1], v[5], v[9], v[13], word1);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_y(v[2], v[6], v[10], v[14], word1);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_x_0(v[2], v[7], v[8], v[13], word1);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_x_0(v[3], v[7], v[11], v[15], word1);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_y(v[0], v[4], v[8], v[12], word1);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_0_0(v[0], v[5], v[10], v[15]);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);

    mix_0_0(v[0], v[4], v[8], v[12]);
    mix_0_0(v[1], v[5], v[9], v[13]);
    mix_0_0(v[2], v[6], v[10], v[14]);
    mix_0_0(v[3], v[7], v[11], v[15]);
    mix_x_0(v[0], v[5], v[10], v[15], word1);
    mix_0_0(v[1], v[6], v[11], v[12]);
    mix_0_0(v[2], v[7], v[8], v[13]);
    mix_0_0(v[3], v[4], v[9], v[14]);
    
    // compress v into the blake state; this produces the 50-byte hash
    // (two Xi values)
    h[0] = blake_state[0] ^ v[0] ^ v[8];
    h[1] = blake_state[1] ^ v[1] ^ v[9];
    h[2] = blake_state[2] ^ v[2] ^ v[10];
    h[3] = blake_state[3] ^ v[3] ^ v[11];
    h[4] = blake_state[4] ^ v[4] ^ v[12];
    h[5] = blake_state[5] ^ v[5] ^ v[13];
    h[6] = (blake_state[6] ^ v[6] ^ v[14]) & 0xffff;

    // store the two Xi values in the hash table;

    uint new_row = get_row(0, h[0]);
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht, 0, _NR_ROWS(0) - 1, _NR_SLOTS(0) - 1);
    uint nr_slots = inc_gds_row_counter(device_thread, 0, row_counters, new_row);
    if (nr_slots < _NR_SLOTS(0))
        p = (__global uint4 *)get_slot_ptr(ht, 0, new_row, nr_slots);
        
    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"
          "ds_swizzle_b32 %[xi6], %[ref] offset:0x041f\n"
	        
          "v_alignbit_b32_e32 %[xi4], %[h2].y, %[h2].x, 8\n"
          "v_alignbit_b32_e32 %[xi5], %[h3].x, %[h2].y, 8\n"
          
          "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
          "ds_swizzle_b32 %[xi5], %[xi5] offset:0x041f\n"
	      
	      "v_alignbit_b32_e32 %[xi0], %[h0].y, %[h0].x, 8\n"
          "v_alignbit_b32_e32 %[xi1], %[h1].x, %[h0].y, 8\n"
          "v_alignbit_b32_e32 %[xi2], %[h1].y, %[h1].x, 8\n"
          "v_alignbit_b32_e32 %[xi3], %[h2].x, %[h1].y, 8\n"
          "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
	        
	        "s_waitcnt lgkmcnt(0)\n"
	          
            "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
            "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
            "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	        "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].z, %[xi6], %[xi2], vcc\n"
            "v_cndmask_b32_e32 %[write_buffer1].z, %[xi2], %[xi6], vcc\n"

	        "flat_store_dwordx4 %[q], %[write_buffer0]\n"
            "flat_store_dwordx4 %[qq], %[write_buffer1]\n"

	        "s_waitcnt expcnt(0)\n"
	        
            : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi0] "=&v" (xi0),
            [xi1] "=&v" (xi1),
            [xi2] "=&v" (xi2),
            [xi3] "=&v" (xi3),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5),
            [xi6] "=&v" (xi6)
                
            : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
              [p] "v" (p), 
              [pp] "2" (pp), 
              [h0] "v" (h[0]),
              [h1] "v" (h[1]),
              [h2] "v" (h[2]),
              [h3] "v" (h[3]),
              [ref] "v" (input * 2 + 0)
                
            : "memory", "vcc");

    new_row = get_row(0, (uint)h[3] >> 8);
    p = (__global uint4 *)get_slot_ptr(ht, 0, _NR_ROWS(0) - 1, _NR_SLOTS(0) - 1);
    nr_slots = inc_gds_row_counter(device_thread, 0, row_counters, new_row);
    if (nr_slots < _NR_SLOTS(0))
        p = (__global uint4 *)get_slot_ptr(ht, 0, new_row, nr_slots);

    pp = p + 1;
    __asm(  "ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
            "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"
	        "ds_swizzle_b32 %[xi6], %[ref] offset:0x041f\n"

            "v_alignbit_b32 %[xi4], %[h5].y, %[h5].x, 16\n"
            "v_alignbit_b32 %[xi5], %[h6].x, %[h5].y, 16\n"

            "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
            "ds_swizzle_b32 %[xi5], %[xi5] offset:0x041f\n"

            "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	        "v_alignbit_b32 %[xi0], %[h3].y, %[h3].x, 16\n"
            "v_alignbit_b32 %[xi1], %[h4].x, %[h3].y, 16\n"
            "v_alignbit_b32 %[xi2], %[h4].y, %[h4].x, 16\n"
            "v_alignbit_b32 %[xi3], %[h5].x, %[h4].y, 16\n"
	        "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	        "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
              
	        "s_waitcnt lgkmcnt(0)\n"
	          
            "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
            "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
            "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	        "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"
	        "v_cndmask_b32_e32 %[write_buffer0].z, %[xi6], %[xi2], vcc\n"
            "v_cndmask_b32_e32 %[write_buffer1].z, %[xi2], %[xi6], vcc\n"

	        "flat_store_dwordx4 %[q], %[write_buffer0]\n"
            "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
            
	        "s_waitcnt expcnt(0)\n"
	          
            : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi0] "=&v" (xi0),
            [xi1] "=&v" (xi1),
            [xi2] "=&v" (xi2),
            [xi3] "=&v" (xi3),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5),
            [xi6] "=&v" (xi6)
                
            : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp),
            [h3] "v" (h[3]),
            [h4] "v" (h[4]),
            [h5] "v" (h[5]),
            [h6] "v" (h[6]),
            [ref] "v" (input * 2 + 1)
                
            : "memory", "vcc");
}

/*
** XOR a pair of Xi values computed at "round - 1" and store the result in the
** hash table being built for "round". Note that when building the table for
** even rounds we need to skip 1 padding byte present in the "round - 1" table
** (the "0xAB" byte mentioned in the description at the top of this file.) But
** also note we can't load data directly past this byte because this would
** cause an unaligned memory access which is undefined per the OpenCL spec.
**
** Return 0 if successfully stored, or 1 if the row overflowed.
*/

void parallel_xor_and_store_round2(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters)
{
    uint new_row;
    uint new_slot_index;
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, _NR_ROWS(round) - 1, _NR_SLOTS(round) - 1);
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        xi2 = *(ai += _NR_SLOTS(round - 1));
        xi3 = *(ai += _NR_SLOTS(round - 1));
        xi4 = *(ai += _NR_SLOTS(round - 1));
        xi5 = *(ai +  _NR_SLOTS(round - 1));
        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        xi2 ^= *(bi += _NR_SLOTS(round - 1));
        xi3 ^= *(bi += _NR_SLOTS(round - 1));
        xi4 ^= *(bi += _NR_SLOTS(round - 1));
        xi5 ^= *(bi +  _NR_SLOTS(round - 1));

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_row = get_row(round, (xi0 >> 24) | (xi1 << (32 - 24)));
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
            p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        }
    }

    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"
          "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
          "ds_swizzle_b32 %[xi5], %[xi5] offset:0x041f\n"
          
          "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	      "v_mov_b32_e32     %[write_buffer0].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "v_mov_b32_e32     %[write_buffer1].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"

          "s_waitcnt lgkmcnt(0)\n"
	      
	      "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
	      "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
          "flat_store_dwordx4 %[q], %[write_buffer0]\n"
	      
	      "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	      "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"
	      "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
          
	      "s_waitcnt expcnt(0)\n"
	          
          : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5)
            
          : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp), 
            [xi0] "v" (xi1),
            [xi1] "v" (xi2),
            [xi2] "v" (xi3),
            [xi3] "v" (xi4),
            [xi4] "6" (xi5),
            [xi5] "7" (ENCODE_INPUTS(round - 1, row, slot_a, slot_b))
            
          : "memory", "vcc");
}

void parallel_xor_and_store_round4(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi, __global uint *row_counters)
{
    uint new_row;
    uint new_slot_index;
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, _NR_ROWS(round) - 1, _NR_SLOTS(round) - 1);
    uint xi0, xi1, xi2, xi3, xi4, xi5;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        xi2 = *(ai += _NR_SLOTS(round - 1));
        xi3 = *(ai += _NR_SLOTS(round - 1));
        xi4 = *(ai +=  _NR_SLOTS(round - 1));
        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        xi2 ^= *(bi += _NR_SLOTS(round - 1));
        xi3 ^= *(bi += _NR_SLOTS(round - 1));
        xi4 ^= *(bi += _NR_SLOTS(round - 1));

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_row = get_row(round, (xi0 >> 24) | (xi1 << (32 - 24)));
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
            p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        }
    }

    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("v_cmp_eq_u32_e32  vcc, 1, %[second_thread]\n"
          "ds_swizzle_b32    %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32    %[pp].y, %[pp].y offset:0x041f\n"
          "ds_swizzle_b32    %[xi4], %[xi4] offset:0x041f\n"
          
	      "v_mov_b32_e32     %[write_buffer0].y, %[xi1]\n"
	      "v_mov_b32_e32     %[write_buffer0].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "v_mov_b32_e32     %[write_buffer1].y, %[xi1]\n"
	      "v_mov_b32_e32     %[write_buffer1].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
          
	      "s_waitcnt lgkmcnt(0)\n"
        
	      "v_cndmask_b32     %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	      "v_cndmask_b32     %[q].x, %[pp].x, %[p].x, vcc\n"
	      "v_cndmask_b32     %[q].y, %[pp].y, %[p].y, vcc\n"
          "flat_store_dwordx4 %[q], %[write_buffer0]\n"
	      
	      "v_cndmask_b32     %[qq].x, %[p].x, %[pp].x, vcc\n"
	      "v_cndmask_b32     %[qq].y, %[p].y, %[pp].y, vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	      "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
          
	      "s_waitcnt expcnt(0)\n"
	        
          : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5)
            
          : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp), 
            [xi0] "v" (xi1),
            [xi1] "v" (xi2),
            [xi2] "v" (xi3),
            [xi3] "v" (xi4),
            [xi4] "6" (ENCODE_INPUTS(round - 1, row, slot_a, slot_b))
            
          : "memory", "vcc");
}

void parallel_xor_and_store_round5(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters)
{
    uint new_row;
    uint new_slot_index;
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, _NR_ROWS(round) - 1, _NR_SLOTS(round) - 1);
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        xi2 = *(ai += _NR_SLOTS(round - 1));
        xi3 = *(ai += _NR_SLOTS(round - 1));
        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        xi2 ^= *(bi += _NR_SLOTS(round - 1));
        xi3 ^= *(bi += _NR_SLOTS(round - 1));

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_row = get_row(round, xi0);
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
            p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        }
    }

    __asm("v_alignbit_b32_e32 %0, %2, %1, 8" : "=&v" (xi0) : "0" (xi0), "v" (xi1));
    __asm("v_alignbit_b32_e32 %0, %2, %1, 8" : "=&v" (xi1) : "0" (xi1), "v" (xi2));
    __asm("v_alignbit_b32_e32 %0, %2, %1, 8" : "=&v" (xi2) : "0" (xi2), "v" (xi3));
    __asm("v_alignbit_b32_e32 %0, %2, %1, 8" : "=&v" (xi3) : "0" (xi3), "v" (xi4));
    xi4 = ENCODE_INPUTS(round - 1, row, slot_a, slot_b);
    
    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"
          "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	      "s_waitcnt lgkmcnt(0)\n"
	      
          "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
          "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
          "ds_swizzle_b32 %[xi5], %[xi5] offset:0x041f\n"
	      "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
          "ds_swizzle_b32 %[xi6], %[xi6] offset:0x041f\n"
	      "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	      "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
          
	      "s_waitcnt lgkmcnt(2)\n"
	      "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	      "s_waitcnt lgkmcnt(1)\n"
	      "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"
	      "s_waitcnt lgkmcnt(0)\n"

	      "v_cndmask_b32_e32 %[write_buffer0].z, %[xi6], %[xi2], vcc\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "flat_store_dwordx4 %[q], %[write_buffer0]\n"
	      
          "v_cndmask_b32_e32 %[write_buffer1].z, %[xi2], %[xi6], vcc\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
          "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
          
	        "s_waitcnt expcnt(0)\n"
            
          : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5),
            [xi6] "=&v" (xi6)
            
          : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp), 
            [xi0] "v" (xi0),
            [xi1] "v" (xi1),
            [xi2] "v" (xi2),
            [xi3] "v" (xi3),
            [xi4] "6" (xi4),
            [xi5] "7" (xi5),
            [xi6] "8" (xi6)
            
          : "memory", "vcc");
}

void parallel_xor_and_store_round1(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters)
{
    uint new_row;
    uint new_slot_index;
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, _NR_ROWS(round) - 1, _NR_SLOTS(round) - 1);
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        xi2 = *(ai += _NR_SLOTS(round - 1));
        xi3 = *(ai += _NR_SLOTS(round - 1));
        xi4 = *(ai += _NR_SLOTS(round - 1));
        xi5 = *(ai +  _NR_SLOTS(round - 1));
        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        xi2 ^= *(bi += _NR_SLOTS(round - 1));
        xi3 ^= *(bi += _NR_SLOTS(round - 1));
        xi4 ^= *(bi += _NR_SLOTS(round - 1));
        xi5 ^= *(bi +  _NR_SLOTS(round - 1));

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_row = get_row(round, xi0);
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
            p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        }
    }

    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"
          "ds_swizzle_b32 %[xi6], %[ref] offset:0x041f\n"
          
          "v_alignbit_b32_e32 %[xi0], %[xi1], %[xi0], 8\n"
          "v_alignbit_b32_e32 %[xi1], %[xi2], %[xi1], 8\n"
          "v_alignbit_b32_e32 %[xi2], %[xi3], %[xi2], 8\n"
          "v_alignbit_b32_e32 %[xi3], %[xi4], %[xi3], 8\n"
          "v_alignbit_b32_e32 %[xi4], %[xi5], %[xi4], 8\n"
          "v_lshrrev_b32_e32  %[xi5], 8, %[xi5]\n"
          
          "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
          "ds_swizzle_b32 %[xi5], %[xi5] offset:0x041f\n"
          
          "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
          
	      "s_waitcnt lgkmcnt(0)\n"
	      
          "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
	      "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
          "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer0].z, %[xi6], %[xi2], vcc\n"
	      "flat_store_dwordx4 %[q], %[write_buffer0]\n"
	      
	      "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	      "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"
          "v_cndmask_b32_e32 %[write_buffer1].z, %[xi2], %[xi6], vcc\n"
          "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
          
	        "s_waitcnt expcnt(0)\n"
	          
          : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi0] "=&v" (xi0),
            [xi1] "=&v" (xi1),
            [xi2] "=&v" (xi2),
            [xi3] "=&v" (xi3),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5),
            [xi6] "=&v" (xi6)
            
          : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp), 
            [xi0] "6" (xi0),
            [xi1] "7" (xi1),
            [xi2] "8" (xi2),
            [xi3] "9" (xi3),
            [xi4] "10" (xi4),
            [xi5] "11" (xi5),
            [ref] "v" (ENCODE_INPUTS(round - 1, row, slot_a, slot_b))
            
          : "memory", "vcc");
}

void parallel_xor_and_store_round3(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters)
{
    uint new_row;
    uint new_slot_index;
    __global uint4 *p = (__global uint4 *)get_slot_ptr(ht_dst, round, _NR_ROWS(round) - 1, _NR_SLOTS(round) - 1);
    uint xi0, xi1, xi2, xi3, xi4, xi5, xi6;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        xi2 = *(ai += _NR_SLOTS(round - 1));
        xi3 = *(ai += _NR_SLOTS(round - 1));
        xi4 = *(ai += _NR_SLOTS(round - 1));
        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        xi2 ^= *(bi += _NR_SLOTS(round - 1));
        xi3 ^= *(bi += _NR_SLOTS(round - 1));
        xi4 ^= *(bi += _NR_SLOTS(round - 1));

        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_row = get_row(round, xi0);
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
            p = (__global uint4 *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        }
    }

    uint4 write_buffer0, write_buffer1;
    __global uint4 *pp = p + 1;
    __global uint4 *q;
    __global uint4 *qq;
    __asm("ds_swizzle_b32 %[pp].x, %[pp].x offset:0x041f\n"
          "ds_swizzle_b32 %[pp].y, %[pp].y offset:0x041f\n"

          "v_alignbit_b32_e32 %[xi0], %[xi1], %[xi0], 8\n"
          "v_alignbit_b32_e32 %[xi1], %[xi2], %[xi1], 8\n"
          "v_alignbit_b32_e32 %[xi2], %[xi3], %[xi2], 8\n"
          "v_alignbit_b32_e32 %[xi3], %[xi4], %[xi3], 8\n"
          "v_lshrrev_b32_e32  %[xi4], 8, %[xi4]\n"
          "v_cmp_eq_u32_e32 vcc, 1, %[second_thread]\n"
	      
          "ds_swizzle_b32 %[xi4], %[xi4] offset:0x041f\n"
          "ds_swizzle_b32 %[xi5], %[ref] offset:0x041f\n"

	      "s_waitcnt lgkmcnt(0)\n"

          "v_cndmask_b32_e32 %[q].x, %[pp].x, %[p].x, vcc\n"
	      "v_cndmask_b32_e32 %[q].y, %[pp].y, %[p].y, vcc\n"
	      "v_cndmask_b32_e32 %[qq].x, %[p].x, %[pp].x, vcc\n"
	      "v_cndmask_b32_e32 %[qq].y, %[p].y, %[pp].y, vcc\n"
          
	      "v_mov_b32         %[write_buffer0].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer0].w, %[xi3]\n"
	      "v_mov_b32         %[write_buffer1].z, %[xi2]\n"
	      "v_mov_b32         %[write_buffer1].w, %[xi3]\n"
	      
	      "s_waitcnt lgkmcnt(0)\n"

	      "v_cndmask_b32_e32 %[write_buffer0].x, %[xi4], %[xi0], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].x, %[xi0], %[xi4], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer0].y, %[xi5], %[xi1], vcc\n"
	      "v_cndmask_b32_e32 %[write_buffer1].y, %[xi1], %[xi5], vcc\n"

	      "flat_store_dwordx4 %[q], %[write_buffer0]\n"
	      "flat_store_dwordx4 %[qq], %[write_buffer1]\n"
          
	      "s_waitcnt expcnt(0)\n"
	          
          : [write_buffer0] "=&v" (write_buffer0),
            [write_buffer1] "=&v" (write_buffer1),
            [p] "=&v" (p), 
            [pp] "=&v" (pp),
            [q] "=&v" (q), 
            [qq] "=&v" (qq),
            [xi0] "=&v" (xi0),
            [xi1] "=&v" (xi1),
            [xi2] "=&v" (xi2),
            [xi3] "=&v" (xi3),
            [xi4] "=&v" (xi4),
            [xi5] "=&v" (xi5)
            
          : [second_thread] "v" ((uint)(get_local_id(0) & 0x1)),
            [p] "2" (p), 
            [pp] "3" (pp), 
            [xi0] "6" (xi0),
            [xi1] "7" (xi1),
            [xi2] "8" (xi2),
            [xi3] "9" (xi3),
            [xi4] "10" (xi4),
            [ref] "v" (ENCODE_INPUTS(round - 1, row, slot_a, slot_b))
            
          : "memory", "vcc");
}

void xor_and_store(uint device_thread, uint round, __global char *ht_src, __global char *ht_dst, uint row,
    uint slot_a, uint slot_b, __local uint *ai, __local uint *bi,
    __global uint *row_counters)
{
    const int even_round = !(round & 0x1);
    uint new_row;
    uint new_slot_index = _NR_SLOTS(round);
    uint xi0, xi1, xi2, xi3, xi4, xi5;

    slot_t slot;

    if (slot_a < _NR_SLOTS(round - 1)) {
        xi0 = *ai;
        xi1 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 = *(ai += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 = *(ai += _NR_SLOTS(round - 1));

        xi0 ^= *bi;
        xi1 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 7) xi2 ^= *(bi += _NR_SLOTS(round - 1));
        if (round <= 6) xi3 ^= *(bi += _NR_SLOTS(round - 1));

        new_row = get_row(round, even_round ? ((xi0 >> 24) | (xi1 << (32 - 24))) : xi0);
 
        // invalid solutions (which start happenning in round 5) have duplicate
        // inputs and xor to zero, so discard them
        if (xi0 || xi1) {
            new_slot_index = inc_gds_row_counter(device_thread, round, row_counters, new_row);
        }

        slot.slot.xi[0] = even_round ? xi1 : ((xi1 << 24) | (xi0 >> 8));
        if (round <= 7) slot.slot.xi[1] = even_round ? xi2 : ((xi2 << 24) | (xi1 >> 8));
        if (round <= 6) slot.slot.xi[2] = even_round ? xi3 : ((xi3 << 24) | (xi2 >> 8));
        slot.slot.xi[UINTS_IN_XI(round)] = ENCODE_INPUTS(round - 1, row, slot_a, slot_b);
    }

    if (new_slot_index < _NR_SLOTS(round)) {
        __global slot_t *p = (__global slot_t *)get_slot_ptr(ht_dst, round, new_row, new_slot_index);
        if (round >= 8)
            __asm("flat_store_dwordx2 %0, %1\n"
                  "s_waitcnt expcnt(0)\n"
                  :
                  : "v" ((__global uint2 *)p), "v" (slot.ui2[0])
                  : "memory", "vcc");
        else
            __asm("flat_store_dwordx4 %0, %1\n"
                  "s_waitcnt expcnt(0)\n"
                  :
                  : "v" ((__global uint4 *)p), "v" (slot.ui4[0])
                  : "memory", "vcc");
    }
}

/*
** Execute one Equihash round. Read from ht_src, XOR colliding pairs of Xi,
** store them in ht_dst. Each work group processes only one row at a time.
*/

void equihash_round(
    const uint device_thread,
    const uint round,
    __global char *ht_src,
    __global char *ht_dst,
    __global uint *debug,
    __local uint  *slot_cache,
    __local SLOT_INDEX_TYPE *collision_array_a,
    __local SLOT_INDEX_TYPE *collision_array_b,
    __local uint *nr_collisions,
    __global uint *rowCountersSrc,
    __global uint *rowCountersDst,
    __local uint *bin_first_slots,
    __local SLOT_INDEX_TYPE *bin_next_slots)
{
    uint     i, j;

    // the mask is also computed to read data from the previous round
#define BIN_MASK(round)        ((((round) + 1) % 2) ? 0xf000 : 0xf0000)
#define BIN_MASK_OFFSET(round) ((((round) + 1) % 2) ? 3 * 4 : 4 * 4)

#define BIN_MASK2(round) ((_NR_ROWS_LOG(round) == 12) ? ((((round) + 1) % 2) ? 0x00f0 : 0xf000) : \
                                                        ((((round) + 1) % 2) ? 0x00e0 : 0xe000))
#define BIN_MASK2_OFFSET(round) ((_NR_ROWS_LOG(round) == 12) ? ((((round) + 1) % 2) ? 0 : 8) : \
                                                               ((((round) + 1) % 2) ? 1 : 9))

#define _NR_BINS_LOG(round) (PREFIX(PARAM_N, PARAM_K) - _NR_ROWS_LOG(round))
#define _NR_BINS(round) (1 << _NR_BINS_LOG(round))

    const uint assigned_row_index = get_group_id(0);
    if (assigned_row_index >= _NR_ROWS(round - 1))
        return;

    const uint nr_slots = get_nr_slots(device_thread, round - 1, rowCountersSrc, assigned_row_index);

     bin_first_slots[get_local_id(0)] = _NR_SLOTS(round - 1);
    for (i = get_local_id(0); i < _NR_SLOTS(round - 1); i += get_local_size(0))
        bin_next_slots[i] = _NR_SLOTS(round - 1);

    // Perform a radix sort as slots get loaded into LDS.
    // Make sure all the work items in the work group enter the loop.
    uint i_max =  nr_slots + get_local_size(0) - (nr_slots / get_local_size(0)) - 1;
    for (i = get_local_id(0); i <= i_max; i += get_local_size(0)) {
        if (!get_local_id(0))
            *nr_collisions = 0;

        barrier(CLK_LOCAL_MEM_FENCE);

        uint slot_a_index = i;
        uint slot_b_index;
        uint slot_cache_index = i;
        uint xi0;
        uint bin_to_use;
        if (i < nr_slots) {
            if (UINTS_IN_XI(round - 1) == 6) {
                uint4 slot_data0;
                uint2 slot_data1;
                __global uint4 *p;
                __global uint2 *p1;
                __local uint *q, *q1, *q2, *q3, *q4, *q5;
                uint    temp0;
                
                __asm("v_add_u32 %[p1].x, vcc, %[p].x, 16\n"
                      "v_addc_u32 %[p1].y, vcc, %[p].y, 0, vcc\n"
                      "flat_load_dwordx4 %[slot_data0], %[p]\n"
                      "flat_load_dwordx2 %[slot_data1], %[p1]\n"
                      
                      "v_add_u32 %[q1], vcc, %[q], %[q_step]\n"
                      "v_add_u32 %[q2], vcc, %[q1], %[q_step]\n"
                      "v_add_u32 %[q3], vcc, %[q2], %[q_step]\n"
                      "v_add_u32 %[q4], vcc, %[q3], %[q_step]\n"
                      "v_add_u32 %[q5], vcc, %[q4], %[q_step]\n"
                      
                      "s_waitcnt vmcnt(0)\n"
                      
                      "ds_write_b32 %[q], %[slot_data0].x\n"
                      "ds_write_b32 %[q1], %[slot_data0].y\n"
                      "ds_write_b32 %[q2], %[slot_data0].z\n"
                      "ds_write_b32 %[q3], %[slot_data0].w\n"
                      "ds_write_b32 %[q4], %[slot_data1].x\n"
                      "ds_write_b32 %[q5], %[slot_data1].y\n"
                      
                      "v_and_b32    %[bin_to_use], %[slot_data0].x, %[bin_mask]\n"
                      "v_and_b32    %[temp0], %[slot_data0].x, %[bin_mask2]\n"
                      "v_lshrrev_b32 %[bin_to_use], %[bin_mask_offset], %[bin_to_use]\n"
                      "v_lshrrev_b32 %[temp0], %[bin_mask2_offset], %[temp0]\n"
                      "v_or_b32     %[bin_to_use], %[bin_to_use], %[temp0]\n"
                      
                      "s_waitcnt expcnt(0)\n"
                      
                      : [slot_data0] "=&v" (slot_data0),
                        [slot_data1] "=&v" (slot_data1),
                        [p] "=&v" (p), [p1] "=&v" (p1),
                        [q1] "=&v" (q1), [q2] "=&v" (q2), [q3] "=&v" (q3), [q4] "=&v" (q4), [q5] "=&v" (q5),
                        [temp0] "=&v" (temp0),
                        [bin_to_use] "=&v" (bin_to_use)
                      : [p] "2" ((__global uint4 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0),
                        [q] "v" ((__local uint *)&slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index]),
                        [q_step] "v" ((uint)(_NR_SLOTS(round - 1) * sizeof(uint))),
                        [bin_mask] "s" (BIN_MASK(round - 1)),
                        [bin_mask2] "s" (BIN_MASK2(round - 1)),
                        [bin_mask_offset] "s" (BIN_MASK_OFFSET(round - 1)),
                        [bin_mask2_offset] "s" (BIN_MASK2_OFFSET(round - 1))
                        );
                        
                bin_next_slots[i] = slot_b_index = atomic_xchg(&bin_first_slots[bin_to_use], i);
            } else if (UINTS_IN_XI(round - 1) == 5) {
                uint4 slot_data0;
                uint  slot_data1;
                __global uint4 *p;
                __global uint *p1;
                __local uint *q, *q1, *q2, *q3, *q4;
                
                __asm("v_add_u32 %[p1].x, vcc, %[p].x, 16\n"
                      "v_addc_u32 %[p1].y, vcc, %[p].y, 0, vcc\n"
                      
                      "flat_load_dwordx4 %[slot_data0], %[p]\n"
                      "flat_load_dword %[slot_data1], %[p1]\n"
                      
                      "v_add_u32 %[q1], vcc, %[q], %[q_step]\n"
                      "v_add_u32 %[q2], vcc, %[q1], %[q_step]\n"
                      "v_add_u32 %[q3], vcc, %[q2], %[q_step]\n"
                      "v_add_u32 %[q4], vcc, %[q3], %[q_step]\n"
                      
                      "s_waitcnt vmcnt(0)\n"
                      
                      "ds_write_b32 %[q], %[slot_data0].x\n"
                      "ds_write_b32 %[q1], %[slot_data0].y\n"
                      "ds_write_b32 %[q2], %[slot_data0].z\n"
                      "ds_write_b32 %[q3], %[slot_data0].w\n"
                      "ds_write_b32 %[q4], %[slot_data1]\n"
                      "v_mov_b32 %[xi0], %[slot_data0].x\n"
                      
                      "s_waitcnt expcnt(0)\n"
                      
                      : [slot_data0] "=&v" (slot_data0),
                        [slot_data1] "=&v" (slot_data1),
                        [p] "=&v" (p), [p1] "=&v" (p1),
                        [q1] "=&v" (q1), [q2] "=&v" (q2), [q3] "=&v" (q3), [q4] "=&v" (q4),
                        [xi0] "=&v" (xi0)
                      : [p] "2" ((__global uint4 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0),
                        [q] "v" ((__local uint *)&slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index]),
                        [q_step] "v" ((uint)(_NR_SLOTS(round - 1) * sizeof(uint))));
     
                bin_to_use =
                      ((xi0 & BIN_MASK(round - 1)) >> BIN_MASK_OFFSET(round - 1))
                    | ((xi0 & BIN_MASK2(round - 1)) >> BIN_MASK2_OFFSET(round - 1));
                bin_next_slots[i] = slot_b_index = atomic_xchg(&bin_first_slots[bin_to_use], i);
            } else {
                uint2 slot_data0, slot_data1;
                if (UINTS_IN_XI(round - 1) >= 1) slot_data0 = *((__global uint2 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 0);
                if (UINTS_IN_XI(round - 1) >= 3) slot_data1 = *((__global uint2 *)get_slot_ptr(ht_src, round - 1, assigned_row_index, slot_cache_index) + 1);

                xi0 = slot_data0.s0;
                bin_to_use =
                      ((xi0 & BIN_MASK(round - 1)) >> BIN_MASK_OFFSET(round - 1))
                    | ((xi0 & BIN_MASK2(round - 1)) >> BIN_MASK2_OFFSET(round - 1));
                bin_next_slots[i] = slot_b_index = atomic_xchg(&bin_first_slots[bin_to_use], i);

                slot_cache[0 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s0;
                if (UINTS_IN_XI(round - 1) >= 2) slot_cache[1 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data0.s1;

                if (UINTS_IN_XI(round - 1) >= 3) slot_cache[2 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data1.s0;
                if (UINTS_IN_XI(round - 1) >= 4) slot_cache[3 * _NR_SLOTS(round - 1) + slot_cache_index] = slot_data1.s1;

            }

            while (slot_b_index < _NR_SLOTS(round - 1)) {
                uint coll_index = atomic_inc(nr_collisions);
                if (coll_index >= _LDS_COLL_SIZE(round - 1))
                    break;
                collision_array_a[coll_index] = slot_a_index;
                collision_array_b[coll_index] = slot_b_index;
                slot_b_index = bin_next_slots[slot_b_index];
            }
        }
        
        barrier(CLK_LOCAL_MEM_FENCE);

        uint nr_collisions_copy = *nr_collisions;
        if (nr_collisions_copy >= _LDS_COLL_SIZE(round - 1))
            nr_collisions_copy = _LDS_COLL_SIZE(round - 1);

        __local uint *slot_cache_a, *slot_cache_b;
        uint write_index;

        barrier(CLK_LOCAL_MEM_FENCE);
        
        write_index = get_local_id(0);
        slot_a_index = _NR_SLOTS(round - 1);
        if (write_index < nr_collisions_copy) {
            slot_a_index = collision_array_a[write_index];
            slot_b_index = collision_array_b[write_index];
            slot_cache_a = (__local uint *)&slot_cache[slot_a_index];
            slot_cache_b = (__local uint *)&slot_cache[slot_b_index];
        }
        if (round == 1) {
            parallel_xor_and_store_round1(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 3) {
            parallel_xor_and_store_round3(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 5) {
            parallel_xor_and_store_round5(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 2) {
            parallel_xor_and_store_round2(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 4) {
            parallel_xor_and_store_round4(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else {
            xor_and_store(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        }
        
        write_index = get_local_size(0) + get_local_id(0);
        slot_a_index = _NR_SLOTS(round - 1);
        if (write_index < nr_collisions_copy) {
            slot_a_index = collision_array_a[write_index];
            slot_b_index = collision_array_b[write_index];
            slot_cache_a = (__local uint *)&slot_cache[slot_a_index];
            slot_cache_b = (__local uint *)&slot_cache[slot_b_index];
        }
        if (round == 1) {
            parallel_xor_and_store_round1(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 3) {
            parallel_xor_and_store_round3(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 5) {
            parallel_xor_and_store_round5(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 2) {
            parallel_xor_and_store_round2(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else if (round == 4) {
            parallel_xor_and_store_round4(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        } else {
            xor_and_store(device_thread, round, ht_src, ht_dst, assigned_row_index, slot_a_index, slot_b_index, slot_cache_a, slot_cache_b, rowCountersDst);
        }
    }
}

/*
** This defines kernel_round1, kernel_round2, ..., kernel_round8.
*/

#define KERNEL_ROUND(kernel_name, N) \
__kernel void kernel_name(uint device_thread, __global char *ht_src, __global char *ht_dst, \
	__global uint *rowCountersSrc, __global uint *rowCountersDst, \
       	__global uint *debug) \
{ \
    __local uint    slot_cache[ADJUSTED_LDS_ARRAY_SIZE(UINTS_IN_XI(N - 1) * _NR_SLOTS(N - 1))]; \
    __local SLOT_INDEX_TYPE collision_array_a[ADJUSTED_LDS_ARRAY_SIZE(_LDS_COLL_SIZE(N - 1))]; \
    __local SLOT_INDEX_TYPE collision_array_b[ADJUSTED_LDS_ARRAY_SIZE(_LDS_COLL_SIZE(N - 1))]; \
    __local uint    nr_collisions[1]; \
	__local uint    bin_first_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_BINS(N - 1))]; \
	__local SLOT_INDEX_TYPE bin_next_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS(N - 1))]; \
    equihash_round(device_thread, (N), ht_src, ht_dst, debug, slot_cache, collision_array_a, collision_array_b, \
	    nr_collisions, rowCountersSrc, rowCountersDst, bin_first_slots, bin_next_slots); \
}

KERNEL_ROUND(kernel_round1, 1)
KERNEL_ROUND(kernel_round2, 2)
KERNEL_ROUND(kernel_round3, 3)
KERNEL_ROUND(kernel_round4, 4)
KERNEL_ROUND(kernel_round5, 5)
KERNEL_ROUND(kernel_round6, 6)
KERNEL_ROUND(kernel_round7, 7)
KERNEL_ROUND(kernel_round8, 8)


void mark_potential_sol(__global potential_sols_t *potential_sols, uint ref0, uint ref1)
{
    uint sol_i = atomic_inc(&potential_sols->nr);
    if (sol_i >= MAX_POTENTIAL_SOLS)
        return;
    *(__global uint2 *)&(potential_sols->values[sol_i][0]) = (uint2){ref0, ref1};
}

/*
** Scan the hash tables to find Equihash solutions.
*/

__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_POTENTIAL_SOLS, 1, 1)))
void kernel_potential_sols(
    uint device_thread,
    __global char *ht_src,
    __global potential_sols_t *potential_sols,
    __global uint *rowCountersSrc)
{
    __local uint refs[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];
    __local uint data[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];

    uint		nr_slots;
    uint		i, j;
    __global char	*p;
    uint		ref_i, ref_j;
    __local uint    bin_first_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_BINS((PARAM_K - 1)))];
    __local SLOT_INDEX_TYPE    bin_next_slots[ADJUSTED_LDS_ARRAY_SIZE(_NR_SLOTS((PARAM_K - 1)))];

    uint assigned_row_index = get_group_id(0);
    if (assigned_row_index >= _NR_ROWS((PARAM_K - 1)))
        return;
    
    bin_first_slots[get_local_id(0)] = _NR_SLOTS((PARAM_K - 1));
    for (i = get_local_id(0); i < _NR_SLOTS((PARAM_K - 1)); i += get_local_size(0))
        bin_next_slots[i] = _NR_SLOTS((PARAM_K - 1));

    nr_slots = get_nr_slots(device_thread, PARAM_K - 1, rowCountersSrc, assigned_row_index);

    barrier(CLK_LOCAL_MEM_FENCE);

    // in the final hash table, we are looking for a match on both the bits
    // part of the previous PREFIX colliding bits, and the last PREFIX bits.
    for (uint i = get_local_id(0); i < nr_slots; i += get_local_size(0)) {
        __global uint2 *p = (__global uint2 *)get_slot_ptr(ht_src, PARAM_K - 1, assigned_row_index, i);
        uint2 slot_data = *p;
        uint data_i = data[i] = slot_data.x;
        uint ref_i  = refs[i] = slot_data.y;
        uint bin_to_use =
                ((data_i & BIN_MASK(PARAM_K - 1)) >> BIN_MASK_OFFSET(PARAM_K - 1))
            | ((data_i & BIN_MASK2(PARAM_K - 1)) >> BIN_MASK2_OFFSET(PARAM_K - 1));
        j = bin_next_slots[i] = atomic_xchg(&bin_first_slots[bin_to_use], i);
        
        while (j < nr_slots) {
            if (data_i == data[j])
                mark_potential_sol(potential_sols, refs[i], refs[j]);
            j = bin_next_slots[j];
        }
    }
}



__kernel __attribute__((reqd_work_group_size(LOCAL_WORK_SIZE_SOLS, 1, 1)))
void kernel_sols(__global char *ht0,
    __global char *ht1,
    __global sols_t *sols,
    __global uint *rowCountersSrc,
    __global uint *rowCountersDst,
    __global char *ht2,
    __global char *ht3,
    __global char *ht4,
    __global char *ht5,
    __global char *ht6,
    __global char *ht7,
    __global char *ht8,
    __global potential_sols_t *potential_sols)
{
    __local uint	inputs_a[ADJUSTED_LDS_ARRAY_SIZE(1 << PARAM_K)], inputs_b[ADJUSTED_LDS_ARRAY_SIZE(1 << (PARAM_K - 1))];
    __global char	*htabs[] = { ht0, ht1, ht2, ht3, ht4, ht5, ht6, ht7, ht8 };

    if (get_group_id(0) < potential_sols->nr && get_group_id(0) < MAX_POTENTIAL_SOLS) {
        __local uint dup_counter;
        if (get_local_id(0) == 0) {
            dup_counter = 0;
            inputs_a[0] = potential_sols->values[get_group_id(0)][0];
            inputs_a[1] = potential_sols->values[get_group_id(0)][1];
        }
        barrier(CLK_LOCAL_MEM_FENCE);

#pragma unroll
        for (int round = 7; round >= 0; --round) {
            if (round % 2) {
                for (uint i = get_local_id(0); i < (1 << ((PARAM_K - 1) - round)); i += get_local_size(0)) {
                    inputs_b[i * 2 + 1] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_a[i]), DECODE_SLOT1(round, inputs_a[i]));
                    inputs_b[i * 2] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_a[i]), DECODE_SLOT0(round, inputs_a[i]));
                }
            } else {
                for (uint i = get_local_id(0); i < (1 << ((PARAM_K - 1) - round)); i += get_local_size(0)) {
                    inputs_a[i * 2 + 1] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_b[i]), DECODE_SLOT1(round, inputs_b[i]));
                    inputs_a[i * 2] = *get_ref_ptr(htabs[round], round, DECODE_ROW(round, inputs_b[i]), DECODE_SLOT0(round, inputs_b[i]));
                }
            }
            barrier(CLK_LOCAL_MEM_FENCE);
        }
        //barrier(CLK_LOCAL_MEM_FENCE);

        int	dup_to_watch = inputs_a[(1 << PARAM_K) - 1];
        uint j = 3 + get_local_id(0);
        if (inputs_a[j] == dup_to_watch)
            atomic_inc(&dup_counter);
        j += get_local_size(0);
        if (j < (1 << PARAM_K) - 2 && inputs_a[j] == dup_to_watch)
            atomic_inc(&dup_counter);
        
        barrier(CLK_LOCAL_MEM_FENCE);
        
        // solution appears valid, copy it to sols
        if (!dup_counter) {
            __local uint sol_i;
            if (!get_local_id(0))
                 sol_i = atomic_inc(&sols->nr);
            barrier(CLK_LOCAL_MEM_FENCE);
            if (sol_i < MAX_SOLS) {
                if (!get_local_id(0))
                    sols->valid[sol_i] = 1;
                sols->values[sol_i][get_local_id(0)] = inputs_a[get_local_id(0)];
                sols->values[sol_i][get_local_id(0) + get_local_size(0)] = inputs_a[get_local_id(0) + get_local_size(0)];
            }
        }
    }
}
