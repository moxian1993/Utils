//
//  NSObject+Perform.m
//  DictPublishAssistant
//
//  Created by zhuwei on 15/3/6.
//  Copyright (c) 2015年 zhuwei. All rights reserved.
//

#import "NSObject+Perform.h"
#import "objc/runtime.h"

typedef void ( *ImpFuncType )( id a, SEL b, void * c );

@implementation NSObject (Perform)

- (void)performSelectorAlongChain:(SEL)sel
{
    NSMutableArray * classStack = [NSMutableArray array];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack addObject:thisClass];
    }
    
    for ( Class thisClass in classStack )
    {
        ImpFuncType prevImp = NULL;
        
        Method method = class_getInstanceMethod( thisClass, sel );
        
        if ( method )
        {
            ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
            
            if ( imp )
            {
                if ( imp == prevImp )
                {
                    continue;
                }
                
                imp( self, sel, nil );
                
                prevImp = imp;
            }
        }
    }
}

- (void)performSelectorAlongChainReversed:(SEL)sel
{
    NSMutableArray * classStack = [NSMutableArray array];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack insertObject:thisClass atIndex:0];
    }
    
    for ( Class thisClass in classStack )
    {
        ImpFuncType prevImp = NULL;
        
        Method method = class_getInstanceMethod( thisClass, sel );
        
        if ( method )
        {
            ImpFuncType imp = (ImpFuncType)method_getImplementation( method );
            
            if ( imp )
            {
                if ( imp == prevImp )
                {
                    continue;
                }
                
                imp( self, sel, nil );
                
                prevImp = imp;
            }
        }
    }
}

- (void)performMsgSendWithTarget:(id)target sel:(SEL)sel signal:(id)signal
{
    NSMethodSignature * sig = [[target class] instanceMethodSignatureForSelector:sel];
    
    if ( sig )
    {
        NSInvocation * inv = [NSInvocation invocationWithMethodSignature:sig];
        [inv setTarget:target];
        [inv setSelector:sel];
        [inv setArgument:(__bridge void *)(signal) atIndex:2];
        [inv invoke];
    }
}
- (BOOL)performMsgSendWithTarget:(id)target sel:(SEL)sel
{
    NSMethodSignature * sig = [[target class] instanceMethodSignatureForSelector:sel];
    
    if ( sig )
    {
        return YES;
    }
    
    return NO;
}

@end
