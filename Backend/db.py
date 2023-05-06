from flask_sqlalchemy import SQLAlchemy
import base64
import boto3
import datetime
import io
from io import BytesIO
from mimetypes import guess_extension, guess_type
import os
from PIL import Image
import random
import re
import string

db = SQLAlchemy()

EXTENSIONS = ["png", "gif", "jpg", "jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-1.amazonaws.com"

class Asset(db.Model):
    """
    Asset model
    """
    __tablename__ = "assets"
    id = db.Column(db.Integer, primary_key = True, autoincrement=True)
    base_url = db.Column(db.String, nullable=True)
    salt = db.Column(db.String, nullable=False)
    extension = db.Column(db.String, nullable=False)
    width = db.Column(db.Integer, nullable=False)
    height = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, nullable=False)

    def __init__(self, **kwargs):
        """
        Initialize an Asset object
        """
        self.create(kwargs.get("image_data"))

    def serialize(self):
        """
        Serialize an Asset object
        """
        return{
            "url": f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)
        }

    def create(self, image_data):
        """
        Given an image in base64 form, does the following:
            1. Reject the image if it's not supported filetype
            2. Generate a random string for the image filename
            3. Decode the image and attempt to upload it to AWS
        """

        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]

            #only accept supported file extension
            if ext not in EXTENSIONS:
                raise Exception(f"Extension {ext} not supported")
            
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range(16)
            )

            #remove base64 header
            img_str = re.sub("^data:image/.+;base64,", "", image_data)
            img_data = base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))

            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width = img.width
            self.height = img.height
            self.created_at = datetime.datetime.now()

            img_filename = f"{self.salt}.{self.extension}"
            self.upload(img, img_filename)
        except Exception as e:
            print(f"Error while creating image: {e}")

    def upload(self, img, img_filename):
        """
        Attempt to upload the image into S3 bucket
        """
        try:
            #save image temporarily on the server
            img_temploc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temploc)

            #upload the image to S3
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temploc, S3_BUCKET_NAME, img_filename)

            #make s3 image url public
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME, img_filename)
            object_acl.put(ACL="public-read")

            #remove image from server
            os.remove(img_temploc)
        except Exception as e:
            print(f"Error while uploading image: {e}")

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
        "id": self.id,
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
            "id":self.id,
            "timestamp" : self.timestamp,
            "question" : self.question,
            "answer" : self.answer,
            "user_id" : self.user_id
        }
