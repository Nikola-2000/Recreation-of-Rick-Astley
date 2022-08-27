s.boot;
s.recHeaderFormat = "wav";

(
  var notes, on, off, ctrl,lastSawCutoff=0, midiz, lastDecay=0, tempo=2,
 lastPlayed=0, seqPlaying=0, rootine, noteDur, notez, counter=0,recording=0;

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

 ~synthBuff = Buffer.read(s, "../LayeredClap/LayeredClap.Wav");
  SynthDef.new(\Synth,{
	arg amp=1, note=50, buffer, attack=0.02,decay=0.01,sustain=1,release=3;
	var signal, bufferSignal, env;
	bufferSignal = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer), doneAction: 2) * amp ! 10;
	signal = ((bufferSignal * 1000) / 44100);
	env = EnvGen.ar(Env([0,1,0.7,0.4,0], [attack,decay,sustain,release]), doneAction:2);
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
		notes[noteNum] = Synth(\Synth, [
				\note,   noteNum.midicps,
				\buffer, ~synthBuff
			]);
	});
	releaseFunc.value(noteNum);
  });

  ctrl = MIDIFunc.cc({
	arg veloc, sliderNum, chan, src;

	if ( sliderNum==119,
		{
			if(veloc == 127, {
				recording = 1;
				s.record(path: "../Recordings/LayeredClap.Wav", numChannels:2);
				wait(0.02);
			}, {
				s.stopRecording;
			});
		}
	);
  });

  q = { on.free; ctrl.free; };
)