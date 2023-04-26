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
    db.Column("user_id", db.Integer, db.ForeignKey("user.id")),
    db.Column("progress",db.Integer) #Not sure if this is the way to put a saved progress.
)



class Book(db.Model):
    """
    AudioBook Model
    """
    __tablename__ = "book"
    id = db.Column(db.Integer, primary_key = True, autoincrement = True)
    bookname = db.Column(db.String, nullable = False)
    author = db.Column(db.String, nullable = False)
    description = db.Column(db.Text, nullable = False)
    genre = db.Column(db.String, nullable = False)
    book_url = db.Column(db.Text, nullable = False)
    book_cover = db.Column(db.Text, nullable = False)
    saved_by_users = db.relationship("User",secondary=saved_books,back_populates="books_saved")
    continue_by_users= db.relationship("User",secondary = continue_reading, back_populates="continue_books")

    def __init__ (self, **kwargs):
        """
        Initializes a Book object
        """
        self.id = kwargs.get("id")
        self.bookname = kwargs.get("name")
        self.author = kwargs.get("author")
        self.description = kwargs.get("description")
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
    music_url = db.Column(db.Text, nullable = False)
    music_cover = db.Column(db.Text, nullable = False)

    def __init__(self, **kwargs):
        """
        Initializes a Music object
        """
        self.musicname = kwargs.get("musicname")
        self.artist = kwargs.get("artist")
        self.music_url = kwargs.get("music_url")
        self.music_cover = kwargs.get("music_cover")

    def serialize(self):
        """
        Serializes a Music object
        """
        return {
            "id" : self.id,
            "artist" : self.artist,
            "music_url" : self.music_url,
            "music_cover" : self.music_cover
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
    pfp = db.Column(db.Text, nullable = False)
    books_saved = db.relationship("Book",secondary = saved_books, back_populates = "saved_by_users")
    continue_books = db.relationship("Book",secondary = continue_reading, back_populates = "continue_by_users")
    
    def __init__(self, **kwargs):
      """
      Initializes a User object
      """
      self.username = kwargs.get("username","")
      self.password = kwargs.get("password","")
      self.email = kwargs.get("email","")
      self.pfp = kwargs.get("pfp","")
 
    def serialize(self):
      """
      Serializes a User object
      """
      return {
        "username" : self.username,
        "password" : self.password,
        "email" : self.email,
        "pfp" : self.pfp,
        "books_saved" : [b.serialize() for b in self.books_saved],
        "continue_books" : [b.serialize() for b in self.continue_books]
     }