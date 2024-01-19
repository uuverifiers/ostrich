(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((\(\d{3}\) ?)|(\d{3}[- \.]))?\d{3}[- \.]\d{4}(\s(x\d+)?){0,1}$
(assert (not (str.in_re X (re.++ (re.opt (re.union (re.++ (str.to_re "(") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ")") (re.opt (str.to_re " "))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re "."))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.union (str.to_re "-") (str.to_re " ") (str.to_re ".")) ((_ re.loop 4 4) (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.opt (re.++ (str.to_re "x") (re.+ (re.range "0" "9")))))) (str.to_re "\u{0a}")))))
; /\u{2e}pfm([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.pfm") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; /filename=[^\n]*\u{2e}doc/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".doc/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
