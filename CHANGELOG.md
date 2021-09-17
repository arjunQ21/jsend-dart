## 1.0.0

- Initial version, created by Stagehand

## 1.0.1-pre-release

- Added api base in APIRequest

## 1.0.2-pre-release

- Moved to lib folder

## 1.0.3

- Added jsendResponse.fromAPIRequest
- Added onError, onSuccess and onFail handlers to jsendResponse object's constructor
- Added toString method to jsendResponse

## 1.0.4

- JsendStatusHandlers can be passed in through constructor
- Multiple status handlers for same status can now be run. For example, for success, they can be called with onSuccess and statusHandler.forSuccess
- RemoteResource Model is added. It can be used to perform CRUD operation on jsend based APIs very easily.

## 1.0.5
- Changed JsendStatusHandlers to JsendStatusHandler
- Now array of status handlers can be passed. Rather than single status Handler

## 1.0.6

- Status Handlers Bug Fixed

## 1.0.7

- Bug Fixes

## 1.0.8

- Bug Fixes

## 1.0.9

- Made Default Headers of APIRequest editable anytime

## 1.0.10

- multipleDataKey added in remote resource

## 1.0.11

- can clear headers from API Request now
