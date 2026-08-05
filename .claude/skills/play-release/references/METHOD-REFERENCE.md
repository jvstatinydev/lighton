# Google Play Android Developer API — Method Reference

- Version: `v3`  ·  Discovery revision: **20260803**
- Root URL: `https://androidpublisher.googleapis.com/`
- Discovery doc: `https://androidpublisher.googleapis.com/$discovery/rest?version=v3`
- OAuth scopes: `https://www.googleapis.com/auth/androidpublisher`

Generated from the machine-readable discovery document — this is the authoritative API surface.

**Total methods: 143**  ·  **Schemas: 383**

## Index

| Method | HTTP | Path |
| --- | --- | --- |
| `applications.dataSafety` | POST | `androidpublisher/v3/applications/{packageName}/dataSafety` |
| `applications.deviceTierConfigs.create` | POST | `androidpublisher/v3/applications/{packageName}/deviceTierConfigs` |
| `applications.deviceTierConfigs.get` | GET | `androidpublisher/v3/applications/{packageName}/deviceTierConfigs/{deviceTierConfigId}` |
| `applications.deviceTierConfigs.list` | GET | `androidpublisher/v3/applications/{packageName}/deviceTierConfigs` |
| `applications.tracks.releases.list` | GET | `androidpublisher/v3/{+parent}/releases` |
| `apprecovery.addTargeting` | POST | `androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:addTargeting` |
| `apprecovery.cancel` | POST | `androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:cancel` |
| `apprecovery.create` | POST | `androidpublisher/v3/applications/{packageName}/appRecoveries` |
| `apprecovery.deploy` | POST | `androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:deploy` |
| `apprecovery.list` | GET | `androidpublisher/v3/applications/{packageName}/appRecoveries` |
| `appstoreappsreview.createappstorehostedapp` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps:create` |
| `appstoreappsreview.updateappstorehostedapp` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps:update` |
| `appstoreappsreview.updateappstorehostedapppublishstatus` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}:updateAppStoreHostedAppPublishStatus` |
| `appstoreappsreview.uploadapk` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/apks:upload` |
| `appstoreappsreview.uploadappstoreapppolicydeclarationfile` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/policyDeclarationFiles:upload` |
| `appstoreappsreview.uploadimage` | POST | `androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/images:upload` |
| `appstorecatalog.recentappviews.get` | GET | `androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentAppViews/{playAppPackageName}` |
| `appstorecatalog.recentupdateevents.list` | GET | `androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentUpdateEvents` |
| `edits.commit` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}:commit` |
| `edits.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/edits/{editId}` |
| `edits.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}` |
| `edits.insert` | POST | `androidpublisher/v3/applications/{packageName}/edits` |
| `edits.validate` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}:validate` |
| `edits.apks.addexternallyhosted` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/externallyHosted` |
| `edits.apks.list` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks` |
| `edits.apks.upload` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks` |
| `edits.bundles.list` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles` |
| `edits.bundles.upload` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles` |
| `edits.countryavailability.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/countryAvailability/{track}` |
| `edits.deobfuscationfiles.upload` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}` |
| `edits.details.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/details` |
| `edits.details.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/edits/{editId}/details` |
| `edits.details.update` | PUT | `androidpublisher/v3/applications/{packageName}/edits/{editId}/details` |
| `edits.expansionfiles.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}` |
| `edits.expansionfiles.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}` |
| `edits.expansionfiles.update` | PUT | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}` |
| `edits.expansionfiles.upload` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}` |
| `edits.images.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}` |
| `edits.images.deleteall` | DELETE | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}` |
| `edits.images.list` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}` |
| `edits.images.upload` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}` |
| `edits.listings.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}` |
| `edits.listings.deleteall` | DELETE | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings` |
| `edits.listings.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}` |
| `edits.listings.list` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings` |
| `edits.listings.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}` |
| `edits.listings.update` | PUT | `androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}` |
| `edits.testers.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}` |
| `edits.testers.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}` |
| `edits.testers.update` | PUT | `androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}` |
| `edits.tracks.create` | POST | `androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks` |
| `edits.tracks.get` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}` |
| `edits.tracks.list` | GET | `androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks` |
| `edits.tracks.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}` |
| `edits.tracks.update` | PUT | `androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}` |
| `externaltransactions.createexternaltransaction` | POST | `androidpublisher/v3/{+parent}/externalTransactions` |
| `externaltransactions.getexternaltransaction` | GET | `androidpublisher/v3/{+name}` |
| `externaltransactions.refundexternaltransaction` | POST | `androidpublisher/v3/{+name}:refund` |
| `generatedapks.download` | GET | `androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode}/downloads/{downloadId}:download` |
| `generatedapks.list` | GET | `androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode}` |
| `grants.create` | POST | `androidpublisher/v3/{+parent}/grants` |
| `grants.delete` | DELETE | `androidpublisher/v3/{+name}` |
| `grants.patch` | PATCH | `androidpublisher/v3/{+name}` |
| `inappproducts.batchDelete` | POST | `androidpublisher/v3/applications/{packageName}/inappproducts:batchDelete` |
| `inappproducts.batchGet` | GET | `androidpublisher/v3/applications/{packageName}/inappproducts:batchGet` |
| `inappproducts.batchUpdate` | POST | `androidpublisher/v3/applications/{packageName}/inappproducts:batchUpdate` |
| `inappproducts.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/inappproducts/{sku}` |
| `inappproducts.get` | GET | `androidpublisher/v3/applications/{packageName}/inappproducts/{sku}` |
| `inappproducts.insert` | POST | `androidpublisher/v3/applications/{packageName}/inappproducts` |
| `inappproducts.list` | GET | `androidpublisher/v3/applications/{packageName}/inappproducts` |
| `inappproducts.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/inappproducts/{sku}` |
| `inappproducts.update` | PUT | `androidpublisher/v3/applications/{packageName}/inappproducts/{sku}` |
| `internalappsharingartifacts.uploadapk` | POST | `androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/apk` |
| `internalappsharingartifacts.uploadbundle` | POST | `androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/bundle` |
| `monetization.convertRegionPrices` | POST | `androidpublisher/v3/applications/{packageName}/pricing:convertRegionPrices` |
| `monetization.onetimeproducts.batchDelete` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchDelete` |
| `monetization.onetimeproducts.batchGet` | GET | `androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchGet` |
| `monetization.onetimeproducts.batchUpdate` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchUpdate` |
| `monetization.onetimeproducts.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}` |
| `monetization.onetimeproducts.get` | GET | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}` |
| `monetization.onetimeproducts.list` | GET | `androidpublisher/v3/applications/{packageName}/oneTimeProducts` |
| `monetization.onetimeproducts.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/onetimeproducts/{productId}` |
| `monetization.onetimeproducts.purchaseOptions.batchDelete` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchDelete` |
| `monetization.onetimeproducts.purchaseOptions.batchUpdateStates` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchUpdateStates` |
| `monetization.onetimeproducts.purchaseOptions.offers.activate` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:activate` |
| `monetization.onetimeproducts.purchaseOptions.offers.batchDelete` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchDelete` |
| `monetization.onetimeproducts.purchaseOptions.offers.batchGet` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchGet` |
| `monetization.onetimeproducts.purchaseOptions.offers.batchUpdate` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdate` |
| `monetization.onetimeproducts.purchaseOptions.offers.batchUpdateStates` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdateStates` |
| `monetization.onetimeproducts.purchaseOptions.offers.cancel` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:cancel` |
| `monetization.onetimeproducts.purchaseOptions.offers.deactivate` | POST | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:deactivate` |
| `monetization.onetimeproducts.purchaseOptions.offers.list` | GET | `androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers` |
| `monetization.subscriptions.archive` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}:archive` |
| `monetization.subscriptions.batchGet` | GET | `androidpublisher/v3/applications/{packageName}/subscriptions:batchGet` |
| `monetization.subscriptions.batchUpdate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions:batchUpdate` |
| `monetization.subscriptions.create` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions` |
| `monetization.subscriptions.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}` |
| `monetization.subscriptions.get` | GET | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}` |
| `monetization.subscriptions.list` | GET | `androidpublisher/v3/applications/{packageName}/subscriptions` |
| `monetization.subscriptions.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}` |
| `monetization.subscriptions.basePlans.activate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:activate` |
| `monetization.subscriptions.basePlans.batchMigratePrices` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchMigratePrices` |
| `monetization.subscriptions.basePlans.batchUpdateStates` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchUpdateStates` |
| `monetization.subscriptions.basePlans.deactivate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:deactivate` |
| `monetization.subscriptions.basePlans.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}` |
| `monetization.subscriptions.basePlans.migratePrices` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:migratePrices` |
| `monetization.subscriptions.basePlans.offers.activate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:activate` |
| `monetization.subscriptions.basePlans.offers.batchGet` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchGet` |
| `monetization.subscriptions.basePlans.offers.batchUpdate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdate` |
| `monetization.subscriptions.basePlans.offers.batchUpdateStates` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdateStates` |
| `monetization.subscriptions.basePlans.offers.create` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers` |
| `monetization.subscriptions.basePlans.offers.deactivate` | POST | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:deactivate` |
| `monetization.subscriptions.basePlans.offers.delete` | DELETE | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}` |
| `monetization.subscriptions.basePlans.offers.get` | GET | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}` |
| `monetization.subscriptions.basePlans.offers.list` | GET | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers` |
| `monetization.subscriptions.basePlans.offers.patch` | PATCH | `androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}` |
| `orders.batchget` | GET | `androidpublisher/v3/applications/{packageName}/orders:batchGet` |
| `orders.get` | GET | `androidpublisher/v3/applications/{packageName}/orders/{orderId}` |
| `orders.refund` | POST | `androidpublisher/v3/applications/{packageName}/orders/{orderId}:refund` |
| `orders.reviewrefund` | POST | `androidpublisher/v3/applications/{packageName}/orders/{orderId}:reviewrefund` |
| `purchases.products.acknowledge` | POST | `androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge` |
| `purchases.products.consume` | POST | `androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:consume` |
| `purchases.products.get` | GET | `androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}` |
| `purchases.productsv2.getproductpurchasev2` | GET | `androidpublisher/v3/applications/{packageName}/purchases/productsv2/tokens/{token}` |
| `purchases.subscriptions.acknowledge` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge` |
| `purchases.subscriptions.cancel` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel` |
| `purchases.subscriptions.defer` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer` |
| `purchases.subscriptionsv2.cancel` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:cancel` |
| `purchases.subscriptionsv2.defer` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:defer` |
| `purchases.subscriptionsv2.get` | GET | `androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}` |
| `purchases.subscriptionsv2.revoke` | POST | `androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:revoke` |
| `purchases.voidedpurchases.list` | GET | `androidpublisher/v3/applications/{packageName}/purchases/voidedpurchases` |
| `reviews.get` | GET | `androidpublisher/v3/applications/{packageName}/reviews/{reviewId}` |
| `reviews.list` | GET | `androidpublisher/v3/applications/{packageName}/reviews` |
| `reviews.reply` | POST | `androidpublisher/v3/applications/{packageName}/reviews/{reviewId}:reply` |
| `systemapks.variants.create` | POST | `androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants` |
| `systemapks.variants.download` | GET | `androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId}:download` |
| `systemapks.variants.get` | GET | `androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId}` |
| `systemapks.variants.list` | GET | `androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants` |
| `users.create` | POST | `androidpublisher/v3/{+parent}/users` |
| `users.delete` | DELETE | `androidpublisher/v3/{+name}` |
| `users.list` | GET | `androidpublisher/v3/{+parent}/users` |
| `users.patch` | PATCH | `androidpublisher/v3/{+name}` |

---

## Methods


# Resource: `applications`

### `applications.dataSafety`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/dataSafety`

