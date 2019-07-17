/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
 /*------------------------------------------------------------------------
    File        : ElasticSearchWriter
    Purpose     : Writer for Elastic Search 
    Author(s)   : pjudge
    Created     : 2018-05-07
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Util.Token.
using Progress.Lang.Object.

class Example.Filters.ElasticSearchWriter implements ILoggerFilter:
    
    /* The translation service URI */
    define public property ServiceURI as URI no-undo
        get.
        set.
    
    /* The Elastic Search index name. Defaults to the LoggerName */
    define public property IndexName as character no-undo initial ?
        get.
        set.
    
    // reusable HTTP client
    define private variable httpClient as IHttpClient no-undo.
    
    /* Default constructor */
    constructor public ElasticSearchWriter():
        assign httpClient = ClientBuilder:Build():Client.
    end constructor.
    
    method public void ExecuteFilter(input poEvent as LogEvent):
        define variable indexURI as URI no-undo.
        define variable req as IHttpRequest no-undo.
        define variable logData as JsonObject no-undo.
        define variable msgData as JsonObject no-undo.
        define variable entryData as JsonObject no-undo.
        define variable arrData as JsonArray no-undo.
        define variable jw as JsonEntityWriter no-undo.
        define variable tokenCtx as Object no-undo.
        define variable iter as IIterator no-undo.
        
        assign logData = new JsonObject()
               msgData = new JsonObject()
               .
        logData:Add('loggerName':u, poEvent:LoggerName).
        logData:Add('logLevel':u,   string(poEvent:LogLevel)).
        logData:Add('timeStamp':u,  poEvent:TimeStamp).
        logData:Add('callStack':u,  new JsonArray(poEvent:CallStack)).
        
        // errors
        if valid-object(poEvent:Error) then
        do:
            assign jw = new JsonEntityWriter().
            jw:Open().
            jw:Write(poEvent:Error).
            jw:Close().
            
            logData:Add('error':u, cast(jw:Entity, JsonObject)).
        end.
        else
            logData:AddNull('error':u).
        
        if valid-handle(poEvent:LoggedBy) then
            logData:Add('loggedBy':u, poEvent:LoggedBy:qualified-user-id).
        else
            logData:AddNull('loggedBy':u).
        
        logData:Add('loggerShortName':u, poEvent:LoggerShortName).
        logData:Add('shortNameFormat':u, poEvent:ShortNameFormat).
        logData:Add('message':u, msgData).
            msgData:Add('groupName':u, poEvent:Message:GroupName).
            msgData:Add('baseText':u,  poEvent:Message:BaseText).
            msgData:Add('msgText':u,   poEvent:Message:Message).
        
        assign tokenCtx = poEvent:Message:GetContext('tokens':u).
        if     valid-object(tokenCtx) 
           and type-of(tokenCtx, IList)
        then
        do:
            assign iter    = cast(tokenCtx, IList):Iterator()
                   arrData = new JsonArray()
                   .
            msgData:Add('tokens':u, arrData).
            do while iter:HasNext():
                arrData:Add(iter:Next():ToString()).
            end.
        end.
        
        // use POST so that Elasticsearch creates the id
        assign indexURI = new URI(ServiceURI:Scheme, ServiceURI:Host, ServiceURI:Port)
               req      = RequestBuilder:Post(indexURI, logData):Request
               .
        indexURI:AddQuery('pretty':u).
        
        if String:IsNullOrEmpty(IndexName) then
            assign indexURI:Path = substitute('/&1/_doc':u, lc(replace(poEvent:LoggerName, '.':u, '_':u))).
        else
            assign indexURI:Path = substitute('/&1/_doc':u, lc(replace(IndexName, '.':u, '_':u))).
        
        // Send the data
        httpClient:Execute(req).
        
        catch writerError as Progress.Lang.Error :
            // no-op
        end catch.
    end method.

end class.