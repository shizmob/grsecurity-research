## Progress

Phase 1:

```
» ./scripts/progress.sh
split hunks: 1519 (14%)
remaining hunks: 9376
total hunks: 10863
```

## Disclaimer

I stepped into this with only an end-user's knowledge of grsecurity/PaX, and thus may categorize or split stuff wrong. Be aware of this, and suggestions are of course welcome.
The point is mostly learning how grsecurity and PaX work internally, properly.

## Phases

1. **(current)** Split up `grsecurity-3.1-4.9.24-201704252333.patch` into semantically meaningful tinier patches, grouped by feature they are implementing;
2. From smaller patches, gain knowledge about how the features work exactly, together with docs at https://pax.grsecurity.net/docs, https://forums.grsecurity.net/viewforum.php?f=7 and https://forums.grsecurity.net/viewforum.php?f=1;
   * Maybe ask spender or pipacs about specific still-hard-to-understand stuff after reading the above if they're feeling charitable?
3. ???
4. Profit? Maybe at least a tinier degree more maintainability.

## Structure

* `original`: Original patches, unmodified:
  - `pax-linux-4.9.24-test7.patch`: Unmodified PaX 4.9.24-test7 patch from https://grsecurity.net/~paxguy1/pax-linux-4.9.24-test7.patch;
  - `grsecurity-3.1-4.9.24-201704252333.patch`: Unmodified grsecurity 3.1 4.9.24-201704252333 patch from https://grsecurity.net/~spender/grsecurity-3.1-4.9.24-201704252333.patch (now removed);
  - `grsecurity-nopax-3.1-4.9.24-201704252333.patch`: 'Split' grsecurity patch obtained by diffing an applied unedited `grsecurity-3.1-4.9.24-201704252333.patch` tree against an applied unedited `pax-linux-4.9.24-test7.patch` tree. `no-pax` is a bit of a misnomer, as it still has PaX changes and is based on PaX: it just doesn't include the PaX base;
* `split`: The split up patches;
  - `split/00-misc`: Features that don't specifically belong to PaX or grsecurity like general cleanups;
  - `split/01-pax`: PaX features;
  - `split/01-pax/zz-unsplit/unsplit-pax-linux-4.9.24-test7.patch`: The unsplit remainder of the original PaX patch;
  - `split/02-grsec`: grsecurity features;
  - `split/02-grsec/zz-unsplit/unsplit-grsecurity-nopax-3.1-4.9.24-201704252333.patch`: The unsplit remainder of the diffed grsecurity patch;
* `scripts`: Scripts to help the splitting process;
* `notes.txt`: Random notes taken by me while splitting up, may contain useful stuff, most likely not.

## Scripts

* `scripts/progress.sh`: Show progress in terms of split-up hunks;
* `scripts/patch.sh`: Fetch Linux 4.9.24 and (re-)apply the current split-up patchset against it;
* `scripts/compare.sh`: Compare the split-up patched kernel against a kernel patched with the original patch, to detect mistakes made during the splitting process.
