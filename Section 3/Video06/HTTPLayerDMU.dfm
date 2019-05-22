object HTTPDM: THTTPDM
  OldCreateOrder = False
  Height = 154
  Width = 211
  object HTTPClient: TNetHTTPClient
    AllowCookies = True
    HandleRedirects = True
    UserAgent = 'Embarcadero URI Client/1.0'
    OnValidateServerCertificate = HTTPClientValidateServerCertificate
    OnReceiveData = HTTPClientReceiveData
    Left = 64
    Top = 62
  end
end
