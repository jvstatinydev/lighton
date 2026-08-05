# Voided Purchases API  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/voided-purchases

---

## Page Summary

 outlined_flag

- 
 The Google Play Voided Purchases API provides a list of orders associated with voided purchases to help implement a revocation system.

- 
 This API is applicable to one-time in-app orders and App Subscriptions.

- 
 Purchases can be voided due to user requests for refunds, cancellations, chargebacks, or developer/Google initiated cancellations/refunds with the revoke option enabled.

- 
 Access to the API requires viewing financial information permission, typically through an OAuth client or service account.

- 
 Best practices for using the API include fetching data safely with default parameters and continuation tokens, integrating with Real-time developer notifications, and implementing a fair and transparent revocation policy.

The Google Play Voided Purchases API provides a list of orders that
are associated with purchases that a user has voided. You can use information
from this list to implement a revocation system that prevents the user from
accessing products from those orders.

This API applies to one-time in-app orders and App Subscriptions.

A purchase can be voided in the following ways:

- The user requests a refund for their order.

- The user cancels their order.

- An order is charged back.

- Developer cancels or refunds order.

Note: only revoked orders will be shown in the Voided Purchases API.
If a developer refunds a purchase without setting the revoke option,
the order will not be returned by the API.

- Google cancels or refunds order.

By using this API, you help create a more balanced and fair experience for all
of your app's users, particularly if your app is a game.

Note: Unlike other order-related data sources, the Voided Purchases API
includes purchases that are charged back by payment processors. Therefore, you
might see inconsistencies between the information from this API and
information from other order-related data sources.Note: The Voided Purchases API returns voided purchases only when they need to
be revoked. Developers can use this API as an indication for when to take
additional action on their end. However, some purchases may be refunded
with reason that the purchase was never acknowledged by the developer, and
therefore may not exist in the developer's records.

## Gaining Access

To work with the Voided Purchases API, you need to have permission to view
financial information. You provide authorization using an OAuth client or a
service account. If you're using a service account, enable the "View financial
reports" permission within this account.

To learn more about gaining authorized access to Google Play Developer APIs, see
the following guides:

- Setting Up API Access Clients

- Add developer account users & manage permissions

## Viewing Voided Purchases

Use the GET method to request a list of voided purchases. In your request,
include the fully-qualified package name for your app—such as
com.google.android.apps.maps—and the authorization token you
received when gaining access to the API.

```

GET https://www.googleapis.com/androidpublisher/v3/applications/
your_package_name/purchases/voidedpurchases?access_token=your_auth_token

```

You can also include the following parameters in your request, each of which is
optional:

 startTime
 The time, in milliseconds since the Unix epoch, of the oldest
 voided purchase that you want to see in the response. By default,
 startTime is set to 30 days ago.

 The API can only show voided purchases that have occurred during the past
 30 days. Older voided purchases are not included in the response, regardless
 of the value that you've provided for startTime.

 Note: The voided purchases within the response are filtered based on
 the time at which a given record is seen as voided by the API, not by the
 value of voidedTimeMillis returned in the response.

 endTime
 The time, in milliseconds since the Unix epoch, of the newest
 voided purchase of that you want to see in the response. By default,
 endTime is set to the current time.

 Note: The voided purchases within the response are
 filtered based on the time at which a given record is seen as voided by the
 API, not by the value of voidedTimeMillis returned in the
 response.

 maxResults
 The maximum number of voided purchases that appear in each response. By
 default, this value is 1000. Note that the maximum value for this parameter is
 also 1000.

 token
 A continuation token from a previous response, allowing you to view more
 results.

 type
 The type of voided purchases that appear in each response. If set to 0,
 only voided in-app purchases will be returned. If set to 1, both voided in-app
 purchases and voided subscription purchases will be returned. Default value is
 0. 

 Note: Before requesting to receive voided
 subscription purchases, you must switch to use orderId in the response which
 uniquely identifies one-time purchases and subscriptions. Otherwise, you will
 receive multiple subscription orders with the same PurchaseToken.

 includeQuantityBasedPartialRefund
 Whether to include voided purchases of quantity-based partial refunds,
 which are applicable only to multi-quantity purchases. If true,
 additional voided purchases may be returned with voidedQuantity
 that indicates the refund quantity of a quantity-based partial refund. The
 default value is false.

 Note: When the remaining total quantity of a
 purchase is refunded, the corresponding voided purchase won't have
 voidedQuantity, which serves as a signal that the purchase has
 been fully refunded. For example, if a purchase of quantity 10 is refunded 3
 times with quantities 2, 3 and 5, there will be 3 voided purchases. The first
 two voided purchases will have a voidedQuantity of 2 and 3, while
 the third voided purchase will not have a voidedQuantity.

