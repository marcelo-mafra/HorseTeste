unit cosmos.view.regions.actions.interfaces;

interface

uses
  System.Classes, FMX.TreeView, FMX.ListBox,
  client.controller.regions.types;

type
  IRegionsTreeActions = interface
    ['{E405F505-1C1F-4E67-A502-4DFFBDD10592}']
    function ListRootRegions(Obj: TTreeView): TRegionsList; overload;
    function ListRootRegions(Obj: TListbox): TRegionsList; overload;
    function ListParentRegions(obj: TTreeView; NodeObj: TTreeViewItem;
          OwnerId: integer): TRegionsList;
  end;

implementation

end.
