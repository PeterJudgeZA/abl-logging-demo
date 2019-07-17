/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : ElasticSearchWriterBuilder
    Purpose     : Builds a ElasticSearchWriter logging filter 
    Author(s)   : pjudge
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Filters.ElasticSearchWriter.
using OpenEdge.Core.Assert.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Net.URI.

class Example.Builders.ElasticSearchWriterBuilder inherits LogFilterBuilder: 
    /* Constructor */
    constructor public ElasticSearchWriterBuilder(input filterName as character):
        super(filterName).
    end method.
    
    /* Creates the instance.
       
       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter(  ):
        define variable logFilter as ILoggerFilter no-undo.
        define variable esw as ElasticSearchWriter no-undo.
        
        // Use the default for most of the stuff
        assign logFilter = super:NewFilter().
        
        Assert:IsType(logFilter, get-class(ElasticSearchWriter)).
        
        assign esw           = cast(logFilter, ElasticSearchWriter)
               esw:ServiceURI = URI:Parse(GetOptionStringValue('serviceURI':u))
               .
        if HasOption('indexName':u) then
            assign esw:IndexName = GetOptionStringValue('indexName':u).
        
        return logFilter.
    end method.
    
end class.