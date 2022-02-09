import ast

from rest_framework import viewsets

from saleofmedicines.models import Doctor, Medicine, SalesRepresentative, Sales
from saleofmedicines.serializers import DoctorSerializer, MedicineSerializer, SalesRepresentativeSerializer, \
    SalesSerializer


class DoctorViewSet(viewsets.ModelViewSet):
    serializer_class = DoctorSerializer
    queryset = Doctor.objects.all()

    def get_queryset(self):
        if self.request.GET.get('ids'):
            ini_list = self.request.GET.get('ids')
            ids_list = ast.literal_eval(ini_list)
            self.queryset = Doctor.objects.filter().exclude(id__in=ids_list)
        return super(DoctorViewSet, self).get_queryset()


class MedicineViewSet(viewsets.ModelViewSet):
    serializer_class = MedicineSerializer
    queryset = Medicine.objects.all()

    def get_queryset(self):
        if self.request.GET.get('ids'):
            ini_list = self.request.GET.get('ids')
            ids_list = ast.literal_eval(ini_list)
            self.queryset = Medicine.objects.filter().exclude(id__in=ids_list)
        return super(MedicineViewSet, self).get_queryset()


class SalesRepresentativeViewSet(viewsets.ModelViewSet):
    serializer_class = SalesRepresentativeSerializer
    queryset = SalesRepresentative.objects.all()

    def get_queryset(self):
        if self.request.GET.get('ph') and self.request.GET.get('pas'):
            phone = self.request.GET.get('ph')
            password = self.request.GET.get('pas')
            self.queryset = SalesRepresentative.objects.filter(
                phone_number=phone, password=password)
        else:
            self.queryset = SalesRepresentative.objects.none()
        return super(SalesRepresentativeViewSet, self).get_queryset()


class SalesViewSet(viewsets.ModelViewSet):
    serializer_class = SalesSerializer
    queryset = Sales.objects.all()
