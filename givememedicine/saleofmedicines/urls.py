from django.urls import path, include
from rest_framework import routers

from saleofmedicines.views import DoctorViewSet, MedicineViewSet, SalesRepresentativeViewSet, \
    SalesViewSet

router = routers.DefaultRouter()
router.register('doctors', DoctorViewSet, 'doctors')
router.register('medicines', MedicineViewSet, 'medicines')
router.register('sales-representative',
                SalesRepresentativeViewSet, 'sales_representative')
router.register('sales', SalesViewSet, 'sales')

urlpatterns = [
    path('', include(router.urls)),
]
