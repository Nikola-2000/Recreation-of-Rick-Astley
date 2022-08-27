s.boot;
s.recHeaderFormat = "wav";

(
  var notes, on, off, ctrl,lastSawCutoff=0, midiz, lastDecay=0, tempo=2.0,
 lastPlayed=0, seqPlaying=0, rootine, noteDur, notez, counter=0,recording=0, recording2=0;

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
				Synth(\kick, [
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

 ~synthBuff = SynthDef(\kick, {
 	|out = 0, pan = 0, amp = 0.3|
 	var body, bodyFreq, bodyAmp;
 	var pop, popFreq, popAmp;
 	var click, clickAmp;
	var snd;
bodyFreq = EnvGen.ar(Env([261, 120, 51], [0.035, 0.08], curve: \exp));
 	bodyAmp = EnvGen.ar(Env.linen(0.005, 0.1, 0.3), doneAction: 2);
 	body = SinOsc.ar(bodyFreq) * bodyAmp;
 	popFreq = XLine.kr(750, 261, 0.02);
 	popAmp = EnvGen.ar(Env.linen(0.001, 0.02, 0.001)) * 0.15;
 	pop = SinOsc.ar(popFreq) * popAmp;
 	clickAmp = EnvGen.ar(Env.perc(0.001, 0.01)) * 0.15;
 	click = LPF.ar(Formant.ar(910, 4760, 2110), 3140) * clickAmp;
 	snd = body + pop + click;
 	snd = snd.tanh;
 	Out.ar(out, Pan2.ar(snd, pan, amp));
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
		notes[noteNum] = Synth(\kick, [
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
				recording2 = 1;
				s.record(path: "../Recordings/KickSynth.Wav", numChannels:2);
				wait(0.02);
			}, {
				s.stopRecording;
			});
		}
	);

	if ( sliderNum==121,
		{
			playFunc.value(veloc);
		}
	);
  });

  q = { on.free; ctrl.free; };
)