Writes the Safety Labels declaration of an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app. |

- Request body: `SafetyLabelsUpdateRequest`
- Response: `SafetyLabelsUpdateResponse`

### `applications.deviceTierConfigs.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/deviceTierConfigs`

Creates a new device tier config for an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `allowUnknownDevices` | query | boolean |  | Whether the service should accept device IDs that are unknown to Play's device catalog. |

- Request body: `DeviceTierConfig`
- Response: `DeviceTierConfig`

### `applications.deviceTierConfigs.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/deviceTierConfigs/{deviceTierConfigId}`

Returns a particular device tier config.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `deviceTierConfigId` | path | string | yes | Required. Id of an existing device tier config. |
| `packageName` | path | string | yes | Package name of the app. |

- Response: `DeviceTierConfig`

### `applications.deviceTierConfigs.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/deviceTierConfigs`

Returns created device tier configs, ordered by descending creation time.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `pageToken` | query | string |  | A page token, received from a previous `ListDeviceTierConfigs` call. Provide this to retrieve the subsequent page. |
| `pageSize` | query | integer |  | The maximum number of device tier configs to return. The service may return fewer than this value. If unspecified, at most 10 device tier configs will be returned. The maximum valu |

- Response: `ListDeviceTierConfigsResponse`

### `applications.tracks.releases.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/{+parent}/releases`

Returns the list of all releases for a given track. This excludes any releases that are obsolete.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `parent` | path | string | yes | Required. The parent track, which owns this collection of releases. Format: applications/{package_name}/tracks/{track} |

- Response: `ListReleaseSummariesResponse`


# Resource: `apprecovery`

### `apprecovery.addTargeting`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:addTargeting`

Incrementally update targeting for a recovery action. Note that only the criteria selected during the creation of recovery action can be expanded.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app for which recovery action is to be updated. |
| `appRecoveryId` | path | string | yes | Required. ID corresponding to the app recovery action. |

- Request body: `AddTargetingRequest`
- Response: `AddTargetingResponse`

### `apprecovery.cancel`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:cancel`

Cancel an already executing app recovery action. Note that this action changes status of the recovery action to CANCELED.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app for which recovery action cancellation is requested. |
| `appRecoveryId` | path | string | yes | Required. ID corresponding to the app recovery action. |

- Request body: `CancelAppRecoveryRequest`
- Response: `CancelAppRecoveryResponse`

### `apprecovery.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/appRecoveries`

Create an app recovery action with recovery status as DRAFT. Note that this action does not execute the recovery action.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app on which recovery action is performed. |

- Request body: `CreateDraftAppRecoveryRequest`
- Response: `AppRecoveryAction`

### `apprecovery.deploy`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/appRecoveries/{appRecoveryId}:deploy`

Deploy an already created app recovery action with recovery status DRAFT. Note that this action activates the recovery action for all targeted users and changes its status to ACTIVE.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app for which recovery action is deployed. |
| `appRecoveryId` | path | string | yes | Required. ID corresponding to the app recovery action to deploy. |

- Request body: `DeployAppRecoveryRequest`
- Response: `DeployAppRecoveryResponse`

### `apprecovery.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/appRecoveries`

List all app recovery action resources associated with a particular package name and app version.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | query | string |  | Required. Version code targeted by the list of recovery actions. |
| `packageName` | path | string | yes | Required. Package name of the app for which list of recovery actions is requested. |

- Response: `ListAppRecoveriesResponse`


# Resource: `appstoreappsreview`

### `appstoreappsreview.createappstorehostedapp`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps:create`

Creates an app store hosted app. This must be called before any other RPCs for this hosted app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |

- Request body: `CreateAppStoreHostedAppRequest`
- Response: `CreateAppStoreHostedAppResponse`

### `appstoreappsreview.updateappstorehostedapp`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps:update`

Updates details for an app hosted on an app store. Use this to provide details for a new app, or to update details for an existing app. The update will be sent for review immediately after creation.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |

- Request body: `UpdateAppStoreHostedAppRequest`
- Response: `UpdateAppStoreHostedAppResponse`

### `appstoreappsreview.updateappstorehostedapppublishstatus`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}:updateAppStoreHostedAppPublishStatus`

Updates the publish status of an app store hosted app. The default state after calling UpdateAppStoreHostedApp is PUBLISHED. It is not necessary to call this RPC explicitly to set an app to PUBLISHED.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app. |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |

- Request body: `UpdateAppStoreHostedAppPublishStatusRequest`
- Response: `UpdateAppStoreHostedAppPublishStatusResponse`

### `appstoreappsreview.uploadapk`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/apks:upload`

Upload an APK file for the hosted app. Returns an ID to track this APK.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app. |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |

