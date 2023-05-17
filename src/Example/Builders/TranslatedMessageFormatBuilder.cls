/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : TranslatedMessageFormatBuilder
    Purpose     : Builds a TranslatedMessageFormat logging filter
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Filters.TranslatedMessageFormat.
using OpenEdge.Core.Assert.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Filter.LogFilterBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonObject.

class Example.Builders.TranslatedMessageFormatBuilder inherits LogFilterBuilder:
    /* Constructor */
    constructor public TranslatedMessageFormatBuilder(input filterName as character):
        super(filterName).
    end method.

    /* Creates the instance.

       @return ILoggerFilter A filter instance  */
    method override protected ILoggerFilter NewFilter(  ):
        define variable logFilter as ILoggerFilter no-undo.
        define variable tmf as TranslatedMessageFormat no-undo.

        // Use the default for most of the stuff
        assign logFilter = super:NewFilter().

        Assert:IsType(logFilter, get-class(TranslatedMessageFormat)).

        assign tmf                    = cast(logFilter, TranslatedMessageFormat)
               tmf:To                 = this-object:GetOptionStringValue('toLang':u)
               tmf:ApiKey             = this-object:GetOptionStringValue('apiKey':u)
               tmf:Region             = this-object:GetOptionStringValue('region':u)
               tmf:TranslationService = URI:Parse(this-object:GetOptionStringValue('serviceURI':u))
               .
        return logFilter.
    end method.

end class.