from django.db import models


class Doctor(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    address = models.CharField(max_length=100)
    phone = models.CharField(max_length=100)
    specialization = models.CharField(max_length=100)
    clinic_name = models.CharField(max_length=100)

    def __str__(self):
        return f'{self.first_name} {self.last_name}'

    class Meta:
        unique_together = ['address', 'phone']


class Medicine(models.Model):
    scientific_name = models.CharField(max_length=100)
    trade_name = models.CharField(max_length=100)
    producing_company = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=6, decimal_places=2)

    def __str__(self):
        return self.scientific_name


class SalesRepresentative(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=100, unique=True)
    address = models.CharField(max_length=100)
    password = models.CharField(max_length=128)
    last_login = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f'{self.first_name} {self.last_name}'


class Sales(models.Model):
    sales_representative = models.ForeignKey(
        SalesRepresentative, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    remark = models.CharField(max_length=500)
    date = models.DateField()
    medicines = models.ManyToManyField(Medicine, through='SalesMedicine')

    def __str__(self):
        return f'{self.sales_representative} - {self.doctor}'


class SalesMedicine(models.Model):
    sales = models.ForeignKey(Sales, on_delete=models.CASCADE, blank=True)
    medicine = models.ForeignKey(Medicine, on_delete=models.CASCADE)
    quantity_type = models.CharField(max_length=50)
    quantity = models.PositiveIntegerField()
