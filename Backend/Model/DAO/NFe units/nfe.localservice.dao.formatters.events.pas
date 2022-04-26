unit nfe.localservice.dao.formatters.events;

interface

uses
 System.Classes, System.SysUtils,
 nfe.localservice.dao.formatters.types,
 nfe.localservice.dao.formatters.customobj;

type
  TOnAfterNumberFormat = procedure(Sender: TCustomFormatter; Info: TFormattedInfo;
        const OriginalValue, value: variant);

  TOnNumberFormatError = procedure(Sender: TCustomFormatter; Info: TFormattedInfo;
        const value: variant; E: Exception);


implementation

end.
