# Download generated APKs using the Play Developer Publishing API  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/download-apks

---

## Page Summary

 outlined_flag

- 
 You can download APKs generated from an app bundle uploaded to Play Console using the Generated APKs feature in the Google Play Developer API.

- 
 A typical workflow involves creating an edit, uploading a bundle, assigning it to a track as a draft, committing the edit, downloading generated APKs, processing them, creating a new edit, and then promoting the release.

- 
 Alternatively, you can release a new version to an internal test track before downloading the generated APKs to avoid committing a draft release.

- 
 To use downloaded APKs with bundletool, you need to download the APKs, create a toc.json file from the TargetingInfo field, name each APK with its DownloadId, and place them all in a directory.

You can download all APKs that Google Play generated from an app bundle
you've uploaded to Play Console using the Generated APKs feature in the
Google Play Developer API.

## How to use generated APKs

A typical publishing workflow which includes downloading generated APKs before
they are released on any track would be the following:

- Create a new edit, by calling
Edits: Insert
and specifying the app you want to modify.

- Upload a bundle by calling
Edits.bundles: upload.

- Assign the bundle to a track by calling
Edits.tracks: update.
To avoid releasing the new version to end users at this stage, set the
status of the new release to draft.

- Commit the edit.

- Download the APKs generated from the bundle that you uploaded in step 2
using the Generated APKs methods in the API.

- Process your downloaded APKs.

- Create a new edit as you did in step 1.

- Promote the draft release to a staged or full rollout by calling
Edits.tracks: update.

- Commit the edit.

Tip: Alternatively, if you want to avoid committing a draft release, you can
release a new version of the app to an internal test track before downloading
the generated APKs.

## How to construct your APK directory

If you need to use your APK files with bundletool, follow these steps to build
them using the Generated APKs API:

- When calling the Generated APKs list method, the response will contain
TargetingInfo field for each signing key. Write this field value
to a file named toc.json.

- Download your APKs, and put them in a directory with the toc.json created
in the previous step. Note that each downloaded APK must be named
"DownloadId.apk", where DownloadId is the ID used to download the APK
from the Generated APKs download method.

- You can now use this directory with bundletool version 1.15.2 or higher.
For example, bundletool install-apks --apks /path/to/created/directory.
