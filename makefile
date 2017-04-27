all: mw4_1.d64 mw4_2.d64 mw4.d81

clean:
	rm *.pak *.raw *.bin *.prg *.tbl *.hdr *.dat level*.p* *.bak 0* 1* 2* 3* 4* 5* 6* 7* *.reu *.c64

mw4_1.d64: mw4_1.seq mw4start.prg mw4.pak drive.pak settings.bin instr.pak \
	loadpic.pak
	makedisk mw4_1.d64 mw4_1.seq METAL.WARRIOR.4___S1_2A 12

mw4_2.d64: mw4_2.seq drive.pak \
	level00.pak level01.pak level02.pak level03.pak level04.pak \
	level05.pak level06.pak level07.pak level08.pak level09.pak \
	level10.pak level11.pak level12.pak level13.pak level14.pak \
	level15.pak level16.pak level17.pak level18.pak level19.pak \
	level20.pak level21.pak level22.pak level23.pak level24.pak \
	level25.pak level26.pak \
	lvlact.pak \
	music00.pak music01.pak music02.pak music03.pak \
	music04.pak music05.pak music06.pak music07.pak \
	music08.pak music09.pak music10.pak music11.pak music12.pak music13.pak \
	agent.pak common.pak lift.pak cop.pak thugs.pak ian.pak inside.pak legs.pak \
	tech.pak bystand.pak scientis.pak grunt.pak commando.pak enemyage.pak \
	priest.pak turret.pak heavytur.pak robot.pak spider.pak copter.pak iac.pak \
	exoskele.pak mutant1.pak mutant2.pak hover.pak blackhan.pak blowfish.pak \
	goat.pak joan.pak band.pak sentinel.pak \
	title.pak map.pak faces.pak script01.pak script02.pak script03.pak script04.pak \
	script05.pak script06.pak script07.pak script08.pak script09.pak script10.pak script11.pak \
	script12.pak script13.pak script14.pak script15.pak script16.pak script17.pak \
	script18.pak script19.pak script20.pak script21.pak script22.pak script23.pak \
	script24.pak script25.pak script26.pak script27.pak script28.pak script29.pak script30.pak
	makedisk mw4_2.d64 mw4_2.seq METAL.WARRIOR.4___S2_2A 12

mw4.d81: mw4_1.d64 mw4_2.d64
	c1541 < mw4.seq
	c1541 < mw4d81.seq
	zip mw4.zip mw*.d64 readme.txt
	zip mw4ind.zip mw4 0* 1* 2* 3* 4* 5* 6* read_ind.txt

loader.bin: loader.s define.s
	dasm loader.s -oloader.bin -sloader.tbl -v3 -p3 -f3
	symbols loader.tbl loadsym.s loadsym.txt

drive.pak: drive.s define.s loadsym.s
	dasm drive.s -odrive.bin -v3 -p3 -f3
	pack drive.bin drive.pak

mw4start.prg: define.s menu.s mw4start.s bg/scorescr.chr loader.bin mw4.pak
	dasm menu.s -omenu.prg -v3 -p3
	exomizer -omenu.pak -r -m1024 -p1 menu.prg
	dasm mw4start.s -omw4start.prg -v3 -p3

settings.bin: settings.s
	dasm settings.s -osettings.bin -v3 -p3 -f3

loadpic.pak: pics/loadpic.lbm
	benton64 pics/loadpic.lbm loadpic.raw -r -b0 -c
	truncate loadpic.raw 10048
	pack loadpic.raw loadpic.pak

instr.pak: instr.s bg/scoresc2.chr
	dasm instr.s -oinstr.bin -v3 -p3 -f3
	pack instr.bin instr.pak


