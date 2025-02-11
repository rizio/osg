/* -*-c++-*- OpenSceneGraph - Copyright (C) 2009-2010 Mathias Froehlich
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
#include <osgQt/QFontImplementation>

#include <osgDB/FileNameUtils>
#include <osgDB/Registry>
#include <osgText/Font>

#include <QtGui/QFont>
#include <QtGui/QFontMetrics>
#include <QtGui/QImage>
#include <QtGui/QPainter>

namespace osgQt {

QFontImplementation::QFontImplementation(const QFont& font) :
   _filename(font.toString().toStdString() + ".qfont"),
   _font(font)
{
   _currentRes.first = 0;
   _currentRes.second = 0;
}

QFontImplementation::~QFontImplementation()
{
}

std::string
QFontImplementation::getFileName() const
{
    return _filename;
}

void
QFontImplementation::setFontResolution(const osgText::FontResolution& fontSize)
{
    if (fontSize == _currentRes)
        return;

    _currentRes = fontSize;
    _font.setPixelSize(fontSize.second);
}

osgText::Glyph*
QFontImplementation::getGlyph(const osgText::FontResolution& fontRes, unsigned int charcode)
{
    setFontResolution(fontRes);

    QFontMetrics fontMetrics(_font);
    QFontMetricsF fontMetricsF(_font);

    QRect rect = fontMetrics.boundingRect(QChar(charcode));
    QRectF rectF = fontMetricsF.boundingRect(QChar(charcode));

    int margin = 1;

    int imageWidth = rect.width() + 2*margin;
    int imageHeight = rect.height() + 2*margin;

    // Now paint the glyph into the image
    QImage image(imageWidth, imageHeight, QImage::Format_ARGB32);
    image.fill(0);
    QPainter painter(&image);
    painter.setRenderHint(QPainter::TextAntialiasing);

    painter.setFont(_font);

    painter.setBackgroundMode(Qt::TransparentMode);
    painter.setBrush(Qt::white);
    painter.setPen(Qt::white);

    painter.drawText(margin - rect.left(), imageHeight - 1 - (margin + rect.bottom()), QString(QChar(charcode)));
    painter.end();

    // Transfer the rendered image to osg
    osg::ref_ptr<osgText::Glyph> glyph = new osgText::Glyph(_facade, charcode);

    unsigned int dataSize = imageWidth*imageHeight;
    unsigned char* data = new unsigned char[dataSize];

    // copy the qimage into the texture memory
    for (int x = 0; x < imageWidth; ++x)
    {
        for (int y = 0; y < imageHeight; ++y)
        {
           data[x + y*imageWidth] = qAlpha(image.pixel(x, imageHeight - 1 - y));
        }
    }
    
    // the glyph texture in osg
    glyph->setImage(imageWidth, imageHeight, 1,
                    GL_ALPHA,
                    GL_ALPHA, GL_UNSIGNED_BYTE,
                    data,
                    osg::Image::USE_NEW_DELETE,
                    1);
    glyph->setInternalTextureFormat(GL_ALPHA);

    // Layout parameters
    float leftBearing = fontMetricsF.leftBearing(QChar(charcode));
    float rightBearing = fontMetricsF.rightBearing(QChar(charcode));

    // for horizonal layout
    osg::Vec2 bottomLeft(leftBearing - margin, - rectF.bottom() - margin);
    glyph->setHorizontalBearing(bottomLeft);
    glyph->setHorizontalAdvance(fontMetricsF.width(QChar(charcode)));

    // for vertical layout
    osg::Vec2 topMiddle(- margin + 0.5*(leftBearing - rect.width() - rightBearing),
                        rectF.top() - margin);
    glyph->setVerticalBearing(topMiddle);
    glyph->setVerticalAdvance(rectF.height() + fontMetricsF.overlinePos() - fontMetricsF.xHeight());
    
    // ... ready
    addGlyph(fontRes, charcode, glyph.get());
    
    return glyph.release();
}

osg::Vec2
QFontImplementation::getKerning(unsigned int leftcharcode, unsigned int rightcharcode, osgText::KerningType kerningType)
{
    return osg::Vec2(0, 0);
}

bool
QFontImplementation::hasVertical() const
{
    return true;
}

}
