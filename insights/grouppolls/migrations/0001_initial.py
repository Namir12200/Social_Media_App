# Generated by Django 4.2.3 on 2023-07-09 02:17

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('group', '0003_remove_group_members'),
        ('userPortrait', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Question',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('question_text', models.CharField(max_length=200)),
                ('pub_date', models.DateTimeField(auto_now_add=True)),
                ('finished', models.BooleanField(default=False)),
                ('group', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, to='group.group')),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='userPortrait.userprofile')),
            ],
        ),
        migrations.CreateModel(
            name='Choice',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('choice_text', models.CharField(max_length=200)),
                ('votes', models.IntegerField(default=0)),
                ('question', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='grouppolls.question')),
            ],
        ),
    ]