mw4.pak: define.s loader.bin mw4.s main.s screen.s raster.s sprite.s file.s \
	sound.s control.s level.s init.s actor.s math.s player.s ai.s weapon.s \
	actdata.s scrdata.s snddata.s sprdata.s ctrldata.s itemdata.s \
	lvldata.s item.s others.s script.s var.s wpndata.s gamemenu.s gmdata.s \
	plot.s loadsym.s \
	spr/weapon2.spr \
	sfx/laser.ins sfx/melee.ins sfx/damage.ins \
	sfx/takedown.ins sfx/dart.ins sfx/throw.ins \
	sfx/explosio.ins sfx/grenade.ins sfx/clip.ins sfx/ammo.ins \
	sfx/cock.ins sfx/pickup.ins sfx/select.ins sfx/object.ins sfx/cockfast.ins \
	sfx/footstep.ins sfx/jump.ins sfx/glass.ins \
	sfx/pistol.ins sfx/9mmsuppr.ins sfx/44magnum.ins \
	sfx/shotgun.ins sfx/556rifle.ins sfx/sniper.ins \
	sfx/hypo.ins sfx/powerup.ins sfx/shutdown.ins sfx/flame.ins sfx/ignite.ins sfx/taser.ins \
	sfx/gasfist.ins sfx/missile.ins sfx/parasite.ins sfx/train.ins
	ins2nt sfx/laser.ins sfx/laser.sfx
	ins2nt sfx/dart.ins sfx/dart.sfx
	ins2nt sfx/pistol.ins sfx/pistol.sfx
	ins2nt sfx/9mmsuppr.ins sfx/9mmsuppr.sfx
	ins2nt sfx/44magnum.ins sfx/44magnum.sfx
	ins2nt sfx/shotgun.ins sfx/shotgun.sfx
	ins2nt sfx/556rifle.ins sfx/556rifle.sfx
	ins2nt sfx/sniper.ins sfx/sniper.sfx
	ins2nt sfx/melee.ins sfx/melee.sfx
	ins2nt sfx/throw.ins sfx/throw.sfx
	ins2nt sfx/punch.ins sfx/punch.sfx
	ins2nt sfx/damage.ins sfx/damage.sfx
	ins2nt sfx/takedown.ins sfx/takedown.sfx
	ins2nt sfx/explosio.ins sfx/explosio.sfx
	ins2nt sfx/grenade.ins sfx/grenade.sfx
	ins2nt sfx/clip.ins sfx/clip.sfx
	ins2nt sfx/ammo.ins sfx/ammo.sfx
	ins2nt sfx/cock.ins sfx/cock.sfx
	ins2nt sfx/cockfast.ins sfx/cockfast.sfx
	ins2nt sfx/pickup.ins sfx/pickup.sfx
	ins2nt sfx/select.ins sfx/select.sfx
	ins2nt sfx/object.ins sfx/object.sfx
	ins2nt sfx/footstep.ins sfx/footstep.sfx
	ins2nt sfx/jump.ins sfx/jump.sfx
	ins2nt sfx/glass.ins sfx/glass.sfx
	ins2nt sfx/taser.ins sfx/taser.sfx
	ins2nt sfx/hypo.ins sfx/hypo.sfx
	ins2nt sfx/powerup.ins sfx/powerup.sfx
	ins2nt sfx/shutdown.ins sfx/shutdown.sfx
	ins2nt sfx/flame.ins sfx/flame.sfx
	ins2nt sfx/ignite.ins sfx/ignite.sfx
	ins2nt sfx/gasfist.ins sfx/gasfist.sfx
	ins2nt sfx/missile.ins sfx/missile.sfx
	ins2nt sfx/parasite.ins sfx/parasite.sfx
	ins2nt sfx/train.ins sfx/train.sfx
	ins2nt sfx/transmis.ins sfx/transmis.sfx
	ins2nt sfx/bat.ins sfx/bat.sfx
	sprconv2 spr/weapon2.spr wpnspr.s wpnspr.dat
	dasm mw4.s -omw4.bin -smw4.tbl -v3 -p3 -f3
	symbols mw4.tbl mw4sym.s mw4sym.txt
	symbols mw4.tbl extern.s
	pack mw4.bin mw4.pak

level00.pak: bg/level00.chr bg/level00.map bg/level00.blk bg/level00.lvz level00a.s level00b.s level00c.s define.s
	dasm level00a.s -olevel00a.bin -v3 -p3 -f3
	dasm level00b.s -olevel00b.bin -v3 -p3 -f3
	dasm level00c.s -olevel00c.bin -v3 -p3 -f3
	pack level00a.bin level00a.pak
	pack level00b.bin level00b.pak
	pack level00c.bin level00c.pak
	filejoin level00a.pak+level00b.pak+level00c.pak level00.pak

level01.pak: bg/level01.chr bg/level01.map bg/level01.blk bg/level01.lvz level01a.s level01b.s level01c.s define.s
	dasm level01a.s -olevel01a.bin -v3 -p3 -f3
	dasm level01b.s -olevel01b.bin -v3 -p3 -f3
	dasm level01c.s -olevel01c.bin -v3 -p3 -f3
	pack level01a.bin level01a.pak
	pack level01b.bin level01b.pak
	pack level01c.bin level01c.pak
	filejoin level01a.pak+level01b.pak+level01c.pak level01.pak

