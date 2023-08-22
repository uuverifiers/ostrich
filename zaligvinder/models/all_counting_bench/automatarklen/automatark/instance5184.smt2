(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[a-zA-Z0-9]\/[a-f0-9]{5}\.swf[\u{22}\u{27}]/
(assert (not (str.in_re X (re.++ (str.to_re "/") (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9")) (str.to_re "/") ((_ re.loop 5 5) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re ".swf") (re.union (str.to_re "\u{22}") (str.to_re "'")) (str.to_re "/\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
