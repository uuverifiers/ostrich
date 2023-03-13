(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (\bR(\.|)R(\.|)|RURAL\s{0,}(ROUTE|RT(\.|)))\s{0,}\d{1,}(,|)\s{1,}\bBOX\s{0,}\d
(assert (str.in_re X (re.++ (re.union (str.to_re "R.R.") (re.++ (str.to_re "RURAL") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "R") (re.union (str.to_re "OUTE") (str.to_re "T.")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "BOX") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (str.to_re "\u{0a}"))))
; /\u{2f}\?ts\u{3d}[a-f0-9]{40}\u{26}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//?ts=") ((_ re.loop 40 40) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "&/Ui\u{0a}")))))
; \x2Fpagead\x2Fads\?waitingisDownload
(assert (not (str.in_re X (str.to_re "/pagead/ads?waitingisDownload\u{0a}"))))
(check-sat)
