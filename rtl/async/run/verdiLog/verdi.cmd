sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
simSetSimulator "-vcssv" -exec "vsim" -args \
           "-sverilog +plusargs_save +seed=776998298 -ucli"
debImport "-sverilog" "-top" "tb_top" "+v2k" "-dbdir" "vsim.daidir"
debLoadSimResult /home/ICer/AMBA/rtl/async/run/vsim.fsdb
wvCreateWindow
srcHBSelect "tb_top.dut" -win $_nTrace1
srcSetScope -win $_nTrace1 "tb_top.dut" -delim "."
srcHBSelect "tb_top.dut" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "CP" -line 8 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "D" -line 10 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "Q" -line 11 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 31747.231432 259269.056696
wvZoom -win $_nWave2 81058.045273 120660.492256
wvZoom -win $_nWave2 100332.240002 103310.370785
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 100175.595607 -snap {("G1" 1)}
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoom -win $_nWave2 99740.262590 101562.118684
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 100200.922021 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 100168.595043 -snap {("G1" 2)}
wvSetWindowTimeUnit -win $_nWave2 1.000000 ns
wvSetCursor -win $_nWave2 1002.040008 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 1001.732132 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 1001.916857 -snap {("G1" 1)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoom -win $_nWave2 2944.772144 3244.273895
wvZoom -win $_nWave2 2987.413500 3019.426151
wvSetCursor -win $_nWave2 2998.097908 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 3001.979459 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 3001.681919 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 3002.020033 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 3005.928633 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 3009.972478 -snap {("G1" 1)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 3930.447747 4094.906482
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 4885.343659 5205.506671
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 5836.432050 6314.715283
wvZoom -win $_nWave2 5993.637101 6021.723864
wvSetCursor -win $_nWave2 6002.085675 -snap {("G1" 0)}
wvSetCursor -win $_nWave2 6001.824624 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 6006.155705 -snap {("G1" 1)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoom -win $_nWave2 21244.189033 24590.876347
wvZoom -win $_nWave2 22854.614403 23234.951914
wvSetCursor -win $_nWave2 23000.354210 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23001.800360 -snap {("G1" 1)}
wvZoom -win $_nWave2 22986.535441 23036.668649
wvSetCursor -win $_nWave2 23001.912166 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 22997.887954 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23001.975706 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23001.721546 -snap {("G1" 2)}
wvSetCursor -win $_nWave2 23002.018066 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23002.018066 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23003.055889 -snap {("G1" 3)}
wvSetCursor -win $_nWave2 23006.126999 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23009.960590 -snap {("G1" 1)}
wvSetCursor -win $_nWave2 23006.148179 -snap {("G1" 1)}
