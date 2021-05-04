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