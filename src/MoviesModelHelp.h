#pragma once

#include <QtQml>
#include <QObject>

class UnitSysOrder : public QObject
{
    Q_OBJECT
    public:
        UnitSysOrder() : QObject() {}

        enum class Order
        {
            None,
            Asc,
            Desc
        };
        Q_ENUMS(Order)

        // Do not forget to declare your class to the QML system.
        static void declareQML()
        {
            qmlRegisterType<UnitSysOrder>("UnitSys", 1, 0, "Order");
        }
};

class UnitSysRole : public QObject
{
    Q_OBJECT
    public:
        UnitSysRole() : QObject() {}

        enum Role
        {
            Title = Qt::UserRole +1,
            TitleOriginal,
            Genre,
            Year,
            Timestamp,
            Plot,
            Poster,
            UserRating,
            Rating,
            Url
        };
        Q_ENUMS(Role)

        // Do not forget to declare your class to the QML system.
        static void declareQML()
        {
            qmlRegisterType<UnitSysRole>("UnitSys", 1, 0, "Role");
        }
};

Q_DECLARE_METATYPE(UnitSysOrder::Order)
Q_DECLARE_METATYPE(UnitSysRole::Role)