level02.pak: bg/level02.chr bg/level02.map bg/level02.blk bg/level02.lvz level02a.s level02b.s level02c.s define.s
	dasm level02a.s -olevel02a.bin -v3 -p3 -f3
	dasm level02b.s -olevel02b.bin -v3 -p3 -f3
	dasm level02c.s -olevel02c.bin -v3 -p3 -f3
	pack level02a.bin level02a.pak
	pack level02b.bin level02b.pak
	pack level02c.bin level02c.pak
	filejoin level02a.pak+level02b.pak+level02c.pak level02.pak

level03.pak: bg/level03.chr bg/level03.map bg/level03.blk bg/level03.lvz level03a.s level03b.s level03c.s define.s
	dasm level03a.s -olevel03a.bin -v3 -p3 -f3
	dasm level03b.s -olevel03b.bin -v3 -p3 -f3
	dasm level03c.s -olevel03c.bin -v3 -p3 -f3
	pack level03a.bin level03a.pak
	pack level03b.bin level03b.pak
	pack level03c.bin level03c.pak
	filejoin level03a.pak+level03b.pak+level03c.pak level03.pak

level04.pak: bg/level04.chr bg/level04.map bg/level04.blk bg/level04.lvz level04a.s level04b.s level04c.s define.s
	dasm level04a.s -olevel04a.bin -v3 -p3 -f3
	dasm level04b.s -olevel04b.bin -v3 -p3 -f3
	dasm level04c.s -olevel04c.bin -v3 -p3 -f3
	pack level04a.bin level04a.pak
	pack level04b.bin level04b.pak
	pack level04c.bin level04c.pak
	filejoin level04a.pak+level04b.pak+level04c.pak level04.pak

level05.pak: bg/level05.chr bg/level05.map bg/level05.blk bg/level05.lvz level05a.s level05b.s level05c.s define.s
	dasm level05a.s -olevel05a.bin -v3 -p3 -f3
	dasm level05b.s -olevel05b.bin -v3 -p3 -f3
	dasm level05c.s -olevel05c.bin -v3 -p3 -f3
	pack level05a.bin level05a.pak
	pack level05b.bin level05b.pak
	pack level05c.bin level05c.pak
	filejoin level05a.pak+level05b.pak+level05c.pak level05.pak

level06.pak: bg/level06.chr bg/level06.map bg/level06.blk bg/level06.lvz level06a.s level06b.s level06c.s define.s
	dasm level06a.s -olevel06a.bin -v3 -p3 -f3
	dasm level06b.s -olevel06b.bin -v3 -p3 -f3
	dasm level06c.s -olevel06c.bin -v3 -p3 -f3
	pack level06a.bin level06a.pak
	pack level06b.bin level06b.pak
	pack level06c.bin level06c.pak
	filejoin level06a.pak+level06b.pak+level06c.pak level06.pak

level07.pak: bg/level07.chr bg/level07.map bg/level07.blk bg/level07.lvz level07a.s level07b.s level07c.s define.s
	dasm level07a.s -olevel07a.bin -v3 -p3 -f3
	dasm level07b.s -olevel07b.bin -v3 -p3 -f3
	dasm level07c.s -olevel07c.bin -v3 -p3 -f3
	pack level07a.bin level07a.pak
	pack level07b.bin level07b.pak
	pack level07c.bin level07c.pak
	filejoin level07a.pak+level07b.pak+level07c.pak level07.pak

level08.pak: bg/level08.chr bg/level08.map bg/level08.blk bg/level08.lvz level08a.s level08b.s level08c.s define.s
	dasm level08a.s -olevel08a.bin -v3 -p3 -f3
	dasm level08b.s -olevel08b.bin -v3 -p3 -f3
	dasm level08c.s -olevel08c.bin -v3 -p3 -f3
	pack level08a.bin level08a.pak
	pack level08b.bin level08b.pak
	pack level08c.bin level08c.pak
	filejoin level08a.pak+level08b.pak+level08c.pak level08.pak

level09.pak: bg/level09.chr bg/level09.map bg/level09.blk bg/level09.lvz level09a.s level09b.s level09c.s define.s
	dasm level09a.s -olevel09a.bin -v3 -p3 -f3
	dasm level09b.s -olevel09b.bin -v3 -p3 -f3
	dasm level09c.s -olevel09c.bin -v3 -p3 -f3
	pack level09a.bin level09a.pak
	pack level09b.bin level09b.pak
	pack level09c.bin level09c.pak
	filejoin level09a.pak+level09b.pak+level09c.pak level09.pak

level10.pak: bg/level10.chr bg/level10.map bg/level10.blk bg/level10.lvz level10a.s level10b.s level10c.s define.s
	dasm level10a.s -olevel10a.bin -v3 -p3 -f3
	dasm level10b.s -olevel10b.bin -v3 -p3 -f3
	dasm level10c.s -olevel10c.bin -v3 -p3 -f3
	pack level10a.bin level10a.pak
	pack level10b.bin level10b.pak
	pack level10c.bin level10c.pak
	filejoin level10a.pak+level10b.pak+level10c.pak level10.pak

