from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class UserManager(BaseUserManager):

  def create_user(self, email, password=None, **extra_fields):
    # Creates and saves a new user
    if not email:
      raise ValueError('Users must have an email address')
    user = self.model(email=self.normalize_email(email), **extra_fields)
    # Adds the user's password to the object
    user.set_password(password)
    # Saves the object to the database
    user.save(using=self._db)

    return user

  def create_superuser(self, email, password):
    # Extra fields aren't required because we'll be using the command line for this
    user = self.create_user(email, password)
    user.is_staff = True
    user.is_superuser = True
    user.save(using=self._db)
    return user


class User(AbstractBaseUser, PermissionsMixin):
  # Custom user model which supports using email instead of the default username
  email = models.EmailField(max_length=255, unique=True)
  name = models.CharField(max_length=255)
  is_active = models.BooleanField(default=True)
  is_staff = models.BooleanField(default=False)

  objects = UserManager()
  USERNAME_FIELD = 'email'