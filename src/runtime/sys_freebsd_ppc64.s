// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build freebsd
// +build ppc64 ppc64le

//
// System calls and other sys.stuff for ppc64, Linux
//

#include "go_asm.h"
#include "go_tls.h"
#include "textflag.h"
#include "asm_ppc64x.h"

#define CLOCK_REALTIME		0
#define CLOCK_MONOTONIC		4
#define	SYS_exit                   1   
#define	SYS_fork                   2   
#define	SYS_read                   3   
#define	SYS_write                  4   
#define	SYS_open                   5   
#define	SYS_close                  6   
#define	SYS_wait4                  7   
#define	SYS_link                   9   
#define	SYS_unlink                 10  
#define	SYS_chdir                  12  
#define	SYS_fchdir                 13  
#define	SYS_mknod                  14  
#define	SYS_chmod                  15  
#define	SYS_chown                  16  
#define	SYS_obreak                 17  
#define	SYS_getpid                 20  
#define	SYS_mount                  21  
#define	SYS_unmount                22  
#define	SYS_setuid                 23  
#define	SYS_getuid                 24  
#define	SYS_geteuid                25  
#define	SYS_ptrace                 26  
#define	SYS_recvmsg                27  
#define	SYS_sendmsg                28  
#define	SYS_recvfrom               29  
#define	SYS_accept                 30  
#define	SYS_getpeername            31  
#define	SYS_getsockname            32  
#define	SYS_access                 33  
#define	SYS_chflags                34  
#define	SYS_fchflags               35  
#define	SYS_sync                   36  
#define	SYS_kill                   37  
#define	SYS_getppid                39  
#define	SYS_dup                    41  
#define	SYS_pipe                   42  
#define	SYS_getegid                43  
#define	SYS_profil                 44  
#define	SYS_ktrace                 45  
#define	SYS_getgid                 47  
#define	SYS_getlogin               49  
#define	SYS_setlogin               50  
#define	SYS_acct                   51  
#define	SYS_sigaltstack            53  
#define	SYS_ioctl                  54  
#define	SYS_reboot                 55  
#define	SYS_revoke                 56  
#define	SYS_symlink                57  
#define	SYS_readlink               58  
#define	SYS_execve                 59  
#define	SYS_umask                  60  
#define	SYS_chroot                 61  
#define	SYS_msync                  65  
#define	SYS_vfork                  66  
#define	SYS_sbrk                   69  
#define	SYS_sstk                   70  
#define	SYS_ovadvise               72  
#define	SYS_munmap                 73  
#define	SYS_mprotect               74  
#define	SYS_madvise                75  
#define	SYS_mincore                78  
#define	SYS_getgroups              79  
#define	SYS_setgroups              80  
#define	SYS_getpgrp                81  
#define	SYS_setpgid                82  
#define	SYS_setitimer              83  
#define	SYS_swapon                 85  
#define	SYS_getitimer              86  
#define	SYS_getdtablesize          89  
#define	SYS_dup2                   90  
#define	SYS_fcntl                  92  
#define	SYS_select                 93  
#define	SYS_fsync                  95  
#define	SYS_setpriority            96  
#define	SYS_socket                 97  
#define	SYS_connect                98  
#define	SYS_getpriority            100 
#define	SYS_bind                   104 
#define	SYS_setsockopt             105 
#define	SYS_listen                 106 
#define	SYS_gettimeofday           116 
#define	SYS_getrusage              117 
#define	SYS_getsockopt             118 
#define	SYS_readv                  120 
#define	SYS_writev                 121 
#define	SYS_settimeofday           122 
#define	SYS_fchown                 123 
#define	SYS_fchmod                 124 
#define	SYS_setreuid               126 
#define	SYS_setregid               127 
#define	SYS_rename                 128 
#define	SYS_flock                  131 
#define	SYS_mkfifo                 132 
#define	SYS_sendto                 133 
#define	SYS_shutdown               134 
#define	SYS_socketpair             135 
#define	SYS_mkdir                  136 
#define	SYS_rmdir                  137 
#define	SYS_utimes                 138 
#define	SYS_adjtime                140 
#define	SYS_setsid                 147 
#define	SYS_quotactl               148 
#define	SYS_lgetfh                 160 
#define	SYS_getfh                  161 
#define	SYS_sysarch                165 
#define	SYS_rtprio                 166 
#define	SYS_freebsd6_pread         173 
#define	SYS_freebsd6_pwrite        174 
#define	SYS_setfib                 175 
#define	SYS_ntp_adjtime            176 
#define	SYS_setgid                 181 
#define	SYS_setegid                182 
#define	SYS_seteuid                183 
#define	SYS_stat                   188 
#define	SYS_fstat                  189 
#define	SYS_lstat                  190 
#define	SYS_pathconf               191 
#define	SYS_fpathconf              192 
#define	SYS_getrlimit              194 
#define	SYS_setrlimit              195 
#define	SYS_getdirentries          196 
#define	SYS_freebsd6_mmap          197 
#define	SYS_freebsd6_lseek         199 
#define	SYS_freebsd6_truncate      200 
#define	SYS_freebsd6_ftruncate     201 
#define	SYS___sysctl               202 
#define	SYS_mlock                  203 
#define	SYS_munlock                204 
#define	SYS_undelete               205 
#define	SYS_futimes                206 
#define	SYS_getpgid                207 
#define	SYS_poll                   209 
#define	SYS_clock_gettime          232 
#define	SYS_clock_settime          233 
#define	SYS_clock_getres           234 
#define	SYS_ktimer_create          235 
#define	SYS_ktimer_delete          236 
#define	SYS_ktimer_settime         237 
#define	SYS_ktimer_gettime         238 
#define	SYS_ktimer_getoverrun      239 
#define	SYS_nanosleep              240 
#define	SYS_ffclock_getcounter     241 
#define	SYS_ffclock_setestimate    242 
#define	SYS_ffclock_getestimate    243 
#define	SYS_clock_getcpuclockid2   247 
#define	SYS_ntp_gettime            248 
#define	SYS_minherit               250 
#define	SYS_rfork                  251 
#define	SYS_openbsd_poll           252 
#define	SYS_issetugid              253 
#define	SYS_lchown                 254 
#define	SYS_getdents               272 
#define	SYS_lchmod                 274 
#define	SYS_lutimes                276 
#define	SYS_nstat                  278 
#define	SYS_nfstat                 279 
#define	SYS_nlstat                 280 
#define	SYS_preadv                 289 
#define	SYS_pwritev                290 
#define	SYS_fhopen                 298 
#define	SYS_fhstat                 299 
#define	SYS_modnext                300 
#define	SYS_modstat                301 
#define	SYS_modfnext               302 
#define	SYS_modfind                303 
#define	SYS_kldload                304 
#define	SYS_kldunload              305 
#define	SYS_kldfind                306 
#define	SYS_kldnext                307 
#define	SYS_kldstat                308 
#define	SYS_kldfirstmod            309 
#define	SYS_getsid                 310 
#define	SYS_setresuid              311 
#define	SYS_setresgid              312 
#define	SYS_yield                  321 
#define	SYS_mlockall               324 
#define	SYS_munlockall             325 
#define	SYS___getcwd               326 
#define	SYS_sched_setparam         327 
#define	SYS_sched_getparam         328 
#define	SYS_sched_setscheduler     329 
#define	SYS_sched_getscheduler     330 
#define	SYS_sched_yield            331 
#define	SYS_sched_get_priority_max 332 
#define	SYS_sched_get_priority_min 333 
#define	SYS_sched_rr_get_interval  334 
#define	SYS_utrace                 335 
#define	SYS_kldsym                 337 
#define	SYS_jail                   338 
#define	SYS_sigprocmask            340 
#define	SYS_sigsuspend             341 
#define	SYS_sigpending             343 
#define	SYS_sigtimedwait           345 
#define	SYS_sigwaitinfo            346 
#define	SYS___acl_get_file         347 
#define	SYS___acl_set_file         348 
#define	SYS___acl_get_fd           349 
#define	SYS___acl_set_fd           350 
#define	SYS___acl_delete_file      351 
#define	SYS___acl_delete_fd        352 
#define	SYS___acl_aclcheck_file    353 
#define	SYS___acl_aclcheck_fd      354 
#define	SYS_extattrctl             355 
#define	SYS_extattr_set_file       356 
#define	SYS_extattr_get_file       357 
#define	SYS_extattr_delete_file    358 
#define	SYS_getresuid              360 
#define	SYS_getresgid              361 
#define	SYS_kqueue                 362 
#define	SYS_kevent                 363 
#define	SYS_extattr_set_fd         371 
#define	SYS_extattr_get_fd         372 
#define	SYS_extattr_delete_fd      373 
#define	SYS___setugid              374 
#define	SYS_eaccess                376 
#define	SYS_nmount                 378 
#define	SYS___mac_get_proc         384 
#define	SYS___mac_set_proc         385 
#define	SYS___mac_get_fd           386 
#define	SYS___mac_get_file         387 
#define	SYS___mac_set_fd           388 
#define	SYS___mac_set_file         389 
#define	SYS_kenv                   390 
#define	SYS_lchflags               391 
#define	SYS_uuidgen                392 
#define	SYS_sendfile               393 
#define	SYS_mac_syscall            394 
#define	SYS_getfsstat              395 
#define	SYS_statfs                 396 
#define	SYS_fstatfs                397 
#define	SYS_fhstatfs               398 
#define	SYS___mac_get_pid          409 
#define	SYS___mac_get_link         410 
#define	SYS___mac_set_link         411 
#define	SYS_extattr_set_link       412 
#define	SYS_extattr_get_link       413 
#define	SYS_extattr_delete_link    414 
#define	SYS___mac_execve           415 
#define	SYS_sigaction              416 
#define	SYS_sigreturn              417 
#define	SYS_getcontext             421 
#define	SYS_setcontext             422 
#define	SYS_swapcontext            423 
#define	SYS_swapoff                424 
#define	SYS___acl_get_link         425 
#define	SYS___acl_set_link         426 
#define	SYS___acl_delete_link      427 
#define	SYS___acl_aclcheck_link    428 
#define	SYS_sigwait                429 
#define	SYS_thr_create             430 
#define	SYS_thr_exit               431 
#define	SYS_thr_self               432 
#define	SYS_thr_kill               433 
#define	SYS__umtx_lock             434 
#define	SYS__umtx_unlock           435 
#define	SYS_jail_attach            436 
#define	SYS_extattr_list_fd        437 
#define	SYS_extattr_list_file      438 
#define	SYS_extattr_list_link      439 
#define	SYS_thr_suspend            442 
#define	SYS_thr_wake               443 
#define	SYS_kldunloadf             444 
#define	SYS_audit                  445 
#define	SYS_auditon                446 
#define	SYS_getauid                447 
#define	SYS_setauid                448 
#define	SYS_getaudit               449 
#define	SYS_setaudit               450 
#define	SYS_getaudit_addr          451 
#define	SYS_setaudit_addr          452 
#define	SYS_auditctl               453 
#define	SYS__umtx_op               454 
#define	SYS_thr_new                455 
#define	SYS_sigqueue               456 
#define	SYS_abort2                 463 
#define	SYS_thr_set_name           464 
#define	SYS_rtprio_thread          466 
#define	SYS_pread                  475 
#define	SYS_pwrite                 476 
#define	SYS_mmap                   477 
#define	SYS_lseek                  478 
#define	SYS_truncate               479 
#define	SYS_ftruncate              480 
#define	SYS_thr_kill2              481 
#define	SYS_shm_open               482 
#define	SYS_shm_unlink             483 
#define	SYS_cpuset                 484 
#define	SYS_cpuset_setid           485 
#define	SYS_cpuset_getid           486 
#define	SYS_cpuset_getaffinity     487 
#define	SYS_cpuset_setaffinity     488 
#define	SYS_faccessat              489 
#define	SYS_fchmodat               490 
#define	SYS_fchownat               491 
#define	SYS_fexecve                492 
#define	SYS_fstatat                493 
#define	SYS_futimesat              494 
#define	SYS_linkat                 495 
#define	SYS_mkdirat                496 
#define	SYS_mkfifoat               497 
#define	SYS_mknodat                498 
#define	SYS_openat                 499 
#define	SYS_readlinkat             500 
#define	SYS_renameat               501 
#define	SYS_symlinkat              502 
#define	SYS_unlinkat               503 
#define	SYS_posix_openpt           504 
#define	SYS_jail_get               506 
#define	SYS_jail_set               507 
#define	SYS_jail_remove            508 
#define	SYS_closefrom              509 
#define	SYS_lpathconf              513 
#define	SYS_cap_new                514 
#define	SYS___cap_rights_get       515 
#define	SYS_cap_getrights          515 
#define	SYS_cap_enter              516 
#define	SYS_cap_getmode            517 
#define	SYS_pdfork                 518 
#define	SYS_pdkill                 519 
#define	SYS_pdgetpid               520 
#define	SYS_pselect                522 
#define	SYS_getloginclass          523 
#define	SYS_setloginclass          524 
#define	SYS_rctl_get_racct         525 
#define	SYS_rctl_get_rules         526 
#define	SYS_rctl_get_limits        527 
#define	SYS_rctl_add_rule          528 
#define	SYS_rctl_remove_rule       529 
#define	SYS_posix_fallocate        530 
#define	SYS_posix_fadvise          531 
#define	SYS_wait6                  532 
#define	SYS_cap_rights_limit       533 
#define	SYS_bindat                 538 
#define	SYS_connectat              539 
#define	SYS_chflagsat              540 
#define	SYS_accept4                541 
#define	SYS_pipe2                  542 
#define	SYS_procctl                544 
#define	SYS_ppoll                  545 
#define	SYS_futimens               546 
#define	SYS_utimensat              547 

