unit horse.model.params.exceptions;

interface

uses
 System.Classes, System.SysUtils;

type
 TParamsErrorIdent = class
   const
     UnknownObject = 'E0001';
 end;

 TParamsErrorMsg = class
   const
     UnknownObject
       = 'Falha ao tentar adicionar o par�metro "%s" � lista. ' +
         'Verifique se foi chamado o m�todo "BeginObject" antes de iniciar ' +
         'a adi��o de novos par�metros' ;
 end;

 {Exception "ancestral da qual, tipicamente, todas as demais dessa unit
 descender�o. Define a categoria da exce��o}
 EBackendError = class(Exception)
   private
    FErrorId: string;
   public
    property ErrorId: string read FErrorId;
 end;

  //Exception relacionada aos contrutor de par�metros de consultas
  EParamBuilder = class(EBackendError)
   public
    constructor Create(const ErrorInfo: string = ''); reintroduce;
    property ErrorId;
  end;

implementation

{ EParamBuilder }

constructor EParamBuilder.Create(const ErrorInfo: string);
begin
 inherited Create(EmptyStr);
 FErrorId := TParamsErrorIdent.UnknownObject;
 self.Message := Format(TParamsErrorMsg.UnknownObject, [ErrorInfo]);
end;

end.
