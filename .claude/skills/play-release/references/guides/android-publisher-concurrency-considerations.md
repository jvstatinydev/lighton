# Concurrency considerations  |  Google Play Developer API  |  Google for Developers

Source: https://developers.google.com/android-publisher/concurrency-considerations

---

## Page Summary

 outlined_flag

- 
 Avoid using the Developer Console and Publishing API concurrently to update applications due to potential unintended side effects.

- 
 Committing an API edit sends all changes for review, including those ready to send from the Developer Console.

- 
 Changes made in the Developer Console invalidate active API edits.

- 
 Creating a new API edit invalidates any other active edits by the same user for the same application.

- 
 Multiple users can have active API edits for the same application until one is committed, which invalidates the others.

You should not use the Developer Console and the Publishing API concurrently
to update applications because of the potential for unintended side effects.

The following is a list of some example scenarios that illustrate the
expected behavior if you decide to use the Developer Console and the
Publishing API concurrently to update your application, or use multiple
concurrent Publishing API clients.

## Committing an edit while changes are ready to send for review in the Developer Console

Committing an edit will send all changes for review, including changes ready
to send for review in the Developer Console.
For example, assume you have changes ready to send for review in the Developer
Console. If you create, edit, and then commit an edit using the API, the commit
action sends all changes to your application for review, including those made
through the Developer Console.

## Making changes in the Developer Console invalidates active edits

If you have an active edit made using the API, and you then update your
application using the Developer Console, the edit is invalidated. You need to
create a new edit to update your application through the API.

## Creating a new edit invalidates any active edits for the same application by the same user

Creating a new edit for an application invalidates any active edits for that
application created by the same user. Each API user can have only one active
edit per application.

## Multiple users can have active edits for the same application

If two users create edits for the same application, both edits are
active for both users until one is committed. The first committed edit
invalidates all other edits for that application.
