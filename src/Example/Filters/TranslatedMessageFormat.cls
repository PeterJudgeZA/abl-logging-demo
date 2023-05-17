/** This is free and unencumbered software released into the public domain.
    Anyone is free to copy, modify, publish, use, compile, sell, or
    distribute this software, either in source code form or as a compiled
    binary, for any purpose, commercial or non-commercial, and by any
    means.  **/
 /*------------------------------------------------------------------------
    File        : TranslatedMessageFormat
    Purpose     : Translates the message text
    Author(s)   : pjudge
    Created     : 2018-11-08
    Notes       : * Uses Microsoft Azure's Translation API
                         https://docs.microsoft.com/en-us/azure/cognitive-services/Translator/quickstart-csharp-translate
                  * Request and response payloads are described at
                    https://docs.microsoft.com/en-us/azure/cognitive-services/Translator/reference/v3-0-translate?tabs=curl
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Logging.Filter.ILoggerFilter.
using OpenEdge.Logging.LogEvent.
using OpenEdge.Net.HTTP.ClientBuilder.
using OpenEdge.Net.HTTP.IHttpClient.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.RequestBuilder.
using OpenEdge.Net.URI.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonArray.

class Example.Filters.TranslatedMessageFormat implements ILoggerFilter:

    /* The translation service URI */
    define public property TranslationService as URI no-undo
        get.
        set.

    /* The API key for making requests*/
    define public property ApiKey as character no-undo
        get.
        set.

    /* The Azure region */
    define public property Region as character no-undo
        get.
        set.

    define public property To as character no-undo
        get.
        set.

    // reusable HTTP client
    define variable httpClient as IHttpClient no-undo.

    constructor public TranslatedMessageFormat():
        assign httpClient = ClientBuilder:Build():Client.
    end constructor.

    method public void ExecuteFilter( input poEvent as LogEvent):
        define variable req as IHttpRequest no-undo.
        define variable resp as IHttpResponse no-undo.
        define variable msg as JsonArray no-undo.
        define variable txt as JsonObject no-undo.
        define variable transArray as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.

        TranslationService:AddQuery('to':u, this-object:To).

        assign req        = RequestBuilder:Post(TranslationService)
                                :AddHeader('Ocp-Apim-Subscription-Key':u, ApiKey)
                                :AddHeader('Ocp-Apim-Subscription-Region':u, Region)
                                :AcceptJson()
                                :ContentType('application/json':u)
                                :Request

               msg        = new JsonArray()
               txt        = new JsonObject()
               req:Entity = msg
               .

        txt:Add('Text':u, poEvent:Message:Message).
        msg:Add(txt).

        // send the translation request
        assign resp = httpClient:Execute(req).

        // success
        if type-of(resp:Entity, JsonArray) then
            assign msg  = cast(resp:Entity, JsonArray)

                   transArray = msg:GetJsonObject(1):GetJsonArray('translations':u)
                   cnt        = transArray:Length
                   .
        else
        // failure
        if type-of(resp:Entity, JsonConstruct) then
            cast(resp:Entity, JsonConstruct):WriteFile(session:temp-dir + 'translate.json', true).

        do loop = 1 to cnt:
            assign txt = transArray:GetJsonObject(loop).
            if txt:GetCharacter('to':u) eq this-object:To then
            do:
                assign poEvent:Message:Message = substitute('[&1] &2', this-object:To,txt:GetCharacter('text':u)).
                leave.
            end.
        end.
    end method.

end class.