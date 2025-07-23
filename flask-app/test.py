import unittest
from app import app

class FlaskAppTestCase(unittest.TestCase):

    def setUp(self):
        # Creates a test client
        self.app = app.test_client()
        self.app.testing = True

    def test_home_status_code(self):
        # Test that the homepage loads successfully
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    def test_home_content(self):
        # Test that the rendered page contains expected text
        response = self.app.get('/')
        self.assertIn(b'Welcome to Flask!', response.data)
        self.assertIn(b'Hello, Shorya!', response.data)

    def test_invalid_route(self):
        # Test a non-existent route returns 404
        response = self.app.get('/invalid')
        self.assertEqual(response.status_code, 404)

if __name__ == '__main__':
    unittest.main()
