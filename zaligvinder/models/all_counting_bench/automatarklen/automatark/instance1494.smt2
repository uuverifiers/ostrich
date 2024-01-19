(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [^0-9]((\(?(\+420|00420)\)?( |-)?)?([0-9]{3} ?(([0-9]{3} ?[0-9]{3})|([0-9]{2} ?[0-9]{2} ?[0-9]{2})))|([0-9]{3}-(([0-9]{3}-[0-9]{3})|([0-9]{2}-[0-9]{2}-[0-9]{2}))))[^0-9|/]
(assert (not (str.in_re X (re.++ (re.range "0" "9") (re.union (re.++ (re.opt (re.++ (re.opt (str.to_re "(")) (re.union (str.to_re "+420") (str.to_re "00420")) (re.opt (str.to_re ")")) (re.opt (re.union (str.to_re " ") (str.to_re "-"))))) ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (str.to_re " ")) ((_ re.loop 2 2) (re.range "0" "9"))))) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")))))) (re.union (re.range "0" "9") (str.to_re "|") (str.to_re "/")) (str.to_re "\u{0a}")))))
; ^[a-zA-Z]{4}\d{6}[a-zA-Z]{6}\d{2}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 6 6) (re.range "0" "9")) ((_ re.loop 6 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /\u{2e}hhk([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.hhk") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
