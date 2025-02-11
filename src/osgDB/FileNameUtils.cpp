/* -*-c++-*- OpenSceneGraph - Copyright (C) 1998-2006 Robert Osfield 
 *
 * This library is open source and may be redistributed and/or modified under  
 * the terms of the OpenSceneGraph Public License (OSGPL) version 0.0 or 
 * (at your option) any later version.  The full license is in LICENSE file
 * included with this distribution, and on the openscenegraph.org website.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
 * OpenSceneGraph Public License for more details.
*/
#include <stdlib.h>
#include <string.h>
#include <limits.h>

#include <osgDB/FileNameUtils>
#include <osgDB/FileUtils>

#ifdef WIN32
    #define _WIN32_WINNT 0x0500
    #include <windows.h>
#endif

#if defined(__sgi)
    #include <ctype.h>
#elif defined(__GNUC__) || !defined(WIN32) || defined(__MWERKS__)
    #include <cctype>
    using std::tolower;
#endif

using namespace std;

std::string osgDB::getFilePath(const std::string& fileName)
{
    std::string::size_type slash = fileName.find_last_of("/\\");
    if (slash==std::string::npos) return std::string();
    else return std::string(fileName, 0, slash);
}


std::string osgDB::getSimpleFileName(const std::string& fileName)
{
    std::string::size_type slash = fileName.find_last_of("/\\");
    if (slash==std::string::npos) return fileName;
    else return std::string(fileName.begin()+slash+1,fileName.end());
}


std::string osgDB::getFileExtension(const std::string& fileName)
{
    std::string::size_type dot = fileName.find_last_of('.');
    std::string::size_type slash = fileName.find_last_of("/\\");
    if (dot==std::string::npos || (slash!=std::string::npos && dot<slash)) return std::string("");
    return std::string(fileName.begin()+dot+1,fileName.end());
}

std::string osgDB::getFileExtensionIncludingDot(const std::string& fileName)
{
    std::string::size_type dot = fileName.find_last_of('.');
    std::string::size_type slash = fileName.find_last_of("/\\");
    if (dot==std::string::npos || (slash!=std::string::npos && dot<slash)) return std::string("");
    return std::string(fileName.begin()+dot,fileName.end());
}

std::string osgDB::convertFileNameToWindowsStyle(const std::string& fileName)
{
    std::string new_fileName(fileName);
    
    std::string::size_type slash = 0;
    while( (slash=new_fileName.find_first_of(UNIX_PATH_SEPARATOR,slash)) != std::string::npos)
    {
        new_fileName[slash]=WINDOWS_PATH_SEPARATOR;
    }
    return new_fileName;
}

std::string osgDB::convertFileNameToUnixStyle(const std::string& fileName)
{
    std::string new_fileName(fileName);
    
    std::string::size_type slash = 0;
    while( (slash=new_fileName.find_first_of(WINDOWS_PATH_SEPARATOR,slash)) != std::string::npos)
    {
        new_fileName[slash]=UNIX_PATH_SEPARATOR;
    }

    return new_fileName;
}

char osgDB::getNativePathSeparator()
{
#if defined(WIN32) && !defined(__CYGWIN__)
    return WINDOWS_PATH_SEPARATOR;
#else
    return UNIX_PATH_SEPARATOR;
#endif
}

bool osgDB::isFileNameNativeStyle(const std::string& fileName)
{
#if defined(WIN32) && !defined(__CYGWIN__)
    return fileName.find(UNIX_PATH_SEPARATOR) == std::string::npos; // return true if no unix style slash exist
#else
    return fileName.find(WINDOWS_PATH_SEPARATOR) == std::string::npos; // return true if no windows style backslash exist
#endif
}

std::string osgDB::convertFileNameToNativeStyle(const std::string& fileName)
{
#if defined(WIN32) && !defined(__CYGWIN__)
    return convertFileNameToWindowsStyle(fileName);
#else
    return convertFileNameToUnixStyle(fileName);
#endif
}



std::string osgDB::getLowerCaseFileExtension(const std::string& filename)
{
    return convertToLowerCase(osgDB::getFileExtension(filename));
}

std::string osgDB::convertToLowerCase(const std::string& str)
{
    std::string lowcase_str(str);
    for(std::string::iterator itr=lowcase_str.begin();
        itr!=lowcase_str.end();
        ++itr)
    {
        *itr = tolower(*itr);
    }
    return lowcase_str;
}

// strip one level of extension from the filename.
std::string osgDB::getNameLessExtension(const std::string& fileName)
{
    std::string::size_type dot = fileName.find_last_of('.');
    std::string::size_type slash = fileName.find_last_of("/\\");        // Finds forward slash *or* back slash
    if (dot==std::string::npos || (slash!=std::string::npos && dot<slash)) return fileName;
    return std::string(fileName.begin(),fileName.begin()+dot);
}


// strip all extensions from the filename.
std::string osgDB::getNameLessAllExtensions(const std::string& fileName)
{
    // Finds start serach position: from last slash, or the begining of the string if none found
    std::string::size_type startPos = fileName.find_last_of("/\\");            // Finds forward slash *or* back slash
    if (startPos == std::string::npos) startPos = 0;
    std::string::size_type dot = fileName.find_first_of('.', startPos);        // Finds *FIRST* dot from start pos
    if (dot==std::string::npos) return fileName;
    return std::string(fileName.begin(),fileName.begin()+dot);
}

