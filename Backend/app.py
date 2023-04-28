from db import db, Book, Music, User
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

@app.route("/api/albums/")
def get_albums():
    """
    get all albums
    """
    albums = [t.serialize() for t in Music.query.all()]
    return json.dumps({"albums": albums}), 200
    
@app.route("/api/albums/<int:album_id>/")
def get_album(album_id):
    """
    get an album by id
    """
    album = Music.query.filter_by(id=album_id).first()
    if album is None:
        return json.dumps({"error":"Album not found!"}), 404
    return json.dumps(album.serialize()), 200
    
@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    get a user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"User not found!"}), 404
    return json.dumps(user.serialize()), 200

@app.route("/api/books/", methods=["POST"])
def create_book():
    """
    create a book
    """
    body = json.loads(request.data)
    if body.get("bookname") is None:
        return json.dumps({"error":"Error message: no bookname"}), 400
    if body.get("author") is None:
        return json.dumps({"error":"Error message: no author"}), 400
    if body.get("description") is None:
        return json.dumps({"error":"Error message: no description"}), 400
    if body.get("genre") is None:
        return json.dumps({"error":"Error message: no genre"}), 400
    if body.get("book_url") is None:
        return json.dumps({"error":"Error message: no book_url"}), 400
    if body.get("book_cover") is None:
        return json.dumps({"error":"Error message: no book_cover"}), 400
    new_book = Book(
        bookname = body.get("bookname"),
        author = body.get("author"),
        description = body.get("description"),
        genre = body.get("genre"),
        book_url = body.get("book_url"),
        book_cover = body.get("book_cover")
    )
    db.session.add(new_book)
    db.session.commit()
    return json.dumps(new_book.serialize()), 201

@app.route("/api/albums/", methods=["POST"])
def create_album():
    """
    create an album
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
    new_music = Music(
        musicname = body.get("musicname"),
        artist = body.get("artist"),
        music_url = body.get("music_url"),
        music_cover = body.get("music_cover")
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
    new_user = User(
        username = body.get("username"),
        password = body.get("password"),
        email = body.get("email"),
        pfp = body.get("pfp")
    )
    db.session.add(new_user)
    db.session.commit()
    return json.dumps(new_user.serialize()), 201

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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
