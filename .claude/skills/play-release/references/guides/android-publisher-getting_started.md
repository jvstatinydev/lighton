# Getting Started  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/getting_started

---

## Page Summary

 outlined_flag

- 
 Accessing the Google Play Developer API requires setting up a Google Cloud Project, enabling the API, and configuring either a service account or OAuth client for access.

- 
 A service account is the recommended method for secure server-to-server API access and is set up in both the Google Cloud Console and Google Play Console.

- 
 OAuth clients allow API access on behalf of individual users and require configuring branding information before creation.

- 
 Your Google Play Console Developer ID, needed for some APIs, can be found in the URL of most Google Play Console pages.

- 
 Specialized APIs within the Google Play Developer API allow for specific actions like replying to reviews or managing voided purchases.

Note: You no longer need to link your developer account to a
Google Cloud Project in order to access the Google Play Developer API.
Before you can start making API calls, you need to set up API access to your
Google Play Developer Account. This involves changes in both the
Google Play Console and Google Cloud Console. The following instructions
explain the steps needed to start using the Google Play Developer API.

- Create a Google Cloud Project.

- Enable the Google Play Developer API for your Google Cloud Project.

- Set up a service account with appropriate Google Play Console permissions to access the Google Play Developer API.

## Create a Google Cloud Project

You can skip this step if you already have a Google Cloud Project
you want to use.

Create a project in the
Google Cloud Console.

For further information on Google Cloud Projects,
refer to Creating and managing projects.

## Enable the API

Once you have set up the Google Cloud Project, you need to enable
the Google Play Developer API for this project.

To enable Google Play Developer API:

- Go to the Google Play Developer API page in Google Cloud Console.

- Click Enable.

## Configure OAuth and Service Accounts

You need to configure access to the Google Play Developer API with an OAuth client or
a service account. In most cases, you should use a service account
to access the API.

Service accounts must be used in a secure environment, such as your server.
The service account credentials need to be securely managed so they are not
revealed to anyone that is not authorized to use the API.

The OAuth Client ID should be used if you need to access the API on behalf
of an individual user. For example, if your website needs to access the
Google Play Developer API from the web client on behalf of the user, you can use the
Client ID. The user will be authenticated with their Google account instead
of the service account. This allows you to make API calls on behalf of a user
without compromising service account credentials.

- Service account: A secure software service will access the API (most common)

- OAuth clients: A user will access the API

### Use a service account

You can create a service account from
the Google Play Console.

- In the Google Cloud Console go to Service Accounts.

- Click Create service account and follow the steps.

- Go to the Users & Permissions page on the Google Play Console.

- Click Invite new users.

- Put an email address for your service account in the email address
field and grant the necessary rights to perform actions.

To use the Google Play Billing APIs, you must grant the following permissions:

- View financial data, orders, and cancellation survey responses

- Manage orders and subscriptions

- Click Invite user.

At this point, you should be able to access the Google Play Developer API through the
service account. For more information, see Using OAuth 2.0 for Server to Server
Applications.

### Use OAuth clients

You can allow users to perform actions using the API under their own credentials
using an OAuth client.
A user’s actions are limited to those permitted via the
Users and permissions
page on the Google Play Console.

Before creating OAuth clients, you need to configure branding information for
your product. For more information, see Setting up your OAuth consent screen.

- In the Google Cloud Console, go to OAuth consent screen page.

- Follow the steps to create OAuth consent screen.

To create an OAuth client:

- In the Google Cloud Console, go to Credentials.

- Click Create Credentials > OAuth client ID.

- Choose your application type and follow the instructions.

## Additional information

Use the following tips and tricks to help you get started with API usage on
Google Play.

### Obtain your Developer ID

Some APIs require you to provide a Google Play Console Developer ID. This
is a long number that was assigned when your Google Play Developer Account
was created. Your Developer ID can be found in the URL of almost any page on the
Google Play Console, such as the
API access page.

For example, consider the Google Play Console URL:

```
https://play.google.com/console/developers/1234567890123456789/api-access

```

In the URL above, the Developer ID would be 1234567890123456789.

Note: If an app is transferred from one Google Play Developer Account
to another, the Developer ID associated with that app will change. This means
that after the transfer completes, you must use the Developer ID for the new
Google Play Developer Account account in API calls for that app.

### Specialized APIs

The Google Play Developer API contains several specialized APIs that allow
you to perform specific types of analysis on your app:

Reply to Reviews API
Allows you to view user feedback for your app and reply to this feedback.
Voided Purchases API
Allows you to revoke access to in-app products associated with purchases that
a user has voided.

### Client libraries

We have provided client libraries you can use to programmatically
access the REST APIs. For more information, see Client Libraries and Code
Samples.
