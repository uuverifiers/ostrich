(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{3f}sv\u{3d}\d{1,3}\u{26}tq\u{3d}/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/?sv=") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re "&tq=/smiU\u{0a}")))))
; /^\u{2f}nosignal\.jpg\?\d\.\d+$/U
(assert (str.in_re X (re.++ (str.to_re "//nosignal.jpg?") (re.range "0" "9") (str.to_re ".") (re.+ (re.range "0" "9")) (str.to_re "/U\u{0a}"))))
(check-sat)
