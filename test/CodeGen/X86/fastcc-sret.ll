; RUN: llc < %s -march=x86 -tailcallopt=false | FileCheck %s
; CHECK: ret{{[^4]*$}}

	%struct.foo = type { [4 x i32] }

define fastcc void @bar(%struct.foo* noalias sret %agg.result) nounwind  {
entry:
	%tmp1 = getelementptr %struct.foo* %agg.result, i32 0, i32 0
	%tmp3 = getelementptr [4 x i32]* %tmp1, i32 0, i32 0
	store i32 1, i32* %tmp3, align 8
        ret void
}

@dst = external global i32

define void @foo() nounwind {
	%memtmp = alloca %struct.foo, align 4
        call fastcc void @bar( %struct.foo* sret %memtmp ) nounwind
        %tmp4 = getelementptr %struct.foo* %memtmp, i32 0, i32 0
	%tmp5 = getelementptr [4 x i32]* %tmp4, i32 0, i32 0
        %tmp6 = load i32* %tmp5
        store i32 %tmp6, i32* @dst
        ret void
}
