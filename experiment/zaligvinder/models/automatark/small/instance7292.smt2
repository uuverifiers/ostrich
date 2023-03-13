(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{20}-\u{7e}\u{0d}\u{0a}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (re.range " " "~") (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "/P\u{0a}"))))
; /filename\=\d+\.swf/H
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.+ (re.range "0" "9")) (str.to_re ".swf/H\u{0a}"))))
; ^04[0-9]{8}
(assert (not (str.in_re X (re.++ (str.to_re "04") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
(check-sat)