level11.pak: bg/level11.chr bg/level11.map bg/level11.blk bg/level11.lvz level11a.s level11b.s level11c.s define.s
	dasm level11a.s -olevel11a.bin -v3 -p3 -f3
	dasm level11b.s -olevel11b.bin -v3 -p3 -f3
	dasm level11c.s -olevel11c.bin -v3 -p3 -f3
	pack level11a.bin level11a.pak
	pack level11b.bin level11b.pak
	pack level11c.bin level11c.pak
	filejoin level11a.pak+level11b.pak+level11c.pak level11.pak

level12.pak: bg/level12.chr bg/level12.map bg/level12.blk bg/level12.lvz level12a.s level12b.s level12c.s define.s
	dasm level12a.s -olevel12a.bin -v3 -p3 -f3
	dasm level12b.s -olevel12b.bin -v3 -p3 -f3
	dasm level12c.s -olevel12c.bin -v3 -p3 -f3
	pack level12a.bin level12a.pak
	pack level12b.bin level12b.pak
	pack level12c.bin level12c.pak
	filejoin level12a.pak+level12b.pak+level12c.pak level12.pak

level13.pak: bg/level13.chr bg/level13.map bg/level13.blk bg/level13.lvz level13a.s level13b.s level13c.s define.s
	dasm level13a.s -olevel13a.bin -v3 -p3 -f3
	dasm level13b.s -olevel13b.bin -v3 -p3 -f3
	dasm level13c.s -olevel13c.bin -v3 -p3 -f3
	pack level13a.bin level13a.pak
	pack level13b.bin level13b.pak
	pack level13c.bin level13c.pak
	filejoin level13a.pak+level13b.pak+level13c.pak level13.pak

level14.pak: bg/level14.chr bg/level14.map bg/level14.blk bg/level14.lvz level14a.s level14b.s level14c.s define.s
	dasm level14a.s -olevel14a.bin -v3 -p3 -f3
	dasm level14b.s -olevel14b.bin -v3 -p3 -f3
	dasm level14c.s -olevel14c.bin -v3 -p3 -f3
	pack level14a.bin level14a.pak
	pack level14b.bin level14b.pak
	pack level14c.bin level14c.pak
	filejoin level14a.pak+level14b.pak+level14c.pak level14.pak

level15.pak: bg/level15.chr bg/level15.map bg/level15.blk bg/level15.lvz level15a.s level15b.s level15c.s define.s
	dasm level15a.s -olevel15a.bin -v3 -p3 -f3
	dasm level15b.s -olevel15b.bin -v3 -p3 -f3
	dasm level15c.s -olevel15c.bin -v3 -p3 -f3
	pack level15a.bin level15a.pak
	pack level15b.bin level15b.pak
	pack level15c.bin level15c.pak
	filejoin level15a.pak+level15b.pak+level15c.pak level15.pak

level16.pak: bg/level16.chr bg/level16.map bg/level16.blk bg/level16.lvz level16a.s level16b.s level16c.s define.s
	dasm level16a.s -olevel16a.bin -v3 -p3 -f3
	dasm level16b.s -olevel16b.bin -v3 -p3 -f3
	dasm level16c.s -olevel16c.bin -v3 -p3 -f3
	pack level16a.bin level16a.pak
	pack level16b.bin level16b.pak
	pack level16c.bin level16c.pak
	filejoin level16a.pak+level16b.pak+level16c.pak level16.pak

level17.pak: bg/level17.chr bg/level17.map bg/level17.blk bg/level17.lvz level17a.s level17b.s level17c.s define.s
	dasm level17a.s -olevel17a.bin -v3 -p3 -f3
	dasm level17b.s -olevel17b.bin -v3 -p3 -f3
	dasm level17c.s -olevel17c.bin -v3 -p3 -f3
	pack level17a.bin level17a.pak
	pack level17b.bin level17b.pak
	pack level17c.bin level17c.pak
	filejoin level17a.pak+level17b.pak+level17c.pak level17.pak

level18.pak: bg/level18.chr bg/level18.map bg/level18.blk bg/level18.lvz level18a.s level18b.s level18c.s define.s
	dasm level18a.s -olevel18a.bin -v3 -p3 -f3
	dasm level18b.s -olevel18b.bin -v3 -p3 -f3
	dasm level18c.s -olevel18c.bin -v3 -p3 -f3
	pack level18a.bin level18a.pak
	pack level18b.bin level18b.pak
	pack level18c.bin level18c.pak
	filejoin level18a.pak+level18b.pak+level18c.pak level18.pak

