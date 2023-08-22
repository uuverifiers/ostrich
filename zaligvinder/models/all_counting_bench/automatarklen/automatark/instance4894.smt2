(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((mailto\:|(news|(ht|f)tp(s?))\://){1}\S+)
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 1 1) (re.union (str.to_re "mailto:") (re.++ (re.union (str.to_re "news") (re.++ (re.union (str.to_re "ht") (str.to_re "f")) (str.to_re "tp") (re.opt (str.to_re "s")))) (str.to_re "://")))) (re.+ (re.comp (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))))))
; (\bR(\.|)R(\.|)|RURAL\s{0,}(ROUTE|RT(\.|)))\s{0,}\d{1,}(,|)\s{1,}\bBOX\s{0,}\d
(assert (not (str.in_re X (re.++ (re.union (str.to_re "R.R.") (re.++ (str.to_re "RURAL") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "R") (re.union (str.to_re "OUTE") (str.to_re "T.")))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.range "0" "9")) (str.to_re ",") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "BOX") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.range "0" "9") (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
