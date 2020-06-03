# Python Basics

&nbsp;
## Conventions

&nbsp;
### Naming
* UpperCamelCase for classes
* CAPITALISED_UNDERSCORED for constants
* snake_case for everything else


&nbsp;
## Functions
Functions in Python have a simple structure:

```py
def function_name(variable):
  result = 'result'
  return result
```

As with JavaScript you can pass in a default value for a variable:

```py
def function_name(variable=None):
  # some code
```

You can also group additional fields into a single term:

```py
def function_name(variable, **extra_fields):
  # some code
```