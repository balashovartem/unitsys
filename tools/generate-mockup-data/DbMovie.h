#pragma once

#include <QtCore/QMetaType>
#include <QtCore/QString>
#include <QtCore/QDateTime>
#include <QtCore/QUuid>

#include <odb/core.hxx>


#pragma db object table("Movies")
struct DbMovie
{
    DbMovie();
#pragma db id
    QUuid id;
#pragma db auto
    //Название на русском языке
    QString title;
#pragma db auto
    //Оригинальное название
    QString title_original;
#pragma db index
    //Жанр
    QString genre;
#pragma db auto
    //Год
    quint16 year;
#pragma db auto
    //Дата добавления
    QDateTime timestamp;
#pragma db auto
    //Описание
    QString plot;
#pragma db auto
    //Постер
    QByteArray poster;
#pragma db auto
    //Пользовательская оценка
    quint8 user_rating;
#pragma db auto
    //Рейтинг
    double rating;
#pragma db auto
    //Ссылка на кинопоиск
    QString url;
};

