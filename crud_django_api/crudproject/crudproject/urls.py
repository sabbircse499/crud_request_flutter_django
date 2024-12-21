from django.contrib import admin
from django.urls import path
from crudapp import views  # Import views from your app

urlpatterns = [
    path('admin/', admin.site.urls),  # Admin interface
    # path('adddata/', views.add_data),  # Custom view for handling "adddata/"
    path('items/', views.ItemList.as_view(), name='item-list'),  # List all items or create a new item

    path('item/<int:pk>/', views.ItemDetail.as_view(), name='item-detail'),  # Retrieve, update, or delete an item by ID

# for distinkct items show
    path('items/distinct/', views.ItemValue.as_view(), name='item-distinclist'),  # List all items or create a new item
]
