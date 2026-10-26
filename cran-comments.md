## Submission

This is a new submission (version 0.1.0).

## Test environments

* local Windows install, R release
* GitHub Actions (R-CMD-check workflow): Ubuntu, Windows and macOS with
  R-devel, R-release and R-oldrel-1
* win-builder (R-devel): <add result before submitting>

## R CMD check results

0 errors | 0 warnings | 0 notes

(Edit this section to match your final `R CMD check --as-cran` output.
 "New submission" will appear as a NOTE from CRAN's incoming checks.)

## Notes

* The packages 'readxl', 'openxlsx' and 'haven' are in Suggests. Functions
  that need them check for them with `requireNamespace()` and give a clear
  error if they are missing; examples and tests that use them are guarded.
  
* 'Likert' (the Likert scale) and 'RII' (Relative Importance Index) are
  correct technical terms, not misspellings.
