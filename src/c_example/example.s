	.text
	.file	"example.c"
	.section	.text.test,"",@
	.globl	test                            # -- Begin function test
	.globaltype	__stack_pointer, i32
	.functype	sleep (i32) -> (i32)
	.functype	printf (i32, i32) -> (i32)
	.functype	thrd_exit (i32) -> ()
	.functype	thrd_create (i32, i32, i32) -> (i32)
	.functype	thrd_join (i32, i32) -> (i32)
	.functype	getTempRet0 () -> (i32)
	.import_module	getTempRet0, env
	.import_name	getTempRet0, getTempRet0
	.functype	setTempRet0 (i32) -> ()
	.import_module	setTempRet0, env
	.import_name	setTempRet0, setTempRet0
	.type	test,@function
test:                                   # @test
	.functype	test (i32) -> (i32)
	.local  	i32, i32, i32, i32, i32, i32, i32, i32
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
	i32.const	1
	local.set	4
	local.get	4
	call	sleep
	drop
	global.get	variable1@GOT@TLS
	local.set	5
	local.get	5
	i32.load	0
	local.set	6
	local.get	3
	local.get	6
	i32.store	0
	i32.const	.L.str
	local.set	7
	local.get	7
	local.get	3
	call	printf
	drop
	i32.const	0
	local.set	8
	local.get	8
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
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32
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
	global.get	variable1@GOT@TLS
	local.set	4
	local.get	4
	i32.load	0
	local.set	5
	local.get	2
	local.get	5
	i32.store	0
	i32.const	.L.str.1
	local.set	6
	local.get	6
	local.get	2
	call	printf
	drop
	i32.const	test
	local.set	7
	i32.const	24
	local.set	8
	local.get	2
	local.get	8
	i32.add 
	local.set	9
	local.get	9
	local.get	7
	local.get	3
	call	thrd_create
	drop
	local.get	4
	i32.load	0
	local.set	10
	i32.const	1
	local.set	11
	local.get	10
	local.get	11
	i32.add 
	local.set	12
	local.get	4
	local.get	12
	i32.store	0
	local.get	4
	i32.load	0
	local.set	13
	local.get	2
	local.get	13
	i32.store	16
	i32.const	.L.str.2
	local.set	14
	i32.const	16
	local.set	15
	local.get	2
	local.get	15
	i32.add 
	local.set	16
	local.get	14
	local.get	16
	call	printf
	drop
	local.get	2
	i32.load	24
	local.set	17
	i32.const	0
	local.set	18
	local.get	17
	local.get	18
	call	thrd_join
	drop
	i32.const	0
	local.set	19
	i32.const	32
	local.set	20
	local.get	2
	local.get	20
	i32.add 
	local.set	21
	local.get	21
	global.set	__stack_pointer
	local.get	19
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
	.type	variable1,@object               # @variable1
	.section	.tdata.variable1,"T",@
	.globl	variable1
	.p2align	2
variable1:
	.int32	1                               # 0x1
	.size	variable1, 4

	.type	.L.str,@object                  # @.str
	.section	.rodata..L.str,"S",@
.L.str:
	.asciz	"in thread, variable1: %d\n"
	.size	.L.str, 26

	.type	.L.str.1,@object                # @.str.1
	.section	.rodata..L.str.1,"S",@
.L.str.1:
	.asciz	"main, variable1 before: %d\n"
	.size	.L.str.1, 28

	.type	.L.str.2,@object                # @.str.2
	.section	.rodata..L.str.2,"S",@
.L.str.2:
	.asciz	"main, variable1 after: %d\n"
	.size	.L.str.2, 27

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
	.section	.rodata..L.str.2,"S",@
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
	.section	.rodata..L.str.2,"S",@
