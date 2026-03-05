from django.test import TestCase
from django.urls import reverse

class BasicTest(TestCase):

    def test_home_page(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
