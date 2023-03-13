(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9,+,(), ,]{1,}(,[0-9]+){0,}$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "0" "9") (str.to_re ",") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.++ (str.to_re ",") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; [a-z]{1}[a-z0-9\-_\.]{2,24}@tlen\.pl
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "a" "z")) ((_ re.loop 2 24) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_") (str.to_re "."))) (str.to_re "@tlen.pl\u{0a}"))))
; /filename=[^\n]*\u{2e}fdf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fdf/i\u{0a}")))))
; /filename=[^\n]*\u{2e}xml/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xml/i\u{0a}")))))
(check-sat)
