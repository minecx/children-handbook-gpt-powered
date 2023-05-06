from db import db, Asset, Book, Music, User, Message
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
    bookname = body.get("bookname")
    author = body.get("author")
    description = body.get("description")
    story = body.get("story")
    genre = body.get("genre")
    bookurl = body.get("book_url")
    bookcover = body.get("book_cover")

    if (bookname or author or description or story or genre or bookurl or bookcover) is None:
        return json.dumps({"error":"Error message: missing information"}), 400
    new_book = Book(
        bookname = bookname,
        author = author,
        description = description,
        story = story,
        genre = genre,
        book_url = bookurl,
        book_cover = bookcover
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
    musicname = body.get("musicname")
    artist = body.get("artist")
    musicurl = body.get("music_url")
    musiccover = body.get("music_cover")
    length = body.get("length")

    if (musicname or artist or musicurl or musiccover or length) is None:
        return json.dumps({"error":"Error message: missing information"}), 400
    new_music = Music(
        musicname = musicname,
        artist = artist,
        music_url = musicurl,
        music_cover = musiccover,
        length = length
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
    username = body.get("username")
    password = body.get("password")
    email = body.get("email")
    pfp = body.get("pfp")
    social_media = body.get("social_media")
    dob = body.get("dob")
    if (username or password or email or pfp or social_media or dob) is None:
        return json.dumps({"error":"Error message: missing information"}), 400
    
    new_user = User(
        username = username,
        password = password,
        email =email,
        pfp = pfp,
        social_media = social_media,
        dob = dob
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
    """
    Save a book for a user, according to their respective ID
    """
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
    """
    Mark a book as continue reading for a user, according to their respective ID
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"Error message: User not found"}),404
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Error message: book not found"}), 404
    user.continue_books.append(book)
    db.session.commit()
    return json.dumps(user.serialize()),201

@app.route("/upload/", methods=["POST"])
def upload():
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image
    """
    body = json.loads(request.data)
    image_data = body.get("image_data")
    if image_data is None:
        return json.dumps({"error":"No Base64 URL"}),400
    
    #create new Asset object
    asset = Asset(image_data = image_data)
    db.session.add(asset)
    db.session.commit()
    return json.dumps(asset.serialize()),201

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
