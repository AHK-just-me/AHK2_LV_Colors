#Requires AutoHotkey v2.0.1
AHK :=  "AutoHotkey v" . A_AhkVersion . " (" . (A_PtrSize = 8 ? "64" : "32") . "-bit)"
Main := Gui("", "ListView & Colors - " . AHK)
Main.MarginX := 20
Main.MarginY := 20
Header := ["Column 1", "Column 2", "Column 3", "Column 4", "Column 5", "Column 6", "Column 7", "Column 8"]
MainLV := Main.AddListView("w800 r30 cBlue Grid -ReadOnly", Header)
Loop 256
   MainLV.Add("", "Value " . A_Index, "Value " . A_Index, "Value " . A_Index, "Value " . A_Index, "Value " . A_Index,
              "Value " . A_Index, "Value " . A_Index, "Value " . A_Index)
Loop MainLV.GetCount("Column")
   MainLV.ModifyCol(A_Index, 95)
; Create a new instance of LV_Colors
CLV := LV_Colors(MainLV)
If !IsObject(CLV) {
   MsgBox("Couldn't create a new LV_Colors object!", "ERROR", 16)
   ExitApp
}
; Set the colors for selected rows
CLV.SelectionColors(0xF0F0F0)
Main.AddCheckBox("w120 vColorsOn Checked", "Colors On").OnEvent("Click", ShowColors)
Main.AddRadio("x+0 yp wp vNone", "No Colors").OnEvent("Click", WhichColors)
Main.AddRadio("x+0 yp wp vColors Checked", "Colors").OnEvent("Click", WhichColors)
Main.AddRadio("x+0 yp wp vAltRows", "Alternate Rows").OnEvent("Click", WhichColors)
Main.AddRadio("x+0 yp wp vAltCols", "Alternate Columns").OnEvent("Click", WhichColors)
Main.OnEvent("Close", MainClose)
Main.OnEvent("Escape", MainClose)
Main.Show()
WhichColors({Name: "Colors"})
; ----------------------------------------------------------------------------------------------------------------------
MainClose(*) {
   Main.Destroy()
   ExitApp
}
; ----------------------------------------------------------------------------------------------------------------------
ShowColors(Ctl, *) {
   CLV.ShowColors(Ctl.Value)
   MainLV.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
WhichColors(Ctl, *) {
   MainLV.Opt("-Redraw")
   CLV.Clear(1, 1)
   Switch Ctl.Name {
      Case "Colors":
         SetColors(CLV)
      Case "AltRows":
         CLV.AlternateRows(0x808080, 0xFFFFFF)
      Case "AltCols":
         CLV.AlternateCols(0x808080, 0xFFFFFF)
   }
   MainLV.Opt("+Redraw")
   MainLV.Focus()
}
; ----------------------------------------------------------------------------------------------------------------------
SetColors(CLV) {
   Loop CLV.LV.GetCount() {
      If (A_Index & 1) {
         If (Mod(A_Index, 3) = 0)
            CLV.Row(A_Index, 0xFF0000, 0xFFFF00)
         CLV.Cell(A_Index, 1, 0x00FF00, 0x000080)
         CLV.Cell(A_Index, 3, 0x00FF00, 0x000080)
         CLV.Cell(A_Index, 5, 0x00FF00, 0x000080)
      }
      Else {
         CLV.Row(A_Index, 0x000080, 0x00FF00)
      }
   }
}
; ----------------------------------------------------------------------------------------------------------------------
#Include Class_LV_Colors.ahk
