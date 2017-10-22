#include <QApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QFontDatabase>

//#include <odb/sqlite/database.hxx>
//#include <odb/schema-catalog.hxx>
//#include <odb/transaction.hxx>
//#include "DbMovie.h"
//#include "DbMovie-odb.h"


#include <QSqlDatabase>
#include <QSqlError>

#include "MoviesModel.h"
#include "MoviesModelHelp.h"

Q_LOGGING_CATEGORY( TAG_MAIN, "unitsys.main" )


int main( int argc, char **argv )
{
    QApplication app( argc, argv );

    //генерация базы данных
/*
    {
        odb::sqlite::database dataBase( "movies.db", SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE );
        odb::transaction t( dataBase.begin() );
        odb::schema_catalog::create_schema( dataBase, "DbMovie" );

        for( int i = 0; i < 1024; i++ )
        {
            DbMovie movie;
            movie.title = QString("гавно %1").arg(i);
            movie.title_original = QString("shit %1").arg(i);
            movie.plot = QString("Гавносюжет %1").arg(i);
            movie.genre = QString("гавно %1").arg( i%10 );
            movie.year = 1900 + i%100;

            dataBase.persist( movie );
        }

        t.commit();
    }
*/


    QSqlDatabase moviesDb = QSqlDatabase::addDatabase("QSQLITE");
    moviesDb.setDatabaseName( "movies.db" );
    bool success = moviesDb.open();
    if( !success )
    {
        qCWarning( TAG_MAIN ) << "Ошибка открытия базы данных" << moviesDb.databaseName() << ":" << moviesDb.lastError();
        return 0;
    }

    MoviesModel moviesModel( moviesDb );

    UnitSysRole::declareQML();
    UnitSysOrder::declareQML();

    QQmlApplicationEngine engine;
    QQuickStyle::setStyle("Material");
    QFontDatabase::addApplicationFont( ":/icons/materialdesignicons-webfont.ttf" );

    engine.rootContext()->setContextProperty( "moviesModel", &moviesModel );
    engine.load( QUrl("qrc:/src/MainWindow.qml") );

    return app.exec();
}
