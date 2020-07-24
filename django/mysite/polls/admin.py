from django.contrib import admin
from django.utils.html import format_html

# Register your models here.
from .models import Question, Choice, Item

class ChoiceAdmin(admin.ModelAdmin):
    list_display = ('choice_text', 'votes')
    
class ItemAdmin(admin.ModelAdmin):
    list_display = ('item', 'quantity', 'unit_price', 'amount_money', 'custom_column')
    class Media:
        js = ('js/sum.js',) 

    def custom_column(self, obj):
        return format_html('<div class="custom" id="test-' + str(obj.pk) + '">' + str(obj.pk) + '</dev>')
        
admin.site.register(Question)
admin.site.register(Choice, ChoiceAdmin)
admin.site.register(Item, ItemAdmin)