- Request body: `UploadApkRequest`
- Response: `UploadApkResponse`
- **Media upload supported** — max size `10737418240`, accepts `application/octet-stream, application/vnd.android.package-archive`

### `appstoreappsreview.uploadappstoreapppolicydeclarationfile`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/policyDeclarationFiles:upload`

Upload a policy declaration file for the hosted app. Returns an ID to track the file.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |
| `packageName` | path | string | yes | Required. Package name of the app. |

- Request body: `UploadAppStoreAppPolicyDeclarationFileRequest`
- Response: `UploadAppStoreAppPolicyDeclarationFileResponse`
- **Media upload supported** — max size `10485760`, accepts `application/pdf, image/jpeg, image/png`

### `appstoreappsreview.uploadimage`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/appstore/{appStorePackageName}/apps/{packageName}/images:upload`

Upload a screenshot or app icon for the hosted app. Returns an ID to track the image.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app. |
| `appStorePackageName` | path | string | yes | Required. Package name of the third-party app store. |

- Request body: `UploadImageRequest`
- Response: `UploadImageResponse`
- **Media upload supported** — max size `15728640`, accepts `image/*`


# Resource: `appstorecatalog`

### `appstorecatalog.recentappviews.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentAppViews/{playAppPackageName}`

Returns metadata about a recently updated app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `appStorePackageName` | path | string | yes | Required. The package name of the app store on behalf of which the request is made. |
| `playAppPackageName` | path | string | yes | Required. The package name of the requested Play app. |

- Response: `RecentAppView`

### `appstorecatalog.recentupdateevents.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/appstorecatalog/{appStorePackageName}/recentUpdateEvents`

Lists update events for eligible apps in the given time range.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `pageToken` | query | string |  | Optional. A page token, received from a previous `ListRecentUpdateEvents` call. Provide this to retrieve the subsequent page. When paginating, all other parameters provided to `Lis |
| `appStorePackageName` | path | string | yes | Required. The package name of the app store on behalf of which the request is made. |
| `pageSize` | query | integer |  | Optional. The maximum number of update events to return. The service may return fewer than this value. If unspecified, at most 100 update events will be returned. The maximum value |
| `endTime` | query | string |  | Required. The end time of the range (exclusive). |
| `startTime` | query | string |  | Required. The start time of the range (inclusive). |

- Response: `ListRecentUpdateEventsResponse`


# Resource: `edits`

### `edits.commit`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}:commit`

Commits an app edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `changesNotSentForReview` | query | boolean |  | When a rejection happens, the parameter will make sure that the changes in this edit won't be reviewed until they are explicitly sent for review from within the Google Play Console |
| `changesInReviewBehavior` | query | string |  | Optional. Specify how the API should behave if there are changes currently in review. If this value is not set, it will default to "CANCEL_IN_REVIEW_AND_SUBMIT", which will cancel  |

- Response: `AppEdit`

### `edits.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}`

Deletes an app edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |


### `edits.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}`

Gets an app edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `AppEdit`

### `edits.insert`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits`

Creates a new edit for an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |

- Request body: `AppEdit`
- Response: `AppEdit`

### `edits.validate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}:validate`

Validates an app edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `AppEdit`

### `edits.apks.addexternallyhosted`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/externallyHosted`

Creates a new APK without uploading the APK itself to Google Play, instead hosting the APK at a specified URL. This function is only available to organizations using Managed Play whose application is configured to restrict distribution to the organizations.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `ApksAddExternallyHostedRequest`
- Response: `ApksAddExternallyHostedResponse`

### `edits.apks.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks`

Lists all current APKs of the app and edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `ApksListResponse`

### `edits.apks.upload`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks`

Uploads an APK and adds to the current edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `Apk`
- **Media upload supported** — max size `10737418240`, accepts `application/octet-stream, application/vnd.android.package-archive`

### `edits.bundles.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles`

Lists all current Android App Bundles of the app and edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `BundlesListResponse`

### `edits.bundles.upload`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/bundles`

Uploads a new Android App Bundle to this edit. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See [Timeouts and Errors](https://developers.google.com/api-client-library/java/google-api-java-client/errors) for an example in java.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `deviceTierConfigId` | query | string |  | Device tier config (DTC) to be used for generating deliverables (APKs). Contains id of the DTC or "LATEST" for last uploaded DTC. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `ackBundleInstallationWarning` | query | boolean |  | Deprecated. The installation warning has been removed, it's not necessary to set this field anymore. |

- Response: `Bundle`
- **Media upload supported** — max size `53687091200`, accepts `application/octet-stream`

### `edits.countryavailability.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/countryAvailability/{track}`

Gets country availability.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `track` | path | string | yes | The track to read from. |

- Response: `TrackCountryAvailability`

### `edits.deobfuscationfiles.upload`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/deobfuscationFiles/{deobfuscationFileType}`

Uploads a new deobfuscation file and attaches to the specified APK.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `apkVersionCode` | path | integer | yes | The version code of the APK whose Deobfuscation File is being uploaded. |
| `deobfuscationFileType` | path | string | yes | The type of the deobfuscation file. |
| `packageName` | path | string | yes | Unique identifier for the Android app. |
| `editId` | path | string | yes | Unique identifier for this edit. |

- Response: `DeobfuscationFilesUploadResponse`
- **Media upload supported** — max size `1677721600`, accepts `application/octet-stream`

### `edits.details.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/details`

Gets details of an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `AppDetails`

### `edits.details.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/details`

Patches details of an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `AppDetails`
- Response: `AppDetails`

### `edits.details.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/details`

Updates details of an app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `AppDetails`
- Response: `AppDetails`

### `edits.expansionfiles.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}`

Fetches the expansion file configuration for the specified APK.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `apkVersionCode` | path | integer | yes | The version code of the APK whose expansion file configuration is being read or modified. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `expansionFileType` | path | string | yes | The file type of the file configuration which is being read or modified. |

- Response: `ExpansionFile`

### `edits.expansionfiles.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}`

Patches the APK's expansion file configuration to reference another APK's expansion file. To add a new expansion file use the Upload method.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `apkVersionCode` | path | integer | yes | The version code of the APK whose expansion file configuration is being read or modified. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `expansionFileType` | path | string | yes | The file type of the expansion file configuration which is being updated. |

- Request body: `ExpansionFile`
- Response: `ExpansionFile`

### `edits.expansionfiles.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}`

Updates the APK's expansion file configuration to reference another APK's expansion file. To add a new expansion file use the Upload method.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `apkVersionCode` | path | integer | yes | The version code of the APK whose expansion file configuration is being read or modified. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `expansionFileType` | path | string | yes | The file type of the file configuration which is being read or modified. |

- Request body: `ExpansionFile`
- Response: `ExpansionFile`

### `edits.expansionfiles.upload`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/apks/{apkVersionCode}/expansionFiles/{expansionFileType}`

Uploads a new expansion file and attaches to the specified APK.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `apkVersionCode` | path | integer | yes | The version code of the APK whose expansion file configuration is being read or modified. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `expansionFileType` | path | string | yes | The file type of the expansion file configuration which is being updated. |

- Response: `ExpansionFilesUploadResponse`
- **Media upload supported** — max size `2147483648`, accepts `application/octet-stream`

### `edits.images.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}/{imageId}`

Deletes the image (specified by id) from the edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `imageType` | path | string | yes | Type of the Image. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). |
| `imageId` | path | string | yes | Unique identifier an image within the set of images attached to this edit. |


### `edits.images.deleteall`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}`

Deletes all images for the specified language and image type. Returns an empty response if no images are found.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `imageType` | path | string | yes | Type of the Image. Providing an image type that refers to no images is a no-op. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). Providing a language that is not supported by the App is a no-op. |

- Response: `ImagesDeleteAllResponse`

### `edits.images.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}`

Lists all images. The response may be empty.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). There must be a store listing for the specified language. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `imageType` | path | string | yes | Type of the Image. Providing an image type that refers to no images will return an empty response. |

- Response: `ImagesListResponse`

### `edits.images.upload`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}/{imageType}`

Uploads an image of the specified language and image type, and adds to the edit.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). Providing a language that is not supported by the App is a no-op. |
| `imageType` | path | string | yes | Type of the Image. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `aiGeneratedState` | query | string |  | Optional. Whether the image was generated by AI. Attested by the developer. |

