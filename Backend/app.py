from db import db, Book, Music, User, Message
from flask import Flask, request
import json
import os

app = Flask(__name__)
db_filename = "MyApp.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

@app.route("/")
def welcome():
    return "Test, this server is working!"
    
@app.route("/api/books/")
def get_books():
    """
    get all books
    """
    books = [t.serialize() for t in Book.query.all()]
    return json.dumps({"books": books}), 200
    
@app.route("/api/books/<int:book_id>/")
def get_book(book_id):
    """
    get a book by id
    """
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Book not found!"}), 404
    return json.dumps(book.serialize()), 200

@app.route("/api/music/")
def get_all_music():
    """
    get all musics
    """
    music = [t.serialize() for t in Music.query.all()]
    return json.dumps({"music": music}), 200
    
@app.route("/api/music/<int:music_id>/")
def get_music(music_id):
    """
    get an music by id
    """
    music = Music.query.filter_by(id=music_id).first()
    if music is None:
        return json.dumps({"error":"Music not found!"}), 404
    return json.dumps(music.serialize()), 200

@app.route("/api/users/")
def get_users():
    """
    get all users
    """
    users = [u.serialize() for u in User.query.all()]
    return json.dumps({"users":users}), 200

@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    get a user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"User not found!"}), 404
    return json.dumps(user.serialize()), 200

@app.route("/api/messages/")
def get_messages():
    """
    get all messages
    """
    messages = [m.serialize() for m in Message.query.all()]
    return json.dumps({"messages": messages}), 200

@app.route("/api/messages/<int:message_id>/")
def get_message(message_id):
    """
    get a message by id
    """
    message = Message.query.filter_by(id=message_id).first()
    if message is None:
        return json.dumps({"error":"Message not found!"})
    return json.dumps(message.serialize()),200

@app.route("/api/books/", methods=["POST"])
def create_book():
    """
    create a book
    """
    body = json.loads(request.data)
    bn = body.get("bookname")
    if bn is None:
        return json.dumps({"error":"Error message: no bookname"}), 400
    if body.get("author") is None:
        return json.dumps({"error":"Error message: no author"}), 400
    if body.get("description") is None:
        return json.dumps({"error":"Error message: no description"}), 400
    if body.get("story") is None:
        return json.dumps({"error":"Error message: no story"})
    if body.get("genre") is None:
        return json.dumps({"error":"Error message: no genre"}), 400
    if body.get("book_url") is None:
        return json.dumps({"error":"Error message: no book_url"}), 400
    if body.get("book_cover") is None:
        return json.dumps({"error":"Error message: no book_cover"}), 400
    new_book = Book(
        bookname = bn,
        author = body.get("author"),
        description = body.get("description"),
        story = body.get("story"),
        genre = body.get("genre"),
        book_url = body.get("book_url"),
        book_cover = body.get("book_cover")
    )
    db.session.add(new_book)
    db.session.commit()
    return json.dumps(new_book.serialize()), 201

@app.route("/api/music/", methods=["POST"])
def create_music():
    """
    create an music
    """
    body = json.loads(request.data)
    if body.get("musicname") is None:
        return json.dumps({"error":"Error message: no musicname"}), 400
    if body.get("artist") is None:
        return json.dumps({"error":"Error message: no artist"}), 400
    if body.get("music_url") is None:
        return json.dumps({"error":"Error message: no music_url"}), 400
    if body.get("music_cover") is None:
        return json.dumps({"error":"Error message: no music_cover"}), 400
    if body.get("length") is None:
        return json.dumps({"error":"Error message: no length"})
    new_music = Music(
        musicname = body.get("musicname"),
        artist = body.get("artist"),
        music_url = body.get("music_url"),
        music_cover = body.get("music_cover"),
        length = body.get("length")
    )
    db.session.add(new_music)
    db.session.commit()
    return json.dumps(new_music.serialize()), 201

@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    create a user
    """
    body = json.loads(request.data)
    if body.get("username") is None:
        return json.dumps({"error":"Error message: no username"}), 400
    if body.get("password") is None:
        return json.dumps({"error":"Error message: no password"}), 400
    if body.get("email") is None:
        return json.dumps({"error":"Error message: no email"}), 400
    if body.get("pfp") is None:
        return json.dumps({"error":"Error message: no pfp"}), 400
    if body.get("social_media") is None:
        return json.dumps({"error":"Error message: no social media"}), 400
    if body.get("dob") is None:
        return json.dumps({"error":"Error message: no date of birth"}), 400
    
    new_user = User(
        username = body.get("username"),
        password = body.get("password"),
        email = body.get("email"),
        pfp = body.get("pfp"),
        social_media = body.get("social_media"),
        dob = body.get("dob")
    )
    db.session.add(new_user)
    db.session.commit()
    return json.dumps(new_user.serialize()), 201

@app.route("/api/messages/<int:user_id>/",methods = ["POST"])
def create_message(user_id):
    """
    create a message
    """
    body = json.loads(request.data)
    ts = body.get("timestamp")
    q = body.get("question")
    a = body.get("answer")

    if ts is None or q is None or a is None:
        return json.dumps({"error":"Error message: missing information"})
    new_message = Message(
        timestamp = ts,
        question = q,
        answer = a,
        user_id = user_id
    )
    db.session.add(new_message)
    db.session.commit()
    return json.dumps(new_message.serialize()), 201

@app.route("/api/books/<int:book_id>/",methods = ["DELETE"])
def delete_book(book_id):
    """
    Delete a book by id
    """
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Error message: book not found"}), 404
    db.session.delete(book)
    db.session.commit()
    return json.dumps(book.serialize()), 200

app.route("/api/music/<int:music_id>/",methods = ["DELETE"])
def delete_music(music_id):
    """
    Delete a music by id
    """
    music = Music.query.filter_by(id=music_id).first()
    if music is None:
        return json.dumps({"error":"Error message: music not found"}), 404
    db.session.delete(music)
    db.session.commit()
    return json.dumps(music.serialize()), 200

app.route("/api/users/<int:user_id>/",methods = ["DELETE"])
def delete_user(user_id):
    """
    Delete a user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"Error message: user not found"}), 404
    db.session.delete(user)
    db.session.commit()
    return json.dumps(user.serialize()), 200

app.route("/api/messages/<int:message_id>/",methods = ["DELETE"])
def delete_message(message_id):
    """
    Delete a message by id
    """
    message = Message.query.filter_by(id=message_id).first()
    if message is None:
        return json.dumps({"error":"Error message: message not found"}), 404
    db.session.delete(message)
    db.session.commit()
    return json.dumps(message.serialize()), 200

@app.route("/api/save/<int:user_id>/<int:book_id>/", methods = ["POST"])
def save_book(book_id, user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"Error message: User not found"}),404
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Error message: book not found"}), 404
    user.books_saved.append(book)
    db.session.commit()
    return json.dumps(user.serialize()),201

@app.route("/api/continue/<int:user_id>/<int:book_id>/", methods = ["POST"])
def continue_book(book_id, user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"Error message: User not found"}),404
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Error message: book not found"}), 404
    user.continue_books.append(book)
    db.session.commit()
    return json.dumps(user.serialize()),201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
