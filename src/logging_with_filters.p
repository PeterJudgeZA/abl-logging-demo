/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : test_reverse_word_format.p
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.ILogWriter.

using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.MDC.

/* ***************************  Main Block  *************************** */
define variable logger as ILogWriter no-undo.

//logger = LoggerBuilder:GetLogger('send.to.elastic.search').
//logger = LoggerBuilder:GetLogger('should.be.void').
//logger = LoggerBuilder:GetLogger('one.with.reversed.words').
//logger = LoggerBuilder:GetLogger('one.with.tokens').
logger = LoggerBuilder:GetLogger('one').

message 
    logger skip
    logger:LogLevel skip
    logger:Name    
view-as alert-box.

OpenEdge.Logging.MDC:Put('myName', 'Michael Caine').
OpenEdge.Logging.MDC:Put('whoAreYou', ?).

logger:Info('this should be backwards').
logger:Info('Do geese see God').
logger:Info('A message with some tokens $~{t.now} or even $~{mdc.myName} ').
logger:Trace('And you are? $~{mdc.whoAreYou} ').
logger:Fatal('Flaw').

int('abc').

catch e as Progress.Lang.Error :
    logger:Error('caught one!', e).
end catch.








