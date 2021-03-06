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

#include "WicFrameDecode.h"

using namespace std;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

WicFrameDecode::WicFrameDecode( QoiImage* pImage ) :
    m_pImage( pImage ),
    m_width( 0 ),
    m_height( 0 ),
    m_pixelFormat( QoiPixelFormat::Unknown ),
    m_imageData( NULL )
{
    DEBUG_TRACE("WicFrameDecode::WicFrameDecode\n");
    m_width = m_pImage->GetWidth( );
    m_height = m_pImage->GetHeight( );
    m_pixelFormat = m_pImage->GetPixelFormat( );
    m_imageData = m_pImage->GetBytes();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

WicFrameDecode::~WicFrameDecode( )
{
    DEBUG_TRACE("WicFrameDecode::~WicFrameDecode\n");
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::CreateFromStream( IStream* pIStream, ComPtr<WicFrameDecode>* ppFrame, UINT index )
{
    DEBUG_TRACE("WicFrameDecode::CreateFromStream\n");
    if ( pIStream == nullptr )
    {
        return E_INVALIDARG;
    }

    DEBUG_TRACE("    std::auto_ptr<QoiImage> pImage( new QoiImage )\n");
    std::auto_ptr<QoiImage> pImage( new QoiImage );
    if ( pImage.get( ) == nullptr )
    {
        return E_OUTOFMEMORY;
    }

    DEBUG_TRACE("    pImage->Read( pIStream )\n");
    if ( !pImage->Read( pIStream ) )
    {
        return E_FAIL;
    }

    ComPtr<WicFrameDecode> output;
    (*ppFrame).reset( nullptr );

    output.reset( new WicFrameDecode( pImage.release( ) ) );
    if ( output.Ptr( ) == nullptr )
    {
        return E_OUTOFMEMORY;
    }

    (*ppFrame).reset( output.AddRef( ) );

    return S_OK;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region RawImageLib

UINT WicFrameDecode::GetFrameCount( )
{
    return 1;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region IUnknown

HRESULT WicFrameDecode::QueryInterface( REFIID riid, void** ppObject )
{
    if ( ppObject == nullptr )
    {
        return E_INVALIDARG;
    }

    *ppObject = nullptr;

    if ( IsEqualGUID( riid, IID_IWICBitmapFrameDecode ) )
    {
        this->AddRef( );
        *ppObject = static_cast<IWICBitmapFrameDecode*>( this );
    }
    else if ( ( IsEqualGUID( riid, IID_IWICBitmapSource ) ) ||
              ( IsEqualGUID( riid, IID_IUnknown ) ) )
    {
        this->AddRef( );
        *ppObject = static_cast<IWICBitmapSource*>( this );
    }
    else
    {
        return E_NOINTERFACE;
    }

    return S_OK;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region IWICBitmapSource_required

HRESULT WicFrameDecode::GetSize( UINT* pWidth, UINT* pHeight )
{
    if ( pWidth == nullptr || pHeight == nullptr )
    {
        return E_INVALIDARG;
    }

    *pWidth = m_width;
    *pHeight = m_height;

    return S_OK;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::GetPixelFormat( WICPixelFormatGUID* pPixelFormat )
{
    if ( pPixelFormat == nullptr )
    {
        return E_INVALIDARG;
    }

    if ( m_pixelFormat == QoiPixelFormat::RGB24 )
    {
        *pPixelFormat = GUID_WICPixelFormat24bppRGB;
    }
    else if ( m_pixelFormat == QoiPixelFormat::RGBA32 )
    {
        *pPixelFormat = GUID_WICPixelFormat32bppRGBA;
    }
    else
    {
        return E_FAIL;
    }

    return S_OK;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::GetResolution(double* pDpiX, double* pDpiY )
{
    if ( pDpiX == nullptr || pDpiY == nullptr )
    {
        return E_INVALIDARG;
    }

    *pDpiX = 96;
    *pDpiY = 96;

    return S_OK;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::CopyPixels( const WICRect* pRc, UINT stride, UINT bufferSize, BYTE* pBuffer )
{
    if ( pBuffer == nullptr )
    {
        return E_INVALIDARG;
    }

    WICRect rect = { 0, 0, static_cast<int>( m_width ), static_cast<int>( m_height ) };

    // pRc specifies the rectangle to copy. A NULL value specifies the entire bitmap.
    if ( pRc != nullptr )
    {
        rect = *pRc;
    }

    if ( ( rect.Width < 0 ) || ( rect.Height < 0 ) || ( rect.X < 0 ) || ( rect.Y < 0 ) )
    {
        return E_INVALIDARG;
    }

    if ( ( ( rect.X + rect.Width ) > static_cast<int>( m_width ) ) ||
         ( ( rect.Y + rect.Height ) > static_cast<int>( m_height ) ) )
    {
        return E_INVALIDARG;
    }

    if ( ( bufferSize / stride ) < static_cast<UINT>( rect.Height ) )
    {
        return WINCODEC_ERR_INSUFFICIENTBUFFER;
    }

    int bytesPerPixel = QoiImage::GetBytesPerPixel( m_pixelFormat );
    if ( bytesPerPixel == 0 )
    {
        return WINCODEC_ERR_INTERNALERROR;
    }

    int x = rect.X;
    int strideSrc  = m_width * bytesPerPixel;
    int strideDest = rect.Width * bytesPerPixel;

    int i = 0;
    for ( int y = rect.Y ; y < ( rect.Y + rect.Height ) ; y++ )
    {
        BYTE* pLine = ((BYTE*)m_imageData) + ( ( y * strideSrc ) + ( x * bytesPerPixel ) );
        memcpy( pBuffer + ( i * stride ), pLine, strideDest );
        i++;
    }

    return S_OK;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region IWICBitmapSource_optional

HRESULT WicFrameDecode::CopyPalette( IWICPalette* /*pIPalette*/ )
{
    return WINCODEC_ERR_PALETTEUNAVAILABLE;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region IWICBitmapFrameDecode

HRESULT WicFrameDecode::GetThumbnail( IWICBitmapSource** /*ppIThumbnail*/ )
{
    return WINCODEC_ERR_CODECNOTHUMBNAIL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::GetColorContexts( UINT /*cCount*/, IWICColorContext** /*ppIColorContexts*/, UINT* /*pcActualCount*/ )
{
    return WINCODEC_ERR_UNSUPPORTEDOPERATION;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

HRESULT WicFrameDecode::GetMetadataQueryReader( IWICMetadataQueryReader** /*ppIMetadataQueryReader*/ )
{
    return WINCODEC_ERR_UNSUPPORTEDOPERATION;
}

#pragma endregion
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////