level19.pak: bg/level19.chr bg/level19.map bg/level19.blk bg/level19.lvz level19a.s level19b.s level19c.s define.s
	dasm level19a.s -olevel19a.bin -v3 -p3 -f3
	dasm level19b.s -olevel19b.bin -v3 -p3 -f3
	dasm level19c.s -olevel19c.bin -v3 -p3 -f3
	pack level19a.bin level19a.pak
	pack level19b.bin level19b.pak
	pack level19c.bin level19c.pak
	filejoin level19a.pak+level19b.pak+level19c.pak level19.pak

level20.pak: bg/level20.chr bg/level20.map bg/level20.blk bg/level20.lvz level20a.s level20b.s level20c.s define.s
	dasm level20a.s -olevel20a.bin -v3 -p3 -f3
	dasm level20b.s -olevel20b.bin -v3 -p3 -f3
	dasm level20c.s -olevel20c.bin -v3 -p3 -f3
	pack level20a.bin level20a.pak
	pack level20b.bin level20b.pak
	pack level20c.bin level20c.pak
	filejoin level20a.pak+level20b.pak+level20c.pak level20.pak

level21.pak: bg/level21.chr bg/level21.map bg/level21.blk bg/level21.lvz level21a.s level21b.s level21c.s define.s
	dasm level21a.s -olevel21a.bin -v3 -p3 -f3
	dasm level21b.s -olevel21b.bin -v3 -p3 -f3
	dasm level21c.s -olevel21c.bin -v3 -p3 -f3
	pack level21a.bin level21a.pak
	pack level21b.bin level21b.pak
	pack level21c.bin level21c.pak
	filejoin level21a.pak+level21b.pak+level21c.pak level21.pak

level22.pak: bg/level22.chr bg/level22.map bg/level22.blk bg/level22.lvz level22a.s level22b.s level22c.s define.s
	dasm level22a.s -olevel22a.bin -v3 -p3 -f3
	dasm level22b.s -olevel22b.bin -v3 -p3 -f3
	dasm level22c.s -olevel22c.bin -v3 -p3 -f3
	pack level22a.bin level22a.pak
	pack level22b.bin level22b.pak
	pack level22c.bin level22c.pak
	filejoin level22a.pak+level22b.pak+level22c.pak level22.pak

level23.pak: bg/level23.chr bg/level23.map bg/level23.blk bg/level23.lvz level23a.s level23b.s level23c.s define.s
	dasm level23a.s -olevel23a.bin -v3 -p3 -f3
	dasm level23b.s -olevel23b.bin -v3 -p3 -f3
	dasm level23c.s -olevel23c.bin -v3 -p3 -f3
	pack level23a.bin level23a.pak
	pack level23b.bin level23b.pak
	pack level23c.bin level23c.pak
	filejoin level23a.pak+level23b.pak+level23c.pak level23.pak

level24.pak: bg/level24.chr bg/level24.map bg/level24.blk bg/level24.lvz level24a.s level24b.s level24c.s define.s
	dasm level24a.s -olevel24a.bin -v3 -p3 -f3
	dasm level24b.s -olevel24b.bin -v3 -p3 -f3
	dasm level24c.s -olevel24c.bin -v3 -p3 -f3
	pack level24a.bin level24a.pak
	pack level24b.bin level24b.pak
	pack level24c.bin level24c.pak
	filejoin level24a.pak+level24b.pak+level24c.pak level24.pak

level25.pak: bg/level25.chr bg/level25.map bg/level25.blk bg/level25.lvz level25a.s level25b.s level25c.s define.s
	dasm level25a.s -olevel25a.bin -v3 -p3 -f3
	dasm level25b.s -olevel25b.bin -v3 -p3 -f3
	dasm level25c.s -olevel25c.bin -v3 -p3 -f3
	pack level25a.bin level25a.pak
	pack level25b.bin level25b.pak
	pack level25c.bin level25c.pak
	filejoin level25a.pak+level25b.pak+level25c.pak level25.pak

level26.pak: bg/level26.chr bg/level26.map bg/level26.blk bg/level26.lvz level26a.s level26b.s level26c.s define.s
	dasm level26a.s -olevel26a.bin -v3 -p3 -f3
	dasm level26b.s -olevel26b.bin -v3 -p3 -f3
	dasm level26c.s -olevel26c.bin -v3 -p3 -f3
	pack level26a.bin level26a.pak
	pack level26b.bin level26b.pak
	pack level26c.bin level26c.pak
	filejoin level26a.pak+level26b.pak+level26c.pak level26.pak


