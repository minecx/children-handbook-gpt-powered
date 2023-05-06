# children-handbook-gpt-powered

## iOS App

Our app is for parents to showcase fairytales to their children. We hope to provide a platform for parents to find books for their kids, bookmark them so they can come back for them later, and read them to their children. We also hope to provide a platform for parents to create their own stories and share them with other parents.

We integrated Google OAuth into our app so that parents can log in with their Google accounts and save their favorite stories to their accounts, and we integrated ChatGPT into our app so that parents ask for story recommendations based on their children's interests as well as search for questions that they are not sure on the fly.

To do so, we built the following pages.

### Login / Sign Up Page

This page allows users to log in with their Google accounts. We used Google OAuth to authenticate users and save their favorite stories to their accounts.

- *Unfinished*: Apple Login and FaceBook Login. Both requires a paid developer account to test which we do not have.

### Home Page

We called it Discover View in our app. This page allows users to search for stories based on their children's interests. If the users are logged in and have a reading history, we will show a "Continue Reading" section for them (only used mock data for now). They will also be able to check out music for their kids.

During the development process, we consulted the following resources to integrate ChatGPT and Google OAuth into our iOS app:

- [OpenAI tutorial](https://youtu.be/XF8IbrNh7E0)
- [Google OAuth tutorial](https://youtu.be/M5LiqOBDeGg)

## Backend
