# API Usage Instructions  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/api_usage

---

Because the new API gives you access to sensitive account settings, it is
important to keep your app secure.

- Do not publish alpha or beta updates more frequently than once a day.
(Production apps should be updated even less frequently than that.)
Every update costs your users time and possibly money. If you update too
frequently, users will start ignoring updates, or even uninstall the product.

Of course, if there's a major problem with your app, go ahead and fix it.

- Do not allow third parties to use the APIs to publish to your account on your
behalf. Do not use the APIs to offer a developer service or tool which
creates, uploads, publishes, distributes or updates apps to the Google Play
Store. Doing this is a violation of the Google Play Developer API Terms of
Service. Such actions may result in your account being suspended, and your
apps removed from the Google Play Store. Everything done on your account is
your responsibility, and allowing a third party to use your account puts all
of your users at risk.

- If third parties are helping you to develop your app or design your store
listing, that's fine. However, do not share your developer account
username or password with those people. Instead, use the Google Play
Developer Console to add new user
accounts
for those people, and carefully limit the permissions for the accounts.

- We recommend not giving third parties access to any service accounts you
may create. We especially recommend not giving access to any private keys
for your service account. Doing so provides anonymous access to your account
that can be shared with anyone.
