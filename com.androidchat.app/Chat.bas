B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=10.7
@EndOfDesignText@
Sub Class_Globals
	Private xui As XUI
	Private TextField As B4XFloatTextField
	Private CLV As CustomListView
	Private BBCodeView1 As BBCodeView
	Private Engine As BCTextEngine
	Private bc As BitmapCreator
	Private ArrowWidth As Int = 10dip
	Private Gap As Int = 6dip
	Private pnlBottom As B4XView
	Private LastUserLeft As Boolean = True
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Parent As B4XView)
	'load the layout that has the chat design
	Parent.LoadLayout("chatlay")
	Engine.Initialize(Parent)
	bc.Initialize(300, 300)
	'initialize edit text where you edit the message
	TextField.NextField = TextField
End Sub

Private Sub BuildMessage (Text As String, User As String) As List
	'Buid message design
	Dim title As BCTextRun = Engine.CreateRun(User & CRLF)
	title.TextFont  = BBCodeView1.ParseData.DefaultBoldFont
	Dim TextRun As BCTextRun = Engine.CreateRun(Text & CRLF)
	Dim time As BCTextRun = Engine.CreateRun(DateTime.Time(DateTime.Now))
	time.TextFont = xui.CreateDefaultFont(10)
	time.TextColor = xui.Color_Gray
	Return Array(title, TextRun, time)
End Sub

Private Sub AddItem (Text As String, Right As Boolean)
	Dim p As B4XView = xui.CreatePanel("")
	p.Color = xui.Color_Transparent
	Dim User As String
	If Right Then User = "User 2" Else User = "User 1"
	BBCodeView1.ExternalRuns = BuildMessage(Text, User)
	BBCodeView1.ParseAndDraw
	Dim ivText As B4XView = CreateImageView
	'get the bitmap from BBCodeView1 foreground layer.
	Dim bmpText As B4XBitmap = GetBitmap(BBCodeView1.ForegroundImageView)
	'the image might be scaled by Engine.mScale. The "correct" dimensions are:
	Dim TextWidth As Int = bmpText.Width / Engine.mScale
	Dim TextHeight As Int = bmpText.Height / Engine.mScale
	'bc is not really used here. Only the utility method.
	bc.SetBitmapToImageView(bmpText, ivText)
	Dim ivBG As B4XView = CreateImageView
	'Draw the bubble.
	Dim bmpBG As B4XBitmap = DrawBubble(TextWidth, TextHeight, Right)
	bc.SetBitmapToImageView(bmpBG, ivBG)
	p.SetLayoutAnimated(0, 0, 0, CLV.sv.ScrollViewContentWidth - 2dip, TextHeight + 3 * Gap)
	If Right Then
		p.AddView(ivBG, p.Width - bmpBG.Width * xui.Scale, Gap, bmpBG.Width * xui.Scale, bmpBG.Height * xui.Scale)
		p.AddView(ivText, p.Width - Gap - ArrowWidth - TextWidth, 2 * Gap, TextWidth, TextHeight)
	Else
		p.AddView(ivBG, 0, Gap, bmpBG.Width * xui.Scale, bmpBG.Height * xui.Scale)
		p.AddView(ivText, Gap + ArrowWidth, 2 * Gap, TextWidth, TextHeight)
	End If
	CLV.Add(p, Null)
	ScrollToLastItem
End Sub