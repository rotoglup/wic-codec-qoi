///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//    MIT License
//
//    Copyright(c) 2017 Ren� Slijkhuis
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

using namespace std;
using namespace Wic::ImageFormat::Utilities;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region Public methods

QoiImage::QoiImage( ) :
    m_width( 0 ),
    m_height( 0 ),
    m_pixelFormat( QoiPixelFormat::Unknown )
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

QoiImage::~QoiImage( )
{
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Read( const wstring& filename )
{
    CComPtr<IStream> pIStream;
    HRESULT hr = SHCreateStreamOnFileEx( filename.c_str( ), STGM_READ, FILE_ATTRIBUTE_NORMAL, FALSE, NULL, &pIStream );
    if ( ( FAILED( hr ) ) || ( pIStream == nullptr ) )
    {
        return false;
    }

    return Read( pIStream );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Read( IStream* pStream )
{
    if ( pStream == nullptr ) return false;

    StreamReader stream( pStream );

    if ( !stream.SetPosition( 21 ) ) return false;

    UINT version;
    if ( !stream.ReadUInt32( version ) ) return false;
    if ( version != 1 ) return false;

    if ( !stream.ReadUInt32( m_width ) ) return false;
    if ( !stream.ReadUInt32( m_height ) ) return false;

    UINT value;
    if ( !stream.ReadUInt32( value ) ) return false;
    m_pixelFormat = ConvertPixelFormat( value );
    if ( m_pixelFormat == QoiPixelFormat::Unknown ) return false;

    UINT offset = 0;
    if ( !stream.ReadUInt32( offset ) ) return false;
    if ( !stream.SetPosition( offset ) ) return false;

    UINT size = m_width * m_height * GetBytesPerPixel( m_pixelFormat );
    if ( stream.GetSize( ) < ( offset + size ) ) return false;

    m_bytes.resize( size );
    if ( !stream.ReadBytes( m_bytes.data( ), size ) ) return false;

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Save( const std::wstring& filename ) const
{
    CComPtr<IStream> pIStream;
    HRESULT hr = SHCreateStreamOnFileEx( filename.c_str( ), STGM_WRITE | STGM_CREATE, FILE_ATTRIBUTE_NORMAL, TRUE, NULL, &pIStream );
    if ( ( FAILED( hr ) ) || ( pIStream == nullptr ) )
    {
        return false;
    }

    return Save( pIStream );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

bool QoiImage::Save( IStream* pStream ) const
{
    if ( pStream == nullptr )
    {
        return false;
    }

    if ( ( m_width == 0 ) || ( m_height == 0 ) || ( m_pixelFormat == QoiPixelFormat::Unknown ) )
    {
        return false;
    }

    StreamWriter stream( pStream );

    vector<BYTE> id1 = { 'L', 'I', 'S', 'A', '\0' };
    if ( !stream.WriteBytes( id1 ) ) return false;

    vector<BYTE> id2 = { 0x17, 0x26, 0x71, 0xF7, 0x9E, 0xCC, 0x43, 0x4B, 0xBC, 0x7A, 0x8F, 0x21, 0x5D, 0x77, 0xDE, 0x35 };
    if ( !stream.WriteBytes( id2 ) ) return false;

    if ( !stream.WriteUInt32( 1 ) ) return false; // Write the version number of the image format specification.
    if ( !stream.WriteUInt32( m_width ) ) return false;
    if ( !stream.WriteUInt32( m_height ) ) return false;
    if ( !stream.WriteUInt32( ConvertPixelFormat( m_pixelFormat ) ) ) return false;
    if ( !stream.WriteUInt32( 48 ) ) return false; // Offset

    vector<BYTE> empty( 7, 0x00 );
    if ( !stream.WriteBytes( empty ) ) return false;
    if ( !stream.WriteBytes( m_bytes ) ) return false;

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
    m_bytes = bytes;

    return true;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void QoiImage::GetBytes( vector<BYTE>& bytes ) const
{
    bytes = m_bytes;
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
    else if ( pixelFormat == QoiPixelFormat::UInt8 )
    {
        return 1;
    }
    else if ( pixelFormat == QoiPixelFormat::RGB24 )
    {
        return 3;
    }

    throw invalid_argument( "Unknown QoiPixelFormat" );
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region Private methods

QoiPixelFormat QoiImage::ConvertPixelFormat( const UINT value ) const
{
    if ( value == 0 )
    {
        return QoiPixelFormat::UInt8;
    }
    else if ( value == 1 )
    {
        return QoiPixelFormat::RGB24;
    }

    return QoiPixelFormat::Unknown;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

UINT QoiImage::ConvertPixelFormat( const QoiPixelFormat pixelFormat ) const
{
    if ( pixelFormat == QoiPixelFormat::Unknown )
    {
        throw invalid_argument( "Invalid argument" );
    }
    else if ( pixelFormat == QoiPixelFormat::UInt8 )
    {
        return 0;
    }
    else if ( pixelFormat == QoiPixelFormat::RGB24 )
    {
        return 1;
    }

    throw invalid_argument( "Unknown QoiPixelFormat" );
}

#pragma endregion

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
