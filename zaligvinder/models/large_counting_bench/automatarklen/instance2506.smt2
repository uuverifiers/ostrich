(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([A-Z0-9]{5})$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.union (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}smil/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".smil/i\u{0a}")))))
; /\u{2e}pub([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pub") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; /^[a-z]\u{3d}[a-f\d]{80,140}$/Pi
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.range "a" "z") (str.to_re "=") ((_ re.loop 80 140) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Pi\u{0a}")))))
; (\d*)'*-*(\d*)/*(\d*)"
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (str.to_re "'")) (re.* (str.to_re "-")) (re.* (re.range "0" "9")) (re.* (str.to_re "/")) (re.* (re.range "0" "9")) (str.to_re "\u{22}\u{0a}")))))
(assert (< 200 (str.len X)))
(check-sat)
