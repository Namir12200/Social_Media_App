# Generated by Django 4.2.2 on 2023-06-29 14:31

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('userPortrait', '0001_initial'),
        ('post', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='PostLikes',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('liked', models.BooleanField(default=False)),
                ('disliked', models.BooleanField(default=True)),
                ('post', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='post.post')),
                ('rated_by', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='userPortrait.userprofile')),
            ],
        ),
        migrations.DeleteModel(
            name='tag',
        ),
    ]
