# RUN: llvm-mc -triple i386-apple-darwin9 %s -filetype=obj -o %t.o
# RUN: llvm-dwarfdump -v %t.o | FileCheck --check-prefix=COMMON %s
#
# Test object to verify dwarfdump handles v5 string offset tables in Mach-O.
# This is similar to dwarfdump-str-offsets.s with 2 CUs and 1 TU, but no
# split sections.
#
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz "Handmade DWARF producer"
str_CU1:
        .asciz "Compile_Unit_1"
str_CU1_dir:
        .asciz "/home/test/CU1"
str_CU2:
        .asciz "Compile_Unit_2"
str_CU2_dir:
        .asciz "/home/test/CU2"
str_TU:
        .asciz "Type_Unit"
str_TU_type:
        .asciz "MyStruct"
str_Subprogram:
        .asciz "MyFunc"
str_Variable1:
        .asciz "MyVar1"
str_Variable2:
        .asciz "MyVar2"
str_Variable3:
        .asciz "MyVar3"

	.section	__DWARF,__debug_str_offs,regular,debug
Ldebug_str_offsets:
        .long Ldebug_str_offsets_segment0_end-Ldebug_str_offsets_base0
        .short 5    # DWARF version
        .short 0    # Padding
Ldebug_str_offsets_base0:
        .long str_producer
        .long str_CU1
        .long str_CU1_dir
        .long str_Subprogram
        .long str_Variable1
        .long str_Variable2
        .long str_Variable3
Ldebug_str_offsets_segment0_end:
# CU2's contribution
        .long Ldebug_str_offsets_segment1_end-Ldebug_str_offsets_base1
        .short 5    # DWARF version
        .short 0    # Padding
Ldebug_str_offsets_base1:
        .long str_producer
        .long str_CU2
        .long str_CU2_dir
Ldebug_str_offsets_segment1_end:
# The TU's contribution
        .long Ldebug_str_offsets_segment2_end-Ldebug_str_offsets_base2
        .short 5    # DWARF version
        .short 0    # Padding
Ldebug_str_offsets_base2:
        .long str_TU
        .long str_TU_type
Ldebug_str_offsets_segment2_end:

	.section	__DWARF,__debug_abbrev,regular,debug
Lsection_abbrev:
        .byte 0x01  # Abbrev code
        .byte 0x11  # DW_TAG_compile_unit
        .byte 0x01  # DW_CHILDREN_yes
        .byte 0x25  # DW_AT_producer
        .byte 0x1a  # DW_FORM_strx
        .byte 0x03  # DW_AT_name
        .byte 0x1a  # DW_FORM_strx
        .byte 0x72  # DW_AT_str_offsets_base
        .byte 0x17  # DW_FORM_sec_offset
        .byte 0x1b  # DW_AT_comp_dir
        .byte 0x1a  # DW_FORM_strx
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x02  # Abbrev code
        .byte 0x41  # DW_TAG_type_unit
        .byte 0x01  # DW_CHILDREN_yes
        .byte 0x03  # DW_AT_name
        .byte 0x1a  # DW_FORM_strx
        .byte 0x72  # DW_AT_str_offsets_base
        .byte 0x17  # DW_FORM_sec_offset
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x03  # Abbrev code
        .byte 0x13  # DW_TAG_structure_type
        .byte 0x00  # DW_CHILDREN_no (no members)
        .byte 0x03  # DW_AT_name
        .byte 0x1a  # DW_FORM_strx
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x04  # Abbrev code
        .byte 0x2e  # DW_TAG_subprogram
        .byte 0x01  # DW_CHILDREN_yes
        .byte 0x03  # DW_AT_name
        .byte 0x25  # DW_FORM_strx1
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x05  # Abbrev code
        .byte 0x34  # DW_TAG_variable
        .byte 0x00  # DW_CHILDREN_no
        .byte 0x03  # DW_AT_name
        .byte 0x26  # DW_FORM_strx2
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x06  # Abbrev code
        .byte 0x34  # DW_TAG_variable
        .byte 0x00  # DW_CHILDREN_no
        .byte 0x03  # DW_AT_name
        .byte 0x27  # DW_FORM_strx3
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x07  # Abbrev code
        .byte 0x34  # DW_TAG_variable
        .byte 0x00  # DW_CHILDREN_no
        .byte 0x03  # DW_AT_name
        .byte 0x28  # DW_FORM_strx4
        .byte 0x00  # EOM(1)
        .byte 0x00  # EOM(2)
        .byte 0x00  # EOM(3)

	.section	__DWARF,__debug_info,regular,debug