// func exitThread(wait *uint32)
TEXT runtime·exitThread(SB),NOSPLIT|NOFRAME,$0-8
	MOVD	wait+0(FP), R1
	// We're done using the stack.
	MOVW	$0, R2
	SYNC
	MOVW	R2, (R1)
	MOVW	$0, R3	// exit code
	SYSCALL	$SYS_exit
	JMP	0(PC)

TEXT runtime·open(SB),NOSPLIT|NOFRAME,$0-20
	MOVD	name+0(FP), R3
	MOVW	mode+8(FP), R4
	MOVW	perm+12(FP), R5
	SYSCALL	$SYS_open
	BVC	2(PC)
	MOVW	$-1, R3
	MOVW	R3, ret+16(FP)
	RET

TEXT runtime·closefd(SB),NOSPLIT|NOFRAME,$0-12
	MOVW	fd+0(FP), R3
	SYSCALL	$SYS_close
	BVC	2(PC)
	MOVW	$-1, R3
	MOVW	R3, ret+8(FP)
	RET

TEXT runtime·write1(SB),NOSPLIT|NOFRAME,$0-28
	MOVD	fd+0(FP), R3
	MOVD	p+8(FP), R4
	MOVW	n+16(FP), R5
	SYSCALL	$SYS_write
	BVC	2(PC)
	NEG	R3	// caller expects negative errno
	MOVW	R3, ret+24(FP)
	RET