lvlact.pak: bg/lvlact.dat
	pack bg/lvlact.dat lvlact.pak

music/empty.bin: music/music.d64
	d642prg music/music.d64 empty.bin music/empty.bin

music00.pak: music/music.d64
	d642prg music/music.d64 title.bin music/title.bin
	pack music/title.bin music00.pak

music01.pak: music/music.d64
	d642prg music/music.d64 ansgaros2.bin music/ansgaros2.bin
	pack music/ansgaros2.bin music01.pak

music02.pak: music/music.d64
	d642prg music/music.d64 cadaver.bin music/cadaver.bin
	pack music/cadaver.bin music02.pak

music03.pak: music/music.d64
	d642prg music/music.d64 aeuk.bin music/aeuk.bin
	pack music/aeuk.bin music03.pak

music04.pak: music/music.d64
	d642prg music/music.d64 ansgaros1.bin music/ansgaros1.bin
	pack music/ansgaros1.bin music04.pak

music05.pak: music/music.d64
	d642prg music/music.d64 crow.bin music/crow.bin
	pack music/crow.bin music05.pak

music06.pak: music/music.d64
	d642prg music/music.d64 barfington.bin music/barfington.bin
	pack music/barfington.bin music06.pak

music07.pak: music/music.d64
	d642prg music/music.d64 cadaver2.bin music/cadaver2.bin
	pack music/cadaver2.bin music07.pak

music08.pak: music/music.d64
	d642prg music/music.d64 neomancia.bin music/neomancia.bin
	pack music/neomancia.bin music08.pak

music09.pak: music/music.d64
	d642prg music/music.d64 malekith.bin music/malekith.bin
	pack music/malekith.bin music09.pak

music10.pak: music/music.d64
	d642prg music/music.d64 warlord.bin music/warlord.bin
	pack music/warlord.bin music10.pak

music11.pak: music/music.d64
	d642prg music/music.d64 tara.bin music/tara.bin
	pack music/tara.bin music11.pak

music12.pak: music/music.d64
	d642prg music/music.d64 ending.bin music/ending.bin
	pack music/ending.bin music12.pak

music13.pak: music/music.d64
	d642prg music/music.d64 credits.bin music/credits.bin
	pack music/credits.bin music13.pak


agent.pak: spr/agent.spr
	sprconv spr/agent.spr agent.hdr agent.dat
	pack agent.dat agent.dat
	filejoin agent.hdr+agent.dat agent.pak

common.pak: spr/common.spr
	sprconv spr/common.spr common.hdr common.dat
	pack common.dat common.dat
	filejoin common.hdr+common.dat common.pak

lift.pak: spr/lift.spr
	sprconv spr/lift.spr lift.hdr lift.dat
	pack lift.dat lift.dat
	filejoin lift.hdr+lift.dat lift.pak

cop.pak: spr/cop.spr
	sprconv spr/cop.spr cop.hdr cop.dat
	pack cop.dat cop.dat
	filejoin cop.hdr+cop.dat cop.pak

ian.pak: spr/ian.spr
	sprconv spr/ian.spr ian.hdr ian.dat
	pack ian.dat ian.dat
	filejoin ian.hdr+ian.dat ian.pak

thugs.pak: spr/thugs.spr
	sprconv spr/thugs.spr thugs.hdr thugs.dat
	pack thugs.dat thugs.dat
	filejoin thugs.hdr+thugs.dat thugs.pak

inside.pak: spr/inside.spr
	sprconv spr/inside.spr inside.hdr inside.dat
	pack inside.dat inside.dat
	filejoin inside.hdr+inside.dat inside.pak

legs.pak: spr/legs.spr
	sprconv spr/legs.spr legs.hdr legs.dat
	pack legs.dat legs.dat
	filejoin legs.hdr+legs.dat legs.pak

tech.pak: spr/tech.spr
	sprconv spr/tech.spr tech.hdr tech.dat
	pack tech.dat tech.dat
	filejoin tech.hdr+tech.dat tech.pak

bystand.pak: spr/bystand.spr
	sprconv spr/bystand.spr bystand.hdr bystand.dat
	pack bystand.dat bystand.dat
	filejoin bystand.hdr+bystand.dat bystand.pak

scientis.pak: spr/scientis.spr
	sprconv spr/scientis.spr scientis.hdr scientis.dat
	pack scientis.dat scientis.dat
	filejoin scientis.hdr+scientis.dat scientis.pak

grunt.pak: spr/grunt.spr
	sprconv spr/grunt.spr grunt.hdr grunt.dat
	pack grunt.dat grunt.dat
	filejoin grunt.hdr+grunt.dat grunt.pak

