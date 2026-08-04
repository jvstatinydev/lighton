# Google Play Android Developer API  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/api-ref/rest

---

## Page Summary

 outlined_flag

- 
 This content allows Android application developers to access their Google Play accounts.

- 
 The typical workflow involves inserting an Edit, making necessary changes, and then committing it.

 Lets Android application developers access their Google Play accounts. At a high level, the expected workflow is to "insert" an Edit, make changes as necessary, and then "commit" it.

- REST Resource: v3.applications
 
- REST Resource: v3.applications.deviceTierConfigs
 
- REST Resource: v3.applications.tracks.releases
 
- REST Resource: v3.apprecovery
 
- REST Resource: v3.appstorecatalog.recentAppViews
 
- REST Resource: v3.appstorecatalog.recentUpdateEvents
 
- REST Resource: v3.edits
 
- REST Resource: v3.edits.apks
 
- REST Resource: v3.edits.bundles
 
- REST Resource: v3.edits.countryavailability
 
- REST Resource: v3.edits.deobfuscationfiles
 
- REST Resource: v3.edits.details
 
- REST Resource: v3.edits.expansionfiles
 
- REST Resource: v3.edits.images
 
- REST Resource: v3.edits.listings
 
- REST Resource: v3.edits.testers
 
- REST Resource: v3.edits.tracks
 
- REST Resource: v3.externaltransactions
 
- REST Resource: v3.generatedapks
 
- REST Resource: v3.grants
 
- REST Resource: v3.inappproducts
 
- REST Resource: v3.internalappsharingartifacts
 
- REST Resource: v3.monetization
 
- REST Resource: v3.monetization.onetimeproducts
 
- REST Resource: v3.monetization.onetimeproducts.purchaseOptions
 
- REST Resource: v3.monetization.onetimeproducts.purchaseOptions.offers
 
- REST Resource: v3.monetization.subscriptions
 
- REST Resource: v3.monetization.subscriptions.basePlans
 
- REST Resource: v3.monetization.subscriptions.basePlans.offers
 
- REST Resource: v3.orders
 
- REST Resource: v3.purchases.products
 
- REST Resource: v3.purchases.productsv2
 
- REST Resource: v3.purchases.subscriptions
 
- REST Resource: v3.purchases.subscriptionsv2
 
- REST Resource: v3.purchases.voidedpurchases
 
- REST Resource: v3.reviews
 
- REST Resource: v3.systemapks.variants
 
- REST Resource: v3.users

## Service: androidpublisher.googleapis.com

 To call this service, we recommend that you use the Google-provided client libraries. If your application needs to use your own libraries to call this service, use the following information when you make the API requests.

### Discovery document

 A Discovery Document is a machine-readable specification for describing and consuming REST APIs. It is used to build client libraries, IDE plugins, and other tools that interact with Google APIs. One service may provide multiple discovery documents. This service provides the following discovery document:

- https://androidpublisher.googleapis.com/$discovery/rest?version=v3

### Service endpoint

 A service endpoint is a base URL that specifies the network address of an API service. One service might have multiple service endpoints. This service has the following service endpoint and all URIs below are relative to this service endpoint:

- https://androidpublisher.googleapis.com

## REST Resource: v3.applications

 Methods | 

 dataSafety | 
 
 POST /androidpublisher/v3/applications/{packageName}/dataSafety 
 Writes the Safety Labels declaration of an app. | 

## REST Resource: v3.applications.deviceTierConfigs

 Methods | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/deviceTierConfigs 
 Creates a new device tier config for an app. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/deviceTierConfigs/{deviceTierConfigId} 
 Returns a particular device tier config. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/deviceTierConfigs 
 Returns created device tier configs, ordered by descending creation time. | 

