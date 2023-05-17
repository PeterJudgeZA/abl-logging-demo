/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : logger_simple.p
    Author(s)   : pjudge
    Created     : 2023-05-16
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.ILogWriter.

using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.

/* ***************************  Main Block  *************************** */
define variable logger as ILogWriter no-undo.

/* Need to turn the LOG-MANAGER off since the ABL plugin uses it */
log-manager:close-log().
log-manager:logfile-name = ?.

logger = LoggerBuilder:GetLogger('has.no.config').

message
    logger skip
    logger:LogLevel skip
    logger:Name skip(2)
    log-manager:logfile-name
view-as alert-box.

logger:Info('Do geese see God').
logger:Info('A message with some tokens $~{t.now} or even $~{mdc.myName} ').
logger:Trace('And you are? $~{mdc.whoAreYou} ').
logger:Fatal('Flaw').

int('abc').

catch e as Progress.Lang.Error :
    logger:Error('caught one!', e).
end catch.
