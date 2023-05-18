/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
/*------------------------------------------------------------------------
    File        : TranslationLoggerBuilder
    Purpose     : Builds a custom logger for translations
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Example.Filters.TranslatedMessageFormat.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.Writer.NamedFileWriter.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.URI.

class Example.Builders.TranslationLoggerBuilder inherits LoggerBuilder:
    /* Constructor */
    constructor public TranslationLoggerBuilder(input pLoggerType as character):
        super(pLoggerType).
    end method.

    /* Constructs the actual logger instance
       
       @return ILogWriter A new or cached logged */
    method override protected ILogWriter GetLoggerInstance():
        define variable filterList as ILoggerFilter extent 2 no-undo.
        define variable tmf as TranslatedMessageFormat no-undo.

        /* Let's say we only a translation for this group of loggers */
        assign tmf                    = new TranslatedMessageFormat()
               tmf:To                 = entry(2, this-object:LoggerType, '.')
               tmf:ApiKey             = '11bee17b7b9a42b0be976094f6a74ca8'
               tmf:Region             = 'eastus'
               tmf:TranslationService = URI:Parse('https://api.cognitive.microsofttranslator.com/translate?api-version=3.0')
               
               filterList[1]          = tmf
               filterList[2]          = new NamedFileWriter(session:temp-dir + 'translations-only.log', true)
               .

        return new Logger(this-object:LoggerType, LogLevelEnum:Trace, filterList).
    end method.

end class.