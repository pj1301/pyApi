from django.test import TestCase


from app.calc import add, subtract


class CalcTests(TestCase):

  def test_add(self):
    self.assertEqual(add(4, 9), 13)

  def test_substract(self):
    self.assertEqual(subtract(5, 4), 1)