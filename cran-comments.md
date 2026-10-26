## Test environments

* Windows Server 2022, R-oldrelease (4.5.3) and R-devel, via win-builder
* GitHub Actions: Ubuntu, Windows and macOS with R-devel, R-release and
  R-oldrel-1

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission.
* 'Likert' (the Likert scale) and 'RII' (Relative Importance Index) are
  correct technical terms, not misspellings.

## Notes

* The packages 'readxl', 'openxlsx' and 'haven' are in Suggests. Functions
  that need them check for them with `requireNamespace()` and give a clear
  error if they are missing; examples and tests that use them are guarded.
* The package name 'RII' is used by an unrelated, archived CRAN package, so
  this package is submitted as 'LikertRII'.