- Response: `ImagesUploadResponse`
- **Media upload supported** — max size `15728640`, accepts `image/*`

### `edits.listings.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}`

Deletes a localized store listing.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). |


### `edits.listings.deleteall`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings`

Deletes all store listings.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |


### `edits.listings.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}`

Gets a localized store listing.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). |

- Response: `Listing`

### `edits.listings.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings`

Lists all localized store listings.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `ListingsListResponse`

### `edits.listings.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}`

Patches a localized store listing.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `Listing`
- Response: `Listing`

### `edits.listings.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/listings/{language}`

Creates or updates a localized store listing.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `language` | path | string | yes | Language localization code (a BCP-47 language tag; for example, "de-AT" for Austrian German). |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `Listing`
- Response: `Listing`

### `edits.testers.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}`

Gets testers. Note: Testers resource does not support email lists.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `track` | path | string | yes | The track to read from. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `Testers`

### `edits.testers.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}`

Patches testers. Note: Testers resource does not support email lists.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `track` | path | string | yes | The track to update. |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `Testers`
- Response: `Testers`

### `edits.testers.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/testers/{track}`

Updates testers. Note: Testers resource does not support email lists.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `track` | path | string | yes | The track to update. |

- Request body: `Testers`
- Response: `Testers`

### `edits.tracks.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks`

Creates a new track.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the app. |
| `editId` | path | string | yes | Required. Identifier of the edit. |

- Request body: `TrackConfig`
- Response: `Track`

### `edits.tracks.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}`

Gets a track.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `track` | path | string | yes | Identifier of the track. [More on track name](https://developers.google.com/android-publisher/tracks#ff-track-name) |

- Response: `Track`

### `edits.tracks.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks`

Lists all tracks.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Response: `TracksListResponse`

### `edits.tracks.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}`

Patches a track.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `track` | path | string | yes | Identifier of the track. [More on track name](https://developers.google.com/android-publisher/tracks#ff-track-name) |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |

- Request body: `Track`
- Response: `Track`

### `edits.tracks.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/edits/{editId}/tracks/{track}`

Updates a track.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `editId` | path | string | yes | Identifier of the edit. |
| `track` | path | string | yes | Identifier of the track. [More on track name](https://developers.google.com/android-publisher/tracks#ff-track-name) |

- Request body: `Track`
- Response: `Track`


# Resource: `externaltransactions`

### `externaltransactions.createexternaltransaction`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/{+parent}/externalTransactions`

Creates a new external transaction.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `parent` | path | string | yes | Required. The parent resource where this external transaction will be created. Format: applications/{package_name} |
| `externalTransactionId` | query | string |  | Required. The id to use for the external transaction. Must be unique across all other transactions for the app. This value should be 1-63 characters and valid characters are /a-zA- |

- Request body: `ExternalTransaction`
- Response: `ExternalTransaction`

### `externaltransactions.getexternaltransaction`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}`

Gets an existing external transaction.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | path | string | yes | Required. The name of the external transaction to retrieve. Format: applications/{package_name}/externalTransactions/{external_transaction} |

- Response: `ExternalTransaction`

### `externaltransactions.refundexternaltransaction`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}:refund`

Refunds or partially refunds an existing external transaction.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | path | string | yes | Required. The name of the external transaction that will be refunded. Format: applications/{package_name}/externalTransactions/{external_transaction} |

- Request body: `RefundExternalTransactionRequest`
- Response: `ExternalTransaction`


# Resource: `generatedapks`

### `generatedapks.download`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode}/downloads/{downloadId}:download`

Downloads a single signed APK generated from an app bundle.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | path | integer | yes | Version code of the app bundle. |
| `downloadId` | path | string | yes | Download ID, which uniquely identifies the APK to download. Can be obtained from the response of `generatedapks.list` method. |
| `packageName` | path | string | yes | Package name of the app. |


### `generatedapks.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/generatedApks/{versionCode}`

Returns download metadata for all APKs that were generated from a given app bundle.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | path | integer | yes | Version code of the app bundle. |
| `packageName` | path | string | yes | Package name of the app. |

- Response: `GeneratedApksListResponse`


# Resource: `grants`

### `grants.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/{+parent}/grants`

Grant access for a user to the given package.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `parent` | path | string | yes | Required. The user which needs permission. Format: developers/{developer}/users/{user} |

- Request body: `Grant`
- Response: `Grant`

### `grants.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}`

Removes all access for the user to the given package or developer account.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | path | string | yes | Required. The name of the grant to delete. Format: developers/{developer}/users/{email}/grants/{package_name} |


### `grants.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}`

Updates access for the user to the given package.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `updateMask` | query | string |  | Optional. The list of fields to be updated. |
| `name` | path | string | yes | Required. Resource name for this grant, following the pattern "developers/{developer}/users/{email}/grants/{package_name}". If this grant is for a draft app, the app ID will be use |

- Request body: `Grant`
- Response: `Grant`


# Resource: `inappproducts`

### `inappproducts.batchDelete`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts:batchDelete`

Deletes in-app products (managed products or subscriptions). Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput. This method should not be used to delete subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |

- Request body: `InappproductsBatchDeleteRequest`

### `inappproducts.batchGet`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts:batchGet`

Reads multiple in-app products, which can be managed products or subscriptions. This method should not be used to retrieve subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `sku` | query | string |  | Unique identifier for the in-app products. |

- Response: `InappproductsBatchGetResponse`

### `inappproducts.batchUpdate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts:batchUpdate`

Updates or inserts one or more in-app products (managed products or subscriptions). Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput. This method should no longer be used to update subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |

- Request body: `InappproductsBatchUpdateRequest`
- Response: `InappproductsBatchUpdateResponse`

### `inappproducts.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts/{sku}`

Deletes an in-app product (a managed product or a subscription). This method should no longer be used to delete subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `sku` | path | string | yes | Unique identifier for the in-app product. |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |
| `packageName` | path | string | yes | Package name of the app. |


### `inappproducts.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts/{sku}`

Gets an in-app product, which can be a managed product or a subscription. This method should no longer be used to retrieve subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `sku` | path | string | yes | Unique identifier for the in-app product. |

- Response: `InAppProduct`

### `inappproducts.insert`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts`

Creates an in-app product (a managed product or a subscription). This method should no longer be used to create subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `autoConvertMissingPrices` | query | boolean |  | If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the d |

- Request body: `InAppProduct`
- Response: `InAppProduct`

### `inappproducts.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts`

Lists all in-app products - both managed products and subscriptions. If an app has a large number of in-app products, the response may be paginated. In this case the response field `tokenPagination.nextPageToken` will be set and the caller should provide its value as a `token` request parameter to retrieve the next page. This method should no longer be used to retrieve subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `maxResults` | query | integer |  | Deprecated and ignored. The page size is determined by the server. |
| `token` | query | string |  | Pagination token. If empty, list starts at the first product. |
| `startIndex` | query | integer |  | Deprecated and ignored. Set the `token` parameter to retrieve the next page. |

- Response: `InappproductsListResponse`

### `inappproducts.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts/{sku}`

Patches an in-app product (a managed product or a subscription). This method should no longer be used to update subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `autoConvertMissingPrices` | query | boolean |  | If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the d |
| `sku` | path | string | yes | Unique identifier for the in-app product. |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |

- Request body: `InAppProduct`
- Response: `InAppProduct`

### `inappproducts.update`

`PUT https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/inappproducts/{sku}`

Updates an in-app product (a managed product or a subscription). This method should no longer be used to update subscriptions. See [this article](https://android-developers.googleblog.com/2023/06/changes-to-google-play-developer-api-june-2023.html) for more information.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `allowMissing` | query | boolean |  | If set to true, and the in-app product with the given package_name and sku doesn't exist, the in-app product will be created. |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |
| `packageName` | path | string | yes | Package name of the app. |
| `autoConvertMissingPrices` | query | boolean |  | If true the prices for all regions targeted by the parent app that don't have a price specified for this in-app product will be auto converted to the target currency based on the d |
| `sku` | path | string | yes | Unique identifier for the in-app product. |

- Request body: `InAppProduct`
- Response: `InAppProduct`


# Resource: `internalappsharingartifacts`

### `internalappsharingartifacts.uploadapk`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/apk`

Uploads an APK to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See [Timeouts and Errors](https://developers.google.com/api-client-library/java/google-api-java-client/errors) for an example in java.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |

- Response: `InternalAppSharingArtifact`
- **Media upload supported** — max size `1073741824`, accepts `application/octet-stream, application/vnd.android.package-archive`

### `internalappsharingartifacts.uploadbundle`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/internalappsharing/{packageName}/artifacts/bundle`

Uploads an app bundle to internal app sharing. If you are using the Google API client libraries, please increase the timeout of the http request before calling this endpoint (a timeout of 2 minutes is recommended). See [Timeouts and Errors](https://developers.google.com/api-client-library/java/google-api-java-client/errors) for an example in java.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |

- Response: `InternalAppSharingArtifact`
- **Media upload supported** — max size `10737418240`, accepts `application/octet-stream`


# Resource: `monetization`

### `monetization.convertRegionPrices`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/pricing:convertRegionPrices`

Calculates the region prices, using today's exchange rate and country-specific pricing patterns, based on the price in the request for a set of regions.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The app package name. |

- Request body: `ConvertRegionPricesRequest`
- Response: `ConvertRegionPricesResponse`

### `monetization.onetimeproducts.batchDelete`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchDelete`

Deletes one or more one-time products.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the one-time products should be deleted. Must be equal to the package_name field on all the OneTimeProduct resources. |

- Request body: `BatchDeleteOneTimeProductsRequest`

### `monetization.onetimeproducts.batchGet`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchGet`

Reads one or more one-time products.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productIds` | query | string |  | Required. A list of up to 100 product IDs to retrieve. All IDs must be different. |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the products should be retrieved. Must be equal to the package_name field on all requests. |

- Response: `BatchGetOneTimeProductsResponse`

### `monetization.onetimeproducts.batchUpdate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts:batchUpdate`

Creates or updates one or more one-time products.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the one-time products should be updated. Must be equal to the package_name field on all the OneTimeProduct resources. |

- Request body: `BatchUpdateOneTimeProductsRequest`
- Response: `BatchUpdateOneTimeProductsResponse`

### `monetization.onetimeproducts.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}`

Deletes a one-time product.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the one-time product to delete. |
| `productId` | path | string | yes | Required. The one-time product ID of the one-time product to delete. |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |


### `monetization.onetimeproducts.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}`

Reads a single one-time product.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the product to retrieve. |
| `productId` | path | string | yes | Required. The product ID of the product to retrieve. |

- Response: `OneTimeProduct`

### `monetization.onetimeproducts.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts`

Lists all one-time products under a given app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `pageSize` | query | integer |  | Optional. The maximum number of one-time product to return. The service may return fewer than this value. If unspecified, at most 50 one-time products will be returned. The maximum |
| `pageToken` | query | string |  | Optional. A page token, received from a previous `ListOneTimeProducts` call. Provide this to retrieve the subsequent page. When paginating, all other parameters provided to `ListOn |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the one-time product should be read. |

- Response: `ListOneTimeProductsResponse`

### `monetization.onetimeproducts.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/onetimeproducts/{productId}`

Creates or updates a one-time product.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productId` | path | string | yes | Required. Immutable. Unique product ID of the product. Unique within the parent app. Product IDs must start with a number or lowercase letter, and can contain numbers (0-9), lowerc |
| `allowMissing` | query | boolean |  | Optional. If set to true, and the one-time product with the given package_name and product_id doesn't exist, the one-time product will be created. If a new one-time product is crea |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product upsert. Defaults to latency-sensitive. |
| `packageName` | path | string | yes | Required. Immutable. Package name of the parent app. |
| `regionsVersion.version` | query | string |  | Required. A string representing the version of available regions being used for the specified resource. Regional prices and latest supported version for the resource have to be spe |
| `updateMask` | query | string |  | Required. The list of fields to be updated. |

- Request body: `OneTimeProduct`
- Response: `OneTimeProduct`

### `monetization.onetimeproducts.purchaseOptions.batchDelete`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchDelete`

Deletes purchase options across one or multiple one-time products. By default this operation will fail if there are any existing offers under the deleted purchase options. Use the force parameter to override the default behavior.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the purchase options to delete. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all purchase options to delete belong to the same one-time product. If this batch delete spans multiple one-time product |

- Request body: `BatchDeletePurchaseOptionsRequest`

### `monetization.onetimeproducts.purchaseOptions.batchUpdateStates`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions:batchUpdateStates`

Activates or deactivates purchase options across one or multiple one-time products.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated purchase options. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all updated purchase options belong to the same one-time product. If this batch update spans multiple one-time products, |

- Request body: `BatchUpdatePurchaseOptionStatesRequest`
- Response: `BatchUpdatePurchaseOptionStatesResponse`

### `monetization.onetimeproducts.purchaseOptions.offers.activate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:activate`

Activates a one-time product offer.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `offerId` | path | string | yes | Required. The offer ID of the offer to activate. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to activate. |
| `productId` | path | string | yes | Required. The parent one-time product (ID) of the offer to activate. |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) of the offer to activate. |

- Request body: `ActivateOneTimeProductOfferRequest`
- Response: `OneTimeProductOffer`

### `monetization.onetimeproducts.purchaseOptions.offers.batchDelete`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchDelete`

Deletes one or more one-time product offers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offers to delete. Must be equal to the package_name field on all the OneTimeProductOffer resources. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all offers to delete belong to the same product. If this request spans multiple one-time products, set this field to "-" |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) for which the offers should be deleted. May be specified as '-' to update offers from multiple purchase options. |

- Request body: `BatchDeleteOneTimeProductOffersRequest`

### `monetization.onetimeproducts.purchaseOptions.offers.batchGet`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchGet`

Reads one or more one-time product offers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated offers. Must be equal to the package_name field on all the updated OneTimeProductOffer resources. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all updated offers belong to the same product. If this request spans multiple one-time products, set this field to "-". |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) for which the offers should be updated. May be specified as '-' to update offers from multiple purchase options. |

- Request body: `BatchGetOneTimeProductOffersRequest`
- Response: `BatchGetOneTimeProductOffersResponse`

### `monetization.onetimeproducts.purchaseOptions.offers.batchUpdate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdate`

Creates or updates one or more one-time product offers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) for which the offers should be updated. May be specified as '-' to update offers from multiple purchase options. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated offers. Must be equal to the package_name field on all the updated OneTimeProductOffer resources. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all updated offers belong to the same product. If this request spans multiple one-time products, set this field to "-". |

