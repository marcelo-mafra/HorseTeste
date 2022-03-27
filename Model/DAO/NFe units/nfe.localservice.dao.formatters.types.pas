unit nfe.localservice.dao.formatters.types;

interface
{Os tipos definidos nessa unit são apenas aqueles usados pelas classes "formatadoras"
de dados. Esses tipos definem, de forma estruturada e simples como os dados
serão formatados pelas classes formatadoras.}

uses
 System.Classes, System.SysUtils, Winapi.Windows;

type
  TFormattedInfo = (fiValorUnitario, fiValorTotal, fiIcms, fiIcmsAliq, fiPesos,
      fiBC);

  //"Alias" para as formatações suportadas de números
  TNumberFormats = (nf16_6, nf10_2, nf10_3, nf14_3);

  //Define um number (16,6)
  TNumber16 = record
   const
    Precision = 16;
    Scale     = 6;
    procedure ValidateNumber(const value: double; var IntSize, Precision, Scale: boolean);
  end;

  //Define um number (10,2)
  TNumber10 = record
   const
    Precision = 10;
    Scale     = 2;
  end;

  //Define um number (10,3)
  TNumber10_3 = record
   const
    Precision = 10;
    Scale     = 3;
  end;

  //Define um number (14,3)
  TNumber14 = record
   const
    Precision = 14;
    Scale     = 3;
  end;

implementation


{ TNumber16 }

procedure TNumber16.ValidateNumber(const value: double; var IntSize, Precision,
  Scale: boolean);
var
 I: integer;
begin
 I := value.ToString.IndexOf('.');
 if I > 0 then
  begin
   Scale := Length(Copy(value.ToString, I + 1, 1)) <= TNumber16.Scale;
   Precision := Length(value.ToString) - 1 <= (TNumber16.Precision);
   IntSize := Length(Copy(value.ToString, 0, I)) <= (TNumber16.Precision - TNumber16.Scale);
   //outputdebugstring(PWideChar(Copy(value.ToString, 0, I)));
  end
 else
  begin
   Scale := False;
   Precision := Length(value.ToString) <= (TNumber16.Precision - TNumber16.Scale);
   IntSize := Precision;
  end;

end;

end.
