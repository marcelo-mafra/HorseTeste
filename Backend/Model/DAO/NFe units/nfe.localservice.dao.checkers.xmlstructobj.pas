unit nfe.localservice.dao.checkers.xmlstructobj;

interface

uses
  Winapi.Windows, System.Classes,
  //nfe units
  nfe.localservice.model.nfeobj.xmlmapper,
  nfe.localservice.dao.checkers.customobj,
  nfe.localservice.dao.checkers.interfaces, 
  nfe.localservice.dao.process.events,
  nfe.localservice.model.nfeobj.interfaces;

type
  TDAOCheckXMLStructure = class(TDAOCustomChecker, IDAOCheckXMLStructure)
    private
      FXmlContent: string;
      function GetXmlMapper: INFEModelXmlMapper;

    protected
      constructor Create(const XmlContent: string; OnCheckerExecute: TOnCheckerExecuteEvent); reintroduce;
      function IsValidXML(var ErrorMsg: string): boolean;
      function XmlIsEmpty: boolean;
    public
      destructor Destroy; override;
      class function New(const XmlContent: string; OnCheckerExecute: TOnCheckerExecuteEvent): IDAOCheckXMLStructure;
      //eventos
      property OnCheckerExecute;
      property XmlMapper: INFeModelXmlMapper read GetXmlMapper;

  end;

implementation

{ TCheckXMLStructure }

constructor TDAOCheckXMLStructure.Create(const XmlContent: string;
    OnCheckerExecute: TOnCheckerExecuteEvent);
begin
 inherited Create(OnCheckerExecute);
 FXmlContent := XmlContent;
end;

destructor TDAOCheckXMLStructure.Destroy;
begin
  inherited Destroy;
end;

function TDAOCheckXMLStructure.GetXmlMapper: INFEModelXmlMapper;
begin
 Result := TNFEObjectModelXmlMapper.New;
end;

class function TDAOCheckXMLStructure.New(const XmlContent: string;
  OnCheckerExecute: TOnCheckerExecuteEvent): IDAOCheckXMLStructure;
begin
  Result := self.Create(XmlContent, OnCheckerExecute);
end;

function TDAOCheckXMLStructure.IsValidXML(
  var ErrorMsg: string): boolean;
begin
   //Valida se o xml possui um schemma íntegro
 Result := XmlMapper.IsValidXML(FXmlContent, ErrorMsg);
 if Assigned(OnCheckerExecute) then OnCheckerExecute(self, nil, Result);
end;

function TDAOCheckXMLStructure.XmlIsEmpty: boolean;
begin
  //Retorna se o xml é uma string vazia
 Result := XmlMapper.XmlIsEmpty(FXmlContent);
 if Assigned(OnCheckerExecute) then OnCheckerExecute(self, nil, Result);
end;

end.
