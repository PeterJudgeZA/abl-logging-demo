/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : PerRequestWriter
    Purpose     : Reverses the words in the log message 
    Author(s)   : pjudge
    Created     : 2023-05-16
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Core.Util.TokenResolverEventArgs.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using Progress.Lang.* from propath.
using OpenEdge.Logging.Writer.NamedFileWriter.

class Example.Filters.PerRequestWriter implements ILoggerFilter:
    
    method public void ExecuteFilter( input poEvent as LogEvent):
        define variable fileName as character no-undo.
        define variable nfw as ILoggerFilter no-undo.

        TokenResolver:TokenResolved:Subscribe(this-object:TokenResolvedHandler).

        fileName = TokenResolver:Resolve('$~{session.temp-dir}/request-$~{req.id}.log').

        /* If not run on PASOE, there will be no request id, and the token will not resolve */
        if index(fileName, StringConstant:CURLY_OPEN) = 0 then do:
            nfw = new NamedFileWriter(filename, true).
            nfw:ExecuteFilter(poEvent).
        end.

        finally:
            TokenResolver:TokenResolved:Unsubscribe(this-object:TokenResolvedHandler).
        end finally.
    end method.

    method public void TokenResolvedHandler(input pSender as Progress.Lang.Object,
                                            input pArgs as TokenResolverEventArgs):
        define variable cri as OERequestInfo no-undo.

        if pArgs:TokenGroup = "req" and pArgs:TokenArg= "id" then do:
            cri = session:current-request-info.
            if valid-object(cri) then
                pArgs:TokenValue = replace(cri:RequestId, ':', '').
        end.
    end method.
    
end class.
