s.boot;
s.recHeaderFormat = "wav";

(
  var notes, on, off, ctrl,lastSawCutoff=0, midiz, lastDecay=0, tempo=1,
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
				Synth(\clap, [
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

 ~synthBuff = SynthDef(\clap, {
    |out = 0, amp = 0.5, pan = 0, dur = 1|
    var env1, env2, snd, noise1, noise2;
    env1 = EnvGen.ar(
        Env.new(
            [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            [0.001, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            [0, -3, 0, -3, 0, -3, 0, -4]
        )
    );

    noise1 = WhiteNoise.ar(env1);
    noise1 = HPF.ar(noise1, 600);
    noise1 = LPF.ar(noise1, XLine.kr(7200, 4000, 0.03));
    noise1 = BPF.ar(noise1, 1620, 3);
    env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.18], [0, -4]), doneAction:2);

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(noise2, 1000);
    noise2 = LPF.ar(noise2, 7600);
    noise2 = BPF.ar(noise2, 1230, 0.7, 0.7);

    snd = noise1 + noise2;
    snd = snd * 2;
    snd = snd.softclip;

    Out.ar(out, Pan2.ar(snd,pan,amp));
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
		notes[noteNum] = Synth(\clap, [
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
				s.record(path: "../Recordings/LClapSynth.Wav", numChannels:2);
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
