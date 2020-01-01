program TouchFileDate;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Windows, Classes, SysUtils, CustApp,
  Types, FileUtil, LazFileUtils;

type

  { TTouchFileDate }

  TTouchFileDate = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TTouchFileDate }

procedure TTouchFileDate.DoRun;
var
  ErrorMsg: String;
  fileHandle: THandle;
  fileTime: TFILETIME;
  LFileTime: TFILETIME;
  LSysTime: TSystemTime;
  aFilename: TFileName;
  aDateString: string;
  aDate: TDateTime;
  validDate: boolean;
  validFilename: boolean;
begin
  // quick check parameters

  ErrorMsg:=CheckOptions('hfd:', 'help filename datetime:');

  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('f', 'filename') then begin
    aFilename:= GetOptionValue('f', 'filename');
    validFilename:= FileExistsUTF8(aFilename);
    if not validFilename then WriteLn('Filename -f ungueltig: ' + aFilename);
  end;

  if HasOption('d', 'datetime') then begin
    aDateString:= GetOptionValue('d', 'datetime');
    validDate:= TryStrToDateTime(aDateString, aDate);
    if not validDate then WriteLn('Datum -d ungueltig: ' + aDateString);

  end;

  if (not validFilename) or (not validDate) then
  begin
    Terminate;
    exit;
  end;

  try
     DecodeDate(aDate, LSysTime.Year, LSysTime.Month, LSysTime.Day);
     DecodeTime(aDate, LSysTime.Hour, LSysTime.Minute, LSysTime.Second, LSysTime.Millisecond);
     if SystemTimeToFileTime(LSysTime, LFileTime) then
     begin
       if LocalFileTimeToFileTime(LFileTime, fileTime) then
       begin
         fileHandle:= FileOpenUTF8(aFilename, fmOpenReadWrite or fmShareExclusive);
         SetFileTime(fileHandle, fileTime, fileTime, fileTime);
       end;
     end;
  finally

  end;

  Terminate;
end;

constructor TTouchFileDate.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TTouchFileDate.Destroy;
begin
  inherited Destroy;
end;

procedure TTouchFileDate.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TTouchFileDate;
begin
  Application:=TTouchFileDate.Create(nil);
  Application.Title:='TouchFileDate';
  Application.Run;
  Application.Free;
end.

