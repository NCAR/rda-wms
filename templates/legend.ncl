load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin

  wks_type = "png"
  wks = gsn_open_wks(wks_type,"__OUTFILE__")
  gsn_define_colormap(wks,"__COLOR_MAP__")
#IF __SPECIFIC_LABELS__
  nboxes = __NUM_LABEL_BOXES__
  fill_colors = (/__FILL_COLORS__/)
  labels = (/__LABELS__/)
#ENDIF __SPECIFIC_LABELS__
#ELSE __SPECIFIC_LABELS__
  colors = read_colormap_file("__COLOR_MAP__");
  dims = dimsizes(colors)
  nboxes = dims(0)
  if (nboxes .gt. 254) then
    nboxes = 254
  end if
  boxsize = __BOX_SIZE__
  fill_colors = ispan(2,nboxes+1,1)
  vals = fspan(__MIN_VAL__,__MIN_VAL__+boxsize*(nboxes-1),dimsizes(fill_colors))
  labels = new(dimsizes(fill_colors),string)
  do i=0,dimsizes(fill_colors)-1
    labels(i)=sprintf("%.__LABEL_PRECISION__f",vals(i))
  end do
#ENDELSE __SPECIFIC_LABELS__

  lbres = True
  lbres@lbAutoManage = False
  lbres@vpWidthF = 0.25
  lbres@vpHeightF = 0.05
  lbres@lbRightMarginF = 0.085
  lbres@lbOrientation = "Horizontal"
  lbres@lbFillColors = fill_colors
  lbres@lbPerimOn = True
  lbres@lbBoxLinesOn = False
  lbres@lbMonoFillPattern = True
  lbres@lbLabelAlignment = "InteriorEdges"
#IF __SPECIFIC_LABELS__
  lbres@lbLabelStride = __LABEL_STRIDE__
#ENDIF __SPECIFIC_LABELS__
  lbres@lbLabelJust = "CenterRight"
  lbres@lbLabelFontHeightF = 0.006
  lbres@lbLabelAngleF = 30.
  lbres@lbLabelOffsetF = 0.02
  lbres@lbTitleString = "__TITLE__"
  lbres@lbTitlePosition = "Bottom"
  lbres@lbTitleDirection = "Across"
  lbres@lbTitleAngleF = 0.
  lbres@lbTitleFontHeightF = 0.0075
  lbres@lbTitleOffsetF = 0.

  gsn_labelbar_ndc(wks,nboxes,labels,0.01,0.99,lbres)
  frame(wks)

end
