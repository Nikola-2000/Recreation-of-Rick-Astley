s.boot;
s.recHeaderFormat = "wav";

(
  var notes, on, off, ctrl,lastSawCutoff=0, midiz, lastDecay=0, tempo=2,
 lastPlayed=0, seqPlaying=0, rootine, noteDur, notez, counter=0,recording=0, recording2= 0;

  var releaseFunc = {
	arg i;
	if(notes[i].notNil) {

		notes[i].release;
		notes[i] = nil;
		lastPlayed = 0;
	}
  };

  var playFunc = {
	arg playFlag;

	if(playFlag == 127, {
		seqPlaying=1;
		TempoClock.default.tempo = tempo;
		rootine = Task({
			var delta;
			while {
				delta=noteDur.next;
				delta.notNil
			}
			{
				Synth(\Synth, [
					\freq, midiz.next.midicps,
					\sawCutoff, lastSawCutoff,
					\decay, lastDecay,
				]);
				delta.yield;
			}
		});
		rootine.play(quant: TempoClock.default.tempo_(tempo).beats);
	}, { rootine.stop; seqPlaying=0; });
  };

  notes = Array.newClear(128);
  notez = Array.newClear(16);
  notez = [60, 62, 64, 65, 67, 69, 71, 72,
	       60, 62, 64, 65, 67, 69, 71, 72];

 ~synthBuff = Buffer.read(s, "../Pad/Pad1.Wav");
  SynthDef.new(\Synth,{
	arg amp=1, note=50, buffer, attack=0.02,decay=0.01,sustain=1,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 10;
	signal = ((bufferSignal * 1000) / 44100);
	env = EnvGen.ar(Env([0,1,0.7,0.4,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

~synthBuff2 = Buffer.read(s, "../Pad/Pad2.Wav");
 SynthDef.new(\Synth, {
	arg amp=2, note=50, buffer, attack=0.02,decay=0.01,sustain=0.2,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 5;
	signal = ((bufferSignal * 1000) / 44100) ;
	env = EnvGen.ar(Env([0,1,0.7,0.7,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

~synthBuff3 = Buffer.read(s, "../Pad/Pad3.Wav");
 SynthDef.new(\Synth, {
	arg amp=2, note=50, buffer, attack=0.02,decay=0.01,sustain=0.2,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 5;
	signal = ((bufferSignal * 1000) / 44100) ;
	env = EnvGen.ar(Env([0,1,0.7,0.7,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

~synthBuff4 = Buffer.read(s, "../Pad/Pad4.Wav");
 SynthDef.new(\Synth, {
	arg amp=2, note=50, buffer, attack=0.02,decay=0.01,sustain=0.2,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 5;
	signal = ((bufferSignal * 1000) / 44100) ;
	env = EnvGen.ar(Env([0,1,0.7,0.7,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

~synthBuff5 = Buffer.read(s, "../Pad/Pad5.Wav");
 SynthDef.new(\Synth, {
	arg amp=2, note=50, buffer, attack=0.02,decay=0.01,sustain=0.2,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 5;
	signal = ((bufferSignal * 1000) / 44100) ;
	env = EnvGen.ar(Env([0,1,0.7,0.7,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

~synthBuff6 = Buffer.read(s, "../Pad/Pad6.Wav");
 SynthDef.new(\Synth, {
	arg amp=2, note=50, buffer, attack=0.02,decay=0.01,sustain=0.2,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(2, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 5;
	signal = ((bufferSignal * 1000) / 44100) ;
	env = EnvGen.ar(Env([0,1,0.7,0.7,0], [attack,decay,sustain,release]), doneAction:2);
	signal = signal*amp*env;
	Out.ar(0,signal.dup(2));
  }).add;

  midiz =  Pseq(
	notez
	, inf).asStream;

  noteDur = Pseq(
	[
		1
	], inf).asStream;

  MIDIClient.init;
  MIDIIn.connectAll;

  on = MIDIFunc.noteOn({
	arg veloc, noteNum, chan, src;
	lastPlayed = noteNum;

	if(recording == 1 , {
		if(counter == 15, {
			counter = 0;
		});

		notez[counter] = noteNum;
		counter = counter+1;
		midiz =  Pseq(notez, 1).asStream;
	});

	if(recording == 0, {
		if(noteNum == 21, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff
			]);
		});
		if(noteNum == 22, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff2
			]);
		});
		if(noteNum == 23, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff3
			]);
		});
		if(noteNum == 24, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff4
			]);
		});
		if(noteNum == 25, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff5
			]);
		});
		if(noteNum == 26, {
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff6
			]);
		});
	});
	releaseFunc.value(noteNum);
  });

  ctrl = MIDIFunc.cc({
	arg veloc, sliderNum, chan, src;

	if ( sliderNum==119,
		{
			if(veloc == 127, {
				recording2 = 1;
				s.record(path: "../Recordings/Pad.Wav", numChannels:2);
				wait(0.02);
			}, {
				s.stopRecording;
			});
		}
	);

  });

  q = { on.free; ctrl.free; };
)