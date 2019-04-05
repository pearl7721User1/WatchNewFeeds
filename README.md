# WatchNewFeeds

## Why did I start this project?
Back in 2018, I watched WWDC 2018 Core Data Best Practices. 
They showed a slide featuring a simple photo sharing app. There was one datasource that they kept remotely that all the client apps had access to it for inserting/downloading/deleting. When the datasource was pulled, the local Core Data was synchronized with the remote one, and the user could see the Core Data status in a table view.
Only, the synchronizing wasn’t working properly since more than one context were reading/writing the Core Data. It ended up with incomplete table view updating, leaving spotty empty cells.

Not having experienced any of those multi-context based Core Data app, I started this project to study the basics and demystify concurrency issues of Core Data.
This is a simple rss feed managing app. You can install a couple of rss feeds in Core Data. Those installed feeds are pulled regularly to notice you the updates of their own contents.

One thing noticeable about this app is that most proportion of what is implemented is working under the hood. Feed pulling, figuring out the right insert/update/delete-required-contents, having all the updates persist in the Core Data, and so on. So, it’s paramount to build in a way that the app is completely testable to ensure integrity. (Actually, I hope to speak for all the other apps that I’m going to create.)

## Problems that I encountered along the way:
1. What makes it stand out for not using CoreData FetchController but suit the fetching needs on my own?
2. What is involved if you want any changes in Core Data resulting in inserting/deleting/reloading UITableview cell?
3. How to take advantage of using Protocol to mock the behavior of the instance?
4. How to take advantage of Operation class in a way that I concurrently do multiple works and have it execute a specific code when all are completed?
5. How to test Core Data operations in a way that it doesn’t actually insert any data?

## What I've been studying much further:
1. Is it possible to design the Comparator in a way that I can use it for more general instance compare needs?
2. ShowListViewController represents the core data status. Can I work on it further in a way that I can even mock the core data status to increase testability?