TEXT runtime·read(SB),NOSPLIT|NOFRAME,$0-28
	MOVW	fd+0(FP), R3
	MOVD	p+8(FP), R4
	MOVW	n+16(FP), R5
	SYSCALL	$SYS_read
	BVC	2(PC)
	NEG	R3	// caller expects negative errno
	MOVW	R3, ret+24(FP)
	RET

// func pipe() (r, w int32, errno int32)
TEXT runtime·pipe(SB),NOSPLIT|NOFRAME,$0-12
	ADD	$FIXED_FRAME, R1, R3
	SYSCALL	$SYS_pipe
	MOVW	R3, errno+8(FP)
	RET

// func pipe2(flags int32) (r, w int32, errno int32)
TEXT runtime·pipe2(SB),NOSPLIT|NOFRAME,$0-20
	ADD	$FIXED_FRAME+8, R1, R3
	MOVW	flags+0(FP), R4
	SYSCALL	$SYS_pipe2
	MOVW	R3, errno+16(FP)
	RET

TEXT runtime·usleep(SB),NOSPLIT,$16-4
	MOVW	usec+0(FP), R3
	MOVD	R3, R5
	MOVW	$1000000, R4
	DIVD	R4, R3
	MOVD	R3, 8(R1)
	MOVW	$1000, R4
	MULLD	R3, R4
	SUB	R4, R5
	MOVD	R5, 16(R1)

	// nanosleep(&ts, 0)
	ADD	$8, R1, R3
	MOVW	$0, R4
	SYSCALL	$SYS_nanosleep
	RET

