# Testing

&nbsp;
## Running Basic Unit Test

Create a new file in which our function will be executed, let's call it `calc.py`, inside the Docker root file. Then let's add a simple addition function:

```py
# ./app/app/calc.py

def add(x, y) 
  return x + y
```

Now create a tests file in the Docker root directory, let's call it `test.py`:

```py
# ./app/app/tests.py

# Import the TestCase with helper methods from django.test (this is more like Java than JS)
from django.test import TestCase
# Import the function to test
from app.calc import add
# Create a class, name it sensibly and inherit from the TestCase class (so we can access helper methods)
class CalcTests(TestCase):
  # Define a test, pass in the instance of the class
  def test_add_numbers(self):
    self.assetEqual(add(3, 8), 11);
```

> NOTE: When writing tests, the test file, must have test in the name and the functions inside the class must begin with test.

As we are using Docker, the command to run the tests is:

```bash
docker-compose run app sh -c "python manage.py test"

# You can also execute the linter with:
# docker-compose run app sh -c "python manage.py test && flake8"
```

&nbsp;
## Platform Tests

&nbsp;
### Validate User
When creating a user with an email address, we are likely to want to ensure that the provided email is valid. Let's write a test to ensure that. First we write a test:

```py
# ./app/core/test.tests_models.py

...
class ModelTests(TestCase):
  ...

  def test_new_user_invalid_email(self):
    with self.assertRaises(ValueError):
      get_user_model().objects.create_user(None, 'test123')
```

What this function does is that it says we expect this test to raise an exception (with ValueError type) when we run the function below to create a user. Notice we are passing None as an email value which we know is not valid. 

Now to make the test pass we need to add the code inside the model file:

```py
# ./app/core/models.py

...
class UserManager(BaseUserManager):
  
  def create_user(self, email, password=None, **extra_fields)
    if not email:
      raise ValueError('Users must have a valid email address')
    user = self.model(email=self.normalize_email(email), **extra_fields)
    user.set_password(password)
    user.save(using=self._db)
    return user
  
  ...
```
If you run the test now, it will pass because we have ensured that if `None` is entered as a value for email, the user will not be created.