- Request body: `BatchUpdateOneTimeProductOffersRequest`
- Response: `BatchUpdateOneTimeProductOffersResponse`

### `monetization.onetimeproducts.purchaseOptions.offers.batchUpdateStates`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers:batchUpdateStates`

Updates a batch of one-time product offer states.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated one-time product offers. |
| `productId` | path | string | yes | Required. The product ID of the parent one-time product, if all updated offers belong to the same one-time product. If this batch update spans multiple one-time products, set this  |
| `purchaseOptionId` | path | string | yes | Required. The purchase option ID of the parent purchase option, if all updated offers belong to the same purchase option. If this batch update spans multiple purchase options, set  |

- Request body: `BatchUpdateOneTimeProductOfferStatesRequest`
- Response: `BatchUpdateOneTimeProductOfferStatesResponse`

### `monetization.onetimeproducts.purchaseOptions.offers.cancel`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:cancel`

Cancels a one-time product offer.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) of the offer to cancel. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to cancel. |
| `productId` | path | string | yes | Required. The parent one-time product (ID) of the offer to cancel. |
| `offerId` | path | string | yes | Required. The offer ID of the offer to cancel. |

- Request body: `CancelOneTimeProductOfferRequest`
- Response: `OneTimeProductOffer`

### `monetization.onetimeproducts.purchaseOptions.offers.deactivate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers/{offerId}:deactivate`

Deactivates a one-time product offer.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `offerId` | path | string | yes | Required. The offer ID of the offer to deactivate. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to deactivate. |
| `productId` | path | string | yes | Required. The parent one-time product (ID) of the offer to deactivate. |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) of the offer to deactivate. |

- Request body: `DeactivateOneTimeProductOfferRequest`
- Response: `OneTimeProductOffer`

