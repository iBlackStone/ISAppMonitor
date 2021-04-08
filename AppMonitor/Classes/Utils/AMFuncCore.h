//
//  AMFuncCore.h
//  Prepare
//
//  Created by GL on 2021/4/4.
//

#ifndef AMFuncCore_h
#define AMFuncCore_h

#include <stdio.h>
#include <objc/objc.h>

typedef struct {
    __unsafe_unretained Class cls;
    SEL sel;
    uint64_t time; // us (1/1000 ms)
    int depth;
} CallRecord;

extern void CallTraceStart(void);
extern void CallTraceStop(void);

extern void CallConfigMinTime(uint64_t us); //default 1000
extern void CallConfigMaxDepth(int depth);  //default 3

extern CallRecord *GetCallRecords(int *num);
extern void ClearCallRecords(void);

#endif /* AMFuncCore_h */
