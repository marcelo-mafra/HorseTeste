unit horse.model.params.builder.interfaces;

interface

uses
 System.Classes, Data.DB, System.JSON;

type
  IModelParamsBuilder = interface
    ['{A05E6EDB-0539-4A74-9EC4-75C26F47DB56}']
    function BeginObject: IModelParamsBuilder;
    function Add(const ParamName: string; ParamValue: string): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: integer): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: int64): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Byte): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Word): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: ShortInt): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: double): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: TDateTime): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: TDate): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: Boolean): IModelParamsBuilder; overload;
    function Add(const ParamName: string; ParamValue: variant): IModelParamsBuilder; overload;
    function Add(Obj: TJSONObject): IModelParamsBuilder; overload;
    function ParamsObj: TParams;
  end;

implementation

end.
