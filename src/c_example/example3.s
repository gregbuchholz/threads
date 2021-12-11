	.text
	.file	"example3.c"
	.section	.text.test,"",@
	.globl	test                            # -- Begin function test
	.globaltype	__stack_pointer, i32
	.functype	thrd_exit (i32) -> ()
	.functype	thrd_create (i32, i32, i32) -> (i32)
	.functype	thrd_join (i32, i32) -> (i32)
	.functype	printf (i32, i32) -> (i32)
	.functype	getTempRet0 () -> (i32)
	.import_module	getTempRet0, env
	.import_name	getTempRet0, getTempRet0
	.functype	setTempRet0 (i32) -> ()
	.import_module	setTempRet0, env
	.import_name	setTempRet0, setTempRet0
	.type	test,@function
test:                                   # @test
	.functype	test (i32) -> (i32)
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:
	global.get	__stack_pointer
	local.set	1
	i32.const	16
	local.set	2
	local.get	1
	local.get	2
	i32.sub 
	local.set	3
	local.get	3
	global.set	__stack_pointer
	local.get	3
	local.get	0
	i32.store	12
	i32.const	0
	local.set	4
	local.get	3
	local.get	4
	i32.store	8
.LBB0_1:                                # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                                # label1:
	local.get	3
	i32.load	8
	local.set	5
	i32.const	10000000
	local.set	6
	local.get	5
	local.set	7
	local.get	6
	local.set	8
	local.get	7
	local.get	8
	i32.lt_s
	local.set	9
	i32.const	1
	local.set	10
	local.get	9
	local.get	10
	i32.and 
	local.set	11
	local.get	11
	i32.eqz
	br_if   	1                               # 1: down to label0
# %bb.2:                                #   in Loop: Header=BB0_1 Depth=1
	i32.const	0
	local.set	12
	i32.const	1
	local.set	13
	local.get	12
	local.get	13
	i32.atomic.rmw.add	foo_atomic
	drop
	i32.const	0
	local.set	14
	local.get	14
	i32.load	bar_non
	local.set	15
	i32.const	1
	local.set	16
	local.get	15
	local.get	16
	i32.add 
	local.set	17
	i32.const	0
	local.set	18
	local.get	18
	local.get	17
	i32.store	bar_non
# %bb.3:                                #   in Loop: Header=BB0_1 Depth=1
	local.get	3
	i32.load	8
	local.set	19
	i32.const	1
	local.set	20
	local.get	19
	local.get	20
	i32.add 
	local.set	21
	local.get	3
	local.get	21
	i32.store	8
	br      	0                               # 0: up to label1
.LBB0_4:
	end_loop
	end_block                               # label0:
	i32.const	0
	local.set	22
	local.get	22
	call	thrd_exit
	unreachable
	end_function
.Lfunc_end0:
	.size	test, .Lfunc_end0-test
                                        # -- End function
	.section	.text.__original_main,"",@
	.globl	__original_main                 # -- Begin function __original_main
	.type	__original_main,@function
__original_main:                        # @__original_main
	.functype	__original_main () -> (i32)
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
# %bb.0:
	global.get	__stack_pointer
	local.set	0
	i32.const	32
	local.set	1
	local.get	0
	local.get	1
	i32.sub 
	local.set	2
	local.get	2
	global.set	__stack_pointer
	i32.const	0
	local.set	3
	local.get	2
	local.get	3
	i32.store	28
	i32.const	24
	local.set	4
	local.get	2
	local.get	4
	i32.add 
	local.set	5
	local.get	5
	local.set	6
	i32.const	test
	local.set	7
	local.get	7
	local.set	8
	i32.const	0
	local.set	9
	local.get	6
	local.get	8
	local.get	9
	call	thrd_create
	drop
	i32.const	0
	local.set	10
	local.get	2
	local.get	10
	i32.store	20
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	block   	
	loop    	                                # label3:
	local.get	2
	i32.load	20
	local.set	11
	i32.const	10000000
	local.set	12
	local.get	11
	local.set	13
	local.get	12
	local.set	14
	local.get	13
	local.get	14
	i32.lt_s
	local.set	15
	i32.const	1
	local.set	16
	local.get	15
	local.get	16
	i32.and 
	local.set	17
	local.get	17
	i32.eqz
	br_if   	1                               # 1: down to label2
