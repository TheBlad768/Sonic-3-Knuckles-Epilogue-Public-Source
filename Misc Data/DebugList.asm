; ===========================================================================
; Debug mode item lists
; ===========================================================================

DebugList: offsetTable
		offsetTableEntry.w .DEZ1
		offsetTableEntry.w .DEZ1
		offsetTableEntry.w .DEZ1
		offsetTableEntry.w .DEZ1

		zonewarning DebugList,(2*4)
; ---------------------------------------------------------------------------

			; Object Mappings Subtype Frame Arttile
.DEZ1: dbglistheader
	dbglistobj Obj_Ring, Map_Ring, 0, 0, make_art_tile(ArtTile_Ring,3,1)
	dbglistobj Obj_PathSwap, Map_PathSwap, 9, 1, make_art_tile(ArtTile_Ring,3,0)
	dbglistobj Obj_PathSwap, Map_PathSwap, $D, 5, make_art_tile(ArtTile_Ring,3,0)
	dbglistobj Obj_Spikes, Map_Spikes, 0, 0, make_art_tile($48C,0,0)
	dbglistobj Obj_Spikes, Map_Spikes, $40, 4, make_art_tile($484,0,0)
	dbglistobj Obj_EggCapsule, Map_EggCapsule, 1, 0, make_art_tile($43E,0,0)
.DEZ1_End:

	even