from db import db, Book, Music, Usser
from flask import Flask, request
import json
import os

app = Flask(__name__)
db_filename = "cms.db"

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
def get_course(book_id):
    """
    get a book by id
    """
    book = Book.query.filter_by(id=book_id).first()
    if book is None:
        return json.dumps({"error":"Book not found!"}), 404
    return json.dumps(book.serialize()), 200
    
@app.route("/api/users/<int:user_id>/")
def get_course(user_id):
    """
    get a user by id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return json.dumps({"error":"User not found!"}), 404
    return json.dumps(user.serialize()), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
