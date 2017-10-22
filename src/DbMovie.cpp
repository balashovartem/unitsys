#include "DbMovie.h"

DbMovie::DbMovie()
    :
      id( QUuid::createUuid() ),
      timestamp( QDateTime::currentDateTime() )
{

}
