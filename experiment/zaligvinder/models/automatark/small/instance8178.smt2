(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}vap/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".vap/i\u{0a}"))))
; /filename=[^\n]*\u{2e}f4p/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".f4p/i\u{0a}")))))
; ^([a-zA-Z0-9@*#]{8,15})$
(assert (str.in_re X (re.++ ((_ re.loop 8 15) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "@") (str.to_re "*") (str.to_re "#"))) (str.to_re "\u{0a}"))))
; [\t ]+
(assert (str.in_re X (re.++ (re.+ (re.union (str.to_re "\u{09}") (str.to_re " "))) (str.to_re "\u{0a}"))))
(check-sat)
