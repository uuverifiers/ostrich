(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /User\u{2d}Agent\u{3a}\u{20}[A-F\d]{32}\r\n/H
(assert (str.in_re X (re.++ (str.to_re "/User-Agent: ") ((_ re.loop 32 32) (re.union (re.range "A" "F") (re.range "0" "9"))) (str.to_re "\u{0d}\u{0a}/H\u{0a}"))))
; ^(([0]{0,1})([1-9]{1})([0-9]{2})){1}([\ ]{0,1})((([0-9]{3})([\ ]{0,1})([0-9]{3}))|(([0-9]{2})([\ ]{0,1})([0-9]{2})([\ ]{0,1})([0-9]{2})))$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.++ (re.opt (str.to_re "0")) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "0" "9")))) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; ^[0-9]{5}([- /]?[0-9]{4})?$
(assert (not (str.in_re X (re.++ ((_ re.loop 5 5) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "/"))) ((_ re.loop 4 4) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
(check-sat)
