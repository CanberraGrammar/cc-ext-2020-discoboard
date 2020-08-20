# Week 5 - Audio

This week we'll be moving on to something exciting -- playing sounds out of the audio jack on the discoboard.

It sounds like quite a complex task, but we'll make sure to take it slow, and explain things that need to be explained.

First off, let's talk about sound.

## So, what is audio?

It's likely that you've seen this kind of thing before in audio editing software, or something:
![](images/audio_example.png)
but what does it represent?

Well, as most of you probably know, it represents a *waveform* -- a digital representation of all of the different waves needed to make the sound that you hear.

Each *wave* has a centre line -- at zero -- and the points along the *wave* are different outputs at a time that varies based on the *sample-rate*.

Let's take a really simple example:

![](images/simple_wave.png)

Here, assuming the time (x axis) is measured in milliseconds, and the output has a *range* from 10 to -10, we have a *triangle* wave, with a *period* of 10ms.

Since we have one point every millisecond, the placement of the markers also implies a *sample-rate* of 1000hz -- or 1000 audio changes per-second.

Finally, a wave with a *period* of 10ms, will have a *frequency* of 100hz: *frequency (hz) = 1000/period (ms)*.

If we were to play the same sounding wave, at a sample rate of 2000hz (double our sample-rate), we would need *double* the samples:

![](images/simple_wave_2.png)

To reiterate then:

* *sample rate* is the number of discrete points that an audio device outputs per second.

* *frequency* is the number of oscilations (that is, full-cycles) that a specific wave will undertake per second.

* *period* is the amount of time that it takes a specific wave to do one oscilation.

* *output* is the actual digital signal to output (usually converted to volts).

* *frequency* and *period* are both related (frequency is the reciprocal of period, and obviously the opposite is true).

There's one more major thing we need to understand before we can think about making sound:

In order to make a sound with a specific *frequency* we need to know the *sample-rate* that we are working with, in order to find out the number of *samples per wave*. Let's say, for instance, that we're working with a device that has a sample rate of 44000hz.

If we want to play a wave with a *frequency* of 440hz, we're going to need *100 samples-per-wave* to produce that sound, as *44000 / 440 = 100*.

Similarly, if we wanted to play a wave with a *frequency* of 880hz, we'd need *50 samples-per-wave* to produce that sound, since *44000 / 880 = 50*. This should hopefully begin to make intuitive sense -- 880hz is *double* the frequency of 440hz, so as a result, since we have the same *sample-rate* we can only use *half* the number of *samples-per-wave*.

Hopefully, that all makes sense. To make sure you get understand basically what's going on, here's one last thing:

The Discoboard has a sample-rate of *48000hz*. How many *samples-per-wave* will you need to use in order to produce a sound that is *240hz*?

### One final note on waves

We've talked about output as being the representation of the output of the wave, at a certain point. The last really important thing to know about sound is this: the volume of a sound is not proportional to the *average output*, which, at first may not make sense.

But think for a minute about sound, as if it were waves on the ocean. Here, zero output is the average level of the sea. Positive output is therefore when the water is above this average, and negative output is when the water is below this average.

If the water in some location spends more time above the "average" line, does that imply that the *waves* are larger?

![](images/simple_wave_3.png)
![](images/simple_wave_2.png)

Hopefully, not. The size of each *wave* is dependent on the difference between the highest output -- at the *peak* -- and the lowest output -- the *trough*. This metric is called the *amplitude* of the wave.

## Making a sound