# %bb.2:                                #   in Loop: Header=BB1_1 Depth=1
	i32.const	0
	local.set	18
	i32.const	1
	local.set	19
	local.get	18
	local.get	19
	i32.atomic.rmw.add	foo_atomic
	drop
	i32.const	0
	local.set	20
	local.get	20
	i32.load	bar_non
	local.set	21
	i32.const	1
	local.set	22
	local.get	21
	local.get	22
	i32.add 
	local.set	23
	i32.const	0
	local.set	24
	local.get	24
	local.get	23
	i32.store	bar_non
# %bb.3:                                #   in Loop: Header=BB1_1 Depth=1
	local.get	2
	i32.load	20
	local.set	25
	i32.const	1
	local.set	26
	local.get	25
	local.get	26
	i32.add 
	local.set	27
	local.get	2
	local.get	27
	i32.store	20
	br      	0                               # 0: up to label3
.LBB1_4:
	end_loop
	end_block                               # label2:
	local.get	2
	i32.load	24
	local.set	28
	i32.const	0
	local.set	29
	local.get	28
	local.get	29
	call	thrd_join
	drop
	local.get	29
	i32.atomic.load	foo_atomic
	local.set	30
	i32.const	0
	local.set	31
	local.get	31
	i32.load	bar_non
	local.set	32
	local.get	2
	local.get	32
	i32.store	4
	local.get	2
	local.get	30
	i32.store	0
	i32.const	.L.str
	local.set	33
	local.get	33
	local.get	2
	call	printf
	drop
	i32.const	0
	local.set	34
	i32.const	32
	local.set	35
	local.get	2
	local.get	35
	i32.add 
	local.set	36
	local.get	36
	global.set	__stack_pointer
	local.get	34
	return
	end_function
.Lfunc_end1:
	.size	__original_main, .Lfunc_end1-__original_main
                                        # -- End function
	.section	.text.main,"",@
	.globl	main                            # -- Begin function main
	.type	main,@function
main:                                   # @main
	.functype	main (i32, i32) -> (i32)
	.local  	i32
# %bb.0:
	call	__original_main
	local.set	2
	local.get	2
	return
	end_function
.Lfunc_end2:
	.size	main, .Lfunc_end2-main
                                        # -- End function
	.type	foo_atomic,@object              # @foo_atomic
	.section	.bss.foo_atomic,"",@
	.globl	foo_atomic
	.p2align	2
foo_atomic:
	.int32	0                               # 0x0
	.size	foo_atomic, 4

	.type	bar_non,@object                 # @bar_non
	.section	.bss.bar_non,"",@
	.globl	bar_non
	.p2align	2
bar_non:
	.int32	0                               # 0x0
	.size	bar_non, 4

	.type	.L.str,@object                  # @.str
	.section	.rodata..L.str,"S",@
.L.str:
	.asciz	"foo_atomic: %d, bar_non: %d\n"
	.size	.L.str, 29

	.ident	"clang version 14.0.0 (https://github.com/llvm/llvm-project 4348cd42c385e71b63e5da7e492172cff6a79d7b)"
	.no_dead_strip	__indirect_function_table
	.size	__THREW__, 4
	.size	__threwValue, 4
	.section	.custom_section.producers,"",@
	.int8	1
	.int8	12
	.ascii	"processed-by"
	.int8	1
	.int8	5
	.ascii	"clang"
	.int8	86
	.ascii	"14.0.0 (https://github.com/llvm/llvm-project 4348cd42c385e71b63e5da7e492172cff6a79d7b)"
	.section	.rodata..L.str,"S",@
	.section	.custom_section.target_features,"",@
	.int8	4
	.int8	43
	.int8	7
	.ascii	"atomics"
	.int8	43
	.int8	11
	.ascii	"bulk-memory"
	.int8	43
	.int8	15
	.ascii	"mutable-globals"
	.int8	43
	.int8	8
	.ascii	"sign-ext"
	.section	.rodata..L.str,"S",@
