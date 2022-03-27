unit nfe.localservice.dao.process.datainfobuilder;

interface

uses
  System.Classes, System.SysUtils,
  //nfe units
  nfe.localservice.model.process.types,
  nfe.localservice.model.nfeobj,
  nfe.localservice.dao.exceptions.consts;

type
  IProcessDataInfoBuilder = interface
    ['{18DF1A7F-7B15-439C-85BD-7AF3ABC7B67A}']
    function MessageInfo(const Obj: TNFEObject; const ProcessInfo: TProcessDataInfo;
        const RefProduto: string): string;
  end;

  TProcessDataInfoBuilder = class(TInterfacedObject, IProcessDataInfoBuilder)
   protected
    constructor Create;
    function MessageInfo(const Obj: TNFEObject; const ProcessInfo: TProcessDataInfo;
        const RefProduto: string): string;

   public
    class function New: IProcessDataInfoBuilder;
    destructor Destroy; override;
  end;

implementation

{ TProcessDataInfoBuilder }

constructor TProcessDataInfoBuilder.Create;
begin
 inherited Create;
end;

destructor TProcessDataInfoBuilder.Destroy;
begin
  inherited Destroy;
end;

class function TProcessDataInfoBuilder.New: IProcessDataInfoBuilder;
begin
 Result := self.Create;
end;

function TProcessDataInfoBuilder.MessageInfo(const Obj: TNFEObject;
  const ProcessInfo: TProcessDataInfo; const RefProduto: string): string;
begin
 if not Assigned(Obj) then Exit;
 case ProcessInfo of
   diDestinatario: Result := Format(TDAOStatusNfeError.UnknownDest, [Obj.ChaveNfe, Obj.Data.Destinatario.Cnpj]);
   diEmitente:     Result := Format(TDAOStatusNfeError.UnknownEmit, [Obj.ChaveNfe, Obj.Data.Emitente.Cnpj]);
   diFabricante:   Result := Format(TDAOStatusNfeError.UnknownFabr, [Obj.ChaveNfe, Obj.Data.Fabricante.Cnpj]);
   diMunicipio:    Result := Format(TDAOStatusNfeError.UnknownMun,  [Obj.Data.Destinatario.MunCod, Obj.Data.Emitente.MunCod]);
   diPais:         Result := TDAOStatusNfeError.UnknownPais;
   diProduto:      Result := Format(TDAOStatusNfeError.UnknownProd, [RefProduto]);
   diNFe:          Result := Format(TDAOInfoMessages.NewNFe,        [Obj.ChaveNfe]);
 end;
end;



end.
