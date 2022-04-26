unit nfe.localservice.dao.logs.files;

interface

uses
  Winapi.Windows, System.Classes, System.SysUtils, Data.Win.ADODB,
  //NFe units...
  nfe.localservice.model.logs.types,
  nfe.localservice.dao.logs.interfaces,
  nfe.localservice.dao.ado.xmlrecordset,
  nfe.localservice.dao.logs.consts;

type
 //Classe DAO que implementa INFEDAOFileLogs para escrita de logs em arquivos
  TNFEDAOFileLogs = class(TInterfacedObject, INFEDAOFileLogs)
    private
     FFilePath: string;
     FModelFile: string;
     procedure ToXmlFile(Dataset: TADODataset); inline;
     function NewFileName: string; inline;

    protected
     constructor Create(const FilePath, ModelFile: string);
     //INFEDAOFileLogs
     procedure RegisterLog(Data: TLogData);

    public
     class function New(const FilePath, ModelFile: string): INFEDAOFileLogs;
     destructor Destroy; override;

  end;

implementation

{ TNFEDAOFileLogs }

constructor TNFEDAOFileLogs.Create(const FilePath, ModelFile: string);
begin
 inherited Create;
 FFilePath := FilePath;
 FModelFile := ModelFile;
end;

destructor TNFEDAOFileLogs.Destroy;
begin
  inherited Destroy;
end;

class function TNFEDAOFileLogs.New(
  const FilePath, ModelFile: string): INFEDAOFileLogs;
begin
  Result := self.Create(FilePath, ModelFile) as INFEDAOFileLogs;
end;

function TNFEDAOFileLogs.NewFileName: string;
begin
 //Gera um novo nome para o arquivo de logs
 Randomize;
 Result := FFilePath + Format(TFileLogsConst.NewFile, [Random(10000)]);
end;

procedure TNFEDAOFileLogs.RegisterLog(Data: TLogData);
var
 Ds: TADODataset;
begin
 //Registra novo log crítico em arquivo XML usando oledb
 Ds := TADODataset.Create(nil);
 try
  Ds.CommandType := cmdFile;
  Ds.CommandText := FModelFile;
  Ds.CursorLocation := clUseClient;
  Ds.Open;
  Ds.Append;
  with Ds.Fields do
   begin
    FieldByName(TFileLogsFields.LOG).Value := Data.Text;
    FieldByName(TFileLogsFields.DATA).AsDateTime := Now;
    FieldByName(TFileLogsFields.TIPO).Value := TFileLogsConst.CriticalError;
    FieldByName(TFileLogsFields.CLASSNAME).Value := Data.ExceptionClass;
    FieldByName(TFileLogsFields.INNERMSG).Value := Data.DetailsInfo;
   end;

  Ds.Post;
  self.ToXmlFile(Ds);

 finally
  FreeAndNil(Ds);
 end;
end;

procedure TNFEDAOFileLogs.ToXmlFile(Dataset: TADODataset);
var
 FileContent: TStringList;
begin
 //Converte um dataset para o formato XML e o salva em um arquivo
 FileContent := TStringList.Create;

 try
  FileContent.Text := TADOXmlRecordset.New.RecordsetToXML(Dataset.Recordset);
  FileContent.SaveToFile(self.NewFileName);
 finally
  FreeAndNil(FileContent);
 end;
end;

end.