### `monetization.onetimeproducts.purchaseOptions.offers.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/oneTimeProducts/{productId}/purchaseOptions/{purchaseOptionId}/offers`

Lists all offers under a given app, product, or purchase option.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `pageSize` | query | integer |  | Optional. The maximum number of offers to return. The service may return fewer than this value. If unspecified, at most 50 offers will be returned. The maximum value is 1000; value |
| `purchaseOptionId` | path | string | yes | Required. The parent purchase option (ID) for which the offers should be read. May be specified as '-' to read all offers under a one-time product or an app. Must be specified as ' |
| `pageToken` | query | string |  | Optional. A page token, received from a previous `ListOneTimeProductsOffers` call. Provide this to retrieve the subsequent page. When paginating, product_id, package_name and purch |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the offers should be read. |
| `productId` | path | string | yes | Required. The parent one-time product (ID) for which the offers should be read. May be specified as '-' to read all offers under an app. |

- Response: `ListOneTimeProductOffersResponse`

### `monetization.subscriptions.archive`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}:archive`

Deprecated: subscription archiving is not supported.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the app of the subscription to delete. |
| `productId` | path | string | yes | Required. The unique product ID of the subscription to delete. |

- Request body: `ArchiveSubscriptionRequest`
- Response: `Subscription`

### `monetization.subscriptions.batchGet`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions:batchGet`

Reads one or more subscriptions.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be retrieved. Must be equal to the package_name field on all the requests. |
| `productIds` | query | string |  | Required. A list of up to 100 subscription product IDs to retrieve. All the IDs must be different. |

- Response: `BatchGetSubscriptionsResponse`

### `monetization.subscriptions.batchUpdate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions:batchUpdate`

Updates a batch of subscriptions. Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be updated. Must be equal to the package_name field on all the Subscription resources. |

- Request body: `BatchUpdateSubscriptionsRequest`
- Response: `BatchUpdateSubscriptionsResponse`

### `monetization.subscriptions.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions`

Creates a new subscription. Newly added base plans will remain in draft state until activated.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscription should be created. Must be equal to the package_name field on the Subscription resource. |
| `productId` | query | string |  | Required. The ID to use for the subscription. For the requirements on this format, see the documentation of the product_id field on the Subscription resource. |
| `regionsVersion.version` | query | string |  | Required. A string representing the version of available regions being used for the specified resource. Regional prices and latest supported version for the resource have to be spe |

- Request body: `Subscription`
- Response: `Subscription`

### `monetization.subscriptions.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}`

Deletes a subscription. A subscription can only be deleted if it has never had a base plan published.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the app of the subscription to delete. |
| `productId` | path | string | yes | Required. The unique product ID of the subscription to delete. |


### `monetization.subscriptions.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}`

Reads a single subscription.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the subscription to get. |
| `productId` | path | string | yes | Required. The unique product ID of the subscription to get. |

- Response: `Subscription`

### `monetization.subscriptions.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions`

Lists all subscriptions under a given app.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `pageToken` | query | string |  | A page token, received from a previous `ListSubscriptions` call. Provide this to retrieve the subsequent page. When paginating, all other parameters provided to `ListSubscriptions` |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be read. |
| `pageSize` | query | integer |  | The maximum number of subscriptions to return. The service may return fewer than this value. If unspecified, at most 50 subscriptions will be returned. The maximum value is 1000; v |
| `showArchived` | query | boolean |  | Deprecated: subscription archiving is not supported. |

- Response: `ListSubscriptionsResponse`

### `monetization.subscriptions.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}`

Updates an existing subscription.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productId` | path | string | yes | Immutable. Unique product ID of the product. Unique within the parent app. Product IDs must be composed of lower-case letters (a-z), numbers (0-9), underscores (_) and dots (.). It |
| `updateMask` | query | string |  | Required. The list of fields to be updated. |
| `packageName` | path | string | yes | Immutable. Package name of the parent app. |
| `regionsVersion.version` | query | string |  | Required. A string representing the version of available regions being used for the specified resource. Regional prices and latest supported version for the resource have to be spe |
| `allowMissing` | query | boolean |  | Optional. If set to true, and the subscription with the given package_name and product_id doesn't exist, the subscription will be created. If a new subscription is created, update_ |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |

- Request body: `Subscription`
- Response: `Subscription`

### `monetization.subscriptions.basePlans.activate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:activate`

Activates a base plan. Once activated, base plans will be available to new subscribers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the base plan to activate. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the base plan to activate. |
| `basePlanId` | path | string | yes | Required. The unique base plan ID of the base plan to activate. |

- Request body: `ActivateBasePlanRequest`
- Response: `Subscription`

### `monetization.subscriptions.basePlans.batchMigratePrices`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchMigratePrices`

Batch variant of the MigrateBasePlanPrices endpoint. Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be created or updated. Must be equal to the package_name field on all the Subscription resources. |
| `productId` | path | string | yes | Required. The product ID of the parent subscription, if all updated offers belong to the same subscription. If this batch update spans multiple subscriptions, set this field to "-" |

- Request body: `BatchMigrateBasePlanPricesRequest`
- Response: `BatchMigrateBasePlanPricesResponse`

### `monetization.subscriptions.basePlans.batchUpdateStates`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans:batchUpdateStates`

Activates or deactivates base plans across one or multiple subscriptions. Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated base plans. |
| `productId` | path | string | yes | Required. The product ID of the parent subscription, if all updated base plans belong to the same subscription. If this batch update spans multiple subscriptions, set this field to |

- Request body: `BatchUpdateBasePlanStatesRequest`
- Response: `BatchUpdateBasePlanStatesResponse`

### `monetization.subscriptions.basePlans.deactivate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:deactivate`

Deactivates a base plan. Once deactivated, the base plan will become unavailable to new subscribers, but existing subscribers will maintain their subscription

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the base plan to deactivate. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the base plan to deactivate. |
| `basePlanId` | path | string | yes | Required. The unique base plan ID of the base plan to deactivate. |

- Request body: `DeactivateBasePlanRequest`
- Response: `Subscription`

### `monetization.subscriptions.basePlans.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}`

Deletes a base plan. Can only be done for draft base plans. This action is irreversible.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the base plan to delete. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the base plan to delete. |
| `basePlanId` | path | string | yes | Required. The unique offer ID of the base plan to delete. |


### `monetization.subscriptions.basePlans.migratePrices`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}:migratePrices`

Migrates subscribers from one or more legacy price cohorts to the current price. Requests result in Google Play notifying affected subscribers. Only up to 250 simultaneous legacy price cohorts are supported.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. Package name of the parent app. Must be equal to the package_name field on the Subscription resource. |
| `productId` | path | string | yes | Required. The ID of the subscription to update. Must be equal to the product_id field on the Subscription resource. |
| `basePlanId` | path | string | yes | Required. The unique base plan ID of the base plan to update prices on. |

- Request body: `MigrateBasePlanPricesRequest`
- Response: `MigrateBasePlanPricesResponse`

### `monetization.subscriptions.basePlans.offers.activate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:activate`

Activates a subscription offer. Once activated, subscription offers will be available to new subscribers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to activate. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the offer to activate. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) of the offer to activate. |
| `offerId` | path | string | yes | Required. The unique offer ID of the offer to activate. |

- Request body: `ActivateSubscriptionOfferRequest`
- Response: `SubscriptionOffer`

### `monetization.subscriptions.basePlans.offers.batchGet`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchGet`

Reads one or more subscription offers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be created or updated. Must be equal to the package_name field on all the requests. |
| `productId` | path | string | yes | Required. The product ID of the parent subscription, if all updated offers belong to the same subscription. If this request spans multiple subscriptions, set this field to "-". Mus |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) for which the offers should be read. May be specified as '-' to read offers from multiple base plans. |

- Request body: `BatchGetSubscriptionOffersRequest`
- Response: `BatchGetSubscriptionOffersResponse`

### `monetization.subscriptions.basePlans.offers.batchUpdate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdate`

Updates a batch of subscription offers. Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated subscription offers. Must be equal to the package_name field on all the updated SubscriptionOffer resources. |
| `productId` | path | string | yes | Required. The product ID of the parent subscription, if all updated offers belong to the same subscription. If this request spans multiple subscriptions, set this field to "-". Mus |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) for which the offers should be updated. May be specified as '-' to update offers from multiple base plans. |

