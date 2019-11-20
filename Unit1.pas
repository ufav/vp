unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, SHDocVw,
  Vcl.StdCtrls, MSHTML, regexpr, Vcl.Grids, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdBaseComponent, IdMessage;

type
  TForm1 = class(TForm)
    green_list: TWebBrowser;
    Memo1: TMemo;
    predictions: TWebBrowser;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure green_listNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure green_listDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      const URL: OleVariant);
    procedure predictionsNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure predictionsDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  CurDispatch: IDispatch;
  cappers: TStringList;
  flag: Boolean;
  function CountPos(const subtext: string; Text: string): Integer;
  function StripTags(s, f, l: string): string;

implementation

{$R *.dfm}

procedure Gmail(predict: string);
var
  IdMessage: TIdMessage;
  IdSMTP: TIdSMTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
begin
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSL.SSLOptions.Method := sslvTLSv1;
  SSL.SSLOptions.Mode := sslmUnassigned;
  SSL.SSLOptions.VerifyMode := [];
  SSL.SSLOptions.VerifyDepth := 0;
  IdMessage.ContentType := 'text/html';
  IdMessage.CharSet := 'Windows-1251';
  IdMessage.From.Address := 'marlen.karimov@gmail.com';
  IdMessage.Recipients.EMailAddresses := 'plus_stick@mail.com, sayat.kuramayev@gmail.com'; //
  IdMessage.subject := 'Прогноз';
  IdMessage.body.text := predict;
  IdSMTP.IOHandler := SSL;
  IdSMTP.Host := 'smtp.gmail.com';
  IdSMTP.Port := 587;
  IdSMTP.username := 'marlen.karimov@gmail.com';
  IdSMTP.password := 'ghbrjkghbrjk';
  IdSMTP.UseTLS := utUseExplicitTLS;
  IdSMTP.Connect;
  IdSMTP.Send(IdMessage);
  IdSMTP.Disconnect;
  IdSMTP.Free;
  IdMessage.Free;
  SSL.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.WindowState := wsMaximized;
  green_list.Navigate('https://vprognoze.ru/statalluser/');
end;

procedure TForm1.green_listDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
var
  re1: TRegExpr;
  s: string;
  i: Integer;
  lgn, psswrd: IHTMLElement;
  input: IHTMLInputElement;
begin
  if (pDisp = CurDispatch) then
    begin
      Beep;
      CurDispatch := nil;
      begin
        s := (green_list.Document as IHTMLDocument2).body.innerHTML;
        if Pos('khvostatyy', s) = 0 then
          try
            lgn := (green_list.Document as IHTMLDocument3).getElementById('login_name');
            psswrd := (green_list.Document as IHTMLDocument3).getElementById('login_password');
            if Assigned(lgn) then
              if Supports(lgn, IID_IHTMLInputElement, input) then
                input.value := 'khvostatyy';
            if Assigned(psswrd) then
              if Supports(psswrd, IID_IHTMLInputElement, input) then
                input.value := 'Ghbrjk123';
            for i := 0 to green_list.OleObject.Document.All.Tags('input').Length - 1 do
              begin
                if (green_list.OleObject.Document.All.Tags('input').Item(i).Value = 'Вход') then
                  green_list.OleObject.Document.All.Tags('input').Item(i).Click;
              end;
          except
            Gmail('Authorization error');
            Application.Terminate;
          end
        else
          s := (green_list.Document as IHTMLDocument2).body.innerHTML;
          cappers := TStringList.Create;
          re1 := TRegExpr.Create;
          re1.Expression := '00cc33\">(.*?)<';
          if re1.Exec(s) then
            repeat
              cappers.Add(re1.Match[1]);
            until not re1.ExecNext;
          Memo3.Text := cappers.Text;
          Memo3.Text := StringReplace(Memo3.Text, '+', ' ', [rfReplaceAll, rfIgnoreCase]);
          predictions.Navigate('https://vprognoze.ru/forecast/pro/');
      end;
    end;
end;

procedure TForm1.predictionsDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  s, t, u, ch, ev, pr, od, pr_text, final_pr: string;
  i: Integer;
  re1: TRegExpr;
  authors, times: TStringList;
  f: textfile;
