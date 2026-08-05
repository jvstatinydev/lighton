# Quotas  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/quotas

---

## Page Summary

 outlined_flag

- 
 Google Play Developer APIs are organized into quota buckets with independent per-minute limits.

- 
 The default quota limit for each bucket is 3000 queries per minute.

- 
 Different APIs are grouped into specific quota buckets such as Subscriptions, One-time Purchases, Orders, and Publishing APIs.

- 
 You can monitor your current quota usage in the Google Cloud Console and request additional quota if needed.

The Google Play Developer APIs are organized into categories called buckets, where
each bucket has its own per-minute quota limit. The default quota is 3000
queries per minute for each bucket, and each bucket's quota is independent
of the others. It means that the quota for
the Subscriptions bucket is independent of the quota for the
One-time purchases bucket. The following table lists the various quota
buckets and the corresponding APIs in each bucket:

 Quota bucket name | 
 APIs in the bucket | 

 Subscriptions (excludes APIs in the Subscription Updates bucket) | 

- SubscriptionPurchases
 
- SubscriptionPurchasesV2
 
 | 

 Subscription Updates | 

- SubscriptionPurchases.Cancel

- SubscriptionPurchases.Defer

- SubscriptionPurchases.Refund

- SubscriptionPurchases.Revoke

- SubscriptionPurchasesV2.Revoke

 | 

 One-time Purchases
 | 

- 
 ProductPurchase
 
- ProductPurchaseV2
 
 | 

 Orders
 | 

- Orders
 
- Voided Purchases
 
 | 

 ExternalTransactions
 | 
 ExternalTransactions
 | 

 Publishing, Monetization, and Reply to Reviews APIs
 | 

- All Publishing APIs
 
- Monetization APIs
 
- Permissions APIs
 
- Reply to Reviews APIs
 
 | 

For information regarding Google Play quotas, refer to the
Google Play Billing API: Per-Minute quota blog post.

You can view your existing quota usage in the Quotas
section of the Google Cloud Console. If you need additional quotas for
your APIs, you can
submit a quota request for the Google Play Developer API.
