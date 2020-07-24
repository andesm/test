from django.db import models

# Create your models here.

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')


class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)

class Item(models.Model):
    item = models.CharField('アイテム', max_length=50)
    quantity = models.IntegerField('数量', default=1)
    unit_price = models.CharField('単価', max_length=20)
    amount_money = models.CharField('金額', max_length=20)
    def __str__(self):
        return self.item
    class Meta:
        verbose_name = 'アイテム'
        verbose_name_plural = 'アイテム'
