#include <osg/Object>
#include <osg/UserDataContainer>
#include <osgDB/ObjectWrapper>
#include <osgDB/InputStream>
#include <osgDB/OutputStream>
#include <osg/Notify>
#include <string.h>

static bool checkUserData( const osg::Object& obj )
{
    return (obj.getUserData() && dynamic_cast<const osg::Object*>(obj.getUserData()));
}

static bool readUserData( osgDB::InputStream& is, osg::Object& obj )
{
    is >> osgDB::BEGIN_BRACKET;
    osg::Object* object = is.readObject(); 
    if(object) obj.setUserData(object); 
    is >> osgDB::END_BRACKET;
    return true;
}

static bool writeUserData( osgDB::OutputStream& os, const osg::Object& obj )
{
    os << osgDB::BEGIN_BRACKET << std::endl;
    os.writeObject(dynamic_cast<const osg::Object*>(obj.getUserData())); 
    os << osgDB::END_BRACKET << std::endl;
    return true;
}

REGISTER_OBJECT_WRAPPER( Object,
                         /*new osg::Object*/NULL,
                         osg::Object,
                         "osg::Object" )
{
    ADD_STRING_SERIALIZER( Name, "" );  // _name
    
    BEGIN_ENUM_SERIALIZER( DataVariance, UNSPECIFIED );
        ADD_ENUM_VALUE( STATIC );
        ADD_ENUM_VALUE( DYNAMIC );
        ADD_ENUM_VALUE( UNSPECIFIED );
    END_ENUM_SERIALIZER();  // _dataVariance

    ADD_USER_SERIALIZER( UserData );  // _userData, deprecated
    
    UPDATE_TO_VERSION( 77 )
    {
        REMOVE_SERIALIZER( UserData );
        ADD_OBJECT_SERIALIZER( UserDataContainer, osg::UserDataContainer, NULL );
    }
}