begin
  predictions.Stop;
  if (pDisp = CurDispatch) then
    begin
      Beep;
      CurDispatch := nil;
      begin
        times := TStringList.Create;
        AssignFile(f, 'list.txt');
        Reset(f);
        while not Eof(f) do
          begin
            ReadLn(f, u);
            times.Add(u);
          end;
        u := times.Text;
        Append(f);
        s := (predictions.Document as IHTMLDocument2).body.innerHTML;
        s := Copy(s, Pos('dle-content', s), Length(s) - Pos('dle-content', s));
        authors := TStringList.Create;
        re1 := TRegExpr.Create;
        re1.Expression := 'ShowProfileM\(''(.*?)'',';
        if re1.Exec(s) then
          repeat
            authors.Add(re1.Match[1]);
          until not re1.ExecNext;
        Memo2.Text := authors.Text;
        for i := 0 to authors.Count - 1 do
          begin
            if Pos(authors.Strings[i], Memo3.Text) > 0 then
              begin
                t := Copy(s, Pos('от ' + authors.Strings[i], s), Pos('>' + authors.Strings[i] + '<', s) - Pos('от ' + authors.Strings[i], s));
                s := Copy(s, Pos('>' + authors.Strings[i] + '<', s) + 1, Length(s) - Pos('>' + authors.Strings[i] + '<', s));
                re1.Expression := 'cur_time(.*?) data';
                re1.Exec(t);
                if Pos(re1.Match[1], u) > 0 then  //если событие есть в файле
                  Continue
                else
                  begin
                    Writeln(f, re1.Match[1]);
                    re1.Expression := 'championship>(.*?)</DIV>'; //event place
                    re1.Exec(t);
                    ch := re1.Match[1];
                    re1.Expression := '_name>(.*?)</SPAN>';       //event
                    re1.Exec(t);
                    ev := StripTags(re1.Match[1], '<', '>');
                    re1.Expression := 'info_match>(.*?)</DIV>';   //predict
                    re1.Exec(t);
                    pr := re1.Match[1];
                    re1.Expression := 'w target=_blank>(.*?)</A>';   //odd
                    re1.Exec(t);
                    od := re1.Match[1];
                    pr_text := Copy(t, Pos('game_start', t), Pos('info down', t) - Pos('game_start', t)); //prediction text
                    if Pos('inline', pr_text) > 0 then
                      begin
                        re1.Expression := 'inline">(.*?)</DIV></DIV>';
                        re1.Exec(pr_text);
                        pr_text := re1.Match[1];
                      end
                    else
                      begin
                        re1.Expression := '<DIV>(.*?)</DIV></DIV>';
                        re1.Exec(pr_text);
                        pr_text := re1.Match[1];
                      end;
                    final_pr := '<b>' + ch + '<br>' +
                                ev + '<br>' +
                                pr + '</b>' + '<br>' +
                                od + '</b>' + '<br>' +
                                pr_text + '<br><hr>';
                    if Length(final_pr) > 50 then Memo1.Lines.Add(final_pr);
                    //Memo1.Lines.Add(t);
                  end;
              end
            else
              s := Copy(s, Pos('>' + authors.Strings[i] + '<', s) + 1, Length(s) - Pos('>' + authors.Strings[i] + '<', s));
          end;
        try
          if Length(Memo1.Text) > 50 then Gmail(Memo1.Text);
        finally
          CloseFile(f);
          Application.Terminate;
        end;
      end;
    end;
end;

procedure TForm1.green_listNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
begin
  if CurDispatch = nil then
    CurDispatch := pDisp;
end;

procedure TForm1.predictionsNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  if CurDispatch = nil then
    CurDispatch := pDisp;
end;

function CountPos(const subtext: string; Text: string): Integer;  //количество вхождений подстроки в строку
begin
  if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
    Result := 0
  else
    Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div Length(subtext);
end;

function StripTags(s, f, l: string): string; // удаляем теги
var
  TagBegin, TagEnd, TagLength: Integer;
begin
  TagBegin := pos(f, s);
  while (TagBegin > 0) do
    begin
      TagEnd := pos(l, s);
      TagLength := TagEnd - TagBegin + length(l);
      Delete(s, TagBegin, TagLength);
      TagBegin := pos(f, s);
    end;
  Result := s;
end;

end.