std::string osgDB::getStrippedName(const std::string& fileName)
{
    std::string simpleName = getSimpleFileName(fileName);
    return getNameLessExtension( simpleName );
}


bool osgDB::equalCaseInsensitive(const std::string& lhs,const std::string& rhs)
{
    if (lhs.size()!=rhs.size()) return false;
    std::string::const_iterator litr = lhs.begin();
    std::string::const_iterator ritr = rhs.begin();
    while (litr!=lhs.end())
    {
        if (tolower(*litr)!=tolower(*ritr)) return false;
        ++litr;
        ++ritr;
    }
    return true;
}

bool osgDB::equalCaseInsensitive(const std::string& lhs,const char* rhs)
{
    if (rhs==NULL || lhs.size()!=strlen(rhs)) return false;
    std::string::const_iterator litr = lhs.begin();
    const char* cptr = rhs;
    while (litr!=lhs.end())
    {
        if (tolower(*litr)!=tolower(*cptr)) return false;
        ++litr;
        ++cptr;
    }
    return true;
}



bool osgDB::containsServerAddress(const std::string& filename)
{
    // need to check for ://
    std::string::size_type pos(filename.find("://"));
    if (pos == std::string::npos) 
        return false;
    std::string proto(filename.substr(0, pos));
    
    return Registry::instance()->isProtocolRegistered(proto);
}

std::string osgDB::getServerProtocol(const std::string& filename)
{
    std::string::size_type pos(filename.find("://"));
    if (pos != std::string::npos)
        return filename.substr(0,pos);

    return "";
}

std::string osgDB::getServerAddress(const std::string& filename)
{
    std::string::size_type pos(filename.find("://"));
    
    if (pos != std::string::npos)
    {
        std::string::size_type pos_slash = filename.find_first_of('/',pos+3);
        if (pos_slash!=std::string::npos)
        {
            return filename.substr(pos+3,pos_slash-pos-3);
        }
        else
        {
            return filename.substr(pos+3,std::string::npos);
        }
    }
    return "";
}

std::string osgDB::getServerFileName(const std::string& filename)
{
    std::string::size_type pos(filename.find("://"));

    if (pos != std::string::npos)
    {
        std::string::size_type pos_slash = filename.find_first_of('/',pos+3);
        if (pos_slash!=std::string::npos)
        {
            return filename.substr(pos_slash+1,std::string::npos);
        }
        else
        {
            return "";
        }
    
    }
    return filename;
}

std::string osgDB::concatPaths(const std::string& left, const std::string& right)
{
#if defined(WIN32) && !defined(__CYGWIN__)
    const char delimiterNative  = WINDOWS_PATH_SEPARATOR;
    const char delimiterForeign = UNIX_PATH_SEPARATOR;
#else
    const char delimiterNative  = UNIX_PATH_SEPARATOR;
    const char delimiterForeign = WINDOWS_PATH_SEPARATOR;
#endif

    if(left.empty())
    {
        return(right);
    }
    char lastChar = left[left.size() - 1];

    if(lastChar == delimiterNative)
    {
        return left + right;
    }
    else if(lastChar == delimiterForeign)
    {
        return left.substr(0, left.size() - 1) + delimiterNative + right;
    }
    else // lastChar != a delimiter
    {
        return left + delimiterNative + right;
    }
}

std::string osgDB::getRealPath(const std::string& path)
{
#if defined(WIN32)  && !defined(__CYGWIN__)
    // Not unicode compatible should give an error if UNICODE defined
    char retbuf[MAX_PATH + 1];
    char tempbuf1[MAX_PATH + 1];
    GetFullPathName(path.c_str(), sizeof(retbuf), retbuf, NULL);
    // Force drive letter to upper case
    if ((retbuf[1] == ':') && islower(retbuf[0]))
        retbuf[0] = _toupper(retbuf[0]);
    if (fileExists(std::string(retbuf)))
    {
        // Canonicalise the full path
        GetShortPathName(retbuf, tempbuf1, sizeof(tempbuf1));
        GetLongPathName(tempbuf1, retbuf, sizeof(retbuf));
        return std::string(retbuf);
    }
    else
    {
        // Canonicalise the directories
        std::string FilePath = getFilePath(retbuf);
        char tempbuf2[MAX_PATH + 1];
        if (0 == GetShortPathName(FilePath.c_str(), tempbuf1, sizeof(tempbuf1)))
            return std::string(retbuf);
        if (0 == GetLongPathName(tempbuf1, tempbuf2, sizeof(tempbuf2)))
            return std::string(retbuf);
        FilePath = std::string(tempbuf2);
        FilePath += WINDOWS_PATH_SEPARATOR;
        FilePath.append(getSimpleFileName(std::string(retbuf)));
        return FilePath;
    }
#else
    char resolved_path[PATH_MAX];
    char* result = realpath(path.c_str(), resolved_path);
    
    if (result) return std::string(resolved_path);
    else return path;
#endif 
}
