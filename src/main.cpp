#include <QApplication>
#include <QLoggingCategory>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QFontDatabase>


#include <QSqlDatabase>
#include <QSqlError>

#include "MoviesModel.h"
#include "MoviesModelHelp.h"

Q_LOGGING_CATEGORY( TAG_MAIN, "unitsys.main" )


int main( int argc, char **argv )
{
    QApplication app( argc, argv );


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
