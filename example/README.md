## Pre-requisites to run the Example app:

* Create `.env` and copy the contents of `sample.env` and replace the values of `DUPLICATE_WRITE_KEY` and `DUPLICATE_DATA_PLANE_URL` with the actual values form your Rudderstack Dashboard.
* Please make sure to un-comment the `.env` under `flutter/assets` in the `pubspec.yml` file

## Update the JS snippet for Flutter Web:

*	To deploy the “web” package, ensure you replace `<WRITE_KEY>` in `/web/index.html` with the actual write key value.
![alt text](replace-writeKey-in-placeholder.png)