#ifndef OSGDB_ASCIISTREAMOPERATOR
#define OSGDB_ASCIISTREAMOPERATOR

#include <osgDB/StreamOperator>

class AsciiOutputIterator : public osgDB::OutputIterator
{
public:
    AsciiOutputIterator( std::ostream* ostream )
    : _readyForIndent(false), _indent(0) { _out = ostream; }
    
    virtual ~AsciiOutputIterator() {}
    
    virtual bool isBinary() const { return false; }
    
    virtual void writeBool( bool b )
    {
        indentIfRequired();
        if ( b ) *_out << "TRUE ";
        else *_out << "FALSE ";
    }
    
    virtual void writeChar( char c )
    { indentIfRequired(); *_out << (short)c << ' '; }
    
    virtual void writeUChar( unsigned char c )
    { indentIfRequired(); *_out << (unsigned short)c << ' '; }
    
    virtual void writeShort( short s )
    { indentIfRequired(); *_out << s << ' '; }
    
    virtual void writeUShort( unsigned short s )
    { indentIfRequired(); *_out << s << ' '; }
    
    virtual void writeInt( int i )
    { indentIfRequired(); *_out << i << ' '; }
    
    virtual void writeUInt( unsigned int i )
    { indentIfRequired(); *_out << i << ' '; }
    
    virtual void writeLong( long l )
    { indentIfRequired(); *_out << l << ' '; }
    
    virtual void writeULong( unsigned long l )
    { indentIfRequired(); *_out << l << ' '; }
    
    virtual void writeFloat( float f )
    { indentIfRequired(); *_out << f << ' '; }
    
    virtual void writeDouble( double d )
    { indentIfRequired(); *_out << d << ' '; }
    
    virtual void writeString( const std::string& s )
    { indentIfRequired(); *_out << s << ' '; }
    
    virtual void writeStream( std::ostream& (*fn)(std::ostream&) )
    {
        indentIfRequired(); *_out << fn;
        if ( fn==static_cast<std::ostream& (*)(std::ostream&)>(std::endl) )
        {
            _readyForIndent = true;
        }
    }
    
    virtual void writeBase( std::ios_base& (*fn)(std::ios_base&) )
    {
        indentIfRequired(); *_out << fn;
    }
    
    virtual void writeGLenum( const osgDB::ObjectGLenum& value )
    {
        GLenum e = value.get(); 
        const std::string& enumString = osgDB::Registry::instance()->getObjectWrapperManager()->getString("GL", e);
        indentIfRequired(); *_out << enumString << ' ';
    }
    
    virtual void writeProperty( const osgDB::ObjectProperty& prop )
    {
        std::string enumString = prop._name;
        if ( prop._mapProperty )
        {
            enumString = osgDB::Registry::instance()->getObjectWrapperManager()->getString(prop._name, prop._value);
        }
        indentIfRequired(); *_out << enumString << ' ';
    }
    
    virtual void writeMark( const osgDB::ObjectMark& mark )
    {
        _indent += mark._indentDelta;
        indentIfRequired(); *_out << mark._name;
    }
    
    virtual void writeCharArray( const char* s, unsigned int size ) {}
    
    virtual void writeWrappedString( const std::string& str )
    {
        std::string wrappedStr;
        unsigned int size = str.size();
        for ( unsigned int i=0; i<size; ++i )
        {
            char ch = str[i];
            if ( ch=='\"' ) wrappedStr += '\\';
            else if ( ch=='\\' ) wrappedStr += '\\';
            wrappedStr += ch;
        }
        
        wrappedStr.insert( 0, 1, '\"' );
        wrappedStr += '\"';

        indentIfRequired();
        writeString( wrappedStr );
    }
    
protected:

    inline void indentIfRequired()
    {
        if ( _readyForIndent )
        {
            for (int i=0; i<_indent; ++i)
                *_out << ' ';
            _readyForIndent = false;
        }
    }
    
    bool _readyForIndent;
    int _indent;
};

class AsciiInputIterator : public osgDB::InputIterator
{
public:
    AsciiInputIterator( std::istream* istream ) { _in = istream; }
    virtual ~AsciiInputIterator() {}
    
