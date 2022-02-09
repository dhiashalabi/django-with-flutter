from django.contrib import admin

from saleofmedicines.models import Doctor, Medicine, SalesRepresentative, Sales


class DoctorAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'address',
                    'phone', 'specialization', 'clinic_name')


admin.site.register(Doctor, DoctorAdmin)


class MedicineAdmin(admin.ModelAdmin):
    list_display = ('scientific_name', 'trade_name',
                    'producing_company', 'price')


admin.site.register(Medicine, MedicineAdmin)


class SalesRepresentativeAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name',
                    'phone_number', 'address', 'last_login')
    fields = ('first_name', 'last_name', 'phone_number', 'password', 'address')


admin.site.register(SalesRepresentative, SalesRepresentativeAdmin)


class SalesActionMedicineInline(admin.TabularInline):
    model = Sales.medicines.through
    extra = 1


class SalesActionAdmin(admin.ModelAdmin):
    list_display = ('sales_representative', 'doctor', 'remark', 'date')
    inlines = [SalesActionMedicineInline]


admin.site.register(Sales, SalesActionAdmin)
