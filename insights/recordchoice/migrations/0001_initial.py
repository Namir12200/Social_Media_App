# Generated by Django 4.2.3 on 2023-07-09 04:57

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('grouppolls', '0001_initial'),
        ('groupmember', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='ChoiceRecord',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('choice', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='grouppolls.choice')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='groupmember.groupmember')),
                ('question', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='grouppolls.question')),
            ],
        ),
    ]