commando.pak: spr/commando.spr
	sprconv spr/commando.spr commando.hdr commando.dat
	pack commando.dat commando.dat
	filejoin commando.hdr+commando.dat commando.pak

enemyage.pak: spr/enemyage.spr
	sprconv spr/enemyage.spr enemyage.hdr enemyage.dat
	pack enemyage.dat enemyage.dat
	filejoin enemyage.hdr+enemyage.dat enemyage.pak

priest.pak: spr/priest.spr
	sprconv spr/priest.spr priest.hdr priest.dat
	pack priest.dat priest.dat
	filejoin priest.hdr+priest.dat priest.pak

turret.pak: spr/turret.spr
	sprconv spr/turret.spr turret.hdr turret.dat
	pack turret.dat turret.dat
	filejoin turret.hdr+turret.dat turret.pak

heavytur.pak: spr/heavytur.spr
	sprconv spr/heavytur.spr heavytur.hdr heavytur.dat
	pack heavytur.dat heavytur.dat
	filejoin heavytur.hdr+heavytur.dat heavytur.pak

robot.pak: spr/robot.spr
	sprconv spr/robot.spr robot.hdr robot.dat
	pack robot.dat robot.dat
	filejoin robot.hdr+robot.dat robot.pak

spider.pak: spr/spider.spr
	sprconv spr/spider.spr spider.hdr spider.dat
	pack spider.dat spider.dat
	filejoin spider.hdr+spider.dat spider.pak

copter.pak: spr/copter.spr
	sprconv spr/copter.spr copter.hdr copter.dat
	pack copter.dat copter.dat
	filejoin copter.hdr+copter.dat copter.pak

iac.pak: spr/iac.spr
	sprconv spr/iac.spr iac.hdr iac.dat
	pack iac.dat iac.dat
	filejoin iac.hdr+iac.dat iac.pak

exoskele.pak: spr/exoskele.spr
	sprconv spr/exoskele.spr exoskele.hdr exoskele.dat
	pack exoskele.dat exoskele.dat
	filejoin exoskele.hdr+exoskele.dat exoskele.pak

mutant1.pak: spr/mutant1.spr
	sprconv spr/mutant1.spr mutant1.hdr mutant1.dat
	pack mutant1.dat mutant1.dat
	filejoin mutant1.hdr+mutant1.dat mutant1.pak

mutant2.pak: spr/mutant2.spr
	sprconv spr/mutant2.spr mutant2.hdr mutant2.dat
	pack mutant2.dat mutant2.dat
	filejoin mutant2.hdr+mutant2.dat mutant2.pak

hover.pak: spr/hover.spr
	sprconv spr/hover.spr hover.hdr hover.dat
	pack hover.dat hover.dat
	filejoin hover.hdr+hover.dat hover.pak

blackhan.pak: spr/blackhan.spr
	sprconv spr/blackhan.spr blackhan.hdr blackhan.dat
	pack blackhan.dat blackhan.dat
	filejoin blackhan.hdr+blackhan.dat blackhan.pak

blowfish.pak: spr/blowfish.spr
	sprconv spr/blowfish.spr blowfish.hdr blowfish.dat
	pack blowfish.dat blowfish.dat
	filejoin blowfish.hdr+blowfish.dat blowfish.pak

goat.pak: spr/goat.spr
	sprconv spr/goat.spr goat.hdr goat.dat
	pack goat.dat goat.dat
	filejoin goat.hdr+goat.dat goat.pak

joan.pak: spr/joan.spr
	sprconv spr/joan.spr joan.hdr joan.dat
	pack joan.dat joan.dat
	filejoin joan.hdr+joan.dat joan.pak

band.pak: spr/band.spr
	sprconv spr/band.spr band.hdr band.dat
	pack band.dat band.dat
	filejoin band.hdr+band.dat band.pak

sentinel.pak: spr/sentinel.spr
	sprconv spr/sentinel.spr sentinel.hdr sentinel.dat
	pack sentinel.dat sentinel.dat
	filejoin sentinel.hdr+sentinel.dat sentinel.pak

title.pak: bg/title.chr title.s mw4.pak
	dasm title.s -otitle.bin -v3 -p3 -f3
	pack title.bin title.pak

map.pak: map.s mw4.pak
	dasm map.s -omap.bin -v3 -p3 -f3
	pack map.bin map.pak

faces.pak: bg/faces.chr faces.s
	pack bg/faces.chr faces.pak

script01.pak: script01.s scriptm.s mw4.pak
	dasm script01.s -oscript01.bin -v3 -p3 -f3
	pack script01.bin script01.pak

script02.pak: script02.s scriptm.s mw4.pak
	dasm script02.s -oscript02.bin -v3 -p3 -f3
	pack script02.bin script02.pak