TEXT runtime·setitimer(SB),NOSPLIT|NOFRAME,$0-24
	MOVW	mode+0(FP), R3
	MOVD	new+8(FP), R4
	MOVD	old+16(FP), R5
	SYSCALL	$SYS_setitimer
	RET

TEXT runtime·sigfwd(SB),NOSPLIT,$0-32
	MOVW	sig+8(FP), R3
	MOVD	info+16(FP), R4
	MOVD	ctx+24(FP), R5
	MOVD	fn+0(FP), R12
	MOVD	R12, CTR
	BL	(CTR)
	MOVD	24(R1), R2
	RET

TEXT runtime·sigreturn(SB),NOSPLIT,$0-0
	RET

TEXT runtime·sigprofNonGoWrapper<>(SB),NOSPLIT,$0
	// We're coming from C code, set up essential register, then call sigprofNonGo.
	CALL	runtime·reginit(SB)
	CALL	runtime·sigprofNonGo(SB)
	RET

TEXT runtime·mmap(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), R3
	MOVD	n+8(FP), R4
	MOVW	prot+16(FP), R5
	MOVW	flags+20(FP), R6
	MOVW	fd+24(FP), R7
	MOVW	off+28(FP), R8

	SYSCALL	$SYS_mmap
	BVC	ok
	MOVD	$0, p+32(FP)
	MOVD	R3, err+40(FP)
	RET
