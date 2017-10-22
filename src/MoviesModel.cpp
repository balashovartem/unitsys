#include "MoviesModel.h"
#include <QSqlRecord>
#include <QSqlQuery>
#include <QSqlField>

#include <QLoggingCategory>

Q_LOGGING_CATEGORY( TAG_MOVIES_MODEL, "unitsys.MoviesModel" )

MoviesModel::MoviesModel( QSqlDatabase db, QObject *parent )
    :
      QSqlQueryModel( parent ),
      mDb( db )
{
    mPaginationStep = defaultPaginationStep;
    mCurrentPage = 0;
    updateQuery();
    foreach( int roleId, roleNames().keys() )
    {
        mOrders[ static_cast<Role>( roleId ) ] = Order::None;
    }
}

MoviesModel::~MoviesModel()
{

}

QStringList MoviesModel::genres() const
{
    return mGenres;
}

QStringList MoviesModel::years() const
{
    return mYears;
}

quint64 MoviesModel::count() const
{
    return mRowCount;
}

bool MoviesModel::setUserRating(const QByteArray &id, int rating )
{
    QString updateSql( QString("UPDATE movies SET user_rating = '%2'  WHERE hex(id) = '%1';").arg( QString::fromLatin1( id, id.size() ) ).arg( rating ) );
    qCDebug( TAG_MOVIES_MODEL ) << id.size() << "Обновление пользовательской оценки" << updateSql;
    QSqlQuery query = mDb.exec( updateSql );
    query.next();
    updateQuery();
    return true;
}

bool MoviesModel::setFilter( Role role, const QString & filter )
{
    if( mFilters.value( role ) != filter )
    {
        qCDebug( TAG_MOVIES_MODEL ) << "установка фильтра" << filter << "для поля" << role;
        mFilters[role] = filter;
        updateQuery();
        return true;
    }
    return false;
}

bool MoviesModel::setOrder( Role role, Order order )
{
    if( mOrders.value( role ) != order )
    {
        qCDebug( TAG_MOVIES_MODEL ) << "установка порядка" << order << "для поля" << role;
        mOrders[role] = order;
        if( order != Order::None )
        {
            foreach( const Role iRole, mOrders.keys() )
            {
                if( iRole != role )
                {
                    mOrders[iRole] = Order::None;
                    orderChanged( iRole, Order::None );
                }
            }
        }

        updateQuery();
        orderChanged( role, order );
        return true;
    }
    return false;
}

bool MoviesModel::order( Role role ) const
{
    return mOrders.value( role );
}

bool MoviesModel::setPaginationStep( quint8 step )
{
    if( mPaginationStep != step )
    {
        mPaginationStep = step;
        updateQuery();
        paginationStepChanged( mPaginationStep );
        return true;
    }
    return false;
}

quint8 MoviesModel::paginationStep() const
{
    return mPaginationStep;
}

quint64 MoviesModel::currentPage() const
{
    return mCurrentPage;
}

bool MoviesModel::setCurrentPage( const quint64 & page )
{
    if( page >= pageCount() )
    {
        return false;
    }
    if( mCurrentPage != page )
    {
        mCurrentPage = page;
        updateQuery();
        currentPageChanged( 0 );
        return true;
    }
    return false;
}
quint64 MoviesModel::pageCount() const
{
    return std::ceil( mRowCount /(float) mPaginationStep );
}

QHash<int, QByteArray> MoviesModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    for( int i = 0; i < record().count(); i++)
    {
        roles[Qt::UserRole + i + 1] = record().fieldName(i).toLatin1();
    }
    return roles;
}

QVariant MoviesModel::data(const QModelIndex &index, int role) const
{
    QVariant value = QSqlQueryModel::data(index, role);
    if(role < Qt::UserRole)
    {
        value = QSqlQueryModel::data(index, role);
    }
    else
    {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}

void MoviesModel::updateQuery()
{
    {
        QSqlQuery query = mDb.exec( "SELECT DISTINCT genre FROM movies ORDER BY genre ASC" );
        mGenres.clear();
        while( query.next() ) {
            mGenres << query.value( 0 ).toString();
        }
    }

    {
        QSqlQuery query = mDb.exec( "SELECT DISTINCT year FROM movies ORDER BY year ASC" );
        mYears.clear();
        while( query.next() ) {
            mYears << query.value( 0 ).toString();
        }
    }

    QString sqlFilter;
    if( !mFilters.isEmpty() )
    {
        foreach( const QString & filter, mFilters.values() )
        {
            if( !filter.isEmpty() )
            {
                sqlFilter += filter + " AND ";
            }
        }
        if( !sqlFilter.isEmpty() )
        {
            sqlFilter = sqlFilter.left( sqlFilter.size() - 4 );
            sqlFilter = QString("WHERE %1").arg( sqlFilter );
        }
    }

    QString orderQuery;
    foreach( const Role role, mOrders.keys() )
    {
        const Order order = mOrders.value( role );
        if( order != Order::None )
        {
            QString fieldName = record().fieldName( static_cast<int>( role ) - Qt::UserRole - 1 );
            orderQuery += QString("ORDER BY movies.%1 %2").arg( fieldName ).arg( order == Order::Asc ? "ASC" : "DESC" );
        }
    }

    {
        quint64 lastPageCount = pageCount();
        //sqlFilter сделать экранирования знака %
        QSqlQuery query = mDb.exec( QString("SELECT COUNT(*) FROM movies %2 %1" ).arg( orderQuery ).arg( sqlFilter ) );
        query.next();
        mRowCount = query.value( 0 ).toULongLong();
        quint64 currentPageCount = pageCount();
        if( lastPageCount != currentPageCount )
        {
            qCDebug( TAG_MOVIES_MODEL ) << "emit pageCountChanged(" << currentPageCount << ")";
            pageCountChanged( currentPageCount );
        }
    }
    //sqlFilter сделать экранирования знака %
    QString query = QString("SELECT hex(movies.id) as id, movies.title, movies.title_original, movies.genre, movies.year, movies.timestamp,"\
                            "movies.plot, movies.poster, movies.user_rating, movies.rating, movies.url FROM movies %4 %3 LIMIT %1, %2;")
                     .arg( mCurrentPage*mPaginationStep ).arg( mPaginationStep ).arg( orderQuery ).arg( sqlFilter );
    qCDebug( TAG_MOVIES_MODEL ) << query << sqlFilter ;
    setQuery( query, mDb );
}
