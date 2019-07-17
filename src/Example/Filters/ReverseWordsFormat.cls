/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : ReverseWordsFormat
    Purpose     : Reverses the words in the log message 
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.StringConstant.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.

class Example.Filters.ReverseWordsFormat implements ILoggerFilter: 
    
    method public void ExecuteFilter( input poEvent as LogEvent):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable newMessage as character no-undo.
        
        assign cnt = num-entries(poEvent:Message:Message, StringConstant:SPACE).
        do loop = cnt to 1 by -1:
            assign newMessage = newMessage
                              + entry(loop, poEvent:Message:Message, StringConstant:SPACE)
                              + StringConstant:SPACE.
        end.
        
        assign poEvent:Message:Message = newMessage.
    end method.
    
end class.