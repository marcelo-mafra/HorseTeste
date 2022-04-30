unit cosmos.view.main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.TabControl, FMX.Layouts, FMX.TreeView, FMX.Edit,
  client.controller.regions, cosmos.view.regions.actions,
  client.controller.regions.types, FMX.ListBox, FMX.SearchBox;
 // Bind4D, Bind4D.Types, Bind4D.Attributes;

type
//  [FormRest('/users', '', '', '')]
  TFrmMain = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    SpeedButton1: TSpeedButton;
    TrvRegions: TTreeView;
    Edit1: TEdit;
    LstboxRegions: TListBox;
    SearchBox1: TSearchBox;
    ListBoxGroupFooter1: TListBoxGroupFooter;
    procedure FormShow(Sender: TObject);
    procedure TrvRegionsDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure ListRegions;

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.fmx}

procedure TFrmMain.FormShow(Sender: TObject);
begin
 self.ListRegions;
end;

procedure TFrmMain.ListRegions;
var
 ListObj: TRegionsList;
begin
 try
  ListObj := TRegionsTreeActions.New.ListRootRegions(self.LstboxRegions);
 finally
  ListObj.DisposeOf;
 end;
end;

procedure TFrmMain.TrvRegionsDblClick(Sender: TObject);
var
 ListObj: TRegionsList;
begin
 try
  ListObj := TRegionsTreeActions.New.ListParentRegions(TrvRegions, TrvRegions.Selected,  4);
 finally
  ListObj.DisposeOf;
 end
end;

end.
