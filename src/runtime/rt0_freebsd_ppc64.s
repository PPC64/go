#include "textflag.h"

TEXT _rt0_ppc64_freebsd(SB),NOSPLIT,$-8
	MOVD	$runtime·rt0_go(SB), R12
	MOVD	R12, CTR
	MOVBZ	runtime·iscgo(SB), R5
	CMP	R5, $0
	BEQ	nocgo
	BR	(CTR)
nocgo:
//	MOVD	0(R1), R3 // argc
//	ADD	$8, R1, R4 // argv
	BR	(CTR)