- Request body: `BatchUpdateSubscriptionOffersRequest`
- Response: `BatchUpdateSubscriptionOffersResponse`

### `monetization.subscriptions.basePlans.offers.batchUpdateStates`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers:batchUpdateStates`

Updates a batch of subscription offer states. Set the latencyTolerance field on nested requests to PRODUCT_UPDATE_LATENCY_TOLERANCE_LATENCY_TOLERANT to achieve maximum update throughput.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The parent app (package name) of the updated subscription offers. Must be equal to the package_name field on all the updated SubscriptionOffer resources. |
| `productId` | path | string | yes | Required. The product ID of the parent subscription, if all updated offers belong to the same subscription. If this request spans multiple subscriptions, set this field to "-". Mus |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) for which the offers should be updated. May be specified as '-' to update offers from multiple base plans. |

- Request body: `BatchUpdateSubscriptionOfferStatesRequest`
- Response: `BatchUpdateSubscriptionOfferStatesResponse`

### `monetization.subscriptions.basePlans.offers.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers`

Creates a new subscription offer. Only auto-renewing base plans can have subscription offers. The offer state will be DRAFT until it is activated.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productId` | path | string | yes | Required. The parent subscription (ID) for which the offer should be created. Must be equal to the product_id field on the SubscriptionOffer resource. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) for which the offer should be created. Must be equal to the base_plan_id field on the SubscriptionOffer resource. |
| `offerId` | query | string |  | Required. The ID to use for the offer. For the requirements on this format, see the documentation of the offer_id field on the SubscriptionOffer resource. |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the offer should be created. Must be equal to the package_name field on the Subscription resource. |
| `regionsVersion.version` | query | string |  | Required. A string representing the version of available regions being used for the specified resource. Regional prices and latest supported version for the resource have to be spe |

- Request body: `SubscriptionOffer`
- Response: `SubscriptionOffer`

### `monetization.subscriptions.basePlans.offers.deactivate`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}:deactivate`

Deactivates a subscription offer. Once deactivated, existing subscribers will maintain their subscription, but the offer will become unavailable to new subscribers.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `offerId` | path | string | yes | Required. The unique offer ID of the offer to deactivate. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to deactivate. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the offer to deactivate. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) of the offer to deactivate. |

- Request body: `DeactivateSubscriptionOfferRequest`
- Response: `SubscriptionOffer`

### `monetization.subscriptions.basePlans.offers.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}`

Deletes a subscription offer. Can only be done for draft offers. This action is irreversible.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `offerId` | path | string | yes | Required. The unique offer ID of the offer to delete. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to delete. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the offer to delete. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) of the offer to delete. |


### `monetization.subscriptions.basePlans.offers.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}`

Reads a single offer

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `offerId` | path | string | yes | Required. The unique offer ID of the offer to get. |
| `packageName` | path | string | yes | Required. The parent app (package name) of the offer to get. |
| `productId` | path | string | yes | Required. The parent subscription (ID) of the offer to get. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) of the offer to get. |

- Response: `SubscriptionOffer`

### `monetization.subscriptions.basePlans.offers.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers`

Lists all offers under a given subscription.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productId` | path | string | yes | Required. The parent subscription (ID) for which the offers should be read. May be specified as '-' to read all offers under an app. |
| `basePlanId` | path | string | yes | Required. The parent base plan (ID) for which the offers should be read. May be specified as '-' to read all offers under a subscription or an app. Must be specified as '-' if prod |
| `packageName` | path | string | yes | Required. The parent app (package name) for which the subscriptions should be read. |
| `pageToken` | query | string |  | A page token, received from a previous `ListSubscriptionsOffers` call. Provide this to retrieve the subsequent page. When paginating, all other parameters provided to `ListSubscrip |
| `pageSize` | query | integer |  | The maximum number of subscriptions to return. The service may return fewer than this value. If unspecified, at most 50 subscriptions will be returned. The maximum value is 1000; v |

- Response: `ListSubscriptionOffersResponse`

### `monetization.subscriptions.basePlans.offers.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/subscriptions/{productId}/basePlans/{basePlanId}/offers/{offerId}`

Updates an existing subscription offer.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `productId` | path | string | yes | Required. Immutable. The ID of the parent subscription this offer belongs to. |
| `basePlanId` | path | string | yes | Required. Immutable. The ID of the base plan to which this offer is an extension. |
| `offerId` | path | string | yes | Required. Immutable. Unique ID of this subscription offer. Must be unique within the base plan. |
| `allowMissing` | query | boolean |  | Optional. If set to true, and the subscription offer with the given package_name, product_id, base_plan_id and offer_id doesn't exist, an offer will be created. If a new offer is c |
| `latencyTolerance` | query | string |  | Optional. The latency tolerance for the propagation of this product update. Defaults to latency-sensitive. |
| `packageName` | path | string | yes | Required. Immutable. The package name of the app the parent subscription belongs to. |
| `regionsVersion.version` | query | string |  | Required. A string representing the version of available regions being used for the specified resource. Regional prices and latest supported version for the resource have to be spe |
| `updateMask` | query | string |  | Required. The list of fields to be updated. |

- Request body: `SubscriptionOffer`
- Response: `SubscriptionOffer`


# Resource: `orders`

### `orders.batchget`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/orders:batchGet`

Get order details for a list of orders.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing'). |
| `orderIds` | query | string |  | Required. The list of order IDs to retrieve order details for. There must be between 1 and 1000 (inclusive) order IDs per request. If any order ID is not found or does not match th |

- Response: `BatchGetOrdersResponse`

### `orders.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/orders/{orderId}`

Get order details for a single order.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing'). |
| `orderId` | path | string | yes | Required. The order ID provided to the user when the subscription or in-app order was purchased. |

- Response: `Order`

### `orders.refund`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/orders/{orderId}:refund`

Refunds a user's subscription or in-app purchase order. Orders older than 3 years cannot be refunded.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing'). |
| `orderId` | path | string | yes | The order ID provided to the user when the subscription or in-app order was purchased. |
| `revoke` | query | boolean |  | Whether to revoke the purchased item. If set to true, access to the subscription or in-app item will be terminated immediately. If the item is a recurring subscription, all future  |


### `orders.reviewrefund`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/orders/{orderId}:reviewrefund`

Provide refund preference and purchase usage for a chargeback request

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The package name of the application for which this subscription or in-app item was purchased (for example, 'com.some.thing'). |
| `orderId` | path | string | yes | Required. The order ID provided to the user when the subscription or in-app order was purchased. |

- Request body: `OrdersReviewRefundRequest`


# Resource: `purchases`

### `purchases.products.acknowledge`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:acknowledge`

Acknowledges a purchase of an inapp item.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | The package name of the application the inapp product was sold in (for example, 'com.some.thing'). |
| `productId` | path | string | yes | The inapp product SKU (for example, 'com.some.thing.inapp1'). |
| `token` | path | string | yes | The token provided to the user's device when the inapp product was purchased. |

- Request body: `ProductPurchasesAcknowledgeRequest`

### `purchases.products.consume`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}:consume`

Consumes a purchase for an inapp item.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | The package name of the application the inapp product was sold in (for example, 'com.some.thing'). |
| `productId` | path | string | yes | The inapp product SKU (for example, 'com.some.thing.inapp1'). |
| `token` | path | string | yes | The token provided to the user's device when the inapp product was purchased. |


### `purchases.products.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/products/{productId}/tokens/{token}`

Checks the purchase and consumption status of an inapp item.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | path | string | yes | The token provided to the user's device when the inapp product was purchased. |
| `packageName` | path | string | yes | The package name of the application the inapp product was sold in (for example, 'com.some.thing'). |
| `productId` | path | string | yes | The inapp product SKU (for example, 'com.some.thing.inapp1'). |

- Response: `ProductPurchase`

### `purchases.productsv2.getproductpurchasev2`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/productsv2/tokens/{token}`

Checks the purchase and consumption status of an inapp item.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | path | string | yes | The token provided to the user's device when the inapp product was purchased. |
| `packageName` | path | string | yes | The package name of the application the inapp product was sold in (for example, 'com.some.thing'). |

- Response: `ProductPurchaseV2`

### `purchases.subscriptions.acknowledge`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:acknowledge`

