# children-handbook-gpt-powered

## iOS App

Our app is for parents to showcase fairytales to their children. We hope to provide a platform for parents to find books for their kids, bookmark them so they can come back for them later, and read them to their children. We also hope to provide a platform for parents to create their own stories and share them with other parents.

We integrated Google OAuth into our app so that parents can log in with their Google accounts and save their favorite stories to their accounts, and we integrated ChatGPT into our app so that parents ask for story recommendations based on their children's interests as well as search for questions that they are not sure on the fly.

To do so, we built the following pages:

- TODO

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
