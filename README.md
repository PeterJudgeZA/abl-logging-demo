# ABL Logging Demo 
This repo contains examples of filters (writers and formatters) and their builders for the ABL Logging component, in support of the **ABL Logging: From Files to Cloud, with No Code Changes** talk first given at the 2019 SA PUG. The [slides](abl_logging.pdf) are also available in this repo.


## Project structure
The main folders are

Folder | Contents 
---- | ---- 
bin/ | Contains r-code built form the ABL source
src/ |  Contains the ABL sources for filters, builders, test code and the `logging.config` configurations

This code can run on any AVM, as of OpenEdge 11.6.0 (due to the use of enum types).

For the translation and elastic search filters, make sure that `$DLC/tty/netlib/OpenEdge.Net.pl` is on `PROPATH`.

To use the filter(s), update the [configuration file](src/logging.config) as per the filter. The checked-in configuration file has examples of all the filters in it.

Run the test procedure, [src/logging_with_filters.p](src/logging_with_filters.p). The `/src` folder is really all that needs to be on PROPATH.

The session demos 3 filters.


## Reversed words filter
This filter reverses the order of the log message's words.

---- | ---- 
Filter type | Format
Filter class |  `Example.Filters.ReverseWordsFormat` 
Builder class | <none> 

### Configuration
Add a `REVERSED_WORDS_FILTER` to the `filter` property

    "filter": {
        "REVERSED_WORDS_FILTER": "Example.Filters.ReverseWordsFormat"
    }


To use, add a reference into individual loggers' `filters` array.

	"filters": [
		<filter-1>,
		"REVERSED_WORDS_FILTER",
		<filter-n>
 	]



## Translation filter
This filter uses Microsoft Azure's Translation API to translate log messages to a specified language. Doc at (https://docs.microsoft.com/en-us/azure/cognitive-services/Translator/quickstart-csharp-translate). You'll need an account to use this service; free tiers are available.

---- | ---- 
Filter type | Format
Filter class | `Example.Filters.TranslatedMessageFormat`
Builder class | `Example.Builders.TranslatedMessageFormatBuilder`
 
### Configuration
Add a `TRANSLATION_FILTER` to the `filter` property

    "filter": {
        "TRANSLATION_FILTER": {
            "type":    "Example.Filters.TranslatedMessageFormat",
            "builder": "Example.Builders.TranslatedMessageFormatBuilder"
        }

To use, add a reference into individual loggers' `filters` array

	"filters": [
		<filter-1>,
          {
            "name": "TRANSLATION_FILTER",
            "toLang": "af",
            "serviceURI": "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0",
            "apiKey": "<your-api-key-here>"
          },
		<filter-n>
 	]



## Elastic Search filter
This filter writes log messages to a (local) Elastic Search instance. Elastic Search (and other ELK-stack products) can be downloaded and installed from (https://www.elastic.co/start) .

---- | ---- 
Filter type | Writer
Filter class | `Example.Filters.ElasticSearchWriter`
Builder class | `Example.Builders.ElasticSearchWriterBuilder`

### Configuration
Add `ELASTIC_SEARCH_FILTER` to the `filter` property

    "filter": {
        "ELASTIC_SEARCH_WRITER": {
            "type":    "Example.Filters.ElasticSearchWriter",
            "builder": "Example.Builders.ElasticSearchWriterBuilder"
        }


To use, add a reference into individual loggers' `filters` array

	"filters": [
		<filter-1>,
          {
          	"name": "ELASTIC_SEARCH_WRITER",
            "serviceURI": "http://localhost:9200/",
            "indexName": "<an-index-name>"
          }
		<filter-n>
 	]
