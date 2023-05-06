# children-handbook-gpt-powered

## iOS App

Our app is for parents to showcase fairytales to their children. We hope to provide a platform for parents to find books for their kids, bookmark them so they can come back for them later, and read them to their children. We also hope to provide a platform for parents to create their own stories and share them with other parents.

We integrated Google OAuth into our app so that parents can log in with their Google accounts and save their favorite stories to their accounts, and we integrated ChatGPT into our app so that parents ask for story recommendations based on their children's interests as well as search for questions that they are not sure on the fly.

To do so, we built the following pages.

### Login / Sign Up Page

This page allows users to log in with their Google accounts. We used Google OAuth to authenticate users and save their favorite stories to their accounts.

- *Unfinished*: Apple Login and FaceBook Login. Both requires a paid developer account to test which we do not have.

### Home Page

We called it `DiscoverView.swift` in our app. This page allows users to search for stories based on their children's interests. If the users are logged in and have a reading history, we will show a "Continue Reading" section for them (only used mock data for now). They will also be able to check out music for their kids.

*Unfinished*: In this section, the user should also be able to bookmark books and musics, so they can come back to them later in the bookmark page below.

### Bookmark Page

*Unfinished*.

What should happen here is that users can see their bookmarked stories and read them to their children, as mentioned above.

### Chat Page

We called it `ChatgptView.swift` in our app. This page allows users to chat with ChatGPT. We used OpenAI's ChatGPT to generate responses to users' questions. It features the original ChatGPT experience - ask the AI anytime, and it will provide a response. You can also create new chats and delete chats to categorize your conversations.

### Profile Page

This page allows users to log out of their accounts. They can also change their preferred name and avatar here for social purposes.

*Unfinished*: meet and have a chat with other parents.

### References

During the development process, we consulted the following resources to integrate ChatGPT and Google OAuth into our iOS app:

- [OpenAI tutorial](https://youtu.be/XF8IbrNh7E0)
- [Google OAuth tutorial](https://youtu.be/M5LiqOBDeGg)

## Backend

- Routes
  - GET /api/books/
  - GET /api/books/<int:book_id>/
  - GET /api/music/
  - GET /api/music/<int:music_id>/
  - GET /api/users/
  - GET /api/users/<int:user_id>/
  - GET /api/messages/
  - GET /api/messages/<int:message_id>/
  - POST /api/books/
  - POST /api/music/
  - POST /api/users/
  - POST /api/messages/<int:user_id>/
  - DELETE /api/books/<int:book_id>/
  - DELETE /api/music/<int:music_id>/
  - DELETE /api/users/<int:user_id>/
  - DELETE /api/messages/<int:message_id>/
  - POST /api/save/<int:user_id>/<int:book_id>/ : Save a book for a user, according to their respective ID
  - POST /api/continue/<int:user_id>/<int:book_id>/ : Mark a book as continue reading for a user, according to their respective ID
  - POST /upload/ : Endpoint for uploading an image to AWS given its base64 form, then storing/returning the URL of that image
- Database Models
  - Book
  - Music