The response is a JSON string that contains a list of voided purchases. If there
are more results than the number specified in the maxResults request parameter
, the response includes a nextPageToken value, which you can pass into a
subsequent request to view more results. The first result in the list shows the
oldest voided purchase.

```

{
 "tokenPagination": {
 "nextPageToken": "next_page_token"
 },
 "voidedPurchases": [
 {
 "kind": "androidpublisher#voidedPurchase",
 "purchaseToken": "some_purchase_token",
 "purchaseTimeMillis": "1468825200000",
 "voidedTimeMillis": "1469430000000",
 "orderId": "some_order_id",
 "voidedSource": "0",
 "voidedReason": "4"
 },
 {
 "kind": "androidpublisher#voidedPurchase",
 "purchaseToken": "some_other_purchase_token",
 "purchaseTimeMillis": "1468825100000",
 "voidedTimeMillis": "1470034800000",
 "orderId": "some_other_order_id",
 "voidedSource": "2",
 "voidedReason": "5"
 },
 ]
}

```

## Quotas

The Voided Purchases API sets the following quotas on a per-package basis:

- 6000 queries per day. (The day begins and ends at midnight Pacific Time.)

- 30 queries during any 30-second period.

### Guidelines for initial requests

During your initial API request, you may want to fetch all available data for
your app. Although unlikely, this process could exhaust your daily quota. To
obtain voided purchases data in a safer, more consistent manner, follow these
best practices:

- Use the default value for the maxResults parameter. That way, if you use
your entire query quota for a day, you can retrieve the details of 6,000,000
voided purchases.

- If a response includes a value for nextPageToken, assign this value to the
token parameter during your next request.

## Best Practices

Note: In addition to using this API, developers should integrate with
Real-time developer notifications (RTDN).
With RTDN, you receive notifications from Google whenever there is a
change in a user's entitlement within your app, including when a user
voids a purchase.
When using this API in your app, remember that there are many
reasons to void a purchase and that there is no single solution that works in
all cases. You should keep your users in mind when designing your revocation
policies and strategies. To do so, you can apply these recommended practices:

- Use this API as one of many elements in a comprehensive strategy to address
undesired behavior. Revoking access to in-app products is usually more effective
when combined with an app that has reasonable prices for in-app purchases, an
app design that discourages undesirable behavior, a strong user base whose
culture rejects such behavior, and responsive and efficient user support
channels.

- Administer your revocation policy uniformly to ensure fairness for all users.

- Consider creating a staged policy when addressing undesired behavior. For
example, start with in-app warnings for early offenses, then escalate your
responses as a user's undesired behavior continues. As a last resort, you can
prevent a user from interacting with your app at all.

- When you introduce a revocation policy, and each time you update it, use your
app's outreach channels to inform your users about the changes. Give your users
time to clearly understand these changes before they take effect in your app.

- Be transparent to your users and inform them whenever you take action, such as
revoking their access to an in-app product. Ideally, users should be able to
dispute your decisions, and such disputes should be treated fairly.

- Monitor feedback forms and community forums to understand what drives users to
behave in undesirable ways and how they carry out such behavior. Act on these
insights as a first line of defense.