script03.pak: script03.s scriptm.s mw4.pak
	dasm script03.s -oscript03.bin -v3 -p3 -f3
	pack script03.bin script03.pak

script04.pak: script04.s scriptm.s mw4.pak
	dasm script04.s -oscript04.bin -v3 -p3 -f3
	pack script04.bin script04.pak

script05.pak: script05.s scriptm.s mw4.pak
	dasm script05.s -oscript05.bin -v3 -p3 -f3
	pack script05.bin script05.pak

script06.pak: script06.s scriptm.s mw4.pak
	dasm script06.s -oscript06.bin -v3 -p3 -f3
	pack script06.bin script06.pak

script07.pak: script07.s scriptm.s mw4.pak
	dasm script07.s -oscript07.bin -v3 -p3 -f3
	pack script07.bin script07.pak

script08.pak: script08.s scriptm.s mw4.pak
	dasm script08.s -oscript08.bin -v3 -p3 -f3
	pack script08.bin script08.pak

script09.pak: script09.s scriptm.s mw4.pak
	dasm script09.s -oscript09.bin -v3 -p3 -f3
	pack script09.bin script09.pak

script10.pak: script10.s scriptm.s mw4.pak
	dasm script10.s -oscript10.bin -v3 -p3 -f3
	pack script10.bin script10.pak

script11.pak: script11.s scriptm.s mw4.pak
	dasm script11.s -oscript11.bin -v3 -p3 -f3
	pack script11.bin script11.pak

script12.pak: script12.s scriptm.s mw4.pak
	dasm script12.s -oscript12.bin -v3 -p3 -f3
	pack script12.bin script12.pak

script13.pak: script13.s scriptm.s mw4.pak
	dasm script13.s -oscript13.bin -v3 -p3 -f3
	pack script13.bin script13.pak

script14.pak: script14.s scriptm.s mw4.pak
	dasm script14.s -oscript14.bin -v3 -p3 -f3
	pack script14.bin script14.pak

script15.pak: script15.s scriptm.s mw4.pak
	dasm script15.s -oscript15.bin -v3 -p3 -f3
	pack script15.bin script15.pak

script16.pak: script16.s scriptm.s mw4.pak
	dasm script16.s -oscript16.bin -v3 -p3 -f3
	pack script16.bin script16.pak

script17.pak: script17.s scriptm.s mw4.pak
	dasm script17.s -oscript17.bin -v3 -p3 -f3
	pack script17.bin script17.pak

script18.pak: script18.s scriptm.s mw4.pak
	dasm script18.s -oscript18.bin -v3 -p3 -f3
	pack script18.bin script18.pak

script19.pak: script19.s scriptm.s mw4.pak
	dasm script19.s -oscript19.bin -v3 -p3 -f3
	pack script19.bin script19.pak

script20.pak: script20.s scriptm.s mw4.pak
	dasm script20.s -oscript20.bin -v3 -p3 -f3
	pack script20.bin script20.pak

script21.pak: script21.s scriptm.s mw4.pak
	dasm script21.s -oscript21.bin -v3 -p3 -f3
	pack script21.bin script21.pak

script22.pak: script22.s scriptm.s mw4.pak
	dasm script22.s -oscript22.bin -v3 -p3 -f3
	pack script22.bin script22.pak

script23.pak: script23.s scriptm.s mw4.pak
	dasm script23.s -oscript23.bin -v3 -p3 -f3
	pack script23.bin script23.pak

script24.pak: script24.s scriptm.s mw4.pak
	dasm script24.s -oscript24.bin -v3 -p3 -f3
	pack script24.bin script24.pak

script25.pak: script25.s scriptm.s mw4.pak
	dasm script25.s -oscript25.bin -v3 -p3 -f3
	pack script25.bin script25.pak

script26.pak: script26.s scriptm.s mw4.pak
	dasm script26.s -oscript26.bin -v3 -p3 -f3
	pack script26.bin script26.pak

script27.pak: script27.s scriptm.s mw4.pak
	dasm script27.s -oscript27.bin -v3 -p3 -f3
	pack script27.bin script27.pak

script28.pak: script28.s scriptm.s mw4.pak
	dasm script28.s -oscript28.bin -v3 -p3 -f3
	pack script28.bin script28.pak

script29.pak: script29.s scriptm.s mw4.pak
	dasm script29.s -oscript29.bin -v3 -p3 -f3
	pack script29.bin script29.pak

script30.pak: script30.s scriptm.s mw4.pak
	dasm script30.s -oscript30.bin -v3 -p3 -f3
	pack script30.bin script30.pak



