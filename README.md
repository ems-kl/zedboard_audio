#An Audio Interface for the Zedboard

###Overview

This VHDL interface connects the ADAU1761 audio codec on the Zedboard to the Zynq PL. Audio signals can be received in stereo from the line in jack and/or transmitted to the headphone out jack. The design has originally been developed by Mike Field (alias hamster). In his design it is part of a system for filtering audio signals with the Zedboard (http://hamsterworks.co.nz/mediawiki/index.php/Zedboard_Audio). We have extracted, modified and extended the audio interface part to provide an easy to use standalone IP core for using the audio capabilities on the Zedboard.
###Features

* ready to use, standalone IP block
* interface synchronized to 100 MHz system clock
* compatible to Vivado
* testbench to test line in and headphone out
* documentation and "how-to-use" guidance
* ready-to-use bitstreams for quick evaluation

###Authors and Contributors

Microelectronic Systems Design Research Group, TU Kaiserslautern, Germany, http://ems.eit.uni-kl.de/
