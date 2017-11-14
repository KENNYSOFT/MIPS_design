C:\altera\13.1\quartus\bin\quartus_cdb --update_mif MIPS_System.qpf
C:\altera\13.1\quartus\bin\quartus_asm MIPS_System.qpf
C:\altera\13.1\quartus\bin\quartus_pgm -c usb-blaster -m jtag -o p;MIPS_System.sof
