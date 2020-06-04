# Constructing Python API

&nbsp;
## Core App
The core app will host all of our core elements which will be used across the application.

To add our core functions enter:

```bash
docker-compose run app sh -c "python manage.py startapp core"
```
This will run the manage.py helper script and will pass in the command startapp core, creating a new core app inside the existing project. Now quickly go back into the ./app/app directory and enter into the settings file and add core to the list of installed apps:

```py
# ./app/app/settings.py

INSTALLED_APPS = [
  ...
  'core'
]
```

For this application we will not be using the following files, so you can delete them:

* tests
* views

&nbsp;
### Testing

We will still be testing, but we will be adding our own test files, in our own location. Go ahead and create `./app/core/tests/__init__.py`. _We have called the file something other than tests, because you are only allowed to have either a file named test/tests or a folder with the name. If you have both errors will occur_. 

Now inside the tests file, create a file called `tests_models.py`:

```py
# ./app/core/tests/tests_models.py

from django.test import TestCase
from django.contrib.auth import get_user_model

class ModelTests(TestCase):

  def test_create_user_with_email_successful(self):
    # Tests whether creation of a new user with an email is successful
    email = 'test@test.co.uk'
    password = 'pass123'
    user = get_user_model().objects.create_user(username = email, password = password)

    self.assertEqual(user.username, email)
    self.assertTrue(user.check_password(password))
```

_Notice that the above uses username - this is because the helper function within Django expects username not email. If you try this with email in place of username in the two locations above you will receive an error._

This is just for demonstration purposes, as we actually want to create a custom user model which we will create with an email field, rather than a username field. 


&nbsp;
### Models
Models should be created inside the models.py file, in this case we will create a user model and then update the test to make it pass with the new structure:

```py
# ./app/core/models.py

from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin

class UserManager(BaseUserManager):

  def create_user(self, email, password=None, **extra_fields):
    # Creates and saves a new user
    user = self.model(email=email, **extra_fields)
    # Adds the user's password to the object
    user.set_password(password)
    # Saves the object to the database
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
```
**What's going on?**
First we import the models from Django and the base user, manager and permissions mixin. Then we create a UserManager class which extends the BaseUserManager class. In this class we create a user using the email and password we're passing in, then we save to the database.

Then we create a new custom User class, which extends the abstract base user and the permissions mixin. It has the following variables, email, name, is_active and is_staff. it then assigns a user object to the variable objects and finally confirms that the USERNAME_FIELD should actually be email.

Now we need to add the custom user model to the settings file:

```py
# ./app/app/settings.py

...
AUTH_USER_MODEL = 'core.User'
```

Finally, go back to the test file and change the function to use email rather than username:

```py
# ./app/core/tests/tests_models.py

...
class ModelTests(TestCase):

  def test_create_user_with_email_successful(self):
    # Tests whether creation of a new user with an email is successful
    email = 'test@test.co.uk'
    password = 'pass123'
    user = get_user_model().objects.create_user(email = email, password = password)

    self.assertEqual(user.email, email)
    self.assertTrue(user.check_password(password))
```

When we run the tests, this should now work.

&nbsp;
#### Creating a Superuser
> **What is a superuser?**
> A superuser is a user with high level permissions, which can be created by Django. It is a field on the class instance of user which is included in PermissionsMixin. This is why it is not actually included in the user model.

First let's write the test:

```py
# ./app/core/tests/tests_models.py

def test_super_user_created(self):
    # Test creating a new superuser
    user = get_user_model().objects.create_superuser(
      'test@test.com',
      'pass123'
    )
    self.assertTrue(user.is_superuser)
    self.assertTrue(user.is_staff)
```

Then let's add the method to the user model class:

```py
# ./app/core/models.py

...
class UserManager(BaseUserManager):
  ...
  def create_superuser(self, email, password):
    user = self.create_user(email, password)
    user.is_staff = True
    user.is_superuser = True
    user.save(using=self._db)
    return user
...
```
So we're running thre regular create user command, which will validate the email and we're setting the fields, is_staff and is_superuser to `True`. Then we save to the database.