Lsection_info:
# DWARF v5 CU header.
        .long  CU1_5_end-CU1_5_version  # Length of Unit
CU1_5_version:
        .short 5               # DWARF version number
        .byte 1                # DWARF Unit Type
        .byte 8                # Address Size (in bytes)
        .long 0                # Offset Into Abbrev. Section
# The compile-unit DIE, which has a DW_AT_producer, DW_AT_name,
# DW_AT_str_offsets and DW_AT_compdir.
        .byte 1                # Abbreviation code
        .byte 0                # The index of the producer string
        .byte 1                # The index of the CU name string
        .long Ldebug_str_offsets_base0-Ldebug_str_offsets
        .byte 2                # The index of the comp dir string
# A subprogram DIE with DW_AT_name, using DW_FORM_strx1.
        .byte 4                # Abbreviation code
        .byte 3                # Subprogram name string (DW_FORM_strx1)
# A variable DIE with DW_AT_name, using DW_FORM_strx2.
        .byte 5                # Abbreviation code
        .short 0x0004          # Subprogram name string (DW_FORM_strx2)
# A variable DIE with DW_AT_name, using DW_FORM_strx3.
        .byte 6                # Abbreviation code
        .byte 5                # Subprogram name string (DW_FORM_strx3)
        .short 0               # Subprogram name string (DW_FORM_strx3)
# A variable DIE with DW_AT_name, using DW_FORM_strx4.
        .byte 7                # Abbreviation code
        .quad 0x00000006       # Subprogram name string (DW_FORM_strx4)
        .byte 0 # NULL
        .byte 0 # NULL
        .byte 0 # NULL
CU1_5_end:

# DWARF v5 CU header
        .long  CU2_5_end-CU2_5_version  # Length of Unit
CU2_5_version:
        .short 5               # DWARF version number
        .byte 1                # DWARF Unit Type
        .byte 8                # Address Size (in bytes)
        .long 0                # Offset Into Abbrev. Section
# The compile-unit DIE, which has a DW_AT_producer, DW_AT_name,
# DW_AT_str_offsets and DW_AT_compdir.
        .byte 1                # Abbreviation code
        .byte 0                # The index of the producer string
        .byte 1                # The index of the CU name string
        .long Ldebug_str_offsets_base1-Ldebug_str_offsets
        .byte 2                # The index of the comp dir string
        .byte 0 # NULL
CU2_5_end:

	.section	__DWARF,__debug_types,regular,debug
# DWARF v5 Type unit header.
TU_5_start:
        .long  TU_5_end-TU_5_version  # Length of Unit
TU_5_version:
        .short 5               # DWARF version number
        .byte 2                # DWARF Unit Type
        .byte 8                # Address Size (in bytes)
        .long 0                # Offset Into Abbrev. Section
        .quad 0x0011223344556677 # Type Signature
        .long TU_5_type-TU_5_start # Type offset
# The type-unit DIE, which has a name.
        .byte 2                # Abbreviation code
        .byte 0                # Index of the unit type name string
        .long Ldebug_str_offsets_base2-Ldebug_str_offsets  # offset into the str_offsets section
# The type DIE, which has a name.
TU_5_type:
        .byte 3                # Abbreviation code
        .byte 1                # Index of the type name string
        .byte 0 # NULL
        .byte 0 # NULL
TU_5_end:


.subsections_via_symbols

