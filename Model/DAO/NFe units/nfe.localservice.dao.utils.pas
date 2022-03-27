unit nfe.localservice.dao.utils;

interface

uses
 Winapi.Windows, System.Classes, System.SysUtils,
 //nfe untis...
 nfe.localservice.model.nfeobj.types,
 nfe.localservice.model.nfeobj,
 nfe.localservice.dao.sqlconsts;

type
  //Classe utilitária para retornar valores de ambiente usados em comandos
  TSQLUtils = class
   public
    class function CurrentSQLDateTime(const Quoted: boolean = True): string ;
    class function GenerateChars(Obj: TNFEObject): TFormatedChars; 
  end;

implementation

{ TSQLUtils }

class function TSQLUtils.CurrentSQLDateTime(const Quoted: boolean): string;
const
 sSQLFormat = 'yyyy/mm/dd hh:nn:ss'; //do not localize!
begin
 Result := FormatDateTime(sSQLFormat, Now);
 if Quoted then Result := QuotedStr(Result);
 
end;

class function TSQLUtils.GenerateChars(Obj: TNFEObject): TFormatedChars;
begin
 Result.ProcessedMark := QuotedStr(TSQLChars.ProcessedMark);
 case Obj.Status of
   snCompleted:     Result.StatusNFe := TNFEIStatus.Completed;
   snSummarized:    Result.StatusNFe := TNFEIStatus.Summarized;
   snIndetermined:  Result.StatusNFe := TNFEIStatus.Indetermined;
 end;
 //override de TFormatedChars.StatusNFe conforme resultado do mapeamento O.R.
 case Obj.MapperStatus of
   msNormalMapping: Exit; //irrelevante, nesse contexto
   msBrokenXmlMapping:
    begin
     Result.StatusNFe     := TNFEIStatus.Pending;
     Result.PendencieMark := TNFEIPendencieMark.InvalidXml;
    end;
   msIncompleteDbMapping:
    begin
     Result.StatusNFe := TNFEIStatus.Pending;
     Result.PendencieMark := TNFEIPendencieMark.IncompletedMapping;
    end;
   msFatalFailureOnMapping:
    begin
     Result.StatusNFe := TNFEIStatus.Pending;
     Result.PendencieMark := TNFEIPendencieMark.EndedFatalFailure;
    end;
 end;

end;

end.