Acknowledges a subscription purchase.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `subscriptionId` | path | string | yes | Note: Since May 21, 2025, subscription_id is not required, and not recommended for subscription with add-ons. The purchased subscription ID (for example, 'monthly001'). |
| `packageName` | path | string | yes | The package name of the application for which this subscription was purchased (for example, 'com.some.thing'). |
| `token` | path | string | yes | The token provided to the user's device when the subscription was purchased. |

- Request body: `SubscriptionPurchasesAcknowledgeRequest`

### `purchases.subscriptions.cancel`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:cancel`

Deprecated: Use purchases.subscriptionsv2.cancel instead. Cancels a user's subscription purchase. The subscription remains valid until its expiration time. Newer version is available at purchases.subscriptionsv2.cancel for better client library support.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | The package name of the application for which this subscription was purchased (for example, 'com.some.thing'). |
| `token` | path | string | yes | The token provided to the user's device when the subscription was purchased. |
| `subscriptionId` | path | string | yes | Note: Since May 21, 2025, subscription_id is not required, and not recommended for subscription with add-ons. The purchased subscription ID (for example, 'monthly001'). |


### `purchases.subscriptions.defer`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptions/{subscriptionId}/tokens/{token}:defer`

Deprecated: Use purchases.subscriptionsv2.defer instead. Defers a user's subscription purchase until a specified future expiration time.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | path | string | yes | The token provided to the user's device when the subscription was purchased. |
| `packageName` | path | string | yes | The package name of the application for which this subscription was purchased (for example, 'com.some.thing'). |
| `subscriptionId` | path | string | yes | The purchased subscription ID (for example, 'monthly001'). |

- Request body: `SubscriptionPurchasesDeferRequest`
- Response: `SubscriptionPurchasesDeferResponse`

### `purchases.subscriptionsv2.cancel`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:cancel`

Cancel a subscription purchase for the user.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | path | string | yes | Required. The token provided to the user's device when the subscription was purchased. |
| `packageName` | path | string | yes | Required. The package of the application for which this subscription was purchased (for example, 'com.some.thing'). |

- Request body: `CancelSubscriptionPurchaseRequest`
- Response: `CancelSubscriptionPurchaseResponse`

### `purchases.subscriptionsv2.defer`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:defer`

Defers the renewal of a subscription.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Required. The package of the application for which this subscription was purchased (for example, 'com.some.thing'). |
| `token` | path | string | yes | Required. The token provided to the user's device when the subscription was purchased. |

- Request body: `DeferSubscriptionPurchaseRequest`
- Response: `DeferSubscriptionPurchaseResponse`

### `purchases.subscriptionsv2.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}`

Get metadata about a subscription

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | The package of the application for which this subscription was purchased (for example, 'com.some.thing'). |
| `token` | path | string | yes | Required. The token provided to the user's device when the subscription was purchased. |

- Response: `SubscriptionPurchaseV2`

### `purchases.subscriptionsv2.revoke`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/subscriptionsv2/tokens/{token}:revoke`

Revoke a subscription purchase for the user.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | path | string | yes | Required. The token provided to the user's device when the subscription was purchased. |
| `packageName` | path | string | yes | Required. The package of the application for which this subscription was purchased (for example, 'com.some.thing'). |

- Request body: `RevokeSubscriptionPurchaseRequest`
- Response: `RevokeSubscriptionPurchaseResponse`

### `purchases.voidedpurchases.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/purchases/voidedpurchases`

Lists the purchases that were canceled, refunded or charged-back.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | query | string |  | Defines the token of the page to return, usually taken from TokenPagination. This can only be used if token paging is enabled. |
| `packageName` | path | string | yes | The package name of the application for which voided purchases need to be returned (for example, 'com.some.thing'). |
| `maxResults` | query | integer |  | Defines how many results the list operation should return. The default number depends on the resource collection. |
| `startIndex` | query | integer |  | Defines the index of the first element to return. This can only be used if indexed paging is enabled. |
| `type` | query | integer |  | The type of voided purchases that you want to see in the response. Possible values are: 0. Only voided in-app product purchases will be returned in the response. This is the defaul |
| `startTime` | query | string |  | The time, in milliseconds since the Epoch, of the oldest voided purchase that you want to see in the response. The value of this parameter cannot be older than 30 days and is ignor |
| `endTime` | query | string |  | The time, in milliseconds since the Epoch, of the newest voided purchase that you want to see in the response. The value of this parameter cannot be greater than the current time a |
| `includeQuantityBasedPartialRefund` | query | boolean |  | Optional. Whether to include voided purchases of quantity-based partial refunds, which are applicable only to multi-quantity purchases. If true, additional voided purchases may be  |

- Response: `VoidedPurchasesListResponse`


# Resource: `reviews`

### `reviews.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/reviews/{reviewId}`

Gets a single review.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `translationLanguage` | query | string |  | Language localization code. |
| `packageName` | path | string | yes | Package name of the app. |
| `reviewId` | path | string | yes | Unique identifier for a review. |

- Response: `Review`

### `reviews.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/reviews`

Lists all reviews.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `token` | query | string |  | Pagination token. If empty, list starts at the first review. |
| `packageName` | path | string | yes | Package name of the app. |
| `maxResults` | query | integer |  | How many results the list operation should return. |
| `translationLanguage` | query | string |  | Language localization code. |
| `startIndex` | query | integer |  | The index of the first element to return. |

- Response: `ReviewsListResponse`

### `reviews.reply`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/reviews/{reviewId}:reply`

Replies to a single review, or updates an existing reply.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `reviewId` | path | string | yes | Unique identifier for a review. |

- Request body: `ReviewsReplyRequest`
- Response: `ReviewsReplyResponse`


# Resource: `systemapks`

### `systemapks.variants.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants`

Creates an APK which is suitable for inclusion in a system image from an already uploaded Android App Bundle.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | path | string | yes | The version code of the App Bundle. |
| `packageName` | path | string | yes | Package name of the app. |

- Request body: `Variant`
- Response: `Variant`

### `systemapks.variants.download`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId}:download`

Downloads a previously created system APK which is suitable for inclusion in a system image.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | path | string | yes | The version code of the App Bundle. |
| `packageName` | path | string | yes | Package name of the app. |
| `variantId` | path | integer | yes | The ID of a previously created system APK variant. |


### `systemapks.variants.get`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants/{variantId}`

Returns a previously created system APK variant.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `packageName` | path | string | yes | Package name of the app. |
| `variantId` | path | integer | yes | The ID of a previously created system APK variant. |
| `versionCode` | path | string | yes | The version code of the App Bundle. |

- Response: `Variant`

### `systemapks.variants.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/applications/{packageName}/systemApks/{versionCode}/variants`

Returns the list of previously created system APK variants.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `versionCode` | path | string | yes | The version code of the App Bundle. |
| `packageName` | path | string | yes | Package name of the app. |

- Response: `SystemApksListResponse`


# Resource: `users`

### `users.create`

`POST https://androidpublisher.googleapis.com/androidpublisher/v3/{+parent}/users`

Grant access for a user to the given developer account.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `parent` | path | string | yes | Required. The developer account to add the user to. Format: developers/{developer} |

- Request body: `User`
- Response: `User`

### `users.delete`

`DELETE https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}`

Removes all access for the user to the given developer account.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `name` | path | string | yes | Required. The name of the user to delete. Format: developers/{developer}/users/{email} |


### `users.list`

`GET https://androidpublisher.googleapis.com/androidpublisher/v3/{+parent}/users`

Lists all users with access to a developer account.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `parent` | path | string | yes | Required. The developer account to fetch users from. Format: developers/{developer} |
| `pageToken` | query | string |  | A token received from a previous call to this method, in order to retrieve further results. |
| `pageSize` | query | integer |  | The maximum number of results to return. This must be set to -1 to disable pagination. |

- Response: `ListUsersResponse`

### `users.patch`

`PATCH https://androidpublisher.googleapis.com/androidpublisher/v3/{+name}`

Updates access for the user to the developer account.

| Parameter | In | Type | Required | Description |
| --- | --- | --- | --- | --- |
| `updateMask` | query | string |  | Optional. The list of fields to be updated. |
| `name` | path | string | yes | Required. Resource name for this user, following the pattern "developers/{developer}/users/{email}". |

- Request body: `User`
- Response: `User`

