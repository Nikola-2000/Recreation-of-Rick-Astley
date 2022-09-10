s.boot;

(
SynthDef.new(\to_rick_roll_a_butterfly, {
	arg out=0, amp=1;
	var rick, intro, bass, brass, chorus, clap, hihat, kick, lclap, openhat, pad, rbrass, rhodes, verseSuperSaw, shaker, master;
	bass = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/Bass.wav");
	brass = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/Brass.wav");
	chorus = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/ChrousStrings.wav");
	clap = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/ClapSynth.wav");
	hihat = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/HiHat.wav");
	intro = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/IntroToms.wav");
	kick = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/KickSynth.wav");
	lclap = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/LClapSynth.wav");
	openhat = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/OpenHat.wav");
	pad = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/Pad.wav");
	rbrass = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/PassingBrass.wav");
	rhodes = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/Rhodes.wav");
	verseSuperSaw = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/VerseSuperSaw.wav");
	shaker = Buffer.read(s,"C:/Users/Darko/Desktop/b/Faza 2A/Recordings/Shaker.wav");
	rick = Buffer.read(s,"C:/Users/Darko/Desktop/Faza 2B/Rick Astley Synth Voice Project.wav");

	rick = PlayBuf.ar(2, rick.bufnum, BufRateScale.kr(rick), doneAction: 2);
	rick = BHiPass.ar(rick, freq: 20, rq: 0.5);
	rick = BPeakEQ.ar(rick, freq: 50, rq: 1, db: 2);
	rick = BLowPass.ar(rick, freq: 10000, rq: 0.9);

	kick = PlayBuf.ar(2, kick.bufnum, BufRateScale.kr(kick), doneAction: 2);
	kick = DCompressor.ar(kick, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	kick = BHiPass.ar(kick, freq: 20, rq: 0.5);
	kick = BPeakEQ.ar(kick, freq: 50, rq: 1, db: 2);
	kick = BLowPass.ar(kick, freq: 1000, rq: 0.9);

	brass = PlayBuf.ar(2, brass.bufnum, BufRateScale.kr(brass), doneAction: 2);
	brass = DCompressor.ar(brass, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	brass = BHiPass.ar(brass, freq: 20, rq: 0.5);
	brass = BPeakEQ.ar(brass, freq: 50, rq: 1, db: 2);
	brass = BLowPass.ar(brass, freq: 10000, rq: 0.9);

	bass = PlayBuf.ar(2, bass.bufnum, BufRateScale.kr(bass), doneAction: 2);
	bass = DCompressor.ar(bass, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	bass = BHiPass.ar(bass, freq: 20, rq: 0.5);
	bass = BPeakEQ.ar(bass, freq: 50, rq: 1, db: 2);
	bass = BLowPass.ar(bass, freq: 10000, rq: 0.9);

	rbrass = PlayBuf.ar(2, rbrass.bufnum, BufRateScale.kr(rbrass), doneAction: 2);
	rbrass = DCompressor.ar(rbrass, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	rbrass = BHiPass.ar(rbrass, freq: 20, rq: 0.5);
	rbrass = BPeakEQ.ar(rbrass, freq: 50, rq: 1, db: 2);
	rbrass = BLowPass.ar(rbrass, freq: 10000, rq: 0.9);

	chorus = PlayBuf.ar(2, chorus.bufnum, BufRateScale.kr(chorus), doneAction: 2);
	chorus = DCompressor.ar(chorus, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	chorus = BHiPass.ar(chorus, freq: 20, rq: 0.5);
	chorus = BPeakEQ.ar(chorus, freq: 50, rq: 1, db: 2);
	chorus = BLowPass.ar(chorus, freq: 10000, rq: 0.9);

	clap = PlayBuf.ar(2, clap.bufnum, BufRateScale.kr(clap), doneAction: 2);
	clap = DCompressor.ar(clap, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	clap = BHiPass.ar(clap, freq: 20, rq: 0.5);
	clap = BPeakEQ.ar(clap, freq: 50, rq: 1, db: 2);
	clap = BLowPass.ar(clap, freq: 500);

	lclap = PlayBuf.ar(2, lclap.bufnum, BufRateScale.kr(lclap), doneAction: 2);
	lclap = DCompressor.ar(lclap, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	lclap = BHiPass.ar(lclap, freq: 20, rq: 0.5);
	lclap = BPeakEQ.ar(lclap, freq: 50, rq: 1, db: 2);
	lclap = BLowPass.ar(lclap, freq: 500);

	hihat = PlayBuf.ar(2, hihat.bufnum, BufRateScale.kr(hihat), doneAction: 2);
	hihat = DCompressor.ar(hihat, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	hihat = BHiPass.ar(hihat, freq: 20, rq: 0.5);
	hihat = BPeakEQ.ar(hihat, freq: 50, rq: 1, db: 2);
	hihat = BLowPass.ar(hihat, freq: 10000, rq: 0.9);

	openhat = PlayBuf.ar(2, openhat.bufnum, BufRateScale.kr(openhat), doneAction: 2);
	openhat = DCompressor.ar(openhat, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	openhat = BHiPass.ar(openhat, freq: 20, rq: 0.5);
	openhat = BPeakEQ.ar(openhat, freq: 50, rq: 1, db: 2);
	openhat = BLowPass.ar(openhat, freq: 10000, rq: 0.9);

	intro = PlayBuf.ar(2, intro.bufnum, BufRateScale.kr(intro), doneAction: 2);
	intro = DCompressor.ar(intro, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	intro = BHiPass.ar(intro, freq: 20, rq: 0.5);
	intro = BPeakEQ.ar(intro, freq: 50, rq: 1, db: 2);
	intro = BLowPass.ar(intro, freq: 10000, rq: 0.9);

	pad = PlayBuf.ar(2, pad.bufnum, BufRateScale.kr(pad), doneAction: 2);
	pad = DCompressor.ar(pad, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	pad = BHiPass.ar(pad, freq: 20, rq: 0.5);
	pad = BPeakEQ.ar(pad, freq: 50, rq: 1, db: 2);
	pad = BLowPass.ar(pad, freq: 10000, rq: 0.9);

	rhodes = PlayBuf.ar(2, rhodes.bufnum, BufRateScale.kr(rhodes), doneAction: 2);
	rhodes = DCompressor.ar(rhodes, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	rhodes = BHiPass.ar(rhodes, freq: 20, rq: 0.5);
	rhodes = BPeakEQ.ar(rhodes, freq: 50, rq: 1, db: 2);
	rhodes = BLowPass.ar(rhodes, freq: 10000, rq: 0.9);

	verseSuperSaw = PlayBuf.ar(2, verseSuperSaw.bufnum, BufRateScale.kr(verseSuperSaw), doneAction: 2);
	verseSuperSaw = DCompressor.ar(verseSuperSaw, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	verseSuperSaw = BHiPass.ar(verseSuperSaw, freq: 20, rq: 0.5);
	verseSuperSaw = BPeakEQ.ar(verseSuperSaw, freq: 50, rq: 1, db: 2);
	verseSuperSaw = BLowPass.ar(verseSuperSaw, freq: 10000, rq: 0.9);

	shaker = PlayBuf.ar(2, shaker.bufnum, BufRateScale.kr(shaker), doneAction: 2);
	shaker = DCompressor.ar(shaker, sidechain: 0, ratio: 4, threshold: -20, attack: 30, release: 39.5, automakeup: 0);
	shaker = BHiPass.ar(shaker, freq: 20, rq: 0.5);
	shaker = BPeakEQ.ar(shaker, freq: 50, rq: 1, db: 2);
	shaker = BLowPass.ar(shaker, freq: 10000, rq: 0.9);

	master = Mix([intro, rick, bass, brass, chorus, clap, hihat, kick, lclap, openhat, pad, rbrass, rhodes, verseSuperSaw, shaker]);

	master = BHiPass.ar(master, freq: 12, rq: 1.0);
	master = BPeakEQ.ar(master, freq: 30, rq: 1.0, db: 1.0);
	master = BPeakEQ.ar(master, freq: 200.5, rq: 0.5, db: -1.0);
	master = BPeakEQ.ar(master, freq: 500, rq: 0.3, db: 0.5);
	master = BPeakEQ.ar(master, freq: 10000, rq: 1.5, db: 0.9);
	master = BLowPass.ar(master, freq: 10000, rq: 0.9);
	 master =  DCompressor.ar(master, ratio: 8, threshold: -20, attack: 30, release: 1, makeup: 0);
	master =  Limiter.ar(master, level: -1, dur: 0.04);

	Out.ar(out, master * amp);
}
).add;)

Synth(\to_rick_roll_a_butterfly);