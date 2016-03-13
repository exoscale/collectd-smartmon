   { "Intel 730 and DC S35x0/3610/3700 Series SSDs", // tested with INTEL SSDSC2BP480G4, SSDSC2BB120G4/D2010355,
       // INTEL SSDSC2BB800G4T, SSDSC2BA200G3/5DV10250, SSDSC2BB080G6/G2010130,  SSDSC2BX200G4/G2010110,
       // INTEL SSDSC2BB016T6/G2010140, SSDSC2BX016T4/G2010140
     "INTEL SSDSC(1N|2B)[ABPX]((080|100|120|160|200|240|300|400|480|600|800)G[346]T?|(012|016)T[46])",
       // A = S3700, B*4 = S3500, B*6 = S3510, P = 730, X = S3610
     "", "",
   //"-v 3,raw16(avg16),Spin_Up_Time "
   //"-v 4,raw48,Start_Stop_Count "
   //"-v 5,raw16(raw16),Reallocated_Sector_Ct "
   //"-v 9,raw24(raw8),Power_On_Hours "
   //"-v 12,raw48,Power_Cycle_Count "
     "-v 170,raw48,Available_Reservd_Space "
     "-v 171,raw48,Program_Fail_Count "
     "-v 172,raw48,Erase_Fail_Count "
     "-v 174,raw48,Unsafe_Shutdown_Count "
     "-v 175,raw16(raw16),Power_Loss_Cap_Test "
     "-v 183,raw48,SATA_Downshift_Count "
   //"-v 184,raw48,End-to-End_Error "
   //"-v 187,raw48,Reported_Uncorrect "
     "-v 190,tempminmax,Temperature_Case "
     "-v 192,raw48,Unsafe_Shutdown_Count "
     "-v 194,tempminmax,Temperature_Internal "
   //"-v 197,raw48,Current_Pending_Sector "
     "-v 199,raw48,CRC_Error_Count "
     "-v 225,raw48,Host_Writes_32MiB "
     "-v 226,raw48,Workld_Media_Wear_Indic " // Timed Workload Media Wear Indicator (percent*1024)
     "-v 227,raw48,Workld_Host_Reads_Perc "  // Timed Workload Host Reads Percentage
     "-v 228,raw48,Workload_Minutes " // 226,227,228 can be reset by 'smartctl -t vendor,0x40'
   //"-v 232,raw48,Available_Reservd_Space "
   //"-v 233,raw48,Media_Wearout_Indicator "
     "-v 234,raw24/raw32:04321,Thermal_Throttle "
     "-v 241,raw48,Host_Writes_32MiB "
     "-v 242,raw48,Host_Reads_32MiB "
     "-v 243,raw48,NAND_Writes_32MiB " // S3510/3610
   }