ok:
	MOVD	R3, p+32(FP)
	MOVD	$0, err+40(FP)
	RET

TEXT runtime·munmap(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), R3
	MOVD	n+8(FP), R4
	SYSCALL	$SYS_munmap
	BVC	2(PC)
	MOVD	R0, 0xf0(R0)
	RET

TEXT runtime·madvise(SB),NOSPLIT|NOFRAME,$0
	MOVD	addr+0(FP), R3
	MOVD	n+8(FP), R4
	MOVW	flags+16(FP), R5
	SYSCALL	$SYS_madvise
	MOVW	R3, ret+24(FP)
	RET

TEXT runtime·cpuset_getaffinity(SB),NOSPLIT|NOFRAME,$0
	MOVD	pid+0(FP), R3
	MOVD	len+8(FP), R4
	MOVD	buf+16(FP), R5
	SYSCALL	$SYS_cpuset_getaffinity
	BVC	2(PC)
	NEG	R3	// caller expects negative errno
	MOVW	R3, ret+24(FP)
	RET

// void runtime·closeonexec(int32 fd);
TEXT runtime·closeonexec(SB),NOSPLIT|NOFRAME,$0
	MOVW    fd+0(FP), R3  // fd
	MOVD    $2, R4  // F_SETFD
	MOVD    $1, R5  // FD_CLOEXEC
	SYSCALL	$SYS_fcntl
	RET

// func runtime·setNonblock(int32 fd)
//TEXT runtime·setNonblock(SB),NOSPLIT|NOFRAME,$0-4
TEXT runtime·setNonblock(SB),NOSPLIT|NOFRAME,$0
	MOVW	fd+0(FP), R3 // fd
	MOVD	$3, R4	// F_GETFL
	MOVD	$0, R5
	SYSCALL	$SYS_fcntl
	OR	$0x800, R3, R5 // O_NONBLOCK
	MOVW	fd+0(FP), R3 // fd
	MOVD	$4, R4	// F_SETFL
	SYSCALL	$SYS_fcntl
	RET

// int32 runtime·kqueue(void);
TEXT runtime·kqueue(SB),NOSPLIT,$0
	SYSCALL	$SYS_kqueue
	MOVW	R3, ret+0(FP)
	RET

// int32 runtime·kevent(int kq, Kevent *changelist, int nchanges, Kevent *eventlist, int nevents, Timespec *timeout);
TEXT runtime·kevent(SB),NOSPLIT,$0
	MOVW	kq+0(FP), R3
	MOVD	ch+8(FP), R4
	MOVW	nch+16(FP), R5
	MOVD	ev+24(FP), R6
	MOVW	nev+32(FP), R7
	MOVD	ts+40(FP), R8
	SYSCALL $SYS_kevent
	NEG	R3	// caller expects negative errno
	MOVW	R3, ret+48(FP)
	RET

//TEXT runtime·osyield(SB),NOSPLIT,$-4
TEXT runtime·osyield(SB),NOSPLIT,$0
	SYSCALL $SYS_sched_yield
	RET