# We are using a hand-constructed object file and are interest in the correct
# diplay of the DW_str_offsetsbase attribute and the correct display of strings.
#
# Abbreviation for DW_AT_str_offsets_base
# COMMON:      .debug_abbrev contents:
# COMMON-NOT:  contents:
# COMMON:      DW_TAG_compile_unit
# COMMON-NOT:  DW_TAG
# COMMON:      DW_AT_str_offsets_base DW_FORM_sec_offset
# 
# Verify that strings are displayed correctly as indexed strings
# COMMON:      .debug_info contents:
# COMMON-NOT:  contents:     
# COMMON:      DW_TAG_compile_unit
# COMMON-NEXT: DW_AT_producer [DW_FORM_strx] ( indexed (00000000) string = "Handmade DWARF producer")
# COMMON-NEXT: DW_AT_name [DW_FORM_strx] ( indexed (00000001) string = "Compile_Unit_1")
# COMMON-NEXT: DW_AT_str_offsets_base [DW_FORM_sec_offset] (0x00000008)
# COMMON-NEXT: DW_AT_comp_dir [DW_FORM_strx] ( indexed (00000002) string = "/home/test/CU1")
# COMMON-NOT:  NULL
# COMMON:      DW_TAG_subprogram
# COMMON-NEXT: DW_AT_name [DW_FORM_strx1] ( indexed (00000003) string = "MyFunc")
# COMMON-NOT:  NULL
# COMMON:      DW_TAG_variable
# COMMON-NEXT: DW_AT_name [DW_FORM_strx2] ( indexed (00000004) string = "MyVar1")
# COMMON-NOT:  NULL
# COMMON:      DW_TAG_variable
# COMMON-NEXT: DW_AT_name [DW_FORM_strx3] ( indexed (00000005) string = "MyVar2")
# COMMON-NOT:  NULL
# COMMON:      DW_TAG_variable
# COMMON-NEXT: DW_AT_name [DW_FORM_strx4] ( indexed (00000006) string = "MyVar3")
# 
# Second compile unit (b.cpp)
# COMMON:      DW_TAG_compile_unit
# COMMON-NEXT: DW_AT_producer [DW_FORM_strx] ( indexed (00000000) string = "Handmade DWARF producer")
# COMMON-NEXT: DW_AT_name [DW_FORM_strx] ( indexed (00000001) string = "Compile_Unit_2")
# COMMON-NEXT: DW_AT_str_offsets_base [DW_FORM_sec_offset] (0x0000002c)
# COMMON-NEXT: DW_AT_comp_dir [DW_FORM_strx] ( indexed (00000002) string = "/home/test/CU2")
# 
# The type unit
# COMMON:      .debug_types contents:
# COMMON:      DW_TAG_type_unit
# COMMON-NEXT: DW_AT_name [DW_FORM_strx] ( indexed (00000000) string = "Type_Unit")
# COMMON-NEXT: DW_AT_str_offsets_base [DW_FORM_sec_offset]       (0x00000040)
# COMMON:      DW_TAG_structure_type
# COMMON-NEXT: DW_AT_name [DW_FORM_strx] ( indexed (00000001) string = "MyStruct")
# 
# The .debug_str_offsets section
# COMMON:      .debug_str_offsets contents:
# COMMON-NEXT: 0x00000000: Contribution size = 28, Version = 5
# COMMON-NEXT: 0x00000008: 00000000 "Handmade DWARF producer"
# COMMON-NEXT: 0x0000000c: 00000018 "Compile_Unit_1"
# COMMON-NEXT: 0x00000010: 00000027 "/home/test/CU1"
# COMMON-NEXT: 0x00000014: 00000067 "MyFunc"
# COMMON-NEXT: 0x00000018: 0000006e "MyVar1"
# COMMON-NEXT: 0x0000001c: 00000075 "MyVar2"
# COMMON-NEXT: 0x00000020: 0000007c "MyVar3"
# COMMON-NEXT: 0x00000024: Contribution size = 12, Version = 5
# COMMON-NEXT: 0x0000002c: 00000000 "Handmade DWARF producer"
# COMMON-NEXT: 0x00000030: 00000036 "Compile_Unit_2"
# COMMON-NEXT: 0x00000034: 00000045 "/home/test/CU2"
# COMMON-NEXT: 0x00000038: Contribution size = 8, Version = 5
# COMMON-NEXT: 0x00000040: 00000054 "Type_Unit"
# COMMON-NEXT: 0x00000044: 0000005e "MyStruct"
