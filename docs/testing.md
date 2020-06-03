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