from django.core.urlresolvers import reverse
#from django.test import TestCase
from rest_framework import status
from rest_framework.test import APITestCase
from todo.models import TodoItem
# Create your tests here.

def createItem(client):
    url = reverse('todoitem-list')
    data = {'title': 'Walk the dog'}
    return client.post(url, data, format='json')

class TestCreateTodoItem(APITestCase):
    """
    Ensure we can create a new toto item
    """
    def setUp(self):
        self.response = createItem(self.client)

    def test_received_201_created_status_code(self):
        self.assertEqual(self.response.status_code, status.HTTP_201_CREATED)

    def test_recieve_location_header_hyperlink(self):
        self.assertRegexpMatches(self.response['Location'], '^http://.+/todos/[\d]+$')

class TestUpdateTodoItem(APITestCase):
    """
    Ensures we can update an existing todo item using PUT
    """
    def setUp(self):
        response = createItom(self.client)
        selt.assertEqual(TodoItem.objects.get().completed, False)
        url = response['Location']
        data = {'title': 'Walk the dog', 'completed': True}
        self.response = self.client.put(url, data, format=json)
