(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}m4a/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".m4a/i\u{0a}")))))
; ^((\(\d{3}\) ?)|(\d{3}-)|(\(\d{2}\) ?)|(\d{2}-)|(\(\d{1}\) ?)|(\d{1}-))?\d{3}-(\d{3}|\d{4})
(assert (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-")) (re.++ (str.to_re "(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-")) (re.++ (str.to_re "(") ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "-")))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; User-Agent\x3A\s+Host\x3A[^\n\r]*Hourspjpoptwql\u{2f}rlnjFrom\x3Asbver\u{3a}Ghost
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Hourspjpoptwql/rlnjFrom:sbver:Ghost\u{13}\u{0a}")))))
(check-sat)
