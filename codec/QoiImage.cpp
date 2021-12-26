///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    MIT License
//
//    Copyright(c) 2017 René Slijkhuis
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include <atlbase.h>

#include "QoiImage.h"
#include "StreamReader.h"
#include "StreamWriter.h"

#define QOI_NO_STDIO
#define QOI_IMPLEMENTATION
#include "qoi.h"

using namespace std;
using namespace Wic::ImageFormat::Utilities;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region Public methods

QoiImage::QoiImage( ) :
    m_width( 0 ),
    m_height( 0 ),
    m_pixelFormat( QoiPixelFormat::Unknown ),
    m_bytes( NULL )
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QoiImage::~QoiImage( )
{
    if (m_bytes != NULL)
    {
        free( m_bytes );
        m_bytes = NULL;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Read( IStream* pStream )
{
    if ( pStream == nullptr ) return false;

    StreamReader stream( pStream );

    UINT64 streamSize64 = stream.GetSize();
    if (streamSize64 > INT_MAX) return false;

    int streamSize = (int)streamSize64;
    
    std::vector<BYTE> streamData;
    streamData.resize( streamSize );
    if ( !stream.ReadBytes( &streamData[0], streamSize ) ) return false;

    qoi_desc qoiDesc;
    m_bytes = qoi_decode( &streamData[0], streamSize, &qoiDesc, 0 );

    if ( m_bytes == NULL ) return false;

    m_width  = qoiDesc.width;
    m_height = qoiDesc.height;
    m_pixelFormat = ConvertPixelFormat( qoiDesc.channels );

    if (m_pixelFormat == QoiPixelFormat::Unknown) return false;
    
    // TODO(nll) use qoiDesc.colorspace

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Save( IStream* pStream ) const
{
    if ( pStream == nullptr )
    {
        return false;
    }

    if ( ( m_width == 0 ) || ( m_height == 0 ) )
    {
        return false;
    }

    qoi_desc qoiDesc;
    qoiDesc.width = m_width;
    qoiDesc.height = m_height;

    if (m_pixelFormat == QoiPixelFormat::RGB24)
    {
        qoiDesc.channels = 3;
        qoiDesc.colorspace = QOI_SRGB;          // TODO(nll)
    }
    else if (m_pixelFormat == QoiPixelFormat::RGBA32)
    {
        qoiDesc.channels = 4;
        qoiDesc.colorspace = QOI_SRGB;          // TODO(nll)
    }
    else
    {
        return false;
    }

    int encodedLen = 0;
    void* encoded = qoi_encode( m_bytes, &qoiDesc, &encodedLen );
    if ( encoded == NULL )
    {
        return false;
    }

    StreamWriter stream( pStream );

    if (!stream.WriteBytes( encoded, encodedLen ))
    {
        free( encoded );
        return false;
    }

    free( encoded );

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::SetImage( const UINT width,
                          const UINT height,
                          const QoiPixelFormat pixelFormat,
                          const vector<BYTE>& bytes )
{
    if ( ( width == 0 ) || ( height == 0 ) || ( pixelFormat == QoiPixelFormat::Unknown ) )
    {
        return false;
    }

    if ( bytes.size( ) != width * height * GetBytesPerPixel( pixelFormat ) )
    {
        return false;
    }

    m_width = width;
    m_height = height;
    m_pixelFormat = pixelFormat;
    
    if (m_bytes != NULL)
    {
        free( m_bytes );
        m_bytes = NULL;
    }
    if (!bytes.empty())
    {
        m_bytes = malloc( bytes.size() );
        if (m_bytes == NULL) return false;
        memcpy( m_bytes, bytes.data(), bytes.size() );
    }

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void* QoiImage::GetBytes() const
{
    return m_bytes;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UINT QoiImage::GetWidth( ) const
{
    return m_width;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UINT QoiImage::GetHeight( ) const
{
    return m_height;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QoiPixelFormat QoiImage::GetPixelFormat( ) const
{
    return m_pixelFormat;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UINT QoiImage::GetBytesPerPixel( const QoiPixelFormat pixelFormat )
{
    if ( pixelFormat == QoiPixelFormat::Unknown )
    {
        return 0;
    }
    else if ( pixelFormat == QoiPixelFormat::RGB24 )
    {
        return 3;
    }
    else if ( pixelFormat == QoiPixelFormat::RGBA32 )
    {
        return 4;
    }

    return 0;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region Private methods

QoiPixelFormat QoiImage::ConvertPixelFormat( const UINT value ) const
{
    if ( value == (UINT)QoiPixelFormat::RGB24 )
    {
        return QoiPixelFormat::RGB24;
    }
    else if ( value == (UINT)QoiPixelFormat::RGBA32 )
    {
        return QoiPixelFormat::RGBA32;
    }

    return QoiPixelFormat::Unknown;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma endregion

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
