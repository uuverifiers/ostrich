(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^[0-9]{2,3}-? ?[0-9]{6,7}$
(assert (str.in_re X (re.++ ((_ re.loop 2 3) (re.range "0" "9")) (re.opt (str.to_re "-")) (re.opt (str.to_re " ")) ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{28}\u{3f}\u{3d}[^)]{300}/
(assert (not (str.in_re X (re.++ (str.to_re "/(?=") ((_ re.loop 300 300) (re.comp (str.to_re ")"))) (str.to_re "/\u{0a}")))))
; /^\/jmx.jar?r=\d+/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//jmx") re.allchar (str.to_re "ja") (re.opt (str.to_re "r")) (str.to_re "r=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
