#pragma once

#include <QObject>
#include <QSqlQueryModel>
#include <QSqlDatabase>
#include <QHash>
#include <QByteArray>
#include <QString>
#include <QUuid>

class MoviesModel : public QSqlQueryModel
{
    Q_OBJECT
    quint8 defaultPaginationStep = 10;
public:
    enum Order
    {
        None,
        Asc,
        Desc
    };
    Q_ENUMS(Order)
    enum Role
    {
        Id = Qt::UserRole +1,
        Title,
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
    explicit MoviesModel( QSqlDatabase db, QObject *parent = nullptr );
    virtual ~MoviesModel();

    Q_INVOKABLE QStringList genres() const;
    Q_INVOKABLE QStringList years() const;
    Q_INVOKABLE quint64 count() const;

    Q_INVOKABLE bool setUserRating(const QByteArray &id, int rating );
    Q_INVOKABLE bool setFilter( Role role, const QString & filter );
    Q_INVOKABLE bool setOrder( Role role, Order order );
    Q_INVOKABLE bool order( Role role ) const;

    Q_INVOKABLE bool setPaginationStep( quint8 step );
    Q_INVOKABLE quint8 paginationStep() const;

    Q_INVOKABLE quint64 currentPage() const;
    Q_INVOKABLE bool setCurrentPage( const quint64 & page );
    Q_INVOKABLE quint64 pageCount() const;

    QHash<int, QByteArray> roleNames() const;
    QVariant data( const QModelIndex &index, int role) const;

signals:
    void currentPageChanged( quint64 page );
    void pageCountChanged( quint64 pageCount );
    void paginationStepChanged( quint8 step );
    void orderChanged( Role role, Order order );

private:
    void updateQuery();

private:
    QSqlDatabase mDb;
    quint8 mPaginationStep;
    quint64 mCurrentPage;
    quint64 mRowCount;

    QMap<Role,QString/*filter*/> mFilters;
    QMap<Role,Order > mOrders;
    QStringList mGenres;
    QStringList mYears;
};

Q_DECLARE_METATYPE(QModelIndex)
