Implementation of [jsend](https://github.com/omniti-labs/jsend) specification in dart. Simply putting, jsend is a specification that tells how JSON responses coming from server should be structured.

## Using

    import 'package:jsend/jsend.dart';

    // ... some code

    var someHTTPResponse = await http.get('https://api-that-gives-json-response');

    // obtained HTTP Response can be parsed to jsend Response as

    var jsendResp = jsendResponse(someHTTPResponse);

    // Even Easier Now. jsendResponse object can be created from APIRequest object as:

    APIRequest.base = 'https://jsonplaceholder.typicode.com/';
    jsendResponse.fromAPIRequest(APIRequest(
        path: '/users'
    )) ;


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


## Status Handlers

Status handling can be done in declarative programming style. Since we are lazy and dont like this type of code:

    ...

    if(jsendResp.status == 'success'){
        // do something
    }else if(jsendResp.status == 'error'){
        // do another thing
    }else {
        // do some other thing
    }

    ...

This package helps us by assigning the status handlers in constructor of jsendResponse as:

    ...
    jsendResponse.fromAPIRequest(APIRequest(
            path: '/users'
        ),
        onSuccess: (jsendResponse resp){
            print('Fetched Successfully') ;
            print(resp.data) ;
        },
        onError: (_){
            print("failed") ;
        }
    ) ;


## RemoteResource class might surprise you

See how easily I perform CRUD operations on data on server.

    //setting API Base first
    APIRequset.base = 'http://your-server/api/' ;

    //Creating RemoteResource instance that fetches from /products
    var productsFetcher = RemoteResource('products') ;


Showing all products

    //mapped to GET /products
    print(await productsFetcher.getAll()) ;

Getting single product

    //mapped to GET /prdoucts/:product_id
    print(await productsFetcher.get("prdouct_id")) ;

Creating new product

    //mapped to POST /products
    await productsFetcher.createItem({name: 'Apple', price: 34}) ;


Worried about handling validation Errors from server ? You can easily handle them as:

    await productsFetcher.createItem({...}, statusHanlders: JsendStatusHandlers(
        forError: (jsendResponse resp){...},
        forSuccess: (jsendResponse resp){...},
        forFail: (jsendResponse resp){
            if(resp.hasErrorIn('name')){
                print('Response contains error in name: ' + resp.errorIn('name')) ;
            }
        }
    ))

statusHandlers can be applied to all methods of RemoteResource

Updating Product

    // mapped to PUT /products/:product_id
    await productsFetcher.updateItem({_id: 'id', ...});

Deleting Product

    //mapped to DELETE /products/:product_id
    await productsFetcher.deleteItem({_id: 'id',...}, statusHandlers: JsendStatusHandlers(
        forSuccess: (_){
            print("Deleted Successfully.") ;
        }
    ));




