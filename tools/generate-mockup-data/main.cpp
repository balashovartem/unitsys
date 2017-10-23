#include <QString>
#include <QList>

#include "DbMovie.h"
#include "DbMovie-odb.h"

#include <odb/sqlite/database.hxx>
#include <odb/schema-catalog.hxx>
#include <odb/transaction.hxx>


int main( int argc, char **argv )
{

    odb::sqlite::database dataBase( "movies.db", SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE );
    odb::transaction t( dataBase.begin() );

    dataBase.tracer( odb::stderr_tracer );
    odb::schema_catalog::create_schema( dataBase, "DbMovie" );

    QList<QString> genres;
    genres << "Short" << "Drama" << "Comedy" << "Documentary" << "Adult" << "Thriller" << "Action" << "Romance" << "Music"
           << "Animation" << "Horror" << "Family" << "Crime" << "Adventure" << "Fantasy" << "Sci-Fi" << "Mystery" << "Biography"
           << "History" << "Sport" << "Musical" << "War" << "Reality-TV" << "Western" << "News" << "Talk-Show" << "Game-Show";
    QList<QPair<QString,QString> > titles;
    titles << qMakePair( QString("Побег из Шоушенка"), QString("The Shawshank Redemption") )
           << qMakePair( QString("Зеленая миля"), QString("The Green Mile") )
           << qMakePair( QString("Форрест Гамп"), QString("Forrest Gump") )
           << qMakePair( QString("Список Шиндлера"), QString("Schindler's List") );

    for( int i = 0; i < 1024; i++ )
    {
        DbMovie movie;
        movie.title = titles[ qrand()%titles.size() ].first + " " + QString::number( i );
        movie.title_original = titles[ qrand()%titles.size() ].second + " " + QString::number( i );
        for( int wordCount = 0; wordCount < i%100; ++wordCount )
        {
            movie.plot += genres.at( qrand()%genres.size() ) + " ";
        }
        movie.plot = "Сюжет: " + movie.plot;
        movie.genre = genres.at( i%genres.size() );
        movie.year = 1900 + i%100;
        movie.rating = (qrand()%10000)/100;
        movie.user_rating = 0;


        dataBase.persist( movie );
    }

    t.commit();
}
