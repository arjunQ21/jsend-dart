Implementation of [jsend](https://github.com/omniti-labs/jsend) specification in dart. Simply putting, jsend is a specification that tells how JSON responses coming from server should be structured.

## Using

    import 'package:jsend/jsend.dart';

    // ... your code

    var someHTTPResponse = await http.get('https://api-that-gives-json-response');

    // obtained HTTP Response can be parsed to jsend Response as

    var jsendResp = jsendResponse(someHTTPResponse);

## Getting status, message and data

    //status
    jsendResp.status

    //message
    jsendResp.message

    //data
    jsendResp.data

## Handling validation errors in fields

By jsend standard, we send validation errors in data field. This package contains some helper methods to read errors in fields.

    //checking if errors exist in a field

    if(jsendResp.hasErrorIn('email')){
        // executed if errors exist in email field
    }

    //getting errors in a field
    var errorInEmail = jsendResp.errorIn('email') ;
    // returns null in case no errors exist.


Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).