## REST Resource: v3.applications.tracks.releases

 Methods | 

 list | 
 
 GET /androidpublisher/v3/{parent=applications/*/tracks/*}/releases 
 Returns the list of all releases for a given track. | 

## REST Resource: v3.apprecovery

 Methods | 

 addTargeting | 
 
 POST /androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:addTargeting 
 Incrementally update targeting for a recovery action. | 

 cancel | 
 
 POST /androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:cancel 
 Cancel an already executing app recovery action. | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/appRecoveries 
 Create an app recovery action with recovery status as DRAFT. | 

 deploy | 
 
 POST /androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:deploy 
 Deploy an already created app recovery action with recovery status DRAFT. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/appRecoveries 
 List all app recovery action resources associated with a particular package name and app version. | 

## REST Resource: v3.appstorecatalog.recentAppViews

 Methods | 

 get | 
 
 GET /androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentAppViews/{playAppPackageName} 
 Returns metadata about a recently updated app. | 

## REST Resource: v3.appstorecatalog.recentUpdateEvents

 Methods | 

 list | 
 
 GET /androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentUpdateEvents 
 Lists update events for eligible apps in the given time range. | 

## REST Resource: v3.edits

 Methods | 

 commit | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}:commit 
 Commits an app edit. | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/edits/{editId} 
 Deletes an app edit. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId} 
 Gets an app edit. | 

 insert | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits 
 Creates a new edit for an app. | 

 validate | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}:validate 
 Validates an app edit. | 

## REST Resource: v3.edits.apks

 Methods | 

 addexternallyhosted | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/externallyHosted 
 Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks 
 Lists all current APKs of the app and edit. | 

 upload | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks 
 POST /upload/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks 
 Uploads an APK and adds to the current edit. | 

## REST Resource: v3.edits.bundles

 Methods | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles 
 Lists all current Android App Bundles of the app and edit. | 

 upload | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles 
 POST /upload/androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles 
 Uploads a new Android App Bundle to this edit. | 

## REST Resource: v3.edits.countryavailability

 Methods | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/countryAvailability/{track} 
 Gets country availability. | 

## REST Resource: v3.edits.deobfuscationfiles

 Methods | 

 upload | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType} 
 POST /upload/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType} 
 Uploads a new deobfuscation file and attaches to the specified APK. | 

## REST Resource: v3.edits.details

 Methods | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/details 
 Gets details of an app. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/edits/{editId}/details 
 Patches details of an app. | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/edits/{editId}/details 
 Updates details of an app. | 

## REST Resource: v3.edits.expansionfiles

 Methods | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType} 
 Fetches the expansion file configuration for the specified APK. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType} 
 Patches the APK's expansion file configuration to reference another APK's expansion file. | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType} 
 Updates the APK's expansion file configuration to reference another APK's expansion file. | 

 upload | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType} 
 POST /upload/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType} 
 Uploads a new expansion file and attaches to the specified APK. | 

## REST Resource: v3.edits.images

 Methods | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId} 
 Deletes the image (specified by id) from the edit. | 

 deleteall | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType} 
 Deletes all images for the specified language and image type. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType} 
 Lists all images. | 

 upload | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType} 
 POST /upload/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType} 
 Uploads an image of the specified language and image type, and adds to the edit. | 

## REST Resource: v3.edits.listings

 Methods | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language} 
 Deletes a localized store listing. | 

 deleteall | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings 
 Deletes all store listings. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language} 
 Gets a localized store listing. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings 
 Lists all localized store listings. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language} 
 Patches a localized store listing. | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language} 
 Creates or updates a localized store listing. | 

## REST Resource: v3.edits.testers

 Methods | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track} 
 Gets testers. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track} 
 Patches testers. | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track} 
 Updates testers. | 

## REST Resource: v3.edits.tracks

 Methods | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks 
 Creates a new track. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track} 
 Gets a track. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks 
 Lists all tracks. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track} 
 Patches a track. | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track} 
 Updates a track. | 

## REST Resource: v3.externaltransactions

 Methods | 

 createexternaltransaction | 
 
 POST /androidpublisher/v3/{parent=applications/*}/externalTransactions 
 Creates a new external transaction. | 

 getexternaltransaction | 
 
 GET /androidpublisher/v3/{name=applications/*/externalTransactions/*} 
 Gets an existing external transaction. | 

 refundexternaltransaction | 
 
 POST /androidpublisher/v3/{name=applications/*/externalTransactions/*}:refund 
 Refunds or partially refunds an existing external transaction. | 

## REST Resource: v3.generatedapks

 Methods | 

 download | 
 
 GET /androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode}/downloads/{downloadId}:download 
 Downloads a single signed APK generated from an app bundle. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode} 
 Returns download metadata for all APKs that were generated from a given app bundle. | 

## REST Resource: v3.grants

 Methods | 

 create | 
 
 POST /androidpublisher/v3/{parent=developers/*/users/*}/grants 
 Grant access for a user to the given package. | 

 delete | 
 
 DELETE /androidpublisher/v3/{name=developers/*/users/*/grants/*} 
 Removes all access for the user to the given package or developer account. | 

 patch | 
 
 PATCH /androidpublisher/v3/{grant.name=developers/*/users/*/grants/*} 
 Updates access for the user to the given package. | 

## REST Resource: v3.inappproducts

 Methods | 

 batchDelete | 
 
 POST /androidpublisher/v3/applications/{packageName}/inappproducts:batchDelete 
 Deletes in-app products (managed products or subscriptions). | 

 batchGet | 
 
 GET /androidpublisher/v3/applications/{packageName}/inappproducts:batchGet 
 Reads multiple in-app products, which can be managed products or subscriptions. | 

 batchUpdate | 
 
 POST /androidpublisher/v3/applications/{packageName}/inappproducts:batchUpdate 
 Updates or inserts one or more in-app products (managed products or subscriptions). | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/inappproducts/{sku} 
 Deletes an in-app product (a managed product or a subscription). | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/inappproducts/{sku} 
 Gets an in-app product, which can be a managed product or a subscription. | 

 insert | 
 
 POST /androidpublisher/v3/applications/{packageName}/inappproducts 
 Creates an in-app product (a managed product or a subscription). | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/inappproducts 
 Lists all in-app products - both managed products and subscriptions. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{packageName}/inappproducts/{sku} 
 Patches an in-app product (a managed product or a subscription). | 

 update | 
 
 PUT /androidpublisher/v3/applications/{packageName}/inappproducts/{sku} 
 Updates an in-app product (a managed product or a subscription). | 

## REST Resource: v3.internalappsharingartifacts

 Methods | 

 uploadapk | 
 
 POST /androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/apk 
 POST /upload/androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/apk 
 Uploads an APK to internal app sharing. | 

 uploadbundle | 
 
 POST /androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/bundle 
 POST /upload/androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/bundle 
 Uploads an app bundle to internal app sharing. | 

## REST Resource: v3.monetization

 Methods | 

 convertRegionPrices | 
 
 POST /androidpublisher/v3/applications/{packageName}/pricing:convertRegionPrices 
 Calculates the region prices, using today's exchange rate and country-specific pricing patterns, based on the price in the request for a set of regions. | 

## REST Resource: v3.monetization.onetimeproducts

 Methods | 

 batchDelete | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchDelete 
 Deletes one or more one-time products. | 

 batchGet | 
 
 GET /androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchGet 
 Reads one or more one-time products. | 

 batchUpdate | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchUpdate 
 Creates or updates one or more one-time products. | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId} 
 Deletes a one-time product. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId} 
 Reads a single one-time product. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/oneTimeProducts 
 Lists all one-time products under a given app. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{oneTimeProduct.packageName}/onetimeproducts/{oneTimeProduct.productId} 
 Creates or updates a one-time product. | 

## REST Resource: v3.monetization.onetimeproducts.purchaseOptions

 Methods | 

 batchDelete | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchDelete 
 Deletes purchase options across one or multiple one-time products. | 

 batchUpdateStates | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchUpdateStates 
 Activates or deactivates purchase options across one or multiple one-time products. | 

## REST Resource: v3.monetization.onetimeproducts.purchaseOptions.offers

 Methods | 

 activate | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:activate 
 Activates a one-time product offer. | 

 batchDelete | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchDelete 
 Deletes one or more one-time product offers. | 

 batchGet | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchGet 
 Reads one or more one-time product offers. | 

 batchUpdate | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdate 
 Creates or updates one or more one-time product offers. | 

 batchUpdateStates | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdateStates 
 Updates a batch of one-time product offer states. | 

 cancel | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:cancel 
 Cancels a one-time product offer. | 

 deactivate | 
 
 POST /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:deactivate 
 Deactivates a one-time product offer. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers 
 Lists all offers under a given app, product, or purchase option. | 

## REST Resource: v3.monetization.subscriptions

 Methods | 

 archive (deprecated) | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}:archive 
 Deprecated: subscription archiving is not supported. | 

 batchGet | 
 
 GET /androidpublisher/v3/applications/{packageName}/subscriptions:batchGet 
 Reads one or more subscriptions. | 

 batchUpdate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions:batchUpdate 
 Updates a batch of subscriptions. | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions 
 Creates a new subscription. | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/subscriptions/{productId} 
 Deletes a subscription. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/subscriptions/{productId} 
 Reads a single subscription. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/subscriptions 
 Lists all subscriptions under a given app. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{subscription.packageName}/subscriptions/{subscription.productId} 
 Updates an existing subscription. | 

## REST Resource: v3.monetization.subscriptions.basePlans

 Methods | 

 activate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:activate 
 Activates a base plan. | 

 batchMigratePrices | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchMigratePrices 
 Batch variant of the MigrateBasePlanPrices endpoint. | 

 batchUpdateStates | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchUpdateStates 
 Activates or deactivates base plans across one or multiple subscriptions. | 

 deactivate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:deactivate 
 Deactivates a base plan. | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId} 
 Deletes a base plan. | 

 migratePrices | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:migratePrices 
 Migrates subscribers from one or more legacy price cohorts to the current price. | 

## REST Resource: v3.monetization.subscriptions.basePlans.offers

 Methods | 

 activate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:activate 
 Activates a subscription offer. | 

 batchGet | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchGet 
 Reads one or more subscription offers. | 

 batchUpdate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdate 
 Updates a batch of subscription offers. | 

 batchUpdateStates | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdateStates 
 Updates a batch of subscription offer states. | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers 
 Creates a new subscription offer. | 

 deactivate | 
 
 POST /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:deactivate 
 Deactivates a subscription offer. | 

 delete | 
 
 DELETE /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId} 
 Deletes a subscription offer. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId} 
 Reads a single offer | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers 
 Lists all offers under a given subscription. | 

 patch | 
 
 PATCH /androidpublisher/v3/applications/{subscriptionOffer.packageName}/subscriptions/{subscriptionOffer.productId}/basePlans/{subscriptionOffer.basePlanId}/offers/{subscriptionOffer.offerId} 
 Updates an existing subscription offer. | 

## REST Resource: v3.orders

 Methods | 

 batchget | 
 
 GET /androidpublisher/v3/applications/{packageName}/orders:batchGet 
 Get order details for a list of orders. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/orders/{orderId} 
 Get order details for a single order. | 

 refund | 
 
 POST /androidpublisher/v3/applications/{packageName}/orders/{orderId}:refund 
 Refunds a user's subscription or in-app purchase order. | 

 reviewrefund | 
 
 POST /androidpublisher/v3/applications/{packageName}/orders/{orderId}:reviewrefund 
 Provide refund preference and purchase usage for a chargeback request | 

## REST Resource: v3.purchases.products

 Methods | 

 acknowledge | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge 
 Acknowledges a purchase of an inapp item. | 

 consume | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:consume 
 Consumes a purchase for an inapp item. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token} 
 Checks the purchase and consumption status of an inapp item. | 

## REST Resource: v3.purchases.productsv2

 Methods | 

 getproductpurchasev2 | 
 
 GET /androidpublisher/v3/applications/{packageName}/purchases/productsv2/tokens/{token} 
 Checks the purchase and consumption status of an inapp item. | 

## REST Resource: v3.purchases.subscriptions

 Methods | 

 acknowledge | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge 
 Acknowledges a subscription purchase. | 

 cancel (deprecated) | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel 
 Deprecated: Use purchases.subscriptionsv2.cancel instead. | 

 defer (deprecated) | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer 
 Deprecated: Use purchases.subscriptionsv2.defer instead. | 

## REST Resource: v3.purchases.subscriptionsv2

 Methods | 

 cancel | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:cancel 
 Cancel a subscription purchase for the user. | 

 defer | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:defer 
 Defers the renewal of a subscription. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token} 
 Get metadata about a subscription | 

 revoke | 
 
 POST /androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:revoke 
 Revoke a subscription purchase for the user. | 

## REST Resource: v3.purchases.voidedpurchases

 Methods | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/purchases/voidedpurchases 
 Lists the purchases that were canceled, refunded or charged-back. | 

## REST Resource: v3.reviews

 Methods | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/reviews/{reviewId} 
 Gets a single review. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/reviews 
 Lists all reviews. | 

 reply | 
 
 POST /androidpublisher/v3/applications/{packageName}/reviews/{reviewId}:reply 
 Replies to a single review, or updates an existing reply. | 

## REST Resource: v3.systemapks.variants

 Methods | 

 create | 
 
 POST /androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants 
 Creates an APK which is suitable for inclusion in a system image from an already uploaded Android App Bundle. | 

 download | 
 
 GET /androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId}:download 
 Downloads a previously created system APK which is suitable for inclusion in a system image. | 

 get | 
 
 GET /androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId} 
 Returns a previously created system APK variant. | 

 list | 
 
 GET /androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants 
 Returns the list of previously created system APK variants. | 

## REST Resource: v3.users

 Methods | 

 create | 
 
 POST /androidpublisher/v3/{parent=developers/*}/users 
 Grant access for a user to the given developer account. | 

 delete | 
 
 DELETE /androidpublisher/v3/{name=developers/*/users/*} 
 Removes all access for the user to the given developer account. | 

 list | 
 
 GET /androidpublisher/v3/{parent=developers/*}/users 
 Lists all users with access to a developer account. | 

 patch | 
 
 PATCH /androidpublisher/v3/{user.name=developers/*/users/*} 
 Updates access for the user to the developer account. |
