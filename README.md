# Flutter CRUD Application with Django REST API

This project demonstrates a basic CRUD (Create, Read, Update, Delete) operation application built using **Flutter** for the frontend and **Django REST Framework** for the backend.

---

## **Project Structure**

### **Frontend**: Flutter
- **Framework**: Flutter
- **State Management**: Provider / Riverpod / GetX (Choose one)
- **Features**:
  - Display list of items.
  - Add a new item.
  - Edit an existing item.
  - Delete an item.

### **Backend**: Django REST Framework
- **Framework**: Django
- **API Framework**: Django REST Framework
- **Database**: SQLite (default) / PostgreSQL
- **Endpoints**:
  - `GET /api/items/`: Retrieve all items.
  - `POST /api/items/`: Create a new item.
  - `PUT /api/items/<id>/`: Update an item.
  - `DELETE /api/items/<id>/`: Delete an item.

---

## **Setup Instructions**

### **1. Backend Setup (Django REST API)**

1. **Install Python and Django**
   ```bash
   pip install django djangorestframework
   ```

2. **Create a Django Project**
   ```bash
   django-admin startproject crud_django_api
   cd crud_django_api
   ```

3. **Create an App**
   ```bash
   python manage.py startapp items
   ```

4. **Configure Models** (in `items/models.py`):
   ```python
   from django.db import models

   class Item(models.Model):
       name = models.CharField(max_length=255)
       description = models.TextField()
       created_at = models.DateTimeField(auto_now_add=True)
       updated_at = models.DateTimeField(auto_now=True)

       def __str__(self):
           return self.name
   ```

5. **Migrate Database**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. **Create Serializers** (in `items/serializers.py`):
   ```python
   from rest_framework import serializers
   from .models import Item

   class ItemSerializer(serializers.ModelSerializer):
       class Meta:
           model = Item
           fields = '__all__'
   ```

7. **Create Views** (in `items/views.py`):
   ```python
   from rest_framework import viewsets
   from .models import Item
   from .serializers import ItemSerializer

   class ItemViewSet(viewsets.ModelViewSet):
       queryset = Item.objects.all()
       serializer_class = ItemSerializer
   ```

8. **Register Routes** (in `crud_django_api/urls.py`):
   ```python
   from django.contrib import admin
   from django.urls import path, include
   from rest_framework.routers import DefaultRouter
   from items.views import ItemViewSet

   router = DefaultRouter()
   router.register(r'items', ItemViewSet)

   urlpatterns = [
       path('admin/', admin.site.urls),
       path('api/', include(router.urls)),
   ]
   ```

9. **Run the Server**
   ```bash
   python manage.py runserver
   ```

   Your API is now available at `http://127.0.0.1:8000/api/items/`.

---

### **2. Frontend Setup (Flutter)**

1. **Install Flutter**
   Follow the [official guide](https://docs.flutter.dev/get-started/install) to install Flutter.

2. **Create a New Flutter Project**
   ```bash
   flutter create crud_app
   cd crud_app
   ```

3. **Add HTTP Package**
   Add the `http` package to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     http: ^0.15.0
   ```

   Run:
   ```bash
   flutter pub get
   ```

4. **Create API Service**
   Create a file `lib/services/api_service.dart`:
   ```dart
   import 'dart:convert';
   import 'package:http/http.dart' as http;

   class ApiService {
     static const String baseUrl = "http://127.0.0.1:8000/api/items/";

     Future<List<dynamic>> fetchItems() async {
       final response = await http.get(Uri.parse(baseUrl));
       return jsonDecode(response.body);
     }

     Future<void> addItem(Map<String, dynamic> item) async {
       await http.post(Uri.parse(baseUrl),
           headers: {"Content-Type": "application/json"},
           body: jsonEncode(item));
     }

     Future<void> updateItem(int id, Map<String, dynamic> item) async {
       await http.put(Uri.parse("$baseUrl$id/"),
           headers: {"Content-Type": "application/json"},
           body: jsonEncode(item));
     }

     Future<void> deleteItem(int id) async {
       await http.delete(Uri.parse("$baseUrl$id/"));
     }
   }
   ```

5. **Implement UI**
   Update the `lib/main.dart` file to include the CRUD operations and interact with the API.

6. **Run the App**
   Start the Flutter application:
   ```bash
   flutter run
   ```

---

## **Usage**

1. **Start Backend**
   Run the Django development server:
   ```bash
   python manage.py runserver
   ```

2. **Start Frontend**
   Run the Flutter application:
   ```bash
   flutter run
   ```

3. **Perform CRUD Operations**
   - View all items.
   - Add new items.
   - Edit existing items.
   - Delete items.

---

## **Future Improvements**
- Add authentication (e.g., JWT tokens).
- Use a more robust database like PostgreSQL.
- Implement state management in Flutter (e.g., Provider, GetX).

---

## **Contributing**
Feel free to open issues or submit pull requests to improve this project!

---

## **License**
This project is licensed under the MIT License.