    virtual bool isBinary() const { return false; }
    
    virtual void readBool( bool& b )
    {
        std::string boolString;
        *_in >> boolString;
        if ( boolString=="TRUE" ) b = true;
        else b = false;
    }
    
    virtual void readChar( char& c )
    {
        short s = 0;
        *_in >> s;
        c = (char)s;
    }
    
    virtual void readSChar( signed char& c )
    {
        short s = 0;
        *_in >> s;
        c = (signed char)s;
    }
    
    virtual void readUChar( unsigned char& c )
    {
        short s = 0;
        *_in >> s;
        c = (unsigned char)s;
    }
    
    virtual void readShort( short& s )
    { *_in >> s; }
    
    virtual void readUShort( unsigned short& s )
    { *_in >> s; }
    
    virtual void readInt( int& i )
    { *_in >> i; }
    
    virtual void readUInt( unsigned int& i )
    { *_in >> i; }
    
    virtual void readLong( long& l )
    { *_in >> l; }
    
    virtual void readULong( unsigned long& l )
    { *_in >> l; }
    
    virtual void readFloat( float& f )
    { *_in >> f; }
    
    virtual void readDouble( double& d )
    { *_in >> d; }
    
    virtual void readString( std::string& s )
    { *_in >> s; }
    
    virtual void readStream( std::istream& (*fn)(std::istream&) )
    { *_in >> fn; }
    
    virtual void readBase( std::ios_base& (*fn)(std::ios_base&) )
    { *_in >> fn; }
    
    virtual void readGLenum( osgDB::ObjectGLenum& value )
    {
        GLenum e = 0;
        std::string enumString;
        *_in >> enumString;
        e = osgDB::Registry::instance()->getObjectWrapperManager()->getValue("GL", enumString);
        value.set( e );
    }
    
    virtual void readProperty( osgDB::ObjectProperty& prop )
    {
        int value = 0;
        std::string enumString;
        *_in >> enumString;
        if ( prop._mapProperty )
        {
            value = osgDB::Registry::instance()->getObjectWrapperManager()->getValue(prop._name, enumString);
        }
        else
        {
            if ( prop._name!=enumString )
            {
                OSG_WARN << "AsciiInputIterator::readProperty(): Unmatched property "
                                       << enumString << ", expecting " << prop._name << std::endl;
            }
            prop._name = enumString;
        }
        prop.set( value );
    }
    
    virtual void readMark( osgDB::ObjectMark& mark )
    {
        std::string markString;
        *_in >> markString;
    }
    
    virtual void readCharArray( char* s, unsigned int size ) {}
    
    virtual void readWrappedString( std::string& str )
    {
        char ch;
        _in->get( ch ); checkStream();

        // skip white space
        while ( ch==' ' || (ch=='\n') || (ch=='\r'))
        {
            _in->get( ch ); checkStream();
        }

        if (ch=='"')
        {
            // we have an "wrapped string"
            _in->get( ch ); checkStream();
            while ( ch!='"' )
            {
                if (ch=='\\')
                {
                    _in->get( ch ); checkStream();
                    str += ch;
                }
                else str += ch;

                _in->get( ch ); checkStream();
            }
        }
        else
        {
            // we have an unwrapped string, read to first space or end of line
            while ( (ch!=' ') && (ch!=0) && (ch!='\n') )
            {
                str += ch;
                _in->get( ch ); checkStream();
            }
        }
    }

    virtual bool matchString( const std::string& str )
    {
        std::string s; readString(s);
        if ( s==str ) return true;
        else _in->seekg( -(int)(s.length()), std::ios::cur );
        return false;
    }
    
    virtual void advanceToCurrentEndBracket()
    {
        std::string passString;
        unsigned int blocks = 0;
        while ( !_in->eof() )
        {
            passString.clear();
            readString( passString );
            
            if ( passString=="}" )
            {
                if ( blocks<=0 ) return;
                else blocks--;
            }
            else if ( passString=="{" )
                blocks++;
        }
    }
};

#endif
