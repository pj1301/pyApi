from django.test import TestCase
from django.contrib.auth import get_user_model

class ModelTests(TestCase):

  def test_create_user_with_email_successful(self):
    # Tests whether creation of a new user with an email is successful
    email = 'test@test.co.uk'
    password = 'pass123'
    user = get_user_model().objects.create_user(email = email, password = password)

    self.assertEqual(user.email, email)
    self.assertTrue(user.check_password(password))


  def test_new_user_email_normalised(self):
    #Test that the email address has been normalised
    email = 'test@LONDONDEV.CO.UK'
    user = get_user_model().objects.create_user(email, 'pass123')

    self.assertEqual(user.email, email.lower())


  def test_new_user_invalid_email(self):
    # Test that creating user without an email value, raises an error
    with self.assertRaises(ValueError):
      # If the above doesn't raise a value error test will fail
      get_user_model().objects.create_user(None, 'test123')


  def test_super_user_created(self):
    # Test creating a new superuser
    user = get_user_model().objects.create_superuser(
      'test@test.com',
      'pass123'
    )
    self.assertTrue(user.is_superuser)
    self.assertTrue(user.is_staff)