TEXT runtime·sysctl(SB),NOSPLIT,$0
	MOVD	mib+0(FP), R3		// arg 1 - name
	MOVW	miblen+8(FP), R4		// arg 2 - namelen
	MOVD	out+16(FP), R5		// arg 3 - oldp
	MOVD	size+24(FP), R6		// arg 4 - oldlenp
	MOVD	dst+32(FP), R7		// arg 5 - newp
	MOVD	ndst+40(FP), R8		// arg 6 - newlen
	SYSCALL $SYS___sysctl
  NEG	R3
	MOVD	R3, ret+48(FP)
	RET

TEXT runtime·sys_umtx_op(SB),NOSPLIT,$0
	MOVD addr+0(FP), R3
	MOVW mode+8(FP), R4
	MOVW val+12(FP), R5
	MOVD uaddr1+16(FP), R6
	MOVD ut+24(FP), R7
	SYSCALL $SYS__umtx_op
	MOVD	R3, ret+32(FP)
	RET

TEXT runtime·sigprocmask(SB),NOSPLIT,$0-24
	MOVW	how+0(FP), R3
	MOVD	new+8(FP), R4
	MOVD	old+16(FP), R5
	SYSCALL $SYS_sigprocmask
	RET

TEXT runtime·thr_new(SB),NOSPLIT,$0-24
	MOVD param+0(FP), R3
	MOVW size+8(FP), R4
	SYSCALL $SYS_thr_new
	MOVD	R3, ret+16(FP)
	RET

TEXT runtime·thr_self(SB),NOSPLIT,$0-8
	// thr_self(&0(FP))
	MOVD $ret+0(FP), R3
//	MOVD	$ptr-8(SP), R3	// arg 1 &8(SP)
	SYSCALL $SYS_thr_self
//	MOVD	ptr-8(SP), R3
//	MOVD	R3, ret+0(FP)
	RET

TEXT runtime·thr_kill(SB),NOSPLIT,$0-16
	// thr_kill(tid, sig)
	MOVD	tid+0(FP), R3	// arg 1 id
	MOVD	sig+8(FP), R4	// arg 2 sig
	SYSCALL $SYS_thr_kill
	RET

TEXT runtime·sigaltstack(SB),NOSPLIT,$-8
	MOVD	new+0(FP), R3
	MOVD	old+8(FP), R4
	SYSCALL $SYS_sigaltstack
	BVC	2(PC)
	MOVD	R0, 0xf0(R0)  // crash
	RET

TEXT runtime·asmSigaction(SB),NOSPLIT,$0-24
	MOVD	sig+0(FP), R3		// arg 1 sig
	MOVD	new+8(FP), R4		// arg 2 act
	MOVD	old+16(FP), R5		// arg 3 oact
	SYSCALL $SYS_sigaction
	BVC	2(PC)
	NEG	R3	// caller expects negative errno
	MOVD	R3, ret+24(FP)
	RET

TEXT runtime·exit(SB),NOSPLIT|NOFRAME,$0-4
	MOVW	code+0(FP), R3
	SYSCALL	$SYS_exit
	RET

TEXT runtime·raiseproc(SB),NOSPLIT|NOFRAME,$0
	SYSCALL	$SYS_getpid
	MOVW	R3, R3	// arg 1 pid
	MOVW	sig+0(FP), R4	// arg 2
	SYSCALL	$SYS_kill
	RET

//TEXT runtime·fallback_walltime(SB), NOSPLIT, $32-12
//    MOVD $0, R3
//    MOVD $e+8(FP), R4
//  	SYSCALL $SYS_clock_gettime
//	  MOVD	e+8(FP), R3
//	  MOVD	e(FP), R4
//	  RET

TEXT runtime·fallback_walltime(SB), NOSPLIT, $32-12
    MOVD $0, R3
    MOVD $FIXED_FRAME+0(R1), R4
  	SYSCALL $SYS_clock_gettime
	  MOVD	FIXED_FRAME+0(R1), R3
	  MOVD	FIXED_FRAME+8(R1), R5
	  MOVD	R3, sec+0(FP)
	  MOVW	R5, nsec+8(FP)
	  RET

//TEXT runtime·fallback_nanotime(SB), NOSPLIT, $32-8
//	MOVD	$CLOCK_MONOTONIC, R3
//  MOVD $e+8(FP), R4
//	SYSCALL	$SYS_clock_gettime
//	MOVD	e+8(FP), R3
//	MOVD	e(FP), R4
//	RET

