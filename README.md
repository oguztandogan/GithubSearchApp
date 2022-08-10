# Sahibinden.com - iOS Code Challenge

Github App is an application that uses the Github Search API & CoreData and is built with Swift. 
It demos some Swift concepts. The goal is to make a real world application using Swift only.

## What does this application do?

This application retrieves repositories and their details; then it shows them at the list. You can save the repositories which you like to the saved repositories list. Also you can see the repository details by clicking one of the repository.

This application includes three pages:

### Repositories List Page

This page includes list of repositories which are retrieved from Github Search API. You can save the repositories you like to the saved repositories list by clicking heart shaped button.

### Saved Repositories Page

This page includes list of saved repositories which are saved by the user. You can delete the repositories from the saved repositories list by clicking heart shaped button.

### Repository Details Page

This page includes repository details retrieved from Github Search API. It includes some details about the repository.

# Design Patterns

## MVVM

This app is written with MVVM.

Model: App data that the app operates on.
View: The user interface’s visual elements. In iOS, the view controller is inseparable from the concept of the view.
ViewModel: Updates the model from view inputs and updates views from model outputs.

## Networking Layer

This app includes simple networking layer and scene based requests. This networking layer includes two function:

###Request

Makes a URL request to desired URL.

### Image Cacher and Downloader

Downloads an image; if it's already downloaded and cached; then it won't download the image and uses it from the cache.

## CoreData Layer

This app includes simple CoreData manager. CRUD operations can be done here.

## Platforms

Currently Github App runs on iPhone.
