from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

saved_books = db.Table(
    "savedbooks",
    db.Column("book_id", db.Integer, db.ForeignKey("book.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
)

continue_reading = db.Table(
    "continue",
    db.Column("book_id",db.Integer,db.ForeignKey("book.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
)

class Book(db.Model):
    """
    AudioBook Model
    """
    __tablename__ = "book"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    bookname = db.Column(db.String, nullable = False)
    author = db.Column(db.String, nullable = False)
    description = db.Column(db.String, nullable = False)
    genre = db.Column(db.String, nullable = False)
    story = db.Column(db.String, nullable = False)
    book_url = db.Column(db.String, nullable = False)
    book_cover = db.Column(db.String, nullable = False)
    saved_by_users = db.relationship("User",secondary=saved_books,back_populates="books_saved")
    continue_by_users= db.relationship("User",secondary = continue_reading, back_populates="continue_books")

    def __init__ (self, **kwargs):
        """
        Initializes a Book object
        """
        self.id = kwargs.get("id")
        self.bookname = kwargs.get("bookname")
        self.author = kwargs.get("author")
        self.description = kwargs.get("description")
        self.story = kwargs.get("story","")
        self.genre = kwargs.get("genre")
        self.book_url = kwargs.get("book_url")
        self.book_cover = kwargs.get("book_cover")

    def serialize(self):
        """
        Serializes a Book object
        """
        return{
            "id" : self.id,
            "bookname" : self.bookname,
            "author" : self.author,
            "description" : self.description,
            "story" : self.story,
            "genre" : self.genre,
            "book_url" : self.book_url,
            "book_cover" : self.book_cover
        }


class Music(db.Model):
    """
    Music Model
    """
    __tablename__ = "music"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    musicname = db.Column(db.String, nullable = False)
    artist = db.Column(db.String, nullable = False)
    music_url = db.Column(db.String, nullable = False)
    music_cover = db.Column(db.String, nullable = False)
    length = db.Column(db.Integer, nullable = False)

    def __init__(self, **kwargs):
        """
        Initializes a Music object
        """
        self.musicname = kwargs.get("musicname")
        self.artist = kwargs.get("artist")
        self.music_url = kwargs.get("music_url")
        self.music_cover = kwargs.get("music_cover")
        self.length = kwargs.get("length")

    def serialize(self):
        """
        Serializes a Music object
        """
        return {
            "id" : self.id,
            "artist" : self.artist,
            "music_url" : self.music_url,
            "music_cover" : self.music_cover,
            "length" : self.length
        }
class User(db.Model):
    """
    User Model
    """
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key = True, autoincrement= True)
    username = db.Column(db.String, nullable = False)
    password = db.Column(db.String, nullable = False)
    email = db.Column(db.String, nullable = False)
    pfp = db.Column(db.String, nullable = False)
    social_media= db.Column(db.String, nullable = False)
    dob= db.Column(db.Integer, nullable = False) #Datetime
    books_saved = db.relationship("Book",secondary = saved_books, back_populates = "saved_by_users")
    continue_books = db.relationship("Book",secondary = continue_reading, back_populates = "continue_by_users")
    messages = db.relationship("Message", cascade = "delete")

    def __init__(self, **kwargs):
      """
      Initializes a User object
      """
      self.username = kwargs.get("username","")
      self.password = kwargs.get("password","")
      self.email = kwargs.get("email","")
      self.pfp = kwargs.get("pfp","")
      self.social_media = kwargs.get("social_media")
      self.dob = kwargs.get("dob")
 
    def serialize(self):
      """
      Serializes a User object
      """
      return {
        "username" : self.username,
        "password" : self.password,
        "email" : self.email,
        "pfp" : self.pfp,
        "social_media" : self.social_media,
        "dob" : self.dob,
        "books_saved" : [b.serialize() for b in self.books_saved],
        "continue_books" : [b.serialize() for b in self.continue_books],
        "messages":[m.serialize() for m in self.messages]
        }
    
class Message(db.Model):
    """
    Message Model
    """
    __tablename__ = "message"
    id = db.Column(db.Integer, primary_key = True, autoincrement= True)
    timestamp = db.Column(db.String, nullable = False) 
    question = db.Column(db.String, nullable = False)
    answer = db.Column(db.String, nullable = False)
    user_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)

    def __init__(self, **kwargs):
        """
        Initializes a Message object
        """
        self.timestamp = kwargs.get("timestamp")
        self.question = kwargs.get("question")
        self.answer = kwargs.get("answer")
        self.user_id = kwargs.get("user_id")

    def serialize(self):
        """
        Serializes a Message object
        """
        return {
            "timestamp" : self.timestamp,
            "question" : self.question,
            "answer" : self.answer,
            "user_id" : self.user_id
        }