TEXT runtime·fallback_nanotime(SB), NOSPLIT, $32-8
	MOVD	$CLOCK_MONOTONIC, R3
  MOVD $FIXED_FRAME+0(R1), R4
  SYSCALL $SYS_clock_gettime
  MOVD	FIXED_FRAME+0(R1), R3
  MOVD	FIXED_FRAME+8(R1), R5
	MOVD	$1000000000, R4
	MULLD	R4, R3
	ADD	R5, R3
	MOVD	R3, ret+0(FP)
  RET

//TEXT runtime·sigtramp(SB),NOSPLIT|NOFRAME,$0
TEXT runtime·sigtramp(SB),NOSPLIT,$24
	// initialize essential registers (just in case)
	BL	runtime·reginit(SB)

	// this might be called in external code context,
	// where g is not set.
	MOVBZ	runtime·iscgo(SB), R6
	CMP 	R6, $0
	BEQ	2(PC)
	BL	runtime·load_g(SB)

//	MOVW R3, sig-24(SP)
//	MOVD R4, info-16(SP)
//	MOVD R5, ctx-8(SP)
//	CALL	runtime·sigtrampgo(SB)
	MOVW	R3, FIXED_FRAME+0(R1)
	MOVD	R4, FIXED_FRAME+8(R1)
	MOVD	R5, FIXED_FRAME+16(R1)
	MOVD	$runtime·sigtrampgo(SB), R12
	MOVD	R12, CTR
	BL	(CTR)
	MOVD	24(R1), R2
	RET

//TEXT runtime·sigtramp(SB),NOSPLIT,$72
  //MOVD R3, r3-8(SP)
  //MOVD R4, r4-16(SP)
  //MOVD R5, r5-24(SP)
  //MOVD R6, r6-32(SP)
  //MOVD R7, r7-40(SP)
  //MOVD R8, r8-48(SP)
  //MOVD R9, ctx-56(SP)
  //MOVD R10, info-64(SP)
  //MOVD R11, signum-72(SP)
	//CALL	runtime·sigtrampgo(SB)
	//MOVD	r8-48(SP), R8
	//MOVD	r7-40(SP), R7
	//MOVD	r6-32(SP), R6
	//MOVD	r5-24(SP), R5
	//MOVD	r4-16(SP), R4
	//MOVD	r3-8(SP), R3
	//RET

TEXT emptyfunc<>(SB),0,$0-0
	RET

TEXT runtime·thr_start(SB),NOSPLIT,$0
// 	// set up g
// 	MOVD g, R6
// 	MOVD g_m, R6
// 	MOVD	g_m(g), R6 // R6 = m
// 
// 	MOVD	m_g0(R0), g
// 	MOVD	R0, g_m(g)
// 	BL	emptyfunc<>(SB)	 // fault if stack check is wrong
// 	BL	runtime·mstart(SB)
// 	MOVD	$2, R8	// crash (not reached)
// 	MOVD	R8, (R8)
// 	RET
  XOR  R0, R0 // reset R0 
  // set g                                                                                                                                                                                                                                 
  MOVD  m_g0(R3), g                                                                                                                                                                                                                        
  BL    runtime·save_g(SB)                                                                                                                                                                                                                  
  MOVD  R3, g_m(g)                                                                                                                                                                                                                         
                                                                                                                                                                                                                                           
  // Layout new m scheduler stack on os stack.                                                                                                                                                                                             
  //MOVD  R1, R3                                                                                                                                                                                                                             
//  MOVD  R3, (g_stack+stack_hi)(g)                                                                                                                                                                                                          
//  SUB $(const_threadStackSize), R3    // stack size                                                                                                                                                                                        
//   MOVD  R3, (g_stack+stack_lo)(g)                                                                                                                                                                                                          
//   ADD $const__StackGuard, R3                                                                                                                                                                                                               
//   MOVD  R3, g_stackguard0(g)                                                                                                                                                                                                               
//   MOVD  R3, g_stackguard1(g)                                                                                                                                                                                                               
                                                                                                                                                                                                                                           
 	BL	emptyfunc<>(SB)	 // fault if stack check is wrong
  BL  runtime·mstart(SB)                                                                                                                                                                                                                  
                                                                                                                                                                                                                                           
  MOVD R0, R3                                                                                                                                                                                                                              
  RET                                                                                                                                                                                                                                      

