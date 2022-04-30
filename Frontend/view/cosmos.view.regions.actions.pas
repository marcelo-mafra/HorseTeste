unit cosmos.view.regions.actions;

interface

uses
  System.Classes, FMX.TreeView, FMX.ListBox,
  client.controller.regions, client.controller.regions.types,
  cosmos.view.regions.actions.interfaces;

type
  TRegionsTreeActions = class(TInterfacedObject, IRegionsTreeActions)

    protected
      constructor Create;
      function ListRootRegions(Obj: TTreeView): TRegionsList; overload;
      function ListRootRegions(Obj: TListbox): TRegionsList; overload;
      function ListParentRegions(obj: TTreeView; NodeObj: TTreeViewItem;
            OwnerId: integer): TRegionsList;
    public
      destructor Destroy; override;
      class function New: IRegionsTreeActions;
  end;

implementation

{ TRegionsTreeActions }

constructor TRegionsTreeActions.Create;
begin
 inherited;
end;

destructor TRegionsTreeActions.Destroy;
begin

  inherited;
end;

class function TRegionsTreeActions.New: IRegionsTreeActions;
begin
  Result := self.Create;
end;

function TRegionsTreeActions.ListParentRegions(obj: TTreeView; NodeObj: TTreeViewItem;
    OwnerId: integer): TRegionsList;
var
 I: integer;
 Node: TTreeViewItem;
begin
 Result := TControllerRegions.New.ListParentRegions(OwnerId);
 obj.BeginUpdate;
 try
   NodeObj.DeleteChildren;
   for I := 0 to Pred(Result.Count) do
     begin
      Node := TTreeViewItem.Create(obj);
      Node.Text := Result.Items[I].Regiao;
      Node.AddObject(Result.Items[I]);
      Obj.AddObject(Node);
   //   Node.Parent := obj;
//      Node.Parent := obj.Selected;
      //NodeObj.InsertObject(0, Node);
      //Node.Items.ParentItem := NodeObj;
     end;
 finally
   obj.EndUpdate;
 end;
end;

function TRegionsTreeActions.ListRootRegions(Obj: TListbox): TRegionsList;
var
 I: integer;
 GroupItemObj: TListboxGroupHeader;
 ListItemObj : TListBoxItem;
begin
 Result := TControllerRegions.New.ListRegions;
 obj.BeginUpdate;
 try
   obj.Clear;
   for I := 0 to Pred(Result.Count) do
     begin
      ListItemObj := TListBoxItem.Create(obj);
      ListItemObj.Text := Result.Items[I].Regiao;
      ListItemObj.StyleLookup := 'listboxitemnodetail';
      ListItemObj.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      Obj.AddObject(ListItemObj);
     end;
 finally
   obj.EndUpdate;
 end;

end;

function TRegionsTreeActions.ListRootRegions(Obj: TTreeView): TRegionsList;
var
 I: integer;
 Node: TTreeViewItem;
begin
 Result := TControllerRegions.New.ListRegions;
 obj.BeginUpdate;
 try
   obj.Clear;
   for I := 0 to Pred(Result.Count) do
     begin
      Node := TTreeViewItem.Create(nil);
      Node.Text := Result.Items[I].Regiao;
      Node.AddObject(Result.Items[I]);
      Node.Parent := obj;
     end;
 finally
   obj.EndUpdate;
 end;
end;



end.
