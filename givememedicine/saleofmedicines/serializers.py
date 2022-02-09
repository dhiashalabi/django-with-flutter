from rest_framework import serializers

from saleofmedicines.models import Doctor, Medicine, SalesRepresentative, Sales


class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = (
            'id', 'first_name', 'last_name',
            'address', 'phone', 'specialization', 'clinic_name'
        )


class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = (
            'id', 'scientific_name', 'trade_name',
            'producing_company', 'price'
        )


class SalesRepresentativeSerializer(serializers.ModelSerializer):
    class Meta:
        model = SalesRepresentative
        fields = (
            'id',
        )


class SalesMedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Sales.medicines.through
        fields = ('medicine', 'quantity_type', 'quantity')


class SalesSerializer(serializers.ModelSerializer):
    medicines = SalesMedicineSerializer(source='salesmedicine_set', many=True)

    def create(self, validated_data):
        medicines = validated_data.pop('salesmedicine_set')
        sales = Sales.objects.create(**validated_data)
        for medicine in medicines:
            Sales.medicines.through.objects.create(sales=sales, **medicine)
        return sales

    class Meta:
        model = Sales
        fields = ('id', 'sales_representative', 'doctor',
                  'remark', 'date', 'medicines')
