## Teachable Takehome Assesment

Still todo:
* could fix up some of the names. there are inconsistencies with the API class and Todoable module
* need to retry on failures  in case of stale token
* api for items can be simplified since they are uuids
  * keep list and items in memory so that a list_id doesnt' have to be provided at all for operations on tiems
  * this is break if the app goes down, so we would also want to put the current state into memory on `init`

* I know that the tests can be simplified