120 => float bpm;
4 => int hhRow;

Launchpad.Launchpad(0) @=> Launchpad lp;

fun void loopSample(string filename, dur beat)
{
    beat - (now % beat) => now; // puts you in sync the first time
    SndBuf buf => dac;
    filename => buf.read;
    while(true)
    {
        0 => buf.pos;
        1 => buf.rate;
        beat - (now % beat) => now;
    }
}

fun void boxHandler(Box box, string filename)
{
    Shred @ currentShred[8];
    while(true)
    {
        box.e => now;
        2::minute / bpm => dur beat;
        beat / Math.pow(2, box.e.column) => beat;
        if(box.e.velocity == 127)
            spork ~ loopSample(filename, beat) @=> currentShred[box.e.column];
        else
            Machine.remove(currentShred[box.e.column].id());
    }
}

fun void sampleRow(int rowNum, string filename)
{
    Box box;
    box.init(lp, 0, rowNum, 8, 1);
    spork ~ boxHandler(box, filename);
}

sampleRow(7, "inst/808/media/shake.wav");
sampleRow(6, "inst/808/media/click.wav");
sampleRow(5, "inst/808/media/alien.wav");
sampleRow(4, "inst/808/media/clap.wav");
sampleRow(3, "inst/808/media/hh.wav");
sampleRow(2, "inst/808/media/snare.wav");
sampleRow(1, "inst/808/media/kick_short.wav");
sampleRow(0, "inst/808/media/kick_long.wav");

while(true) { 100::ms => now; }
